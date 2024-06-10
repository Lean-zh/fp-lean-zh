<!--
# Worked Example: `cat`
-->

# 现实示例 `cat`

<!--
The standard Unix utility `cat` takes a number of command-line options, followed by zero or more input files.
If no files are provided, or if one of them is a dash (`-`), then it takes the standard input as the corresponding input instead of reading a file.
The contents of the inputs are written, one after the other, to the standard output.
If a specified input file does not exist, this is noted on standard error, but `cat` continues concatenating the remaining inputs.
A non-zero exit code is returned if any of the input files do not exist.
-->

标准 Unix 实用程序 `cat` 接受多个命令行选项，后跟零个或多个输入文件。
如果没有提供文件，或者其中一个文件是横线（`-`），则它将标准输入作为相应的输入，而不是读取文件。
输入的内容将按顺序写入标准输出。如果指定的输入文件不存在，则会在标准错误中注明，
但 `cat` 会继续连接剩余的输入。如果任何输入文件不存在，则返回非零退出代码。

<!--
This section describes a simplified version of `cat`, called `feline`.
Unlike commonly-used versions of `cat`, `feline` has no command-line options for features such as numbering lines, indicating non-printing characters, or displaying help text.
Furthermore, it cannot read more than once from a standard input that's associated with a terminal device.
-->

本节介绍了 `cat` 的简化版本，称为 `feline`。与 `cat` 的常用版本不同，
`feline` 没有用于诸如对行编号、指示不可打印字符或显示帮助文本等功能的命令行选项。
此外，它无法从与终端设备关联的标准输入中多次读取。

<!--
To get the most benefit from this section, follow along yourself.
It's OK to copy-paste the code examples, but it's even better to type them in by hand.
This makes it easier to learn the mechanical process of typing in code, recovering from mistakes, and interpreting feedback from the compiler.
-->

要充分学习本节内容，请自己动手操作。复制粘贴代码示例是可以的，但最好手动输入它们。
这使得学习输入代码、从错误中恢复以及解释编译器反馈的机械过程变得更加容易。

<!--
## Getting started
-->

## 开始

<!--
The first step in implementing `feline` is to create a package and decide how to organize the code.
In this case, because the program is so simple, all the code will be placed in `Main.lean`.
The first step is to run `lake new feline`.
Edit the Lakefile to remove the library, and delete the generated library code and the reference to it from `Main.lean`.
Once this has been done, `lakefile.lean` should contain:
-->

第一步是创建包并决定如何组织代码。在本例中，由于程序非常简单，所有代码都将放在 `Main.lean` 中。
首先运行 `lake new feline`。编辑 `Lakefile` 以删除库，并删除生成的库代码及其在
`Main.lean` 中的引用。完成后，`lakefile.lean` 应包含：

```lean
{{#include ../../../examples/feline/1/lakefile.lean}}
```

<!--
and `Main.lean` should contain something like:
-->

而 `Main.lean` 应包含类似以下内容：

```lean
{{#include ../../../examples/feline/1/Main.lean}}
```

<!--
Alternatively, running `lake new feline exe` instructs `lake` to use a template that does not include a library section, making it unnecessary to edit the file.
-->

或者，运行 `lake new feline exe` 指示 `lake` 使用不包含库部分的模板，从而无需编辑文件。

<!--
Ensure that the code can be built by running `{{#command {feline/1} {feline/1} {lake build} }}`.
-->

运行 `{{#command {feline/1} {feline/1} {lake build} }}` 确保可以构建代码。

<!--
## Concatenating Streams
-->

## 连接流

<!--
Now that the basic skeleton of the program has been built, it's time to actually enter the code.
A proper implementation of `cat` can be used with infinite IO streams, such as `/dev/random`, which means that it can't read its input into memory before outputting it.
Furthermore, it should not work one character at a time, as this leads to frustratingly slow performance.
Instead, it's better to read contiguous blocks of data all at once, directing the data to the standard output one block at a time.
-->

现在已经构建了程序的基本框架，是时候实际输入代码了。`cat` 的正确实现可以与无限
IO 流（例如 `/dev/random`）一起使用，这意味着它不能在输出之前将其输入读到内存中。
此外，它不应一次处理一个字符，因为这会导致性能变差。
相反，最好一次读取连续的数据块，一次将数据定向到标准输出。

<!--
The first step is to decide how big of a block to read.
For the sake of simplicity, this implementation uses a conservative 20 kilobyte block.
`USize` is analogous to `size_t` in C—it's an unsigned integer type that is big enough to represent all valid array sizes.
-->

第一步是确定要读取的块的大小。为了简单起见，此实现使用保守的 20kb 字节块。
`USize` 类似于 C 中的 `size_t`，它是一个无符号整数类型，足以表示所有有效的数组大小。

```lean
{{#include ../../../examples/feline/2/Main.lean:bufsize}}
```

<!--
### Streams
-->

### 流

<!--
The main work of `feline` is done by `dump`, which reads input one block at a time, dumping the result to standard output, until the end of the input has been reached:
-->

`feline` 的主要工作由 `dump` 完成，它一次读取一个块的输入，将结果转储到标准输出，直到抵达输入的末尾：

```lean
{{#include ../../../examples/feline/2/Main.lean:dump}}
```

<!--
The `dump` function is declared `partial`, because it calls itself recursively on input that is not immediately smaller than an argument.
When a function is declared to be partial, Lean does not require a proof that it terminates.
On the other hand, partial functions are also much less amenable to proofs of correctness, because allowing infinite loops in Lean's logic would make it unsound.
However, there is no way to prove that `dump` terminates, because infinite input (such as from `/dev/random`) would mean that it does not, in fact, terminate.
In cases like this, there is no alternative to declaring the function `partial`.
-->

`dump` 函数被声明为 `partial`，因为它在输入上递归调用自身，该输入不会立即小于一个参数。
当一个函数被声明为 `partial` 时，Lean 不要求证明它会终止。另一方面，`partial`
函数也不太适合正确性证明，因为允许在 Lean 的逻辑中进行无限循环会使其不可靠（Sound）。
然而，我们没有办法证明 `dump` 会终止，因为无限输入（例如来自 `/dev/random`）意味着它实际上不会终止。
在这种情况下，除了将函数声明为 `partial` 之外别无选择。

<!--
The type `IO.FS.Stream` represents a POSIX stream.
Behind the scenes, it is represented as a structure that has one field for each POSIX stream operation.
Each operation is represented as an IO action that provides the corresponding operation:
-->

类型 `IO.FS.Stream` 表示一个 POSIX 流。在幕后，它被表示为一个结构体，
该结构体为每个 POSIX 流活动提供一个字段。每个活动都表示为一个 IO 活动，它提供了相应的活动：

```lean
{{#example_decl Examples/Cat.lean Stream}}
```

<!--
The Lean compiler contains `IO` actions (such as `IO.getStdout`, which is called in `dump`) to get streams that represent standard input, standard output, and standard error.
These are `IO` actions rather than ordinary definitions because Lean allows these standard POSIX streams to be replaced in a process, which makes it easier to do things like capturing the output from a program into a string by writing a custom `IO.FS.Stream`.
-->

Lean 编译器包含 `IO` 活动（例如 `IO.getStdout`，它在 `dump` 中被调用）以获取表示标准输入、
标准输出和标准错误的流。这些都是是 `IO` 活动，而非普通定义，因为 Lean 允许在进程中替换这些标准
POSIX 流，这使得通过编写自定义 `IO.FS.Stream` 将程序的输出捕获到字符串中变得更容易。

<!--
The control flow in `dump` is essentially a `while` loop.
When `dump` is called, if the stream has reached the end of the file, `pure ()` terminates the function by returning the constructor for `Unit`.
If the stream has not yet reached the end of the file, one block is read, and its contents are written to `stdout`, after which `dump` calls itself directly.
The recursive calls continue until `stream.read` returns an empty byte array, which indicates that the end of the file has been reached.
-->

`dump` 中的控制流本质上是一个 `while` 循环。当调用 `dump` 时，如果流已达到文件末尾，
`pure ()` 就会通过返回 `Unit` 的构造子来终止函数。如果流尚未达到文件末尾，则读取一个块，
并将它的内容写入 `stdout`，之后 `dump` 直接调用自身。递归调用会一直持续到
`stream.read` 返回一个空字节数组，这表示已达到文件末尾。

<!--
When an `if` expression occurs as a statement in a `do`, as in `dump`, each branch of the `if` is implicitly provided with a `do`.
In other words, the sequence of steps following the `else` are treated as a sequence of `IO` actions to be executed, just as if they had a `do` at the beginning.
Names introduced with `let` in the branches of the `if` are visible only in their own branches, and are not in scope outside of the `if`.
-->

当 `if` 表达式作为 `do` 中的语句出现时，如 `dump` 中，`if` 的每个分支都会隐式地提供一个 `do`。
换句话说，跟在 `else` 之后的步骤序列会被视为要执行的 `IO` 活动序列，就像它们在开头有一个 `do` 一样。
在 `if` 分支中用 `let` 引入的名称只在其自己的分支中可见，而不在 `if` 之外的范围。

<!--
There is no danger of running out of stack space while calling `dump` because the recursive call happens as the very last step in the function, and its result is returned directly rather than being manipulated or computed with.
This kind of recursion is called _tail recursion_, and it is described in more detail [later in this book](../programs-proofs/tail-recursion.md).
Because the compiled code does not need to retain any state, the Lean compiler can compile the recursive call to a jump.
-->

在调用 `dump` 时，不会出现耗尽堆栈空间的危险，因为递归调用发生在函数的最后一步，
并且其结果会被直接返回，而不会被活动或计算。这种递归称为 **尾递归（Tail Recursion）** ，
将在本书[后面的章节](../programs-proofs/tail-recursion.md)中详细描述。
由于编译后的代码不需要保留任何状态，因此 Lean 编译器可以将递归调用编译为跳转。

<!--
If `feline` only redirected standard input to standard output, then `dump` would be sufficient.
However, it also needs to be able to open files that are provided as command-line arguments and emit their contents.
When its argument is the name of a file that exists, `fileStream` returns a stream that reads the file's contents.
When the argument is not a file, `fileStream` emits an error and returns `none`.
-->

如果 `feline` 只将标准输入重定向到标准输出，那么 `dump` 就足够了。
但是，它还需要能够打开命令行参数提供的文件并输出其内容。当其参数是存在的文件名时，
`fileStream` 返回读取文件内容的流。当参数不是文件时，`fileStream` 报告错误并返回 `none`。

```lean
{{#include ../../../examples/feline/2/Main.lean:fileStream}}
```

<!--
Opening a file as a stream takes two steps.
First, a file handle is created by opening the file in read mode.
A Lean file handle tracks an underlying file descriptor.
When there are no references to the file handle value, a finalizer closes the file descriptor.
Second, the file handle is given the same interface as a POSIX stream using `IO.FS.Stream.ofHandle`, which fills each field of the `Stream` structure with the corresponding `IO` action that works on file handles.
-->

打开一个文件作为流需要两个步骤。首先，通过以读取模式打开文件来创建一个文件勾柄。
Lean 文件勾柄跟踪了一个底层文件的描述符。当没有对文件勾柄值进行引用时，
收尾器（finalizer）会关闭文件描述符。其次，使用 `IO.FS.Stream.ofHandle`
为文件勾柄提供与 POSIX 流相同的接口，该接口会使用文件勾柄上工作的相应 `IO` 活动填充
`Stream` 结构体的每个字段。

<!--
### Handling Input
-->

### 处理输入

<!--
The main loop of `feline` is another tail-recursive function, called `process`.
In order to return a non-zero exit code if any of the inputs could not be read, `process` takes an argument `exitCode` that represents the current exit code for the whole program.
Additionally, it takes a list of input files to be processed.
-->

`feline` 的主循环是另一个尾递归函数，称为 `process`。为了在无法读取任何输入时返回非零退出代码，
`process` 接受一个参数 `exitCode`，该参数表示整个程序的当前退出码。
此外，它还接受一个要处理的输入文件列表。

```lean
{{#include ../../../examples/feline/2/Main.lean:process}}
```

<!--
Just as with `if`, each branch of a `match` that is used as a statement in a `do` is implicitly provided with its own `do`.
-->

和 `if` 一样，在 `do` 中作为语句使用的 `match` 的每个分支都隐式地提供了自己的 `do`。

<!--
There are three possibilities.
One is that no more files remain to be processed, in which case `process` returns the error code unchanged.
Another is that the specified filename is `"-"`, in which case `process` dumps the contents of the standard input and then processes the remaining filenames.
The final possibility is that an actual filename was specified.
In this case, `fileStream` is used to attempt to open the file as a POSIX stream.
Its argument is encased in `⟨ ... ⟩` because a `FilePath` is a single-field structure that contains a string.
If the file could not be opened, it is skipped, and the recursive call to `process` sets the exit code to `1`.
If it could, then it is dumped, and the recursive call to `process` leaves the exit code unchanged.
-->

分支有三种可能的情况。一种是没有更多文件需要处理，此时，`process` 返回未更改的错误代码。
另一种是指定的文件名为 `"-"`, 此时，`process` 转储标准输入的内容，然后处理剩余的文件名。
最后一种情况是指定了实际文件名。此时，`fileStream` 用于尝试将文件作为 POSIX 流打开。
它的参数被封装在 `⟨ ... ⟩` 中，因为 `FilePath` 是一个包含字符串的单字段结构体。
若无法打开文件，则跳过该文件，对`process` 的递归调用会将退出代码设置为 `1`；
若可以打开，则将其转储，对 `process` 的递归调用会将使退出代码保持不变。

<!--
`process` does not need to be marked `partial` because it is structurally recursive.
Each recursive call is provided with the tail of the input list, and all Lean lists are finite.
Thus, `process` does not introduce any non-termination.
-->

`process` 无需标记为 `partial`，因为它在结构上是递归的。
每次递归调用都会提供输入列表的尾部，而所有的 Lean 列表都是有限的，
因此，`process` 不会引入任何非终止。

<!--
### Main
-->

### Main 活动

<!--
The final step is to write the `main` action.
Unlike prior examples, `main` in `feline` is a function.
In Lean, `main` can have one of three types:

 * `main : IO Unit` corresponds to programs that cannot read their command-line arguments and always indicate success with an exit code of `0`,
 * `main : IO UInt32` corresponds to `int main(void)` in C, for programs without arguments that return exit codes, and
 * `main : List String → IO UInt32` corresponds to `int main(int argc, char **argv)` in C, for programs that take arguments and signal success or failure.
-->

最后一步是编写 `main` 活动。与之前的示例不同，`feline` 中的 `main`
是一个函数。在 Lean 中，`main` 可以有三种类型之一：

* `main : IO Unit` 对应于无法读取其命令行参数并始终以退代码 `0` 表示成功的程序，
* `main : IO UInt32` 对应于 C 中的 `int main(void)`，用于没有参数且返回退出码的程序，
* `main : List String → IO UInt32` 对应于 C 中的 `int main(int argc, char **argv)`，
  用于获取参数并发出成功或失败信号的程序。

<!--
If no arguments were provided, `feline` should read from standard input as if it were called with a single `"-"` argument.
Otherwise, the arguments should be processed one after the other.
-->

如果没有提供参数，`feline` 应从标准输入读取，就像使用单个 `"-"` 参数调用它一样。
否则，应依次处理参数。

```lean
{{#include ../../../examples/feline/2/Main.lean:main}}
```

<!--
## Meow!
-->

## 喵！

<!--
To check whether `feline` works, the first step is to build it with `{{#command {feline/2} {feline/2} {lake build} }}`.
First off, when called without arguments, it should emit what it receives from standard input.
Check that
-->

要检查 `feline` 是否工作，第一步是用 `{{#command {feline/2} {feline/2} {lake build} }}`
构建它。首先，在没有参数的情况下调用它时，它应当返回从标准输入接收到的内容。检查

```
{{#command {feline/2} {feline/2} {echo "It works!" | ./build/bin/feline} }}
```

<!--
emits `{{#command_out {feline/2} {echo "It works!" | ./build/bin/feline} }}`.
-->

会返回 `{{#command_out {feline/2} {echo "It works!" | ./build/bin/feline} }}`.

<!--
Secondly, when called with files as arguments, it should print them.
If the file `test1.txt` contains
-->

其次，当以文件作为参数调用它时，它应该打印它们。如果文件 `test1.txt` 包含

```
{{#include ../../../examples/feline/2/test1.txt}}
```

<!--
and `test2.txt` contains
-->

且 `test2.txt` 包含

```
{{#include ../../../examples/feline/2/test2.txt}}
```

<!--
then the command
-->

那么命令

```
{{#command {feline/2} {feline/2} {./build/bin/feline test1.txt test2.txt} }}
```

<!--
should emit
-->

应当返回

```
{{#command_out {feline/2} {./build/bin/feline test1.txt test2.txt} {feline/2/expected/test12.txt} }}
```

<!--
Finally, the `-` argument should be handled appropriately.
-->

最后，参数 `-` 应得到适当处理。

```
{{#command {feline/2} {feline/2} {echo "and purr" | ./build/bin/feline test1.txt - test2.txt} }}
```

<!--
should yield
-->

应产生

```
{{#command_out {feline/2} {echo "and purr" | ./build/bin/feline test1.txt - test2.txt} {feline/2/expected/test1purr2.txt}}}
```

<!--
## Exercise
-->

## 练习

<!--
Extend `feline` with support for usage information.
The extended version should accept a command-line argument `--help` that causes documentation about the available command-line options to be written to standard output.
-->

扩展 `feline` 使其支持用法信息。扩展版本应接受命令行参数 `--help`，
产生关于可用命令行选项的文档并写入到标准输出。
