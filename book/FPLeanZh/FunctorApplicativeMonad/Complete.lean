import VersoManual
import FPLeanZh.Examples

open Verso.Genre Manual
open Verso Code External

open FPLeanZh

set_option verso.exampleProject "../examples"
set_option verso.exampleModule "Examples.FunctorApplicativeMonad.ActualDefs"

#doc (Manual) "完整定义" =>

-- Now that all the relevant language features have been presented, this section describes the complete, honest definitions of {anchorName HonestFunctor}`Functor`, {anchorName Applicative}`Applicative`, and {anchorName Monad}`Monad` as they occur in the Lean standard library.
-- For the sake of understanding, no details are omitted.

现在所有相关的语言特性都已介绍完毕，本节将描述 Lean 标准库中 {anchorName HonestFunctor}`Functor`、{anchorName Applicative}`Applicative` 和 {anchorName Monad}`Monad` 的完整、真实的定义。
为了便于理解，没有省略任何细节。

-- # Functor

# 函子

-- The complete definition of the {anchorName Applicative}`Functor` class makes use of universe polymorphism and a default method implementation:

{anchorName Applicative}`Functor` 类的完整定义利用了宇宙多态性和默认方法实现：

```anchor HonestFunctor
class Functor (f : Type u → Type v) : Type (max (u+1) v) where
  map : {α β : Type u} → (α → β) → f α → f β
  mapConst : {α β : Type u} → α → f β → f α :=
    Function.comp map (Function.const _)
```

-- In this definition, {anchorName HonestFunctor}`Function.comp` is function composition, which is typically written with the {lit}`∘` operator.
-- {anchorName HonestFunctor}`Function.const` is the _constant function_, which is a two-argument function that ignores its second argument.
-- Applying this function to only one argument produces a function that always returns the same value, which is useful when an API demands a function but a program doesn't need to compute different results for different arguments.
-- A simple version of {anchorName HonestFunctor}`Function.const` can be written as follows:

在此定义中，{anchorName HonestFunctor}`Function.comp` 是函数组合，通常用 {lit}`∘` 运算符表示。
{anchorName HonestFunctor}`Function.const` 是__常量函数__，它是一个忽略其第二个参数的二元函数。
仅将此函数应用于一个参数会产生一个始终返回相同值的函数，这在 API 需要函数但程序不需要为不同参数计算不同结果时很有用。
{anchorName HonestFunctor}`Function.const` 的简单版本可以这样编写：

```anchor simpleConst
def simpleConst  (x : α) (_ : β) : α := x
```

-- Using it with one argument as the function argument to {anchorTerm extras}`List.map` demonstrates its utility:

将其与一个参数作为 {anchorTerm extras}`List.map` 的函数参数一起使用，可以展示其效用：

```anchor mapConst
#eval [1, 2, 3].map (simpleConst "same")
```
```anchorInfo mapConst
["same", "same", "same"]
```

-- The actual function has the following signature:

实际函数具有以下签名：

```anchorInfo FunctionConstType
Function.const.{u, v} {α : Sort u} (β : Sort v) (a : α) : β → α
```

-- Here, the type argument {anchorName HonestFunctor}`β` is an explicit argument, so the default definition of {anchorName HonestFunctor}`mapConst` provides an {anchorTerm HonestFunctor}`_` argument that instructs Lean to find a unique type to pass to {anchorName HonestFunctor}`Function.const` that would cause the program to type check.
-- {anchorTerm unfoldCompConst}`Function.comp map (Function.const _)` is equivalent to {anchorTerm unfoldCompConst}`fun (x : α) (y : f β) => map (fun _ => x) y`.

在这里，类型参数 {anchorName HonestFunctor}`β` 是一个显式参数，因此 {anchorName HonestFunctor}`mapConst` 的默认定义提供了一个 {anchorTerm HonestFunctor}`_` 参数，该参数指示 Lean 找到一个唯一的类型传递给 {anchorName HonestFunctor}`Function.const`，这将导致程序进行类型检查。
{anchorTerm unfoldCompConst}`Function.comp map (Function.const _)` 等价于 {anchorTerm unfoldCompConst}`fun (x : α) (y : f β) => map (fun _ => x) y`。

-- The {anchorName HonestFunctor}`Functor` type class inhabits a universe that is the greater of {anchorTerm HonestFunctor}`u+1` and {anchorTerm HonestFunctor}`v`.
-- Here, {anchorTerm HonestFunctor}`u` is the level of universes accepted as arguments to {anchorName HonestFunctor}`f`, while {anchorTerm HonestFunctor}`v` is the universe returned by {anchorName HonestFunctor}`f`.
-- To see why the structure that implements the {anchorName HonestFunctor}`Functor` type class must be in a universe that's larger than {anchorTerm HonestFunctor}`u`, begin with a simplified definition of the class:

{anchorName HonestFunctor}`Functor` 类型类存在于一个宇宙中，该宇宙是 {anchorTerm HonestFunctor}`u+1` 和 {anchorTerm HonestFunctor}`v` 中较大的一个。
在这里，{anchorTerm HonestFunctor}`u` 是作为 {anchorName HonestFunctor}`f` 参数接受的宇宙级别，而 {anchorTerm HonestFunctor}`v` 是 {anchorName HonestFunctor}`f` 返回的宇宙。
要了解为什么实现 {anchorName HonestFunctor}`Functor` 类型类的结构必须位于比 {anchorTerm HonestFunctor}`u` 更大的宇宙中，请从类的简化定义开始：

```anchor FunctorSimplified
class Functor (f : Type u → Type v) : Type (max (u+1) v) where
  map : {α β : Type u} → (α → β) → f α → f β
```

-- This type class's structure type is equivalent to the following inductive type:

此类型类的结构类型等效于以下归纳类型：

```anchor FunctorDatatype
inductive Functor (f : Type u → Type v) : Type (max (u+1) v) where
  | mk : ({α β : Type u} → (α → β) → f α → f β) → Functor f
```

-- The implementation of the {lit}`map` method that is passed as an argument to {anchorName FunctorDatatype}`mk` contains a function that takes two types in {anchorTerm FunctorDatatype}`Type u` as arguments.
-- This means that the type of the function itself is in {lit}`Type (u+1)`, so {anchorName FunctorDatatype}`Functor` must also be at a level that is at least {anchorTerm FunctorDatatype}`u+1`.
-- Similarly, other arguments to the function have a type built by applying {anchorName FunctorDatatype}`f`, so it must also have a level that is at least {anchorTerm FunctorDatatype}`v`.
-- All the type classes in this section share this property.

作为参数传递给 {anchorName FunctorDatatype}`mk` 的 {lit}`map` 方法的实现包含一个函数，该函数接受 {anchorTerm FunctorDatatype}`Type u` 中的两种类型作为参数。
这意味着函数本身的类型在 {lit}`Type (u+1)` 中，因此 {anchorName FunctorDatatype}`Functor` 也必须至少在 {anchorTerm FunctorDatatype}`u+1` 级别。
同样，函数的其他参数具有通过应用 {anchorName FunctorDatatype}`f` 构建的类型，因此它也必须至少具有 {anchorTerm FunctorDatatype}`v` 级别。
本节中的所有类型类都共享此属性。

-- # Applicative

# Applicative

-- The {anchorName Applicative}`Applicative` type class is actually built from a number of smaller classes that each contain some of the relevant methods.
-- The first are {anchorName Applicative}`Pure` and {anchorName Applicative}`Seq`, which contain {anchorName Applicative}`pure` and {anchorName Seq}`seq` respectively:

{anchorName Applicative}`Applicative` 类型类实际上是由许多较小的类构建的，每个类都包含一些相关方法。
首先是 {anchorName Applicative}`Pure` 和 {anchorName Applicative}`Seq`，它们分别包含 {anchorName Applicative}`pure` 和 {anchorName Seq}`seq`：

```anchor Pure
class Pure (f : Type u → Type v) : Type (max (u+1) v) where
  pure {α : Type u} : α → f α
```

```anchor Seq
class Seq (f : Type u → Type v) : Type (max (u+1) v) where
  seq : {α β : Type u} → f (α → β) → (Unit → f α) → f β
```

-- In addition to these, {anchorName Applicative}`Applicative` also depends on {anchorName SeqRight}`SeqRight` and an analogous {anchorName SeqLeft}`SeqLeft` class:

除了这些之外，{anchorName Applicative}`Applicative` 还依赖于 {anchorName SeqRight}`SeqRight` 和类似的 {anchorName SeqLeft}`SeqLeft` 类：

```anchor SeqRight
class SeqRight (f : Type u → Type v) : Type (max (u+1) v) where
  seqRight : {α β : Type u} → f α → (Unit → f β) → f β
```

```anchor SeqLeft
class SeqLeft (f : Type u → Type v) : Type (max (u+1) v) where
  seqLeft : {α β : Type u} → f α → (Unit → f β) → f α
```

-- The {anchorName SeqRight}`seqRight` function, which was introduced in the {ref "alternative"}[section about alternatives and validation], is easiest to understand from the perspective of effects.
-- {anchorTerm seqRightSugar (module := Examples.FunctorApplicativeMonad)}`E1 *> E2`, which desugars to {anchorTerm seqRightSugar (module := Examples.FunctorApplicativeMonad)}`SeqRight.seqRight E1 (fun () => E2)`, can be understood as first executing {anchorName seqRightSugar (module:=Examples.FunctorApplicativeMonad)}`E1`, and then {anchorName seqRightSugar (module:=Examples.FunctorApplicativeMonad)}`E2`, resulting only in {anchorName seqRightSugar (module:=Examples.FunctorApplicativeMonad)}`E2`'s result.
-- Effects from {anchorName seqRightSugar (module:=Examples.FunctorApplicativeMonad)}`E1` may result in {anchorName seqRightSugar (module:=Examples.FunctorApplicativeMonad)}`E2` not being run, or being run multiple times.
-- Indeed, if {anchorName SeqRight}`f` has a {anchorName Monad}`Monad` instance, then {anchorTerm seqRightSugar (module:=Examples.FunctorApplicativeMonad)}`E1 *> E2` is equivalent to {lit}`do let _ ← E1; E2`, but {anchorName SeqRight}`seqRight` can be used with types like {anchorName Validate (module:=Examples.FunctorApplicativeMonad)}`Validate` that are not monads.

{anchorName SeqRight}`seqRight` 函数（在 {ref "alternative"}[替代方案和验证部分] 中介绍）从效果的角度最容易理解。
{anchorTerm seqRightSugar (module := Examples.FunctorApplicativeMonad)}`E1 *> E2`，它脱糖为 {anchorTerm seqRightSugar (module := Examples.FunctorApplicativeMonad)}`SeqRight.seqRight E1 (fun () => E2)`，可以理解为首先执行 {anchorName seqRightSugar (module:=Examples.FunctorApplicativeMonad)}`E1`，然后执行 {anchorName seqRightSugar (module:=Examples.FunctorApplicativeMonad)}`E2`，只产生 {anchorName seqRightSugar (module:=Examples.FunctorApplicativeMonad)}`E2` 的结果。
来自 {anchorName seqRightSugar (module:=Examples.FunctorApplicativeMonad)}`E1` 的效果可能导致 {anchorName seqRightSugar (module:=Examples.FunctorApplicativeMonad)}`E2` 不运行，或运行多次。
实际上，如果 {anchorName SeqRight}`f` 有一个 {anchorName Monad}`Monad` 实例，那么 {anchorTerm seqRightSugar (module:=Examples.FunctorApplicativeMonad)}`E1 *> E2` 等价于 {lit}`do let _ ← E1; E2`，但 {anchorName SeqRight}`seqRight` 可以与像 {anchorName Validate (module:=Examples.FunctorApplicativeMonad)}`Validate` 这样不是单子的类型一起使用。

-- Its cousin {anchorName SeqLeft}`seqLeft` is very similar, except the leftmost expression's value is returned.
-- {anchorTerm seqLeftSugar}`E1 <* E2` desugars to {anchorTerm seqLeftSugar}`SeqLeft.seqLeft E1 (fun () => E2)`.
-- {anchorTerm seqLeftType}`SeqLeft.seqLeft` has type {anchorTerm seqLeftType}`f α → (Unit → f β) → f α`, which is identical to that of {anchorName SeqRight}`seqRight` except for the fact that it returns {anchorTerm SeqLeft}`f α`.
-- {anchorTerm seqLeftSugar}`E1 <* E2` can be understood as a program that first executes {anchorName seqLeftSugar}`E1`, and then {anchorName seqLeftSugar}`E2`, returning the original result for {anchorName seqLeftSugar}`E1`.
-- If {anchorName SeqLeft}`f` has a {anchorName Monad}`Monad` instance, then {anchorTerm seqLeftSugar}`E1 <* E2` is equivalent to {lit}`do let x ← E1; _ ← E2; pure x`.
-- Generally speaking, {anchorName SeqLeft}`seqLeft` is useful for specifying extra conditions on a value in a validation or parser-like workflow without changing the value itself.

它的近亲 {anchorName SeqLeft}`seqLeft` 非常相似，只是返回最左边表达式的值。
{anchorTerm seqLeftSugar}`E1 <* E2` 脱糖为 {anchorTerm seqLeftSugar}`SeqLeft.seqLeft E1 (fun () => E2)`。
{anchorTerm seqLeftType}`SeqLeft.seqLeft` 的类型是 {anchorTerm seqLeftType}`f α → (Unit → f β) → f α`，除了它返回 {anchorTerm SeqLeft}`f α` 之外，它与 {anchorName SeqRight}`seqRight` 的类型相同。
{anchorTerm seqLeftSugar}`E1 <* E2` 可以理解为一个程序，它首先执行 {anchorName seqLeftSugar}`E1`，然后执行 {anchorName seqLeftSugar}`E2`，返回 {anchorName seqLeftSugar}`E1` 的原始结果。
如果 {anchorName SeqLeft}`f` 有一个 {anchorName Monad}`Monad` 实例，那么 {anchorTerm seqLeftSugar}`E1 <* E2` 等价于 {lit}`do let x ← E1; _ ← E2; pure x`。
一般来说，{anchorName SeqLeft}`seqLeft` 对于在验证或类似解析器的工作流中指定值的额外条件而无需更改值本身很有用。

-- The definition of {anchorName Applicative}`Applicative` extends all these classes, along with {anchorName Applicative}`Functor`:

{anchorName Applicative}`Applicative` 的定义扩展了所有这些类，以及 {anchorName Applicative}`Functor`：

```anchor Applicative
class Applicative (f : Type u → Type v)
    extends Functor f, Pure f, Seq f, SeqLeft f, SeqRight f where
  map      := fun x y => Seq.seq (pure x) fun _ => y
  seqLeft  := fun a b => Seq.seq (Functor.map (Function.const _) a) b
  seqRight := fun a b => Seq.seq (Functor.map (Function.const _ id) a) b
```

-- A complete definition of {anchorName Applicative}`Applicative` requires only definitions for {anchorName Applicative}`pure` and {anchorName Seq}`seq`.
-- This is because there are default definitions for all of the methods from {anchorName Applicative}`Functor`, {anchorName SeqLeft}`SeqLeft`, and {anchorName SeqRight}`SeqRight`.
-- The {anchorName HonestFunctor}`mapConst` method of {anchorName HonestFunctor}`Functor` has its own default implementation in terms of {anchorName Applicative}`Functor.map`.
-- These default implementations should only be overridden with new functions that are behaviorally equivalent, but more efficient.
-- The default implementations should be seen as specifications for correctness as well as automatically-created code.

{anchorName Applicative}`Applicative` 的完整定义只需要 {anchorName Applicative}`pure` 和 {anchorName Seq}`seq` 的定义。
这是因为 {anchorName Applicative}`Functor`、{anchorName SeqLeft}`SeqLeft` 和 {anchorName SeqRight}`SeqRight` 的所有方法都有默认定义。
{anchorName HonestFunctor}`Functor` 的 {anchorName HonestFunctor}`mapConst` 方法有其自己的基于 {anchorName Applicative}`Functor.map` 的默认实现。
这些默认实现只应被行为等效但更高效的新函数覆盖。
默认实现应被视为正确性的规范以及自动生成的代码。

-- The default implementation for {anchorName SeqLeft}`seqLeft` is very compact.
-- Replacing some of the names with their syntactic sugar or their definitions can provide another view on it, so:

{anchorName SeqLeft}`seqLeft` 的默认实现非常紧凑。
用它们的语法糖或定义替换一些名称可以提供另一种视图，因此：

```anchorTerm unfoldMapConstSeqLeft
Seq.seq (Functor.map (Function.const _) a) b
```

-- becomes

变为

```anchorTerm unfoldMapConstSeqLeft
fun a b => Seq.seq ((fun x _ => x) <$> a) b
```

-- How should {anchorTerm unfoldMapConstSeqLeft}`(fun x _ => x) <$> a` be understood?
-- Here, {anchorName unfoldMapConstSeqLeft}`a` has type {anchorTerm unfoldMapConstSeqLeft}`f α`, and {anchorName unfoldMapConstSeqLeft}`f` is a functor.
-- If {anchorName unfoldMapConstSeqLeft}`f` is {anchorName extras}`List`, then {anchorTerm mapConstList}`(fun x _ => x) <$> [1, 2, 3]` evaluates to {anchorTerm mapConstList}`[fun _ => 1, fun _ => 2, fun _ => 3`.
-- If {anchorName unfoldMapConstSeqLeft}`f` is {anchorName mapConstOption}`Option`, then {anchorTerm mapConstOption}`(fun x _ => x) <$> some "hello"` evaluates to {anchorTerm mapConstOption}`some (fun _ => "hello")`.
-- In each case, the values in the functor are replaced by functions that return the original value, ignoring their argument.
-- When combined with {anchorName Seq}`seq`, this function discards the values from {anchorName Seq}`seq`'s second argument.

如何理解 {anchorTerm unfoldMapConstSeqLeft}`(fun x _ => x) <$> a`？
这里，{anchorName unfoldMapConstSeqLeft}`a` 的类型是 {anchorTerm unfoldMapConstSeqLeft}`f α`，而 {anchorName unfoldMapConstSeqLeft}`f` 是一个函子。
如果 {anchorName unfoldMapConstSeqLeft}`f` 是 {anchorName extras}`List`，那么 {anchorTerm mapConstList}`(fun x _ => x) <$> [1, 2, 3]` 的计算结果是 {anchorTerm mapConstList}`[fun _ => 1, fun _ => 2, fun _ => 3`。
如果 {anchorName unfoldMapConstSeqLeft}`f` 是 {anchorName mapConstOption}`Option`，那么 {anchorTerm mapConstOption}`(fun x _ => x) <$> some "hello"` 的计算结果是 {anchorTerm mapConstOption}`some (fun _ => "hello")`。
在每种情况下，函子中的值都被替换为返回原始值并忽略其参数的函数。
当与 {anchorName Seq}`seq` 结合时，此函数会丢弃 {anchorName Seq}`seq` 的第二个参数中的值。

-- The default implementation for {anchorName SeqRight}`seqRight` is very similar, except {anchorName FunctionConstType}`Function.const` has an additional argument {anchorName Applicative}`id`.
-- This definition can be understood similarly, by first introducing some standard syntactic sugar and then replacing some names with their definitions:

{anchorName SeqRight}`seqRight` 的默认实现非常相似，只是 {anchorName FunctionConstType}`Function.const` 有一个额外的参数 {anchorName Applicative}`id`。
这个定义可以类似地理解，首先引入一些标准语法糖，然后用它们的定义替换一些名称：

```anchorEvalSteps unfoldMapConstSeqRight
fun a b => Seq.seq (Functor.map (Function.const _ id) a) b
===>
fun a b => Seq.seq ((fun _ => id) <$> a) b
===>
fun a b => Seq.seq ((fun _ => fun x => x) <$> a) b
===>
fun a b => Seq.seq ((fun _ x => x) <$> a) b
```

-- How should {anchorTerm unfoldMapConstSeqRight}`(fun _ x => x) <$> a` be understood?
-- Once again, examples are useful.
-- {anchorTerm mapConstIdList}`fun _ x => x) <$> [1, 2, 3]` is equivalent to {anchorTerm mapConstIdList}`[fun x => x, fun x => x, fun x => x]`, and {anchorTerm mapConstIdOption}`(fun _ x => x) <$> some "hello"` is equivalent to {anchorTerm mapConstIdOption}`some (fun x => x)`.
-- In other words, {anchorTerm unfoldMapConstSeqRight}`(fun _ x => x) <$> a` preserves the overall shape of {anchorName unfoldMapConstSeqRight}`a`, but each value is replaced by the identity function.
-- From the perspective of effects, the side effects of {anchorName unfoldMapConstSeqRight}`a` occur, but the values are thrown out when it is used with {anchorName Seq}`seq`.

如何理解 {anchorTerm unfoldMapConstSeqRight}`(fun _ x => x) <$> a`？
再次，示例很有用。
{anchorTerm mapConstIdList}`fun _ x => x) <$> [1, 2, 3]` 等价于 {anchorTerm mapConstIdList}`[fun x => x, fun x => x, fun x => x]`，而 {anchorTerm mapConstIdOption}`(fun _ x => x) <$> some "hello"` 等价于 {anchorTerm mapConstIdOption}`some (fun x => x)`。
换句话说，{anchorTerm unfoldMapConstSeqRight}`(fun _ x => x) <$> a` 保留了 {anchorName unfoldMapConstSeqRight}`a` 的整体形状，但每个值都被替换为恒等函数。
从效果的角度来看，{anchorName unfoldMapConstSeqRight}`a` 的副作用发生，但当它与 {anchorName Seq}`seq` 一起使用时，这些值被丢弃。

-- # Monad

# Monad

-- Just as the constituent operations of {anchorName Applicative}`Applicative` are split into their own type classes, {anchorName Bind}`Bind` has its own class as well:

就像 {anchorName Applicative}`Applicative` 的组成操作被拆分为它们自己的类型类一样，{anchorName Bind}`Bind` 也有自己的类：

```anchor Bind
class Bind (m : Type u → Type v) where
  bind : {α β : Type u} → m α → (α → m β) → m β
```

-- {anchorName Monad}`Monad` extends {anchorName Applicative}`Applicative` with {anchorName Bind}`Bind`:

{anchorName Monad}`Monad` 扩展了 {anchorName Applicative}`Applicative` 和 {anchorName Bind}`Bind`：

```anchor Monad
class Monad (m : Type u → Type v) : Type (max (u+1) v)
    extends Applicative m, Bind m where
  map      f x := bind x (Function.comp pure f)
  seq      f x := bind f fun y => Functor.map y (x ())
  seqLeft  x y := bind x fun a => bind (y ()) (fun _ => pure a)
  seqRight x y := bind x fun _ => y ()
```

-- Tracing the collection of inherited methods and default methods from the entire hierarchy shows that a {anchorName Monad}`Monad` instance requires only implementations of {anchorName Bind}`bind` and {anchorName Pure}`pure`.
-- In other words, {anchorName Monad}`Monad` instances automatically yield implementations of {anchorName Seq}`seq`, {anchorName SeqLeft}`seqLeft`, {anchorName SeqRight}`seqRight`, {anchorName HonestFunctor}`map`, and {anchorName HonestFunctor}`mapConst`.
-- From the perspective of API boundaries, any type with a {anchorName Monad}`Monad` instance gets instances for {anchorName Bind}`Bind`, {anchorName Pure}`Pure`, {anchorName Seq}`Seq`, {anchorName Applicative}`Functor`, {anchorName SeqLeft}`SeqLeft`, and {anchorName SeqRight}`SeqRight`.

追踪整个层次结构中继承的方法和默认方法的集合表明，{anchorName Monad}`Monad` 实例只需要实现 {anchorName Bind}`bind` 和 {anchorName Pure}`pure`。
换句话说，{anchorName Monad}`Monad` 实例会自动生成 {anchorName Seq}`seq`、{anchorName SeqLeft}`seqLeft`、{anchorName SeqRight}`seqRight`、{anchorName HonestFunctor}`map` 和 {anchorName HonestFunctor}`mapConst` 的实现。
从 API 边界的角度来看，任何具有 {anchorName Monad}`Monad` 实例的类型都会获得 {anchorName Bind}`Bind`、{anchorName Pure}`Pure`、{anchorName Seq}`Seq`、{anchorName Applicative}`Functor`、{anchorName SeqLeft}`SeqLeft` 和 {anchorName SeqRight}`SeqRight` 的实例。


-- # Exercises

# 练习

--  1. Understand the default implementations of {anchorName HonestFunctor}`map`, {anchorName Seq}`seq`, {anchorName SeqLeft}`seqLeft`, and {anchorName SeqRight}`seqRight` in {anchorName Monad}`Monad` by working through examples such as {anchorName mapConstOption}`Option` and {anchorName ApplicativeExcept (module:=Examples.FunctorApplicativeMonad)}`Except`. In other words, substitute their definitions for {anchorName Bind}`bind` and {anchorName Pure}`pure` into the default definitions, and simplify them to recover the versions {anchorName HonestFunctor}`map`, {anchorName Seq}`seq`, {anchorName SeqLeft}`seqLeft`, and {anchorName SeqRight}`seqRight` that would be written by hand.
--  2. On paper or in a text file, prove to yourself that the default implementations of {anchorName HonestFunctor}`map` and {anchorName Seq}`seq` satisfy the contracts for {anchorName Applicative}`Functor` and {anchorName Applicative}`Applicative`. In this argument, you're allowed to use the rules from the {anchorName Monad}`Monad` contract as well as ordinary expression evaluation.

 1. 通过 {anchorName mapConstOption}`Option` 和 {anchorName ApplicativeExcept (module:=Examples.FunctorApplicativeMonad)}`Except` 等示例，理解 {anchorName Monad}`Monad` 中 {anchorName HonestFunctor}`map`、{anchorName Seq}`seq`、{anchorName SeqLeft}`seqLeft` 和 {anchorName SeqRight}`seqRight` 的默认实现。换句话说，将它们对 {anchorName Bind}`bind` 和 {anchorName Pure}`pure` 的定义代入默认定义，并简化它们以恢复手动编写的 {anchorName HonestFunctor}`map`、{anchorName Seq}`seq`、{anchorName SeqLeft}`seqLeft` 和 {anchorName SeqRight}`seqRight` 版本。
 2. 在纸上或文本文件中，向自己证明 {anchorName HonestFunctor}`map` 和 {anchorName Seq}`seq` 的默认实现满足 {anchorName Applicative}`Functor` 和 {anchorName Applicative}`Applicative` 的契约。在此论证中，您可以使用 {anchorName Monad}`Monad` 契约中的规则以及普通表达式求值。
