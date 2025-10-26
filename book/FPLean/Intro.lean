import VersoManual
import FPLeanZh.Examples

open Verso.Genre Manual
open Verso Code External

open FPLeanZh

set_option verso.exampleProject "../examples"
set_option verso.exampleModule "Examples.Intro"

#doc (Manual) "Introduction" =>
%%%
htmlSplit := .never
number := false
%%%

/- Lean is an interactive theorem prover based on dependent type theory.
Originally developed at Microsoft Research, development now takes place at the [Lean FRO](https://lean-fro.org).
Dependent type theory unites the worlds of programs and proofs; thus, Lean is also a programming language.
Lean takes its dual nature seriously, and it is designed to be suitable for use as a general-purpose programming language—Lean is even implemented in itself.
This book is about writing programs in Lean.
-/
Lean 是一个基于__依值类型论（Dependent Type Theory）__的交互式定理证明器。
它最初由微软研究院开发，现在由 [Lean FRO](https://lean-fro.org) 负责开发。
依值类型论将程序和证明的世界统一了起来，因此，Lean 也是一门编程语言。
Lean 认真对待其双重性质，并被设计为适合用作通用编程语言——Lean 甚至是用它自己实现的。
本书旨在介绍如何使用 Lean 编写程序。

/- When viewed as a programming language, Lean is a strict pure functional language with dependent types.
A large part of learning to program with Lean consists of learning how each of these attributes affects the way programs are written, and how to think like a functional programmer.
_Strictness_ means that function calls in Lean work similarly to the way they do in most languages: the arguments are fully computed before the function's body begins running.
_Purity_ means that Lean programs cannot have side effects such as modifying locations in memory, sending emails, or deleting files without the program's type saying so.
Lean is a _functional_ language in the sense that functions are first-class values like any other and that the execution model is inspired by the evaluation of mathematical expressions.
_Dependent types_, which are the most unusual feature of Lean, make types into a first-class part of the language, allowing types to contain programs and programs to compute types.
-/
作为一门编程语言，Lean 是一种具有依值类型的严格纯函数式语言。
学习使用 Lean 编程很大一部分内容在于学习这些属性是如何影响程序编写方式的，
以及如何像函数式程序员一样思考。

- __严格性（Strictness）__ 意味着 Lean 中的函数调用与大多数语言中的工作方式类似：
在函数体开始运行之前，参数会被完全计算。
- __纯粹性（Purity）__ 意味着 Lean 程序除非明确声明，否则无法产生副作用，
例如修改内存中的位置、发送电子邮件或删除文件等。
Lean 是一种 __函数式（Functional）__ 语言，这意味着函数就像任何其他值一样是一等值，
并且执行模型受数学表达式的求值启发。
- __依值类型（Dependent type）__ 是 Lean 最不寻常的特性，它使类型成为语言的一等部分，
允许类型包含程序，而程序计算类型。

/- This book is intended for programmers who want to learn Lean, but who have not necessarily used a functional programming language before.
Familiarity with functional languages such as Haskell, OCaml, or F# is not required.
On the other hand, this book does assume knowledge of concepts like loops, functions, and data structures that are common to most programming languages.
While this book is intended to be a good first book on functional programming, it is not a good first book on programming in general.
-/
本书面向想要学习 Lean 的程序员，但未必以前使用过函数式编程语言。
读者不需要熟悉 Haskell、OCaml 或 F# 等函数式语言。而另一方面，本书确实假定读者了解循环、
函数和数据结构等大多数编程语言中的常见概念。虽然本书旨在成为一本关于函数式编程的优秀入门书，
但它并不是一本关于一般编程的入门书。

/- Mathematicians who are using Lean as a proof assistant will likely need to write custom proof automation tools at some point.
This book is also for them.
As these tools become more sophisticated, they begin to resemble programs in functional languages, but most working mathematicians are trained in languages like Python and Mathematica.
This book can help bridge the gap, empowering more mathematicians to write maintainable and understandable proof automation tools.
-/
对于将 Lean 作为证明助手的数学家来说，他们可能需要在某个时间点编写自定义的证明自动化工具，
本书也适用于他们。随着这些工具变得越来越复杂，它们也会越来越像函数式语言编写的程序，
但大多数在职数学家接受的是 Python 和 Mathematica 等语言的培训。
本书可以帮助他们弥合这一差距，让更多数学家能够编写可维护且易于理解的证明自动化工具。

/- This book is intended to be read linearly, from the beginning to the end.
Concepts are introduced one at a time, and later sections assume familiarity with earlier sections.
Sometimes, later chapters will go into depth on a topic that was only briefly addressed earlier on.
Some sections of the book contain exercises.
These are worth doing, in order to cement your understanding of the section.
It is also useful to explore Lean as you read the book, finding creative new ways to use what you have learned.
-/
本书旨在从头到尾线性阅读。概念一次引入一个，后面的章节会假定读者熟悉前面的章节。
有时，后面的章节会深入探讨一个之前仅简要讨论过的主题。本书的某些章节包含练习。
为了巩固你对该章节的理解，这些练习值得一做。在阅读本书时探索 Lean 也很有用，
可以发现能利用你所学知识的创造性新方法。

-- # Getting Lean

# 获取 Lean

/- Before writing and running programs written in Lean, you'll need to set up Lean on your own computer.
The Lean tooling consists of the following:
-/
在编写并运行 Lean 所编写的程序之前，你需要在自己的计算机上设置 Lean。Lean 工具包括以下内容：

/- * {lit}`elan` manages the Lean compiler toolchains, similarly to {lit}`rustup` or {lit}`ghcup`.
 * {lit}`lake` builds Lean packages and their dependencies, similarly to {lit}`cargo`, {lit}`make`, or Gradle.
 * {lit}`lean` type checks and compiles individual Lean files as well as providing information to programmer tools about files that are currently being written.
   Normally, {lit}`lean` is invoked by other tools rather than directly by users.
 * Plugins for editors, such as Visual Studio Code or Emacs, that communicate with {lit}`lean` and present its information conveniently.
-/
* {lit}`elan`：用于管理 Lean 编译器工具链，类似于 {lit}`rustup` 或 {lit}`ghcup`。
* {lit}`lake`：用于构建 Lean 包及其依赖项，类似于 {lit}`cargo`、{lit}`make` 或 Gradle。
* {lit}`lean`：用于对 Lean 文件进行类型检查和编译，并向程序员工具提供当前正在编写的文件的相关信息。
  通常，{lit}`lean` 是由其他工具而非用户直接调用的。
* 编辑器插件，如 Visual Studio Code 或 Emacs，可与 {lit}`lean` 通信并方便地显示其信息。

/- Please refer to the [Lean manual](https://lean-lang.org/lean4/doc/quickstart.html) for up-to-date instructions for installing Lean.
-/
有关安装 Lean 的最新说明，请参阅 [Lean manual](https://lean-lang.org/lean4/doc/quickstart.html)。

-- # Typographical Conventions

# 排版约定

/- Code examples that are provided to Lean as _input_ are formatted like this:
-/
作为 __输入__ 提供给 Lean 的代码示例格式如下：

```anchor add1
def add1 (n : Nat) : Nat := n + 1
```

```anchorTerm add1_7
#eval add1 7
```

/- The last line above (beginning with {kw}`#eval`) is a command that instructs Lean to calculate an answer.
Lean's replies are formatted like this:
-/
上面最后一行（以 {kw}`#eval` 开头）是指示 Lean 计算答案的命令。Lean 的回复格式如下：

```anchorInfo add1_7
8
```

/- Error messages returned by Lean are formatted like this:
-/
Lean 返回的错误消息格式如下：

```anchorError add1_string
Application Type mismatch
  add1 "seven"
argument
  "seven"
has type
  String : Type
but is expected to have type
  Nat : Type
```

/- Warnings are formatted like this:
-/
警告格式如下：

```anchorWarning add1_warn
declaration uses 'sorry'
```

# Unicode


/- Idiomatic Lean code makes use of a variety of Unicode characters that are not part of ASCII.
For instance, Greek letters like {lit}`α` and {lit}`β` and the arrow {lit}`→` both occur in the first chapter of this book.
This allows Lean code to more closely resemble ordinary mathematical notation.
-/
惯用的 Lean 代码会使用各种不属于 ASCII 的 Unicode 字符。例如，希腊字母（如 {lit}`α` 和 {lit}`β`）
和箭头（{lit}`→`）都出现在本书的第一章中。这使得 Lean 代码更接近于普通的数学记法。

/- With the default Lean settings, both Visual Studio Code and Emacs allow these characters to be typed with a backslash ({lit}`\`) followed by a name.
For example, to enter {lit}`α`, type {lit}`\alpha`.
To find out how to type a character in Visual Studio Code, point the mouse at it and look at the tooltip.
In Emacs, use {lit}`C-c C-k` with point on the character in question.
-/
在默认的 Lean 设置中，Visual Studio Code 和 Emacs 都允许使用反斜杠（{lit}`\`）后跟名称来输入这些字符。
例如，要输入 {lit}`α`，请键入 {lit}`\alpha`。要了解如何在 Visual Studio Code 中键入字符，
请将鼠标指向该字符并查看工具提示。在 Emacs 中，将光标置于相关字符上，然后使用 {lit}`C-c C-k` 即可查看提示。



# Release history
%%%
number := false
htmlSplit := .never
%%%

/- ## June, 2025

The book has been reformatted with Verso.
-/
## 2025 年 6 月

本书已使用 Verso 重新格式化。

/- ## April, 2025

The book has been extensively updated and now describes Lean version 4.18.
-/
## 2025 年 4 月

本书已 extensively 更新，现在描述 Lean 4.18 版本。

/- ## January, 2024

This is a minor bugfix release that fixes a regression in an example program.
-/
## 2024 年 1 月

这是一个次要的错误修复版本，修复了示例程序中的一个回归问题。

/- ## October, 2023

In this first maintenance release, a number of smaller issues were fixed and the text was brought up to date with the latest release of Lean.
-/
## 2023 年 10 月

在此第一个维护版本中，修复了一些小问题，并根据 Lean 的最新版本更新了文本。

/- ## May, 2023

The book is now complete! Compared to the April pre-release, many small details have been improved and minor mistakes have been fixed.
-/
## 2023 年 5 月

本书现已完成！与 4 月的预发布版本相比，许多小细节得到了改进，并修复了小错误。

/- ## April, 2023

This release adds an interlude on writing proofs with tactics as well as a final chapter that combines discussion of performance and cost models with proofs of termination and program equivalence.
This is the last release prior to the final release.
-/
## 2023 年 4 月

此版本增加了关于使用策略编写证明的插曲，以及一个结合了性能和成本模型讨论与终止和程序等价证明的最终章节。
这是最终发布之前的最后一个版本。

/- ## March, 2023

This release adds a chapter on programming with dependent types and indexed families.
-/
## 2023 年 3 月

此版本增加了关于使用依赖类型和索引族编程的章节。

/- ## January, 2023

This release adds a chapter on monad transformers that includes a description of the imperative features that are available in {kw}`do`-notation.
-/
## 2023 年 1 月

此版本增加了关于单子转换器的章节，其中包括对 {kw}`do`-notation 中可用的命令式功能的描述。

/- ## December, 2022

This release adds a chapter on applicative functors that additionally describes structures and type classes in more detail.
This is accompanied with improvements to the description of monads.
The December 2022 release was delayed until January 2023 due to winter holidays.
-/
## 2022 年 12 月

此版本增加了关于应用函子的章节，其中还更详细地描述了结构和类型类。
同时改进了对单子的描述。
由于冬季假期，2022 年 12 月的版本推迟到 2023 年 1 月发布。

/- ## November, 2022
This release adds a chapter on programming with monads. Additionally, the example of using JSON in the coercions section has been updated to include the complete code.
-/
## 2022 年 11 月
此版本增加了关于使用单子编程的章节。此外，强制转换部分中使用 JSON 的示例已更新，包含了完整的代码。

/- ## October, 2022

This release completes the chapter on type classes. In addition, a short interlude introducing propositions, proofs, and tactics has been added just before the chapter on type classes, because a small amount of familiarity with the concepts helps to understand some of the standard library type classes.
-/
## 2022 年 10 月

此版本完成了类型类章节。此外，在类型类章节之前添加了一个简短的插曲，介绍了命题、证明和策略，因为对这些概念的少量熟悉有助于理解一些标准库类型类。

/- ## September, 2022

This release adds the first half of a chapter on type classes, which are Lean's mechanism for overloading operators and an important means of organizing code and structuring libraries. Additionally, the second chapter has been updated to account for changes in Lean's stream API.
-/
## 2022 年 9 月

此版本增加了类型类章节的前半部分，类型类是 Lean 重载运算符的机制，也是组织代码和构建库的重要手段。此外，第二章已更新，以适应 Lean 流 API 的变化。

/- ## August, 2022

This third public release adds a second chapter, which describes compiling and running programs along with Lean's model for side effects.
-/
## 2022 年 8 月

第三次公开发布增加了第二章，其中描述了程序的编译和运行以及 Lean 的副作用模型。

/- ## July, 2022

The second public release completes the first chapter.
-/
## 2022 年 7 月

第二次公开发布完成了第一章。

/- ## June, 2022

This was the first public release, consisting of an introduction and part of the first chapter.
-/
## 2022 年 6 月

这是第一次公开发布，包括引言和第一章的一部分。


# About the Author

/- David Thrane Christiansen has been using functional languages for twenty years, and dependent types for ten.
Together with Daniel P. Friedman, he wrote [_The Little Typer_](https://thelittletyper.com/), an introduction to the key ideas of dependent type theory.
He has a Ph.D. from the IT University of Copenhagen.
During his studies, he was a major contributor to the first version of the Idris language.
Since leaving academia, he has worked as a software developer at Galois in Portland, Oregon and Deon Digital in Copenhagen, Denmark, and he was the Executive Director of the Haskell Foundation.
At the time of writing, he is employed at the [Lean Focused Research Organization](https://lean-fro.org) working full-time on Lean.
-/
David Thrane Christiansen 使用函数式语言已有二十年，使用依赖类型已有十年。
他与 Daniel P. Friedman 合著了 [_The Little Typer_](https://thelittletyper.com/)，该书介绍了依赖类型理论的核心思想。
他拥有哥本哈根信息技术大学的博士学位。
在学习期间，他是 Idris 语言第一个版本的主要贡献者。
离开学术界后，他曾在俄勒冈州波特兰的 Galois 和丹麦哥本哈根的 Deon Digital 担任软件开发人员，并曾担任 Haskell 基金会的执行董事。
在撰写本书时，他受雇于 [Lean Focused Research Organization](https://lean-fro.org)，全职从事 Lean 的工作。

# License

{creativeCommons}

/- The original version of the book was written by David Thrane Christiansen on contract to Microsoft Corporation, who generously released it under a Creative Commons Attribution 4.0 International License.
The current version has been modified by the author from the original version to account for changes in newer versions of Lean.
A detailed account of the changes can be found in the book's [source code repository](https://github.com/subfish-zhou/fp-lean-zh/).
-/
本书的原始版本由 David Thrane Christiansen 受微软公司委托撰写，微软公司慷慨地将其以知识共享署名 4.0 国际许可协议发布。
当前版本已由作者在原始版本的基础上进行修改，以适应 Lean 新版本的变化。
有关更改的详细说明，请参阅本书的[源代码仓库](https://github.com/subfish-zhou/fp-lean-zh/)。
