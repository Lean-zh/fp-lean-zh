<!--
# Introduction
-->

# 前言

<!--
Lean is an interactive theorem prover developed at Microsoft Research, based on dependent type theory.
Dependent type theory unites the worlds of programs and proofs; thus, Lean is also a programming language.
Lean takes its dual nature seriously, and it is designed to be suitable for use as a general-purpose programming language—Lean is even implemented in itself.
This book is about writing programs in Lean.
-->

Lean 是 Microsoft Research 开发的交互式定理证明器，基于依值类型论。
依值类型论将程序和证明的世界统一起来；因此，Lean 也是一门编程语言。
Lean 认真对待其双重性质，并且被设计为适合用作通用编程语言，Lean
甚至是用它自己实现的。本书介绍了如何用 Lean 编程。

<!--
When viewed as a programming language, Lean is a strict pure functional language with dependent types.
A large part of learning to program with Lean consists of learning how each of these attributes affects the way programs are written, and how to think like a functional programmer.
_Strictness_ means that function calls in Lean work similarly to the way they do in most languages: the arguments are fully computed before the function's body begins running.
_Purity_ means that Lean programs cannot have side effects such as modifying locations in memory, sending emails, or deleting files without the program's type saying so.
Lean is a _functional_ language in the sense that functions are first-class values like any other and that the execution model is inspired by the evaluation of mathematical expressions.
_Dependent types_, which are the most unusual feature of Lean, make types into a first-class part of the language, allowing types to contain programs and programs to compute types.
-->

作为一门编程语言，Lean 是一种具有依值类型的严格纯函数式语言。
学习使用 Lean 编程很大一部分内容在于学习这些属性中的每一个如何影响程序的编写方式，
以及如何像函数式程序员一样思考。
  **严格性（Strictness）** 意味着 Lean 中的函数调用与大多数语言中的工作方式类似：
在函数体开始运行之前，参数被完全计算。
  **纯粹性（Purity）** 意味着 Lean 程序不能产生副作用，例如修改内存中的位置、
发送电子邮件或删除文件，除非程序的类型声明如此。
Lean 是一种  **函数式（Functional）** 语言，这意味着函数就像任何其他值一样是一等值，
并且执行模型受数学表达式的求值启发。
  **依值类型（Dependent type）** 是 Lean 最不寻常的特性，它使类型成为语言的一等部分，
允许类型包含程序，而程序计算类型。"

<!--
This book is intended for programmers who want to learn Lean, but who have not necessarily used a functional programming language before.
Familiarity with functional languages such as Haskell, OCaml, or F# is not required.
On the other hand, this book does assume knowledge of concepts like loops, functions, and data structures that are common to most programming languages.
While this book is intended to be a good first book on functional programming, it is not a good first book on programming in general.
-->

本书面向希望学习 Lean 的程序员，但他们不一定以前使用过函数式编程语言。
不需要熟悉 Haskell、OCaml 或 F# 等函数式语言。另一方面，本书确实假设读者了解循环、
函数和数据结构等大多数编程语言中常见的概念。虽然本书旨在成为一本关于函数式编程的优秀入门书，
但它并不是一本关于一般编程的优秀入门书。"

<!--
Mathematicians who are using Lean as a proof assistant will likely need to write custom proof automation tools at some point.
This book is also for them.
As these tools become more sophisticated, they begin to resemble programs in functional languages, but most working mathematicians are trained in languages like Python and Mathematica.
This book can help bridge the gap, empowering more mathematicians to write maintainable and understandable proof automation tools.
-->

对于将 Lean 作为证明助手的数学家来说，他们可能需要在某个时间点编写自定义的证明自动化工具。本书也适用于他们。随着这些工具变得越来越复杂，它们也越来越像函数式语言编写的程序，但大多数在职数学家接受的是 Python 和 Mathematica 等语言的培训。本书可以帮助他们弥合这一差距，让更多数学家能够编写可维护且易于理解的证明自动化工具。"

<!--
This book is intended to be read linearly, from the beginning to the end.
Concepts are introduced one at a time, and later sections assume familiarity with earlier sections.
Sometimes, later chapters will go into depth on a topic that was only briefly addressed earlier on.
Some sections of the book contain exercises.
These are worth doing, in order to cement your understanding of the section.
It is also useful to explore Lean as you read the book, finding creative new ways to use what you have learned.
-->

本书旨在从头到尾线性阅读。概念一次引入一个，后面的章节假定读者熟悉前面的章节。
有时，后面的章节会深入探讨一个之前仅简要讨论过的主题。本书的某些章节包含练习。
为了巩固你对该章节的理解，这些练习值得一做。在阅读本书时探索 Lean 也很有用，
找到使用你所学知识的创造性新方法。

<!--
# Getting Lean
-->

# 获取 Lean

<!--
Before writing and running programs written in Lean, you'll need to set up Lean on your own computer.
The Lean tooling consists of the following:
-->

在编写和运行用 Lean 编写的程序之前，你需要在自己的计算机上设置 Lean。Lean 工具包括以下内容：

<!--
 * `elan` manages the Lean compiler toolchains, similarly to `rustup` or `ghcup`.
 * `lake` builds Lean packages and their dependencies, similarly to `cargo`, `make`, or Gradle.
 * `lean` type checks and compiles individual Lean files as well as providing information to programmer tools about files that are currently being written.
   Normally, `lean` is invoked by other tools rather than directly by users.
 * Plugins for editors, such as Visual Studio Code or Emacs, that communicate with `lean` and present its information conveniently.
-->

* `elan`：用于管理 Lean 编译器工具链，类似于 `rustup` 或 `ghcup`。
* `lake`：用于构建 Lean 包及其依赖项，类似于 `cargo`、`make` 或 Gradle。
* `lean`：对各个 Lean 文件进行类型检查和编译，并向程序员的工具提供有关当前正在编写的文件的信息。
  通常，`lean` 是由其他工具而非用户直接调用的。
* 编辑器插件，如 Visual Studio Code 或 Emacs，可与 Lean 通信并方便地显示其信息。

<!--
Please refer to the [Lean manual](https://lean-lang.org/lean4/doc/quickstart.html) for up-to-date instructions for installing Lean.
-->

有关安装 Lean 的最新说明，请参阅 [Lean 手册](https://lean-lang.org/lean4/doc/quickstart.html)。

<!--
# Typographical Conventions
-->

# 排版约定

<!--
Code examples that are provided to Lean as _input_ are formatted like this:
-->

作为  **输入** 提供给 Lean 的代码示例格式如下：

```lean
{{#example_decl Examples/Intro.lean add1}}

{{#example_in Examples/Intro.lean add1_7}}
```

<!--
The last line above (beginning with `#eval`) is a command that instructs Lean to calculate an answer.
Lean's replies are formatted like this:
-->

上面最后一行（以 `#eval` 开头）是指示 Lean 计算答案的命令。Lean 的回复格式如下：

```output info
{{#example_out Examples/Intro.lean add1_7}}
```

<!--
Error messages returned by Lean are formatted like this:
-->

Lean 返回的错误消息格式如下：

```output error
{{#example_out Examples/Intro.lean add1_string}}
```

<!--
Warnings are formatted like this:
-->

警告格式如下：

```output warning
declaration uses 'sorry'
```

# Unicode

<!--
Idiomatic Lean code makes use of a variety of Unicode characters that are not part of ASCII.
For instance, Greek letters like `α` and `β` and the arrow `→` both occur in the first chapter of this book.
This allows Lean code to more closely resemble ordinary mathematical notation.
-->

惯用的 Lean 代码使用各种不属于 ASCII 的 Unicode 字符。例如，希腊字母（如 `α` 和 "`β`）
和箭头（`→`）都出现在本书的第一章中。
这使得 Lean 代码更接近于普通的数学记法。

<!--
With the default Lean settings, both Visual Studio Code and Emacs allow these characters to be typed with a backslash (`\`) followed by a name.
For example, to enter `α`, type `\alpha`.
To find out how to type a character in Visual Studio Code, point the mouse at it and look at the tooltip.
In Emacs, use `C-c C-k` with point on the character in question.
-->

在默认的 Lean 设置中，Visual Studio Code 和 Emacs 都允许使用反斜杠 (`\`) 后跟名称来输入这些字符。
例如，要输入 `α`，请键入 `\alpha`。要了解如何在 Visual Studio Code 中键入字符，
请将鼠标指向该字符并查看工具提示。在 Emacs 中，将光标置于相关字符上，然后使用 `C-c C-k`。
