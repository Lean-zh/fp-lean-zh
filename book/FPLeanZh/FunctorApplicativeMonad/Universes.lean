import VersoManual
import FPLeanZh.Examples

open Verso.Genre Manual
open Verso Code External

open FPLeanZh

set_option verso.exampleProject "../examples"
set_option verso.exampleModule "Examples.Universes"

#doc (Manual) "宇宙" =>
%%%
file := "Universes"
tag := "universe-levels"
%%%
-- Universes

-- In the interests of simplicity, this book has thus far papered over an important feature of Lean: _universes_.
-- A universe is a type that classifies other types.
-- Two of them are familiar: {anchorTerm TypeType}`Type` and {anchorTerm PropType}`Prop`.
-- {anchorTerm SomeTypes}`Type` classifies ordinary types, such as {anchorName SomeTypes}`Nat`, {anchorTerm SomeTypes}`String`, {anchorTerm SomeTypes}`Int → String × Char`, and {anchorTerm SomeTypes}`IO Unit`.
-- {anchorTerm PropType}`Prop` classifies propositions that may be true or false, such as {anchorTerm SomeTypes}`"nisse" = "elf"` or {anchorTerm SomeTypes}`3 > 2`.
-- The type of {anchorTerm PropType}`Prop` is {anchorTerm SomeTypes}`Type`:

为了简化，本书到目前为止略去了 Lean 的一个重要特性：_宇宙 (Universes)_。
宇宙是一种对其他类型进行分类的类型。
其中两个是我们熟悉的：{anchorTerm TypeType}`Type` 和 {anchorTerm PropType}`Prop`。
{anchorTerm SomeTypes}`Type` 分类了普通类型，例如 {anchorName SomeTypes}`Nat`、{anchorTerm SomeTypes}`String`、{anchorTerm SomeTypes}`Int → String × Char` 和 {anchorTerm SomeTypes}`IO Unit`。
{anchorTerm PropType}`Prop` 分类了可能为真或假的命题，例如 {anchorTerm SomeTypes}`"nisse" = "elf"` 或 {anchorTerm SomeTypes}`3 > 2`。
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

出于技术原因，我们需要比这两个更多的宇宙。
具体而言，{anchorTerm SomeTypes}`Type` 本身不能是一个 {anchorTerm SomeTypes}`Type`。
这会导致逻辑悖论的产生，并削弱 Lean 作为定理证明器的实用性。

-- The formal argument for this is known as _Girard's Paradox_.
-- It is related to a better-known paradox known as _Russell's Paradox_, which was used to show that early versions of set theory were inconsistent.
-- In these set theories, a set can be defined by a property.
-- For example, one might have the set of all red things, the set of all fruit, the set of all natural numbers, or even the set of all sets.
-- Given a set, one can ask whether a given element is contained in it.
-- For instance, a bluebird is not contained in the set of all red things, but the set of all red things is contained in the set of all sets.
-- Indeed, the set of all sets even contains itself.

对此的正式论证被称为 _吉拉德悖论 (Girard's Paradox)_。
它与一个更著名的悖论有关，称为 _罗素悖论 (Russell's Paradox)_，该悖论用于展示早期版本的集合论是不一致的。
在这些集合论中，一个集合可以通过一个属性来定义。
例如，所有红色事物的集合，所有水果的集合，所有自然数的集合，甚至所有集合的集合。
给定一个集合，可以询问一个给定的元素是否被包含在其中。
例如，一只蓝色的鸟不会被包含在所有红色事物的集合中，但所有红色事物的集合被包含在所有集合的集合中。
实际上，所有集合的集合甚至包含其自身。

-- What about the set of all sets that do not contain themselves?
-- It contains the set of all red things, as the set of all red things is not itself red.
-- It does not contain the set of all sets, because the set of all sets contains itself.
-- But does it contain itself?
-- If it does contain itself, then it cannot contain itself.
-- But if it does not, then it must.

那么，所有不包含自身的集合的集合呢？
它包含所有红色事物的集合，因为所有红色事物的集合本身并不是红色的。
它不包含所有集合的集合，因为所有集合的集合包含自身。
但它是否包含自身呢？
如果它包含自身，那么它就不能包含自身。
但如果它不包含自身，那么它就必须包含自身。

-- This is a contradiction, which demonstrates that something was wrong with the initial assumptions.
-- In particular, allowing sets to be constructed by providing an arbitrary property is too powerful.
-- Later versions of set theory restrict the formation of sets to remove the paradox.

这是一个矛盾，表明了初始的假设存在问题。
具体而言，允许通过提供任意属性来构造集合的做法过于强大。
集合论的后续版本限制了集合的构造以消除这种悖论。

-- A related paradox can be constructed in versions of dependent type theory that assign the type {anchorTerm SomeTypes}`Type` to {anchorTerm SomeTypes}`Type`.
-- To ensure that Lean has consistent logical foundations and can be used as a tool for mathematics, {anchorTerm SomeTypes}`Type` needs to have some other type.
-- This type is called {anchorTerm SomeTypes}`Type 1`:

在那些可以将类型 {anchorTerm SomeTypes}`Type` 分配给 {anchorTerm SomeTypes}`Type` 的依赖类型理论的版本中，可以构建一个相关的悖论。
为了确保 Lean 具有自洽的逻辑基础并且能够被用作数学工具，{anchorTerm SomeTypes}`Type` 需要有其他类型。
这个类型称为 {anchorTerm SomeTypes}`Type 1`：

```anchor TypeType
#check Type
```
```anchorInfo TypeType
Type : Type 1
```

-- Similarly, {anchorTerm Type1Type}`Type 1` is a {anchorTerm Type1Type}`Type 2`,
-- {anchorTerm Type2Type}`Type 2` is a {anchorTerm Type2Type}`Type 3`,
-- {anchorTerm Type3Type}`Type 3` is a {anchorTerm Type3Type}`Type 4`, and so forth.

类似地，{anchorTerm Type1Type}`Type 1` 是一个 {anchorTerm Type1Type}`Type 2`，
{anchorTerm Type2Type}`Type 2` 是一个 {anchorTerm Type2Type}`Type 3`，
{anchorTerm Type3Type}`Type 3` 是一个 {anchorTerm Type3Type}`Type 4`，等等。

-- Function types occupy the smallest universe that can contain both the argument type and the return type.
-- This means that {anchorTerm NatNatType}`Nat → Nat` is a {anchorTerm NatNatType}`Type`, {anchorTerm Fun00Type}`Type → Type` is a {anchorTerm Fun00Type}`Type 1`, and {anchorTerm Fun12Type}`Type 3` is a {anchorTerm Fun12Type}`Type 1 → Type 2`.

函数类型占据了可以同时包含参数类型和返回类型的最小宇宙。
这意味着 {anchorTerm NatNatType}`Nat → Nat` 是一个 {anchorTerm NatNatType}`Type`，{anchorTerm Fun00Type}`Type → Type` 是一个 {anchorTerm Fun00Type}`Type 1`，而 {anchorTerm Fun12Type}`Type 3` 是一个 {anchorTerm Fun12Type}`Type 1 → Type 2`。

-- There is one exception to this rule.
-- If the return type of a function is a {anchorTerm PropType}`Prop`, then the whole function type is in {anchorTerm PropType}`Prop`, even if the argument is in a larger universe such as {anchorTerm SomeTypes}`Type` or even {anchorTerm SomeTypes}`Type 1`.
-- In particular, this means that predicates over values that have ordinary types are in {anchorTerm PropType}`Prop`.
-- For example, the type {anchorTerm FunPropType}`(n : Nat) → n = n + 0` represents a function from a {anchorTerm SomeTypes}`Nat` to evidence that it is equal to itself plus zero.
-- Even though {anchorTerm SomeTypes}`Nat` is in {anchorTerm SomeTypes}`Type`, this function type is in {anchorTerm FunPropType}`Prop` due to this rule.
-- Similarly, even though {anchorTerm SomeTypes}`Type` is in {anchorTerm SomeTypes}`Type 1`, the function type {anchorTerm FunTypePropType}`Type → 2 + 2 = 4` is still in {anchorTerm FunTypePropType}`Prop`.

这个规则有一个例外。
如果一个函数的返回类型是 {anchorTerm PropType}`Prop`，那么即使参数在更大的宇宙中，例如 {anchorTerm SomeTypes}`Type` 或甚至 {anchorTerm SomeTypes}`Type 1`，整个函数类型也在 {anchorTerm PropType}`Prop` 中。
具体而言，这意味着具有普通类型的值的谓词在 {anchorTerm PropType}`Prop` 中。
例如，类型 {anchorTerm FunPropType}`(n : Nat) → n = n + 0` 表示了从一个 {anchorTerm SomeTypes}`Nat` 到它等于自身加零的证据的函数。
尽管 {anchorTerm SomeTypes}`Nat` 在 {anchorTerm SomeTypes}`Type` 中，根据这个规则，这个函数类型在 {anchorTerm FunPropType}`Prop` 中。
同样，尽管 {anchorTerm SomeTypes}`Type` 在 {anchorTerm SomeTypes}`Type 1` 中，函数类型 {anchorTerm FunTypePropType}`Type → 2 + 2 = 4` 仍在 {anchorTerm FunTypePropType}`Prop` 中。

-- # User Defined Types
# 用户定义类型
%%%
tag := "inductive-type-universes"
%%%

-- Structures and inductive datatypes can be declared to inhabit particular universes.
-- Lean then checks whether each datatype avoids paradoxes by being in a universe that's large enough to prevent it from containing its own type.
-- For instance, in the following declaration, {anchorName MyList1}`MyList` is declared to reside in {anchorTerm SomeTypes}`Type`, and so is its type argument {anchorName MyList1}`α`:

结构体和归纳数据类型可以声明为存在于特定的宇宙中。
Lean 随后会检查每个数据类型是否通过位于足够大的宇宙中来避免悖论，从而防止它包含其自身的类型。
例如，在以下声明中，{anchorName MyList1}`MyList` 被声明为驻留在 {anchorTerm SomeTypes}`Type` 中，而它的类型参数 {anchorName MyList1}`α` 也是如此：

```anchor MyList1
inductive MyList (α : Type) : Type where
  | nil : MyList α
  | cons : α → MyList α → MyList α
```

-- {anchorTerm MyList1Type}`MyList` itself is a {anchorTerm MyList1Type}`Type → Type`.
-- This means that it cannot be used to contain actual types, because then its argument would be {anchorTerm SomeTypes}`Type`, which is a {anchorTerm SomeTypes}`Type 1`:

{anchorTerm MyList1Type}`MyList` 本身是一个 {anchorTerm MyList1Type}`Type → Type`。
这意味着它不能用于包含实际类型，因为那样的话它的参数将会是 {anchorTerm SomeTypes}`Type`，也就是一个 {anchorTerm SomeTypes}`Type 1`：

```anchor myListNat1Err
def myListOfNat : MyList Type :=
  .cons Nat .nil
```
```anchorError myListNat1Err
Application type mismatch: The argument
  Type
has type
  Type 1
of sort `Type 2` but is expected to have type
  Type
of sort `Type 1` in the application
  MyList Type
```

-- Updating {anchorName MyList2}`MyList` so that its argument is a {anchorTerm MyList2}`Type 1` results in a definition rejected by Lean:

更新 {anchorName MyList2}`MyList` 使其参数为一个 {anchorTerm MyList2}`Type 1`，这会导致该定义被 Lean 拒绝：

```anchor MyList2
inductive MyList (α : Type 1) : Type where
  | nil : MyList α
  | cons : α → MyList α → MyList α
```
```anchorError MyList2
Invalid universe level in constructor `MyList.cons`: Parameter has type
  α
at universe level
  2
which is not less than or equal to the inductive type's resulting universe level
  1
```

-- This error occurs because the argument to {anchorTerm MyList2}`cons` with type {anchorName MyList2}`α` is from a larger universe than {anchorName MyList2}`MyList`.
-- Placing {anchorName MyList2}`MyList` itself in {anchorTerm SomeTypes}`Type 1` solves this issue, but at the cost of {anchorName MyList2}`MyList` now being itself inconvenient to use in contexts that expect a {anchorTerm SomeTypes}`Type`.

发生此错误的原因是，类型为 {anchorName MyList2}`α` 的 {anchorTerm MyList2}`cons` 的参数来自一个比 {anchorName MyList2}`MyList` 更大的宇宙。
将 {anchorName MyList2}`MyList` 本身置于 {anchorTerm SomeTypes}`Type 1` 中可以解决这个问题，但代价是 {anchorName MyList2}`MyList` 本身在需要 {anchorTerm SomeTypes}`Type` 的内容中变得不便使用。

-- The specific rules that govern whether a datatype is allowed are somewhat complicated.
-- Generally speaking, it's easiest to start with the datatype in the same universe as the largest of its arguments.
-- Then, if Lean rejects the definition, increase its level by one, which will usually go through.

决定某种数据类型是否被允许的具体规则有些复杂。
通常来说，最简单的方法是，从其最大的参数所属的宇宙与自身所属的宇宙相同的数据类型开始。
然后，如果 Lean 拒绝了该定义，那就将其层级增加一级，这通常会奏效。

-- # Universe Polymorphism
# 宇宙多态
%%%
tag := "universe-polymorphism"
%%%

-- Defining a datatype in a specific universe can lead to code duplication.
-- Placing {anchorName MyList1}`MyList` in {anchorTerm MyList1Type}`Type → Type` means that it can't be used for an actual list of types.
-- Placing it in {anchorTerm MyList15Type}`Type 1 → Type 1` means that it can't be used for a list of lists of types.
-- Rather than copy-pasting the datatype to create versions in {anchorTerm SomeTypes}`Type`, {anchorTerm SomeTypes}`Type 1`, {anchorTerm Type2Type}`Type 2`, and so on, a feature called _universe polymorphism_ can be used to write a single definition that can be instantiated in any of these universes.

在特定的宇宙中定义一个数据类型可能会导致代码重复。
将 {anchorName MyList1}`MyList` 置于 {anchorTerm MyList1Type}`Type → Type` 中意味着它不能被用于实际的类型列表。
将它放在 {anchorTerm MyList15Type}`Type 1 → Type 1` 内意味着它不能用于类型列表的列表。
与其复制粘贴数据类型以在 {anchorTerm SomeTypes}`Type`、{anchorTerm SomeTypes}`Type 1`、{anchorTerm Type2Type}`Type 2` 等中创建不同版本，不如使用一种称为 _宇宙多态_ 的特性来编写单个可以在任意这些宇宙中实例化的定义。

-- Ordinary polymorphic types use variables to stand for types in a definition.
-- This allows Lean to fill in the variables differently, which enables these definitions to be used with a variety of types.
-- Similarly, universe polymorphism allows variables to stand for universes in a definition, enabling Lean to fill them in differently so that they can be used with a variety of universes.
-- Just as type arguments are conventionally named with Greek letters, universe arguments are conventionally named {lit}`u`, {lit}`v`, and {lit}`w`.

普通的多态类型在定义中使用变量来表示类型。
这使得 Lean 可以以不同的方式填充这些变量，从而使这些定义可以与各种类型一起使用。
同样，宇宙多态性允许变量在定义中表示宇宙，使得 Lean 可以以不同的方式去填充它们，以便可以用于各种宇宙。
正如类型参数通常用希腊字母命名一样，宇宙参数通常命名为 {lit}`u`、{lit}`v` 和 {lit}`w`。

-- This definition of {anchorName MyList3}`MyList` doesn't specify a particular universe level, but instead uses a variable {anchorTerm MyList3}`u` to stand for any level.
-- If the resulting datatype is used with {anchorTerm SomeTypes}`Type`, then {anchorTerm MyList3}`u` is {lit}`0`, and if it's used with {anchorTerm Fun12Type}`Type 3`, then {anchorTerm MyList3}`u` is {lit}`3`:

{anchorName MyList3}`MyList` 的这个定义没有指定特定的宇宙层级，而是使用变量 {anchorTerm MyList3}`u` 来表示任意层级。
如果最终的数据类型与 {anchorTerm SomeTypes}`Type` 一起使用，那么 {anchorTerm MyList3}`u` 是 {lit}`0`；如果与 {anchorTerm Fun12Type}`Type 3` 一起使用，那么 {anchorTerm MyList3}`u` 是 {lit}`3`：

```anchor MyList3
inductive MyList (α : Type u) : Type u where
  | nil : MyList α
  | cons : α → MyList α → MyList α
```

-- With this definition, the same definition of {anchorName MyList3}`MyList` can be used to contain both actual natural numbers and the natural number type itself:

通过这个定义，{anchorName MyList3}`MyList` 的相同定义可以用于包含实际的自然数以及自然数类型本身：

```anchor myListOfNat3
def myListOfNumbers : MyList Nat :=
  .cons 0 (.cons 1 .nil)

def myListOfNat : MyList Type :=
  .cons Nat .nil
```

-- It can even contain itself:

它甚至可以包含其自身：

```anchor myListOfList3
def myListOfList : MyList (Type → Type) :=
  .cons MyList .nil
```

-- It would seem that this would make it possible to write a logical paradox.
-- After all, the whole point of the universe system is to rule out self-referential types.
-- Behind the scenes, however, each occurrence of {anchorName MyList3}`MyList` is provided with a universe level argument.
-- In essence, the universe-polymorphic definition of {anchorName MyList3}`MyList` created a _copy_ of the datatype at each level, and the level argument selects which copy is to be used.
-- These level arguments are written with a dot and curly braces, so {anchorTerm MyListDotZero}`MyList.{0} : Type → Type`, {anchorTerm MyListDotOne}`MyList.{1} : Type 1 → Type 1`, and {anchorTerm MyListDotTwo}`MyList.{2} : Type 2 → Type 2`.

这似乎使得写出一个逻辑悖论成为可能。
毕竟，宇宙系统的全部意义在于排除自指类型。
然而，在幕后，每次出现 {anchorName MyList3}`MyList` 时都会提供一个宇宙层级的参数。
本质上，{anchorName MyList3}`MyList` 的宇宙多态定义在每个层级创建了数据类型的一个 _副本_，层级参数选择要使用哪个副本。
这些层级参数使用一个点和大括号书写，例如 {anchorTerm MyListDotZero}`MyList.{0} : Type → Type`，{anchorTerm MyListDotOne}`MyList.{1} : Type 1 → Type 1`，和 {anchorTerm MyListDotTwo}`MyList.{2} : Type 2 → Type 2`。

-- Writing the levels explicitly, the prior example becomes:

明确地写出所有层次，之前的例子变成了：

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

当一个宇宙多态定义接受了多个类型作为参数时，最好给每个参数赋予其自己的层级变量，以实现最大的灵活性。
例如，一个带有单个层级参数的 {anchorName SumNoMax}`Sum` 版本可以写成如下形式：

```anchor SumNoMax
inductive Sum (α : Type u) (β : Type u) : Type u where
  | inl : α → Sum α β
  | inr : β → Sum α β
```

-- This definition can be used at multiple levels:

这个定义可以在多个层级上使用：

```anchor SumPoly
def stringOrNat : Sum String Nat := .inl "hello"

def typeOrType : Sum Type Type := .inr Nat
```

-- However, it requires that both arguments be in the same universe:

但是，它要求两个参数位于同一个宇宙内：

```anchor stringOrTypeLevels
def stringOrType : Sum String Type := .inr Nat
```
```anchorError stringOrTypeLevels
Application type mismatch: The argument
  Type
has type
  Type 1
of sort `Type 2` but is expected to have type
  Type
of sort `Type 1` in the application
  Sum String Type
```

-- This datatype can be made more flexible by using different variables for the two type arguments' universe levels, and then declaring that the resulting datatype is in the largest of the two:

通过为两个类型参数的宇宙层级使用不同的变量，并声明生成的数据类型是两者中最大的层级，这可以使该数据类型更加灵活：

```anchor SumMax
inductive Sum (α : Type u) (β : Type v) : Type (max u v) where
  | inl : α → Sum α β
  | inr : β → Sum α β
```

-- This allows {anchorName SumMax}`Sum` to be used with arguments from different universes:

这使得 {anchorName SumMax}`Sum` 可以与来自不同宇宙的参数一起使用：

```anchor stringOrTypeSum
def stringOrType : Sum String Type := .inr Nat
```

-- In positions where Lean expects a universe level, any of the following are allowed:
--  * A concrete level, like {lit}`0` or {lit}`1`
--  * A variable that stands for a level, such as {anchorTerm SumMax}`u` or {anchorTerm SumMax}`v`
--  * The maximum of two levels, written as {anchorTerm SumMax}`max` applied to the levels
--  * A level increase, written with {anchorTerm someTrueProps}`+ 1`

在 Lean 需要宇宙层级的位置，以下任意一种都是被允许的：
 * 具体的层级，如 {lit}`0` 或 {lit}`1`
 * 代表层级的变量，如 {anchorTerm SumMax}`u` 或 {anchorTerm SumMax}`v`
 * 两个层级的最大值，写作 {anchorTerm SumMax}`max` 应用于这些层级
 * 层级增加，写作 {anchorTerm someTrueProps}`+ 1`

-- ## Writing Universe-Polymorphic Definitions
## 编写宇宙多态定义
%%%
tag := "writing-universe-polymorphic-definitions"
%%%

-- Until now, every datatype defined in this book has been in {anchorTerm SomeTypes}`Type`, the smallest universe of data.
-- When presenting polymorphic datatypes from the Lean standard library, such as {anchorName SomeTypes}`List` and {anchorName SumMax}`Sum`, this book created non-universe-polymorphic versions of them.
-- The real versions use universe polymorphism to enable code re-use between type-level and non-type-level programs.

到目前为止，本书中定义的每种数据类型都在 {anchorTerm SomeTypes}`Type` 中，即最小的数据宇宙。
在展示 Lean 标准库中的多态数据类型时，例如 {anchorName SomeTypes}`List` 和 {anchorName SumMax}`Sum`，本书创建了它们的非宇宙多态的版本。
实际的版本使用了宇宙多态性来实现类型层级和非类型层级程序之间的代码复用。

-- There are a few general guidelines to follow when writing universe-polymorphic types.
-- First off, independent type arguments should have different universe variables, which enables the polymorphic definition to be used with a wider variety of arguments, increasing the potential for code reuse.
-- Secondly, the whole type is itself typically either in the maximum of all the universe variables, or one greater than this maximum.
-- Try the smaller of the two first.
-- Finally, it's a good idea to put the new type in as small of a universe as possible, which allows it to be used more flexibly in other contexts.
-- Non-polymorphic types, such as {anchorTerm SomeTypes}`Nat` and {anchorName SomeTypes}`String`, can be placed directly in {anchorTerm Type0Type}`Type 0`.

在编写宇宙多态类型时，有一些通用的指导准则需要遵守。
首先，独立的类型参数应具有不同的宇宙变量，这使得多态定义能够与更多种类的参数一起使用，从而增加代码复用的可能性。
其次，整个类型本身通常要么位于所有宇宙变量的最大值，要么位于比这个最大值大一的层级。
先尝试使用两者中较小的那个。
最后，最好将新类型放在一个尽可能小的宇宙中，这使得它在其他内容中可以更灵活地使用。
非多态类型，如 {anchorTerm SomeTypes}`Nat` 和 {anchorName SomeTypes}`String`，可以直接放在 {anchorTerm Type0Type}`Type 0` 中。

-- ## {anchorTerm PropType}`Prop` and Polymorphism
## {anchorTerm PropType}`Prop` 和多态
%%%
tag := "prop-and-polymorphism"
%%%

-- Just as {anchorTerm SomeTypes}`Type`, {anchorTerm SomeTypes}`Type 1`, and so on describe types that classify programs and data, {anchorTerm PropType}`Prop` classifies logical propositions.
-- A type in {anchorTerm PropType}`Prop` describes what counts as convincing evidence for the truth of a statement.
-- Propositions are like ordinary types in many ways: they can be declared inductively, they can have constructors, and functions can take propositions as arguments.
-- However, unlike datatypes, it typically doesn't matter _which_ evidence is provided for the truth of a statement, only _that_ evidence is provided.
-- On the other hand, it is very important that a program not only return a {anchorTerm SomeTypes}`Nat`, but that it's the _correct_ {anchorTerm SomeTypes}`Nat`.

就像 {anchorTerm SomeTypes}`Type`、{anchorTerm SomeTypes}`Type 1` 等描述了对程序和数据进行分类的类型一样，{anchorTerm PropType}`Prop` 则用于对逻辑命题进行分类。
{anchorTerm PropType}`Prop` 中的类型描述了什么可以作为令人信服的证据以证明一个陈述的真。
命题在许多方面与普通类型相似：它们可以被归纳地声明，它们可以有构造子，并且函数也可以将命题作为参数。
然而，与数据类型不同的是，通常来说，为证明陈述的真实性所提供的 _那个_ 证据的具体内容并不重要，重要的是提供了 _那个_ 证据。
另一方面，程序不仅要返回一个 {anchorTerm SomeTypes}`Nat`，而且要返回 _正确的_ {anchorTerm SomeTypes}`Nat`，这一点非常重要。

-- {anchorTerm PropType}`Prop` is at the bottom of the universe hierarchy, and the type of {anchorTerm PropType}`Prop` is {anchorTerm SomeTypes}`Type`.
-- This means that {anchorTerm PropType}`Prop` is a suitable argument to provide to {anchorName SomeTypes}`List`, for the same reason that {anchorTerm SomeTypes}`Nat` is.
-- Lists of propositions have type {anchorTerm SomeTypes}`List Prop`:

{anchorTerm PropType}`Prop` 位于宇宙层级体系的底部，且 {anchorTerm PropType}`Prop` 的类型是 {anchorTerm SomeTypes}`Type`。
这意味着 {anchorTerm PropType}`Prop` 适合作为 {anchorName SomeTypes}`List` 的一个参数，原因和 {anchorTerm SomeTypes}`Nat` 一样。
命题列表的类型是 {anchorTerm SomeTypes}`List Prop`：

```anchor someTrueProps
def someTruePropositions : List Prop := [
  1 + 1 = 2,
  "Hello, " ++ "world!" = "Hello, world!"
]
```

-- Filling out the universe argument explicitly demonstrates that {anchorTerm PropType}`Prop` is a {anchorTerm SomeTypes}`Type`:

显式地填写宇宙参数表明了 {anchorTerm PropType}`Prop` 是一个 {anchorTerm SomeTypes}`Type`：

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

在幕后，{anchorTerm PropType}`Prop` 和 {anchorTerm SomeTypes}`Type` 被统一到一个称为 {anchorTerm SomeTypes}`Sort` 的层级体系中。
{anchorTerm PropType}`Prop` 与 {anchorTerm sorts}`Sort 0` 相同，{anchorTerm Type0Type}`Type 0` 是 {anchorTerm sorts}`Sort 1`，{anchorTerm SomeTypes}`Type 1` 是 {anchorTerm sorts}`Sort 2`，依此类推。
实际上，{anchorTerm sorts}`Type u` 就是 {anchorTerm sorts}`Sort (u+1)`。
在使用 Lean 编写程序时，这通常并不相关，但它可能有时会出现在错误消息中，并解释 {anchorName sorts}`CoeSort` 类的名称。
此外，将 {anchorTerm PropType}`Prop` 作为 {anchorTerm sorts}`Sort 0` 可以使得一个额外的宇宙运算符变得有用。
宇宙级别 {lit}`imax u v` 在 {anchorTerm sorts}`v` 为 {lit}`0` 时为 {lit}`0`，否则为 {anchorTerm sorts}`u` 或 {anchorTerm sorts}`v` 中较大的那个。
结合 {anchorTerm sorts}`Sort`，这使得在编写代码时可以使用一个特殊规则，该规则允许返回 {anchorTerm PropType}`Prop` 的函数在 {anchorTerm PropType}`Prop` 和 {anchorTerm SomeTypes}`Type` 宇宙之间尽可能地具有可移植性。

-- # Polymorphism in Practice
# 多态的实际应用
%%%
tag := "polymorphism-in-practice"
%%%

-- In the remainder of the book, definitions of polymorphic datatypes, structures, and classes will use universe polymorphism in order to be consistent with the Lean standard library.
-- This will enable the complete presentation of the {moduleName}`Functor`, {anchorName next}`Applicative`, and {anchorName next}`Monad` classes to be completely consistent with their actual definitions.

在本书的其余部分，多态数据类型、结构体和类的定义将使用宇宙多态性，以便与 Lean 的标准库保持一致。
这将使 {moduleName}`Functor`、{anchorName next}`Applicative` 和 {anchorName next}`Monad` 类的完整展示与它们的实际定义完全一致。
