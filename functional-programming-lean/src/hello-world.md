# Hello, World!

<!--
While Lean has been designed to have a rich interactive environment in which programmers can get quite a lot of feedback from the language without leaving the confines of their favorite text editor, it is also a language in which real programs can be written.
This means that it also has a batch-mode compiler, a build system, a package manager, and all the other tools that are necessary for writing programs.
-->

虽然 Lean 被设计为一个丰富的交互式环境，程序员可以在不离开他们最喜欢的文本编辑器的情况下，
从语言中获得相当多的反馈，但它也是一门可以编写现实程序的语言。
这意味着它还具有批处理模式编译器、构建系统、包管理器以及编写程序所需的所有其他工具。

<!--
While the [previous chapter](./getting-to-know.md) presented the basics of functional programming in Lean, this chapter explains how to start a programming project, compile it, and run the result.
Programs that run and interact with their environment (e.g. by reading input from standard input or creating files) are difficult to reconcile with the understanding of computation as the evaluation of mathematical expressions.
In addition to a description of the Lean build tools, this chapter also provides a way to think about functional programs that interact with the world.
-->

[上一章](./getting-to-know.md)介绍了 Lean 中函数式编程的基础知识，
本章将解释如何开始一个编程项目、编译它并运行结果。
运行并与其环境交互的程序（例如通过读取标准输入或创建文件）
很难与将计算理解为数学表达式的求值相协调。除了对 Lean 构建工具的描述之外，
本章还提供了一种思考与世界交互的函数式程序的方法。
