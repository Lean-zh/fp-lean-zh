import VersoManual
import FPLeanZh.Examples

open Verso.Genre Manual
open Verso.Code.External

open FPLeanZh

set_option verso.exampleProject "../examples"
set_option verso.exampleModule "Examples.DependentTypes"


#doc (Manual) "索引族" =>
%%%
file := "IndexedFamilies"
tag := "indexed-families"
%%%
-- Indexed Families

-- Polymorphic inductive types take type arguments.
-- For instance, {moduleName}`List` takes an argument that determines the type of the entries in the list, and {moduleName}`Except` takes arguments that determine the types of the exceptions or values.
-- These type arguments, which are the same in every constructor of the datatype, are referred to as _parameters_.

多态归纳类型接受类型参数。
例如，{moduleName}`List` 接受一个类型参数以决定列表中条目的类型，而 {moduleName}`Except` 接受两个类型参数以决定异常或值的类型。
这些在数据类型的每个构造子中都一致的类型参数，被称为 _参量_（parameters）。

-- Arguments to inductive types need not be the same in every constructor, however.
-- Inductive types in which the arguments to the type vary based on the choice of constructor are called _indexed families_, and the arguments that vary are referred to as _indices_.
-- The “hello world” of indexed families is a type of lists that contains the length of the list in addition to the type of entries, conventionally referred to as “vectors”:

然而，归纳类型中每个构造子的接受的类型参数并不一定要相同。
这种不同构造子可以接受不同类型作为参数的归纳类型被称为 _索引族_（indexed families），而这些不同的参数被称为 _索引_（indices）。
索引族最为人熟知的例子是“向量”（vectors）类型：这个类型类似列表类型，但它除了包含列表中元素的类型，还包含列表的长度。这种类型在 Lean 中的定义如下：

```anchor Vect
inductive Vect (α : Type u) : Nat → Type u where
   | nil : Vect α 0
   | cons : α → Vect α n → Vect α (n + 1)
```

-- The type of a vector of three {anchorName vect3}`String`s includes the fact that it contains three {anchorName vect3}`String`s:

一个包含三个 {anchorName vect3}`String` 的向量的类型包含了它有三个 {anchorName vect3}`String` 这一事实：

```anchor vect3
example : Vect String 3 :=
  .cons "one" (.cons "two" (.cons "three" .nil))
```


-- Function declarations may take some arguments before the colon, indicating that they are available in the entire definition, and some arguments after, indicating a desire to pattern-match on them and define the function case by case.
-- Inductive datatypes have a similar principle: the argument {anchorName Vect}`α` is named at the top of the datatype declaration, prior to the colon, which indicates that it is a parameter that must be provided as the first argument in all occurrences of {anchorName Vect}`Vect` in the definition, while the {anchorName Vect}`Nat` argument occurs after the colon, indicating that it is an index that may vary.
-- Indeed, the three occurrences of {anchorName Vect}`Vect` in the {anchorName Vect}`nil` and {anchorName Vect}`cons` constructor declarations consistently provide {anchorName Vect}`α` as the first argument, while the second argument is different in each case.

函数声明可以在冒号之前接受一些参数，表示这些参数在整个定义中都是可用的，也可以在冒号之后接受一些参数，函数会对它们进行模式匹配，并根据不同情形定义不同的函数体。
归纳数据类型也有类似的原则：以 {anchorName Vect}`Vect` 为例，在其顶部的数据类型声明中，参数 {anchorName Vect}`α` 出现在冒号之前，表示它是一个必须提供的参量，而在冒号之后出现的 {anchorName Vect}`Nat` 参数表示它是一个索引，（在不同的构造子中）可以变化。
事实上，在 {anchorName Vect}`nil` 和 {anchorName Vect}`cons` 构造子的声明中，三个出现 {anchorName Vect}`Vect` 的地方都将 {anchorName Vect}`α` 作为第一个参数提供，而第二个参数在每种情形下都不同。



-- The declaration of {anchorName Vect}`nil` states that it is a constructor of type {anchorTerm Vect}`Vect α 0`.
-- This means that using {anchorName nilNotLengthThree}`Vect.nil` in a context expecting a {anchorTerm nilNotLengthThree}`Vect String 3` is a type error, just as {anchorTerm otherEx}`[1, 2, 3]` is a type error in a context that expects a {anchorTerm otherEx}`List String`:

{anchorName Vect}`nil` 构造子的声明表明它的类型是 {anchorTerm Vect}`Vect α 0`。
这意味着在期望 {anchorTerm nilNotLengthThree}`Vect String 3` 的上下文中使用 {anchorName nilNotLengthThree}`Vect.nil` 会导致类型错误，就像在期望 {anchorTerm otherEx}`List String` 的上下文中使用 {anchorTerm otherEx}`[1, 2, 3]` 一样：

```anchor nilNotLengthThree
example : Vect String 3 := Vect.nil
```
```anchorError nilNotLengthThree
Type mismatch
  Vect.nil
has type
  Vect ?m.3 0
but is expected to have type
  Vect String 3
```
-- The mismatch between {anchorTerm Vect}`0` and {anchorTerm nilNotLengthThree}`3` in this example plays exactly the same role as any other type mismatch, even though {anchorTerm Vect}`0` and {anchorTerm nilNotLengthThree}`3` are not themselves types.
-- The metavariable in the message can be ignored because its presence indicates that {anchorName otherEx}`Vect.nil` can have any element type.

在这个例子中，{anchorTerm Vect}`0` 和 {anchorTerm nilNotLengthThree}`3` 之间的不匹配和其他例子中类型的不匹配是一模一样的情况，尽管 {anchorTerm Vect}`0` 和 {anchorTerm nilNotLengthThree}`3` 本身并不是类型。
消息中的元变量可以忽略，因为它的存在表明 {anchorName otherEx}`Vect.nil` 可以具有任何元素类型。

-- Indexed families are called _families_ of types because different index values can make different constructors available for use.
-- In some sense, an indexed family is not a type; rather, it is a collection of related types, and the choice of index values also chooses a type from the collection.
-- Choosing the index {anchorTerm otherEx}`5` for {anchorName Vect}`Vect` means that only the constructor {anchorName Vect}`cons` is available, and choosing the index {anchorTerm Vect}`0` means that only {anchorName Vect}`nil` is available.

索引族被称为类型的 _族_（families），因为不同的索引值意味着可以使用的构造子不同。
在某种意义上，一个索引族并不是一个类型；它更像是一组相关的类型的集合，不同索引的值对应了这个集合中的一个类型。
选择索引 {anchorTerm otherEx}`5` 作为 {anchorName Vect}`Vect` 的索引意味着只有 {anchorName Vect}`cons` 构造子可用，而选择索引 {anchorTerm Vect}`0` 意味着只有 {anchorName Vect}`nil` 构造子可用。

-- If the index is not yet known (e.g. because it is a variable), then no constructor can be used until it becomes known.
-- Using {anchorName nilNotLengthN}`n` for the length allows neither {anchorName otherEx}`Vect.nil` nor {anchorName consNotLengthN}`Vect.cons`, because there's no way to know whether the variable {anchorName nilNotLengthN}`n` should stand for a {anchorName Vect}`Nat` that matches {anchorTerm Vect}`0` or {anchorTerm Vect}`n + 1`:

如果索引是一个未知的量（例如，一个变量），那么在它变得已知之前，任何构造子都不能被使用。
如果一个 {anchorName Vect}`Vect` 的长度为 {anchorName nilNotLengthN}`n`，那么 {anchorName otherEx}`Vect.nil` 和 {anchorName consNotLengthN}`Vect.cons` 都无法被用来构造这个类型，因为无法知道变量 {anchorName nilNotLengthN}`n` 作为一个 {anchorName Vect}`Nat` 应该匹配 {anchorTerm Vect}`0` 或 {anchorTerm Vect}`n + 1`：

```anchor nilNotLengthN
example : Vect String n := Vect.nil
```
```anchorError nilNotLengthN
Type mismatch
  Vect.nil
has type
  Vect ?m.2 0
but is expected to have type
  Vect String n
```
```anchor consNotLengthN
example : Vect String n := Vect.cons "Hello" (Vect.cons "world" Vect.nil)
```
```anchorError consNotLengthN
Type mismatch
  Vect.cons "Hello" (Vect.cons "world" Vect.nil)
has type
  Vect String (0 + 1 + 1)
but is expected to have type
  Vect String n
```

-- Having the length of the list as part of its type means that the type becomes more informative.
-- For example, {anchorName replicateStart}`Vect.replicate` is a function that creates a {anchorName replicateStart}`Vect` with a number of copies of a given value.
-- The type that says this precisely is:

让列表的长度作为类型的一部分意味着类型具有更多的信息。
例如 {anchorName replicateStart}`Vect.replicate` 是一个创建包含某个值的特定份数副本的 {anchorName replicateStart}`Vect` 的函数。
可以精确地表示这一点的类型是：

```anchor replicateStart
def Vect.replicate (n : Nat) (x : α) : Vect α n := _
```
-- The argument {anchorName replicateStart}`n` appears as the length of the result.
-- The message associated with the underscore placeholder describes the task at hand:

参数 {anchorName replicateStart}`n` 出现在结果的类型的长度中。
以下消息描述了下划线占位符对应的任务：

```anchorError replicateStart
don't know how to synthesize placeholder
context:
α : Type u_1
n : Nat
x : α
⊢ Vect α n
```

-- When working with indexed families, constructors can only be applied when Lean can see that the constructor's index matches the index in the expected type.
-- However, neither constructor has an index that matches {anchorName replicateStart}`n`—{anchorName Vect}`nil` matches {anchorName otherEx}`Nat.zero`, and {anchorName Vect}`cons` matches {anchorName otherEx}`Nat.succ`.
-- Just as in the example type errors, the variable {anchorName Vect}`n` could stand for either, depending on which {anchorName Vect}`Nat` is provided to the function as an argument.
-- The solution is to use pattern matching to consider both of the possible cases:

当编写使用索引族的程序时时，只有当 Lean 能够确定构造子的索引与期望类型中的索引匹配时，才能使用该构造子。
然而，两个构造子的索引与 {anchorName replicateStart}`n` 均不匹配——{anchorName Vect}`nil` 匹配 {anchorName otherEx}`Nat.zero`，而 {anchorName Vect}`cons` 匹配 {anchorName otherEx}`Nat.succ`。
就像在上面的类型错误示例中的情况一样，变量 {anchorName Vect}`n` 可能代表其中一个，取决于具体调用函数时 {anchorName Vect}`Nat` 参数的值。
解决这一问题的方案是利用模式匹配来同时考虑两种情形：

```anchor replicateMatchOne
def Vect.replicate (n : Nat) (x : α) : Vect α n :=
  match n with
  | 0 => _
  | k + 1 => _
```
-- Because {anchorName replicateStart}`n` occurs in the expected type, pattern matching on {anchorName replicateStart}`n` _refines_ the expected type in the two cases of the match.
-- In the first underscore, the expected type has become {lit}`Vect α 0`:

因为 {anchorName replicateStart}`n` 出现在期望的类型中，对 {anchorName replicateStart}`n` 进行模式匹配会在匹配的两种情形下 _细化_（refine）期望的类型。
在第一个下划线中，期望的类型变成了 {lit}`Vect α 0`：

```anchorError replicateMatchOne
don't know how to synthesize placeholder
context:
α : Type u_1
n : Nat
x : α
⊢ Vect α 0
```
-- In the second underscore, it has become {lit}`Vect α (k + 1)`:

在第二个下划线中，它变成了 {lit}`Vect α (k + 1)`：

```anchorError replicateMatchTwo
don't know how to synthesize placeholder
context:
α : Type u_1
n : Nat
x : α
k : Nat
⊢ Vect α (k + 1)
```
-- When pattern matching refines the type of a program in addition to discovering the structure of a value, it is called _dependent pattern matching_.

当模式匹配不仅发现值的结构，还细化程序的类型时，这种模式匹配被称为 _依值模式匹配_（dependent pattern matching）。

-- The refined type makes it possible to apply the constructors.
-- The first underscore matches {anchorName otherEx}`Vect.nil`, and the second matches {anchorName consNotLengthN}`Vect.cons`:

细化后的类型允许我们使用对应的构造子。
第一个下划线匹配 {anchorName otherEx}`Vect.nil`，而第二个下划线匹配 {anchorName consNotLengthN}`Vect.cons`：

```anchor replicateMatchFour
def Vect.replicate (n : Nat) (x : α) : Vect α n :=
  match n with
  | 0 => .nil
  | k + 1 => .cons _ _
```
-- The first underscore under the {anchorName replicateMatchFour}`.cons` should have type {anchorName replicateMatchFour}`α`.
-- There is an {anchorName replicateMatchFour}`α` available, namely {anchorName replicateMatchFour}`x`:

{anchorName replicateMatchFour}`.cons` 下的第一个下划线应该是一个具有类型 {anchorName replicateMatchFour}`α` 的值。
恰好我们有这么一个值：{anchorName replicateMatchFour}`x`。

```anchorError replicateMatchFour
don't know how to synthesize placeholder
context:
α : Type u_1
n : Nat
x : α
k : Nat
⊢ α
```
-- The second underscore should be a {lit}`Vect α k`, which can be produced by a recursive call to {anchorName replicate}`replicate`:

第二个下划线应该是一个具有类型 {lit}`Vect α k` 的值。这个值可以通过对 {anchorName replicate}`replicate` 的递归调用产生：

```anchorError replicateMatchFive
don't know how to synthesize placeholder
context:
α : Type u_1
n : Nat
x : α
k : Nat
⊢ Vect α k
```
-- Here is the final definition of {anchorName replicate}`replicate`:

下面是 {anchorName replicate}`replicate` 的最终定义：

```anchor replicate
def Vect.replicate (n : Nat) (x : α) : Vect α n :=
  match n with
  | 0 => .nil
  | k + 1 => .cons x (replicate k x)
```

-- In addition to providing assistance while writing the function, the informative type of {anchorName replicate}`Vect.replicate` also allows client code to rule out a number of unexpected functions without having to read the source code.
-- A version of {anchorName listReplicate}`replicate` for lists could produce a list of the wrong length:

除了在编写函数时提供帮助之外，{anchorName replicate}`Vect.replicate` 的类型信息还允许调用方不必阅读源代码就明白它一定不是某些错误的实现。
一个可能会产生错误长度的列表的 {anchorName listReplicate}`replicate` 实现如下：

```anchor listReplicate
def List.replicate (n : Nat) (x : α) : List α :=
  match n with
  | 0 => []
  | k + 1 => x :: x :: replicate k x
```
-- However, making this mistake with {anchorName replicateOops}`Vect.replicate` is a type error:

然而，在实现 {anchorName replicateOops}`Vect.replicate` 时犯下同样的错误会引发一个类型错误：

```anchor replicateOops
def Vect.replicate (n : Nat) (x : α) : Vect α n :=
  match n with
  | 0 => .nil
  | k + 1 => .cons x (.cons x (replicate k x))
```
```anchorError replicateOops
Application type mismatch: The argument
  cons x (replicate k x)
has type
  Vect α (k + 1)
but is expected to have type
  Vect α k
in the application
  cons x (cons x (replicate k x))
```


-- The function {anchorName otherEx}`List.zip` combines two lists by pairing the first entry in the first list with the first entry in the second list, the second entry in the first list with the second entry in the second list, and so forth.
-- {anchorName otherEx}`List.zip` can be used to pair the three highest peaks in the US state of Oregon with the three highest peaks in Denmark:

{anchorName otherEx}`List.zip` 函数通过将两个列表中对应的项配对（第一个列表中的第一项和第二个列表的第一项，第一个列表中的第二项和第二个列表的第二项, ……）来合并两个列表。
这个函数可以用来将一个包含美国俄勒冈州前三座最高峰的列表和一个包含丹麦前三座最高峰的列表合并：

```anchorTerm zip1
["Mount Hood",
 "Mount Jefferson",
 "South Sister"].zip ["Møllehøj", "Yding Skovhøj", "Ejer Bavnehøj"]
```
-- The result is a list of three pairs:

结果是一个含有三个有序对的列表：

```anchorTerm zip1
[("Mount Hood", "Møllehøj"),
 ("Mount Jefferson", "Yding Skovhøj"),
 ("South Sister", "Ejer Bavnehøj")]
```
-- It's somewhat unclear what should happen when the lists have different lengths.
-- Like many languages, Lean chooses to ignore the extra entries in one of the lists.
-- For instance, combining the heights of the five highest peaks in Oregon with those of the three highest peaks in Denmark yields three pairs.
-- In particular,

当列表的长度不同时，结果应该如何呢？
与许多其他语言一样，Lean 选择忽略长的列表中的额外条目。
例如，将一个具有俄勒冈州前五座最高峰的高度的列表与一个具有丹麦前三座最高峰的高度的列表合并会产生一个含有三个有序对的列表。
特别地，

```anchorTerm zip2
[3428.8, 3201, 3158.5, 3075, 3064].zip [170.86, 170.77, 170.35]
```
-- evaluates to

求值结果为

```anchorTerm zip2
[(3428.8, 170.86), (3201, 170.77), (3158.5, 170.35)]
```

-- While this approach is convenient because it always returns an answer, it runs the risk of throwing away data when the lists unintentionally have different lengths.
-- F# takes a different approach: its version of {fsharp}`List.zip` throws an exception when the lengths don't match, as can be seen in this {lit}`fsi` session:

这个函数总是返回一个结果，所以它非常易用。但当输入的两个列表意外地具有不同的长度时，一些数据会被悄悄地丢弃。
F# 采用了不同的方法：它的 {fsharp}`List.zip` 函数在两个列表长度不匹配时抛出异常，如下面 {lit}`fsi` 会话中展示的那样：

```fsharp
> List.zip [3428.8; 3201.0; 3158.5; 3075.0; 3064.0] [170.86; 170.77; 170.35];;
```
```fsharpError
System.ArgumentException: The lists had different lengths.
list2 is 2 elements shorter than list1 (Parameter 'list2')
   at Microsoft.FSharp.Core.DetailedExceptions.invalidArgDifferentListLength[?](String arg1, String arg2, Int32 diff) in /builddir/build/BUILD/dotnet-v3.1.424-SDK/src/fsharp.3ef6f0b514198c0bfa6c2c09fefe41a740b024d5/src/fsharp/FSharp.Core/local.fs:line 24
   at Microsoft.FSharp.Primitives.Basics.List.zipToFreshConsTail[a,b](FSharpList`1 cons, FSharpList`1 xs1, FSharpList`1 xs2) in /builddir/build/BUILD/dotnet-v3.1.424-SDK/src/fsharp.3ef6f0b514198c0bfa6c2c09fefe41a740b024d5/src/fsharp/FSharp.Core/local.fs:line 918
   at Microsoft.FSharp.Primitives.Basics.List.zip[T1,T2](FSharpList`1 xs1, FSharpList`1 xs2) in /builddir/build/BUILD/dotnet-v3.1.424-SDK/src/fsharp.3ef6f0b514198c0bfa6c2c09fefe41a740b024d5/src/fsharp/FSharp.Core/local.fs:line 929
   at Microsoft.FSharp.Collections.ListModule.Zip[T1,T2](FSharpList`1 list1, FSharpList`1 list2) in /builddir/build/BUILD/dotnet-v3.1.424-SDK/src/fsharp.3ef6f0b514198c0bfa6c2c09fefe41a740b024d5/src/fsharp/FSharp.Core/list.fs:line 466
   at <StartupCode$FSI_0006>.$FSI_0006.main@()
Stopped due to error
```
-- This avoids accidentally discarding information, but crashing a program comes with its own difficulties.
-- The Lean equivalent, which would use the {anchorName otherEx}`Option` or {anchorName otherEx}`Except` monads, would introduce a burden that may not be worth the safety.

这种方法避免了数据的意外丢失，但一个输入不正确时直接崩溃的程序并不容易使用。
在 Lean 中相似的实现可以在返回值中使用 {anchorName otherEx}`Option` 或 {anchorName otherEx}`Except` 单子，但是为了避免（可能不大的）数据丢失的风险而引入额外的（操作单子的）编程负担又并不太值得。

-- Using {anchorName Vect}`Vect`, however, it is possible to write a version of {anchorName VectZip}`zip` with a type that requires that both arguments have the same length:

然而，如果使用 {anchorName Vect}`Vect`，可以一个 {anchorName VectZip}`zip` 函数，其类型要求两个输入的列表一定具有相同的长度，如下所示：

```anchor VectZip
def Vect.zip : Vect α n → Vect β n → Vect (α × β) n
  | .nil, .nil => .nil
  | .cons x xs, .cons y ys => .cons (x, y) (zip xs ys)
```

-- This definition only has patterns for the cases where either both arguments are {anchorName otherEx}`Vect.nil` or both arguments are {anchorName consNotLengthN}`Vect.cons`, and Lean accepts the definition without a “missing cases” error like the one that results from a similar definition for {anchorName otherEx}`List`:

这个定义只需要考虑两个参数都是 {anchorName otherEx}`Vect.nil` 或都是 {anchorName consNotLengthN}`Vect.cons` 的情形。Lean 接受这个定义，而不会像 {anchorName otherEx}`List` 的类似定义那样产生一个“存在缺失情形”的错误：

```anchor zipMissing
def List.zip : List α → List β → List (α × β)
  | [], [] => []
  | x :: xs, y :: ys => (x, y) :: zip xs ys
```
```anchorError zipMissing
Missing cases:
(List.cons _ _), []
[], (List.cons _ _)
```

-- This is because the constructor used in the first pattern, {anchorName Vect}`nil` or {anchorName Vect}`cons`, _refines_ the type checker's knowledge about the length {anchorName VectZip}`n`.
-- When the first pattern is {anchorName Vect}`nil`, the type checker can additionally determine that the length was {anchorTerm VectZipLen}`0`, so the only possible choice for the second pattern is {anchorName Vect}`nil`.
-- Similarly, when the first pattern is {anchorName Vect}`cons`, the type checker can determine that the length was {anchorTerm VectZipLen}`k+1` for some {anchorName VectZipLen}`Nat` {anchorName VectZipLen}`k`, so the only possible choice for the second pattern is {anchorName Vect}`cons`.
-- Indeed, adding a case that uses {anchorName Vect}`nil` and {anchorName Vect}`cons` together is a type error, because the lengths don't match:

这是因为第一个模式匹配中得到的两个构造子，{anchorName Vect}`nil` 和 {anchorName Vect}`cons`，_细化_ 了类型检查器对长度 {anchorName VectZip}`n` 的知识。
当它是 {anchorName Vect}`nil` 时，类型检查器还可以确定长度是 {anchorTerm VectZipLen}`0`，因此第二个模式的唯一可能选择是 {anchorName Vect}`nil`。
当它是 {anchorName Vect}`cons` 时，类型检查器可以确定长度是 {anchorTerm VectZipLen}`k+1`，因此第二个模式的唯一可能选择是 {anchorName Vect}`cons`。
事实上，添加一个同时使用 {anchorName Vect}`nil` 和 {anchorName Vect}`cons` 的情形会导致类型错误，因为长度不匹配：

```anchor zipExtraCons
def Vect.zip : Vect α n → Vect β n → Vect (α × β) n
  | .nil, .nil => .nil
  | .nil, .cons y ys => .nil
  | .cons x xs, .cons y ys => .cons (x, y) (zip xs ys)
```
```anchorError zipExtraCons
Type mismatch
  Vect.cons y ys
has type
  Vect ?m.10 (?m.16 + 1)
but is expected to have type
  Vect β 0
```
-- The refinement of the length can be observed by making {anchorName VectZipLen}`n` into an explicit argument:

长度的细化可以通过将 {anchorName VectZipLen}`n` 变成一个显式参数来观察：

```anchor VectZipLen
def Vect.zip : (n : Nat) → Vect α n → Vect β n → Vect (α × β) n
  | 0, .nil, .nil => .nil
  | k + 1, .cons x xs, .cons y ys => .cons (x, y) (zip k xs ys)
```

-- # Exercises
# 练习
%%%
tag := "indexed-families-exercises"
%%%


-- Getting a feel for programming with dependent types requires experience, and the exercises in this section are very important.
-- For each exercise, try to see which mistakes the type checker can catch, and which ones it can't, by experimenting with the code as you go.
-- This is also a good way to develop a feel for the error messages.

熟悉使用依值类型编程需要经验，本节的练习非常重要。
对于每个练习，尝试看看类型检查器可以捕捉到哪些错误，哪些错误它无法捕捉。
请通过实验代码来进行尝试。 这也是培养理解错误信息能力的好方法。

--  * Double-check that {anchorName VectZip}`Vect.zip` gives the right answer when combining the three highest peaks in Oregon with the three highest peaks in Denmark.
--    Because {anchorName Vect}`Vect` doesn't have the syntactic sugar that {anchorName otherEx}`List` has, it can be helpful to begin by defining {anchorTerm exerciseDefs}`oregonianPeaks : Vect String 3` and {anchorTerm exerciseDefs}`danishPeaks : Vect String 3`.

 * 仔细检查 {anchorName VectZip}`Vect.zip` 在将俄勒冈州的三座最高峰与丹麦的三座最高峰组合时是否给出了正确的答案。
   由于 {anchorName Vect}`Vect` 没有 {anchorName otherEx}`List` 那样的语法糖，因此最好从定义 {anchorTerm exerciseDefs}`oregonianPeaks : Vect String 3` 和 {anchorTerm exerciseDefs}`danishPeaks : Vect String 3` 开始。

--  * Define a function {anchorName exerciseDefs}`Vect.map` with type {anchorTerm exerciseDefs}`(α → β) → Vect α n → Vect β n`.

 * 定义一个函数 {anchorName exerciseDefs}`Vect.map`。它的类型为 {anchorTerm exerciseDefs}`(α → β) → Vect α n → Vect β n`。

--  * Define a function {anchorName exerciseDefs}`Vect.zipWith` that combines the entries in a {anchorName Vect}`Vect` one at a time with a function.
--    It should have the type {anchorTerm exerciseDefs}`(α → β → γ) → Vect α n → Vect β n → Vect γ n`.

 * 定义一个函数 {anchorName exerciseDefs}`Vect.zipWith`，它将一个接受两个参数的函数依次作用在两个 {anchorName Vect}`Vect` 中的每一项上。
   它的类型应该是 {anchorTerm exerciseDefs}`(α → β → γ) → Vect α n → Vect β n → Vect γ n`。

--  * Define a function {anchorName exerciseDefs}`Vect.unzip` that splits a {anchorName Vect}`Vect` of pairs into a pair of {anchorName Vect}`Vect`s. It should have the type {anchorTerm exerciseDefs}`Vect (α × β) n → Vect α n × Vect β n`.

 * 定义一个函数 {anchorName exerciseDefs}`Vect.unzip`，它将一个包含有序对的 {anchorName Vect}`Vect` 分割成两个 {anchorName Vect}`Vect`。它的类型应该是 {anchorTerm exerciseDefs}`Vect (α × β) n → Vect α n × Vect β n`。

--  * Define a function {anchorName exerciseDefs}`Vect.push` that adds an entry to the _end_ of a {anchorName Vect}`Vect`. Its type should be {anchorTerm exerciseDefs}`Vect α n → α → Vect α (n + 1)` and {anchorTerm snocSnowy}`#eval Vect.push (.cons "snowy" .nil) "peaks"` should yield {anchorInfo snocSnowy}`Vect.cons "snowy" (Vect.cons "peaks" (Vect.nil))`.

 * 定义一个函数 {anchorName exerciseDefs}`Vect.push`，它将一个条目添加到 {anchorName Vect}`Vect` 的 _末尾_。它的类型应该是 {anchorTerm exerciseDefs}`Vect α n → α → Vect α (n + 1)`，{anchorTerm snocSnowy}`#eval Vect.push (.cons "snowy" .nil) "peaks"` 应该输出 {anchorInfo snocSnowy}`Vect.cons "snowy" (Vect.cons "peaks" (Vect.nil))`。

--  * Define a function {anchorName exerciseDefs}`Vect.reverse` that reverses the order of a {anchorName Vect}`Vect`.

 * 定义一个函数 {anchorName exerciseDefs}`Vect.reverse`，它反转一个 {anchorName Vect}`Vect` 的顺序。

--  * Define a function {anchorName exerciseDefs}`Vect.drop` with the following type: {anchorTerm exerciseDefs}`(n : Nat) → Vect α (k + n) → Vect α k`.
--    Verify that it works by checking that {anchorTerm ejerBavnehoej}`#eval danishPeaks.drop 2` yields {anchorInfo ejerBavnehoej}`Vect.cons "Ejer Bavnehøj" (Vect.nil)`.

 * 定义一个函数 {anchorName exerciseDefs}`Vect.drop`。 它的类型 {anchorTerm exerciseDefs}`(n : Nat) → Vect α (k + n) → Vect α k`。
   通过检查 {anchorTerm ejerBavnehoej}`#eval danishPeaks.drop 2` 输出 {anchorInfo ejerBavnehoej}`Vect.cons "Ejer Bavnehøj" (Vect.nil)` 来验证它是否正确。

--  * Define a function {anchorName take}`Vect.take` with type {anchorTerm take}`(n : Nat) → Vect α (k + n) → Vect α n` that returns the first {anchorName take}`n` entries in the {anchorName Vect}`Vect`. Check that it works on an example.

 * 定义一个函数 {anchorName take}`Vect.take`。它的类型为 {anchorTerm take}`(n : Nat) → Vect α (k + n) → Vect α n`。它返回 {anchorName Vect}`Vect` 中的前 {anchorName take}`n` 个条目。检查它在一个例子上的结果。
