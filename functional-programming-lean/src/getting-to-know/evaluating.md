<!--
# Evaluating Expressions
-->

# 求值表达式

<!--
The most important thing to understand as a programmer learning Lean
is how evaluation works. Evaluation is the process of finding the
value of an expression, just as one does in arithmetic. For instance,
the value of 15 - 6 is 9 and the value of 2 × (3 + 1) is 8.
To find the value of the latter expression, 3 + 1 is first replaced by 4, yielding 2 × 4, which itself can be reduced to 8.
Sometimes, mathematical expressions contain variables: the value of _x_ + 1 cannot be computed until we know what the value of _x_ is.
In Lean, programs are first and foremost expressions, and the primary way to think about computation is as evaluating expressions to find their values.
-->

作为学习 Lean 的程序员，最重要的是理解求值的工作原理。求值是得到表达式的值的过程，就像算术那样。
例如，15 - 6 的值为 9，2 × (3 + 1) 的值为 8。要得到后一个表达式的值，首先将 3 + 1 替换为 4，
得到 2 × 4，它本身可以简化为 8。有时，数学表达式包含变量：在知道 *x* 的值之前，
无法计算 *x* + 1 的值。在 Lean 中，程序首先是表达式，思考计算的主要方式是对表达式求值以得到其值。

<!--
Most programming languages are _imperative_, where a program consists
of a series of statements that should be carried out in order to find
the program's result. Programs have access to mutable memory, so the
value referred to by a variable can change over time. In addition to mutable state, programs may have other side
effects, such as deleting files, making outgoing network connections,
throwing or catching exceptions, and reading data from a
database. "Side effects" is essentially a catch-all term for
describing things that may happen in a program that don't follow the
model of evaluating mathematical expressions.
-->

大多数编程语言都是   **命令式的** ，其中程序由一系列语句组成，
这些语句应按顺序执行以找到程序的结果。程序可以访问可变内存，
因此变量引用的值可以随时间而改变。除了可变状态之外，程序还可能产生其他副作用，
例如删除文件、建立传出网络连接、抛出或捕获异常以及从数据库读取数据。
「副作用（Side Effect）」本质上是一个统称，用于描述程序中可能发生的事情，
这些事情不遵循求值数学表达式的模型。

<!--
In Lean, however, programs work the same way as mathematical
expressions. Once given a value, variables cannot be reassigned. Evaluating an expression cannot have side effects. If two
expressions have the same value, then replacing one with the other
will not cause the program to compute a different result. This does
not mean that Lean cannot be used to write `Hello, world!` to the
console, but performing I/O is not a core part of the experience of
using Lean in the same way. Thus, this chapter focuses on how to
evaluate expressions interactively with Lean, while the next chapter
describes how to write, compile, and run the `Hello, world!` program.
-->

然而，在 Lean 中，程序的工作方式与数学表达式相同。一旦赋予一个值，变量就不能重新赋值。
求值表达式不会产生副作用。如果两个表达式具有相同的值，
那么用一个表达式替换另一个表达式不会导致程序计算出不同的结果。
这并不意味着 Lean 不能用于向控制台写入 `Hello, world!`，而是执行 I/O
并不是以同样的方式使用 Lean 的核心部分。因此，本章重点介绍如何使用 Lean
交互式地求值表达式，而下一章将介绍如何编写、编译并运行 `Hello, world!` 程序。

<!--
To ask Lean to evaluate an expression, write `#eval` before it in your
editor, which will then report the result back. Typically, the result
is found by putting the cursor or mouse pointer over `#eval`. For
instance,
-->

要让 Lean 对一个表达式求值，请在编辑器中该表达式的前面加上 `#eval`，然后它将报告结果。
通常可通过将光标或鼠标指针放在 `#eval` 上来查看结果。例如，

```lean
#eval {{#example_in Examples/Intro.lean three}}
```

<!--
yields the value `{{#example_out Examples/Intro.lean three}}`.
-->

会产生值 `{{#example_out Examples/Intro.lean three}}`。

<!--
Lean obeys the ordinary rules of precedence and associativity for
arithmetic operators. That is,
-->

Lean 遵循一般的算术运算符优先级和结合性规则。也就是说，

```lean
{{#example_in Examples/Intro.lean orderOfOperations}}
```

<!--
yields the value `{{#example_out Examples/Intro.lean orderOfOperations}}` rather than
`{{#example_out Examples/Intro.lean orderOfOperationsWrong}}`.
-->

会产生值 `{{#example_out Examples/Intro.lean orderOfOperations}}` 而非
`{{#example_out Examples/Intro.lean orderOfOperationsWrong}}`。

<!--
While both ordinary mathematical notation and the majority of
programming languages use parentheses (e.g. `f(x)`) to apply a function to its
arguments, Lean simply writes the function next to its
arguments (e.g. `f x`). Function application is one of the most common operations,
so it pays to keep it concise. Rather than writing
-->

"虽然普通的数学符号和大多数编程语言都使用括号（例如 `f(x)`）将函数应用于其参数，
但 Lean 只是将函数写在其参数后边（例如 `f x`）。
函数应用是最常见的操作之一，因此保持简洁很重要。与其编写

```lean
#eval String.append("Hello, ", "Lean!")
```

<!--
to compute `{{#example_out Examples/Intro.lean stringAppendHello}}`,
one would instead write
-->

来计算 `{{#example_out Examples/Intro.lean stringAppendHello}}`，不如编写

``` Lean
{{#example_in Examples/Intro.lean stringAppendHello}}
```

<!--
where the function's two arguments are simply written next to
it with spaces.
-->

其中函数的两个参数只是用空格隔开写在后面。

<!--
Just as the order-of-operations rules for arithmetic demand
parentheses in the expression `(1 + 2) * 5`, parentheses are also
necessary when a function's argument is to be computed via another
function call. For instance, parentheses are required in
-->

就像算术运算的顺序规则需要在表达式中使用括号（如 `(1 + 2) * 5`）表示一样，
当函数的参数需要通过另一个函数调用来计算时，括号也是必需的。例如，在

``` Lean
{{#example_in Examples/Intro.lean stringAppendNested}}
```

<!--
because otherwise the second `String.append` would be interpreted as
an argument to the first, rather than as a function being passed
`"oak "` and `"tree"` as arguments. The value of the inner `String.append`
call must be found first, after which it can be appended to `"great "`,
yielding the final value `{{#example_out Examples/Intro.lean stringAppendNested}}`.
-->

中需要括号，否则第二个 `String.append` 将被解释为第一个参数，而非作为接受 `"oak "`
和 `"tree"` 作为参数的函数。必须先得到内部 `String.append` 调用的值，然后才能将其传入到
`"great "`，从而产生最终的值 `{{#example_out Examples/Intro.lean stringAppendNested}}`。

<!--
Imperative languages often have two kinds of conditional: a
conditional _statement_ that determines which instructions to carry
out based on a Boolean value, and a conditional _expression_ that
determines which of two expressions to evaluate based on a Boolean
value. For instance, in C and C++, the conditional statement is
written using `if` and `else`, while the conditional expression is
written with a ternary operator `?` and `:`. In Python, the
conditional statement begins with `if`, while the conditional
expression puts `if` in the middle.
Because Lean is an expression-oriented functional language, there are no conditional statements, only conditional expressions.
They are written using `if`, `then`, and `else`. For
instance,
-->

命令式语言通常有两种条件：根据布尔值确定要执行哪些指令的条件  **语句（Statement）** ，
以及根据布尔值确定要计算两个表达式中哪一个的条件  **表达式（Expression）** 。
例如，在 C 和 C++ 中，条件语句使用 `if` 和 `else` 编写，而条件表达式使用三元运算符 `?` 和 `:` 编写。
在 Python 中，条件语句以 `if` 开头，而条件表达式则将 `if` 放在中间。
由于 Lean 是一种面向表达式的函数式语言，因此没有条件语句，只有条件表达式。
条件表达式使用 `if`、`then` 和 `else` 编写。例如，

``` Lean
{{#example_eval Examples/Intro.lean stringAppend 0}}
```

<!--
evaluates to
-->

会求值为

``` Lean
{{#example_eval Examples/Intro.lean stringAppend 1}}
```

<!--
which evaluates to
-->

进而求值为

```lean
{{#example_eval Examples/Intro.lean stringAppend 2}}
```

<!--
which finally evaluates to `{{#example_eval Examples/Intro.lean stringAppend 3}}`.
-->

最终求值为 `{{#example_eval Examples/Intro.lean stringAppend 3}}`。

<!--
For the sake of brevity, a series of evaluation steps like this will sometimes be written with arrows between them:
-->

为简洁起见，有时会用箭头表示一系列求值步骤：

```lean
{{#example_eval Examples/Intro.lean stringAppend}}
```

<!--
## Messages You May Meet
-->

## 可能会遇到的信息

<!--
Asking Lean to evaluate a function application that is missing an argument will lead to an error message.
In particular, the example
-->

让 Lean 对缺少参数的函数应用进行求值会产生错误信息。具体来说，例如

```lean
{{#example_in Examples/Intro.lean stringAppendReprFunction}}
```

<!--
yields a quite long error message:
-->

会产生一个很长的错误信息：

```output error
{{#example_out Examples/Intro.lean stringAppendReprFunction}}
```

```output error
表达式
  String.append "it is "
类型为
  String → String
但实例
  Lean.MetaEval (String → String)
合成失败，此实例指示 Lean 如何显示结果值，回想一下任何实现了
`Repr` 类的类型也实现了 `Lean.MetaEval` 类。
```

<!--
This message occurs because Lean functions that are applied to only some of their arguments return new functions that are waiting for the rest of the arguments.
Lean cannot display functions to users, and thus returns an error when asked to do so.
-->

会出现此信息是因为在 Lean 中，仅接受了部分参数的函数会返回一个等待其余参数的新函数。
Lean 无法向用户显示函数，因此在被要求这样做时会返回错误。

<!--
## Exercises
-->

## 练习

<!--
What are the values of the following expressions? Work them out by hand,
then enter them into Lean to check your work.
-->

以下表达式的值是什么？请手动计算，然后输入 Lean 来检查你的答案。

 * `42 + 19`
 * `String.append "A" (String.append "B" "C")`
 * `String.append (String.append "A" "B") "C"`
 * `if 3 == 3 then 5 else 7`
 * `if 3 == 4 then "equal" else "not equal"`
