import VersoManual
import FPLeanZh.Examples

open Verso.Genre Manual
open Verso Code External

open FPLeanZh

set_option verso.exampleProject "../examples"
set_option verso.exampleModule "Examples.FunctorApplicativeMonad"

#doc (Manual) "结构与继承" =>

-- In order to understand the full definitions of {anchorName ApplicativeLaws}`Functor`, {anchorName ApplicativeLaws}`Applicative`, and {anchorName ApplicativeLaws}`Monad`, another Lean feature is necessary: structure inheritance.
-- Structure inheritance allows one structure type to provide the interface of another, along with additional fields.
-- This can be useful when modeling concepts that have a clear taxonomic relationship.
-- For example, take a model of mythical creatures.
-- Some of them are large, and some are small:

为了理解 {anchorName ApplicativeLaws}`Functor`、{anchorName ApplicativeLaws}`Applicative` 和 {anchorName ApplicativeLaws}`Monad` 的完整定义，还需要 Lean 的另一个特性：结构继承。
结构继承允许一个结构类型提供另一个结构的接口，以及附加字段。
这在建模具有清晰分类关系的概念时很有用。
例如，以神话生物模型为例。
其中一些体型庞大，另一些则体型较小：

```anchor MythicalCreature
structure MythicalCreature where
  large : Bool
deriving Repr
```

-- Behind the scenes, defining the {anchorName MythicalCreature}`MythicalCreature` structure creates an inductive type with a single constructor called {anchorName MythicalCreatureMore}`mk`:

在幕后，定义 {anchorName MythicalCreature}`MythicalCreature` 结构会创建一个带有单个构造函数 {anchorName MythicalCreatureMore}`mk` 的归纳类型：

```anchor MythicalCreatureMk
#check MythicalCreature.mk
```
```anchorInfo MythicalCreatureMk
MythicalCreature.mk (large : Bool) : MythicalCreature
```

-- Similarly, a function {anchorName MythicalCreatureLarge}`MythicalCreature.large` is created that actually extracts the field from the constructor:

同样，创建了一个函数 {anchorName MythicalCreatureLarge}`MythicalCreature.large`，它实际上从构造函数中提取字段：

```anchor MythicalCreatureLarge
#check MythicalCreature.large
```
```anchorInfo MythicalCreatureLarge
MythicalCreature.large (self : MythicalCreature) : Bool
```

-- In most old stories, each monster can be defeated in some way.
-- A description of a monster should include this information, along with whether it is large:

在大多数古老的故事中，每个怪物都可以通过某种方式被击败。
怪物的描述应包括此信息，以及它是否体型庞大：

```anchor Monster
structure Monster extends MythicalCreature where
  vulnerability : String
deriving Repr
```

-- The {anchorTerm Monster}`extends MythicalCreature` in the heading states that every monster is also mythical.
-- To define a {anchorName Monster}`Monster`, both the fields from {anchorName Monster}`MythicalCreature` and the fields from {anchorName Monster}`Monster` should be provided.
-- A troll is a large monster that is vulnerable to sunlight:

标题中的 {anchorTerm Monster}`extends MythicalCreature` 表示每个怪物都是神话生物。
要定义一个 {anchorName Monster}`Monster`，需要提供 {anchorName Monster}`MythicalCreature` 和 {anchorName Monster}`Monster` 的字段。
巨魔是一种体型庞大且惧怕阳光的怪物：

```anchor troll
def troll : Monster where
  large := true
  vulnerability := "sunlight"
```

-- Behind the scenes, inheritance is implemented using composition.
-- The constructor {anchorName MonsterMk}`Monster.mk` takes a {anchorName Monster}`MythicalCreature` as its argument:

在幕后，继承是通过组合实现的。
构造函数 {anchorName MonsterMk}`Monster.mk` 接受一个 {anchorName Monster}`MythicalCreature` 作为其参数：

```anchor MonsterMk
#check Monster.mk
```
```anchorInfo MonsterMk
Monster.mk (toMythicalCreature : MythicalCreature) (vulnerability : String) : Monster
```

-- In addition to defining functions to extract the value of each new field, a function {anchorTerm MonsterToCreature}`Monster.toMythicalCreature` is defined with type {anchorTerm MonsterToCreature}`Monster → MythicalCreature`.
-- This can be used to extract the underlying creature.

除了定义用于提取每个新字段值的函数外，还定义了一个类型为 {anchorTerm MonsterToCreature}`Monster → MythicalCreature` 的函数 {anchorTerm MonsterToCreature}`Monster.toMythicalCreature`。
这可以用于提取底层生物。

-- Moving up the inheritance hierarchy in Lean is not the same thing as upcasting in object-oriented languages.
-- An upcast operator causes a value from a derived class to be treated as an instance of the parent class, but the value retains its identity and structure.
-- In Lean, however, moving up the inheritance hierarchy actually erases the underlying information.
-- To see this in action, consider the result of evaluating {anchorTerm evalTrollCast}`troll.toMythicalCreature`:

在 Lean 中向上移动继承层次结构与面向对象语言中的向上转型不同。
向上转型运算符使派生类的值被视为父类的实例，但该值保留其标识和结构。
然而，在 Lean 中，向上移动继承层次结构实际上会擦除底层信息。
要了解其作用，请考虑评估 {anchorTerm evalTrollCast}`troll.toMythicalCreature` 的结果：

```anchor evalTrollCast
#eval troll.toMythicalCreature
```
```anchorInfo evalTrollCast
{ large := true }
```

-- Only the fields of {anchorName MythicalCreature}`MythicalCreature` remain.

只剩下 {anchorName MythicalCreature}`MythicalCreature` 的字段。

-- Just like the {kw}`where` syntax, curly-brace notation with field names also works with structure inheritance:

就像 {kw}`where` 语法一样，带有字段名称的花括号表示法也适用于结构继承：

```anchor troll2
def troll : Monster := {large := true, vulnerability := "sunlight"}
```

-- However, the anonymous angle-bracket notation that delegates to the underlying constructor reveals the internal details:

然而，委托给底层构造函数的匿名尖括号表示法揭示了内部细节：

```anchor wrongTroll1
def troll : Monster := ⟨true, "sunlight"⟩
```
```anchorError wrongTroll1
application type mismatch
  Monster.mk true
argument
  true
has type
  Bool : Type
but is expected to have type
  MythicalCreature : Type
```

-- An extra set of angle brackets is required, which invokes {anchorName MythicalCreatureMk}`MythicalCreature.mk` on {anchorName troll3}`true`:

需要额外的一组尖括号，它在 {anchorName troll3}`true` 上调用 {anchorName MythicalCreatureMk}`MythicalCreature.mk`：

```anchor troll3
def troll : Monster := ⟨⟨true⟩, "sunlight"⟩
```

-- Lean's dot notation is capable of taking inheritance into account.
-- In other words, the existing {anchorName trollLargeNoDot}`MythicalCreature.large` can be used with a {anchorName Monster}`Monster`, and Lean automatically inserts the call to {anchorTerm MonsterToCreature}`Monster.toMythicalCreature` before the call to {anchorName trollLargeNoDot}`MythicalCreature.large`.
-- However, this only occurs when using dot notation, and applying the field lookup function using normal function call syntax results in a type error:

Lean 的点表示法能够考虑继承。
换句话说，现有的 {anchorName trollLargeNoDot}`MythicalCreature.large` 可以与 {anchorName Monster}`Monster` 一起使用，并且 Lean 会在调用 {anchorName trollLargeNoDot}`MythicalCreature.large` 之前自动插入对 {anchorTerm MonsterToCreature}`Monster.toMythicalCreature` 的调用。
然而，这只在使用点表示法时发生，使用普通函数调用语法应用字段查找函数会导致类型错误：

```anchor trollLargeNoDot
#eval MythicalCreature.large troll
```
```anchorError trollLargeNoDot
application type mismatch
  MythicalCreature.large troll
argument
  troll
has type
  Monster : Type
but is expected to have type
  MythicalCreature : Type
```

-- Dot notation can also take inheritance into account for user-defined functions.
-- A small creature is one that is not large:

点表示法也可以为用户定义的函数考虑继承。
小生物是指不大的生物：

```anchor small
def MythicalCreature.small (c : MythicalCreature) : Bool := !c.large
```

-- Evaluating {anchorTerm smallTroll}`troll.small` yields {anchorTerm smallTroll}`false`, while attempting to evaluate {anchorTerm smallTrollWrong}`MythicalCreature.small troll` results in:

评估 {anchorTerm smallTroll}`troll.small` 产生 {anchorTerm smallTroll}`false`，而尝试评估 {anchorTerm smallTrollWrong}`MythicalCreature.small troll` 产生：

```anchorError smallTrollWrong
application type mismatch
  MythicalCreature.small troll
argument
  troll
has type
  Monster : Type
but is expected to have type
  MythicalCreature : Type
```

-- # Multiple Inheritance

# 多重继承

-- A helper is a mythical creature that can provide assistance when given the correct payment:

助手是一种神话生物，在获得正确报酬时可以提供帮助：

```anchor Helper
structure Helper extends MythicalCreature where
  assistance : String
  payment : String
deriving Repr
```

-- For example, a _nisse_ is a kind of small elf that's known to help around the house when provided with tasty porridge:

例如，_nisse_ 是一种小精灵，以在提供美味粥时帮助家务而闻名：

```anchor elf
def nisse : Helper where
  large := false
  assistance := "household tasks"
  payment := "porridge"
```

-- If domesticated, trolls make excellent helpers.
-- They are strong enough to plow a whole field in a single night, though they require model goats to keep them satisfied with their lot in life.
-- A monstrous assistant is a monster that is also a helper:

如果被驯化，巨魔会成为优秀的助手。
它们足够强大，可以在一夜之间犁完整个田地，尽管它们需要模型山羊才能对生活感到满意。
一个怪物助手是一个既是怪物又是助手的生物：

```anchor MonstrousAssistant
structure MonstrousAssistant extends Monster, Helper where
deriving Repr
```

-- A value of this structure type must fill in all of the fields from both parent structures:

此结构类型的值必须填充来自两个父结构的所有字段：

```anchor domesticatedTroll
def domesticatedTroll : MonstrousAssistant where
  large := true
  assistance := "heavy labor"
  payment := "toy goats"
  vulnerability := "sunlight"
```

-- Both of the parent structure types extend {anchorName MythicalCreature}`MythicalCreature`.
-- If multiple inheritance were implemented naïvely, then this could lead to a “diamond problem”, where it would be unclear which path to {anchorName MythicalCreature}`large` should be taken from a given {anchorName MonstrousAssistant}`MonstrousAssistant`.
-- Should it take {lit}`large` from the contained {anchorName Monster}`Monster` or from the contained {anchorName Helper}`Helper`?
-- In Lean, the answer is that the first specified path to the grandparent structure is taken, and the additional parent structures' fields are copied rather than having the new structure include both parents directly.

两个父结构类型都扩展了 {anchorName MythicalCreature}`MythicalCreature`。
如果多重继承被天真地实现，那么这可能会导致“菱形问题”，即从给定的 {anchorName MonstrousAssistant}`MonstrousAssistant` 到 {anchorName MythicalCreature}`large` 的路径不明确。
它应该从包含的 {anchorName Monster}`Monster` 中获取 {lit}`large` 还是从包含的 {anchorName Helper}`Helper` 中获取？
在 Lean 中，答案是采用到祖父结构的第一条指定路径，并且复制额外的父结构的字段，而不是让新结构直接包含两个父结构。

-- This can be seen by examining the signature of the constructor for {anchorName MonstrousAssistant}`MonstrousAssistant`:

通过检查 {anchorName MonstrousAssistant}`MonstrousAssistant` 的构造函数的签名可以看出这一点：

```anchor checkMonstrousAssistantMk
#check MonstrousAssistant.mk
```
```anchorInfo checkMonstrousAssistantMk
MonstrousAssistant.mk (toMonster : Monster) (assistance payment : String) : MonstrousAssistant
```

-- It takes a {anchorName Monster}`Monster` as an argument, along with the two fields that {anchorName Helper}`Helper` introduces on top of {anchorName MythicalCreature}`MythicalCreature`.
-- Similarly, while {anchorName MonstrousAssistantMore}`MonstrousAssistant.toMonster` merely extracts the {anchorName Monster}`Monster` from the constructor, {anchorName printMonstrousAssistantToHelper}`MonstrousAssistant.toHelper` has no {anchorName Helper}`Helper` to extract.
-- The {kw}`#print` command exposes its implementation:

它接受一个 {anchorName Monster}`Monster` 作为参数，以及 {anchorName Helper}`Helper` 在 {anchorName MythicalCreature}`MythicalCreature` 之上引入的两个字段。
同样，虽然 {anchorName MonstrousAssistantMore}`MonstrousAssistant.toMonster` 只是从构造函数中提取 {anchorName Monster}`Monster`，但 {anchorName printMonstrousAssistantToHelper}`MonstrousAssistant.toHelper` 没有 {anchorName Helper}`Helper` 可提取。
{kw}`#print` 命令暴露了其实现：

```anchor printMonstrousAssistantToHelper
#print MonstrousAssistant.toHelper
```
```anchorInfo printMonstrousAssistantToHelper
@[reducible] def MonstrousAssistant.toHelper : MonstrousAssistant → Helper :=
fun self => { toMythicalCreature := self.toMythicalCreature, assistance := self.assistance, payment := self.payment }
```

-- This function constructs a {anchorName Helper}`Helper` from the fields of {anchorName MonstrousAssistant}`MonstrousAssistant`.
-- The {lit}`@[reducible]` attribute has the same effect as writing {kw}`abbrev`.

此函数从 {anchorName MonstrousAssistant}`MonstrousAssistant` 的字段构造一个 {anchorName Helper}`Helper`。
{lit}`@[reducible]` 属性与编写 {kw}`abbrev` 具有相同的效果。

-- ## Default Declarations

## 默认声明

-- When one structure inherits from another, default field definitions can be used to instantiate the parent structure's fields based on the child structure's fields.
-- If more size specificity is required than whether a creature is large or not, a dedicated datatype describing sizes can be used together with inheritance, yielding a structure in which the {anchorName MythicalCreature}`large` field is computed from the contents of the {anchorName SizedCreature}`size` field:

当一个结构继承自另一个结构时，可以使用默认字段定义根据子结构的字段实例化父结构的字段。
如果需要比生物是否体型庞大更具体的尺寸特异性，则可以将描述尺寸的专用数据类型与继承一起使用，从而产生一个结构，其中 {anchorName MythicalCreature}`large` 字段是根据 {anchorName SizedCreature}`size` 字段的内容计算的：

```anchor SizedCreature
inductive Size where
  | small
  | medium
  | large
deriving BEq

structure SizedCreature extends MythicalCreature where
  size : Size
  large := size == Size.large
```

-- This default definition is only a default definition, however.
-- Unlike property inheritance in a language like C# or Scala, the definitions in the child structure are only used when no specific value for {anchorName MythicalCreature}`large` is provided, and nonsensical results can occur:

然而，这个默认定义只是一个默认定义。
与 C# 或 Scala 等语言中的属性继承不同，子结构中的定义仅在未提供 {anchorName MythicalCreature}`large` 的特定值时使用，并且可能出现无意义的结果：

```anchor nonsenseCreature
def nonsenseCreature : SizedCreature where
  large := false
  size := .large
```

-- If the child structure should not deviate from the parent structure, there are a few options:

如果子结构不应偏离父结构，则有以下几种选择：

--  1. Documenting the relationship, as is done for {anchorName SizedCreature}`BEq` and {anchorName MonstrousAssistantMore}`Hashable`
--  2. Defining a proposition that the fields are related appropriately, and designing the API to require evidence that the proposition is true where it matters
--  3. Not using inheritance at all

 1. 记录关系，如 {anchorName SizedCreature}`BEq` 和 {anchorName MonstrousAssistantMore}`Hashable` 所做的那样
 2. 定义一个命题，说明字段之间存在适当的关系，并设计 API 以在重要的地方要求命题为真的证据
 3. 完全不使用继承

-- The second option could look like this:

第二种选择可能如下所示：

```anchor sizesMatch
abbrev SizesMatch (sc : SizedCreature) : Prop :=
  sc.large = (sc.size == Size.large)
```

-- Note that a single equality sign is used to indicate the equality _proposition_, while a double equality sign is used to indicate a function that checks equality and returns a {anchorName MythicalCreature}`Bool`.
-- {anchorName sizesMatch}`SizesMatch` is defined as an {kw}`abbrev` because it should automatically be unfolded in proofs, so that {kw}`decide` can see the equality that should be proven.

请注意，单个等号用于表示等价__命题__，而双等号用于表示检查等价并返回 {anchorName MythicalCreature}`Bool` 的函数。
{anchorName sizesMatch}`SizesMatch` 被定义为 {kw}`abbrev`，因为它应该在证明中自动展开，以便 {kw}`decide` 可以看到应该证明的等价。

-- A _huldre_ is a medium-sized mythical creature—in fact, they are the same size as humans.
-- The two sized fields on {anchorName huldresize}`huldre` match one another:

_huldre_ 是一种中等大小的神话生物——事实上，它们与人类大小相同。
{anchorName huldresize}`huldre` 上的两个大小字段相互匹配：

```anchor huldresize
def huldre : SizedCreature where
  size := .medium

example : SizesMatch huldre := by
  decide
```

-- ## Type Class Inheritance

## 类型类继承

-- Behind the scenes, type classes are structures.
-- Defining a new type class defines a new structure, and defining an instance creates a value of that structure type.
-- They are then added to internal tables in Lean that allow it to find the instances upon request.
-- A consequence of this is that type classes may inherit from other type classes.

在幕后，类型类是结构。
定义一个新的类型类会定义一个新的结构，而定义一个实例会创建该结构类型的值。
然后它们被添加到 Lean 的内部表中，允许它在请求时找到实例。
这样做的结果是类型类可以继承自其他类型类。

-- Because it uses precisely the same language features, type class inheritance supports all the features of structure inheritance, including multiple inheritance, default implementations of parent types' methods, and automatic collapsing of diamonds.
-- This is useful in many of the same situations that multiple interface inheritance is useful in languages like Java, C# and Kotlin.
-- By carefully designing type class inheritance hierarchies, programmers can get the best of both worlds: a fine-grained collection of independently-implementable abstractions, and automatic construction of these specific abstractions from larger, more general abstractions.

因为它精确地使用了相同的语言特性，所以类型类继承支持结构继承的所有特性，包括多重继承、父类型方法的默认实现以及菱形问题的自动折叠。
这在许多与 Java、C# 和 Kotlin 等语言中的多接口继承有用的情况下都很有用。
通过仔细设计类型类继承层次结构，程序员可以两全其美：一个可独立实现的细粒度抽象集合，以及从更大、更通用的抽象自动构造这些特定抽象。
