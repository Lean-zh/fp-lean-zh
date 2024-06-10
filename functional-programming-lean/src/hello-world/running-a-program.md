<!--
# Running a Program
-->

# 运行程序

<!--
The simplest way to run a Lean program is to use the `--run` option to the Lean executable.
Create a file called `Hello.lean` and enter the following contents:
-->

运行 Lean 程序最简单的方法是使用 Lean 可执行文件的 `--run` 选项。
创建一个名为 `Hello.lean` 的文件并输入以下内容：

```lean
{{#include ../../../examples/simple-hello/Hello.lean}}
```

<!--
Then, from the command line, run:
-->

然后，在命令行运行：

```
{{#command {simple-hello} {hello} {lean --run Hello.lean} }}
```

<!--
The program displays `{{#command_out {hello} {lean --run Hello.lean} }}` and exits.
-->

该程序会在显示 `{{#command_out {hello} {lean --run Hello.lean} }}` 后退出。

<!--
## Anatomy of a Greeting
-->

## 打招呼程序的剖析

<!--
When Lean is invoked with the `--run` option, it invokes the program's `main` definition.
In programs that do not take command-line arguments, `main` should have type `IO Unit`.
This means that `main` is not a function, because there are no arrows (`→`) in its type.
Instead of being a function that has side effects, `main` consists of a description of effects to be carried out.
-->

当使用 `--run` 选项调用 Lean 时，它会调用程序的 `main` 定义。
对于不从命令行接受参数的程序，`main` 的类型应该是 `IO Unit`。
这意味着 `main` 不是一个函数，因为它的类型中没有箭头（`→`）。
`main` 不是一个具有副作用的函数，而是由要执行的副作用描述组成。

<!--
As discussed in [the preceding chapter](../getting-to-know/polymorphism.md), `Unit` is the simplest inductive type.
It has a single constructor called `unit` that takes no arguments.
Languages in the C tradition have a notion of a `void` function that does not return any value at all.
In Lean, all functions take an argument and return a value, and the lack of interesting arguments or return values can be signaled by using the `Unit` type instead.
If `Bool` represents a single bit of information, `Unit` represents zero bits of information.
-->

如[上一章](../getting-to-know/polymorphism.md)所述，`Unit` 是最简单的归纳类型。
它有一个名为 `unit` 的构造子，不接受任何参数。C 传统的语言中有一个 `void` 函数的概念，
它不返回任何值。在 Lean 中，所有函数都接受一个参数并返回一个值，
而使用 `Unit` 类型可以表示没什么参数或返回值。如果 `Bool` 表示一个比特的信息，
那么 `Unit` 就表示零比特的信息。

<!--
`IO α` is the type of a program that, when executed, will either throw an exception or return a value of type `α`.
During execution, this program may have side effects.
These programs are referred to as `IO` _actions_.
Lean distinguishes between _evaluation_ of expressions, which strictly adheres to the mathematical model of substitution of values for variables and reduction of sub-expressions without side effects, and _execution_ of `IO` actions, which rely on an external system to interact with the world.
`IO.println` is a function from strings to `IO` actions that, when executed, write the given string to standard output.
Because this action doesn't read any interesting information from the environment in the process of emitting the string, `IO.println` has type `String → IO Unit`.
If it did return something interesting, then that would be indicated by the `IO` action having a type other than `Unit`.
-->

`IO α` 是一个程序的类型，当执行时，它要么抛出一个异常，要么返回一个类型为 `α` 的值。
在执行期间，此程序可能会产生副作用。这些程序被称为 `IO` **活动（Action）** 。
Lean 区分表达式的 **求值（Evaluation）** （严格遵循用变量值替换值和无副作用地归约子表达式的数学模型）
和 `IO` 活动的 **执行（Execution）** （依赖于外部系统与世界交互）。
`IO.println` 是一个从字符串到 `IO` 活动的函数，当执行时，它将给定的字符串写入标准输出。
由于此活动在发出字符串的过程中不会从环境中读取任何有趣的信息，
因此 `IO.println` 的类型为 `String → IO Unit`。如果它确实返回了一些有趣的东西，
那么这将通过 `Unit` 类型以外的 `IO` 活动来表示。


<!--
## Functional Programming vs Effects
-->

## 函数式编程与副作用

<!--
Lean's model of computation is based on the evaluation of mathematical expressions, in which variables are given exactly one value that does not change over time.
The result of evaluating an expression does not change, and evaluating the same expression again will always yield the same result.
-->

Lean 的计算模型基于数学表达式的求值，其中变量会被赋予一个不会随时间变化的精确值。
求值表达式的结果不会改变，再次求值相同的表达式将始终产生相同的结果。

<!--
On the other hand, useful programs must interact with the world.
A program that performs neither input nor output can't ask a user for data, create files on disk, or open network connections.
Lean is written in itself, and the Lean compiler certainly reads files, creates files, and interacts with text editors.
How can a language in which the same expression always yields the same result support programs that read files from disk, when the contents of these files might change over time?
-->

另一方面，有用的程序必须与世界交互。既不进行输入也不进行输出的程序无法向用户询问数据、
创建磁盘文件或打开网络连接。Lean 是用它自己编写的，而 Lean 编译器当然会读取文件、
创建文件并与文本编辑器交互。当这些文件的内容可能随时间而改变时，
一种相同的表达式总是产生相同结果的语言，要如何支持从磁盘读取文件的程序？

<!--
This apparent contradiction can be resolved by thinking a bit differently about side effects.
Imagine a café that sells coffee and sandwiches.
This café has two employees: a cook who fulfills orders, and a worker at the counter who interacts with customers and places order slips.
The cook is a surly person, who really prefers not to have any contact with the world outside, but who is very good at consistently delivering the food and drinks that the café is known for.
In order to do this, however, the cook needs peace and quiet, and can't be disturbed with conversation.
The counter worker is friendly, but completely incompetent in the kitchen.
Customers interact with the counter worker, who delegates all actual cooking to the cook.
If the cook has a question for a customer, such as clarifying an allergy, they send a little note to the counter worker, who interacts with the customer and passes a note back to the cook with the result.
-->

通过对副作用进行一些不同的思考，可以解决这种明显的矛盾。想象一家出售咖啡和三明治的咖啡馆。
这家咖啡馆有两个员工：一名厨师负责完成订单，一名柜员负责与顾客互动并下订单。
厨师是个脾气暴躁的人，他真的更喜欢不与外界有任何接触，
但他非常擅长始终如一地提供咖啡馆著名的食物和饮料。然而，为了做到这一点，
厨师需要安静，不能被打扰谈话。柜员很友好，但在厨房里完全没有能力。
顾客与柜员互动，后者将所有实际烹饪委托给厨师。如果厨师对顾客有疑问，例如澄清过敏，
他们会给柜台工作人员发一张小纸条，柜员与顾客互动，并将一张写有结果的纸条传回给厨师。

<!--
In this analogy, the cook is the Lean language.
When provided with an order, the cook faithfully and consistently delivers what is requested.
The counter worker is the surrounding run-time system that interacts with the world and can accept payments, dispense food, and have conversations with customers.
Working together, the two employees serve all the functions of the restaurant, but their responsibilities are divided, with each performing the tasks that they're best at.
Just as keeping customers away allows the cook to focus on making truly excellent coffee and sandwiches, Lean's lack of side effects allows programs to be used as part of formal mathematical proofs.
It also helps programmers understand the parts of the program in isolation from each other, because there are no hidden state changes that create subtle coupling between components.
The cook's notes represent `IO` actions that are produced by evaluating Lean expressions, and the counter worker's replies are the values that are passed back from effects.
-->

在这个类比中，厨师是 Lean 语言。当收到订单时，厨师会忠实且始终如一地提供所要求的内容。
柜员是与世界交互的外围运行时系统，它可以接受付款、分发食物并与顾客交谈。
这两名员工共同承担了餐厅的所有职能，但他们的职责是分开的，每个人都执行自己最擅长的任务。
就像让顾客远离可以让厨师专注于制作真正美味的咖啡和三明治一样，
Lean 缺乏副作用可以让程序用作形式化数学证明的一部分。它还有助于程序员独立理解程序的各个部分，
因为没有隐藏的状态更改会在组件之间创建微妙的耦合。
厨师的笔记表示通过求值 Lean 表达式产生的 `IO` 活动，而柜员的回复是通过副作用传递回来的值。

<!--
This model of side effects is quite similar to how the overall aggregate of the Lean language, its compiler, and its run-time system (RTS) work.
Primitives in the run-time system, written in C, implement all the basic effects.
When running a program, the RTS invokes the `main` action, which returns new `IO` actions to the RTS for execution.
The RTS executes these actions, delegating to the user's Lean code to carry out computations.
From the internal perspective of Lean, programs are free of side effects, and `IO` actions are just descriptions of tasks to be carried out.
From the external perspective of the program's user, there is a layer of side effects that create an interface to the program's core logic.
-->

这种副作用模型与 Lean 语言、编译器和运行时系统 (Run-Time System，RTS) 的整体聚合工作方式非常相似。
运行时系统中的原语（用 C 语言编写）实现了所有基本副作用。在运行程序时，
RTS 调用 `main` 活动，该活动将新的 `IO` 活动返回给 RTS 以执行。
RTS 执行这些活动，委托给用户的 Lean 代码来执行计算。从 Lean 的内部角度来看，
程序没有副作用，而 `IO` 活动只是要执行的任务的描述。从程序用户的外部角度来看，
有一层副作用，它创建了一个与程序核心逻辑的接口。

<!--
## Real-World Functional Programming
-->

## 现实世界的函数式编程

<!--
The other useful way to think about side effects in Lean is by considering `IO` actions to be functions that take the entire world as an argument and return a value paired with a new world.
In this case, reading a line of text from standard input _is_ a pure function, because a different world is provided as an argument each time.
Writing a line of text to standard output is a pure function, because the world that the function returns is different from the one that it began with.
Programs do need to be careful to never re-use the world, nor to fail to return a new world—this would amount to time travel or the end of the world, after all.
Careful abstraction boundaries can make this style of programming safe.
If every primitive `IO` action accepts one world and returns a new one, and they can only be combined with tools that preserve this invariant, then the problem cannot occur.
-->

考虑 Lean 中副作用的另一种方式，就是将 `IO` 活动看做一个函数，它将整个世界作为参数输入，
并返回一个值和一个新的世界。在这种情况下，从标准输入读取一行文本是一个 **纯（Pure）** 函数，
因为每次都提供了一个不同的世界作为参数。向标准输出写入一行文本也是一个纯函数，
因为函数返回的世界与它最初的世界不同。程序确实需要小心，不要重复使用世界，
也不要未能返回一个新世界——毕竟，这将相当于时间旅行或世界末日。
谨慎的抽象边界可以使这种编程风格变得安全。如果每个原语 `IO`
活动接受一个世界并返回一个新世界，并且它们只能与保持这种不变性的工具结合使用，
那么问题就不会发生。

<!--
This model cannot be implemented.
After all, the entire universe cannot be turned into a Lean value and placed into memory.
However, it is possible to implement a variation of this model with an abstract token that stands for the world.
When the program is started, it is provided with a world token.
This token is then passed on to the IO primitives, and their returned tokens are similarly passed to the next step.
At the end of the program, the token is returned to the operating system.
-->

当然，这种模型无法实现，毕竟整个世界无法变成 Lean 的值放入内存中。
然而，可以实现一个此模型的变体，它带有代表世界的抽象标识。
当程序启动时，它会提供一个世界标识。然后将此标识传递给 IO 原语，
并且它们的返回标识类似地传递到下一步。在程序结束时，标识将返回给活动系统。

<!--
This model of side effects is a good description of how `IO` actions as descriptions of tasks to be carried out by the RTS are represented internally in Lean.
The actual functions that transform the real world are behind an abstraction barrier.
But real programs typically consist of a sequence of effects, rather than just one.
To enable programs to use multiple effects, there is a sub-language of Lean called `do` notation that allows these primitive `IO` actions to be safely composed into a larger, useful program.
-->

这种副作用模型很好地描述了 `IO` 活动作为 RTS 要执行的任务描述如何在 Lean 内部表示。
用于转换现实世界的实际函数藏在抽象屏障之后。但实际程序通常由一系列作用组成，
而不仅仅是一个作用。为了使程序能够使用多个作用，Lean 中有一个称为 `do`-记法的子语言，
它能够将这些原始 `IO` 活动安全地组合成一个更大、更有用的程序。

<!--
## Combining `IO` Actions
-->

## 组合 `IO` 活动

<!--
Most useful programs accept input in addition to producing output.
Furthermore, they may take decisions based on input, using the input data as part of a computation.
The following program, called `HelloName.lean`, asks the user for their name and then greets them:
-->

大多数有用的程序除了产生输出外还接受输入。此外，它们可以根据输入做出决策，
将输入数据用作计算的一部分。以下程序名为 `HelloName.lean`，它向用户询问他们的姓名，然后向他们问好：

```lean
{{#include ../../../examples/hello-name/HelloName.lean:all}}
```

<!--
In this program, the `main` action consists of a `do` block.
This block contains a sequence of _statements_, which can be both local variables (introduced using `let`) and actions that are to be executed.
Just as SQL can be thought of as a special-purpose language for interacting with databases, the `do` syntax can be thought of as a special-purpose sub-language within Lean that is dedicated to modeling imperative programs.
`IO` actions that are built with a `do` block are executed by executing the statements in order.
-->

在此程序中，`main` 活动由一个 `do` 代码块组成。此块包含一系列的 **语句(Statement)** ，
它们既可以是局部变量（使用 `let` 引入），也可以是要执行的活动。
正如 SQL 可以被认为是与数据库交互的专用语言一样，`do` 语法可以被认为是 Lean
中的一个专用子语言，专门用于建模命令式程序。使用 `do` 块构建的 `IO` 活动通过按顺序执行语句来执行。

<!--
This program can be run in the same manner as the prior program:
-->

此程序可以与之前的程序以相同的方式运行：

```
{{#command {hello-name} {hello-name} {./run} {lean --run HelloName.lean}}}
```

<!--
If the user responds with `David`, a session of interaction with the program reads:
-->

如果用户回应 `David`，则与程序交互的会话读取：

```
{{#command_out {hello-name} {./run} }}
```

<!--
The type signature line is just like the one for `Hello.lean`:
-->

它的类型签名与 `Hello.lean` 的类型签名一样：

```lean
{{#include ../../../examples/hello-name/HelloName.lean:sig}}
```

<!--
The only difference is that it ends with the keyword `do`, which initiates a sequence of commands.
Each indented line following the keyword `do` is part of the same sequence of commands.
-->

唯一的区别是它以关键字 `do` 结尾，该关键字执行一系列命令。
关键字 `do` 后面的每一行缩进都是同一系列命令的一部分。

<!--
The first two lines, which read:
-->

前两行，读取：

```lean
{{#include ../../../examples/hello-name/HelloName.lean:setup}}
```

<!--
retrieve the `stdin` and `stdout` handles by executing the library actions `IO.getStdin` and `IO.getStdout`, respectively.
In a `do` block, `let` has a slightly different meaning than in an ordinary expression.
Ordinarily, the local definition in a `let` can be used in just one expression, which immediately follows the local definition.
In a `do` block, local bindings introduced by `let` are available in all statements in the remainder of the `do` block, rather than just the next one.
Additionally, `let` typically connects the name being defined to its definition using `:=`, while some `let` bindings in `do` use a left arrow (`←` or `<-`) instead.
Using an arrow means that the value of the expression is an `IO` action that should be executed, with the result of the action saved in the local variable.
In other words, if the expression to the right of the arrow has type `IO α`, then the variable has type `α` in the remainder of the `do` block.
`IO.getStdin` and `IO.getStdout` are `IO` actions in order to allow `stdin` and `stdout` to be locally overridden in a program, which can be convenient.
If they were global variables as in C, then there would be no meaningful way to override them, but `IO` actions can return different values each time they are executed.
-->

分别通过执行库活动 `IO.getStdin` 和 `IO.getStdout` 检索 `stdin` 和 `stdout` 勾柄。
在 `do` 块中，`let` 的含义与在普通表达式中略有不同。
通常，`let` 中的局部定义只能在一个表达式中使用，该表达式紧跟在局部定义之后。
在 `do` 块中，由 `let` 引入的局部绑定在 `do` 块其余部分的所有语句中都可用，
而不仅仅是下一个语句。此外，`let` 通常使用 `:=` 将所定义的名称与其定义连接起来，
而 `do` 中的一些 `let` 绑定则使用向左箭头（`←` 或 `<-`）代替。
使用箭头表示表达式的值是一个 `IO` 活动，该活动应该被执行，活动的结果保存在局部变量中。
换句话说，如果箭头右侧的表达式的类型为 `IO α`，那么该变量在 `do` 块的其余部分中的类型为 `α`。
`IO.getStdin` 和 `IO.getStdout` 是 `IO` 活动，以便允许在程序中局部覆盖 `stdin` 和 `stdout`，这很方便。
如果它们是像 C 中那样的全局变量，那么将不存在有意义的方法来覆盖它们，
但是 `IO` 活动每次执行时都可以返回不同的值。

<!--
The next part of the `do` block is responsible for asking the user for their name:
-->

`do` 块的下一部分负责询问用户姓名：

```lean
{{#include ../../../examples/hello-name/HelloName.lean:question}}
```

<!--
The first line writes the question to `stdout`, the second line requests input from `stdin`, and the third line removes the trailing newline (plus any other trailing whitespace) from the input line.
The definition of `name` uses `:=`, rather than `←`, because `String.dropRightWhile` is an ordinary function on strings, rather than an `IO` action.
-->

第一行将问题写入 `stdout`，第二行从 `stdin` 请求输入，第三行从输入行中删除尾随换行符
（以及任何其他尾随空格）。`name` 的定义使用 `:=` 而非 `←`，因为 `String.dropRightWhile`
是作用于字符串的普通函数，而非 `IO` 活动。

<!--
Finally, the last line in the program is:
-->

最后，程序中的最后一行是：

```
{{#include ../../../examples/hello-name/HelloName.lean:answer}}
```

<!--
It uses [string interpolation](../getting-to-know/conveniences.md#string-interpolation) to insert the provided name into a greeting string, writing the result to `stdout`.
-->

它使用[字符串内插](../getting-to-know/conveniences.md#string-interpolation)
将提供的名称插入到问候字符串中，并将结果写入到 `stdout`。
