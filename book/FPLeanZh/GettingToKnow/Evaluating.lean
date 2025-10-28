import VersoManual
import FPLeanZh.Examples

open Verso.Genre Manual
open Verso Code External

open FPLeanZh

example_module Examples.Intro

set_option verso.exampleProject "../examples"
set_option verso.exampleModule "Examples.Intro"

#doc (Manual) "求值表达式" =>
%%%
file := "Evaluating"
tag := "evaluating"
%%%
-- Evaluating Expressions

-- The most important thing to understand as a programmer learning Lean is how evaluation works.
-- Evaluation is the process of finding the value of an expression, just as one does in arithmetic.
-- For instance, the value of $`15 - 6` is $`9` and the value of $`2 × (3 + 1)` is $`8`.
-- To find the value of the latter expression, $`3 + 1` is first replaced by $`4`, yielding $`2 × 4`, which itself can be reduced to $`8`.
-- Sometimes, mathematical expressions contain variables: the value of $`x + 1` cannot be computed until we know what the value of $`x` is.
-- In Lean, programs are first and foremost expressions, and the primary way to think about computation is as evaluating expressions to find their values.

作为学习 Lean 的程序员，最重要的是理解求值的工作原理。求值是求得表达式的值的过程，就像算术那样。
例如，$`15 - 6` 的值为 $`9`，$`2 × (3 + 1)` 的值为 $`8`。要得到后一个表达式的值，首先将 $`3 + 1` 替换为 $`4`，
得到 $`2 × 4`，它本身又可以归约为 $`8`。有时，数学表达式包含变量：在知道 $`x` 的值之前，
无法计算 $`x + 1` 的值。在 Lean 中，程序首先是表达式，思考计算的主要方式是对表达式求值。

-- Most programming languages are _imperative_, where a program consists of a series of statements that should be carried out in order to find the program's result.
-- Programs have access to mutable memory, so the value referred to by a variable can change over time.
-- In addition to mutable state, programs may have other side effects, such as deleting files, making outgoing network connections,
-- throwing or catching exceptions, and reading data from a database.
-- “Side effects” is essentially a catch-all term for describing things that may happen in a program that don't follow the model of evaluating mathematical expressions.

大多数编程语言都是 *命令式的（Imperative）*，其中程序由一系列语句组成，
这些语句会按顺序执行以得到程序的结果。程序可以访问可变内存，
因此变量引用的值可以随时间而改变。除了可变状态外，程序还可能产生其他副作用，
例如删除文件、建立传出的网络连接、抛出或捕获异常以及从数据库读取数据等等。
"*副作用（Side Effect）*"本质上是一个统称，用于描述程序运行过程中可能发生的事情，
这些事情不遵循数学表达式求值的模型。

-- In Lean, however, programs work the same way as mathematical expressions.
-- Once given a value, variables cannot be reassigned. Evaluating an expression cannot have side effects.
-- If two expressions have the same value, then replacing one with the other will not cause the program to compute a different result.
-- This does not mean that Lean cannot be used to write {lit}`Hello, world!` to the console, but performing I/O is not a core part of the experience of using Lean in the same way.
-- Thus, this chapter focuses on how to evaluate expressions interactively with Lean, while the next chapter describes how to write, compile, and run the {lit}`Hello, world!` program.

然而，在 Lean 中，程序的工作方式与数学表达式相同。变量一旦被赋予一个值，
就不能再被重新赋值。求值表达式不会产生副作用。如果两个表达式的值相同，
那么用一个表达式替换另一个表达式并不会导致程序计算出不同的结果。
这并不意味着不能使用 Lean 向控制台写入 {lit}`Hello, world!`，而是执行 I/O
并不是以求值表达式的方式使用 Lean 的核心部分。因此，本章重点介绍如何使用
Lean 交互式地求值表达式，而下一章将介绍如何编写、编译并运行 {lit}`Hello, world!` 程序。

-- To ask Lean to evaluate an expression, write {kw}`#eval` before it in your editor, which will then report the result back.
-- Typically, the result is found by putting the cursor or mouse pointer over {kw}`#eval`.
-- For instance,

要让 Lean 对一个表达式求值，请在编辑器中的表达式前面加上 {kw}`#eval`，
然后它会返回结果。通常可以将光标或鼠标指针放在 {kw}`#eval` 上查看结果。例如，

```anchor threeEval
#eval 1 + 2
```

-- yields the value

会产生值

```anchorInfo threeEval
3
```

-- Lean obeys the ordinary rules of precedence and associativity for
-- arithmetic operators. That is,

Lean 遵循一般的算术运算符优先级和结合性规则。也就是说，

```anchor orderOfOperations
#eval 1 + 2 * 5
```

-- yields the value {anchorInfo orderOfOperations}`11` rather than {anchorInfo orderOfOperationsWrong}`15`.

会产生值 {anchorInfo orderOfOperations}`11` 而非 {anchorInfo orderOfOperationsWrong}`15`。

-- While both ordinary mathematical notation and the majority of programming languages use parentheses (e.g. {lit}`f(x)`) to apply a function to its arguments, Lean simply writes the function next to its arguments (e.g. {lit}`f x`).
-- Function application is one of the most common operations, so it pays to keep it concise.
-- Rather than writing

虽然普通的数学符号和大多数编程语言都使用括号（例如 {lit}`f(x)`）将函数应用到其参数上，
但 Lean 只是将参数写在函数后边（例如 {lit}`f x`）。
函数应用是最常见的操作之一，因此保持简洁很重要。与其编写

```
#eval String.append("Hello, ", "Lean!")
```

-- to compute {anchorInfo stringAppendHello}`"Hello, Lean!"`, one would instead write

来计算 {anchorInfo stringAppendHello}`"Hello, Lean!"`，不如编写

```anchor stringAppendHello
#eval String.append "Hello, " "Lean!"
```

-- where the function's two arguments are simply written next to it with spaces.

其中函数的两个参数只是写在后面用空格隔开。

-- Just as the order-of-operations rules for arithmetic demand parentheses in the expression {anchorTerm orderOfOperationsWrong}`(1 + 2) * 5`, parentheses are also necessary when a function's argument is to be computed via another function call.
-- For instance, parentheses are required in

就像算术运算的顺序需要在表达式中使用括号（如 {anchorTerm orderOfOperationsWrong}`(1 + 2) * 5`）表示一样，
当函数的参数需要通过另一个函数调用来计算时，括号也是必需的。例如，在

```anchor stringAppendNested
#eval String.append "great " (String.append "oak " "tree")
```

-- because otherwise the second {moduleTerm (anchor := stringAppendNested)}`String.append` would be interpreted as an argument to the first, rather than as a function being passed {moduleTerm (anchor := stringAppendNested)}`"oak "` and {moduleTerm (anchor := stringAppendNested)}`"tree"` as arguments.
-- The value of the inner {anchorTerm stringAppendNested}`String.append` call must be found first, after which it can be appended to {moduleTerm (anchor := stringAppendNested)}`"great "`, yielding the final value {anchorInfo stringAppendNested}`"great oak tree"`.

中需要括号，否则第二个 {moduleTerm (anchor := stringAppendNested)}`String.append` 将被解释为第一个函数的参数，而非一个接受 {moduleTerm (anchor := stringAppendNested)}`"oak "`
和 {moduleTerm (anchor := stringAppendNested)}`"tree"` 作为参数的函数。必须先得到内部 {anchorTerm stringAppendNested}`String.append` 调用的值，然后才能将其追加到
{moduleTerm (anchor := stringAppendNested)}`"great "` 后面，从而产生最终的值 {anchorInfo stringAppendNested}`"great oak tree"`。

-- Imperative languages often have two kinds of conditional: a conditional _statement_ that determines which instructions to carry out based on a Boolean value, and a conditional _expression_ that determines which of two expressions to evaluate based on a Boolean value.
-- For instance, in C and C++, the conditional statement is written using {c}`if` and {c}`else`, while the conditional expression is written with a ternary operator in which {c}`?` and {c}`:` separate the condition from the branches.
-- In Python, the conditional statement begins with {python}`if`, while the conditional expression puts {python}`if` in the middle.
-- Because Lean is an expression-oriented functional language, there are no conditional statements, only conditional expressions.
-- They are written using {kw}`if`, {kw}`then`, and {kw}`else`.
-- For example,

命令式语言通常有两种条件：根据布尔值确定要执行哪些指令的条件 *语句（Statement）*，
以及根据布尔值确定要计算两个表达式中哪一个的条件 *表达式（Expression）*。
例如，在 C 和 C++ 中，条件语句使用 {c}`if` 和 {c}`else` 编写，而条件表达式使用三元运算符 {c}`?` 和 {c}`:` 编写。
在 Python 中，条件语句以 {python}`if` 开头，而条件表达式则将 {python}`if` 放在中间。
由于 Lean 是一种面向表达式的函数式语言，因此没有条件语句，只有条件表达式。
条件表达式使用 {kw}`if`、{kw}`then` 和 {kw}`else` 编写。例如，

```anchorEvalStep stringAppend 0
String.append "it is " (if 1 > 2 then "yes" else "no")
```

-- evaluates to

会求值为

```anchorEvalStep stringAppend 1
String.append "it is " (if false then "yes" else "no")
```

-- which evaluates to

进而求值为

```anchorEvalStep stringAppend 2
String.append "it is " "no"
```

-- which finally evaluates to {anchorEvalStep stringAppend 3}`"it is no"`.

最终求值为 {anchorEvalStep stringAppend 3}`"it is no"`。

-- For the sake of brevity, a series of evaluation steps like this will sometimes be written with arrows between them:

为了简洁起见，这样的一系列求值步骤有时会用箭头连接起来：

```anchorEvalSteps stringAppend
String.append "it is " (if 1 > 2 then "yes" else "no")
===>
String.append "it is " (if false then "yes" else "no")
===>
String.append "it is " "no"
===>
"it is no"
```

-- # Messages You May Meet
# 可能遇到的消息
%%%
tag := "evaluating-messages"
%%%

-- Asking Lean to evaluate a function application that is missing an argument will lead to an error message.
-- In particular, the example

要求 Lean 求值一个缺少参数的函数应用会导致错误消息。特别是，例子

```anchor stringAppendReprFunction
#eval String.append "it is "
```

-- yields a quite long error message:

会产生一个相当长的错误消息：

```anchorError stringAppendReprFunction
could not synthesize a 'ToExpr', 'Repr', or 'ToString' instance for type
  String → String
```

-- This message occurs because Lean functions that are applied to only some of their arguments return new functions that are waiting for the rest of the arguments.
-- Lean cannot display functions to users, and thus returns an error when asked to do so.

出现此消息是因为 Lean 函数仅应用于某些参数时会返回等待其余参数的新函数。
Lean 无法将函数显示给用户，因此在被要求这样做时会返回错误。


-- # Exercises
# 练习
%%%
tag := "evaluating-exercises"
%%%

-- What are the values of the following expressions? Work them out by hand,
-- then enter them into Lean to check your work.

以下表达式的值是什么？先手工计算出来，然后在 Lean 中输入检查你的答案。

--  * {anchorTerm evalEx}`42 + 19`
--  * {anchorTerm evalEx}`String.append "A" (String.append "B" "C")`
--  * {anchorTerm evalEx}`String.append (String.append "A" "B") "C"`
--  * {anchorTerm evalEx}`if 3 == 3 then 5 else 7`
--  * {anchorTerm evalEx}`if 3 == 4 then "equal" else "not equal"`

 * {anchorTerm evalEx}`42 + 19`
 * {anchorTerm evalEx}`String.append "A" (String.append "B" "C")`
 * {anchorTerm evalEx}`String.append (String.append "A" "B") "C"`
 * {anchorTerm evalEx}`if 3 == 3 then 5 else 7`
 * {anchorTerm evalEx}`if 3 == 4 then "equal" else "not equal"`
