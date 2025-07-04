import VersoManual
import FPLeanZh.Examples

open Verso.Genre Manual
open Verso Code External

open FPLeanZh

set_option verso.exampleProject "../examples"
set_option verso.exampleModule "Examples.FunctorApplicativeMonad.ActualDefs"

#doc (Manual) "总结" =>

-- # Type Classes and Structures

# 类型类和结构

-- Behind the scenes, type classes are represented by structures.
-- Defining a class defines a structure, and additionally creates an empty table of instances.
-- Defining an instance creates a value that either has the structure as its type or is a function that can return the structure, and additionally adds an entry to the table.
-- Instance search consists of constructing an instance by consulting the instance tables.
-- Both structures and classes may provide default values for fields (which are default implementations of methods).

在幕后，类型类由结构表示。
定义一个类会定义一个结构，并额外创建一个空的实例表。
定义一个实例会创建一个值，该值要么以该结构作为其类型，要么是一个可以返回该结构的函数，并额外向表中添加一个条目。
实例搜索包括通过查询实例表来构造一个实例。
结构和类都可以为字段提供默认值（即方法的默认实现）。

-- # Structures and Inheritance

# 结构和继承

-- Structures may inherit from other structures.
-- Behind the scenes, a structure that inherits from another structure contains an instance of the original structure as a field.
-- In other words, inheritance is implemented with composition.
-- When multiple inheritance is used, only the unique fields from the additional parent structures are used to avoid a diamond problem, and the functions that would normally extract the parent value are instead organized to construct one.
-- Record dot notation takes structure inheritance into account.

结构可以继承自其他结构。
在幕后，一个继承自另一个结构的结构包含原始结构的一个实例作为字段。
换句话说，继承是通过组合实现的。
当使用多重继承时，只使用额外父结构中的唯一字段来避免菱形问题，并且通常会提取父值的函数被组织成构造一个。
记录点表示法考虑了结构继承。

-- Because type classes are just structures with some additional automation applied, all of these features are available in type classes.
-- Together with default methods, this can be used to create a fine-grained hierarchy of interfaces that nonetheless does not impose a large burden on clients, because the small classes that the large classes inherit from can be automatically implemented.

因为类型类只是应用了一些额外自动化的结构，所以所有这些功能都可以在类型类中使用。
结合默认方法，这可以用于创建接口的细粒度层次结构，尽管如此，它不会给客户端带来很大的负担，因为大类继承的小类可以自动实现。

-- # Applicative Functors

# Applicative 函子

-- An applicative functor is a functor with two additional operations:
--  * {anchorName Applicative}`pure`, which is the same operator as that for {anchorName Monad}`Monad`
--  * {anchorName Seq}`seq`, which allows a function to be applied in the context of the functor.

Applicative 函子是一个具有两个额外操作的函子：
 * {anchorName Applicative}`pure`，它与 {anchorName Monad}`Monad` 的运算符相同
 * {anchorName Seq}`seq`，它允许在函子的上下文中应用函数。

-- While monads can represent arbitrary programs with control flow, applicative functors can only run function arguments from left to right.
-- Because they are less powerful, they provide less control to programs written against the interface, while the implementor of the method has a greater degree of freedom.
-- Some useful types can implement {anchorName Applicative}`Applicative` but not {anchorName Monad}`Monad`.

虽然单子可以表示具有控制流的任意程序，但 Applicative 函子只能从左到右运行函数参数。
因为它们功能较弱，所以它们为针对接口编写的程序提供的控制较少，而方法的实现者具有更大的自由度。
一些有用的类型可以实现 {anchorName Applicative}`Applicative` 但不能实现 {anchorName Monad}`Monad`。

-- In fact, the type classes {anchorName HonestFunctor}`Functor`, {anchorName Applicative}`Applicative`, and {anchorName Monad}`Monad` form a hierarchy of power.
-- Moving up the hierarchy, from {anchorName HonestFunctor}`Functor` towards {anchorName Monad}`Monad`, allows more powerful programs to be written, but fewer types implement the more powerful classes.
-- Polymorphic programs should be written to use as weak of an abstraction as possible, while datatypes should be given instances that are as powerful as possible.
-- This maximizes code re-use.
-- The more powerful type classes extend the less powerful ones, which means that an implementation of {anchorName Monad}`Monad` provides implementations of {anchorName HonestFunctor}`Functor` and {anchorName Applicative}`Applicative` for free.

实际上，类型类 {anchorName HonestFunctor}`Functor`、{anchorName Applicative}`Applicative` 和 {anchorName Monad}`Monad` 形成了一个能力层次结构。
从 {anchorName HonestFunctor}`Functor` 向 {anchorName Monad}`Monad` 向上移动，可以编写更强大的程序，但实现更强大类的类型更少。
多态程序应该使用尽可能弱的抽象，而数据类型应该被赋予尽可能强大的实例。
这最大限度地提高了代码重用。
更强大的类型类扩展了功能较弱的类型类，这意味着 {anchorName Monad}`Monad` 的实现免费提供了 {anchorName HonestFunctor}`Functor` 和 {anchorName Applicative}`Applicative` 的实现。

-- Each class has a set of methods to be implemented and a corresponding contract that specifies additional rules for the methods.
-- Programs that are written against these interfaces expect that the additional rules are followed, and may be buggy if they are not.
-- The default implementations of {anchorName HonestFunctor}`Functor`'s methods in terms of {anchorName Applicative}`Applicative`'s, and of {anchorName Applicative}`Applicative`'s in terms of {anchorName Monad}`Monad`'s, will obey these rules.

每个类都有一组要实现的方法和相应的契约，该契约指定了方法的附加规则。
针对这些接口编写的程序期望遵循附加规则，否则可能会出现错误。
{anchorName HonestFunctor}`Functor` 的方法（以 {anchorName Applicative}`Applicative` 的方法表示）和 {anchorName Applicative}`Applicative` 的方法（以 {anchorName Monad}`Monad` 的方法表示）的默认实现将遵守这些规则。

-- # Universes

# 宇宙

-- To allow Lean to be used as both a programming language and a theorem prover, some restrictions on the language are necessary.
-- This includes restrictions on recursive functions that ensure that they all either terminate or are marked as {kw}`partial` and written to return types that are not uninhabited.
-- Additionally, it must be impossible to represent certain kinds of logical paradoxes as types.

为了使 Lean 既可以用作编程语言又可以用作定理证明器，对语言进行一些限制是必要的。
这包括对递归函数的限制，以确保它们要么终止，要么被标记为 {kw}`partial` 并编写为返回非空类型。
此外，必须不可能将某些逻辑悖论表示为类型。

-- One of the restrictions that rules out certain paradoxes is that every type is assigned to a _universe_.
-- Universes are types such as {anchorTerm extras}`Prop`, {anchorTerm extras}`Type`, {anchorTerm extras}`Type 1`, {anchorTerm extras}`Type 2`, and so forth.
-- These types describe other types—just as {anchorTerm extras}`0` and {anchorTerm extras}`17` are described by {anchorName extras}`Nat`, {anchorName extras}`Nat` is itself described by {anchorTerm extras}`Type`, and {anchorTerm extras}`Type` is described by {anchorTerm extras}`Type 1`.
-- The type of functions that take a type as an argument must be a larger universe than the argument's universe.

排除某些悖论的限制之一是每个类型都被分配到一个__宇宙__。
宇宙是诸如 {anchorTerm extras}`Prop`、{anchorTerm extras}`Type`、{anchorTerm extras}`Type 1`、{anchorTerm extras}`Type 2` 等类型。
这些类型描述其他类型——就像 {anchorTerm extras}`0` 和 {anchorTerm extras}`17` 由 {anchorName extras}`Nat` 描述一样，{anchorName extras}`Nat` 本身由 {anchorTerm extras}`Type` 描述，而 {anchorTerm extras}`Type` 由 {anchorTerm extras}`Type 1` 描述。
接受类型作为参数的函数的类型必须是比参数宇宙更大的宇宙。

-- Because each declared datatype has a universe, writing code that uses types like data would quickly become annoying, requiring each polymorphic type to be copy-pasted to take arguments from {anchorTerm extras}`Type 1`.
-- A feature called _universe polymorphism_ allows Lean programs and datatypes to take universe levels as arguments, just as ordinary polymorphism allows programs to take types as arguments.
-- Generally speaking, Lean libraries should use universe polymorphism when implementing libraries of polymorphic operations.

因为每个声明的数据类型都有一个宇宙，所以编写使用类型作为数据的代码会很快变得烦人，需要复制粘贴每个多态类型以从 {anchorTerm extras}`Type 1` 获取参数。
一个名为__宇宙多态__的功能允许 Lean 程序和数据类型将宇宙级别作为参数，就像普通多态允许程序将类型作为参数一样。
一般来说，Lean 库在实现多态操作库时应该使用宇宙多态。
