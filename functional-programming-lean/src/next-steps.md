<!--
# Next Steps
-->

# 下一步

<!--
This book introduces the very basics of functional programming in Lean, including a tiny amount of interactive theorem proving. Using dependently-typed functional languages like Lean is a deep topic, and much can be said. Depending on your interests, the following resources might be useful for learning Lean 4.
-->

本书介绍了 Lean 中函数式编程的基本知识，包括一些互动定理证明的内容。
使用依值类型的函数式语言（如 Lean）是一个深奥的主题，内容丰富。
根据您的兴趣，以下资源可能对学习 Lean 4 有用。

<!--
### Learning Lean
-->

### 学习 Lean

<!--
Lean 4 itself is described in the following resources:

Theorem Proving in Lean 4 is a tutorial on writing proofs using Lean.
The Lean 4 Manual provides a reference for the language and its features. At the time of writing, it is still incomplete, but it describes many aspects of Lean in greater detail than this book.
How To Prove It With Lean is a Lean-based accompaniment to the well-regarded textbook How To Prove It that provides an introduction to writing paper-and-pencil mathematical proofs.
Metaprogramming in Lean 4 provides an overview of Lean's extension mechanisms, from infix operators and notations to macros, custom tactics, and full-on custom embedded languages.
Functional Programming in Lean may be interesting to readers who enjoy jokes about recursion.
However, the best way to continue learning Lean is to start reading and writing code, consulting the documentation when you get stuck. Additionally, the Lean Zulip is an excellent place to meet other Lean users, ask for help, and help others.
-->

Lean 4 本身在以下资源中有详细描述：

《[Lean 4 定理证明](https://www.leanprover.cn/tp-lean-zh/)》
是一本关于使用 Lean 编写证明的教程。
《[Lean 4 手册](https://www.leanprover.cn/lean4/)》
提供了 Lean 语言及其功能的参考资料。虽然在撰写本文时它仍未完成，
但它比本书更详细地描述了 Lean 的许多方面。
《[怎样用 Lean 证明数学题](https://djvelleman.github.io/HTPIwL/)》是著名教材
《[怎样证明数学题](https://book.douban.com/subject/3810450/)》的 Lean 版伴随读物，
介绍了如何编写纸笔数学证明。
《[Lean 4 元编程](https://www.leanprover.cn/lean4-mp/)》概述了 Lean 的扩展机制，
从中缀运算符和符号到宏、自定义策略和完整的自定义嵌入式语言。
《[Lean 函数式编程](https://www.leanprover.cn/tp-lean-zh/)》可能对喜欢递归笑话的读者来说很有趣。
然而，继续学习 Lean 的最佳方式是开始阅读和编写代码，在遇到困难时查阅文档。
此外，[Lean Zulip](https://leanprover.zulipchat.com/) 是结识其他 Lean 用户、
寻求帮助和帮助他人的好地方。

<!--
### The Standard Library
-->

### 标准库

<!--
Out of the box, Lean itself includes a fairly minimal library. Lean is self-hosted, and the included code is just enough to implement Lean itself. For many applications, a larger standard library is needed.

std4 is an in-progress standard library that includes many data structures, tactics, type class instances, and functions that are out of scope for the Lean compiler itself.

To use std4, the first step is to find a commit in its history that's compatible with the version of Lean 4 that you're using (that is, one in which the lean-toolchain file matches the one in your project). Then, add the following to the top level of your lakefile.lean, where COMMIT_HASH is the appropriate version:
-->

Lean 自带的库相对较小。Lean 是自托管的，所包含的代码仅够实现 Lean 本身。
对于许多应用来说，需要更大的标准库。

[std4](https://github.com/leanprover/std4) 是一个正在开发中的标准库，
包含许多数据结构、策略、类型类实例和函数，这些都超出了 Lean 编译器本身的范围。
要使用 std4，第一步是找到与您使用的 Lean 4 版本兼容的提交记录（即其中的 lean-toolchain
文件与您的项目匹配）。然后，将以下内容添加到您的 lakefile.lean 顶层，
其中 COMMIT_HASH 是适当的版本：

```lean
require std from git
  "https://github.com/leanprover/std4/" @ "COMMIT_HASH"
```

<!--
### Mathematics in Lean
-->

### Lean 形式化数学

<!--
Most resources for mathematicians are written for Lean 3. A wide selection are available at the community site. To get started doing mathematics in Lean 4, it is probably easiest to participate in the process of porting the mathematics library mathlib from Lean 3 to Lean 4. Please see the mathlib4 README for further information.
-->

大多数数学资源是为 Lean 3 编写的。
在[社区](https://leanprover-community.github.io/learn.html)网站上可以找到许多这样的资源。
要开始在 Lean 4 中进行数学研究，最简单的方法可能是参与将数学库 mathlib 从 Lean 3 迁移到 Lean 4 的过程。
有关更多信息，请参阅 [mathlib4 的 README](https://github.com/leanprover-community/mathlib4).

<!--
### Using Dependent Types in Computer Science
-->

### 在计算机科学中使用依值类型

<!--
Coq is a language that has a lot in common with Lean. For computer scientists, the Software Foundations series of interactive textbooks provides an excellent introduction to applications of Coq in computer science. The fundamental ideas of Lean and Coq are very similar, and skills are readily transferable between the systems.
-->

Coq 是一种与 Lean 有许多共同点的语言。对于计算机科学家来说，
《[软件基础](https://coq-zh.github.io/SF-zh/)》系列教材提供了一个很好的介绍，
介绍了 Coq 在计算机科学中的应用。Lean 和 Coq 的基本思想非常相似，
编程技巧在两个语言之间是可以相互转换的。

<!--
### Programming with Dependent Types
-->

### 使用依值类型编程

<!--
For programmers who are interested in learning to use indexed families and dependent types to structure programs, Edwin Brady's Type Driven Development with Idris provides an excellent introduction. Like Coq, Idris is a close cousin of Lean, though it lacks tactics.
-->

对于有兴趣学习使用索引族和依值类型来构建程序的程序员来说，Edwin Brady 的
《[Idris 类型驱动开发](https://www.manning.com/books/type-driven-development-with-idris)》
提供了一个很好的介绍。和 Coq 一样，Idris 是 Lean 的近亲语言，但是它缺乏策略。

<!--
### Understanding Dependent Types
-->

### 理解依值类型

<!--
The Little Typer is a book for programmers who haven't formally studied logic or the theory of programming languages, but who want to build an understanding of the core ideas of dependent type theory. While all of the above resources aim to be as practical as possible, The Little Typer presents an approach to dependent type theory where the very basics are built up from scratch, using only concepts from programming. Disclaimer: the author of Functional Programming in Lean is also an author of The Little Typer.
-->

《[The Little Typer](https://thelittletyper.com/)》是一本为没有正式学习过逻辑或编程语言理论，
但希望理解依值类型论核心思想的程序员准备的书。虽然上述所有资源都旨在实现尽可能的实用，
但这本书通过从头开始构建基础，使用仅来自编程的概念来呈现依值类型理论的方法。

免责声明：《Functional Programming in Lean》的作者也是《The Little Typer》的作者之一。
