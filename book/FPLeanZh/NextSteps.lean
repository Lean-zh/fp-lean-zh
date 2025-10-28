import VersoManual
import FPLeanZh.Examples

open Verso.Genre Manual
open Verso.Code.External

open FPLeanZh

-- Next Steps
%%%
file := "NextSteps"
%%%
#doc (Manual) "继续学习" =>
%%%
tag := "next-steps"
htmlSplit := .never
%%%

-- This book introduces the very basics of functional programming in Lean, including a tiny amount of interactive theorem proving.
-- Using dependently-typed functional languages like Lean is a deep topic, and much can be said.
-- Depending on your interests, the following resources might be useful for learning Lean 4.

本书介绍了 Lean 中函数式编程的基本知识，包括一些互动定理证明的内容。使用依值类型的函数式语言（如 Lean）是一个深奥的主题，内容丰富。根据您的兴趣，以下资源可能对学习 Lean 4 有用。

-- # Learning Lean
# "学习 Lean"
%%%
tag := "learning-lean"
%%%

-- Lean 4 itself is described in the following resources:

--  * [Theorem Proving in Lean 4](https://lean-lang.org/theorem_proving_in_lean4/) is a tutorial on writing proofs using Lean.
--  * [The Lean 4 Manual](https://lean-lang.org/doc/reference/latest/) provides a detailed description of the language and its features.
--  * [How To Prove It With Lean](https://djvelleman.github.io/HTPIwL/) is a Lean-based accompaniment to the well-regarded textbook [_How To Prove It_](https://www.cambridge.org/highereducation/books/how-to-prove-it/6D2965D625C6836CD4A785A2C843B3DA) that provides an introduction to writing paper-and-pencil mathematical proofs.
--  * [Metaprogramming in Lean 4](https://github.com/arthurpaulino/lean4-metaprogramming-book) provides an overview of Lean's extension mechanisms, from infix operators and notations to macros, custom tactics, and full-on custom embedded languages.
--  * [Functional Programming in Lean](https://lean-lang.org/functional_programming_in_lean/) may be interesting to readers who enjoy jokes about recursion.

Lean 4 本身在以下资源中有详细描述：

* [Lean 4 定理证明](https://lean-lang.org/theorem_proving_in_lean4/) 是一篇使用 Lean 编写证明的教程。
* [Lean 4 手册](https://lean-lang.org/doc/reference/latest/) 提供了对语言及其特性的详细描述。
* [怎样用 Lean 证明数学题](https://djvelleman.github.io/HTPIwL/) 是一篇 Lean 支持的配套书籍 [_怎样证明数学题_](https://www.cambridge.org/highereducation/books/how-to-prove-it/6D2965D625C6836CD4A785A2C843B3DA) 的介绍，提供了编写纸笔数学证明的入门。
* [Lean 4 元编程](https://github.com/arthurpaulino/lean4-metaprogramming-book) 提供了对 Lean 扩展机制的概览，从中缀运算符和记号到宏、自定义策略，甚至完整的自定义嵌入式语言。
* [Lean 4 函数式编程](https://lean-lang.org/functional_programming_in_lean/) 可能对喜欢递归笑话的读者感兴趣。

-- However, the best way to continue learning Lean is to start reading and writing code, consulting the documentation when you get stuck.
-- Additionally, the [Lean Zulip](https://leanprover.zulipchat.com/) is an excellent place to meet other Lean users, ask for help, and help others.

继续学习 Lean 的最佳方式是开始阅读和编写代码，在遇到困难时查阅文档。此外， [Lean Zulip](https://leanprover.zulipchat.com/) 是结识其他 Lean 用户、寻求帮助和帮助他人的好地方。

-- # Mathematics in Lean
# Lean 形式化数学
%%%
tag := "nextsteps_mathematics-in-lean"
%%%

-- A wide selection of learning resources for mathematicians are available at [the community site](https://leanprover-community.github.io/learn.html).

数学学习资源广泛分布在 [社区网站](https://leanprover-community.github.io/learn.html) 上。

-- # Using Dependent Types in Computer Science
# 在计算机科学中使用依值类型
%%%
tag := "nextsteps_dependent-types-computer-science"
%%%

-- Rocq is a language that has a lot in common with Lean.
-- For computer scientists, the [Software Foundations](https://softwarefoundations.cis.upenn.edu/) series of interactive textbooks provides an excellent introduction to applications of Rocq in computer science.
-- The fundamental ideas of Lean and Rocq are very similar, and skills are readily transferable between the systems.

Rocq 是一种与 Lean 有许多共同点的语言。对于计算机科学家来说，
《[软件基础](https://coq-zh.github.io/SF-zh/)》系列教材提供了一个很好的介绍，
介绍了 Rocq 在计算机科学中的应用。Lean 和 Rocq 的基本思想非常相似，
编程技巧在两个语言之间是可以相互转换的。

-- # Programming with Dependent Types
# 使用依值类型编程
%%%
tag := "nextsteps_programming-dependent-types"
%%%

-- For programmers who are interested in learning to use indexed families and dependent types to structure programs, Edwin Brady's [_Type Driven Development with Idris_](https://www.manning.com/books/type-driven-development-with-idris) provides an excellent introduction.
-- Like Rocq, Idris is a close cousin of Lean, though it lacks tactics.

对有兴趣学习使用索引族和依值类型来结构化程序的程序员来说，Edwin Brady 的 [_Type Driven Development with Idris_](https://www.manning.com/books/type-driven-development-with-idris) 提供了一个很好的介绍。像 Rocq 一样，Idris 是 Lean 的近亲，尽管它缺乏策略。

-- # Understanding Dependent Types
# 理解依值类型
%%%
tag := "nextsteps_understanding-dependent-types"
%%%

-- [_The Little Typer_](https://thelittletyper.com/) is a book for programmers who haven't formally studied logic or the theory of programming languages, but who want to build an understanding of the core ideas of dependent type theory.
-- While all of the above resources aim to be as practical as possible, _The Little Typer_ presents an approach to dependent type theory where the very basics are built up from scratch, using only concepts from programming.
-- Disclaimer: the author of _Functional Programming in Lean_ is also an author of _The Little Typer_.

[_The Little Typer_](https://thelittletyper.com/) 是一本为没有正式学习过逻辑或编程语言理论，但希望理解依值类型论核心思想的程序员准备的书。虽然上述所有资源都旨在实现尽可能的实用，但这本书通过从头开始构建基础，使用仅来自编程的概念来呈现依值类型理论的方法。

免责声明：《Lean 4 函数式编程》的作者也是 _The Little Typer_ 的作者之一。
