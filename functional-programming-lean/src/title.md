<!--
# Functional Programming in Lean
-->

# Lean 函数式编程

<!--
*by David Thrane Christiansen*

*Copyright Microsoft Corporation 2023*
-->

*作者：David Thrane Christiansen*

*版权所有：Microsoft Corporation 2023*

**[Lean-zh 项目组](https://github.com/orgs/Lean-zh) 译**

<!--
This is a free book on using Lean 4 as a programming language. All code samples are tested with Lean 4 release `{{#lean_version}}`.
-->

这是一本自由书籍，介绍如何使用 Lean 4 作为编程语言。所有代码示例均经过 Lean 4 版本 `{{#lean_version}}` 验证。

<!--
## Release history
-->

## 发行历史

<!--
### January, 2024

This is a minor bugfix release that fixes a regression in an example program.
-->

### 2024 年 1 月

这是一个次要的 bug 修复版本，修复了示例程序中一个回退问题。

<!--
### October, 2023

In this first maintenance release, a number of smaller issues were fixed and the text was brought up to date with the latest release of Lean.
-->

### 2023 年 10 月

在首次维护版本中，修复了许多较小的错误，并根据 Lean 的最新版本更新了文本。


<!--
### May, 2023

The book is now complete! Compared to the April pre-release, many small details have been improved and minor mistakes have been fixed.
-->

### 2023 年 5 月

本书现已完成！与 4 月份的预发布版本相比，许多小细节得到了改进，并修复了一些小错误。

<!--
### April, 2023

This release adds an interlude on writing proofs with tactics as well as a final chapter that combines discussion of performance and cost models with proofs of termination and program equivalence.
This is the last release prior to the final release.
-->

### 2023 年 4 月

此版本添加了关于使用策略编写证明的插曲，以及添加了将性能和成本模型的讨论，与停机证明和程序等价性证明相结合的最后一章。这是最终版本前的最后一个版本。

<!--
### March, 2023

This release adds a chapter on programming with dependent types and indexed families.
-->

### 2023 年 3 月

此版本添加了关于使用依值类型和索引族编程的章节。

<!--
### January, 2023

This release adds a chapter on monad transformers that includes a description of the imperative features that are available in `do`-notation.
-->

### 2023 年 1 月

此版本添加了关于单子变换器的章节，其中包括对 `do`-记法中可用的命令式特性的描述。

<!--
### December, 2022

This release adds a chapter on applicative functors that additionally describes structures and type classes in more detail.
This is accompanied with improvements to the description of monads.
The December 2022 release was delayed until January 2023 due to winter holidays.
-->

### 2022 年 12 月

此版本添加了关于应用函子的章节，此外还更加详细地描述了结构和类型类。此外改进了对单子的描述。由于冬季假期，2022 年 12 月版本被推迟到 2023 年 1 月。

<!--
### November, 2022

This release adds a chapter on programming with monads. Additionally, the example of using JSON in the coercions section has been updated to include the complete code.
-->

### 2022 年 11 月

此版本添加了关于使用单子编程的章节。此外，强制转换一节中使用 JSON 的示例已更新为包含完整代码。
<!--
### October, 2022

This release completes the chapter on type classes. In addition, a short interlude introducing propositions, proofs, and tactics has been added just before the chapter on type classes, because a small amount of familiarity with the concepts helps to understand some of the standard library type classes.
-->

### 2022 年 10 月

此版本完成了类型类的章节。此外，在类型类章节之前添加了一个简短的插曲，介绍了命题、证明和策略，因为简单了解一下这些概念有助于理解一些标准库中的类型类。

<!--
### September, 2022

This release adds the first half of a chapter on type classes, which are Lean's mechanism for overloading operators and an important means of organizing code and structuring libraries. Additionally, the second chapter has been updated to account for changes in Lean's stream API.
-->

### 2022 年 9 月

此版本添加了一个关于类型类的章节的前半部分，这是 Lean 的运算符重载机制，也是组织代码和构建函数库的重要手段。此外，还更新了第二章以适应 Lean 中 Stream 流 API 的变化。

<!--
### August, 2022

This third public release adds a second chapter, which describes compiling and running programs along with Lean's model for side effects.
-->

### 2022 年 8 月

第三次公开发布增加了第二章，其中描述了编译和运行程序以及 Lean 的副作用模型。

<!--
### July, 2022

The second public release completes the first chapter.
-->

### 2022 年 7 月

第二次公开发布，完成了第一章。

<!--
### June, 2022

This was the first public release, consisting of an introduction and part of the first chapter.
-->

### 2022 年 6 月

这是第一次公开发布，包括引言和第一章的一部分。

<!--
## About the Author
-->

## 关于作者

<!--
David Thrane Christiansen has been using functional languages for twenty years, and dependent types for ten.
Together with Daniel P. Friedman, he wrote [_The Little Typer_](https://thelittletyper.com/), an introduction to the key ideas of dependent type theory.
He has a Ph.D. from the IT University of Copenhagen.
During his studies, he was a major contributor to the first version of the Idris language.
Since leaving academia, he has worked as a software developer at Galois in Portland, Oregon and Deon Digital in Copenhagen, Denmark, and he was the Executive Director of the Haskell Foundation.
At the time of writing, he is employed at the [Lean Focused Research Organization](https://lean-fro.org) working full-time on Lean.
-->

David Thrane Christiansen 已使用函数式语言二十年，并使用依值类型十年。他与 Daniel P. Friedman 合著了《[*The Little Typer*](https://thelittletyper.com/)》，介绍了依值类型论的关键思想。他拥有哥本哈根 IT 大学的博士学位。在学习期间，他为 Idris 语言的第一个版本做出了重大贡献。离开学术界后，他曾在俄勒冈州波特兰的 Galois 和丹麦哥本哈根的 Deon Digital 担任软件开发人员，并担任 Haskell 基金会执行董事。在撰写本文时，他受雇于 [Lean 专注研究组织](https://lean-fro.org)，全职从事 Lean 的工作。"

<!--
## License

<a rel="license" href="http://creativecommons.org/licenses/by/4.0/"><img alt="Creative Commons License" style="border-width:0" src="https://i.creativecommons.org/l/by/4.0/88x31.png" /></a><br />This work is licensed under a <a rel="license" href="http://creativecommons.org/licenses/by/4.0/">Creative Commons Attribution 4.0 International License</a>.
-->

## 授权许可

<a rel="license" href="http://creativecommons.org/licenses/by/4.0/"><img alt="Creative Commons License" style="border-width:0" src="https://i.creativecommons.org/l/by/4.0/88x31.png" /></a><br />本作品采用<a rel="license" href="http://creativecommons.org/licenses/by/4.0/">知识共享-署名 4.0 国际许可协议</a>授权。
