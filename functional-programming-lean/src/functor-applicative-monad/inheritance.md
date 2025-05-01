<!--
# Structures and Inheritance
-->

# 结构体和继承 { #structures-and-inheritance }

<!--
In order to understand the full definitions of `Functor`, `Applicative`, and `Monad`, another Lean feature is necessary: structure inheritance.
Structure inheritance allows one structure type to provide the interface of another, along with additional fields.
This can be useful when modeling concepts that have a clear taxonomic relationship.
For example, take a model of mythical creatures.
Some of them are large, and some are small:
-->

为了理解 `Functor`、`Applicative` 和 `Monad` 的完整定义，另一个 Lean 的特性必不可少：结构体继承 (Structure Inheritance)。
结构体继承允许一种结构体类型提供另一种结构体类型的接口，并添加额外的属性。
这在对具有明确分类关系的概念进行建模时非常有用。
例如，以 神话生物 (Mythical Creature) 的模型为例。
其中有些很大型，有些很小型：

```lean
{{#example_decl Examples/FunctorApplicativeMonad.lean MythicalCreature}}
```

<!--
Behind the scenes, defining the `MythicalCreature` structure creates an inductive type with a single constructor called `mk`:
-->

在幕后，定义 `MythicalCreature` 结构体会创建一个具有名为 `mk` 的单一构造子的归纳类型：

```lean
{{#example_in Examples/FunctorApplicativeMonad.lean MythicalCreatureMk}}
```
```output info
{{#example_out Examples/FunctorApplicativeMonad.lean MythicalCreatureMk}}
```

<!--
Similarly, a function `MythicalCreature.large` is created that actually extracts the field from the constructor:
-->

类似地，当一个函数 `MythicalCreature.large` 被创建，它实际上从构造子中提取了属性：

```lean
{{#example_in Examples/FunctorApplicativeMonad.lean MythicalCreatureLarge}}
```
```output info
{{#example_out Examples/FunctorApplicativeMonad.lean MythicalCreatureLarge}}
```

<!--
In most old stories, each monster can be defeated in some way.
A description of a monster should include this information, along with whether it is large:
-->

在大多数古老的故事中，每个怪物都可以用某种方式被击败。
一只怪物 (Monster) 的描述应该包括以下信息，以及它是否庞大：

```lean
{{#example_decl Examples/FunctorApplicativeMonad.lean Monster}}
```

<!--
The `extends MythicalCreature` in the heading states that every monster is also mythical.
To define a `Monster`, both the fields from `MythicalCreature` and the fields from `Monster` should be provided.
A troll is a large monster that is vulnerable to sunlight:
-->

标题中的 `extends MythicalCreature` 表明每个 `Monster` 也都是 `MythicalCreature`。
要定义一个 `Monster`，其 `MythicalCreature` 的属性和 `Monster` 的属性应被同时提供。
巨魔 (Troll) 是一种对阳光敏感的大型怪物。

```lean
{{#example_decl Examples/FunctorApplicativeMonad.lean troll}}
```

<!--
Behind the scenes, inheritance is implemented using composition.
The constructor `Monster.mk` takes a `MythicalCreature` as its argument:
-->

在幕后，继承是通过组合来实现的。构造子 `Monster.mk` 将 `MythicalCreature` 作为其参数：

```lean
{{#example_in Examples/FunctorApplicativeMonad.lean MonsterMk}}
```
```output info
{{#example_out Examples/FunctorApplicativeMonad.lean MonsterMk}}
```

<!--
In addition to defining functions to extract the value of each new field, a function `{{#example_in Examples/FunctorApplicativeMonad.lean MonsterToCreature}}` is defined with type `{{#example_out Examples/FunctorApplicativeMonad.lean MonsterToCreature}}`.
This can be used to extract the underlying creature.
-->

除了定义函数来提取每个新属性的值之外，一个类型为 `{{#example_out Examples/FunctorApplicativeMonad.lean MonsterToCreature}}` 的函数 `{{#example_in Examples/FunctorApplicativeMonad.lean MonsterToCreature}}` 也被定义了。
其可以被用于提取底层的生物。

<!--
Moving up the inheritance hierarchy in Lean is not the same thing as upcasting in object-oriented languages.
An upcast operator causes a value from a derived class to be treated as an instance of the parent class, but the value retains its identity and structure.
In Lean, however, moving up the inheritance hierarchy actually erases the underlying information.
To see this in action, consider the result of evaluating `troll.toMythicalCreature`:
-->

在 Lean 的继承层级体系中逐级上升与面向对象语言中的向上转型（Upcasting）并不相同。
向上转型运算符会使派生类的值被视为父类的实例，但该值会保留其原有的特性和结构体。
然而，在 Lean 中，在继承层级体系内逐级上升实际上会擦除原有的底层信息。
要查看此操作，请看 `troll.toMythicalCreature` 的求值结果：

```lean
{{#example_in Examples/FunctorApplicativeMonad.lean evalTrollCast}}
```
```output info
{{#example_out Examples/FunctorApplicativeMonad.lean evalTrollCast}}
```

<!--
Only the fields of `MythicalCreature` remain.
-->

只有 `MythicalCreature` 的属性被保留了。

<!--
Just like the `where` syntax, curly-brace notation with field names also works with structure inheritance:
-->

如同 `where` 语法一样，使用属性名称的花括号表示法也适用于结构体继承：

```lean
{{#example_decl Examples/FunctorApplicativeMonad.lean troll2}}
```

<!--
However, the anonymous angle-bracket notation that delegates to the underlying constructor reveals the internal details:
-->

不过，委托给底层构造子的匿名尖括号表示法揭示了内部的细节：

```lean
{{#example_in Examples/FunctorApplicativeMonad.lean wrongTroll1}}
```
```output error
{{#example_out Examples/FunctorApplicativeMonad.lean wrongTroll1}}
```

<!--
An extra set of angle brackets is required, which invokes `MythicalCreature.mk` on `true`:
-->

需要额外的一对尖括号，这将对 `true` 调用 `MythicalCreature.mk`：

```lean
{{#example_decl Examples/FunctorApplicativeMonad.lean troll3}}
```

<!--
Lean's dot notation is capable of taking inheritance into account.
In other words, the existing `MythicalCreature.large` can be used with a `Monster`, and Lean automatically inserts the call to `{{#example_in Examples/FunctorApplicativeMonad.lean MonsterToCreature}}` before the call to `MythicalCreature.large`.
However, this only occurs when using dot notation, and applying the field lookup function using normal function call syntax results in a type error:
-->

Lean 的点表示法能够考虑继承。
换句话说，现有的 `MythicalCreature.large` 可以和 `Monster` 一起使用，并且 Lean 会在调用 `MythicalCreature.large` 之前自动插入对 `{{#example_in Examples/FunctorApplicativeMonad.lean MonsterToCreature}}` 的调用。
不过，这仅在使用点表示法时发生，并且使用正常的函数调用语法来应用属性查找函数会致使一个类型错误的发生：

```lean
{{#example_in Examples/FunctorApplicativeMonad.lean trollLargeNoDot}}
```
```output error
{{#example_out Examples/FunctorApplicativeMonad.lean trollLargeNoDot}}
```

<!--
Dot notation can also take inheritance into account for user-defined functions.
A small creature is one that is not large:
-->

对于用户定义函数 (User-Defined Function)，点表示法还可以考虑其继承关系。
小型生物是指那些不大的生物：

```lean
{{#example_decl Examples/FunctorApplicativeMonad.lean small}}
```

<!--
Evaluating `{{#example_in Examples/FunctorApplicativeMonad.lean smallTroll}}` yields `{{#example_out Examples/FunctorApplicativeMonad.lean smallTroll}}`, while attempting to evaluate `{{#example_in Examples/FunctorApplicativeMonad.lean smallTrollWrong}}` results in:
-->

对于 `{{#example_in Examples/FunctorApplicativeMonad.lean smallTroll}}` 的求值结果是 `{{#example_out Examples/FunctorApplicativeMonad.lean smallTroll}}`，而尝试对 `{{#example_in Examples/FunctorApplicativeMonad.lean smallTrollWrong}}` 求值则会产生以下结果：

```output error
{{#example_out Examples/FunctorApplicativeMonad.lean smallTrollWrong}}
```


<!--
### Multiple Inheritance
-->

### 多重继承 { #multiple-inheritance }

<!--
A helper is a mythical creature that can provide assistance when given the correct payment:
-->

助手是一种神话生物，当给予适当的报酬时，它就可以提供帮助。

```lean
{{#example_decl Examples/FunctorApplicativeMonad.lean Helper}}
```

<!--
For example, a _nisse_ is a kind of small elf that's known to help around the house when provided with tasty porridge:
-->

例如，**nisse** 是一种小精灵，众所周知，当给他提供美味的粥时，它就会帮忙打理家务。

```lean
{{#example_decl Examples/FunctorApplicativeMonad.lean elf}}
```

<!--
If domesticated, trolls make excellent helpers.
They are strong enough to plow a whole field in a single night, though they require model goats to keep them satisfied with their lot in life.
A monstrous assistant is a monster that is also a helper:
-->

如果巨魔被驯化，它们便会成为出色的助手。
它们强壮到可以在一个晚上耕完整片田地，尽管它们需要模型山羊来让它们对自己的生活感到满意。
怪物助手是既是怪物又是助手。

```lean
{{#example_decl Examples/FunctorApplicativeMonad.lean MonstrousAssistant}}
```

<!--
A value of this structure type must fill in all of the fields from both parent structures:
-->

这种结构体类型的值必须由两个父结构体的所有属性进行填充：

```lean
{{#example_decl Examples/FunctorApplicativeMonad.lean domesticatedTroll}}
```

<!--
Both of the parent structure types extend `MythicalCreature`.
If multiple inheritance were implemented naïvely, then this could lead to a "diamond problem", where it would be unclear which path to `large` should be taken from a given `MonstrousAssistant`.
Should it take `large` from the contained `Monster` or from the contained `Helper`?
In Lean, the answer is that the first specified path to the grandparent structure is taken, and the additional parent structures' fields are copied rather than having the new structure include both parents directly.
-->

这两种父结构体类型都扩展自 `MythicalCreature`。
如果多重继承被简单地实现，那么这可能会导致“菱形问题”，即在一个给定的 `MonstrousAssistant` 中，不清楚应该采用哪条路径来获取 `large`。
它应该从所包含的 `Monster` 还是 `Helper` 中去获取 `large` 呢？
在 Lean 中，答案是采用第一条指定到祖先结构体的路径，并且其他父结构体的属性会被复制，而不是让新的结构体直接包含两个父结构体。

<!--
This can be seen by examining the signature of the constructor for `MonstrousAssistant`:
-->

通过检验 `MonstrousAssistant` 的构造子的签名可以看到这一点。

```lean
{{#example_in Examples/FunctorApplicativeMonad.lean checkMonstrousAssistantMk}}
```
```output info
{{#example_out Examples/FunctorApplicativeMonad.lean checkMonstrousAssistantMk}}
```

<!--
It takes a `Monster` as an argument, along with the two fields that `Helper` introduces on top of `MythicalCreature`.
Similarly, while `MonstrousAssistant.toMonster` merely extracts the `Monster` from the constructor, `MonstrousAssistant.toHelper` has no `Helper` to extract.
The `#print` command exposes its implementation:
-->

它接受一个 `Monster` 作为参数，以及 `Helper` 在 `MythicalCreature` 之上引入的两个属性。
类似地，虽然 `MonstrousAssistant.toMonster` 仅仅是从构造子中提取出 `Monster`，但 `MonstrousAssistant.toHelper` 并没有 `Helper` 可以提取。
`#print` 命令展现了其实现方式：

```lean
{{#example_in Examples/FunctorApplicativeMonad.lean printMonstrousAssistantToHelper}}
```
```output info
{{#example_out Examples/FunctorApplicativeMonad.lean printMonstrousAssistantToHelper}}
```

<!--
This function constructs a `Helper` from the fields of `MonstrousAssistant`.
The `@[reducible]` attribute has the same effect as writing `abbrev`.
-->

此函数从 `MonstrousAssistant` 的属性中构造了一个 `Helper`。
`@[reducible]` 属性的作用与编写 `abbrev` 相同。


<!--
### Default Declarations
-->

### 默认声明 { #default-declarations }

<!--
When one structure inherits from another, default field definitions can be used to instantiate the parent structure's fields based on the child structure's fields.
If more size specificity is required than whether a creature is large or not, a dedicated datatype describing sizes can be used together with inheritance, yielding a structure in which the `large` field is computed from the contents of the `size` field:
-->

当一个结构体继承自另一个结构体时，可以使用默认属性定义，即基于子结构体的属性去实例化父结构体的属性。
如果需要比生物是否庞大更具体的尺寸特征，则可以结合使用描述尺寸的专用数据类型和继承机制，以此产生一个结构体，其中 `large` 属性是根据 `size` 属性的内容计算得出的：

```lean
{{#example_decl Examples/FunctorApplicativeMonad.lean SizedCreature}}
```

<!--
This default definition is only a default definition, however.
Unlike property inheritance in a language like C# or Scala, the definitions in the child structure are only used when no specific value for `large` is provided, and nonsensical results can occur:
-->

但是，这个默认定义只是一个默认定义。
与 C# 或 Scala 等语言中的属性继承不同，子结构体中的定义仅在没有提供 `large` 的具体值时才会使用，并且可能会出现无意义的结果：

```lean
{{#example_decl Examples/FunctorApplicativeMonad.lean nonsenseCreature}}
```

<!--
If the child structure should not deviate from the parent structure, there are a few options:

 1. Documenting the relationship, as is done for `BEq` and `Hashable`
 2. Defining a proposition that the fields are related appropriately, and designing the API to require evidence that the proposition is true where it matters
 3. Not using inheritance at all

The second option could look like this:
-->

如果子结构体不应偏离父结构体，则有以下几种选择：

 1. 记录其关系，如同 `BEq` 和 `Hashable` 所做的那样
 2. 定义一个属性之间适当关联的命题，并设计 API 以在需要的地方要求提供命题为真的证据
 3. 完全不使用继承

第二种选择可以如同这样：

```lean
{{#example_decl Examples/FunctorApplicativeMonad.lean sizesMatch}}
```

<!--
Note that a single equality sign is used to indicate the equality _proposition_, while a double equality sign is used to indicate a function that checks equality and returns a `Bool`.
`SizesMatch` is defined as an `abbrev` because it should automatically be unfolded in proofs, so that `simp` can see the equality that should be proven.
-->

请注意，单个等号用于表示等式 **命题** ，而双等号用于表示一个检查相等性并返回 `Bool` 的函数。
`SizesMatch` 被定义为 `abbrev`，因为它应该在证明中自动展开，以使得 `simp` 能看到需要被证明的等式。

<!--
A _huldre_ is a medium-sized mythical creature—in fact, they are the same size as humans.
The two sized fields on `huldre` match one another:
-->

**huldre** 是一种中等体型的神话生物——实际上，它们与人类的体型相同。
`huldre` 上的两个大小属性是相互匹配的：

```lean
{{#example_decl Examples/FunctorApplicativeMonad.lean huldresize}}
```

<!--
### Type Class Inheritance
-->

### 类型类继承 { #type-class-inheritance }

<!--
Behind the scenes, type classes are structures.
Defining a new type class defines a new structure, and defining an instance creates a value of that structure type.
They are then added to internal tables in Lean that allow it to find the instances upon request.
A consequence of this is that type classes may inherit from other type classes.
-->

在幕后，类型类是结构体。
定义一个新的类型类会定义一个新的结构体，而定义一个实例会创建该结构体类型的一个值。
然后，它们被添加到 Lean 的内部表中，以便 Lean 可以根据请求找到实例。
这样做的结果是类型类能够继承其他类型类。

<!--
Because it uses precisely the same language features, type class inheritance supports all the features of structure inheritance, including multiple inheritance, default implementations of parent types' methods, and automatic collapsing of diamonds.
This is useful in many of the same situations that multiple interface inheritance is useful in languages like Java, C# and Kotlin.
By carefully designing type class inheritance hierarchies, programmers can get the best of both worlds: a fine-grained collection of independently-implementable abstractions, and automatic construction of these specific abstractions from larger, more general abstractions.
-->

由于使用了完全相同的语言特性，类型类继承支持结构体继承的所有特性，包括多重继承、父类型方法的默认实现以及自动解决菱形继承问题。
这在许多情况下都很有用，就像 Java、C# 和 Kotlin 等语言中的多重接口继承。
通过精心设计类型类的继承层级体系，程序员可以兼得两方面的优势：一方面是得到一个可独立实现的抽象的精细集合，另一方面是从更大、更通用的抽象中自动构造出这些特定的抽象。