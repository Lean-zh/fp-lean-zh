import VersoManual
import FPLeanZh.Examples
import FPLeanZh.GettingToKnow.Evaluating
import FPLeanZh.GettingToKnow.Types
import FPLeanZh.GettingToKnow.FunctionsDefinitions
import FPLeanZh.GettingToKnow.Structures
import FPLeanZh.GettingToKnow.DatatypesPatterns
import FPLeanZh.GettingToKnow.Polymorphism
import FPLeanZh.GettingToKnow.Conveniences
import FPLeanZh.GettingToKnow.Summary

open Verso.Genre Manual
open Verso Code External

open FPLeanZh

set_option verso.exampleProject "../examples"
set_option verso.exampleModule "Examples.Hello"


#doc (Manual) "了解 Lean" =>
%%%
tag := "getting-to-know"
%%%

-- According to tradition, a programming language should be introduced by compiling and running a program that displays {moduleTerm}`"Hello, world!"` on the console.
-- This simple program ensures that the language tooling is installed correctly and that the programmer is able to run the compiled code.

按照惯例，介绍一门编程语言通常会编译并运行一个在控制台上显示「Hello, world!」的程序。这个简单的程序能确保语言工具安装正确，且程序员能够运行已编译的代码。

-- Since the 1970s, however, programming has changed.
-- Today, compilers are typically integrated into text editors, and the programming environment offers feedback as the program is written.
-- Lean is no exception: it implements an extended version of the Language Server Protocol that allows it to communicate with a text editor and provide feedback as the user types.

然而，自 20 世纪 70 年代以来，编程发生了许多变化。如今，编译器通常集成到了文本编辑器中，编程环境会在编写程序时提供反馈。
Lean 也是如此：它实现了语言服务器协议（Language Server Protocol，LSP）的扩展版本，允许它与文本编辑器通信并在用户键入时提供反馈。

-- Languages as varied as Python, Haskell, and JavaScript offer a read-eval-print-loop (REPL), also known as an interactive toplevel or a browser console, in which expressions or statements can be entered.
-- The language then computes and displays the result of the user's input.
-- Lean, on the other hand, integrates these features into the interaction with the editor, providing commands that cause the text editor to display feedback integrated into the program text itself.
-- This chapter provides a short introduction to interacting with Lean in an editor, while {ref "hello-world"}[Hello, World!] describes how to use Lean traditionally from the command line in batch mode.

-- It is best if you read this book with Lean open in your editor, following along and typing in each example. Please play with the
-- examples, and see what happens!

从 Python、Haskell 到 JavaScript 等各种语言都提供*读取-求值-打印-循环（REPL）*，
也称为交互式顶层环境或浏览器控制台，可以在其中输入表达式或语句。然后，该语言会计算并显示用户输入的结果。另一方面，Lean 将这些特性集成到了与编辑器的交互中，它提供的命令能让文本编辑器将程序的反馈集成到程序文本中。本章简要介绍了在编辑器中与 Lean 的交互，而 {ref "hello-world"}[Hello, World!] 则描述了如何在批处理模式下以传统的命令行方式使用 Lean。

阅读本书最好的方式是在编辑器中打开 Lean，输入书中的每个示例并运行他们，然后看看会发生什么。

{include 1 FPLeanZh.GettingToKnow.Evaluating}

{include 1 FPLeanZh.GettingToKnow.Types}

{include 1 FPLeanZh.GettingToKnow.FunctionsDefinitions}

{include 1 FPLeanZh.GettingToKnow.Structures}

{include 1 FPLeanZh.GettingToKnow.DatatypesPatterns}

{include 1 FPLeanZh.GettingToKnow.Polymorphism}

{include 1 FPLeanZh.GettingToKnow.Conveniences}

{include 1 FPLeanZh.GettingToKnow.Summary}
