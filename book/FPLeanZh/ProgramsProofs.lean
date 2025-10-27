import VersoManual
import FPLeanZh.Examples

-- import FPLeanZh.ProgramsProofs.TailRecursion
-- import FPLeanZh.ProgramsProofs.TailRecursionProofs
-- import FPLeanZh.ProgramsProofs.ArraysTermination
-- import FPLeanZh.ProgramsProofs.Inequalities
-- import FPLeanZh.ProgramsProofs.Fin
-- import FPLeanZh.ProgramsProofs.InsertionSort
-- import FPLeanZh.ProgramsProofs.SpecialTypes
-- import FPLeanZh.ProgramsProofs.Summary


open Verso.Genre Manual
open Verso.Code.External

open FPLeanZh

set_option verso.exampleProject "../examples"
set_option verso.exampleModule "Examples.TODO"

-- Programming, Proving, and Performance
#doc (Manual) "编程、证明与性能" =>
%%%
tag := "programs-proofs-performance"
%%%

-- This chapter is about programming.
-- Programs need to compute the correct result, but they also need to do so efficiently.
-- To write efficient functional programs, it's important to know both how to use data structures appropriately and how to think about the time and space needed to run a program.

本章是关于编程的。程序不仅需要计算出正确的结果，还需要高效地执行。为了编写高效的功能程序，了解如何适当地使用数据结构，以及如何考虑运行程序所需的时间和空间非常重要。

-- This chapter is also about proofs.
-- One of the most important data structures for efficient programming in Lean is the array, but safe use of arrays requires proving that array indices are in bounds.
-- Furthermore, most interesting algorithms on arrays do not follow the pattern of structural recursion—instead, they iterate over the array.
-- While these algorithms terminate, Lean will not necessarily be able to automatically check this.
-- Proofs can be used to demonstrate why a program terminates.

本章也是关于证明的。在 Lean 中进行高效编程最重要的数据结构体之一是数组，但安全使用数组需要证明数组索引在边界内。此外，大多数有趣的数组算法并不遵循结构化递归模式。相反，它们会遍历数组。虽然这些算法会停机，但 Lean 不一定能够自动检查这一点。证明可以用来展示程序为什么会停机。

-- Rewriting programs to make them faster often results in code that is more difficult to understand.
-- Proofs can also show that two programs always compute the same answers, even if they do so with different algorithms or implementation techniques.
-- In this way, the slow, straightforward program can serve as a specification for the fast, complicated version.

重写程序使其运行得更快通常会导致代码更难理解。证明还可以表明两个程序始终会计算出相同的答案，即使它们使用不同的算法或实现技术。通过这种方式，缓慢、直白的程序可以作为快速、复杂版本的规范。

-- Combining proofs and programming allows programs to be both safe and efficient.
-- Proofs allow elision of run-time bounds checks, they render many tests unnecessary, and they provide an extremely high level of confidence in a program without introducing any runtime performance overhead.
-- However, proving theorems about programs can be time consuming and expensive, so other tools are often more economical.

将证明和编程相结合，可以使程序既安全又高效。证明允许省略运行时边界检查，它们使许多测试变得不必要，并且它们在不引入任何运行时性能开销的情况下为程序提供了极高的置信度。然而，证明程序的定理可能是耗时且昂贵的，因此其他工具通常更经济。

-- Interactive theorem proving is a deep topic.
-- This chapter provides only a taste, oriented towards the proofs that come up in practice while programming in Lean.
-- Most interesting theorems are not closely related to programming.
-- Please refer to {ref "next-steps"}[Next Steps] for a list of resources for learning more.
-- Just as when learning programming, however, there's no substitute for hands-on experience when learning to write proofs—it's time to get started!

交互式定理证明是一个深刻的话题。本章仅提供一个示例，面向在 Lean 中编程时出现的证明。大多数有趣的定理与编程没有密切关系。请参阅 {ref "next-steps"}[继续学习] 以获取更多学习资源的列表。然而，就像学习编程一样，在学习编写证明时，没有什么是可以替代实践经验的——是时候开始了！
