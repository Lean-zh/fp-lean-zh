import VersoManual
import FPLeanZh.Examples


open Verso.Genre Manual
open Verso Code External


open FPLeanZh


set_option verso.exampleProject "../examples"
set_option verso.exampleModule "Examples.HelloWorld"

-- Summary
#doc (Manual) "总结" =>
%%%
file := "HelloWorld/Summary"
tag := "hello-world-summary"
%%%

-- # Evaluation vs Execution
# 求值与执行
%%%
tag := "evaluation-vs-execution"
%%%

-- Side effects are aspects of program execution that go beyond the evaluation of mathematical expressions, such as reading files, throwing exceptions, or triggering industrial machinery.
-- While most languages allow side effects to occur during evaluation, Lean does not.
-- Instead, Lean has a type called {moduleName}`IO` that represents _descriptions_ of programs that use side effects.
-- These descriptions are then executed by the language's run-time system, which invokes the Lean expression evaluator to carry out specific computations.
-- Values of type {moduleTerm}`IO α` are called _{moduleName}`IO` actions_.
-- The simplest is {moduleName}`pure`, which returns its argument and has no actual side effects.

副作用是程序执行中超出数学表达式求值的方面，例如读取文件、抛出异常或触发工业机械。
虽然大多数语言允许在求值期间发生副作用，但 Lean 不允许。
相反，Lean 有一个名为 {moduleName}`IO` 的类型，它表示使用副作用的程序的*描述*。
这些描述然后由语言的运行时系统执行，该系统调用 Lean 表达式求值器来执行特定计算。
{moduleTerm}`IO α` 类型的值被称为 *{moduleName}`IO` 动作*。
最简单的是 {moduleName}`pure`，它返回其参数且没有实际副作用。

-- {moduleName}`IO` actions can also be understood as functions that take the whole world as an argument and return a new world in which the side effect has occurred.
-- Behind the scenes, the {moduleName}`IO` library ensures that the world is never duplicated, created, or destroyed.
-- While this model of side effects cannot actually be implemented, as the whole universe is too big to fit in memory, the real world can be represented by a token that is passed around through the program.

{moduleName}`IO` 动作也可以理解为以整个世界为参数并返回发生副作用的新世界的函数。
在幕后，{moduleName}`IO` 库确保世界永远不会被复制、创建或销毁。
虽然这种副作用模型实际上无法实现，因为整个宇宙太大而无法放入内存，但真实世界可以由通过程序传递的令牌表示。

-- An {moduleName}`IO` action {anchorName MainTypes}`main` is executed when the program starts.
-- {anchorName MainTypes}`main` can have one of three types:
-- * {anchorTerm MainTypes}`main : IO Unit` is used for simple programs that cannot read their command-line arguments and always return exit code {anchorTerm MainTypes}`0`,
-- * {anchorTerm MainTypes}`main : IO UInt32` is used for programs without arguments that may signal success or failure, and
-- * {anchorTerm MainTypes}`main : List String → IO UInt32` is used for programs that take command-line arguments and signal success or failure.

程序启动时会执行 {moduleName}`IO` 动作 {anchorName MainTypes}`main`。
{anchorName MainTypes}`main` 可以有三种类型之一：
 * {anchorTerm MainTypes}`main : IO Unit` 用于无法读取命令行参数且始终返回退出代码 {anchorTerm MainTypes}`0` 的简单程序，
 * {anchorTerm MainTypes}`main : IO UInt32` 用于没有参数但可能发出成功或失败信号的程序，以及
 * {anchorTerm MainTypes}`main : List String → IO UInt32` 用于接受命令行参数并发出成功或失败信号的程序。

-- # {lit}`do` Notation
# {lit}`do` 记法
%%%
tag := "do-notation"
%%%

-- The Lean standard library provides a number of basic {moduleName}`IO` actions that represent effects such as reading from and writing to files and interacting with standard input and standard output.
-- These base {moduleName}`IO` actions are composed into larger {moduleName}`IO` actions using {kw}`do` notation, which is a built-in domain-specific language for writing descriptions of programs with side effects.
-- A {kw}`do` expression contains a sequence of _statements_, which may be:
-- * expressions that represent {moduleName}`IO` actions,
-- * ordinary local definitions with {kw}`let` and {lit}`:=`, where the defined name refers to the value of the provided expression, or
-- * local definitions with {kw}`let` and {lit}`←`, where the defined name refers to the result of executing the value of the provided expression.

Lean 标准库提供了许多基本的 {moduleName}`IO` 动作，这些动作表示诸如读取和写入文件以及与标准输入和标准输出交互等效果。
这些基本的 {moduleName}`IO` 动作使用 {kw}`do` 记法组合成更大的 {moduleName}`IO` 动作，
这是一种内置的领域特定语言，用于编写带副作用程序的描述。
{kw}`do` 表达式包含一系列*语句*，这些语句可能是：
 * 表示 {moduleName}`IO` 动作的表达式，
 * 使用 {kw}`let` 和 {lit}`:=` 的普通局部定义，其中定义的名称引用所提供表达式的值，或
 * 使用 {kw}`let` 和 {lit}`←` 的局部定义，其中定义的名称引用执行所提供表达式的值的结果。

-- {moduleName}`IO` actions that are written with {kw}`do` are executed one statement at a time.

使用 {kw}`do` 编写的 {moduleName}`IO` 动作一次执行一个语句。

-- Furthermore, {kw}`if` and {kw}`match` expressions that occur immediately under a {kw}`do` are implicitly considered to have their own {kw}`do` in each branch.
-- Inside of a {kw}`do` expression, _nested actions_ are expressions with a left arrow immediately under parentheses.
-- The Lean compiler implicitly lifts them to the nearest enclosing {kw}`do`, which may be implicitly part of a branch of a {kw}`match` or {kw}`if` expression, and gives them a unique name.
-- This unique name then replaces the origin site of the nested action.

此外，直接出现在 {kw}`do` 下的 {kw}`if` 和 {kw}`match` 表达式被隐式认为在每个分支中都有自己的 {kw}`do`。
在 {kw}`do` 表达式内部，*嵌套动作*是括号下紧跟左箭头的表达式。
Lean 编译器隐式地将它们提升到最近的封闭 {kw}`do`，这可能是 {kw}`match` 或 {kw}`if` 表达式分支的隐式部分，并给它们一个唯一的名称。
这个唯一的名称然后替换嵌套动作的原始位置。

-- # Compiling and Running Programs
# 编译和运行程序
%%%
tag := "compiling-and-running-programs"
%%%

-- A Lean program that consists of a single file with a {moduleName}`main` definition can be run using {lit}`lean --run FILE`.
-- While this can be a nice way to get started with a simple program, most programs will eventually graduate to a multiple-file project that should be compiled before running.

由具有 {moduleName}`main` 定义的单个文件组成的 Lean 程序可以使用 {lit}`lean --run FILE` 运行。
虽然这可能是开始简单程序的好方法，但大多数程序最终会升级到多文件项目，应该在运行之前编译。

-- Lean projects are organized into _packages_, which are collections of libraries and executables together with information about dependencies and a build configuration.
-- Packages are described using Lake, a Lean build tool.
-- Use {lit}`lake new` to create a Lake package in a new directory, or {lit}`lake init` to create one in the current directory.
-- Lake package configuration is another domain-specific language.
-- Use {lit}`lake build` to build a project.

Lean 项目组织成*包*，这些包是库和可执行文件的集合，以及有关依赖项和构建配置的信息。
包使用 Lake（一个 Lean 构建工具）来描述。
使用 {lit}`lake new` 在新目录中创建 Lake 包，或使用 {lit}`lake init` 在当前目录中创建一个。
Lake 包配置是另一种领域特定语言。
使用 {lit}`lake build` 来构建项目。

-- # Partiality
# 部分性
%%%
tag := "partiality"
%%%

-- One consequence of following the mathematical model of expression evaluation is that every expression must have a value.
-- This rules out both incomplete pattern matches that fail to cover all constructors of a datatype and programs that can fall into an infinite loop.
-- Lean ensures that all {kw}`match` expressions cover all cases, and that all recursive functions are either structurally recursive or have an explicit proof of termination.

遵循表达式求值的数学模型的一个结果是每个表达式都必须有一个值。
这排除了未能覆盖数据类型所有构造子的不完整模式匹配以及可能陷入无限循环的程序。
Lean 确保所有 {kw}`match` 表达式覆盖所有情况，并且所有递归函数要么是结构递归的，要么有显式的终止证明。

-- However, some real programs require the possibility of looping infinitely, because they handle potentially-infinite data, such as POSIX streams.
-- Lean provides an escape hatch: functions whose definition is marked {kw}`partial` are not required to terminate.
-- This comes at a cost.
-- Because types are a first-class part of the Lean language, functions can return types.
-- Partial functions, however, are not evaluated during type checking, because an infinite loop in a function could cause the type checker to enter an infinite loop.
-- Furthermore, mathematical proofs are unable to inspect the definitions of partial functions, which means that programs that use them are much less amenable to formal proof.

然而，一些真实程序需要无限循环的可能性，因为它们处理可能无限的数据，例如 POSIX 流。
Lean 提供了一个逃生舱：定义被标记为 {kw}`partial` 的函数不需要终止。
这是有代价的。
由于类型是 Lean 语言的一等部分，函数可以返回类型。
然而，部分函数在类型检查期间不会被求值，因为函数中的无限循环可能导致类型检查器进入无限循环。
此外，数学证明无法检查部分函数的定义，这意味着使用它们的程序远不如形式证明那样易于处理。
