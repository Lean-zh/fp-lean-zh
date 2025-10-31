import VersoManual
import FPLeanZh.Examples


open Verso.Genre Manual
open Verso Code External

open FPLeanZh

set_option verso.exampleProject "../examples"

set_option verso.exampleModule "HelloName"

example_module Hello

-- Running a Program
#doc (Manual) "运行程序" =>
%%%
file := "RunningAProgram"
tag := "running-a-program"
%%%

-- The simplest way to run a Lean program is to use the {lit}`--run` option to the Lean executable.
-- Create a file called {lit}`Hello.lean` and enter the following contents:

运行 Lean 程序最简单的方法是使用 Lean 可执行文件的 {lit}`--run` 选项。
创建一个名为 {lit}`Hello.lean` 的文件并输入以下内容：

```module (module:=Hello)
def main : IO Unit := IO.println "Hello, world!"
```

-- Then, from the command line, run:

然后，从命令行运行：

{command hello "simple-hello" "lean --run Hello.lean"}

-- The program displays {commandOut hello}`lean --run Hello.lean` and exits.
程序显示 {commandOut hello}`lean --run Hello.lean` 并退出。

-- # Anatomy of a Greeting
# 问候语的剖析
%%%
tag := "hello-world-parts"
%%%

-- When Lean is invoked with the {lit}`--run` option, it invokes the program's {lit}`main` definition.
-- In programs that do not take command-line arguments, {moduleName (module := Hello)}`main` should have type {moduleTerm}`IO Unit`.
-- This means that {moduleName (module := Hello)}`main` is not a function, because there are no arrows ({lit}`→`) in its type.
-- Instead of being a function that has side effects, {moduleTerm}`main` consists of a description of effects to be carried out.

当使用 {lit}`--run` 选项调用 Lean 时，它会调用程序的 {lit}`main` 定义。
对于不从命令行接受参数的程序，{moduleName (module := Hello)}`main` 的类型应该是 {moduleTerm}`IO Unit`。
这意味着 {moduleName (module := Hello)}`main` 不是一个函数，因为它的类型中没有箭头 ({lit}`→`)。
{moduleTerm}`main` 不是一个具有副作用的函数，而是由要执行的效果的描述组成。

-- As discussed in {ref "polymorphism"}[the preceding chapter], {moduleTerm}`Unit` is the simplest inductive type.
-- It has a single constructor called {moduleTerm}`unit` that takes no arguments.
-- Languages in the C tradition have a notion of a {CSharp}`void` function that does not return any value at all.
-- In Lean, all functions take an argument and return a value, and the lack of interesting arguments or return values can be signaled by using the {moduleTerm}`Unit` type instead.
-- If {moduleTerm}`Bool` represents a single bit of information, {moduleTerm}`Unit` represents zero bits of information.

正如 {ref "polymorphism"}[前一章] 所讨论的，{moduleTerm}`Unit` 是最简单的归纳类型。
它有一个名为 {moduleTerm}`unit` 的构造器，不接受任何参数。
C 语言传统中的语言有一个 {CSharp}`void` 函数的概念，它不返回任何值。
在 Lean 中，所有函数都接受一个参数并返回一个值，而使用 {moduleTerm}`Unit` 类型可以表示没什么参数或返回值。
如果 {moduleTerm}`Bool` 表示一比特信息，那么 {moduleTerm}`Unit` 表示零比特信息。

-- {moduleTerm}`IO α` is the type of a program that, when executed, will either throw an exception or return a value of type {moduleTerm}`α`.
-- During execution, this program may have side effects.
-- These programs are referred to as {moduleTerm}`IO` _actions_.
-- Lean distinguishes between _evaluation_ of expressions, which strictly adheres to the mathematical model of substitution of values for variables and reduction of sub-expressions without side effects, and _execution_ of {anchorTerm sig}`IO` actions, which rely on an external system to interact with the world.
-- {moduleTerm}`IO.println` is a function from strings to {moduleTerm}`IO` actions that, when executed, write the given string to standard output.
-- Because this action doesn't read any interesting information from the environment in the process of emitting the string, {moduleTerm}`IO.println` has type {moduleTerm}`String → IO Unit`.
-- If it did return something interesting, then that would be indicated by the {moduleTerm}`IO` action having a type other than {moduleTerm}`Unit`.

{moduleTerm}`IO α` 是一个程序类型，当执行时，它会抛出异常或返回 {moduleTerm}`α` 类型的值。
在执行期间，该程序可能具有副作用。这些程序被称为 {moduleTerm}`IO` *活动（Action）*。
Lean 区分表达式的 *求值（Evaluation）*（严格遵循用变量值替换值和无副作用地归约子表达式的数学模型）和 {anchorTerm sig}`IO` 活动的 *执行（Execution）*（依赖外部系统与世界交互）。
{moduleTerm}`IO.println` 是一个从字符串到 {moduleTerm}`IO` 活动的函数，当执行时，它会将给定字符串写入标准输出。
因为此活动在发出字符串的过程中不读取环境中任何有趣的信息，所以 {moduleTerm}`IO.println` 的类型是 {moduleTerm}`String → IO Unit`。
如果它确实返回了有趣的东西，那么 {moduleTerm}`IO` 活动的类型将不是 {moduleTerm}`Unit`。


-- # Functional Programming vs Effects
# 函数式编程与副作用
%%%
tag := "fp-effects"
%%%

-- Lean's model of computation is based on the evaluation of mathematical expressions, in which variables are given exactly one value that does not change over time.
-- The result of evaluating an expression does not change, and evaluating the same expression again will always yield the same result.

Lean 的计算模型基于数学表达式的求值，其中变量被赋予一个不随时间变化的值。
求值表达式的结果不会改变，再次求值相同的表达式总是会产生相同的结果。

-- On the other hand, useful programs must interact with the world.
-- A program that performs neither input nor output can't ask a user for data, create files on disk, or open network connections.
-- Lean is written in itself, and the Lean compiler certainly reads files, creates files, and interacts with text editors.
-- How can a language in which the same expression always yields the same result support programs that read files from disk, when the contents of these files might change over time?

另一方面，有用的程序必须与世界交互。
一个既不执行输入也不执行输出的程序无法向用户请求数据、在磁盘上创建文件或打开网络连接。
Lean 是用 Lean 本身编写的，Lean 编译器当然会读取文件、创建文件并与文本编辑器交互。
一个总是产生相同结果的语言如何支持读取磁盘文件的程序，而这些文件的内容可能会随时间变化呢？

-- This apparent contradiction can be resolved by thinking a bit differently about side effects.
-- Imagine a café that sells coffee and sandwiches.
-- This café has two employees: a cook who fulfills orders, and a worker at the counter who interacts with customers and places order slips.
-- The cook is a surly person, who really prefers not to have any contact with the world outside, but who is very good at consistently delivering the food and drinks that the café is known for.
-- In order to do this, however, the cook needs peace and quiet, and can't be disturbed with conversation.
-- The counter worker is friendly, but completely incompetent in the kitchen.
-- Customers interact with the counter worker, who delegates all actual cooking to the cook.
-- If the cook has a question for a customer, such as clarifying an allergy, they send a little note to the counter worker, who interacts with the customer and passes a note back to the cook with the result.

这种明显的矛盾可以通过对副作用的不同思考方式来解决。
想象一家出售咖啡和三明治的咖啡馆。
这家咖啡馆有两名员工：一名厨师负责完成订单，一名柜台工作人员负责与顾客互动并下订单。
厨师是一个脾气暴躁的人，他真的不喜欢与外界接触，但他非常擅长始终如一地提供咖啡馆闻名的食物和饮料。
然而，为了做到这一点，厨师需要安静，不能被打扰交谈。
柜台工作人员很友好，但在厨房里完全无能。
顾客与柜台工作人员互动，柜台工作人员将所有实际烹饪委托给厨师。
如果厨师对顾客有疑问，例如澄清过敏，他们会给柜台工作人员发一张小纸条，柜台工作人员与顾客互动并将结果传回给厨师。

-- In this analogy, the cook is the Lean language.
-- When provided with an order, the cook faithfully and consistently delivers what is requested.
-- The counter worker is the surrounding run-time system that interacts with the world and can accept payments, dispense food, and have conversations with customers.
-- Working together, the two employees serve all the functions of the restaurant, but their responsibilities are divided, with each performing the tasks that they're best at.
-- Just as keeping customers away allows the cook to focus on making truly excellent coffee and sandwiches, Lean's lack of side effects allows programs to be used as part of formal mathematical proofs.
-- It also helps programmers understand the parts of the program in isolation from each other, because there are no hidden state changes that create subtle coupling between components.
-- The cook's notes represent {moduleTerm}`IO` actions that are produced by evaluating Lean expressions, and the counter worker's replies are the values that are passed back from effects.

在这个类比中，厨师就是 Lean 语言。
当收到订单时，厨师忠实而一致地提供所需的东西。
柜台工作人员是周围的运行时系统，它与世界交互，可以接受付款、分发食物并与顾客交谈。
两位员工共同承担餐厅的所有职能，但他们的职责是分开的，每个人都执行他们最擅长的任务。
正如让顾客远离可以使厨师专注于制作真正出色的咖啡和三明治一样，Lean 缺乏副作用使得程序可以作为形式数学证明的一部分使用。
它还有助于程序员理解程序的各个部分，因为没有隐藏的状态变化会在组件之间产生微妙的耦合。
厨师的笔记代表通过评估 Lean 表达式产生的 {moduleTerm}`IO` 活动，而柜台工作人员的回复是从效果中传回的值。

-- This model of side effects is quite similar to how the overall aggregate of the Lean language, its compiler, and its run-time system (RTS) work.
-- Primitives in the run-time system, written in C, implement all the basic effects.
-- When running a program, the RTS invokes the {moduleTerm}`main` action, which returns new {moduleTerm}`IO` actions to the RTS for execution.
-- The RTS executes these actions, delegating to the user's Lean code to carry out computations.
-- From the internal perspective of Lean, programs are free of side effects, and {moduleTerm}`IO` actions are just descriptions of tasks to be carried out.
-- From the external perspective of the program's user, there is a layer of side effects that create an interface to the program's core logic.

这种副作用模型与 Lean 语言、其编译器和运行时系统 (Run-Time System，RTS) 的整体聚合工作方式非常相似。
运行时系统中的原语（Primitive，用 C 语言编写）实现了所有基本副作用。
当运行程序时，RTS 调用 {moduleTerm}`main` 活动，该活动将新的 {moduleTerm}`IO` 活动返回给 RTS 执行。
RTS 执行这些活动，委托用户 Lean 代码执行计算。
从 Lean 的内部角度来看，程序没有副作用，{moduleTerm}`IO` 活动只是要执行的任务的描述。
从程序用户的外部角度来看，存在一个副作用层，它为程序的核心逻辑创建了一个接口。

-- # Real-World Functional Programming
# 真实世界的函数式编程
%%%
tag := "fp-world-passing"
%%%

-- The other useful way to think about side effects in Lean is by considering {moduleTerm}`IO` actions to be functions that take the entire world as an argument and return a value paired with a new world.
-- In this case, reading a line of text from standard input _is_ a pure function, because a different world is provided as an argument each time.
-- Writing a line of text to standard output is a pure function, because the world that the function returns is different from the one that it began with.
-- Programs do need to be careful to never re-use the world, nor to fail to return a new world—this would amount to time travel or the end of the world, after all.
-- Careful abstraction boundaries can make this style of programming safe.
-- If every primitive {moduleTerm}`IO` action accepts one world and returns a new one, and they can only be combined with tools that preserve this invariant, then the problem cannot occur.

考虑 Lean 中副作用的另一种方式，就是将 {moduleTerm}`IO` 活动看做一个函数，它将整个世界作为参数输入，并返回一个值和一个新的世界。
在这种情况下，从标准输入读取一行文本是一个*纯（Pure）*函数，因为每次都提供一个不同的世界作为参数。
将一行文本写入标准输出也是一个纯函数，因为函数返回的世界与它开始时的世界不同。
程序确实需要小心，永远不要重复使用世界，也不要未能返回一个新世界——毕竟，这相当于时间旅行或世界末日。
谨小慎微的抽象边界可以使这种编程风格变得安全。
如果每个原语 {moduleTerm}`IO` 活动都接受一个世界并返回一个新世界，并且它们只能与保持此不变性的工具结合使用，那么问题就不会发生。

-- This model cannot be implemented.
-- After all, the entire universe cannot be turned into a Lean value and placed into memory.
-- However, it is possible to implement a variation of this model with an abstract token that stands for the world.
-- When the program is started, it is provided with a world token.
-- This token is then passed on to the IO primitives, and their returned tokens are similarly passed to the next step.
-- At the end of the program, the token is returned to the operating system.

当然，这种模型无法真正实现，毕竟整个世界无法变成 Lean 的值放入内存中。然而，可以实现一个此模型的变体，它带有代表世界的抽象标识。当程序启动时，它会提供一个世界标识。然后将此标识传递给 {moduleTerm}`IO` 原语，之后它们的返回标识同样地传递到下一步。在程序结束时，标识将返回给操作系统。

-- This model of side effects is a good description of how {moduleTerm}`IO` actions as descriptions of tasks to be carried out by the RTS are represented internally in Lean.
-- The actual functions that transform the real world are behind an abstraction barrier.
-- But real programs typically consist of a sequence of effects, rather than just one.
-- To enable programs to use multiple effects, there is a sub-language of Lean called {kw}`do` notation that allows these primitive {moduleTerm}`IO` actions to be safely composed into a larger, useful program.

这种副作用模型很好地描述了 {moduleTerm}`IO` 活动作为 RTS 执行任务的描述在 Lean 内部是如何表示的。
用于转换现实世界的实际函数隐藏在抽象屏障之后。但实际的程序通常不只有一个作用，而是由一系列作用组成。
为了使程序能够使用多个作用，Lean 中有一种名为 {kw}`do` -表示法的子语言，它允许这些原始 {moduleTerm}`IO` 活动安全地组合成一个更大、更有用的程序。

-- # Combining {anchorName all}`IO` Actions
# 组合 {anchorName all}`IO` 活动
%%%
tag := "combining-io-actions"
%%%

-- Most useful programs accept input in addition to producing output.
-- Furthermore, they may take decisions based on input, using the input data as part of a computation.
-- The following program, called {lit}`HelloName.lean`, asks the user for their name and then greets them:

大多数有用的程序除了产生输出外，还接受输入。
此外，它们可能会根据输入做出决策，将输入数据作为计算的一部分。
以下程序名为 {lit}`HelloName.lean`，它会询问用户的姓名，然后向他们问好：

```module (anchor:=all)
def main : IO Unit := do
  let stdin ← IO.getStdin
  let stdout ← IO.getStdout

  stdout.putStrLn "How would you like to be addressed?"
  let input ← stdin.getLine
  let name := input.dropRightWhile Char.isWhitespace

  stdout.putStrLn s!"Hello, {name}!"
```

-- In this program, the {anchorName all}`main` action consists of a {kw}`do` block.
-- This block contains a sequence of _statements_, which can be both local variables (introduced using {kw}`let`) and actions that are to be executed.
-- Just as SQL can be thought of as a special-purpose language for interacting with databases, the {kw}`do` syntax can be thought of as a special-purpose sub-language within Lean that is dedicated to modeling imperative programs.
-- {anchorName all}`IO` actions that are built with a {kw}`do` block are executed by executing the statements in order.

在此程序中，{anchorName all}`main` 活动由一个 {kw}`do` 块组成。
该块包含一系列 *语句（Statement）*，这些语句既可以是局部变量（使用 {kw}`let` 引入），也可以是要执行的活动。
正如 SQL 可以被认为是与数据库交互的专用语言一样，{kw}`do` 语法可以被认为是 Lean 中专门用于建模命令式程序的专用子语言。
使用 {kw}`do` 块构建的 {anchorName all}`IO` 活动通过按顺序执行语句来执行。

-- This program can be run in the same manner as the prior program:

该程序可以像之前的程序一样运行：

{command helloName "hello-name" "expect -f ./run" (show := "lean --run HelloName.lean")}

-- If the user responds with {lit}`David`, a session of interaction with the program reads:

如果用户回复 {lit}`David`，则与程序交互的会话会读取回应：

```commandOut helloName "expect -f ./run"
How would you like to be addressed?
David
Hello, David!
```

-- The type signature line is just like the one for {lit}`Hello.lean`:
类型签名行与 {lit}`Hello.lean` 的类型签名行相同：

```module (anchor:=sig)
def main : IO Unit := do
```

-- The only difference is that it ends with the keyword {moduleTerm}`do`, which initiates a sequence of commands.
-- Each indented line following the keyword {kw}`do` is part of the same sequence of commands.

唯一的区别是它以关键字 {moduleTerm}`do` 结尾，这会启动一系列命令。
{kw}`do` 关键字后面的每个缩进行都是同一系列命令的一部分。

-- The first two lines, which read:

前两行，读取：
```module (anchor:=setup)
  let stdin ← IO.getStdin
  let stdout ← IO.getStdout
```

-- retrieve the {moduleTerm (anchor := setup)}`stdin` and {moduleTerm (anchor := setup)}`stdout` handles by executing the library actions {moduleTerm (anchor := setup)}`IO.getStdin` and {moduleTerm (anchor := setup)}`IO.getStdout`, respectively.
-- In a {moduleTerm}`do` block, {moduleTerm}`let` has a slightly different meaning than in an ordinary expression.
-- Ordinarily, the local definition in a {moduleTerm}`let` can be used in just one expression, which immediately follows the local definition.
-- In a {moduleTerm}`do` block, local bindings introduced by {moduleTerm}`let` are available in all statements in the remainder of the {moduleTerm}`do` block, rather than just the next one.
-- Additionally, {moduleTerm}`let` typically connects the name being defined to its definition using {lit}`:=`, while some {moduleTerm}`let` bindings in {moduleTerm}`do` use a left arrow ({lit}`←` or {lit}`<-`) instead.
-- Using an arrow means that the value of the expression is an {moduleTerm}`IO` action that should be executed, with the result of the action saved in the local variable.
-- In other words, if the expression to the right of the arrow has type {moduleTerm}`IO α`, then the variable has type {moduleTerm}`α` in the remainder of the {moduleTerm}`do` block.
-- {moduleTerm (anchor := setup)}`IO.getStdin` and {moduleTerm (anchor := setup)}`IO.getStdout` are {moduleTerm (anchor := sig)}`IO` actions in order to allow {moduleTerm (anchor := setup)}`stdin` and {moduleTerm (anchor := setup)}`stdout` to be locally overridden in a program, which can be convenient.
-- If they were global variables as in C, then there would be no meaningful way to override them, but {moduleName}`IO` actions can return different values each time they are executed.

通过执行库活动 {moduleTerm (anchor := setup)}`IO.getStdin` 和 {moduleTerm (anchor := setup)}`IO.getStdout`，分别检索 {moduleTerm (anchor := setup)}`stdin` 和 {moduleTerm (anchor := setup)}`stdout` 句柄（Handle）。
在 {moduleTerm}`do` 块中，{moduleTerm}`let` 的含义与普通表达式略有不同。
通常，{moduleTerm}`let` 中的局部定义只能在一个表达式中使用，该表达式紧跟在局部定义之后。
在 {moduleTerm}`do` 块中，由 {moduleTerm}`let` 引入的局部绑定在 {moduleTerm}`do` 块的其余所有语句中都可用，而不仅仅是下一个语句。
此外，{moduleTerm}`let` 通常使用 {lit}`:=` 将被定义的名称与其定义连接起来，而 {moduleTerm}`do` 中的某些 {moduleTerm}`let` 绑定则使用左箭头 ({lit}`←` 或 {lit}`<-`)。
使用箭头意味着表达式的值是一个 {moduleTerm}`IO` 活动，该活动应该被执行，其结果保存在局部变量中。
换句话说，如果箭头右侧的表达式类型为 {moduleTerm}`IO α`，那么在 {moduleTerm}`do` 块的其余部分中，该变量的类型为 {moduleTerm}`α`。
{moduleTerm (anchor := setup)}`IO.getStdin` 和 {moduleTerm (anchor := setup)}`IO.getStdout` 是 {moduleTerm (anchor := sig)}`IO` 活动，以便允许在程序中局部覆盖 {moduleTerm (anchor := setup)}`stdin` 和 {moduleTerm (anchor := setup)}`stdout`，这很方便。
如果它们像 C 语言中的全局变量一样，那么就不存在有意义的方法来覆盖它们，但 {moduleName}`IO` 活动每次执行时都可以返回不同的值。

-- The next part of the {moduleTerm}`do` block is responsible for asking the user for their name:

{moduleTerm}`do` 块的下一部分负责询问用户的姓名：

```module (anchor:=question)
  stdout.putStrLn "How would you like to be addressed?"
  let input ← stdin.getLine
  let name := input.dropRightWhile Char.isWhitespace
```

-- The first line writes the question to {moduleTerm (anchor := setup)}`stdout`, the second line requests input from {moduleTerm (anchor := setup)}`stdin`, and the third line removes the trailing newline (plus any other trailing whitespace) from the input line.
-- The definition of {moduleTerm (anchor := question)}`name` uses {lit}`:=`, rather than {lit}`←`, because {moduleTerm}`String.dropRightWhile` is an ordinary function on strings, rather than an {moduleTerm (anchor := sig)}`IO` action.

第一行将问题写入 {moduleTerm (anchor := setup)}`stdout`，第二行从 {moduleTerm (anchor := setup)}`stdin` 请求输入，第三行从输入行中删除尾随换行符（以及任何其他尾随空格）。
{moduleTerm (anchor := question)}`name` 的定义使用 {lit}`:=`，而不是 {lit}`←`，因为 {moduleTerm}`String.dropRightWhile` 是一个普通的字符串函数，而不是 {moduleTerm (anchor := sig)}`IO` 活动。

-- Finally, the last line in the program is:

最后，程序的最后一行是：
```module (anchor:=answer)
  stdout.putStrLn s!"Hello, {name}!"
```

-- It uses {ref "string-interpolation"}[string interpolation] to insert the provided name into a greeting string, writing the result to {moduleTerm (anchor := setup)}`stdout`.
它使用 {ref "string-interpolation"}[字符串插值] 将提供的名称插入到问候字符串中，并将结果写入 {moduleTerm (anchor := setup)}`stdout`。
