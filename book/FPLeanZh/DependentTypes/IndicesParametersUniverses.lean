import VersoManual
import FPLeanZh.Examples

open Verso.Genre Manual
open Verso.Code.External

open FPLeanZh

set_option verso.exampleProject "../examples"
set_option verso.exampleModule "Examples.DependentTypes.IndicesParameters"

#doc (Manual) "索引、参数和宇宙级别" =>

-- The distinction between indices and parameters of an inductive type is more than just a way to describe arguments to the type that either vary or do not between the constructors.
-- Whether an argument to an inductive type is a parameter or an index also matters when it comes time to determine the relationships between their universe levels.
-- In particular, an inductive type may have the same universe level as a parameter, but it must be in a larger universe than its indices.
-- This restriction is necessary to ensure that Lean can be used as a theorem prover as well as a programming language—without it, Lean's logic would be inconsistent.
-- Experimenting with error messages is a good way to illustrate these rules, as well as the precise rules that determine whether an argument to a type is a parameter or an index.

归纳类型的索引和参数之间的区别不仅仅是描述类型参数在构造函数之间是否变化的描述方式。
归纳类型的参数是参数还是索引，在确定它们宇宙级别之间的关系时也很重要。
特别是，归纳类型可以与参数具有相同的宇宙级别，但它必须位于比其索引更大的宇宙中。
此限制是必要的，以确保 Lean 可以用作定理证明器和编程语言——没有它，Lean 的逻辑将不一致。
通过实验错误消息是说明这些规则以及确定类型参数是参数还是索引的精确规则的好方法。

-- Generally speaking, the definition of an inductive type takes its parameters before a colon and its indices after the colon.
-- Parameters are given names like function arguments, whereas indices only have their types described.
-- This can be seen in the definition of {anchorName Vect (module := Examples.DependentTypes)}`Vect`:

一般来说，归纳类型的定义在冒号前接受其参数，在冒号后接受其索引。
参数像函数参数一样被命名，而索引只描述它们的类型。
这可以在 {anchorName Vect (module := Examples.DependentTypes)}`Vect` 的定义中看到：

```anchor Vect (module := Examples.DependentTypes)
inductive Vect (α : Type u) : Nat → Type u where
   | nil : Vect α 0
   | cons : α → Vect α n → Vect α (n + 1)
```

-- In this definition, {anchorName Vect (module:=Examples.DependentTypes)}`α` is a parameter and the {anchorName Vect (module:=Examples.DependentTypes)}`Nat` is an index.
-- Parameters may be referred to throughout the definition (for example, {anchorName consNotLengthN (module:=Examples.DependentTypes)}`Vect.cons` uses {anchorName Vect (module:=Examples.DependentTypes)}`α` for the type of its first argument), but they must always be used consistently.
-- Because indices are expected to change, they are assigned individual values at each constructor, rather than being provided as arguments at the top of the datatype definition.

在此定义中，{anchorName Vect (module:=Examples.DependentTypes)}`α` 是一个参数，而 {anchorName Vect (module:=Examples.DependentTypes)}`Nat` 是一个索引。
参数可以在整个定义中引用（例如，{anchorName consNotLengthN (module:=Examples.DependentTypes)}`Vect.cons` 使用 {anchorName Vect (module:=Examples.DependentTypes)}`α` 作为其第一个参数的类型），但它们必须始终一致地使用。
因为索引预期会改变，所以它们在每个构造函数处被分配单独的值，而不是在数据类型定义的顶部作为参数提供。

-- A very simple datatype with a parameter is {anchorName WithParameter}`WithParameter`:

一个带有参数的非常简单的数据类型是 {anchorName WithParameter}`WithParameter`：

```anchor WithParameter
inductive WithParameter (α : Type u) : Type u where
  | test : α → WithParameter α
```

-- The universe level {anchorTerm WithParameter}`u` can be used for both the parameter and for the inductive type itself, illustrating that parameters do not increase the universe level of a datatype.
-- Similarly, when there are multiple parameters, the inductive type receives whichever universe level is greater:

宇宙级别 {anchorTerm WithParameter}`u` 可以用于参数和归纳类型本身，说明参数不会增加数据类型的宇宙级别。
同样，当有多个参数时，归纳类型会接收较大的宇宙级别：

```anchor WithTwoParameters
inductive WithTwoParameters (α : Type u) (β : Type v) : Type (max u v) where
  | test : α → β → WithTwoParameters α β
```

-- Because parameters do not increase the universe level of a datatype, they can be more convenient to work with.
-- Lean attempts to identify arguments that are described like indices (after the colon), but used like parameters, and turn them into parameters:
-- Both of the following inductive datatypes have their parameter written after the colon:

因为参数不会增加数据类型的宇宙级别，所以它们使用起来更方便。
Lean 尝试识别那些描述像索引（冒号后）但使用像参数的参数，并将它们转换为参数：
以下两个归纳数据类型都将其参数写在冒号之后：

```anchor WithParameterAfterColon
inductive WithParameterAfterColon : Type u → Type u where
  | test : α → WithParameterAfterColon α
```

```anchor WithParameterAfterColon2
inductive WithParameterAfterColon2 : Type u → Type u where
  | test1 : α → WithParameterAfterColon2 α
  | test2 : WithParameterAfterColon2 α
```

-- When a parameter is not named in the initial datatype declaration, different names may be used for it in each constructor, so long as they are used consistently.
-- The following declaration is accepted:

当参数在初始数据类型声明中未命名时，可以在每个构造函数中使用不同的名称，只要它们使用一致即可。
以下声明被接受：

```anchor WithParameterAfterColonDifferentNames
inductive WithParameterAfterColonDifferentNames : Type u → Type u where
  | test1 : α → WithParameterAfterColonDifferentNames α
  | test2 : β → WithParameterAfterColonDifferentNames β
```

-- However, this flexibility does not extend to datatypes that explicitly declare the names of their parameters:

然而，这种灵活性不适用于明确声明其参数名称的数据类型：

```anchor WithParameterBeforeColonDifferentNames
inductive WithParameterBeforeColonDifferentNames (α : Type u) : Type u where
  | test1 : α → WithParameterBeforeColonDifferentNames α
  | test2 : β → WithParameterBeforeColonDifferentNames β
```
```anchorError WithParameterBeforeColonDifferentNames
inductive datatype parameter mismatch
  β
expected
  α
```

-- Similarly, attempting to name an index results in an error:

同样，尝试命名索引会导致错误：

```anchor WithNamedIndex
inductive WithNamedIndex (α : Type u) : Type (u + 1) where
  | test1 : WithNamedIndex α
  | test2 : WithNamedIndex α → WithNamedIndex α → WithNamedIndex (α × α)
```
```anchorError WithNamedIndex
inductive datatype parameter mismatch
  α × α
expected
  α
```

-- Using an appropriate universe level and placing the index after the colon results in a declaration that is acceptable:

使用适当的宇宙级别并将索引放在冒号之后会导致可接受的声明：

```anchor WithIndex
inductive WithIndex : Type u → Type (u + 1) where
  | test1 : WithIndex α
  | test2 : WithIndex α → WithIndex α → WithIndex (α × α)
```

-- Even though Lean can sometimes determine that an argument after the colon in an inductive type declaration is a parameter when it is used consistently in all constructors, all parameters are still required to come before all indices.
-- Attempting to place a parameter after an index results in the argument being considered an index itself, which would require the universe level of the datatype to increase:

尽管 Lean 有时可以确定归纳类型声明中冒号后的参数在所有构造函数中一致使用时是参数，但所有参数仍然必须在所有索引之前。
尝试将参数放在索引之后会导致该参数本身被视为索引，这将需要数据类型的宇宙级别增加：

```anchor ParamAfterIndex
inductive ParamAfterIndex : Nat → Type u → Type u where
  | test1 : ParamAfterIndex 0 γ
  | test2 : ParamAfterIndex n γ → ParamAfterIndex k γ → ParamAfterIndex (n + k) γ
```
```anchorError ParamAfterIndex
invalid universe level in constructor 'ParamAfterIndex.test1', parameter 'γ' has type
  Type u
at universe level
  u+2
which is not less than or equal to the inductive type's resulting universe level
  u+1
```

-- Parameters need not be types.
-- This example shows that ordinary datatypes such as {anchorName NatParamFour}`Nat` may be used as parameters:

参数不必是类型。
此示例显示普通数据类型（例如 {anchorName NatParamFour}`Nat`）可以用作参数：

```anchor NatParamFour
inductive NatParam (n : Nat) : Nat → Type u where
  | five : NatParam 4 5
```
```anchorError NatParamFour
inductive datatype parameter mismatch
  4
expected
  n
```

-- Using the {anchorName NatParam}`n` as suggested causes the declaration to be accepted:

按照建议使用 {anchorName NatParam}`n` 会使声明被接受：

```anchor NatParam
inductive NatParam (n : Nat) : Nat → Type u where
  | five : NatParam n 5
```

-- What can be concluded from these experiments?
-- The rules of parameters and indices are as follows:
--  1. Parameters must be used identically in each constructor's type.
--  2. All parameters must come before all indices.
--  3. The universe level of the datatype being defined must be at least as large as the largest parameter, and strictly larger than the largest index.
--  4. Named arguments written before the colon are always parameters, while arguments after the colon are typically indices. Lean may determine that the usage of arguments after the colon makes them into parameters if they are used consistently in all constructors and don't come after any indices.

从这些实验中可以得出什么结论？
参数和索引的规则如下：
 1. 参数必须在每个构造函数的类型中相同地使用。
 2. 所有参数必须在所有索引之前。
 3. 所定义数据类型的宇宙级别必须至少与最大参数一样大，并且严格大于最大索引。
 4. 冒号前编写的命名参数始终是参数，而冒号后的参数通常是索引。如果冒号后的参数在所有构造函数中一致使用且不出现在任何索引之后，Lean 可能会确定它们的用法使其成为参数。

-- When in doubt, the Lean command {kw}`#print` can be used to check how many of a datatype's arguments are parameters.
-- For example, for {anchorTerm printVect}`Vect`, it points out that the number of parameters is 1:

如有疑问，可以使用 Lean 命令 {kw}`#print` 来检查数据类型有多少个参数。
例如，对于 {anchorTerm printVect}`Vect`，它指出参数的数量是 1：

```anchor printVect
#print Vect
```
```anchorInfo printVect
inductive Vect.{u} : Type u → Nat → Type u
number of parameters: 1
constructors:
Vect.nil : {α : Type u} → Vect α 0
Vect.cons : {α : Type u} → {n : Nat} → α → Vect α n → Vect α (n + 1)
```

-- It is worth thinking about which arguments should be parameters and which should be indices when choosing the order of arguments to a datatype.
-- Having as many arguments as possible be parameters helps keep universe levels under control, which can make a complicated program easier to type check.
-- One way to make this possible is to ensure that all parameters come before all indices in the argument list.

在选择数据类型参数的顺序时，值得考虑哪些参数应该是参数，哪些应该是索引。
尽可能多的参数有助于控制宇宙级别，这可以使复杂的程序更容易进行类型检查。
实现这一点的一种方法是确保所有参数在参数列表中都位于所有索引之前。

-- Additionally, even though Lean is capable of determining that arguments after the colon are nonetheless parameters by their usage, it's a good idea to write parameters with explicit names.
-- This makes the intention clear to readers, and it causes Lean to report an error if the argument is mistakenly used inconsistently across the constructors.

此外，尽管 Lean 能够通过其用法确定冒号后的参数仍然是参数，但最好使用显式名称编写参数。
这使得意图对读者来说更清晰，并且如果参数在构造函数之间被错误地不一致使用，Lean 会报告错误。
