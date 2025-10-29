import VersoManual
import FPLeanZh

open Verso.Genre Manual
open Verso Code External

open Verso.Output.Html in
def plausible := {{
    <script defer="defer" data-domain="lean-lang.org" src="https://plausible.io/js/script.outbound-links.js"></script>
  }}


open Verso.Output.Html in
def darkModeScript := {{
    <script>
    (function() {
      try {
        var storageKey = 'theme';
        var root = document.documentElement;
        var mql = window.matchMedia('(prefers-color-scheme: dark)');
        var saved = localStorage.getItem(storageKey);
        function apply(theme) {
          if (theme === 'dark' || theme === 'light') {
            root.setAttribute('data-theme', theme);
          } else {
            root.removeAttribute('data-theme');
          }
        }
        if (saved === 'dark' || saved === 'light') { apply(saved); } else { apply(null); }
        window.__toggleTheme = function() {
          var current = root.getAttribute('data-theme');
          var next = current === 'dark' ? 'light' : (current === 'light' ? null : 'dark');
          if (next) { localStorage.setItem(storageKey, next); } else { localStorage.removeItem(storageKey); }
          apply(next);
        };
        document.addEventListener('DOMContentLoaded', function() {
          var btn = document.createElement('button');
          btn.className = 'theme-toggle';
          btn.type = 'button';
          btn.setAttribute('aria-label', 'Toggle theme');
          function label() {
            var t = root.getAttribute('data-theme');
            if (t === 'dark') return 'Light';
            if (t === 'light') return 'Auto';
            return 'Dark';
          }
          btn.textContent = label();
          btn.addEventListener('click', function() { window.__toggleTheme(); btn.textContent = label(); });
          document.body.appendChild(btn);
        });
        if (mql && mql.addEventListener) {
          mql.addEventListener('change', function() {
            var s = localStorage.getItem(storageKey);
            if (!s) { apply(null); }
          });
        }
      } catch (e) { /* ignore */ }
    })();
    </script>
  }}


def config : Config where
  emitTeX := false
  emitHtmlSingle := false
  emitHtmlMulti := true
  htmlDepth := 2
  extraFiles := [("static", "static")]
  extraCss := [
    "/static/theme.css",
    "/static/fonts/source-serif/source-serif-text.css",
    "/static/fonts/source-code-pro/source-code-pro.css",
    "/static/fonts/source-sans/source-sans-3.css",
    "/static/fonts/noto-sans-mono/noto-sans-mono.css"
  ]
  extraHead := #[plausible, darkModeScript]
  logo := some "/static/lean_logo.svg"
  sourceLink := some "https://github.com/subfish-zhou/fp-lean-zh"
  issueLink := some "https://github.com/subfish-zhou/fp-lean-zh/issues"
  linkTargets := fun st => st.localTargets ++ st.remoteTargets
def main := manualMain (%doc FPLeanZh) (config := config.addKaTeX)
