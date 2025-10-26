(require 'project)
(require 'cl-extra)
(require 'flycheck)

(defun fp-lean-zh--wrap (start end)
  (if (use-region-p)
      (progn (save-excursion
               (goto-char (region-beginning))
               (beginning-of-line)
               (unless (looking-at-p "^$")
                 (newline))
               (insert start)
               (newline))
             (goto-char (region-end))
             (unless (looking-at-p "^$")
               (end-of-line)
               (newline))
             (insert end))
    (end-of-line)
    (unless (looking-at-p "^$")
      (newline))
    (insert start)
    (newline)
    (insert end)
    (save-excursion (newline))
    (beginning-of-line)
    (save-excursion (newline))))

(defun fp-lean-zh--flycheck-overlay-info (overlay)
  "Return the Flycheck info from OVERLAY, or nil if none."
  (overlay-get overlay 'flycheck-error))

(defun fp-lean-zh--flycheck-message-at (where)
  "Get the Flycheck message at WHERE, returning nil if none."
  (let ((info (cl-some #'fp-lean-zh--flycheck-overlay-info (overlays-at where))))
    (if info (flycheck-error-message info) nil)))

(defun fp-lean-zh--flycheck-messages-in (beg end)
  "Get the Flycheck messages between BEG and END."
  (cl-loop for overlay in (overlays-in beg end)
           for info = (fp-lean-zh--flycheck-overlay-info overlay)
           when info
           collect (flycheck-error-message info)))

(defun fp-lean-zh--arbitrary-flycheck-message ()
  "Select an arbitrary Flycheck message from the region if it's active."
  (let ((arbitrary-message
         (if (use-region-p)
             (car (fp-lean-zh--flycheck-messages-in (region-beginning) (region-end)))
           nil)))
    (or arbitrary-message "")))

(defun fp-lean-zh-save-arbitrary-flycheck-message-to-kill-ring ()
  "Add an arbitrary Flycheck message from the active region or around point to the kill ring."
  (interactive)
  (let ((arbitrary-message
         (if (use-region-p)
             (car (fp-lean-zh--flycheck-messages-in (region-beginning) (region-end)))
           (car (fp-lean-zh--flycheck-messages-in (point) (point))))))
    (if arbitrary-message
        (kill-new arbitrary-message)
      (error "No Flycheck output found here"))))


(defun fp-lean-zh--escape (string)
  "Escape STRING for Lean."
  (replace-regexp-in-string
   "\""
   "\\\""
   (replace-regexp-in-string "\\\\" "\\\\" string nil 'literal)
   nil
   'literal))

(defun fp-lean-zh-decl (name)
  "Use a book declaration called NAME."
  (interactive "MName: ")
  (fp-lean-zh--wrap (format "book declaration {{{ %s }}}" name) "stop book declaration"))

(defun fp-lean-zh-info (name)
  "Expect info named NAME."
  (interactive "MName: ")
  (let ((msg (fp-lean-zh--escape (fp-lean-zh--arbitrary-flycheck-message))))
   (fp-lean-zh--wrap (format "expect info {{{ %s }}}" name)
                  (format "message\n\"%s\"\nend expect" msg))))

(defun fp-lean-zh-error (name)
  "Expect error named NAME."
  (interactive "MName: ")
  (let ((msg (fp-lean-zh--escape (fp-lean-zh--arbitrary-flycheck-message))))
    (fp-lean-zh--wrap
     (format "expect error {{{ %s }}}" name)
     (format "message\n\"%s\"\nend expect" msg))))

(defun fp-lean-zh-warning (name)
  "Expect warning named NAME."
  (interactive "MName: ")
  (let ((msg (fp-lean-zh--escape (fp-lean-zh--arbitrary-flycheck-message))))
    (fp-lean-zh--wrap
     (format "expect warning {{{ %s }}}" name)
     (format "message\n\"%s\"\nend expect" msg))))

(defun fp-lean-zh-eval (name)
  "Evaluation steps named NAME."
  (interactive "MName: ")
  (fp-lean-zh--wrap (format "evaluation steps {{{ %s }}}" name) "end evaluation steps"))

(defun fp-lean-zh-example (name)
  "Book example named NAME."
  (interactive "MName: ")
  (fp-lean-zh--wrap (format "bookExample {{{ %s }}}" name) "end bookExample"))

(defun fp-lean-zh-example-type (name)
  "Book example for type named NAME."
  (interactive "MName: ")
  (fp-lean-zh--wrap (format "bookExample type {{{ %s }}}" name) "end bookExample"))


(defun fp-lean-zh-code ()
  (interactive)
  (fp-lean-zh--wrap "```lean" "```"))

(defun fp-lean-zh-output-info ()
  (interactive)
  (fp-lean-zh--wrap "```output info" "```"))

(defun fp-lean-zh-output-error ()
  (interactive)
  (fp-lean-zh--wrap "```output error" "```"))


(defvar-local fp-lean-zh--current-file nil)

(defun fp-lean-zh--examples-dir ()
  "Get the root of the examples."
  (file-name-as-directory (concat (file-name-as-directory (project-root (project-current))) "examples")))

(defun fp-lean-zh--mdbook-dir ()
  "Get the root of the mdbook project."
  (file-name-as-directory
   (concat (file-name-as-directory (project-root (project-current)))
           "functional-programming-lean")))

(defun fp-lean-zh--make-file-examples-relative (filename)
  "Make a FILENAME be relative to the Lean examples for the book."
  (file-relative-name (expand-file-name filename) (fp-lean-zh--examples-dir)))

(defun fp-lean-zh-get-file ()
  "Get the examples filename to use, defaulting to the last one."
  (let ((default-directory (fp-lean-zh--examples-dir)))
    (expand-file-name
     (read-file-name
      (if fp-lean-zh--current-file
          (format "File (%s): " fp-lean-zh--current-file)
        "File: ")
      (fp-lean-zh--examples-dir)
      (and fp-lean-zh--current-file (fp-lean-zh--make-file-examples-relative fp-lean-zh--current-file))
      'confirm
      (and fp-lean-zh--current-file (fp-lean-zh--make-file-examples-relative fp-lean-zh--current-file))
      (lambda (f)
        (and
         (or (file-directory-p f)
             (string= (file-name-extension f) "lean"))
         (not (string-suffix-p "~" f))))))))

(defun fp-lean-zh-name-from-file (filename)
  "Get a name of a defined thing from FILENAME."
  (completing-read "Name: "
                   (with-temp-buffer
                     (insert-file-contents filename)
                     (let ((results (list)))
                       (goto-char (point-min))
                       (while (re-search-forward "{{{\s*\\([^\s]+\\)\s*}}}" nil t nil)
                         (push (match-string 1) results))
                       results))
                   nil nil nil nil nil t))

(defun fp-lean-zh-get-file-and-name ()
  "Read an examples file and a named anchor from it."
  (let ((file (fp-lean-zh-get-file)))
    (list (fp-lean-zh--make-file-examples-relative file)
          (fp-lean-zh-name-from-file file))))

(defun fp-lean-zh-text-decl (file name)
  "Insert a declaration from FILE called NAME."
  (interactive (fp-lean-zh-get-file-and-name))
  (setq fp-lean-zh--current-file file)
  (insert (format "{{#example_decl %s %s}}" file name)))

(defun fp-lean-zh-text-equations (file name)
  "Insert equations from FILE called NAME."
  (interactive (fp-lean-zh-get-file-and-name))
  (setq fp-lean-zh--current-file file)
  (insert (format "{{#equations %s %s}}" file name)))

(defun fp-lean-zh-text-example (file name)
  "Insert a declaration from FILE called NAME."
  (interactive (fp-lean-zh-get-file-and-name))
  (setq fp-lean-zh--current-file file)
  (insert (format "{{#example_in %s %s}}" file name))
  (insert (format "{{#example_out %s %s}}" file name)))

(defun fp-lean-zh-text-interaction (file name)
  "Insert an example interaction from FILE called NAME."
  (interactive (fp-lean-zh-get-file-and-name))
  (setq fp-lean-zh--current-file file)
  (insert "```lean")
  (newline)
  (insert (format "{{#example_in %s %s}}" file name))
  (newline)
  (insert "```\n```output info")
  (newline)
  (insert (format "{{#example_out %s %s}}" file name))
  (newline)
  (insert "```"))

(defun fp-lean-zh-text-error (file name)
  "Insert an error example from FILE called NAME."
  (interactive (fp-lean-zh-get-file-and-name))
  (setq fp-lean-zh--current-file file)
  (insert "```lean")
  (newline)
  (insert (format "{{#example_in %s %s}}" file name))
  (newline)
  (insert "```\n```output error")
  (newline)
  (insert (format "{{#example_out %s %s}}" file name))
  (newline)
  (insert "```"))

(defvar fp-lean-zh-process nil
  "Process under which the book is being served (to avoid duplication).")

(defun fp-lean-zh-serve-book ()
  "Start or restart the server."
  (interactive)
  (let ((buffer (if (processp fp-lean-zh-process)
                    (process-buffer fp-lean-zh-process)
                  "*fp-lean-zh-Server*")))
    (when fp-lean-zh-process
      (when (processp fp-lean-zh-process)
        (let ((buf (process-buffer fp-lean-zh-process)))
          (when (and buf (buffer-live-p buf))
            (with-current-buffer buf
              (goto-char (point-max))
              (insert "\n")
              (insert (format-time-string "%Y-%m-%d %H:%M:%S - Process killed" (current-time))))))
        (kill-process fp-lean-zh-process))
      (setq fp-lean-zh-process nil))
    (let* ((default-directory (fp-lean-zh--mdbook-dir)))
      (setq fp-lean-zh-process (start-process "Lean book server" buffer "mdbook" "serve"))
      (message "Lean book server running in buffer %s" (buffer-name (process-buffer fp-lean-zh-process))))))

(defun fp-lean-zh-ensure-server ()
   "Ensure a server is running."
  (interactive)
  (unless (and fp-lean-zh-process
               (processp fp-lean-zh-process)
               (process-live-p fp-lean-zh-process))
    (fp-lean-zh-serve-book)))

(defun fp-lean-zh-browse-book ()
  "Open the book."
  (interactive)
  (fp-lean-zh-ensure-server)
  (browse-url "localhost:3000"))

(defun fp-lean-zh-text-link (md-file)
  "Insert a link to another chapter or section in MD-FILE."
  (interactive
   (list (read-file-name "Markdown file: " nil nil 'confirm)))
  (insert "[")
  (save-excursion
    (insert "](")
    (insert (file-relative-name md-file))
    (insert ")")))

;;; book-support.el ends here
