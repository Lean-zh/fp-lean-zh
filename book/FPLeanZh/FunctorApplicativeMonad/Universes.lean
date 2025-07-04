import VersoManual
import FPLeanZh.Examples

open Verso.Genre Manual
open Verso Code External

open FPLeanZh

set_option verso.exampleProject "../examples"
set_option verso.exampleModule "Examples.Universes"

#doc (Manual) "宇宙" =>

-- In the interests of simplicity, this book has thus far papered over an important feature of Lean: _universes_.
-- A universe is a type that classifies other types.
-- Two of them are familiar: {anchorTerm TypeType}`Type` and {anchorTerm PropType}`Prop`.
-- {anchorTerm SomeTypes}`Type` classifies ordinary types, such as {anchorName SomeTypes}`Nat`, {anchorTerm SomeTypes}`String`, {anchorTerm SomeTypes}`Int → String × Char`, and {anchorTerm SomeTypes}`IO Unit`.
-- {anchorTerm PropType}`Prop` classifies propositions that may be true or false, such as {anchorTerm SomeTypes}`"nisse" = "elf"` or {anchorTerm SomeTypes}`3 > 2`.
-- The type of {anchorTerm PropType}`Prop` is {anchorTerm SomeTypes}`Type`:

为了简化起见，本书到目前为止一直回避了 Lean 的一个重要特性：__宇宙__。
宇宙是分类其他类型的类型。
其中两个很熟悉：{anchorTerm TypeType}`Type` 和 {anchorTerm PropType}`Prop`。
{anchorTerm SomeTypes}`Type` 分类普通类型，例如 {anchorName SomeTypes}`Nat`、{anchorTerm SomeTypes}`String`、{anchorTerm SomeTypes}`Int → String × Char` 和 {anchorTerm SomeTypes}`IO Unit`。
{anchorTerm PropType}`Prop` 分类可能为真或为假的命题，例如 {anchorTerm SomeTypes}`"nisse" = "elf"` 或 {anchorTerm SomeTypes}`3 > 2`。
{anchorTerm PropType}`Prop` 的类型是 {anchorTerm SomeTypes}`Type`：

```anchor PropType
#check Prop
```
```anchorInfo PropType
Prop : Type
```

-- For technical reasons, more universes than these two are needed.
-- In particular, {anchorTerm SomeTypes}`Type` cannot itself be a {anchorTerm SomeTypes}`Type`.
-- This would allow a logical paradox to be constructed and undermine Lean's usefulness as a theorem prover.

出于技术原因，需要比这两个更多的宇宙。
特别是，{anchorTerm SomeTypes}`Type` 本身不能是 {anchorTerm SomeTypes}`Type`。
这将允许构建逻辑悖论并破坏 Lean 作为定理证明器的有用性。

-- The formal argument for this is known as _Girard's Paradox_.
-- It is related to a better-known paradox known as _Russell's Paradox_, which was used to show that early versions of set theory were inconsistent.
-- In these set theories, a set can be defined by a property.
-- For example, one might have the set of all red things, the set of all fruit, the set of all natural numbers, or even the set of all sets.
-- Given a set, one can ask whether a given element is contained in it.
-- For instance, a bluebird is not contained in the set of all red things, but the set of all red things is contained in the set of all sets.
-- Indeed, the set of all sets even contains itself.

对此的正式论证被称为__吉拉德悖论__。
它与一个更广为人知的悖论__罗素悖论__有关，罗素悖论曾被用来证明早期版本的集合论是不一致的。
在这些集合论中，集合可以通过属性来定义。
例如，可以有所有红色事物的集合、所有水果的集合、所有自然数的集合，甚至所有集合的集合。
给定一个集合，可以询问给定元素是否包含在其中。
例如，蓝鸟不包含在所有红色事物的集合中，但所有红色事物的集合包含在所有集合的集合中。
实际上，所有集合的集合甚至包含它自己。

-- What about the set of all sets that do not contain themselves?
-- It contains the set of all red things, as the set of all red things is not itself red.
-- It does not contain the set of all sets, because the set of all sets contains itself.
-- But does it contain itself?
-- If it does contain itself, then it cannot contain itself.
-- But if it does not, then it must.

那么不包含自身的集合的集合呢？
它包含所有红色事物的集合，因为所有红色事物的集合本身不是红色的。
它不包含所有集合的集合，因为所有集合的集合包含它自己。
但它包含它自己吗？
如果它包含它自己，那么它就不能包含它自己。
但如果它不包含，那么它就必须包含。

-- This is a contradiction, which demonstrates that something was wrong with the initial assumptions.
-- In particular, allowing sets to be constructed by providing an arbitrary property is too powerful.
-- Later versions of set theory restrict the formation of sets to remove the paradox.

这是一个矛盾，表明最初的假设存在问题。
特别是，允许通过提供任意属性来构造集合过于强大。
集合论的后续版本限制了集合的形成以消除悖论。

-- A related paradox can be constructed in versions of dependent type theory that assign the type {anchorTerm SomeTypes}`Type` to {anchorTerm SomeTypes}`Type`.
-- To ensure that Lean has consistent logical foundations and can be used as a tool for mathematics, {anchorTerm SomeTypes}`Type` needs to have some other type.
-- This type is called {anchorTerm SomeTypes}`Type 1`:

在将类型 {anchorTerm SomeTypes}`Type` 赋值给 {anchorTerm SomeTypes}`Type` 的依赖类型理论版本中，可以构造一个相关的悖论。
为了确保 Lean 具有一致的逻辑基础并可以用作数学工具，{anchorTerm SomeTypes}`Type` 需要具有其他类型。
这种类型称为 {anchorTerm SomeTypes}`Type 1`：

```anchor TypeType
#check Type
```
```anchorInfo TypeType
Type : Type 1
```

-- Similarly, {anchorTerm Type1Type}`Type 1` is a {anchorTerm Type1Type}`Type 2`,
-- {anchorTerm Type2Type}`Type 2` is a {anchorTerm Type2Type}`Type 3`,
-- {anchorTerm Type3Type}`Type 3` is a {anchorTerm Type3Type}`Type 4`, and so forth.

同样，{anchorTerm Type1Type}`Type 1` 是 {anchorTerm Type1Type}`Type 2`，
{anchorTerm Type2Type}`Type 2` 是 {anchorTerm Type2Type}`Type 3`，
{anchorTerm Type3Type}`Type 3` 是 {anchorTerm Type3Type}`Type 4`，依此类推。

-- Function types occupy the smallest universe that can contain both the argument type and the return type.
-- This means that {anchorTerm NatNatType}`Nat → Nat` is a {anchorTerm NatNatType}`Type`, {anchorTerm Fun00Type}`Type → Type` is a {anchorTerm Fun00Type}`Type 1`, and {anchorTerm Fun12Type}`Type 3` is a {anchorTerm Fun12Type}`Type 1 → Type 2`.

函数类型占据可以包含参数类型和返回类型的最小宇宙。
这意味着 {anchorTerm NatNatType}`Nat → Nat` 是一个 {anchorTerm NatNatType}`Type`，{anchorTerm Fun00Type}`Type → Type` 是一个 {anchorTerm Fun00Type}`Type 1`，而 {anchorTerm Fun12Type}`Type 3` 是一个 {anchorTerm Fun12Type}`Type 1 → Type 2`。

-- There is one exception to this rule.
-- If the return type of a function is a {anchorTerm PropType}`Prop`, then the whole function type is in {anchorTerm PropType}`Prop`, even if the argument is in a larger universe such as {anchorTerm SomeTypes}`Type` or even {anchorTerm SomeTypes}`Type 1`.
-- In particular, this means that predicates over values that have ordinary types are in {anchorTerm PropType}`Prop`.
-- For example, the type {anchorTerm FunPropType}`(n : Nat) → n = n + 0` represents a function from a {anchorTerm SomeTypes}`Nat` to evidence that it is equal to itself plus zero.
-- Even though {anchorTerm SomeTypes}`Nat` is in {anchorTerm SomeTypes}`Type`, this function type is in {anchorTerm FunPropType}`Prop` due to this rule.
-- Similarly, even though {anchorTerm SomeTypes}`Type` is in {anchorTerm SomeTypes}`Type 1`, the function type {anchorTerm FunTypePropType}`Type → 2 + 2 = 4` is still in {anchorTerm FunTypePropType}`Prop`.

这条规则有一个例外。
如果函数的返回类型是 {anchorTerm PropType}`Prop`，那么整个函数类型都在 {anchorTerm PropType}`Prop` 中，即使参数在更大的宇宙中，例如 {anchorTerm SomeTypes}`Type` 甚至 {anchorTerm SomeTypes}`Type 1`。
特别是，这意味着对具有普通类型的值的谓词在 {anchorTerm PropType}`Prop` 中。
例如，类型 {anchorTerm FunPropType}`(n : Nat) → n = n + 0` 表示一个从 {anchorTerm SomeTypes}`Nat` 到它本身加零相等的证据的函数。
尽管 {anchorTerm SomeTypes}`Nat` 在 {anchorTerm SomeTypes}`Type` 中，但由于此规则，此函数类型在 {anchorTerm FunPropType}`Prop` 中。
同样，尽管 {anchorTerm SomeTypes}`Type` 在 {anchorTerm SomeTypes}`Type 1` 中，但函数类型 {anchorTerm FunTypePropType}`Type → 2 + 2 = 4` 仍然在 {anchorTerm FunTypePropType}`Prop` 中。

-- # User Defined Types

# 用户定义类型

-- Structures and inductive datatypes can be declared to inhabit particular universes.
-- Lean then checks whether each datatype avoids paradoxes by being in a universe that's large enough to prevent it from containing its own type.
-- For instance, in the following declaration, {anchorName MyList1}`MyList` is declared to reside in {anchorTerm SomeTypes}`Type`, and so is its type argument {anchorName MyList1}`α`:

结构和归纳数据类型可以声明为存在于特定宇宙中。
Lean 然后检查每个数据类型是否通过位于足够大的宇宙中来避免悖论，以防止它包含自己的类型。
例如，在以下声明中，{anchorName MyList1}`MyList` 被声明为位于 {anchorTerm SomeTypes}`Type` 中，其类型参数 {anchorName MyList1}`α` 也是如此：

```anchor MyList1
inductive MyList (α : Type) : Type where
  | nil : MyList α
  | cons : α → MyList α → MyList α
```

-- {anchorTerm MyList1Type}`MyList` itself is a {anchorTerm MyList1Type}`Type → Type`.
-- This means that it cannot be used to contain actual types, because then its argument would be {anchorTerm SomeTypes}`Type`, which is a {anchorTerm SomeTypes}`Type 1`:

{anchorTerm MyList1Type}`MyList` 本身是一个 {anchorTerm MyList1Type}`Type → Type`。
这意味着它不能用于包含实际类型，因为那样它的参数将是 {anchorTerm SomeTypes}`Type`，而 {anchorTerm SomeTypes}`Type` 是一个 {anchorTerm SomeTypes}`Type 1`：

```anchor myListNat1Err
def myListOfNat : MyList Type :=
  .cons Nat .nil
```
```anchorError myListNat1Err
application type mismatch
  MyList Type
argument
  Type
has type
  Type 1 : Type 2
but is expected to have type
  Type : Type 1
```

-- Updating {anchorName MyList2}`MyList` so that its argument is a {anchorTerm MyList2}`Type 1` results in a definition rejected by Lean:

更新 {anchorName MyList2}`MyList`，使其参数为 {anchorTerm MyList2}`Type 1`，会导致 Lean 拒绝该定义：

```anchor MyList2
inductive MyList (α : Type 1) : Type where
  | nil : MyList α
  | cons : α → MyList α → MyList α
```
```anchorError MyList2
invalid universe level in constructor 'MyList.cons', parameter has type
  α
at universe level
  2
which is not less than or equal to the inductive type's resulting universe level
  1
```

-- This error occurs because the argument to {anchorTerm MyList2}`cons` with type {anchorName MyList2}`α` is from a larger universe than {anchorName MyList2}`MyList`.
-- Placing {anchorName MyList2}`MyList` itself in {anchorTerm SomeTypes}`Type 1` solves this issue, but at the cost of {anchorName MyList2}`MyList` now being itself inconvenient to use in contexts that expect a {anchorTerm SomeTypes}`Type`.

此错误发生是因为 {anchorTerm MyList2}`cons` 的参数类型 {anchorName MyList2}`α` 来自比 {anchorName MyList2}`MyList` 更大的宇宙。
将 {anchorName MyList2}`MyList` 本身放在 {anchorTerm SomeTypes}`Type 1` 中可以解决此问题，但代价是 {anchorName MyList2}`MyList` 本身在期望 {anchorTerm SomeTypes}`Type` 的上下文中变得不方便使用。

-- The specific rules that govern whether a datatype is allowed are somewhat complicated.
-- Generally speaking, it's easiest to start with the datatype in the same universe as the largest of its arguments.
-- Then, if Lean rejects the definition, increase its level by one, which will usually go through.

管理数据类型是否允许的特定规则有些复杂。
一般来说，最简单的方法是让数据类型与它最大的参数位于同一个宇宙中。
然后，如果 Lean 拒绝该定义，则将其级别增加一，这通常会通过。

-- # Universe Polymorphism

# 宇宙多态

-- Defining a datatype in a specific universe can lead to code duplication.
-- Placing {anchorName MyList1}`MyList` in {anchorTerm MyList1Type}`Type → Type` means that it can't be used for an actual list of types.
-- Placing it in {anchorTerm MyList15Type}`Type 1 → Type 1` means that it can't be used for a list of lists of types.
-- Rather than copy-pasting the datatype to create versions in {anchorTerm SomeTypes}`Type`, {anchorTerm SomeTypes}`Type 1`, {anchorTerm Type2Type}`Type 2`, and so on, a feature called _universe polymorphism_ can be used to write a single definition that can be instantiated in any of these universes.

在特定宇宙中定义数据类型可能导致代码重复。
将 {anchorName MyList1}`MyList` 放在 {anchorTerm MyList1Type}`Type → Type` 中意味着它不能用于实际的类型列表。
将其放在 {anchorTerm MyList15Type}`Type 1 → Type 1` 中意味着它不能用于类型列表的列表。
与其复制粘贴数据类型以创建 {anchorTerm SomeTypes}`Type`、{anchorTerm SomeTypes}`Type 1`、{anchorTerm Type2Type}`Type 2` 等版本，不如使用一个名为__宇宙多态__的功能来编写一个可以在这些宇宙中的任何一个中实例化的单个定义。

-- Ordinary polymorphic types use variables to stand for types in a definition.
-- This allows Lean to fill in the variables differently, which enables these definitions to be used with a variety of types.
-- Similarly, universe polymorphism allows variables to stand for universes in a definition, enabling Lean to fill them in differently so that they can be used with a variety of universes.
-- Just as type arguments are conventionally named with Greek letters, universe arguments are conventionally named {lit}`u`, {lit}`v`, and {lit}`w`.

普通多态类型使用变量来表示定义中的类型。
这允许 Lean 以不同的方式填充变量，从而使这些定义可以与各种类型一起使用。
同样，宇宙多态允许变量表示定义中的宇宙，从而使 Lean 可以以不同的方式填充它们，以便它们可以与各种宇宙一起使用。
就像类型参数通常用希腊字母命名一样，宇宙参数通常命名为 {lit}`u`、{lit}`v` 和 {lit}`w`。

-- This definition of {anchorName MyList3}`MyList` doesn't specify a particular universe level, but instead uses a variable {anchorTerm MyList3}`u` to stand for any level.
-- If the resulting datatype is used with {anchorTerm SomeTypes}`Type`, then {anchorTerm MyList3}`u` is {lit}`0`, and if it's used with {anchorTerm Fun12Type}`Type 3`, then {anchorTerm MyList3}`u` is {lit}`3`:

{anchorName MyList3}`MyList` 的此定义没有指定特定的宇宙级别，而是使用变量 {anchorTerm MyList3}`u` 来表示任何级别。
如果结果数据类型与 {anchorTerm SomeTypes}`Type` 一起使用，则 {anchorTerm MyList3}`u` 为 {lit}`0`，如果与 {anchorTerm Fun12Type}`Type 3` 一起使用，则 {anchorTerm MyList3}`u` 为 {lit}`3`：

```anchor MyList3
inductive MyList (α : Type u) : Type u where
  | nil : MyList α
  | cons : α → MyList α → MyList α
```

-- With this definition, the same definition of {anchorName MyList3}`MyList` can be used to contain both actual natural numbers and the natural number type itself:

有了这个定义，{anchorName MyList3}`MyList` 的相同定义可以用于包含实际自然数和自然数类型本身：

```anchor myListOfNat3
def myListOfNumbers : MyList Nat :=
  .cons 0 (.cons 1 .nil)

def myListOfNat : MyList Type :=
  .cons Nat .nil
```

-- It can even contain itself:

它甚至可以包含自己：

```anchor myListOfList3
def myListOfList : MyList (Type → Type) :=
  .cons MyList .nil
```

-- It would seem that this would make it possible to write a logical paradox.
-- After all, the whole point of the universe system is to rule out self-referential types.
-- Behind the scenes, however, each occurrence of {anchorName MyList3}`MyList` is provided with a universe level argument.
-- In essence, the universe-polymorphic definition of {anchorName MyList3}`MyList` created a _copy_ of the datatype at each level, and the level argument selects which copy is to be used.
-- These level arguments are written with a dot and curly braces, so {anchorTerm MyListDotZero}`MyList.{0} : Type → Type`, {anchorTerm MyListDotOne}`MyList.{1} : Type 1 → Type 1`, and {anchorTerm MyListDotTwo}`MyList.{2} : Type 2 → Type 2`.

这似乎使得编写逻辑悖论成为可能。
毕竟，宇宙系统的全部目的就是排除自引用类型。
然而，在幕后，{anchorName MyList3}`MyList` 的每次出现都提供了宇宙级别参数。
本质上，{anchorName MyList3}`MyList` 的宇宙多态定义在每个级别创建了数据类型的__副本__，并且级别参数选择要使用的副本。
这些级别参数用点和花括号书写，因此 {anchorTerm MyListDotZero}`MyList.{0} : Type → Type`、{anchorTerm MyListDotOne}`MyList.{1} : Type 1 → Type 1` 和 {anchorTerm MyListDotTwo}`MyList.{2} : Type 2 → Type 2`。

-- Writing the levels explicitly, the prior example becomes:

显式写入级别后，前面的示例变为：

```anchor myListOfList3Expl
def myListOfNumbers : MyList.{0} Nat :=
  .cons 0 (.cons 1 .nil)

def myListOfNat : MyList.{1} Type :=
  .cons Nat .nil

def myListOfList : MyList.{1} (Type → Type) :=
  .cons MyList.{0} .nil
```

-- When a universe-polymorphic definition takes multiple types as arguments, it's a good idea to give each argument its own level variable for maximum flexibility.
-- For example, a version of {anchorName SumNoMax}`Sum` with a single level argument can be written as follows:

当宇宙多态定义接受多种类型作为参数时，最好为每个参数提供自己的级别变量，以实现最大灵活性。
例如，可以按如下方式编写具有单个级别参数的 {anchorName SumNoMax}`Sum` 版本：

```anchor SumNoMax
inductive Sum (α : Type u) (β : Type u) : Type u where
  | inl : α → Sum α β
  | inr : β → Sum α β
```

-- This definition can be used at multiple levels:

此定义可以在多个级别使用：

```anchor SumPoly
def stringOrNat : Sum String Nat := .inl "hello"

def typeOrType : Sum Type Type := .inr Nat
```

-- However, it requires that both arguments be in the same universe:

然而，它要求两个参数都在同一个宇宙中：

```anchor stringOrTypeLevels
def stringOrType : Sum String Type := .inr Nat
```
```anchorError stringOrTypeLevels
application type mismatch
  Sum String Type
argument
  Type
has type
  Type 1 : Type 2
but is expected to have type
  Type : Type 1
```

-- This datatype can be made more flexible by using different variables for the two type arguments' universe levels, and then declaring that the resulting datatype is in the largest of the two:

通过为两个类型参数的宇宙级别使用不同的变量，然后声明结果数据类型位于两者中较大的一个，可以使此数据类型更灵活：

```anchor SumMax
inductive Sum (α : Type u) (β : Type v) : Type (max u v) where
  | inl : α → Sum α β
  | inr : β → Sum α β
```

-- This allows {anchorName SumMax}`Sum` to be used with arguments from different universes:

这允许 {anchorName SumMax}`Sum` 与来自不同宇宙的参数一起使用：

```anchor stringOrTypeSum
def stringOrType : Sum String Type := .inr Nat
```

-- In positions where Lean expects a universe level, any of the following are allowed:
--  * A concrete level, like {lit}`0` or {lit}`1`
--  * A variable that stands for a level, such as {anchorTerm SumMax}`u` or {anchorTerm SumMax}`v`
--  * The maximum of two levels, written as {anchorTerm SumMax}`max` applied to the levels
--  * A level increase, written with {anchorTerm someTrueProps}`+ 1`

在 Lean 期望宇宙级别的位置，允许以下任何一种：
 * 具体级别，例如 {lit}`0` 或 {lit}`1`
 * 代表级别的变量，例如 {anchorTerm SumMax}`u` 或 {anchorTerm SumMax}`v`
 * 两个级别中的最大值，写为应用于级别的 {anchorTerm SumMax}`max`
 * 级别增加，写为 {anchorTerm someTrueProps}`+ 1`

-- ## Writing Universe-Polymorphic Definitions

## 编写宇宙多态定义

-- Until now, every datatype defined in this book has been in {anchorTerm SomeTypes}`Type`, the smallest universe of data.
-- When presenting polymorphic datatypes from the Lean standard library, such as {anchorName SomeTypes}`List` and {anchorName SumMax}`Sum`, this book created non-universe-polymorphic versions of them.
-- The real versions use universe polymorphism to enable code re-use between type-level and non-type-level programs.

到目前为止，本书中定义的每个数据类型都位于 {anchorTerm SomeTypes}`Type` 中，这是最小的数据宇宙。
在介绍 Lean 标准库中的多态数据类型时，例如 {anchorName SomeTypes}`List` 和 {anchorName SumMax}`Sum`，本书创建了它们的非宇宙多态版本。
真实版本使用宇宙多态来实现在类型级别和非类型级别程序之间的代码重用。

-- There are a few general guidelines to follow when writing universe-polymorphic types.
-- First off, independent type arguments should have different universe variables, which enables the polymorphic definition to be used with a wider variety of arguments, increasing the potential for code reuse.
-- Secondly, the whole type is itself typically either in the maximum of all the universe variables, or one greater than this maximum.
-- Try the smaller of the two first.
-- Finally, it's a good idea to put the new type in as small of a universe as possible, which allows it to be used more flexibly in other contexts.
-- Non-polymorphic types, such as {anchorTerm SomeTypes}`Nat` and {anchorName SomeTypes}`String`, can be placed directly in {anchorTerm Type0Type}`Type 0`.

编写宇宙多态类型时应遵循一些一般准则。
首先，独立的类型参数应具有不同的宇宙变量，这使得多态定义可以与更广泛的参数一起使用，从而增加了代码重用的潜力。
其次，整个类型本身通常要么在所有宇宙变量的最大值中，要么比这个最大值大一。
首先尝试两者中较小的一个。
最后，最好将新类型放在尽可能小的宇宙中，这使得它可以在其他上下文中更灵活地使用。
非多态类型，例如 {anchorTerm SomeTypes}`Nat` 和 {anchorName SomeTypes}`String`，可以直接放在 {anchorTerm Type0Type}`Type 0` 中。

-- ## {anchorTerm PropType}`Prop` and Polymorphism

## {anchorTerm PropType}`Prop` 和多态

-- Just as {anchorTerm SomeTypes}`Type`, {anchorTerm SomeTypes}`Type 1`, and so on describe types that classify programs and data, {anchorTerm PropType}`Prop` classifies logical propositions.
-- A type in {anchorTerm PropType}`Prop` describes what counts as convincing evidence for the truth of a statement.
-- Propositions are like ordinary types in many ways: they can be declared inductively, they can have constructors, and functions can take propositions as arguments.
-- However, unlike datatypes, it typically doesn't matter _which_ evidence is provided for the truth of a statement, only _that_ evidence is provided.
-- On the other hand, it is very important that a program not only return a {anchorTerm SomeTypes}`Nat`, but that it's the _correct_ {anchorTerm SomeTypes}`Nat`.

就像 {anchorTerm SomeTypes}`Type`、{anchorTerm SomeTypes}`Type 1` 等描述分类程序和数据的类型一样，{anchorTerm PropType}`Prop` 分类逻辑命题。
{anchorTerm PropType}`Prop` 中的类型描述了什么可以作为令人信服的证据来证明一个语句的真实性。
命题在许多方面都像普通类型：它们可以归纳声明，它们可以有构造函数，并且函数可以接受命题作为参数。
然而，与数据类型不同，通常不关心为语句的真实性提供了__哪个__证据，只关心__是否__提供了证据。
另一方面，程序不仅返回一个 {anchorTerm SomeTypes}`Nat`，而且返回的是__正确__的 {anchorTerm SomeTypes}`Nat`，这一点非常重要。

-- {anchorTerm PropType}`Prop` is at the bottom of the universe hierarchy, and the type of {anchorTerm PropType}`Prop` is {anchorTerm SomeTypes}`Type`.
-- This means that {anchorTerm PropType}`Prop` is a suitable argument to provide to {anchorName SomeTypes}`List`, for the same reason that {anchorTerm SomeTypes}`Nat` is.
-- Lists of propositions have type {anchorTerm SomeTypes}`List Prop`:

{anchorTerm PropType}`Prop` 位于宇宙层次结构的底部，{anchorTerm PropType}`Prop` 的类型是 {anchorTerm SomeTypes}`Type`。
这意味着 {anchorTerm PropType}`Prop` 是提供给 {anchorName SomeTypes}`List` 的合适参数，原因与 {anchorTerm SomeTypes}`Nat` 相同。
命题列表的类型为 {anchorTerm SomeTypes}`List Prop`：

```anchor someTrueProps
def someTruePropositions : List Prop := [
  1 + 1 = 2,
  "Hello, " ++ "world!" = "Hello, world!"
]
```

-- Filling out the universe argument explicitly demonstrates that {anchorTerm PropType}`Prop` is a {anchorTerm SomeTypes}`Type`:

显式填写宇宙参数表明 {anchorTerm PropType}`Prop` 是一个 {anchorTerm SomeTypes}`Type`：

```anchor someTruePropsExp
def someTruePropositions : List.{0} Prop := [
  1 + 1 = 2,
  "Hello, " ++ "world!" = "Hello, world!"
]
```

-- Behind the scenes, {anchorTerm PropType}`Prop` and {anchorTerm SomeTypes}`Type` are united into a single hierarchy called {anchorTerm SomeTypes}`Sort`.
-- {anchorTerm PropType}`Prop` is the same as {anchorTerm sorts}`Sort 0`, {anchorTerm Type0Type}`Type 0` is {anchorTerm sorts}`Sort 1`, {anchorTerm SomeTypes}`Type 1` is {anchorTerm sorts}`Sort 2`, and so forth.
-- In fact, {anchorTerm sorts}`Type u` is the same as {anchorTerm sorts}`Sort (u+1)`.
-- When writing programs with Lean, this is typically not relevant, but it may occur in error messages from time to time, and it explains the name of the {anchorName sorts}`CoeSort` class.
-- Additionally, having {anchorTerm PropType}`Prop` as {anchorTerm sorts}`Sort 0` allows one more universe operator to become useful.
-- The universe level {lit}`imax u v` is {lit}`0` when {anchorTerm sorts}`v` is {lit}`0`, or the larger of {anchorTerm sorts}`u` or {anchorTerm sorts}`v` otherwise.
-- Together with {anchorTerm sorts}`Sort`, this allows the special rule for functions that return {anchorTerm PropType}`Prop`s to be used when writing code that should be as portable as possible between {anchorTerm PropType}`Prop` and {anchorTerm SomeTypes}`Type` universes.

在幕后，{anchorTerm PropType}`Prop` 和 {anchorTerm SomeTypes}`Type` 被统一到一个名为 {anchorTerm SomeTypes}`Sort` 的单一层次结构中。
{anchorTerm PropType}`Prop` 与 {anchorTerm sorts}`Sort 0` 相同，{anchorTerm Type0Type}`Type 0` 是 {anchorTerm sorts}`Sort 1`，{anchorTerm SomeTypes}`Type 1` 是 {anchorTerm sorts}`Sort 2`，依此类推。
实际上，{anchorTerm sorts}`Type u` 与 {anchorTerm sorts}`Sort (u+1)` 相同。
在用 Lean 编写程序时，这通常不相关，但它可能会不时出现在错误消息中，并且它解释了 {anchorName sorts}`CoeSort` 类的名称。
此外，将 {anchorTerm PropType}`Prop` 作为 {anchorTerm sorts}`Sort 0` 允许另一个宇宙运算符变得有用。
宇宙级别 {lit}`imax u v` 在 {anchorTerm sorts}`v` 为 {lit}`0` 时为 {lit}`0`，否则为 {anchorTerm sorts}`u` 或 {anchorTerm sorts}`v` 中较大的一个。
结合 {anchorTerm sorts}`Sort`，这允许在编写应在 {anchorTerm PropType}`Prop` 和 {anchorTerm SomeTypes}`Type` 宇宙之间尽可能可移植的代码时使用返回 {anchorTerm PropType}`Prop` 的函数的特殊规则。

-- # Polymorphism in Practice

# 多态实践

-- In the remainder of the book, definitions of polymorphic datatypes, structures, and classes will use universe polymorphism in order to be consistent with the Lean standard library.
-- This will enable the complete presentation of the {moduleName}`Functor`, {anchorName next}`Applicative`, and {anchorName next}`Monad` classes to be completely consistent with their actual definitions.

在本书的其余部分中，多态数据类型、结构和类的定义将使用宇宙多态，以与 Lean 标准库保持一致。
这将使 {moduleName}`Functor`、{anchorName next}`Applicative` 和 {anchorName next}`Monad` 类的完整呈现与其实际定义完全一致。
