import VersoManual
import FPLeanZh.Examples

open Verso.Genre Manual
open Verso.Code.External

open FPLeanZh

set_option verso.exampleProject "../examples"
set_option verso.exampleModule "Examples.DependentTypes"

#doc (Manual) "索引族" =>

-- Polymorphic inductive types take type arguments.
-- For instance, {moduleName}`List` takes an argument that determines the type of the entries in the list, and {moduleName}`Except` takes arguments that determine the types of the exceptions or values.
-- These type arguments, which are the same in every constructor of the datatype, are referred to as _parameters_.

多态归纳类型接受类型参数。
例如，{moduleName}`List` 接受一个参数，该参数确定列表中条目的类型，而 {moduleName}`Except` 接受确定异常或值类型的参数。
这些类型参数在数据类型的每个构造函数中都相同，被称为__参数__。

-- Arguments to inductive types need not be the same in every constructor, however.
-- Inductive types in which the arguments to the type vary based on the choice of constructor are called _indexed families_, and the arguments that vary are referred to as _indices_.
-- The “hello world” of indexed families is a type of lists that contains the length of the list in addition to the type of entries, conventionally referred to as “vectors”:

然而，归纳类型的参数不必在每个构造函数中都相同。
类型参数根据构造函数的选择而变化的归纳类型称为__索引族__，变化的参数称为__索引__。
索引族的“hello world”是一种列表类型，除了条目类型外，还包含列表的长度，通常称为“向量”：

```anchor Vect
inductive Vect (α : Type u) : Nat → Type u where
   | nil : Vect α 0
   | cons : α → Vect α n → Vect α (n + 1)
```

-- The type of a vector of three {anchorName vect3}`String`s includes the fact that it contains three {anchorName vect3}`String`s:

包含三个 {anchorName vect3}`String` 的向量的类型包括它包含三个 {anchorName vect3}`String` 的事实：

```anchor vect3
example : Vect String 3 :=
  .cons "one" (.cons "two" (.cons "three" .nil))
```

-- Function declarations may take some arguments before the colon, indicating that they are available in the entire definition, and some arguments after, indicating a desire to pattern-match on them and define the function case by case.
-- Inductive datatypes have a similar principle: the argument {anchorName Vect}`α` is named at the top of the datatype declaration, prior to the colon, which indicates that it is a parameter that must be provided as the first argument in all occurrences of {anchorName Vect}`Vect` in the definition, while the {anchorName Vect}`Nat` argument occurs after the colon, indicating that it is an index that may vary.
-- Indeed, the three occurrences of {anchorName Vect}`Vect` in the {anchorName Vect}`nil` and {anchorName Vect}`cons` constructor declarations consistently provide {anchorName Vect}`α` as the first argument, while the second argument is different in each case.

函数声明可以在冒号前接受一些参数，表明它们在整个定义中都可用，而在冒号后接受一些参数，表明希望对它们进行模式匹配并逐个定义函数。
归纳数据类型也有类似的原则：参数 {anchorName Vect}`α` 在数据类型声明的顶部、冒号之前命名，这表明它是一个参数，必须在定义中 {anchorName Vect}`Vect` 的所有出现中作为第一个参数提供，而 {anchorName Vect}`Nat` 参数出现在冒号之后，表明它是一个可能变化的索引。
实际上，{anchorName Vect}`nil` 和 {anchorName Vect}`cons` 构造函数声明中 {anchorName Vect}`Vect` 的三次出现始终将 {anchorName Vect}`α` 作为第一个参数提供，而第二个参数在每种情况下都不同。

-- The declaration of {anchorName Vect}`nil` states that it is a constructor of type {anchorTerm Vect}`Vect α 0`.
-- This means that using {anchorName nilNotLengthThree}`Vect.nil` in a context expecting a {anchorTerm nilNotLengthThree}`Vect String 3` is a type error, just as {anchorTerm otherEx}`[1, 2, 3]` is a type error in a context that expects a {anchorTerm otherEx}`List String`:

{anchorName Vect}`nil` 的声明指出它是一个类型为 {anchorTerm Vect}`Vect α 0` 的构造函数。
这意味着在期望 {anchorTerm nilNotLengthThree}`Vect String 3` 的上下文中使用 {anchorName nilNotLengthThree}`Vect.nil` 是一个类型错误，就像 {anchorTerm otherEx}`[1, 2, 3]` 在期望 {anchorTerm otherEx}`List String` 的上下文中是一个类型错误一样：

```anchor nilNotLengthThree
example : Vect String 3 := Vect.nil
```
```anchorError nilNotLengthThree
type mismatch
  Vect.nil
has type
  Vect ?m.1606 0 : Type ?u.1605
but is expected to have type
  Vect String 3 : Type
```

-- The mismatch between {anchorTerm Vect}`0` and {anchorTerm nilNotLengthThree}`3` in this example plays exactly the same role as any other type mismatch, even though {anchorTerm Vect}`0` and {anchorTerm nilNotLengthThree}`3` are not themselves types.
-- The metavariable in the message can be ignored because its presence indicates that {anchorName otherEx}`Vect.nil` can have any element type.

此示例中 {anchorTerm Vect}`0` 和 {anchorTerm nilNotLengthThree}`3` 之间的不匹配与任何其他类型不匹配的作用完全相同，即使 {anchorTerm Vect}`0` 和 {anchorTerm nilNotLengthThree}`3` 本身不是类型。
消息中的元变量可以忽略，因为它的存在表明 {anchorName otherEx}`Vect.nil` 可以具有任何元素类型。

-- Indexed families are called _families_ of types because different index values can make different constructors available for use.
-- In some sense, an indexed family is not a type; rather, it is a collection of related types, and the choice of index values also chooses a type from the collection.
-- Choosing the index {anchorTerm otherEx}`5` for {anchorName Vect}`Vect` means that only the constructor {anchorName Vect}`cons` is available, and choosing the index {anchorTerm Vect}`0` means that only {anchorName Vect}`nil` is available.

索引族被称为类型__族__，因为不同的索引值可以使不同的构造函数可用。
在某种意义上，索引族不是一个类型；相反，它是一组相关类型的集合，索引值的选择也从集合中选择一个类型。
为 {anchorName Vect}`Vect` 选择索引 {anchorTerm otherEx}`5` 意味着只有构造函数 {anchorName Vect}`cons` 可用，而选择索引 {anchorTerm Vect}`0` 意味着只有 {anchorName Vect}`nil` 可用。

-- If the index is not yet known (e.g. because it is a variable), then no constructor can be used until it becomes known.
-- Using {anchorName nilNotLengthN}`n` for the length allows neither {anchorName otherEx}`Vect.nil` nor {anchorName consNotLengthN}`Vect.cons`, because there's no way to know whether the variable {anchorName nilNotLengthN}`n` should stand for a {anchorName Vect}`Nat` that matches {anchorTerm Vect}`0` or {anchorTerm Vect}`n + 1`:

如果索引尚不清楚（例如，因为它是一个变量），那么在它变得清楚之前不能使用任何构造函数。
将 {anchorName nilNotLengthN}`n` 用于长度既不允许 {anchorName otherEx}`Vect.nil` 也不允许 {anchorName consNotLengthN}`Vect.cons`，因为无法知道变量 {anchorName nilNotLengthN}`n` 应该代表与 {anchorTerm Vect}`0` 或 {anchorTerm Vect}`n + 1` 匹配的 {anchorName Vect}`Nat`：

```anchor nilNotLengthN
example : Vect String n := Vect.nil
```
```anchorError nilNotLengthN
type mismatch
  Vect.nil
has type
  Vect ?m.1694 0 : Type ?u.1693
but is expected to have type
  Vect String n : Type
```

```anchor consNotLengthN
example : Vect String n := Vect.cons "Hello" (Vect.cons "world" Vect.nil)
```
```anchorError consNotLengthN
type mismatch
  Vect.cons "Hello" (Vect.cons "world" Vect.nil)
has type
  Vect String (0 + 1 + 1) : Type
but is expected to have type
  Vect String n : Type
```

-- Having the length of the list as part of its type means that the type becomes more informative.
-- For example, {anchorName replicateStart}`Vect.replicate` is a function that creates a {anchorName replicateStart}`Vect` with a number of copies of a given value.
-- The type that says this precisely is:

将列表的长度作为其类型的一部分意味着类型变得更具信息性。
例如，{anchorName replicateStart}`Vect.replicate` 是一个函数，它创建一个包含给定值多个副本的 {anchorName replicateStart}`Vect`。
精确表达此意的类型是：

```anchor replicateStart
def Vect.replicate (n : Nat) (x : α) : Vect α n := _
```

-- The argument {anchorName replicateStart}`n` appears as the length of the result.
-- The message associated with the underscore placeholder describes the task at hand:

参数 {anchorName replicateStart}`n` 作为结果的长度出现。
与下划线占位符关联的消息描述了手头的任务：

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

在使用索引族时，只有当 Lean 能够看到构造函数的索引与预期类型中的索引匹配时，才能应用构造函数。
然而，两个构造函数都没有与 {anchorName replicateStart}`n` 匹配的索引——{anchorName Vect}`nil` 匹配 {anchorName otherEx}`Nat.zero`，而 {anchorName Vect}`cons` 匹配 {anchorName otherEx}`Nat.succ`。
就像示例类型错误中一样，变量 {anchorName Vect}`n` 可以代表其中任何一个，具体取决于作为参数提供给函数的 {anchorName Vect}`Nat`。
解决方案是使用模式匹配来考虑两种可能的情况：

```anchor replicateMatchOne
def Vect.replicate (n : Nat) (x : α) : Vect α n :=
  match n with
  | 0 => _
  | k + 1 => _
```

-- Because {anchorName replicateStart}`n` occurs in the expected type, pattern matching on {anchorName replicateStart}`n` _refines_ the expected type in the two cases of the match.
-- In the first underscore, the expected type has become {lit}`Vect α 0`:

因为 {anchorName replicateStart}`n` 出现在预期类型中，所以对 {anchorName replicateStart}`n` 的模式匹配__细化__了匹配的两种情况下的预期类型。
在第一个下划线中，预期类型已变为 {lit}`Vect α 0`：

```anchorError replicateMatchOne
don't know how to synthesize placeholder
context:
α : Type u_1
n : Nat
x : α
⊢ Vect α 0
```

-- In the second underscore, it has become {lit}`Vect α (k + 1)`:

在第二个下划线中，它已变为 {lit}`Vect α (k + 1)`：

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

当模式匹配除了发现值的结构外还细化程序的类型时，它被称为__依赖模式匹配__。

-- The refined type makes it possible to apply the constructors.
-- The first underscore matches {anchorName otherEx}`Vect.nil`, and the second matches {anchorName consNotLengthN}`Vect.cons`:

细化后的类型使得应用构造函数成为可能。
第一个下划线匹配 {anchorName otherEx}`Vect.nil`，第二个匹配 {anchorName consNotLengthN}`Vect.cons`：

```anchor replicateMatchFour
def Vect.replicate (n : Nat) (x : α) : Vect α n :=
  match n with
  | 0 => .nil
  | k + 1 => .cons _ _
```

-- The first underscore under the {anchorName replicateMatchFour}`.cons` should have type {anchorName replicateMatchFour}`α`.
-- There is an {anchorName replicateMatchFour}`α` available, namely {anchorName replicateMatchFour}`x`:

{anchorName replicateMatchFour}`.cons` 下的第一个下划线应该具有类型 {anchorName replicateMatchFour}`α`。
有一个可用的 {anchorName replicateMatchFour}`α`，即 {anchorName replicateMatchFour}`x`：

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

第二个下划线应该是一个 {lit}`Vect α k`，可以通过递归调用 {anchorName replicate}`replicate` 来生成：

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

这是 {anchorName replicate}`replicate` 的最终定义：

```anchor replicate
def Vect.replicate (n : Nat) (x : α) : Vect α n :=
  match n with
  | 0 => .nil
  | k + 1 => .cons x (replicate k x)
```

-- In addition to providing assistance while writing the function, the informative type of {anchorName replicate}`Vect.replicate` also allows client code to rule out a number of unexpected functions without having to read the source code.
-- A version of {anchorName listReplicate}`replicate` for lists could produce a list of the wrong length:

除了在编写函数时提供帮助之外，{anchorName replicate}`Vect.replicate` 的信息丰富类型还允许客户端代码排除许多意外函数，而无需阅读源代码。
列表的 {anchorName listReplicate}`replicate` 版本可能会生成错误长度的列表：

```anchor listReplicate
def List.replicate (n : Nat) (x : α) : List α :=
  match n with
  | 0 => []
  | k + 1 => x :: x :: replicate k x
```

-- However, making this mistake with {anchorName replicateOops}`Vect.replicate` is a type error:

然而，使用 {anchorName replicateOops}`Vect.replicate` 犯这个错误是一个类型错误：

```anchor replicateOops
def Vect.replicate (n : Nat) (x : α) : Vect α n :=
  match n with
  | 0 => .nil
  | k + 1 => .cons x (.cons x (replicate k x))
```
```anchorError replicateOops
application type mismatch
  cons x (cons x (replicate k x))
argument
  cons x (replicate k x)
has type
  Vect α (k + 1) : Type ?u.2817
but is expected to have type
  Vect α k : Type ?u.2817
```

-- The function {anchorName otherEx}`List.zip` combines two lists by pairing the first entry in the first list with the first entry in the second list, the second entry in the first list with the second entry in the second list, and so forth.
-- {anchorName otherEx}`List.zip` can be used to pair the three highest peaks in the US state of Oregon with the three highest peaks in Denmark:

函数 {anchorName otherEx}`List.zip` 通过将第一个列表中的第一个条目与第二个列表中的第一个条目配对，第一个列表中的第二个条目与第二个列表中的第二个条目配对，依此类推来组合两个列表。
{anchorName otherEx}`List.zip` 可用于将美国俄勒冈州的三座最高峰与丹麦的三座最高峰配对：

```anchorTerm zip1
["Mount Hood",
 "Mount Jefferson",
 "South Sister"].zip ["Møllehøj", "Yding Skovhøj", "Ejer Bavnehøj"]
```

-- The result is a list of three pairs:
结果是三个对的列表：

```anchorTerm zip1
[("Mount Hood", "Møllehøj"),
 ("Mount Jefferson", "Yding Skovhøj"),
 ("South Sister", "Ejer Bavnehøj")]
```

-- It's somewhat unclear what should happen when the lists have different lengths.
-- Like many languages, Lean chooses to ignore the extra entries in one of the lists.
-- For instance, combining the heights of the five highest peaks in Oregon with those of the three highest peaks in Denmark yields three pairs.
-- In particular,

当列表长度不同时，应该发生什么有点不清楚。
像许多语言一样，Lean 选择忽略其中一个列表中的额外条目。
例如，将俄勒冈州五座最高峰的高度与丹麦三座最高峰的高度结合起来会产生三对。
特别是，

-- evaluates to

```anchorTerm zip2
[3428.8, 3201, 3158.5, 3075, 3064].zip [170.86, 170.77, 170.35]
```
计算结果为

```anchorTerm zip2
[(3428.8, 170.86), (3201, 170.77), (3158.5, 170.35)]
```

-- While this approach is convenient because it always returns an answer, it runs the risk of throwing away data when the lists unintentionally have different lengths.
-- F# takes a different approach: its version of {fsharp}`List.zip` throws an exception when the lengths don't match, as can be seen in this {lit}`fsi` session:

虽然这种方法很方便，因为它总是返回一个答案，但当列表意外地具有不同长度时，它存在丢弃数据的风险。
F# 采取了不同的方法：它的 {fsharp}`List.zip` 版本在长度不匹配时会抛出异常，如下面的 {lit}`fsi` 会话所示：

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

这避免了意外丢弃信息，但程序崩溃本身也带来了困难。
Lean 的等价物，它将使用 {anchorName otherEx}`Option` 或 {anchorName otherEx}`Except` 单子，会带来可能不值得安全的负担。

:::paragraph
-- Using {anchorName Vect}`Vect`, however, it is possible to write a version of {anchorName VectZip}`zip` with a type that requires that both arguments have the same length:
然而，使用 {anchorName Vect}`Vect`，可以编写一个 {anchorName VectZip}`zip` 版本，其类型要求两个参数具有相同的长度：

```anchor VectZip
def Vect.zip : Vect α n → Vect β n → Vect (α × β) n
  | .nil, .nil => .nil
  | .cons x xs, .cons y ys => .cons (x, y) (zip xs ys)
```

-- This definition only has patterns for the cases where either both arguments are {anchorName otherEx}`Vect.nil` or both arguments are {anchorName consNotLengthN}`Vect.cons`, and Lean accepts the definition without a “missing cases” error like the one that results from a similar definition for {anchorName otherEx}`List`:

此定义仅包含两个参数都是 {anchorName otherEx}`Vect.nil` 或两个参数都是 {anchorName consNotLengthN}`Vect.cons` 的情况的模式，并且 Lean 接受该定义，而不会出现类似于 {anchorName otherEx}`List` 的类似定义所导致的“缺少情况”错误：

```anchor zipMissing
def List.zip : List α → List β → List (α × β)
  | [], [] => []
  | x :: xs, y :: ys => (x, y) :: zip xs ys
```
```anchorError zipMissing
missing cases:
(List.cons _ _), []
[], (List.cons _ _)
```
:::

-- This is because the constructor used in the first pattern, {anchorName Vect}`nil` or {anchorName Vect}`cons`, _refines_ the type checker's knowledge about the length {anchorName VectZip}`n`.
-- When the first pattern is {anchorName Vect}`nil`, the type checker can additionally determine that the length was {anchorTerm VectZipLen}`0`, so the only possible choice for the second pattern is {anchorName Vect}`nil`.
-- Similarly, when the first pattern is {anchorName Vect}`cons`, the type checker can determine that the length was {anchorTerm VectZipLen}`k+1` for some {anchorName VectZipLen}`Nat` {anchorName VectZipLen}`k`, so the only possible choice for the second pattern is {anchorName Vect}`cons`.
-- Indeed, adding a case that uses {anchorName Vect}`nil` and {anchorName Vect}`cons` together is a type error, because the lengths don't match:

这是因为第一个模式中使用的构造函数 {anchorName Vect}`nil` 或 {anchorName Vect}`cons` __细化__了类型检查器对长度 {anchorName VectZip}`n` 的了解。
当第一个模式是 {anchorName Vect}`nil` 时，类型检查器可以额外确定长度为 {anchorTerm VectZipLen}`0`，因此第二个模式的唯一可能选择是 {anchorName Vect}`nil`。
同样，当第一个模式是 {anchorName Vect}`cons` 时，类型检查器可以确定长度为某个 {anchorName VectZipLen}`Nat` {anchorName VectZipLen}`k` 的 {anchorTerm VectZipLen}`k+1`，因此第二个模式的唯一可能选择是 {anchorName Vect}`cons`。
实际上，添加一个同时使用 {anchorName Vect}`nil` 和 {anchorName Vect}`cons` 的情况是一个类型错误，因为长度不匹配：

```anchor zipExtraCons
def Vect.zip : Vect α n → Vect β n → Vect (α × β) n
  | .nil, .nil => .nil
  | .nil, .cons y ys => .nil
  | .cons x xs, .cons y ys => .cons (x, y) (zip xs ys)
```
```anchorError zipExtraCons
type mismatch
  Vect.cons y ys
has type
  Vect ?m.5565 (?m.5576 + 1) : Type ?u.5573
but is expected to have type
  Vect β 0 : Type ?u.5440
```

-- The refinement of the length can be observed by making {anchorName VectZipLen}`n` into an explicit argument:

长度的细化可以通过将 {anchorName VectZipLen}`n` 显式化为参数来观察：

```anchor VectZipLen
def Vect.zip : (n : Nat) → Vect α n → Vect β n → Vect (α × β) n
  | 0, .nil, .nil => .nil
  | k + 1, .cons x xs, .cons y ys => .cons (x, y) (zip k xs ys)
```

-- # Exercises

# 练习

-- Getting a feel for programming with dependent types requires experience, and the exercises in this section are very important.
-- For each exercise, try to see which mistakes the type checker can catch, and which ones it can't, by experimenting with the code as you go.
-- This is also a good way to develop a feel for the error messages.

熟悉依赖类型编程需要经验，本节中的练习非常重要。
对于每个练习，尝试通过在编写代码时进行实验，查看类型检查器可以捕获哪些错误，以及哪些错误无法捕获。
这也是培养对错误消息的感觉的好方法。

--  * Double-check that {anchorName VectZip}`Vect.zip` gives the right answer when combining the three highest peaks in Oregon with the three highest peaks in Denmark.
--    Because {anchorName Vect}`Vect` doesn't have the syntactic sugar that {anchorName otherEx}`List` has, it can be helpful to begin by defining {anchorTerm exerciseDefs}`oregonianPeaks : Vect String 3` and {anchorTerm exerciseDefs}`danishPeaks : Vect String 3`.

 * 仔细检查 {anchorName VectZip}`Vect.zip` 在组合俄勒冈州三座最高峰和丹麦三座最高峰时是否给出了正确答案。
   因为 {anchorName Vect}`Vect` 没有 {anchorName otherEx}`List` 具有的语法糖，所以从定义 {anchorTerm exerciseDefs}`oregonianPeaks : Vect String 3` 和 {anchorTerm exerciseDefs}`danishPeaks : Vect String 3` 开始可能会有所帮助。

--  * Define a function {anchorName exerciseDefs}`Vect.map` with type {anchorTerm exerciseDefs}`(α → β) → Vect α n → Vect β n`.

 * 定义一个类型为 {anchorTerm exerciseDefs}`(α → β) → Vect α n → Vect β n` 的函数 {anchorName exerciseDefs}`Vect.map`。

--  * Define a function {anchorName exerciseDefs}`Vect.zipWith` that combines the entries in a {anchorName Vect}`Vect` one at a time with a function.
--    It should have the type {anchorTerm exerciseDefs}`(α → β → γ) → Vect α n → Vect β n → Vect γ n`.

 * 定义一个函数 {anchorName exerciseDefs}`Vect.zipWith`，它使用一个函数一次组合 {anchorName Vect}`Vect` 中的条目。
   它应该具有类型 {anchorTerm exerciseDefs}`(α → β → γ) → Vect α n → Vect β n → Vect γ n`。

--  * Define a function {anchorName exerciseDefs}`Vect.unzip` that splits a {anchorName Vect}`Vect` of pairs into a pair of {anchorName Vect}`Vect`s. It should have the type {anchorTerm exerciseDefs}`Vect (α × β) n → Vect α n × Vect β n`.

 * 定义一个函数 {anchorName exerciseDefs}`Vect.unzip`，它将一对 {anchorName Vect}`Vect` 的 {anchorName Vect}`Vect` 分割成一对 {anchorName Vect}`Vect`。它应该具有类型 {anchorTerm exerciseDefs}`Vect (α × β) n → Vect α n × Vect β n`。

--  * Define a function {anchorName exerciseDefs}`Vect.push` that adds an entry to the _end_ of a {anchorName Vect}`Vect`. Its type should be {anchorTerm exerciseDefs}`Vect α n → α → Vect α (n + 1)` and {anchorTerm snocSnowy}`#eval Vect.push (.cons "snowy" .nil) "peaks"` should yield {anchorInfo snocSnowy}`Vect.cons "snowy" (Vect.cons "peaks" (Vect.nil))`.

 * 定义一个函数 {anchorName exerciseDefs}`Vect.push`，它将一个条目添加到 {anchorName Vect}`Vect` 的__末尾__。它的类型应该是 {anchorTerm exerciseDefs}`Vect α n → α → Vect α (n + 1)`，并且 {anchorTerm snocSnowy}`#eval Vect.push (.cons "snowy" .nil) "peaks"` 应该产生 {anchorInfo snocSnowy}`Vect.cons "snowy" (Vect.cons "peaks" (Vect.nil))`。

--  * Define a function {anchorName exerciseDefs}`Vect.reverse` that reverses the order of a {anchorName Vect}`Vect`.

 * 定义一个函数 {anchorName exerciseDefs}`Vect.reverse`，它反转 {anchorName Vect}`Vect` 的顺序。

--  * Define a function {anchorName exerciseDefs}`Vect.drop` with the following type: {anchorTerm exerciseDefs}`(n : Nat) → Vect α (k + n) → Vect α k`.
--    Verify that it works by checking that {anchorTerm ejerBavnehoej}`#eval danishPeaks.drop 2` yields {anchorInfo ejerBavnehoej}`Vect.cons "Ejer Bavnehøj" (Vect.nil)`.

 * 定义一个类型为 {anchorTerm exerciseDefs}`(n : Nat) → Vect α (k + n) → Vect α k` 的函数 {anchorName exerciseDefs}`Vect.drop`。
   通过检查 {anchorTerm ejerBavnehoej}`#eval danishPeaks.drop 2` 是否产生 {anchorInfo ejerBavnehoej}`Vect.cons "Ejer Bavnehøj" (Vect.nil)` 来验证它是否有效。

--  * Define a function {anchorName take}`Vect.take` with type {anchorTerm take}`(n : Nat) → Vect α (k + n) → Vect α n` that returns the first {anchorName take}`n` entries in the {anchorName Vect}`Vect`. Check that it works on an example.

 * 定义一个类型为 {anchorTerm take}`(n : Nat) → Vect α (k + n) → Vect α n` 的函数 {anchorName take}`Vect.take`，它返回 {anchorName Vect}`Vect` 中的前 {anchorName take}`n` 个条目。检查它是否在一个示例上有效。
