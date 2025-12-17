import VersoManual
import FPLeanZh.Examples

open Verso.Genre Manual
open Verso Code External

open FPLeanZh

set_option verso.exampleProject "../examples"
set_option verso.exampleModule "Examples.Classes"

set_option pp.rawOnError true

-- Standard Classes
#doc (Manual) "标准类" =>
%%%
file := "StandardClasses"
tag := "standard-classes"
%%%

-- This section presents a variety of operators and functions that can be overloaded using type classes in Lean.
-- Each operator or function corresponds to a method of a type class.
-- Unlike C++, infix operators in Lean are defined as abbreviations for named functions; this means that overloading them for new types is not done using the operator itself, but rather using the underlying name (such as {moduleName}`HAdd.hAdd`).

本节介绍在 Lean 中可以使用类型类重载的各种运算符和函数。每个运算符或函数都对应一个类型类的方法。
与 C++ 不同，Lean 中的中缀运算符被定义为命名函数的缩写；这意味着为新类型重载它们不是使用运算符本身，而是使用底层名称（例如 {moduleName}`HAdd.hAdd`）。

-- # Arithmetic
# 算术
%%%
tag := "arithmetic-classes"
%%%

-- Most arithmetic operators are available in a heterogeneous form, where the arguments may have different type and an output parameter decides the type of the resulting expression.
-- For each heterogeneous operator, there is a corresponding homogeneous version that can found by removing the letter {lit}`h`, so that {moduleName}`HAdd.hAdd` becomes {moduleName}`Add.add`.
-- The following arithmetic operators are overloaded:

多数算术运算符都是可以进行异质运算的。这意味着参数可能有不同的类型，并且输出参数决定了结果表达式的类型。
对于每个异质运算符，都有一个同质运算符与其对应。可以通过删除字母 {lit}`h` 来找到，比如 {moduleName}`HAdd.hAdd` 变为 {moduleName}`Add.add`。
下面的算术运算符都可以被重载：

-- :::table +header
--
-- *
--  -  Expression
--  -  Desugaring
--  -  Class Name
-- *
--  -  {anchorTerm plusDesugar}`x + y`
--  -  {anchorTerm plusDesugar}`HAdd.hAdd x y`
--  -  {moduleName}`HAdd`
-- *
--  -  {anchorTerm minusDesugar}`x - y`
--  -  {anchorTerm minusDesugar}`HSub.hSub x y`
--  -  {moduleName}`HSub`
-- *
--  -  {anchorTerm timesDesugar}`x * y`
--  -  {anchorTerm timesDesugar}`HMul.hMul x y`
--  -  {moduleName}`HMul`
-- *
--  -  {anchorTerm divDesugar}`x / y`
--  -  {anchorTerm divDesugar}`HDiv.hDiv x y`
--  -  {moduleName}`HDiv`
-- *
--  -  {anchorTerm modDesugar}`x % y`
--  -  {anchorTerm modDesugar}`HMod.hMod x y`
--  -  {moduleName}`HMod`
-- *
--  -  {anchorTerm powDesugar}`x ^ y`
--  -  {anchorTerm powDesugar}`HPow.hPow x y`
--  -  {moduleName}`HPow`
-- *
--  -  {anchorTerm negDesugar}`- x`
--  -  {anchorTerm negDesugar}`Neg.neg x`
--  -  {moduleName}`Neg`
--
--
-- :::

:::table +header

*
 -  表达式
 -  脱糖后
 -  类名
*
 -  {anchorTerm plusDesugar}`x + y`
 -  {anchorTerm plusDesugar}`HAdd.hAdd x y`
 -  {moduleName}`HAdd`
*
 -  {anchorTerm minusDesugar}`x - y`
 -  {anchorTerm minusDesugar}`HSub.hSub x y`
 -  {moduleName}`HSub`
*
 -  {anchorTerm timesDesugar}`x * y`
 -  {anchorTerm timesDesugar}`HMul.hMul x y`
 -  {moduleName}`HMul`
*
 -  {anchorTerm divDesugar}`x / y`
 -  {anchorTerm divDesugar}`HDiv.hDiv x y`
 -  {moduleName}`HDiv`
*
 -  {anchorTerm modDesugar}`x % y`
 -  {anchorTerm modDesugar}`HMod.hMod x y`
 -  {moduleName}`HMod`
*
 -  {anchorTerm powDesugar}`x ^ y`
 -  {anchorTerm powDesugar}`HPow.hPow x y`
 -  {moduleName}`HPow`
*
 -  {anchorTerm negDesugar}`- x`
 -  {anchorTerm negDesugar}`Neg.neg x`
 -  {moduleName}`Neg`

:::

-- # Bitwise Operators
# 位运算符
%%%
tag := "bitwise-classes"
%%%

-- Lean contains a number of standard bitwise operators that are overloaded using type classes.
-- There are instances for fixed-width types such as {anchorTerm UInt8}`UInt8`, {anchorTerm UInt16}`UInt16`, {anchorTerm UInt32}`UInt32`, {anchorTerm UInt64}`UInt64`, and {anchorTerm USize}`USize`.
-- The latter is the size of words on the current platform, typically 32 or 64 bits.
-- The following bitwise operators are overloaded:

Lean 包含许多使用类型类重载的标准位运算符。
对于固定宽度的类型，例如 {anchorTerm UInt8}`UInt8`、{anchorTerm UInt16}`UInt16`、{anchorTerm UInt32}`UInt32`、{anchorTerm UInt64}`UInt64` 和 {anchorTerm USize}`USize`，都有实例。
后者是当前平台上的字长，通常为 32 或 64 位。
以下位运算符被重载：

-- :::table +header
-- *
--  -  Expression
--  -  Desugaring
--  -  Class Name
--
-- *
--  -  {anchorTerm bAndDesugar}`x &&& y`
--  -  {anchorTerm bAndDesugar}`HAnd.hAnd x y`
--  -  {moduleName}`HAnd`
-- *
--  -  {anchorTerm bOrDesugar}`x ||| y`
--  -  {anchorTerm bOrDesugar}`HOr.hOr x y`
--  -  {moduleName}`HOr`
-- *
--  -  {anchorTerm bXorDesugar}`x ^^^ y`
--  -  {anchorTerm bXorDesugar}`HXor.hXor x y`
--  -  {moduleName}`HXor`
-- *
--  -  {anchorTerm complementDesugar}`~~~x`
--  -  {anchorTerm complementDesugar}`Complement.complement x`
--  -  {moduleName}`Complement`
-- *
--  -  {anchorTerm shrDesugar}`x >>> y`
--  -  {anchorTerm shrDesugar}`HShiftRight.hShiftRight x y`
--  -  {moduleName}`HShiftRight`
-- *
--  -  {anchorTerm shlDesugar}`x <<< y`
--  -  {anchorTerm shlDesugar}`HShiftLeft.hShiftLeft x y`
--  -  {moduleName}`HShiftLeft`
--
-- :::

:::table +header
*
 -  表达式
 -  脱糖后
 -  类名

*
 -  {anchorTerm bAndDesugar}`x &&& y`
 -  {anchorTerm bAndDesugar}`HAnd.hAnd x y`
 -  {moduleName}`HAnd`
*
 -  {anchorTerm bOrDesugar}`x ||| y`
 -  {anchorTerm bOrDesugar}`HOr.hOr x y`
 -  {moduleName}`HOr`
*
 -  {anchorTerm bXorDesugar}`x ^^^ y`
 -  {anchorTerm bXorDesugar}`HXor.hXor x y`
 -  {moduleName}`HXor`
*
 -  {anchorTerm complementDesugar}`~~~x`
 -  {anchorTerm complementDesugar}`Complement.complement x`
 -  {moduleName}`Complement`
*
 -  {anchorTerm shrDesugar}`x >>> y`
 -  {anchorTerm shrDesugar}`HShiftRight.hShiftRight x y`
 -  {moduleName}`HShiftRight`
*
 -  {anchorTerm shlDesugar}`x <<< y`
 -  {anchorTerm shlDesugar}`HShiftLeft.hShiftLeft x y`
 -  {moduleName}`HShiftLeft`

:::

-- Because the names {anchorName chapterIntro}`And` and {anchorName chapterIntro}`Or` are already taken as the names of logical connectives, the homogeneous versions of {anchorName chapterIntro}`HAnd` and {anchorName chapterIntro}`HOr` are called {anchorName moreOps}`AndOp` and {anchorName moreOps}`OrOp` rather than {anchorName chapterIntro}`And` and {anchorName chapterIntro}`Or`.

因为名称 {anchorName chapterIntro}`And` 和 {anchorName chapterIntro}`Or` 已被用作逻辑连接词的名称，所以 {anchorName chapterIntro}`HAnd` 和 {anchorName chapterIntro}`HOr` 的同质版本称为 {anchorName moreOps}`AndOp` 和 {anchorName moreOps}`OrOp`，而不是 {anchorName chapterIntro}`And` 和 {anchorName chapterIntro}`Or`。

-- # Equality and Ordering
# 等价性与有序性
%%%
tag := "equality-and-ordering"
%%%

-- Testing equality of two values typically uses the {moduleName}`BEq` class, which is short for “Boolean equality”.
-- Due to Lean's use as a theorem prover, there are really two kinds of equality operators in Lean:
--  * {deftech}_Boolean equality_ is the same kind of equality that is found in other programming languages. It is a function that takes two values and returns a {anchorName CoeBoolProp}`Bool`. Boolean equality is written with two equals signs, just as in Python and C#. Because Lean is a pure functional language, there's no separate notions of reference vs value equality—pointers cannot be observed directly.
--  * {deftech}_Propositional equality_ is the mathematical statement that two things are equal. Propositional equality is not a function; rather, it is a mathematical statement that admits proof. It is written with a single equals sign. A statement of propositional equality is like a type that classifies evidence of this equality.

测试两个值的等价性通常使用 {moduleName}`BEq` 类，它是 Boolean equality（布尔等价）的缩写。
由于 Lean 用作定理证明器，因此 Lean 中实际上有两种等价运算符：
 * {deftech}*布尔等价* 和你能在其他编程语言中看到的等价是一样的。它是一个接受两个值并返回一个 {anchorName CoeBoolProp}`Bool` 的函数。布尔等价用两个等号书写，就像在 Python 和 C# 中一样。因为 Lean 是一种纯函数式语言，指针并不能被直接看到，所以地址和值等价并没有符号上的区别。
 * {deftech}*命题等价* 是两个事物等价的数学陈述。命题等价不是一个函数；相反，它是一个承认证明的数学陈述。它用一个等号书写。命题等价的陈述就像一个对这种等价性的证据进行分类的类型。

-- Both notions of equality are important, and used for different purposes.
-- Boolean equality is useful in programs, when a decision needs to be made about whether two values are equal.
-- For example, {anchorTerm boolEqTrue}`"Octopus" ==  "Cuttlefish"` evaluates to {anchorTerm boolEqTrue}`false`, and {anchorTerm boolEqFalse}`"Octopodes" ==  "Octo".append "podes"` evaluates to {anchorTerm boolEqFalse}`true`.
-- Some values, such as functions, cannot be checked for equality.
-- For example, {anchorTerm functionEq}`(fun (x : Nat) => 1 + x) == (Nat.succ ·)` yields the error:

这两种等价都很重要，它们有不同的用处。布尔等价在程序中很有用，有时我们需要考察两个值是否是等价的。
例如，{anchorTerm boolEqTrue}`"Octopus" ==  "Cuttlefish"` 的结果为 {anchorTerm boolEqTrue}`false`，而 {anchorTerm boolEqFalse}`"Octopodes" ==  "Octo".append "podes"` 的结果为 {anchorTerm boolEqFalse}`true`。
某些值，例如函数，无法检查其等价性。例如，{anchorTerm functionEq}`(fun (x : Nat) => 1 + x) == (Nat.succ ·)` 会产生错误：

```anchorError functionEq
failed to synthesize
  BEq (Nat → Nat)

Hint: Additional diagnostic information may be available using the `set_option diagnostics true` command.
```

-- As this message indicates, {lit}`==` is overloaded using a type class.
-- The expression {anchorTerm beqDesugar}`x == y` is actually shorthand for {anchorTerm beqDesugar}`BEq.beq x y`.

正如该消息所示，{lit}`==` 是使用类型类重载的。
表达式 {anchorTerm beqDesugar}`x == y` 实际上是 {anchorTerm beqDesugar}`BEq.beq x y` 的简写。

-- Propositional equality is a mathematical statement rather than an invocation of a program.
-- Because propositions are like types that describe evidence for some statement, propositional equality has more in common with types like {anchorName readFile}`String` and {anchorTerm moreOps}`Nat → List Int` than it does with Boolean equality.
-- This means that it can't automatically be checked.
-- However, the equality of any two expressions can be stated in Lean, so long as they have the same type.
-- The statement {anchorTerm functionEqProp}`(fun (x : Nat) => 1 + x) = (Nat.succ ·)` is a perfectly reasonable statement.
-- From the perspective of mathematics, two functions are equal if they map equal inputs to equal outputs, so this statement is even true, though it requires a one-line proof to convince Lean of this fact.

命题等价性是一个数学陈述，而不是程序的调用。
因为命题就像描述某个陈述的证据的类型，所以命题等价性与像 {anchorName readFile}`String` 和 {anchorTerm moreOps}`Nat → List Int` 这样的类型比与布尔等价性有更多的共同点。
这意味着它不能自动检查。然而，只要两个表达式具有相同的类型，就可以在 Lean 中陈述它们的等价性。
陈述 {anchorTerm functionEqProp}`(fun (x : Nat) => 1 + x) = (Nat.succ ·)` 是一个完全合理的陈述。
从数学的角度来看，如果两个函数将等价的输入映射到等价的输出，那么它们就是等价的，所以这个陈述甚至是正确的，尽管它需要一行证明。

-- Generally speaking, when using Lean as a programming language, it's easiest to stick to Boolean functions rather than propositions.
-- However, as the names {moduleName}`true` and {moduleName}`false` for {moduleName}`Bool`'s constructors suggest, this difference is sometimes blurred.
-- Some propositions are _decidable_, which means that they can be checked just like a Boolean function.
-- The function that checks whether the proposition is true or false is called a _decision procedure_, and it returns _evidence_ of the truth or falsity of the proposition.
-- Some examples of decidable propositions include equality and inequality of natural numbers, equality of strings, and “ands” and “ors” of propositions that are themselves decidable.

一般来说，当使用 Lean 作为编程语言时，最好坚持使用布尔函数而不是命题。
然而，正如 {moduleName}`Bool` 的构造函数的名称 {moduleName}`true` 和 {moduleName}`false` 所暗示的那样，这种差异有时会变得模糊。
有些命题是*可判定的*，这意味着它们可以像布尔函数一样被检查。
检查命题是真还是假的函数称为*判定过程*，它返回命题真假的*证据*。
可判定命题的一些例子包括自然数的相等和不相等、字符串的相等，以及本身可判定的命题的“与”和“或”。

-- In Lean, {kw}`if` works with decidable propositions.
-- For example, {anchorTerm twoLessFour}`2 < 4` is a proposition:

在 Lean 中，{kw}`if` 与可判定命题一起工作。
例如，{anchorTerm twoLessFour}`2 < 4` 是一个命题：

```anchor twoLessFour
#check 2 < 4
```
```anchorInfo twoLessFour
2 < 4 : Prop
```

-- Nonetheless, it is perfectly acceptable to write it as the condition in an {kw}`if`.
-- For example, {anchorTerm ifProp}`if 2 < 4 then 1 else 2` has type {moduleName}`Nat` and evaluates to {anchorTerm ifProp}`1`.

尽管如此，将其写成 {kw}`if` 中的条件是完全可以接受的。
例如，{anchorTerm ifProp}`if 2 < 4 then 1 else 2` 的类型为 {moduleName}`Nat`，计算结果为 {anchorTerm ifProp}`1`。

-- Not all propositions are decidable.
-- If they were, then computers would be able to prove any true proposition just by running the decision procedure, and mathematicians would be out of a job.
-- More specifically, decidable propositions have an instance of the {anchorName DecLTLEPos}`Decidable` type class, which contains the decision procedure.
-- Trying to use a proposition that isn't decidable as if it were a {anchorName CoeBoolProp}`Bool` results in a failure to find the {anchorName DecLTLEPos}`Decidable` instance.
-- For example, {anchorTerm funEqDec}`if (fun (x : Nat) => 1 + x) = (Nat.succ ·) then "yes" else "no"` results in:

并非所有命题都是可判定的。如果它们是，那么计算机只需运行判定过程就可以证明任何真实的命题，数学家就会失业。
更具体地说，可判定命题具有 {anchorName DecLTLEPos}`Decidable` 类型类的实例，该实例包含判定过程。
试图将不可判定的命题当作 {anchorName CoeBoolProp}`Bool` 来使用会导致找不到 {anchorName DecLTLEPos}`Decidable` 实例。
例如，{anchorTerm funEqDec}`if (fun (x : Nat) => 1 + x) = (Nat.succ ·) then "yes" else "no"` 会导致：

```anchorError funEqDec
failed to synthesize
  Decidable ((fun x => 1 + x) = fun x => x.succ)

Hint: Additional diagnostic information may be available using the `set_option diagnostics true` command.
```

-- The following propositions, that are usually decidable, are overloaded with type classes:

以下通常是可判定的命题，使用类型类进行重载：

-- :::table +header
-- *
--  -  Expression
--  -  Desugaring
--  -  Class Name
-- *
--  -  {anchorTerm ltDesugar}`x < y`
--  -  {anchorTerm ltDesugar}`LT.lt x y`
--  -  {moduleName}`LT`
-- *
--  -  {anchorTerm leDesugar}`x ≤ y`
--  -  {anchorTerm leDesugar}`LE.le x y`
--  -  {moduleName}`LE`
-- *
--  -  {anchorTerm gtDesugar}`x > y`
--  -  {anchorTerm gtDesugar}`LT.lt y x`
--  -  {moduleName}`LT`
-- *
--  -  {anchorTerm geDesugar}`x ≥ y`
--  -  {anchorTerm geDesugar}`LE.le y x`
--  -  {moduleName}`LE`
-- :::

:::table +header
*
 -  表达式
 -  脱糖后
 -  类名
*
 -  {anchorTerm ltDesugar}`x < y`
 -  {anchorTerm ltDesugar}`LT.lt x y`
 -  {moduleName}`LT`
*
 -  {anchorTerm leDesugar}`x ≤ y`
 -  {anchorTerm leDesugar}`LE.le x y`
 -  {moduleName}`LE`
*
 -  {anchorTerm gtDesugar}`x > y`
 -  {anchorTerm gtDesugar}`LT.lt y x`
 -  {moduleName}`LT`
*
 -  {anchorTerm geDesugar}`x ≥ y`
 -  {anchorTerm geDesugar}`LE.le y x`
 -  {moduleName}`LE`

:::

-- Because defining new propositions hasn't yet been demonstrated, it may be difficult to define completely new instances of {moduleName}`LT` and {moduleName}`LE`.
-- However, they can be defined in terms of existing instances.
-- {moduleName}`LT` and {moduleName}`LE` instances for {anchorName LTPos}`Pos` can use the existing instances for {moduleName}`Nat`:

因为尚未演示如何定义新命题，所以可能很难定义 {moduleName}`LT` 和 {moduleName}`LE` 的全新实例。
但是，它们可以根据现有实例来定义。
{anchorName LTPos}`Pos` 的 {moduleName}`LT` 和 {moduleName}`LE` 实例可以使用 {moduleName}`Nat` 的现有实例：

```anchor LTPos
instance : LT Pos where
  lt x y := LT.lt x.toNat y.toNat
```

```anchor LEPos
instance : LE Pos where
  le x y := LE.le x.toNat y.toNat
```

-- These propositions are not decidable by default because Lean doesn't unfold the definitions of propositions while synthesizing an instance.
-- This can be bridged using the {anchorName DecLTLEPos}`inferInstanceAs` operator, which finds an instance for a given class if it exists:

这些命题默认情况下是不可判定的，因为 Lean 在合成实例时不会展开命题的定义。
这可以使用 {anchorName DecLTLEPos}`inferInstanceAs` 运算符来弥合，该运算符在存在时为给定类查找实例：

```anchor DecLTLEPos
instance {x : Pos} {y : Pos} : Decidable (x < y) :=
  inferInstanceAs (Decidable (x.toNat < y.toNat))

instance {x : Pos} {y : Pos} : Decidable (x ≤ y) :=
  inferInstanceAs (Decidable (x.toNat ≤ y.toNat))
```

-- The type checker confirms that the definitions of the propositions match.
-- Confusing them results in an error:

类型检查器确认命题的定义匹配。
混淆它们会导致错误：

```anchor LTLEMismatch
instance {x : Pos} {y : Pos} : Decidable (x ≤ y) :=
  inferInstanceAs (Decidable (x.toNat < y.toNat))
```
```anchorError LTLEMismatch
Type mismatch
  inferInstanceAs (Decidable (x.toNat < y.toNat))
has type
  Decidable (x.toNat < y.toNat)
but is expected to have type
  Decidable (x ≤ y)
```

-- Comparing values using {lit}`<`, {lit}`==`, and {lit}`>` can be inefficient.
-- Checking first whether one value is less than another, and then whether they are equal, can require two traversals over large data structures.
-- To solve this problem, Java and C# have standard {java}`compareTo` and {CSharp}`CompareTo` methods (respectively) that can be overridden by a class in order to implement all three operations at the same time.
-- These methods return a negative integer if the receiver is less than the argument, zero if they are equal, and a positive integer if the receiver is greater than the argument.
-- Rather than overloading the meaning of integers, Lean has a built-in inductive type that describes these three possibilities:

使用 {lit}`<`、{lit}`==` 和 {lit}`>` 比较值可能效率低下。
首先检查一个值是否小于另一个值，然后检查它们是否相等，可能需要对大型数据结构进行两次遍历。
为了解决这个问题，Java 和 C# 分别有标准的 {java}`compareTo` 和 {CSharp}`CompareTo` 方法，可以由类重写以同时实现所有三个操作。
如果接收者小于参数，这些方法返回一个负整数；如果它们相等，则返回零；如果接收者大于参数，则返回一个正整数。
Lean 没有重载整数的含义，而是有一个内置的归纳类型来描述这三种可能性：

```anchor Ordering
inductive Ordering where
  | lt
  | eq
  | gt
```

-- The {anchorName OrdPos}`Ord` type class can be overloaded to produce these comparisons.
-- For {anchorName OrdPos}`Pos`, an implementation can be:

{anchorName OrdPos}`Ord` 类型类可以被重载以产生这些比较。对于 {anchorName OrdPos}`Pos`，一个实现可以是：

```anchor OrdPos
def Pos.comp : Pos → Pos → Ordering
  | Pos.one, Pos.one => Ordering.eq
  | Pos.one, Pos.succ _ => Ordering.lt
  | Pos.succ _, Pos.one => Ordering.gt
  | Pos.succ n, Pos.succ k => comp n k

instance : Ord Pos where
  compare := Pos.comp
```
-- In situations where {java}`compareTo` would be the right approach in Java, use {moduleName}`Ord.compare` in Lean.

在 Java 中使用 {java}`compareTo` 的情形，在 Lean 中使用 {moduleName}`Ord.compare`  就对了。

-- # Hashing
# 哈希
%%%
tag := "hashing"
%%%

-- Java and C# have {java}`hashCode` and {CSharp}`GetHashCode` methods, respectively, that compute a hash of a value for use in data structures such as hash tables.
-- The Lean equivalent is a type class called {anchorName Hashable}`Hashable`:

Java 和 C# 分别有 {java}`hashCode` 和 {CSharp}`GetHashCode` 方法，用于计算值的哈希值，以便在哈希表等数据结构中使用。
Lean 的等价物是一个名为 {anchorName Hashable}`Hashable` 的类型类：

```anchor Hashable
class Hashable (α : Type) where
  hash : α → UInt64
```

-- If two values are considered equal according to a {moduleName}`BEq` instance for their type, then they should have the same hashes.
-- In other words, if {anchorTerm HashableSpec}`x == y` then {anchorTerm HashableSpec}`hash x == hash y`.
-- If {anchorTerm HashableSpec}`x ≠ y`, then {anchorTerm HashableSpec}`hash x` won't necessarily differ from {anchorTerm HashableSpec}`hash y` (after all, there are infinitely more {moduleName}`Nat` values than there are {moduleName}`UInt64` values), but data structures built on hashing will have better performance if unequal values are likely to have unequal hashes.
-- This is the same expectation as in Java and C#.

如果根据其类型的 {moduleName}`BEq` 实例认为两个值相等，那么它们应该具有相同的哈希值。
换句话说，如果 {anchorTerm HashableSpec}`x == y`，那么 {anchorTerm HashableSpec}`hash x == hash y`。
如果 {anchorTerm HashableSpec}`x ≠ y`，那么 {anchorTerm HashableSpec}`hash x` 不一定与 {anchorTerm HashableSpec}`hash y` 不同（毕竟，{moduleName}`Nat` 值的数量比 {moduleName}`UInt64` 但是如果不一样的值有不一样的哈希值的话，那么建立在其上的数据结构会有更好的表现。这与 Java 和 C# 中对哈希的要求是一致的。

-- The standard library contains a function {anchorTerm mixHash}`mixHash` with type {anchorTerm mixHash}`UInt64 → UInt64 → UInt64` that can be used to combine hashes for different fields for a constructor.
-- A reasonable hash function for an inductive datatype can be written by assigning a unique number to each constructor, and then mixing that number with the hashes of each field.
-- For example, a {anchorName HashablePos}`Hashable` instance for {anchorName HashablePos}`Pos` can be written:

标准库包含一个类型为 {anchorTerm mixHash}`UInt64 → UInt64 → UInt64` 的函数 {anchorTerm mixHash}`mixHash`，可用于组合构造函数不同字段的哈希值。
可以通过为每个构造函数分配一个唯一的数字，然后将该数字与每个字段的哈希值混合来为归纳数据类型编写一个合理的哈希函数。
例如，可以为 {anchorName HashablePos}`Pos` 编写一个 {anchorName HashablePos}`Hashable` 实例：

```anchor HashablePos
def hashPos : Pos → UInt64
  | Pos.one => 0
  | Pos.succ n => mixHash 1 (hashPos n)

instance : Hashable Pos where
  hash := hashPos
```

-- {anchorTerm HashableNonEmptyList}`Hashable` instances for polymorphic types can use recursive instance search.
-- Hashing a {anchorTerm HashableNonEmptyList}`NonEmptyList α` is only possible when {anchorName HashableNonEmptyList}`α` can be hashed:

多态类型的 {anchorTerm HashableNonEmptyList}`Hashable` 实例可以使用递归实例搜索。

只有当 {anchorName HashableNonEmptyList}`α` 可以被哈希时，才能对 {anchorTerm HashableNonEmptyList}`NonEmptyList α` 进行哈希：

```anchor HashableNonEmptyList
instance [Hashable α] : Hashable (NonEmptyList α) where
  hash xs := mixHash (hash xs.head) (hash xs.tail)
```

-- Binary trees use both recursion and recursive instance search in the implementations of {anchorName TreeHash}`BEq` and {anchorName TreeHash}`Hashable`:

二叉树在 {anchorName TreeHash}`BEq` 和 {anchorName TreeHash}`Hashable` 的实现中都使用了递归和递归实例搜索：


```anchor TreeHash
inductive BinTree (α : Type) where
  | leaf : BinTree α
  | branch : BinTree α → α → BinTree α → BinTree α

def eqBinTree [BEq α] : BinTree α → BinTree α → Bool
  | BinTree.leaf, BinTree.leaf =>
    true
  | BinTree.branch l x r, BinTree.branch l2 x2 r2 =>
    x == x2 && eqBinTree l l2 && eqBinTree r r2
  | _, _ =>
    false

instance [BEq α] : BEq (BinTree α) where
  beq := eqBinTree

def hashBinTree [Hashable α] : BinTree α → UInt64
  | BinTree.leaf =>
    0
  | BinTree.branch left x right =>
    mixHash 1
      (mixHash (hashBinTree left)
        (mixHash (hash x)
          (hashBinTree right)))

instance [Hashable α] : Hashable (BinTree α) where
  hash := hashBinTree
```

-- # Deriving Standard Classes
# 派生标准类
%%%
tag := "deriving-standard-classes"
%%%

-- Instance of classes like {moduleName}`BEq` and {moduleName}`Hashable` are often quite tedious to implement by hand.
-- Lean includes a feature called _instance deriving_ that allows the compiler to automatically construct well-behaved instances of many type classes.
-- In fact, the {anchorTerm Firewood (module := Examples.Intro)}`deriving Repr` phrase in the definition of {anchorName Firewood (module:=Examples.Intro)}`Firewood` in the {ref "polymorphism"}[first section on polymorphism] is an example of instance deriving.

像 {moduleName}`BEq` 和 {moduleName}`Hashable` 这样的类的实例通常很难手动实现。
Lean 包含一个称为*实例派生*的功能，它允许编译器自动构造许多类型类的行为良好的实例。
实际上，在 {ref "polymorphism"}[多态性的第一部分] 中 {anchorName Firewood (module:=Examples.Intro)}`Firewood` 的定义中的 {anchorTerm Firewood (module := Examples.Intro)}`deriving Repr` 短语就是实例派生的一个例子。

-- Instances can be derived in two ways.
-- The first can be used when defining a structure or inductive type.
-- In this case, add {kw}`deriving` to the end of the type declaration followed by the names of the classes for which instances should be derived.
-- For a type that is already defined, a standalone {kw}`deriving` command can be used.
-- Write {kw}`deriving instance`{lit}` C1, C2, ... `{kw}`for`{lit}` T` to derive instances of {lit}`C1, C2, ...` for the type {lit}`T` after the fact.

派生实例的方法有两种。第一种在定义一个结构体或归纳类型时使用。
在这种情况下，在类型声明的末尾添加 {kw}`deriving`，后跟应为其派生实例的类的名称。
对于已经定义的类型，可以使用独立的 {kw}`deriving` 命令。
事后为类型 {lit}`T` 派生 {lit}`C1, C2, ...` 的实例，请编写 {kw}`deriving instance`{lit}` C1, C2, ... `{kw}`for`{lit}` T`。

-- {moduleName}`BEq` and {moduleName}`Hashable` instances can be derived for {anchorName BEqHashableDerive}`Pos` and {anchorName BEqHashableDerive}`NonEmptyList` using a very small amount of code:

可以使用非常少的代码为 {anchorName BEqHashableDerive}`Pos` 和 {anchorName BEqHashableDerive}`NonEmptyList` 派生 {moduleName}`BEq` 和 {moduleName}`Hashable` 实例：

```anchor BEqHashableDerive
deriving instance BEq, Hashable for Pos
deriving instance BEq, Hashable for NonEmptyList
```

-- Instances can be derived for at least the following classes:

至少可以为以下类派生实例：

--  * {moduleName}`Inhabited`
--  * {moduleName}`BEq`
--  * {moduleName}`Repr`
--  * {moduleName}`Hashable`
--  * {moduleName}`Ord`

 * {moduleName}`Inhabited`
 * {moduleName}`BEq`
 * {moduleName}`Repr`
 * {moduleName}`Hashable`
 * {moduleName}`Ord`

-- In some cases, however, the derived {moduleName}`Ord` instance may not produce precisely the ordering desired in an application.
-- When this is the case, it's fine to write an {moduleName}`Ord` instance by hand.
-- The collection of classes for which instances can be derived can be extended by advanced users of Lean.

然而，在某些情况下，派生的 {moduleName}`Ord` 实例可能无法精确地产生应用程序中所需的排序。
在这种情况下，可以手动编写 {moduleName}`Ord` 实例。你如果对自己的 Lean 水平足够有自信的话，你也可以自己添加可以派生实例的类型类。

-- Aside from the clear advantages in programmer productivity and code readability, deriving instances also makes code easier to maintain, because the instances are updated as the definitions of types evolve.
-- When reviewing changes to code, modifications that involve updates to datatypes are much easier to read without line after line of formulaic modifications to equality tests and hash computation.

实例派生除了在开发效率和代码可读性上有很大的优势外，它也使得代码更易于维护，因为实例会随着类型定义的变化而更新。
对数据类型的一系列更新更易于阅读，因为不需要一行又一行地对相等性测试和哈希计算进行公式化的修改。

-- # Appending
# Appending
%%%
tag := "append-class"
%%%
-- Many datatypes have some sort of append operator.
-- In Lean, appending two values is overloaded with the type class {anchorName HAppend}`HAppend`, which is a heterogeneous operation like that used for arithmetic operations:

许多数据类型都有某种连接运算符。
在 Lean 中，连接两个值是使用类型类 {anchorName HAppend}`HAppend` 重载的，它是一种类似于用于算术运算的异质操作：

```anchor HAppend
class HAppend (α : Type) (β : Type) (γ : outParam Type) where
  hAppend : α → β → γ
```

-- The syntax {anchorTerm desugarHAppend}`xs ++ ys` desugars to {anchorTerm desugarHAppend}`HAppend.hAppend xs ys`.
-- For homogeneous cases, it's enough to implement an instance of {moduleName}`Append`, which follows the usual pattern:

语法 {anchorTerm desugarHAppend}`xs ++ ys` 脱糖为 {anchorTerm desugarHAppend}`HAppend.hAppend xs ys`。
对于同质情况，实现 {moduleName}`Append` 的实例就足够了，它遵循通常的模式：

```anchor AppendNEList
instance : Append (NonEmptyList α) where
  append xs ys :=
    { head := xs.head, tail := xs.tail ++ ys.head :: ys.tail }
```

-- After defining the above instance,

定义上述实例后，

```anchor appendSpiders
#eval idahoSpiders ++ idahoSpiders
```

-- has the following output:
具有以下输出：

```anchorInfo appendSpiders
{ head := "Banded Garden Spider",
  tail := ["Long-legged Sac Spider",
           "Wolf Spider",
           "Hobo Spider",
           "Cat-faced Spider",
           "Banded Garden Spider",
           "Long-legged Sac Spider",
           "Wolf Spider",
           "Hobo Spider",
           "Cat-faced Spider"] }
```

-- Similarly, a definition of {moduleName}`HAppend` allows non-empty lists to be appended to ordinary lists:

同样，{moduleName}`HAppend` 的定义允许将非空列表连接到普通列表：

```anchor AppendNEListList
instance : HAppend (NonEmptyList α) (List α) (NonEmptyList α) where
  hAppend xs ys :=
    { head := xs.head, tail := xs.tail ++ ys }
```

-- With this instance available,

有了这个实例，

```anchor appendSpidersList
#eval idahoSpiders ++ ["Trapdoor Spider"]
```

-- results in
结果为

```anchorInfo appendSpidersList
{ head := "Banded Garden Spider",
  tail := ["Long-legged Sac Spider", "Wolf Spider", "Hobo Spider", "Cat-faced Spider", "Trapdoor Spider"] }
```

-- # Functors
# 函子
%%%
tag := "Functor"
%%%

-- A polymorphic type is a {deftech}_functor_ if it has an overload for a function named {anchorName FunctorDef}`map` that transforms every element contained in it by a function.
-- While most languages use this terminology, C#'s equivalent of {anchorName FunctorDef}`map` is called {CSharp}`System.Linq.Enumerable.Select`.
-- For example, mapping a function over a list constructs a new list in which each entry from the starting list has been replaced by the result of the function on that entry.
-- Mapping a function {anchorName optionFMeta}`f` over an {anchorName optionFMeta}`Option` leaves {anchorName optionFMeta}`none` untouched, and replaces {anchorTerm optionFMeta}`some x` with {anchorTerm optionFMeta}`some (f x)`.

如果一个多态类型重载了一个名为 {anchorName FunctorDef}`map` 的函数，该函数通过一个函数映射其中包含的每个元素，那么它就是一个 {deftech}*函子*。
虽然大多数语言都使用这个术语，但 C# 中与 {anchorName FunctorDef}`map` 等效的函数称为 {CSharp}`System.Linq.Enumerable.Select`。
例如，用一个函数对一个列表进行映射会产生一个新的列表，列表中的每个元素都是函数应用在原列表中元素的结果。
用函数 {anchorName optionFMeta}`f` 映射 {anchorName optionFMeta}`Option` 会使 {anchorName optionFMeta}`none` 保持不变，并将 {anchorTerm optionFMeta}`some x` 替换为 {anchorTerm optionFMeta}`some (f x)`。

-- Here are some examples of functors and how their {anchorName FunctorDef}`Functor` instances overload {anchorName FunctorDef}`map`:
--  * {anchorTerm mapList}`Functor.map (· + 5) [1, 2, 3]` evaluates to {anchorTerm mapList}`[6, 7, 8]`
--  * {anchorTerm mapOption}`Functor.map toString (some (List.cons 5 List.nil))` evaluates to {anchorTerm mapOption}`some "[5]"`
--  * {anchorTerm mapListList}`Functor.map List.reverse [[1, 2, 3], [4, 5, 6]]` evaluates to {anchorTerm mapListList}`[[3, 2, 1], [6, 5, 4]]`

以下是一些函子以及它们的 {anchorName FunctorDef}`Functor` 实例如何重载 {anchorName FunctorDef}`map` 的示例：
 * {anchorTerm mapList}`Functor.map (· + 5) [1, 2, 3]` 结果为 {anchorTerm mapList}`[6, 7, 8]`
 * {anchorTerm mapOption}`Functor.map toString (some (List.cons 5 List.nil))` 结果为 {anchorTerm mapOption}`some "[5]"`
 * {anchorTerm mapListList}`Functor.map List.reverse [[1, 2, 3], [4, 5, 6]]` 结果为 {anchorTerm mapListList}`[[3, 2, 1], [6, 5, 4]]`。

-- Because {anchorName mapList}`Functor.map` is a bit of a long name for this common operation, Lean also provides an infix operator for mapping a function, namely {lit}`<$>`.
-- The prior examples can be rewritten as follows:
--  * {anchorTerm mapInfixList}`(· + 5) <$> [1, 2, 3]` evaluates to {anchorTerm mapInfixList}`[6, 7, 8]`
--  * {anchorTerm mapInfixOption}`toString <$> (some (List.cons 5 List.nil))` evaluates to {anchorTerm mapInfixOption}`some "[5]"`
--  * {anchorTerm mapInfixListList}`List.reverse <$> [[1, 2, 3], [4, 5, 6]]` evaluates to {anchorTerm mapInfixListList}`[[3, 2, 1], [6, 5, 4]]`

{anchorName mapList}`Functor.map` 很常用，但名字有点长，所以 Lean 还提供了一个用于映射函数的中缀运算符，即 {lit}`<$>`。
前面的示例可以重写如下：
 * {anchorTerm mapInfixList}`(· + 5) <$> [1, 2, 3]` 结果为 {anchorTerm mapInfixList}`[6, 7, 8]`
 * {anchorTerm mapInfixOption}`toString <$> (some (List.cons 5 List.nil))` 结果为 {anchorTerm mapInfixOption}`some "[5]"`
 * {anchorTerm mapInfixListList}`List.reverse <$> [[1, 2, 3], [4, 5, 6]]` 结果为 {anchorTerm mapInfixListList}`[[3, 2, 1], [6, 5, 4]]`。

-- An instance of {anchorTerm FunctorNonEmptyList}`Functor` for {anchorTerm FunctorNonEmptyList}`NonEmptyList` requires specifying the {anchorName FunctorNonEmptyList}`map` function.

{anchorTerm FunctorNonEmptyList}`NonEmptyList` 的 {anchorTerm FunctorNonEmptyList}`Functor` 实例需要指定 {anchorName FunctorNonEmptyList}`map` 函数。

```anchor FunctorNonEmptyList
instance : Functor NonEmptyList where
  map f xs := { head := f xs.head, tail := f <$> xs.tail }
```

-- Here, {anchorTerm FunctorNonEmptyList}`map` uses the {anchorTerm FunctorNonEmptyList}`Functor` instance for {moduleName}`List` to map the function over the tail.
-- This instance is defined for {anchorTerm FunctorNonEmptyList}`NonEmptyList` rather than for {anchorTerm FunctorNonEmptyListA}`NonEmptyList α` because the argument type {anchorTerm FunctorNonEmptyListA}`α` plays no role in resolving the type class.
-- A {anchorTerm FunctorNonEmptyList}`NonEmptyList` can have a function mapped over it _no matter what the type of entries is_.
-- If {anchorTerm FunctorNonEmptyListA}`α` were a parameter to the class, then it would be possible to make versions of {anchorTerm FunctorNonEmptyList}`Functor` that only worked for {anchorTerm FunctorNonEmptyListA}`NonEmptyList Nat`, but part of being a functor is that {anchorName FunctorNonEmptyList}`map` works for any entry type.

在这里，{anchorTerm FunctorNonEmptyList}`map` 使用 {moduleName}`List` 的 {anchorTerm FunctorNonEmptyList}`Functor` 实例将函数映射到尾部。
此实例是为 {anchorTerm FunctorNonEmptyList}`NonEmptyList` 定义的，而不是为 {anchorTerm FunctorNonEmptyListA}`NonEmptyList α` 定义的，因为参数类型 {anchorTerm FunctorNonEmptyListA}`α` 在解析类型类中不起作用。
无论条目的类型是什么，都可以用函数来映射 {anchorTerm FunctorNonEmptyList}`NonEmptyList` 。
如果 {anchorTerm FunctorNonEmptyListA}`α` 是该类的参数，那么就可以创建仅适用于 {anchorTerm FunctorNonEmptyListA}`NonEmptyList Nat` 的 {anchorTerm FunctorNonEmptyList}`Functor` 版本，但作为函子的一部分是 {anchorName FunctorNonEmptyList}`map` 适用于任何条目类型。

-- Here is an instance of {anchorTerm FunctorPPoint}`Functor` for {anchorTerm FunctorPPoint}`PPoint`:
以下是 {anchorTerm FunctorPPoint}`PPoint` 的 {anchorTerm FunctorPPoint}`Functor` 实例：

-- In this case, {anchorName FunctorPPoint}`f` has been applied to both {anchorName FunctorPPoint}`x` and {anchorName FunctorPPoint}`y`.

```anchor FunctorPPoint
instance : Functor PPoint where
  map f p := { x := f p.x, y := f p.y }
```
在这种情况下，{anchorName FunctorPPoint}`f` 已应用于 {anchorName FunctorPPoint}`x` 和 {anchorName FunctorPPoint}`y`。

-- Even when the type contained in a functor is itself a functor, mapping a function only goes down one layer.
-- That is, when using  {anchorName FunctorPPoint}`map` on a {anchorTerm NEPP}`NonEmptyList (PPoint Nat)`, the function being mapped should take {anchorTerm NEPP}`PPoint Nat` as its argument rather than {moduleName}`Nat`.

即使函子中包含的类型本身也是一个函子，映射一个函数也只下降一层。
也就是说，当在 {anchorTerm NEPP}`NonEmptyList (PPoint Nat)` 上使用 {anchorName FunctorPPoint}`map` 时，被映射的函数应将 {anchorTerm NEPP}`PPoint Nat` 作为其参数，而不是 {moduleName}`Nat`。

-- The definition of the {anchorName FunctorLaws}`Functor` class uses one more language feature that has not yet been discussed: default method definitions.
-- Normally, a class will specify some minimal set of overloadable operations that make sense together, and then use polymorphic functions with instance implicit arguments that build on the overloaded operations to provide a larger library of features.
-- For example, the function {anchorName concat}`concat` can concatenate any non-empty list whose entries are appendable:

{anchorName FunctorDef}`Functor` 类的定义使用了另一个尚未讨论的语言特性：默认方法定义。
通常，一个类会指定一些有意义的可重载操作的最小集合，然后使用带有实例隐式参数的多态函数，这些函数建立在重载操作之上，以提供更大的功能库。
例如，函数 {anchorName concat}`concat` 可以连接任何其条目可连接的非空列表：

```anchor concat
def concat [Append α] (xs : NonEmptyList α) : α :=
  let rec catList (start : α) : List α → α
    | [] => start
    | (z :: zs) => catList (start ++ z) zs
  catList xs.head xs.tail
```

-- However, for some classes, there are operations that can be more efficiently implemented with knowledge of the internals of a datatype.

然而，对于某些类，有些操作可以通过了解数据类型的内部结构来更有效地实现。

-- In these cases, a default method definition can be provided.
-- A default method definition provides a default implementation of a method in terms of the other methods.
-- However, instance implementors may choose to override this default with something more efficient.
-- Default method definitions contain {lit}`:=` in a {kw}`class` definition.

在这些情况下，可以提供默认方法定义。
默认方法定义根据其他方法提供方法的默认实现。
然而，实例实现者可以选择用更有效的方法覆盖此默认值。
默认方法定义在 {kw}`class` 定义中包含 {lit}`:=`。

-- In the case of {anchorName FunctorDef}`Functor`, some types have a more efficient way of implementing {anchorName FunctorDef}`map` when the function being mapped ignores its argument.
-- Functions that ignore their arguments are called _constant functions_ because they always return the same value.
-- Here is the definition of {anchorName FunctorDef}`Functor`, in which {anchorName FunctorDef}`mapConst` has a default implementation:

在 {anchorName FunctorDef}`Functor` 的情况下，当被映射的函数忽略其参数时，某些类型具有更有效的方法来实现 {anchorName FunctorDef}`map`。
忽略其参数的函数称为*常量函数*，因为它们总是返回相同的值。
以下是 {anchorName FunctorDef}`Functor` 的定义，其中 {anchorName FunctorDef}`mapConst` 具有默认实现：

```anchor FunctorDef
class Functor (f : Type → Type) where
  map : {α β : Type} → (α → β) → f α → f β

  mapConst {α β : Type} (x : α) (coll : f β) : f α :=
    map (fun _ => x) coll
```

-- Just as a {anchorName HashableSpec}`Hashable` instance that doesn't respect {moduleName}`BEq` is buggy, a {moduleName}`Functor` instance that moves around the data as it maps the function is also buggy.
-- For example, a buggy {moduleName}`Functor` instance for {moduleName}`List` might throw away its argument and always return the empty list, or it might reverse the list.
-- A bad {moduleName}`Functor` instance for {moduleName}`PPoint` might place {anchorTerm FunctorPPointBad}`f x` in both the {anchorName FunctorPPointBad}`x` and the {anchorName FunctorPPointBad}`y` fields, or swap them.
-- Specifically, {anchorName FunctorDef}`Functor` instances should follow two rules:
--  1. Mapping the identity function should result in the original argument.
--  2. Mapping two composed functions should have the same effect as composing their mapping.

就像不遵守 {moduleName}`BEq` 的 {anchorName HashableSpec}`Hashable` 实例是有问题的一样，在映射函数时移动数据的 {anchorName FunctorDef}`Functor` 实例也是有问题的。
例如，{moduleName}`List` 的一个有问题的 {moduleName}`Functor` 实例可能会丢弃其参数并始终返回空列表，或者它可能会反转列表。
{moduleName}`PPoint` 的一个糟糕的 {moduleName}`Functor` 实例可能会将 {anchorTerm FunctorPPointBad}`f x` 放在 {anchorName FunctorPPointBad}`x` 和 {anchorName FunctorPPointBad}`y` 字段中，或者交换它们。
具体来说，{anchorName FunctorDef}`Functor` 实例应遵循两条规则：
 1. 映射恒等函数应产生原始参数。
 2. 映射两个组合函数应与组合它们的映射具有相同的效果。

-- More formally, the first rule says that {anchorTerm FunctorLaws}`id <$> x` equals {anchorTerm FunctorLaws}`x`.
-- The second rule says that {anchorTerm FunctorLaws}`map (fun y => f (g y)) x` equals {anchorTerm FunctorLaws}`map f (map g x)`.
-- The composition {anchorTerm compDef}`f ∘ g` can also be written {anchorTerm compDef}`fun y => f (g y)`.
-- These rules prevent implementations of {anchorName FunctorDef}`map` that move the data around or delete some of it.

更正式地说，第一条规则说 {anchorTerm FunctorLaws}`id <$> x` 等于 {anchorTerm FunctorLaws}`x`。
第二条规则说 {anchorTerm FunctorLaws}`map (fun y => f (g y)) x` 等于 {anchorTerm FunctorLaws}`map f (map g x)`。
组合 {anchorTerm compDef}`f ∘ g` 也可以写成 {anchorTerm compDef}`fun y => f (g y)`。
这些规则阻止了移动数据或删除部分数据的 {anchorName FunctorDef}`map` 的实现。

-- # Messages You May Meet
# 您可能会遇到的消息
%%%
tag := "standard-classes-messages"
%%%

-- Lean is not able to derive instances for all classes.
-- For example, the code

Lean 无法为所有类派生实例。
例如，代码

```anchor derivingNotFound
deriving instance ToString for NonEmptyList
```

-- results in the following error:
导致以下错误：

```anchorError derivingNotFound
No deriving handlers have been implemented for class `ToString`
```

-- Invoking {anchorTerm derivingNotFound}`deriving instance` causes Lean to consult an internal table of code generators for type class instances.
-- If the code generator is found, then it is invoked on the provided type to create the instance.
-- This message, however, means that no code generator was found for {anchorName derivingNotFound}`ToString`.

调用 {anchorTerm derivingNotFound}`deriving instance` 会使 Lean 查阅类型类实例的代码生成器的内部表。
如果找到代码生成器，则会在提供的类型上调用它以创建实例。
然而，此消息意味着没有为 {anchorName derivingNotFound}`ToString` 找到代码生成器。

-- # Exercises
# 练习
%%%
tag := "standard-classes-exercises"
%%%
--  * Write an instance of {anchorTerm moreOps}`HAppend (List α) (NonEmptyList α) (NonEmptyList α)` and test it.
--  * Implement a {anchorTerm FunctorLaws}`Functor` instance for the binary tree datatype.

 * 编写一个 {anchorTerm moreOps}`HAppend (List α) (NonEmptyList α) (NonEmptyList α)` 的实例并进行测试。
 * 为二叉树数据类型实现一个 {anchorTerm FunctorLaws}`Functor` 实例。
