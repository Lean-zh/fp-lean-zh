import VersoManual
import FPLeanZh.Examples

open Verso.Genre Manual
open Verso Code External

open FPLeanZh

set_option verso.exampleProject "../examples"
set_option verso.exampleModule "Examples.FunctorApplicativeMonad"

#doc (Manual) "结构体和继承" =>
%%%
file := "Inheritance"
tag := "structure-inheritance"
%%%

-- Structures and Inheritance

-- In order to understand the full definitions of {anchorName ApplicativeLaws}`Functor`, {anchorName ApplicativeLaws}`Applicative`, and {anchorName ApplicativeLaws}`Monad`, another Lean feature is necessary: structure inheritance.
-- Structure inheritance allows one structure type to provide the interface of another, along with additional fields.
-- This can be useful when modeling concepts that have a clear taxonomic relationship.
-- For example, take a model of mythical creatures.
-- Some of them are large, and some are small:

为了理解 {anchorName ApplicativeLaws}`Functor`、{anchorName ApplicativeLaws}`Applicative` 和 {anchorName ApplicativeLaws}`Monad` 的完整定义，另一个 Lean 的特性必不可少：结构体继承 (Structure Inheritance)。
结构体继承允许一种结构体类型提供另一种结构体类型的接口，并添加额外的属性。
这在对具有明确分类关系的概念进行建模时非常有用。
例如，以神话生物 (Mythical Creature) 的模型为例。
其中有些很大型，有些很小型：

```anchor MythicalCreature
structure MythicalCreature where
  large : Bool
deriving Repr
```

-- Behind the scenes, defining the {anchorName MythicalCreature}`MythicalCreature` structure creates an inductive type with a single constructor called {anchorName MythicalCreatureMore}`mk`:

在幕后，定义 {anchorName MythicalCreature}`MythicalCreature` 结构体会创建一个具有名为 {anchorName MythicalCreatureMore}`mk` 的单一构造子的归纳类型：

```anchor MythicalCreatureMk
#check MythicalCreature.mk
```
```anchorInfo MythicalCreatureMk
MythicalCreature.mk (large : Bool) : MythicalCreature
```

-- Similarly, a function {anchorName MythicalCreatureLarge}`MythicalCreature.large` is created that actually extracts the field from the constructor:

类似地，当一个函数 {anchorName MythicalCreatureLarge}`MythicalCreature.large` 被创建，它实际上从构造子中提取了属性：

```anchor MythicalCreatureLarge
#check MythicalCreature.large
```
```anchorInfo MythicalCreatureLarge
MythicalCreature.large (self : MythicalCreature) : Bool
```

-- In most old stories, each monster can be defeated in some way.
-- A description of a monster should include this information, along with whether it is large:

在大多数古老的故事中，每个怪物都可以用某种方式被击败。
一只怪物 (Monster) 的描述应该包括以下信息，以及它是否庞大：

```anchor Monster
structure Monster extends MythicalCreature where
  vulnerability : String
deriving Repr
```

-- The {anchorTerm Monster}`extends MythicalCreature` in the heading states that every monster is also mythical.
-- To define a {anchorName Monster}`Monster`, both the fields from {anchorName Monster}`MythicalCreature` and the fields from {anchorName Monster}`Monster` should be provided.
-- A troll is a large monster that is vulnerable to sunlight:

标题中的 {anchorTerm Monster}`extends MythicalCreature` 表明每个怪物也都是神话生物。
要定义一个 {anchorName Monster}`Monster`，其 {anchorName Monster}`MythicalCreature` 的属性和 {anchorName Monster}`Monster` 的属性应被同时提供。
巨魔 (Troll) 是一种对阳光敏感的大型怪物：

```anchor troll
def troll : Monster where
  large := true
  vulnerability := "sunlight"
```

-- Behind the scenes, inheritance is implemented using composition.
-- The constructor {anchorName MonsterMk}`Monster.mk` takes a {anchorName Monster}`MythicalCreature` as its argument:

在幕后，继承是通过组合来实现的。
构造子 {anchorName MonsterMk}`Monster.mk` 将 {anchorName Monster}`MythicalCreature` 作为其参数：

```anchor MonsterMk
#check Monster.mk
```
```anchorInfo MonsterMk
Monster.mk (toMythicalCreature : MythicalCreature) (vulnerability : String) : Monster
```

-- In addition to defining functions to extract the value of each new field, a function {anchorTerm MonsterToCreature}`Monster.toMythicalCreature` is defined with type {anchorTerm MonsterToCreature}`Monster → MythicalCreature`.
-- This can be used to extract the underlying creature.

除了定义函数来提取每个新属性的值之外，一个类型为 {anchorTerm MonsterToCreature}`Monster → MythicalCreature` 的函数 {anchorTerm MonsterToCreature}`Monster.toMythicalCreature` 也被定义了。
其可以被用于提取底层的生物。

-- Moving up the inheritance hierarchy in Lean is not the same thing as upcasting in object-oriented languages.
-- An upcast operator causes a value from a derived class to be treated as an instance of the parent class, but the value retains its identity and structure.
-- In Lean, however, moving up the inheritance hierarchy actually erases the underlying information.
-- To see this in action, consider the result of evaluating {anchorTerm evalTrollCast}`troll.toMythicalCreature`:

在 Lean 的继承层级体系中逐级上升与面向对象语言中的向上转型（Upcasting）并不相同。
向上转型运算符会使派生类的值被视为父类的实例，但该值会保留其原有的特性和结构体。
然而，在 Lean 中，在继承层级体系内逐级上升实际上会擦除原有的底层信息。
要查看此操作，请看 {anchorTerm evalTrollCast}`troll.toMythicalCreature` 的求值结果：

```anchor evalTrollCast
#eval troll.toMythicalCreature
```
```anchorInfo evalTrollCast
{ large := true }
```

-- Only the fields of {anchorName MythicalCreature}`MythicalCreature` remain.

只有 {anchorName MythicalCreature}`MythicalCreature` 的属性被保留了。


-- Just like the {kw}`where` syntax, curly-brace notation with field names also works with structure inheritance:

如同 {kw}`where` 语法一样，使用属性名称的花括号表示法也适用于结构体继承：

```anchor troll2
def troll : Monster := {large := true, vulnerability := "sunlight"}
```

-- However, the anonymous angle-bracket notation that delegates to the underlying constructor reveals the internal details:

不过，委托给底层构造子的匿名尖括号表示法揭示了内部的细节：

```anchor wrongTroll1
def troll : Monster := ⟨true, "sunlight"⟩
```
```anchorError wrongTroll1
Application type mismatch: The argument
  true
has type
  Bool
but is expected to have type
  MythicalCreature
in the application
  Monster.mk true
```

-- An extra set of angle brackets is required, which invokes {anchorName MythicalCreatureMk}`MythicalCreature.mk` on {anchorName troll3}`true`:

需要额外的一对尖括号，这将对 {anchorName troll3}`true` 调用 {anchorName MythicalCreatureMk}`MythicalCreature.mk`：

```anchor troll3
def troll : Monster := ⟨⟨true⟩, "sunlight"⟩
```


-- Lean's dot notation is capable of taking inheritance into account.
-- In other words, the existing {anchorName trollLargeNoDot}`MythicalCreature.large` can be used with a {anchorName Monster}`Monster`, and Lean automatically inserts the call to {anchorTerm MonsterToCreature}`Monster.toMythicalCreature` before the call to {anchorName trollLargeNoDot}`MythicalCreature.large`.
-- However, this only occurs when using dot notation, and applying the field lookup function using normal function call syntax results in a type error:

Lean 的点表示法能够考虑继承。
换句话说，现有的 {anchorName trollLargeNoDot}`MythicalCreature.large` 可以和 {anchorName Monster}`Monster` 一起使用，并且 Lean 会在调用 {anchorName trollLargeNoDot}`MythicalCreature.large` 之前自动插入对 {anchorTerm MonsterToCreature}`Monster.toMythicalCreature` 的调用。
不过，这仅在使用点表示法时发生，并且使用正常的函数调用语法来应用属性查找函数会致使一个类型错误的发生：

```anchor trollLargeNoDot
#eval MythicalCreature.large troll
```
```anchorError trollLargeNoDot
Application type mismatch: The argument
  troll
has type
  Monster
but is expected to have type
  MythicalCreature
in the application
  MythicalCreature.large troll
```

-- Dot notation can also take inheritance into account for user-defined functions.
-- A small creature is one that is not large:

对于用户定义函数 (User-Defined Function)，点表示法还可以考虑其继承关系。
小型生物是指那些不大的生物：

```anchor small
def MythicalCreature.small (c : MythicalCreature) : Bool := !c.large
```

-- Evaluating {anchorTerm smallTroll}`troll.small` yields {anchorTerm smallTroll}`false`, while attempting to evaluate {anchorTerm smallTrollWrong}`MythicalCreature.small troll` results in:

对于 {anchorTerm smallTroll}`troll.small` 的求值结果是 {anchorTerm smallTroll}`false`，而尝试对 {anchorTerm smallTrollWrong}`MythicalCreature.small troll` 求值则会产生以下结果：

```anchorError smallTrollWrong
Application type mismatch: The argument
  troll
has type
  Monster
but is expected to have type
  MythicalCreature
in the application
  MythicalCreature.small troll
```

-- # Multiple Inheritance
# 多重继承
%%%
tag := "multiple-structure-inheritance"
%%%

-- A helper is a mythical creature that can provide assistance when given the correct payment:

助手是一种神话生物，当给予适当的报酬时，它就可以提供帮助：

```anchor Helper
structure Helper extends MythicalCreature where
  assistance : String
  payment : String
deriving Repr
```

-- For example, a _nisse_ is a kind of small elf that's known to help around the house when provided with tasty porridge:

例如，_nisse_ 是一种小精灵，众所周知，当给他提供美味的粥时，它就会帮忙打理家务：

```anchor elf
def nisse : Helper where
  large := false
  assistance := "household tasks"
  payment := "porridge"
```

-- If domesticated, trolls make excellent helpers.
-- They are strong enough to plow a whole field in a single night, though they require model goats to keep them satisfied with their lot in life.
-- A monstrous assistant is a monster that is also a helper:

如果巨魔被驯化，它们便会成为出色的助手。
它们强壮到可以在一个晚上耕完整片田地，尽管它们需要模型山羊来让它们对自己的生活感到满意。
怪物助手是既是怪物又是助手：

```anchor MonstrousAssistant
structure MonstrousAssistant extends Monster, Helper where
deriving Repr
```

-- A value of this structure type must fill in all of the fields from both parent structures:

这种结构体类型的值必须由两个父结构体的所有属性进行填充：

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

这两种父结构体类型都扩展自 {anchorName MythicalCreature}`MythicalCreature`。
如果多重继承被简单地实现，那么这可能会导致“菱形问题”，即在一个给定的 {anchorName MonstrousAssistant}`MonstrousAssistant` 中，不清楚应该采用哪条路径来获取 {anchorName MythicalCreature}`large`。
它应该从所包含的 {anchorName Monster}`Monster` 还是 {anchorName Helper}`Helper` 中去获取 {lit}`large` 呢？
在 Lean 中，答案是采用第一条指定到祖先结构体的路径，并且其他父结构体的属性会被复制，而不是让新的结构体直接包含两个父结构体。

-- This can be seen by examining the signature of the constructor for {anchorName MonstrousAssistant}`MonstrousAssistant`:

通过检验 {anchorName MonstrousAssistant}`MonstrousAssistant` 的构造子的签名可以看到这一点：

```anchor checkMonstrousAssistantMk
#check MonstrousAssistant.mk
```
```anchorInfo checkMonstrousAssistantMk
MonstrousAssistant.mk (toMonster : Monster) (assistance payment : String) : MonstrousAssistant
```

-- It takes a {anchorName Monster}`Monster` as an argument, along with the two fields that {anchorName Helper}`Helper` introduces on top of {anchorName MythicalCreature}`MythicalCreature`.
-- Similarly, while {anchorName MonstrousAssistantMore}`MonstrousAssistant.toMonster` merely extracts the {anchorName Monster}`Monster` from the constructor, {anchorName printMonstrousAssistantToHelper}`MonstrousAssistant.toHelper` has no {anchorName Helper}`Helper` to extract.
-- The {kw}`#print` command exposes its implementation:

它接受一个 {anchorName Monster}`Monster` 作为参数，以及 {anchorName Helper}`Helper` 在 {anchorName MythicalCreature}`MythicalCreature` 之上引入的两个属性。
类似地，虽然 {anchorName MonstrousAssistantMore}`MonstrousAssistant.toMonster` 仅仅是从构造子中提取出 {anchorName Monster}`Monster`，但 {anchorName printMonstrousAssistantToHelper}`MonstrousAssistant.toHelper` 并没有 {anchorName Helper}`Helper` 可以提取。
{kw}`#print` 命令展现了其实现方式：

```anchor printMonstrousAssistantToHelper
#print MonstrousAssistant.toHelper
```
```anchorInfo printMonstrousAssistantToHelper
@[reducible] def MonstrousAssistant.toHelper : MonstrousAssistant → Helper :=
fun self => { toMythicalCreature := self.toMythicalCreature, assistance := self.assistance, payment := self.payment }
```

-- This function constructs a {anchorName Helper}`Helper` from the fields of {anchorName MonstrousAssistant}`MonstrousAssistant`.
-- The {lit}`@[reducible]` attribute has the same effect as writing {kw}`abbrev`.

此函数从 {anchorName MonstrousAssistant}`MonstrousAssistant` 的属性中构造了一个 {anchorName Helper}`Helper`。
{lit}`@[reducible]` 属性的作用与编写 {kw}`abbrev` 相同。

-- ## Default Declarations
## 默认声明
%%%
tag := "inheritance-defaults"
%%%

-- When one structure inherits from another, default field definitions can be used to instantiate the parent structure's fields based on the child structure's fields.
-- If more size specificity is required than whether a creature is large or not, a dedicated datatype describing sizes can be used together with inheritance, yielding a structure in which the {anchorName MythicalCreature}`large` field is computed from the contents of the {anchorName SizedCreature}`size` field:

当一个结构体继承自另一个结构体时，可以使用默认属性定义，即基于子结构体的属性去实例化父结构体的属性。
如果需要比生物是否庞大更具体的尺寸特征，则可以结合使用描述尺寸的专用数据类型和继承机制，以此产生一个结构体，其中 {anchorName MythicalCreature}`large` 属性是根据 {anchorName SizedCreature}`size` 属性的内容计算得出的：

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

但是，这个默认定义只是一个默认定义。
与 C# 或 Scala 等语言中的属性继承不同，子结构体中的定义仅在没有提供 {anchorName MythicalCreature}`large` 的具体值时才会使用，并且可能会出现无意义的结果：

```anchor nonsenseCreature
def nonsenseCreature : SizedCreature where
  large := false
  size := .large
```

-- If the child structure should not deviate from the parent structure, there are a few options:

--  1. Documenting the relationship, as is done for {anchorName SizedCreature}`BEq` and {anchorName MonstrousAssistantMore}`Hashable`
--  2. Defining a proposition that the fields are related appropriately, and designing the API to require evidence that the proposition is true where it matters
--  3. Not using inheritance at all

-- The second option could look like this:

如果子结构体不应偏离父结构体，则有以下几种选择：

 1. 记录其关系，如同 {anchorName SizedCreature}`BEq` 和 {anchorName MonstrousAssistantMore}`Hashable` 所做的那样
 2. 定义一个属性之间适当关联的命题，并设计 API 以在需要的地方要求提供命题为真的证据
 3. 完全不使用继承

第二种选择可以如同这样：

```anchor sizesMatch
abbrev SizesMatch (sc : SizedCreature) : Prop :=
  sc.large = (sc.size == Size.large)
```

-- Note that a single equality sign is used to indicate the equality _proposition_, while a double equality sign is used to indicate a function that checks equality and returns a {anchorName MythicalCreature}`Bool`.
-- {anchorName sizesMatch}`SizesMatch` is defined as an {kw}`abbrev` because it should automatically be unfolded in proofs, so that {tactic}`decide` can see the equality that should be proven.

请注意，单个等号用于表示等式 _命题_ ，而双等号用于表示一个检查相等性并返回 {anchorName MythicalCreature}`Bool` 的函数。
{anchorName sizesMatch}`SizesMatch` 被定义为 {kw}`abbrev`，因为它应该在证明中自动展开，以使得 {tactic}`decide` 能看到需要被证明的等式。

-- A _huldre_ is a medium-sized mythical creature—in fact, they are the same size as humans.
-- The two sized fields on {anchorName huldresize}`huldre` match one another:

_huldre_ 是一种中等体型的神话生物——实际上，它们与人类的体型相同。
{anchorName huldresize}`huldre` 上的两个大小属性是相互匹配的：

```anchor huldresize
def huldre : SizedCreature where
  size := .medium

example : SizesMatch huldre := by
  decide
```


-- ## Type Class Inheritance
## 类型类继承
%%%
tag := "type-class-inheritance"
%%%

-- Behind the scenes, type classes are structures.
-- Defining a new type class defines a new structure, and defining an instance creates a value of that structure type.
-- They are then added to internal tables in Lean that allow it to find the instances upon request.
-- A consequence of this is that type classes may inherit from other type classes.

在幕后，类型类是结构体。
定义一个新的类型类会定义一个新的结构体，而定义一个实例会创建该结构体类型的一个值。
然后，它们被添加到 Lean 的内部表中，以便 Lean 可以根据请求找到实例。
这样做的结果是类型类能够继承其他类型类。

-- Because it uses precisely the same language features, type class inheritance supports all the features of structure inheritance, including multiple inheritance, default implementations of parent types' methods, and automatic collapsing of diamonds.
-- This is useful in many of the same situations that multiple interface inheritance is useful in languages like Java, C# and Kotlin.
-- By carefully designing type class inheritance hierarchies, programmers can get the best of both worlds: a fine-grained collection of independently-implementable abstractions, and automatic construction of these specific abstractions from larger, more general abstractions.

由于使用了完全相同的语言特性，类型类继承支持结构体继承的所有特性，包括多重继承、父类型方法的默认实现以及自动解决菱形继承问题。
这在许多情况下都很有用，就像 Java、C# 和 Kotlin 等语言中的多重接口继承。
通过精心设计类型类的继承层级体系，程序员可以兼得两方面的优势：一方面是得到一个可独立实现的抽象的精细集合，另一方面是从更大、更通用的抽象中自动构造出这些特定的抽象。
