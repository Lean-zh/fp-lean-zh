import VersoManual
import FPLeanZh.Examples

open Verso.Genre Manual
open Verso.Code.External

open FPLeanZh

set_option verso.exampleProject "../examples"
set_option verso.exampleModule "Examples.DependentTypes.IndicesParameters"

#doc (Manual) "索引、参量和宇宙层级" =>
%%%
tag := "indices-parameters-universe-levels"
file := "IndicesParametersUniverses"
%%%
-- Indices, Parameters, and Universe Levels

-- The distinction between indices and parameters of an inductive type is more than just a way to describe arguments to the type that either vary or do not between the constructors.
-- Whether an argument to an inductive type is a parameter or an index also matters when it comes time to determine the relationships between their universe levels.
-- In particular, an inductive type may have the same universe level as a parameter, but it must be in a larger universe than its indices.
-- This restriction is necessary to ensure that Lean can be used as a theorem prover as well as a programming language—without it, Lean's logic would be inconsistent.
-- Experimenting with error messages is a good way to illustrate these rules, as well as the precise rules that determine whether an argument to a type is a parameter or an index.

归纳类型的参量和索引的区别不仅仅是这些参数在构造子之间相同还是不同。
当确定宇宙层级之间的关系时，归纳类型参数是参量还是索引也很重要：
归纳类型的宇宙层级可以与参量相同，但必须比其索引更大。
这种限制是为了确保 Lean 除了作为编程语言还可以作为定理证明器——否则，Lean 的逻辑将是不一致的。
我们将通过展示不同例子输出的错误信息来阐释决定以下两者的具体规则：宇宙层级和某个参数应该被视为参量还是索引。

-- Generally speaking, the definition of an inductive type takes its parameters before a colon and its indices after the colon.
-- Parameters are given names like function arguments, whereas indices only have their types described.
-- This can be seen in the definition of {anchorName Vect (module := Examples.DependentTypes)}`Vect`:

通常来说，在归纳类型定义中出现在冒号之前的被当作参量，出现在冒号之后的被当作索引。
参量像函数参数可以给出类型和名字，而索引只能给出类型。
如 {anchorName Vect (module := Examples.DependentTypes)}`Vect` 的定义所示：

```anchor Vect (module := Examples.DependentTypes)
inductive Vect (α : Type u) : Nat → Type u where
   | nil : Vect α 0
   | cons : α → Vect α n → Vect α (n + 1)
```
-- In this definition, {anchorName Vect (module:=Examples.DependentTypes)}`α` is a parameter and the {anchorName Vect (module:=Examples.DependentTypes)}`Nat` is an index.
-- Parameters may be referred to throughout the definition (for example, {anchorName consNotLengthN (module:=Examples.DependentTypes)}`Vect.cons` uses {anchorName Vect (module:=Examples.DependentTypes)}`α` for the type of its first argument), but they must always be used consistently.
-- Because indices are expected to change, they are assigned individual values at each constructor, rather than being provided as arguments at the top of the datatype definition.

在这个定义中，{anchorName Vect (module:=Examples.DependentTypes)}`α` 是一个参量，{anchorName Vect (module:=Examples.DependentTypes)}`Nat` 是一个索引。
参量可以在整个定义中被使用（例如，{anchorName consNotLengthN (module:=Examples.DependentTypes)}`Vect.cons` 使用 {anchorName Vect (module:=Examples.DependentTypes)}`α` 作为其第一个参数的类型），但它们必须始终一致。
因为索引可能会不同，所以它们在每个构造子中被分配单独的值，而不是作为参数出现在数据类型的顶部的定义中。


-- A very simple datatype with a parameter is {anchorName WithParameter}`WithParameter`:

一个非常简单的带有参量的数据类型是 {anchorName WithParameter}`WithParameter`：

```anchor WithParameter
inductive WithParameter (α : Type u) : Type u where
  | test : α → WithParameter α
```
-- The universe level {anchorTerm WithParameter}`u` can be used for both the parameter and for the inductive type itself, illustrating that parameters do not increase the universe level of a datatype.
-- Similarly, when there are multiple parameters, the inductive type receives whichever universe level is greater:

宇宙层级 {anchorTerm WithParameter}`u` 可以用于参量和归纳类型本身，说明参量不会增加数据类型的宇宙层级。
同样，当有多个参量时，归纳类型的宇宙层级取决于这些参量的宇宙层级中最大的那个：

```anchor WithTwoParameters
inductive WithTwoParameters (α : Type u) (β : Type v) : Type (max u v) where
  | test : α → β → WithTwoParameters α β
```
-- Because parameters do not increase the universe level of a datatype, they can be more convenient to work with.
-- Lean attempts to identify arguments that are described like indices (after the colon), but used like parameters, and turn them into parameters:
-- Both of the following inductive datatypes have their parameter written after the colon:

由于参量不会增加数据类型的宇宙层级，使用它们很方便。
Lean 会尝试识别像索引一样出现在冒号之后，但像参量一样使用的参数，并将它们转换为参量：
以下两个归纳数据类型的参量都出现在冒号之后：

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

当一个参量在数据类型的声明中没有命名时，可以在每个构造子中使用不同的名称，只要它们的使用是一致的。
以下声明被接受：

```anchor WithParameterAfterColonDifferentNames
inductive WithParameterAfterColonDifferentNames : Type u → Type u where
  | test1 : α → WithParameterAfterColonDifferentNames α
  | test2 : β → WithParameterAfterColonDifferentNames β
```
-- However, this flexibility does not extend to datatypes that explicitly declare the names of their parameters:

然而，当参量的命名被指定时，这种灵活性就不被允许了：

```anchor WithParameterBeforeColonDifferentNames
inductive WithParameterBeforeColonDifferentNames (α : Type u) : Type u where
  | test1 : α → WithParameterBeforeColonDifferentNames α
  | test2 : β → WithParameterBeforeColonDifferentNames β
```
```anchorError WithParameterBeforeColonDifferentNames
Mismatched inductive type parameter in
  WithParameterBeforeColonDifferentNames β
The provided argument
  β
is not definitionally equal to the expected parameter
  α

Note: The value of parameter 'α' must be fixed throughout the inductive declaration. Consider making this parameter an index if it must vary.
```
-- Similarly, attempting to name an index results in an error:

类似的，尝试命名一个索引会导致错误：

```anchor WithNamedIndex
inductive WithNamedIndex (α : Type u) : Type (u + 1) where
  | test1 : WithNamedIndex α
  | test2 : WithNamedIndex α → WithNamedIndex α → WithNamedIndex (α × α)
```
```anchorError WithNamedIndex
Mismatched inductive type parameter in
  WithNamedIndex (α × α)
The provided argument
  α × α
is not definitionally equal to the expected parameter
  α

Note: The value of parameter 'α' must be fixed throughout the inductive declaration. Consider making this parameter an index if it must vary.
```

-- Using an appropriate universe level and placing the index after the colon results in a declaration that is acceptable:

使用适当的宇宙层级并将索引放在冒号之后会导致一个可接受的声明：

```anchor WithIndex
inductive WithIndex : Type u → Type (u + 1) where
  | test1 : WithIndex α
  | test2 : WithIndex α → WithIndex α → WithIndex (α × α)
```


-- Even though Lean can sometimes determine that an argument after the colon in an inductive type declaration is a parameter when it is used consistently in all constructors, all parameters are still required to come before all indices.
-- Attempting to place a parameter after an index results in the argument being considered an index itself, which would require the universe level of the datatype to increase:

虽然 Lean 有时（即，在确定一个参数在所有构造子中的使用一致时）可以确定冒号后的参数是一个参量，但所有参量仍然需要出现在所有索引之前。
试图在索引之后放置一个参量会导致该参量被视为一个索引，进而导致数据类型的宇宙层级必须增加：

```anchor ParamAfterIndex
inductive ParamAfterIndex : Nat → Type u → Type u where
  | test1 : ParamAfterIndex 0 γ
  | test2 : ParamAfterIndex n γ → ParamAfterIndex k γ → ParamAfterIndex (n + k) γ
```
```anchorError ParamAfterIndex
Invalid universe level in constructor `ParamAfterIndex.test1`: Parameter `γ` has type
  Type u
at universe level
  u+2
which is not less than or equal to the inductive type's resulting universe level
  u+1
```

-- Parameters need not be types.
-- This example shows that ordinary datatypes such as {anchorName NatParamFour}`Nat` may be used as parameters:

参量不必是类型。这个例子显示了普通数据类型，如 {anchorName NatParamFour}`Nat` 也可以被用作参量：

```anchor NatParamFour
inductive NatParam (n : Nat) : Nat → Type u where
  | five : NatParam 4 5
```
```anchorError NatParamFour
Mismatched inductive type parameter in
  NatParam 4 5
The provided argument
  4
is not definitionally equal to the expected parameter
  n

Note: The value of parameter 'n' must be fixed throughout the inductive declaration. Consider making this parameter an index if it must vary.
```
-- Using the {anchorName NatParam}`n` as suggested causes the declaration to be accepted:

按照错误信息的提示将 {anchorName NatParam}`n` 改成 `n` 会导致声明被接受：

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

从以上结果中可以总结出什么？
参量和索引的规则如下：
 1. 参量在每个构造子的类型中的使用方式必须相同。
 2. 所有参量必须在所有索引之前。
 3. 正在定义的数据类型的宇宙层级必须至少与最大的参量宇宙层级一样大，并严格大于最大的索引宇宙层级。
 4. 冒号前写的命名参数始终是参量，而冒号后的参数通常是索引。如果 Lean 发现冒号后的参数在所有构造子中使用一致且不在任何索引之后，则可能能够将这个参数视为参量。

-- When in doubt, the Lean command {kw}`#print` can be used to check how many of a datatype's arguments are parameters.
-- For example, for {anchorTerm printVect}`Vect`, it points out that the number of parameters is 1:

当不确定时，可以使用 Lean 命令 {kw}`#print` 来检查数据类型参数中的多少是参量。
例如，对于 {anchorTerm printVect}`Vect`，它指出参量的数量是 1：

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

在选择数据类型的参数顺序时，应当考虑哪些参数应该是参量，哪些应该是索引。
尽可能多地将参数作为参量有助于保持一个可控的宇宙层级，从而使复杂的程序的类型检查更容易进行。
一种可能方法是确保参数列表中所有参量出现在所有索引之前。

-- Additionally, even though Lean is capable of determining that arguments after the colon are nonetheless parameters by their usage, it's a good idea to write parameters with explicit names.
-- This makes the intention clear to readers, and it causes Lean to report an error if the argument is mistakenly used inconsistently across the constructors.

同时，尽管 Lean 有时可以确定冒号后的参数仍然是参量，但最好使用显式命名编写参量。
这使读者清晰的明白意图，并且 Lean 在这个参量在构造子之间有不一致的使用时会报告错误。
