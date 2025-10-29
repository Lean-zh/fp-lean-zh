import VersoManual
import FPLeanZh.Examples


open Verso.Genre Manual
open Verso Code External

open FPLeanZh

set_option verso.exampleProject "../examples"

set_option verso.exampleModule "FelineLib"

example_module Examples.Cat

-- Worked Example: {lit}`cat`
#doc (Manual) "实例：{lit}`cat`" =>
%%%
file := "Cat"
tag := "example-cat"
%%%

-- The standard Unix utility {lit}`cat` takes a number of command-line options, followed by zero or more input files.
-- If no files are provided, or if one of them is a dash ({lit}`-`), then it takes the standard input as the corresponding input instead of reading a file.
-- The contents of the inputs are written, one after the other, to the standard output.
-- If a specified input file does not exist, this is noted on standard error, but {lit}`cat` continues concatenating the remaining inputs.
-- A non-zero exit code is returned if any of the input files do not exist.

标准的 Unix 实用程序 {lit}`cat` 接受多个命令行选项，后跟零个或多个输入文件。
如果没有提供文件，或者其中一个是短划线（{lit}`-`），那么它将标准输入作为相应的输入，而不是读取文件。
输入的内容会一个接一个地写入标准输出。
如果指定的输入文件不存在，这会在标准错误上注明，但 {lit}`cat` 会继续连接剩余的输入。
如果任何输入文件不存在，则返回非零退出代码。

-- This section describes a simplified version of {lit}`cat`, called {lit}`feline`.
-- Unlike commonly-used versions of {lit}`cat`, {lit}`feline` has no command-line options for features such as numbering lines, indicating non-printing characters, or displaying help text.
-- Furthermore, it cannot read more than once from a standard input that's associated with a terminal device.

本节描述了 {lit}`cat` 的简化版本，称为 {lit}`feline`。
与常用的 {lit}`cat` 版本不同，{lit}`feline` 没有用于编号行、指示非打印字符或显示帮助文本等功能的命令行选项。
此外，它无法从与终端设备关联的标准输入中读取多次。

-- To get the most benefit from this section, follow along yourself.
-- It's OK to copy-paste the code examples, but it's even better to type them in by hand.
-- This makes it easier to learn the mechanical process of typing in code, recovering from mistakes, and interpreting feedback from the compiler.

要充分学习本节内容，请自己动手操作。复制粘贴代码示例是可以的，但最好手动输入它们。这使得学习输入代码、从错误中恢复以及解释编译器反馈的机械过程变得更加容易。

-- # Getting Started
# 开始
%%%
tag := "example-cat-start"
%%%

-- The first step in implementing {lit}`feline` is to create a package and decide how to organize the code.
-- In this case, because the program is so simple, all the code will be placed in {lit}`Main.lean`.
-- The first step is to run {lit}`lake new feline`.
-- Edit the Lakefile to remove the library, and delete the generated library code and the reference to it from {lit}`Main.lean`.
-- Once this has been done, {lit}`lakefile.toml` should contain:

实现 {lit}`feline` 的第一步是创建一个包并决定如何组织代码。
在这种情况下，因为程序非常简单，所有代码都将放在 {lit}`Main.lean` 中。
第一步是运行 {lit}`lake new feline`。
编辑 Lakefile 以删除库，并删除生成的库代码和从 {lit}`Main.lean` 中对它的引用。
完成这些后，{lit}`lakefile.toml` 应该包含：

```plainFile "feline/1/lakefile.toml"
name = "feline"
version = "0.1.0"
defaultTargets = ["feline"]

[[lean_exe]]
name = "feline"
root = "Main"
```

-- and {lit}`Main.lean` should contain something like:
{lit}`Main.lean` 应该包含类似的内容：
```plainFile "feline/1/Main.lean"
def main : IO Unit :=
  IO.println s!"Hello, cats!"
```
-- Alternatively, running {lit}`lake new feline exe` instructs {lit}`lake` to use a template that does not include a library section, making it unnecessary to edit the file.

或者，运行 {lit}`lake new feline exe` 指示 {lit}`lake` 使用不包含库部分的模板，使得无需编辑文件。

-- Ensure that the code can be built by running {command feline1 "feline/1"}`lake build`.

通过运行 {command feline1 "feline/1"}`lake build` 确保代码可以构建。

-- # Concatenating Streams
# 连接流
%%%
tag := "example-cat-streams"
%%%

-- Now that the basic skeleton of the program has been built, it's time to actually enter the code.
-- A proper implementation of {lit}`cat` can be used with infinite IO streams, such as {lit}`/dev/random`, which means that it can't read its input into memory before outputting it.
-- Furthermore, it should not work one character at a time, as this leads to frustratingly slow performance.
-- Instead, it's better to read contiguous blocks of data all at once, directing the data to the standard output one block at a time.

现在已经构建了程序的基本骨架，是时候实际输入代码了。
{lit}`cat` 的正确实现可以用于无限的 IO 流，例如 {lit}`/dev/random`，这意味着它不能在输出之前将其输入读入内存。
此外，它不应该一次只处理一个字符，因为这会导致令人沮丧的慢速性能。
相反，最好一次读取连续的数据块，一次将数据一个块地导向标准输出。

-- The first step is to decide how big of a block to read.
-- For the sake of simplicity, this implementation uses a conservative 20 kilobyte block.
-- {anchorName bufsize}`USize` is analogous to {c}`size_t` in C—it's an unsigned integer type that is big enough to represent all valid array sizes.

第一步是决定要读取多大的块。
为了简单起见，这个实现使用保守的 20 KB 块。
{anchorName bufsize}`USize` 类似于 C 中的 {c}`size_t`——它是一个无符号整数类型，足够大以表示所有有效的数组大小。
```module (anchor:=bufsize)
def bufsize : USize := 20 * 1024
```

-- ## Streams
## 流
%%%
tag := "streams"
%%%

-- The main work of {lit}`feline` is done by {anchorName dump}`dump`, which reads input one block at a time, dumping the result to standard output, until the end of the input has been reached.
-- The end of the input is indicated by {anchorName dump}`read` returning an empty byte array:

{lit}`feline` 的主要工作由 {anchorName dump}`dump` 完成，它一次读取一个块的输入，将结果转储到标准输出，直到到达输入的末尾。
输入的结束由 {anchorName dump}`read` 返回空字节数组表示：
```module (anchor:=dump)
partial def dump (stream : IO.FS.Stream) : IO Unit := do
  let buf ← stream.read bufsize
  if buf.isEmpty then
    pure ()
  else
    let stdout ← IO.getStdout
    stdout.write buf
    dump stream
```

-- The {anchorName dump}`dump` function is declared {anchorTerm dump}`partial`, because it calls itself recursively on input that is not immediately smaller than an argument.
-- When a function is declared to be partial, Lean does not require a proof that it terminates.
-- On the other hand, partial functions are also much less amenable to proofs of correctness, because allowing infinite loops in Lean's logic would make it unsound.
-- However, there is no way to prove that {anchorName dump}`dump` terminates, because infinite input (such as from {lit}`/dev/random`) would mean that it does not, in fact, terminate.
-- In cases like this, there is no alternative to declaring the function {anchorTerm dump}`partial`.

{anchorName dump}`dump` 函数被声明为 {anchorTerm dump}`partial`，因为它在不是立即小于参数的输入上递归调用自身。
当函数被声明为部分函数时，Lean 不要求证明它终止。
另一方面，部分函数也远不如正确性证明那样易于处理，因为在 Lean 的逻辑中允许无限循环会使其不健全。
然而，没有办法证明 {anchorName dump}`dump` 终止，因为无限输入（例如来自 {lit}`/dev/random`）意味着它实际上不会终止。
在这种情况下，没有其他选择只能将函数声明为 {anchorTerm dump}`partial`。

-- The type {anchorName dump}`IO.FS.Stream` represents a POSIX stream.
-- Behind the scenes, it is represented as a structure that has one field for each POSIX stream operation.
-- Each operation is represented as an IO action that provides the corresponding operation:

类型 {anchorName dump}`IO.FS.Stream` 表示 POSIX 流。
在幕后，它表示为一个结构，该结构为每个 POSIX 流操作都有一个字段。
每个操作都表示为提供相应操作的 IO 动作：

```anchor Stream (module := Examples.Cat)
structure Stream where
  flush   : IO Unit
  read    : USize → IO ByteArray
  write   : ByteArray → IO Unit
  getLine : IO String
  putStr  : String → IO Unit
  isTty   : BaseIO Bool
```

-- The type {anchorName Stream (module:=Examples.Cat)}`BaseIO` is a variant of {anchorName Stream (module:=Examples.Cat)}`IO` that rules out run-time errors.
-- The Lean compiler contains {anchorName Stream (module:=Examples.Cat)}`IO` actions (such as {anchorName dump}`IO.getStdout`, which is called in {anchorName dump}`dump`) to get streams that represent standard input, standard output, and standard error.
-- These are {anchorName Stream (module:=Examples.Cat)}`IO` actions rather than ordinary definitions because Lean allows these standard POSIX streams to be replaced in a process, which makes it easier to do things like capturing the output from a program into a string by writing a custom {anchorName dump}`IO.FS.Stream`.

类型 {anchorName Stream (module:=Examples.Cat)}`BaseIO` 是 {anchorName Stream (module:=Examples.Cat)}`IO` 的变体，排除了运行时错误。
Lean 编译器包含 {anchorName Stream (module:=Examples.Cat)}`IO` 动作（例如在 {anchorName dump}`dump` 中调用的 {anchorName dump}`IO.getStdout`）来获取表示标准输入、标准输出和标准错误的流。
这些是 {anchorName Stream (module:=Examples.Cat)}`IO` 动作而不是普通定义，因为 Lean 允许在进程中替换这些标准 POSIX 流，这使得通过编写自定义的 {anchorName dump}`IO.FS.Stream` 来捕获程序输出到字符串等操作变得更容易。

-- The control flow in {anchorName dump}`dump` is essentially a {lit}`while` loop.
-- When {anchorName dump}`dump` is called, if the stream has reached the end of the file, {anchorTerm dump}`pure ()` terminates the function by returning the constructor for {anchorName dump}`Unit`.
-- If the stream has not yet reached the end of the file, one block is read, and its contents are written to {anchorName dump}`stdout`, after which {anchorName dump}`dump` calls itself directly.
-- The recursive calls continue until {anchorTerm dump}`stream.read` returns an empty byte array, which indicates the end of the file.

{anchorName dump}`dump` 中的控制流本质上是一个 {lit}`while` 循环。
当调用 {anchorName dump}`dump` 时，如果流已到达文件末尾，{anchorTerm dump}`pure ()` 通过返回 {anchorName dump}`Unit` 的构造函数来终止函数。
如果流尚未到达文件末尾，则读取一个块，其内容被写入 {anchorName dump}`stdout`，之后 {anchorName dump}`dump` 直接调用自身。
递归调用继续，直到 {anchorTerm dump}`stream.read` 返回空字节数组，这表示文件结束。

-- When an {kw}`if` expression occurs as a statement in a {kw}`do`, as in {anchorName dump}`dump`, each branch of the {kw}`if` is implicitly provided with a {kw}`do`.
-- In other words, the sequence of steps following the {kw}`else` are treated as a sequence of {anchorName dump}`IO` actions to be executed, just as if they had a {kw}`do` at the beginning.
-- Names introduced with {kw}`let` in the branches of the {kw}`if` are visible only in their own branches, and are not in scope outside of the {kw}`if`.

当 {kw}`if` 表达式作为 {kw}`do` 中的语句出现时，如在 {anchorName dump}`dump` 中，{kw}`if` 的每个分支都被隐式提供一个 {kw}`do`。
换句话说，{kw}`else` 后面的步骤序列被视为要执行的 {anchorName dump}`IO` 动作序列，就像它们在开头有一个 {kw}`do` 一样。
在 {kw}`if` 分支中用 {kw}`let` 引入的名称只在其自己的分支中可见，在 {kw}`if` 外部不在作用域内。

-- There is no danger of running out of stack space while calling {anchorName dump}`dump` because the recursive call happens as the very last step in the function, and its result is returned directly rather than being manipulated or computed with.
-- This kind of recursion is called _tail recursion_, and it is described in more detail {ref "tail-recursion"}[later in this book].
-- Because the compiled code does not need to retain any state, the Lean compiler can compile the recursive call to a jump.

调用 {anchorName dump}`dump` 时不会有耗尽堆栈空间的危险，因为递归调用作为函数的最后一步发生，其结果直接返回而不是被操作或计算。
这种递归被称为*尾递归*，在 *本书后面* 有更详细的描述。
由于编译的代码不需要保留任何状态，Lean 编译器可以将递归调用编译为跳转。

-- If {lit}`feline` only redirected standard input to standard output, then {anchorName dump}`dump` would be sufficient.
-- However, it also needs to be able to open files that are provided as command-line arguments and emit their contents.
-- When its argument is the name of a file that exists, {anchorName fileStream}`fileStream` returns a stream that reads the file's contents.
-- When the argument is not a file, {anchorName fileStream}`fileStream` emits an error and returns {anchorName fileStream}`none`.

如果 {lit}`feline` 只是将标准输入重定向到标准输出，那么 {anchorName dump}`dump` 就足够了。
但是，它还需要能够打开作为命令行参数提供的文件并输出其内容。
当其参数是存在的文件名时，{anchorName fileStream}`fileStream` 返回读取文件内容的流。
当参数不是文件时，{anchorName fileStream}`fileStream` 发出错误并返回 {anchorName fileStream}`none`。
```module (anchor:=fileStream)
def fileStream (filename : System.FilePath) : IO (Option IO.FS.Stream) := do
  let fileExists ← filename.pathExists
  if not fileExists then
    let stderr ← IO.getStderr
    stderr.putStrLn s!"File not found: {filename}"
    pure none
  else
    let handle ← IO.FS.Handle.mk filename IO.FS.Mode.read
    pure (some (IO.FS.Stream.ofHandle handle))
```

-- Opening a file as a stream takes two steps.
-- First, a file handle is created by opening the file in read mode.
-- A Lean file handle tracks an underlying file descriptor.
-- When there are no references to the file handle value, a finalizer closes the file descriptor.
-- Second, the file handle is given the same interface as a POSIX stream using {anchorName fileStream}`IO.FS.Stream.ofHandle`, which fills each field of the {anchorName Names}`Stream` structure with the corresponding {anchorName fileStream}`IO` action that works on file handles.

将文件作为流打开需要两个步骤。
首先，通过在读取模式下打开文件来创建文件句柄。
Lean 文件句柄跟踪底层文件描述符。
当没有对文件句柄值的引用时，终结器会关闭文件描述符。
其次，使用 {anchorName fileStream}`IO.FS.Stream.ofHandle` 给文件句柄提供与 POSIX 流相同的接口，它用在文件句柄上工作的相应 {anchorName fileStream}`IO` 动作填充 {anchorName Names}`Stream` 结构的每个字段。

-- ## Handling Input
## 处理输入
%%%
tag := "handling-input"
%%%

-- The main loop of {lit}`feline` is another tail-recursive function, called {anchorName process}`process`.
-- In order to return a non-zero exit code if any of the inputs could not be read, {anchorName process}`process` takes an argument {anchorName process}`exitCode` that represents the current exit code for the whole program.
-- Additionally, it takes a list of input files to be processed.

{lit}`feline` 的主循环是另一个尾递归函数，称为 {anchorName process}`process`。
为了在任何输入无法读取时返回非零退出代码，{anchorName process}`process` 接受一个参数 {anchorName process}`exitCode`，它表示整个程序的当前退出代码。
此外，它还接受要处理的输入文件列表。
```module (anchor:=process)
def process (exitCode : UInt32) (args : List String) : IO UInt32 := do
  match args with
  | [] => pure exitCode
  | "-" :: args =>
    let stdin ← IO.getStdin
    dump stdin
    process exitCode args
  | filename :: args =>
    let stream ← fileStream ⟨filename⟩
    match stream with
    | none =>
      process 1 args
    | some stream =>
      dump stream
      process exitCode args
```

-- Just as with {kw}`if`, each branch of a {kw}`match` that is used as a statement in a {kw}`do` is implicitly provided with its own {kw}`do`.

就像 {kw}`if` 一样，用作 {kw}`do` 中语句的 {kw}`match` 的每个分支都被隐式提供其自己的 {kw}`do`。

-- There are three possibilities.
-- One is that no more files remain to be processed, in which case {anchorName process}`process` returns the error code unchanged.
-- Another is that the specified filename is {anchorTerm process}`"-"`, in which case {anchorName process}`process` dumps the contents of the standard input and then processes the remaining filenames.
-- The final possibility is that an actual filename was specified.
-- In this case, {anchorName process}`fileStream` is used to attempt to open the file as a POSIX stream.
-- Its argument is encased in {lit}`⟨ ... ⟩` because a {anchorName Names}`FilePath` is a single-field structure that contains a string.
-- If the file could not be opened, it is skipped, and the recursive call to {anchorName process}`process` sets the exit code to {anchorTerm process}`1`.
-- If it could, then it is dumped, and the recursive call to {anchorName process}`process` leaves the exit code unchanged.

有三种可能性。
一种是没有更多文件需要处理，在这种情况下 {anchorName process}`process` 返回错误代码不变。
另一种是指定的文件名是 {anchorTerm process}`"-"`，在这种情况下 {anchorName process}`process` 转储标准输入的内容，然后处理剩余的文件名。
最后一种可能性是指定了实际的文件名。
在这种情况下，使用 {anchorName process}`fileStream` 尝试将文件作为 POSIX 流打开。
其参数被封装在 {lit}`⟨ ... ⟩` 中，因为 {anchorName Names}`FilePath` 是包含字符串的单字段结构。
如果文件无法打开，它会被跳过，对 {anchorName process}`process` 的递归调用将退出代码设置为 {anchorTerm process}`1`。
如果可以，则转储它，对 {anchorName process}`process` 的递归调用保持退出代码不变。

-- {anchorName process}`process` does not need to be marked {kw}`partial` because it is structurally recursive.
-- Each recursive call is provided with the tail of the input list, and all Lean lists are finite.
-- Thus, {anchorName process}`process` does not introduce any non-termination.

{anchorName process}`process` 不需要标记为 {kw}`partial`，因为它是结构递归的。
每个递归调用都提供输入列表的尾部，所有 Lean 列表都是有限的。
因此，{anchorName process}`process` 不会引入任何非终止性。

-- ## Main
## Main
%%%
tag := "example-cat-main"
%%%

-- The final step is to write the {anchorName main}`main` action.
-- Unlike prior examples, {anchorName main}`main` in {lit}`feline` is a function.
-- In Lean, {anchorName main}`main` can have one of three types:
-- * {anchorTerm Names}`main : IO Unit` corresponds to programs that cannot read their command-line arguments and always indicate success with an exit code of {anchorTerm Names}`0`,
-- * {anchorTerm Names}`main : IO UInt32` corresponds to {c}`int main(void)` in C, for programs without arguments that return exit codes, and
-- * {anchorTerm Names}`main : List String → IO UInt32` corresponds to {c}`int main(int argc, char **argv)` in C, for programs that take arguments and signal success or failure.

最后一步是编写 {anchorName main}`main` 动作。
与先前的示例不同，{lit}`feline` 中的 {anchorName main}`main` 是一个函数。
在 Lean 中，{anchorName main}`main` 可以有三种类型之一：
 * {anchorTerm Names}`main : IO Unit` 对应于无法读取命令行参数且始终以退出代码 {anchorTerm Names}`0` 表示成功的程序，
 * {anchorTerm Names}`main : IO UInt32` 对应于 C 中的 {c}`int main(void)`，用于没有参数但返回退出代码的程序，以及
 * {anchorTerm Names}`main : List String → IO UInt32` 对应于 C 中的 {c}`int main(int argc, char **argv)`，用于接受参数并发出成功或失败信号的程序。

-- If no arguments were provided, {lit}`feline` should read from standard input as if it were called with a single {anchorTerm main}`"-"` argument.
-- Otherwise, the arguments should be processed one after the other.

如果没有提供参数，{lit}`feline` 应该从标准输入读取，就像使用单个 {anchorTerm main}`"-"` 参数调用一样。
否则，参数应该一个接一个地处理。
```module (anchor:=main)
def main (args : List String) : IO UInt32 :=
  match args with
  | [] => process 0 ["-"]
  | _ =>  process 0 args
```

-- # Meow!
# 喵！
%%%
tag := "example-cat-running"
%%%

-- To check whether {lit}`feline` works, the first step is to build it with {command feline2 "feline/2"}`lake build`.
-- First off, when called without arguments, it should emit what it receives from standard input.
-- Check that

要检查 {lit}`feline` 是否工作，第一步是使用 {command feline2 "feline/2"}`lake build` 构建它。
首先，当不带参数调用时，它应该输出从标准输入接收的内容。
检查
```command feline2 "feline/2" (shell := true)
echo "It works!" | lake exe feline
```
-- emits {commandOut feline2}`echo "It works!" | lake exe feline`.

输出 {commandOut feline2}`echo "It works!" | lake exe feline`。

-- Secondly, when called with files as arguments, it should print them.
-- If the file {lit}`test1.txt` contains

其次，当使用文件作为参数调用时，它应该打印它们。
如果文件 {lit}`test1.txt` 包含
```plainFile "feline/2/test1.txt"
It's time to find a warm spot
```

-- and {lit}`test2.txt` contains
{lit}`test2.txt` 包含
```plainFile "feline/2/test2.txt"
and curl up!
```

-- then the command

那么命令

{command feline2 "feline/2" "lake exe feline test1.txt test2.txt"}

-- should emit
应该输出
```commandOut feline2 "lake exe feline test1.txt test2.txt"
It's time to find a warm spot
and curl up!
```

-- Finally, the {lit}`-` argument should be handled appropriately.
最后，{lit}`-` 参数应该被适当处理。
```command feline2 "feline/2" (shell := true)
echo "and purr" | lake exe feline test1.txt - test2.txt
```

-- should yield
应该产生
```commandOut feline2 "echo \"and purr\" | lake exe feline test1.txt - test2.txt"
It's time to find a warm spot
and purr
and curl up!
```

-- # Exercise
# 练习
%%%
tag := "example-cat-exercise"
%%%

-- Extend {lit}`feline` with support for usage information.
-- The extended version should accept a command-line argument {lit}`--help` that causes documentation about the available command-line options to be written to standard output.

扩展 {lit}`feline` 使其支持用法信息。扩展版本应接受命令行参数 {lit}`--help`，产生关于可用命令行选项的文档并写入到标准输出。
