import VersoManual
import FPLeanZh.Examples

open Verso.Genre Manual
open Verso Code External

open FPLeanZh

set_option verso.exampleProject "../examples"
set_option verso.exampleModule "Examples.Classes"

set_option pp.rawOnError true

-- Summary
#doc (Manual) "总结" =>
%%%
file := "Summary"
tag := "type-classes-summary"
%%%

-- # Type Classes and Overloading
# 类型类和重载
%%%
tag := "type-classes-and-overloading"
%%%

-- Type classes are Lean's mechanism for overloading functions and operators.
-- A polymorphic function can be used with multiple types, but it behaves in the same manner no matter which type it is used with.
-- For example, a polymorphic function that appends two lists can be used no matter the type of the entries in the list, but it is unable to have different behavior depending on which particular type is found.
-- An operation that is overloaded with type classes, on the other hand, can also be used with multiple types.
-- However, each type requires its own implementation of the overloaded operation.
-- This means that the behavior can vary based on which type is provided.

类型类是 Lean 用于重载函数和运算符的机制。
多态函数可以与多种类型一起使用，但无论使用哪种类型，其行为方式都相同。
例如，无论列表中的条目类型如何，都可以使用附加两个列表的多态函数，但它无法根据找到的特定类型具有不同的行为。
另一方面，使用类型类重载的操作也可以与多种类型一起使用。
但是，每种类型都需要自己实现重载的操作。
这意味着行为可以根据提供的类型而有所不同。

-- A _type class_ has a name, parameters, and a body that consists of a number of names with types.
-- The name is a way to refer to the overloaded operations, the parameters determine which aspects of the definitions can be overloaded, and the body provides the names and type signatures of the overloadable operations.
-- Each overloadable operation is called a {deftech}_method_ of the type class.
-- Type classes may provide default implementations of some methods in terms of the others, freeing implementors from defining each overload by hand when it is not needed.

*类型类*具有名称、参数和由多个带类型的名称组成的主体。
名称是引用重载操作的一种方式，参数确定可以重载定义的哪些方面，主体提供可重载操作的名称和类型签名。
每个可重载的操作都称为类型类的 {deftech}*方法*。
类型类可以根据其他方法提供某些方法的默认实现，从而使实现者在不需要时无需手动定义每个重载。

-- An {deftech}_instance_ of a type class provides implementations of the methods for given parameters.
-- Instances may be polymorphic, in which case they can work for a variety of parameters, and they may optionally provide more specific implementations of default methods in cases where a more efficient version exists for some particular type.

类型类的 {deftech}*实例*为给定参数提供方法的实现。
实例可以是多态的，在这种情况下，它们可以适用于各种参数，并且在某些特定类型存在更高效版本的情况下，它们可以选择性地提供默认方法的更具体的实现。

-- Type class parameters are either {deftech}_input parameters_ (the default), or {deftech}_output parameters_ (indicated by an {moduleName}`outParam` modifier).
-- Lean will not begin searching for an instance until all input parameters are no longer metavariables, while output parameters may be solved while searching for instances.
-- Parameters to a type class need not be types—they may also be ordinary values.
-- The {moduleName}`OfNat` type class, used to overload natural number literals, takes the overloaded {moduleName}`Nat` itself as a parameter, which allows instances to restrict the allowed numbers.

类型类参数要么是 {deftech}*输入参数*（默认），要么是 {deftech}*输出参数*（由 {moduleName}`outParam` 修饰符指示）。
在所有输入参数不再是元变量之前，Lean 不会开始搜索实例，而输出参数可以在搜索实例时求解。
类型类的参数不必是类型——它们也可以是普通值。
用于重载自然数字面量的 {moduleName}`OfNat` 类型类将重载的 {moduleName}`Nat` 本身作为参数，这允许实例限制允许的数字。

-- Instances may be marked with a {anchorTerm defaultAdd}`@[default_instance]` attribute.
-- When an instance is a default instance, then it will be chosen as a fallback when Lean would otherwise fail to find an instance due to the presence of metavariables in the type.

实例可以用 {anchorTerm defaultAdd}`@[default_instance]` 属性标记。
当实例是默认实例时，当 Lean 由于类型中存在元变量而无法找到实例时，它将被选为后备。

-- # Type Classes for Common Syntax
# 常用语法的类型类
%%%
tag := "type-classes-for-common-syntax"
%%%

-- Most infix operators in Lean are overridden with a type class.
-- For instance, the addition operator corresponds to a type class called {moduleName}`Add`.
-- Most of these operators have a corresponding heterogeneous version, in which the two arguments need not have the same type.
-- These heterogeneous operators are overloaded using a version of the class whose name starts with {lit}`H`, such as {moduleName}`HAdd`.

Lean 中的大多数中缀运算符都使用类型类进行重写。
例如，加法运算符对应于一个名为 {moduleName}`Add` 的类型类。
这些运算符中的大多数都有一个对应的异构版本，其中两个参数不必具有相同的类型。
这些异构运算符是使用名称以 {lit}`H` 开头的类的版本进行重载的，例如 {moduleName}`HAdd`。

-- Indexing syntax is overloaded using a type class called {moduleName}`GetElem`, which involves proofs.
-- {moduleName}`GetElem` has two output parameters, which are the type of elements to be extracted from the collection and a function that can be used to determine what counts as evidence that the index value is in bounds for the collection.
-- This evidence is described by a proposition, and Lean attempts to prove this proposition when array indexing is used.
-- When Lean is unable to check that list or array access operations are in bounds at compile time, the check can be deferred to run time by appending a {lit}`?` to the indexing syntax.

索引语法是使用一个名为 {moduleName}`GetElem` 的类型类进行重载的，该类型类涉及证明。
{moduleName}`GetElem` 有两个输出参数，它们是从集合中提取的元素的类型和一个函数，该函数可用于确定什么算作索引值在集合边界内的证据。
此证据由一个命题描述，当使用数组索引时，Lean 会尝试证明此命题。
当 Lean 无法在编译时检查列表或数组访问操作是否在边界内时，可以通过在索引语法后附加一个 {lit}`?` 来将检查推迟到运行时。

-- # Functors
# 函子
%%%
tag := "functors"
%%%

-- A functor is a polymorphic type that supports a mapping operation.
-- This mapping operation transforms all elements “in place”, changing no other structure.
-- For instance, lists are functors and the mapping operation may neither drop, duplicate, nor mix up entries in the list.

函子是支持映射操作的多态类型。
此映射操作“就地”转换所有元素，不更改其他结构。
例如，列表是函子，映射操作既不能删除、复制，也不能混合列表中的条目。

-- While functors are defined by having {anchorName FunctorDef}`map`, the {anchorName FunctorDef}`Functor` type class in Lean contains an additional default method that is responsible for mapping the constant function over a value, replacing all values whose type are given by polymorphic type variable with the same new value.
-- For some functors, this can be done more efficiently than traversing the entire structure.

虽然函子是通过具有 {anchorName FunctorDef}`map` 来定义的，但 Lean 中的 {anchorName FunctorDef}`Functor` 类型类包含一个额外的默认方法，该方法负责将常量函数映射到一个值上，将所有由多态类型变量给出的类型的值替换为相同的新值。
对于某些函子，这比遍历整个结构更有效。

-- # Deriving Instances
# 派生实例
%%%
tag := "deriving-instances"
%%%

-- Many type classes have very standard implementations.
-- For instance, the Boolean equality class {moduleName}`BEq` is usually implemented by first checking whether both arguments are built with the same constructor, and then checking whether all their arguments are equal.
-- Instances for these classes can be created _automatically_.

许多类型类都有非常标准的实现。
例如，布尔相等类 {moduleName}`BEq` 通常通过首先检查两个参数是否都使用相同的构造函数构建，然后检查它们的所有参数是否相等来实现。
这些类的实例可以*自动*创建。

-- When defining an inductive type or a structure, a {kw}`deriving` clause at the end of the declaration will cause instances to be created automatically.
-- Additionally, the {kw}`deriving instance`﻿{lit}` ... `﻿{kw}`for`﻿{lit}` ...` command can be used outside of the definition of a datatype to cause an instance to be generated.
-- Because each class for which instances can be derived requires special handling, not all classes are derivable.

在定义归纳类型或结构时，声明末尾的 {kw}`deriving` 子句将导致自动创建实例。
此外，可以在数据类型定义之外使用 {kw}`deriving instance`﻿{lit}` ... `﻿{kw}`for`﻿{lit}` ...` 命令来生成实例。
因为可以为其派生实例的每个类都需要特殊处理，所以并非所有类都是可派生的。

-- # Coercions
# 强制类型转换
%%%
tag := "coercions"
%%%


-- Coercions allow Lean to recover from what would normally be a compile-time error by inserting a call to a function that transforms data from one type to another.
-- For example, the coercion from any type {anchorName CoeOption}`α` to the type {anchorTerm CoeOption}`Option α` allows values to be written directly, rather than with the {anchorName CoeOption}`some` constructor, making {anchorName CoeOption}`Option` work more like nullable types from object-oriented languages.

强制类型转换允许 Lean 通过插入一个将数据从一种类型转换为另一种类型的函数的调用来从通常是编译时错误中恢复。
例如，从任何类型 {anchorName CoeOption}`α` 到类型 {anchorTerm CoeOption}`Option α` 的强制类型转换允许直接写入值，而不是使用 {anchorName CoeOption}`some` 构造函数，从而使 {anchorName CoeOption}`Option` 的工作方式更像面向对象语言中的可空类型。

-- There are multiple kinds of coercion.
-- They can recover from different kinds of errors, and they are represented by their own type classes.
-- The {anchorName CoeOption}`Coe` class is used to recover from type errors.
-- When Lean has an expression of type {anchorName Coe}`α` in a context that expects something with type {anchorName Coe}`β`, Lean first attempts to string together a chain of coercions that can transform {anchorName Coe}`α`s into {anchorName Coe}`β`s, and only displays the error when this cannot be done.
-- The {moduleName}`CoeDep` class takes the specific value being coerced as an extra parameter, allowing either further type class search to be done on the value or allowing constructors to be used in the instance to limit the scope of the conversion.
-- The {moduleName}`CoeFun` class intercepts what would otherwise be a “not a function” error when compiling a function application, and allows the value in the function position to be transformed into an actual function if possible.

有多种强制类型转换。
它们可以从不同类型的错误中恢复，并且由它们自己的类型类表示。
{anchorName CoeOption}`Coe` 类用于从类型错误中恢复。
当 Lean 在需要类型为 {anchorName Coe}`β` 的上下文中具有类型为 {anchorName Coe}`α` 的表达式时，Lean 首先尝试将一系列可以将 {anchorName Coe}`α` 转换为 {anchorName Coe}`β` 的强制类型转换串在一起，并且只有在无法完成时才显示错误。
{moduleName}`CoeDep` 类将正在强制转换的特定值作为额外参数，允许对该值进行进一步的类型类搜索，或者允许在实例中使用构造函数来限制转换的范围。
{moduleName}`CoeFun` 类在编译函数应用程序时会截获否则会是“不是函数”的错误，并允许将函数位置的值转换为实际函数（如果可能）。
