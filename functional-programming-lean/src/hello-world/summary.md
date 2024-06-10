<!--
# Summary
-->

# 总结

<!--
## Evaluation vs Execution
-->

## 求值与执行

<!--
Side effects are aspects of program execution that go beyond the evaluation of mathematical expressions, such as reading files, throwing exceptions, or triggering industrial machinery.
While most languages allow side effects to occur during evaluation, Lean does not.
Instead, Lean has a type called `IO` that represents _descriptions_ of programs that use side effects.
These descriptions are then executed by the language's run-time system, which invokes the Lean expression evaluator to carry out specific computations.
Values of type `IO α` are called _`IO` actions_.
The simplest is `pure`, which returns its argument and has no actual side effects.
-->

副作用是程序执行中超出数学表达式求值范围的部分，例如读取文件、抛出异常或驱动工业机械。
虽然大多数语言允许在求值期间发生副作用，但 Lean 不会。相反，Lean 有一个名为 `IO` 的类型，
它表示使用副作用的程序的 **描述（Description）** 。然后由语言的运行时系统执行这些描述，
该系统会调用 Lean 表达式求值器来执行特定计算。类型为 `IO α` 的值称为 **`IO` 活动** 。
最简单的是 `pure`，它返回其参数并且没有实际副作用。

<!--
`IO` actions can also be understood as functions that take the whole world as an argument and return a new world in which the side effect has occurred.
Behind the scenes, the `IO` library ensures that the world is never duplicated, created, or destroyed.
While this model of side effects cannot actually be implemented, as the whole universe is too big to fit in memory, the real world can be represented by a token that is passed around through the program.
-->

`IO` 操作还可以理解为将整个世界作为参数并返回一个副作用已经发生的全新世界的函数。在幕后，`IO` "
"库确保世界永远不会被复制、创建或销毁。虽然这种副作用模型实际上无法实现，因为整个宇宙太大而无法放入内存，但现实世界可以用一个在程序中传递的令牌来表示。

<!--
An `IO` action `main` is executed when the program starts.
`main` can have one of three types:
 * `main : IO Unit` is used for simple programs that cannot read their command-line arguments and always return exit code `0`,
 * `main : IO UInt32` is used for programs without arguments that may signal success or failure, and
 * `main : List String → IO UInt32` is used for programs that take command-line arguments and signal success or failure.
-->

`IO` 活动 `main` 会在程序启动时执行。`main` 可拥有以下三种类型：

* `main : IO Unit` 用于无法读取其命令行参数且始终返回退出码 `0` 的简单程序，
* `main : IO UInt32` 用于没有参数的程序，该程序可能会发出成功或失败信号，以及
* `main : List String → IO UInt32` 用于获取命令行参数并发出成功或失败信号的程序。

<!--
## `do` Notation
-->

## `do` 记法

<!--
The Lean standard library provides a number of basic `IO` actions that represent effects such as reading from and writing to files and interacting with standard input and standard output.
These base `IO` actions are composed into larger `IO` actions using `do` notation, which is a built-in domain-specific language for writing descriptions of programs with side effects.
-->

Lean 标准库提供了许多基本 `IO` 活动，表示诸如读写文件以及与标准输入和标准输出交互之类的作用。
这些基本 `IO` 活动使用 `do` 语法组合成更大的 `IO` 活动，
`do` 语法是用于编写具有副作用的程序描述的内置领域专用语言。

<!--
A `do` expression contains a sequence of _statements_, which may be:
 * expressions that represent `IO` actions,
 * ordinary local definitions with `let` and `:=`, where the defined name refers to the value of the provided expression, or
 * local definitions with `let` and `←`, where the defined name refers to the result of executing the value of the provided expression.
-->

`do` 表达式包含一系列 **语句（Statement）** ，这些语句可以是：

* 表示 `IO` 活动的表达式，
* 使用 `let` 和 `:=` 的普通局部定义，该定义的名称引用了所提供表达式的值，或者
* 使用 `let` 和 `←` 的局部定义，该定义的名称引用了执行所提供表达式的结果值。

<!--
`IO` actions that are written with `do` are executed one statement at a time.
-->

使用 `do` 编写的 `IO` 活动一次只执行一条语句。

<!--
Furthermore, `if` and `match` expressions that occur immediately under a `do` are implicitly considered to have their own `do` in each branch.
Inside of a `do` expression, _nested actions_ are expressions with a left arrow immediately under parentheses.
The Lean compiler implicitly lifts them to the nearest enclosing `do`, which may be implicitly part of a branch of a `match` or `if` expression, and gives them a unique name.
This unique name then replaces the origin site of the nested action.
-->

此外，直接出现在 `do` 下面的 `if` 和 `match` 表达式隐式地被认为在每个分支中都有自己的 `do`。
在 `do` 表达式内部， **嵌套活动（Nested Action）** 是括号下紧跟左箭头的表达式。
Lean 编译器会隐式地将它们提升到最近的封闭 `do` 中，该 `do` 可能隐式地是 `match` 或 `if`
表达式分支的一部分，并为它们提供一个唯一的名称。然后，此唯一名称将替换嵌套活动的原始位置。

<!--
## Compiling and Running Programs
-->

## 编译并运行程序

<!--
A Lean program that consists of a single file with a `main` definition can be run using `lean --run FILE`.
While this can be a nice way to get started with a simple program, most programs will eventually graduate to a multiple-file project that should be compiled before running.
-->

一个由包含 `main` 定义的单个文件组成的 Lean 程序可以使用 `lean --run FILE` 运行。
虽然这可能是开始使用简单程序的好方法，但大多数程序最终都会升级为多文件项目，
在运行之前应该对其进行编译。

<!--
Lean projects are organized into _packages_, which are collections of libraries and executables together with information about dependencies and a build configuration.
Packages are described using Lake, a Lean build tool.
Use `lake new` to create a Lake package in a new directory, or `lake init` to create one in the current directory.
Lake package configuration is another domain-specific language.
Use `lake build` to build a project.
-->

Lean 项目被组织成 **包（Package）** ，它们是库和可执行文件的集合，以及相关的依赖项和构建配置的信息。
包使用 Lean 构建工具 Lake 来描述。使用 `lake new` 可在新目录中创建一个 Lake 包，
或使用 `lake init` 在当前目录中创建一个包。Lake 包配置是另一种领域专用的语言。
可使用 `lake build` 构建项目。

<!--
## Partiality
-->

## 偏函数

<!--
One consequence of following the mathematical model of expression evaluation is that every expression must have a value.
This rules out both incomplete pattern matches that fail to cover all constructors of a datatype and programs that can fall into an infinite loop.
Lean ensures that all `match` expressions cover all cases, and that all recursive functions are either structurally recursive or have an explicit proof of termination.
-->

遵循表达式求值的数学模型的一个结果，就是每个表达式都必定有一个值。
这排除了不完全的模式匹配（即无法覆盖数据类型的全部构造子）和可能陷入无限循环的程序。
Lean 确保了所有 `match` 表达式会涵盖所有情况，并且所有递归函数要么是结构化递归的，
要么具有明确的停机证明。

<!--
However, some real programs require the possibility of looping infinitely, because they handle potentially-infinite data, such as POSIX streams.
Lean provides an escape hatch: functions whose definition is marked `partial` are not required to terminate.
This comes at a cost.
Because types are a first-class part of the Lean language, functions can return types.
Partial functions, however, are not evaluated during type checking, because an infinite loop in a function could cause the type checker to enter an infinite loop.
Furthermore, mathematical proofs are unable to inspect the definitions of partial functions, which means that programs that use them are much less amenable to formal proof.
-->

然而，一些现实的程序需要编写无限循环的能力，因为它们需要处理潜在的无限数据，例如 POSIX 流。
Lean 提供了一个逃生舱：标记为 `partial` 的 **偏函数（Partial Function）** 定义不需要终止。
然而这是有代价的，由于类型是 Lean 语言的一等部分，所以函数可以返回类型。
然而，偏函数在类型检查期间不会被求值，因为函数中的无限循环可能会导致类型检查器进入死循环。
此外，数学证明无法检查偏函数的定义，这意味着使用它们的程序更难进行形式化证明。
