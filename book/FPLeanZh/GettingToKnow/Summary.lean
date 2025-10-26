import VersoManual
import FPLeanZh.Examples

open Verso.Genre Manual
open Verso Code External

open FPLeanZh

set_option verso.exampleProject "../examples"
set_option verso.exampleModule "Examples.Intro"

#doc (Manual) "总结" =>
%%%
tag := "getting-to-know-summary"
%%%

-- # Evaluating Expressions
# 求值表达式

%%%
tag := none
%%%

-- In Lean, computation occurs when expressions are evaluated.
-- This follows the usual rules of mathematical expressions: sub-expressions are replaced by their values following the usual order of operations, until the entire expression has become a value.
-- When evaluating an {kw}`if` or a {kw}`match`, the expressions in the branches are not evaluated until the value of the condition or the match subject has been found.

在 Lean 中，计算在表达式被求值时发生。
这遵循数学表达式的通常规则：子表达式按照通常的运算顺序被它们的值替换，直到整个表达式变成一个值。
在求值 {kw}`if` 或 {kw}`match` 时，分支中的表达式直到条件或匹配主体的值被找到后才被求值。

-- Once they have been given a value, variables never change.
-- Similarly to mathematics but unlike most programming languages, Lean variables are simply placeholders for values, rather than addresses to which new values can be written.
-- Variables' values may come from global definitions with {kw}`def`, local definitions with {kw}`let`, as named arguments to functions, or from pattern matching.

一旦被赋值，变量就永远不会改变。
与数学类似，但与大多数编程语言不同，Lean 变量只是值的占位符，而不是可以写入新值的地址。
变量的值可以来自使用 {kw}`def` 的全局定义、使用 {kw}`let` 的局部定义、作为函数的命名参数，或来自模式匹配。

-- # Functions
# 函数
%%%
tag := none
%%%

-- Functions in Lean are first-class values, meaning that they can be passed as arguments to other functions, saved in variables, and used like any other value.
-- Every Lean function takes exactly one argument.
-- To encode a function that takes more than one argument, Lean uses a technique called currying, where providing the first argument returns a function that expects the remaining arguments.
-- To encode a function that takes no arguments, Lean uses the {moduleName}`Unit` type, which is the least informative possible argument.

在 Lean 中，函数是一等公民，这意味着它们可以作为参数传递给其他函数，保存在变量中，并像任何其他值一样使用。
每个 Lean 函数只接受一个参数。
为了编码一个接受多个参数的函数，Lean 使用一种称为柯里化的技术，即提供第一个参数会返回一个期望剩余参数的函数。
为了编码一个不接受任何参数的函数，Lean 使用 {moduleName}`Unit` 类型，这是信息量最少的参数。

-- There are three primary ways of creating functions:
-- 1. Anonymous functions are written using {kw}`fun`.
--    For instance, a function that swaps the fields of a {anchorName fragments}`Point` can be written {anchorTerm swapLambda}`fun (point : Point) => { x := point.y, y := point.x : Point }`
-- 2. Very simple anonymous functions are written by placing one or more centered dots {anchorTerm subOneDots}`·` inside of parentheses.
--    Each centered dot becomes an argument to the function, and the parentheses delimit its body.
--    For instance, a function that subtracts one from its argument can be written as {anchorTerm subOneDots}`(· - 1)` instead of as {anchorTerm subOneDots}`fun x => x - 1`.
-- 3. Functions can be defined using {kw}`def` or {kw}`let` by adding an argument list or by using pattern-matching notation.

创建函数主要有三种方法：
1. 匿名函数使用 {kw}`fun` 编写。
   例如，一个交换 {anchorName fragments}`Point` 字段的函数可以写成 {anchorTerm swapLambda}`fun (point : Point) => { x := point.y, y := point.x : Point }`
2. 非常简单的匿名函数可以通过在括号内放置一个或多个居中点 {anchorTerm subOneDots}`·` 来编写。
   每个居中点都成为函数的一个参数，括号界定其主体。
   例如，一个从其参数中减去一的函数可以写成 {anchorTerm subOneDots}`(· - 1)` 而不是 {anchorTerm subOneDots}`fun x => x - 1`。
3. 函数可以使用 {kw}`def` 或 {kw}`let` 通过添加参数列表或使用模式匹配表示法来定义。

-- # Types
# 类型
%%%
tag := none
%%%

-- Lean checks that every expression has a type.
-- Types, such as {anchorName fragments}`Int`, {anchorName fragments}`Point`, {anchorTerm fragments}`{α : Type} → Nat → α → List α`, and {anchorTerm fragments}`Option (String ⊕ (Nat × String))`, describe the values that may eventually be found for an expression.
-- Like other languages, types in Lean can express lightweight specifications for programs that are checked by the Lean compiler, obviating the need for certain classes of unit test.
-- Unlike most languages, Lean's types can also express arbitrary mathematics, unifying the worlds of programming and theorem proving.
-- While using Lean for proving theorems is mostly out of scope for this book, _[Theorem Proving in Lean 4](https://leanprover.github.io/theorem_proving_in_lean4/)_ contains more information on this topic.

Lean 检查每个表达式都有一个类型。
类型，例如 {anchorName fragments}`Int`、{anchorName fragments}`Point`、{anchorTerm fragments}`{α : Type} → Nat → α → List α` 和 {anchorTerm fragments}`Option (String ⊕ (Nat × String))`，描述了最终可能为表达式找到的值。
与其他语言一样，Lean 中的类型可以表达由 Lean 编译器检查的程序的轻量级规范，从而无需某些类别的单元测试。
与大多数语言不同，Lean 的类型还可以表达任意数学，从而统一了编程和定理证明的世界。
虽然使用 Lean 证明定理超出了本书的范围，但 *[Theorem Proving in Lean 4](https://leanprover.github.io/theorem_proving_in_lean4/)* 包含有关此主题的更多信息。

-- Some expressions can be given multiple types.
-- For instance, {lit}`3` can be an {anchorName fragments}`Int` or a {anchorName fragments}`Nat`.
-- In Lean, this should be understood as two separate expressions, one with type {anchorName fragments}`Nat` and one with type {anchorName fragments}`Int`, that happen to be written in the same way, rather than as two different types for the same thing.

有些表达式可以被赋予多种类型。
例如，{lit}`3` 可以是 {anchorName fragments}`Int` 或 {anchorName fragments}`Nat`。
在 Lean 中，这应该被理解为两个独立的表达式，一个类型为 {anchorName fragments}`Nat`，另一个类型为 {anchorName fragments}`Int`，它们恰好以相同的方式编写，而不是同一事物的两种不同类型。

-- Lean is sometimes able to determine types automatically, but types must often be provided by the user.
-- This is because Lean's type system is so expressive.
-- Even when Lean can find a type, it may not find the desired type—{lit}`3` could be intended to be used as an {anchorName fragments}`Int`, but Lean will give it the type {anchorName fragments}`Nat` if there are no further constraints.
-- In general, it is a good idea to write most types explicitly, only letting Lean fill out the very obvious types.
-- This improves Lean's error messages and helps make programmer intent more clear.

Lean 有时能够自动确定类型，但通常需要用户提供类型。
这是因为 Lean 的类型系统非常富有表现力。
即使 Lean 可以找到一个类型，它也可能找不到所需的类型——{lit}`3` 可能旨在用作 {anchorName fragments}`Int`，但如果没有进一步的约束，Lean 会给它 {anchorName fragments}`Nat` 类型。
总的来说，明确编写大多数类型是一个好主意，只让 Lean 填充非常明显的类型。
这可以改善 Lean 的错误消息，并有助于使程序员的意图更清晰。

-- Some functions or datatypes take types as arguments.
-- They are called _polymorphic_.
-- Polymorphism allows programs such as one that calculates the length of a list without caring what type the entries in the list have.
-- Because types are first class in Lean, polymorphism does not require any special syntax, so types are passed just like other arguments.
-- Naming an argument in a function type allows later types to mention that name, and when the function is applied to an argument, the type of the resulting term is found by replacing the argument's name with the actual value it was applied to.

一些函数或数据类型将类型作为参数。
它们被称为*多态*。
多态性允许程序计算列表的长度，而无需关心列表中条目的类型。
因为类型在 Lean 中是一等公民，所以多态性不需要任何特殊的语法，因此类型的传递方式与其他参数一样。
在函数类型中命名参数允许后续类型引用该名称，当函数应用于参数时，通过将参数的名称替换为应用它的实际值来找到结果项的类型。

-- # Structures and Inductive Types
# 结构和归纳类型
%%%
tag := none
%%%

-- Brand new datatypes can be introduced to Lean using the {kw}`structure` or {kw}`inductive` features.
-- These new types are not considered to be equivalent to any other type, even if their definitions are otherwise identical.
-- Datatypes have _constructors_ that explain the ways in which their values can be constructed, and each constructor takes some number of arguments.
-- Constructors in Lean are not the same as constructors in object-oriented languages: Lean's constructors are inert holders of data, rather than active code that initializes an allocated object.

可以使用 {kw}`structure` 或 {kw}`inductive` 功能将全新的数据类型引入 Lean。
这些新类型不被认为等同于任何其他类型，即使它们的定义在其他方面是相同的。
数据类型具有*构造函数*，用于解释其值的构造方式，每个构造函数都接受一定数量的参数。
Lean 中的构造函数与面向对象语言中的构造函数不同：Lean 的构造函数是数据的惰性持有者，而不是初始化已分配对象的活动代码。

-- Typically, {kw}`structure` is used to introduce a product type (that is, a type with just one constructor that takes any number of arguments), while {kw}`inductive` is used to introduce a sum type (that is, a type with many distinct constructors).
-- Datatypes defined with {kw}`structure` are provided with one accessor function for each field.
-- Both structures and inductive datatypes may be consumed with pattern matching, which exposes the values stored inside of constructors using a subset of the syntax used to call said constructors.
-- Pattern matching means that knowing how to create a value implies knowing how to consume it.

通常，{kw}`structure` 用于引入乘积类型（即，只有一个构造函数并接受任意数量参数的类型），而 {kw}`inductive` 用于引入和类型（即，具有许多不同构造函数的类型）。
使用 {kw}`structure` 定义的数据类型为每个字段提供一个访问器函数。
结构和归纳数据类型都可以通过模式匹配来使用，它使用用于调用所述构造函数的语法的子集来公开存储在构造函数内部的值。
模式匹配意味着知道如何创建值就意味着知道如何使用它。

-- # Recursion

-- A definition is recursive when the name being defined is used in the definition itself.
-- Because Lean is an interactive theorem prover in addition to being a programming language, there are certain restrictions placed on recursive definitions.
-- In Lean's logical side, circular definitions could lead to logical inconsistency.

# 递归
%%%
tag := none
%%%

当被定义的名称在定义本身中使用时，定义是递归的。
因为 Lean 除了是一种编程语言之外，还是一个交互式定理证明器，所以对递归定义有一定的限制。
在 Lean 的逻辑方面，循环定义可能导致逻辑不一致。

-- In order to ensure that recursive definitions do not undermine the logical side of Lean, Lean must be able to prove that all recursive functions terminate, no matter what arguments they are called with.
-- In practice, this means either that recursive calls are all performed on a structurally-smaller piece of the input, which ensures that there is always progress towards a base case, or that users must provide some other evidence that the function always terminates.
-- Similarly, recursive inductive types are not allowed to have a constructor that takes a function _from_ the type as an argument, because this would make it possible to encode non-terminating functions.

为了确保递归定义不会破坏 Lean 的逻辑方面，Lean 必须能够证明所有递归函数都会终止，无论它们使用什么参数调用。
在实践中，这意味着要么递归调用都在输入的结构上更小的部分上执行，这确保了总是朝着基本情况取得进展，要么用户必须提供其他一些证据来证明函数总是终止。
同样，递归归纳类型不允许具有将*来自*该类型的函数作为参数的构造函数，因为这会使编码非终止函数成为可能。
