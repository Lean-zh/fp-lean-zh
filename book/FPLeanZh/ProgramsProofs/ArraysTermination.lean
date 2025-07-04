import VersoManual
import FPLeanZh.Examples

open Verso.Genre Manual
open Verso.Code.External

open FPLeanZh

set_option verso.exampleProject "../examples"
set_option verso.exampleModule "Examples.ProgramsProofs.Arrays"

#doc (Manual) "Arrays and Termination" =>

/-
To write efficient code, it is important to select appropriate data structures.
Linked lists have their place: in some applications, the ability to share the tails of lists is very important.
However, most use cases for a variable-length sequential collection of data are better served by arrays, which have both less memory overhead and better locality.
-/

为了编写高效的代码，选择合适的数据结构非常重要。链表有它的用途：在某些应用程序中，
共享列表的尾部非常重要。但是，大多数可变长有序数据集合的用例都能由数组更好地提供服务，
数组既有较少的内存开销，又有更好的局部性。

/-
Arrays, however, have two drawbacks relative to lists:
 1. Arrays are accessed through indexing, rather than by pattern matching, which imposes {ref "props-proofs-indexing"}[proof obligations] in order to maintain safety.
 2. A loop that processes an entire array from left to right is a tail-recursive function, but it does not have an argument that decreases on each call.
-/
然而，数组相对于列表来说有两个缺点：
 1. 数组是通过索引访问的，而非通过模式匹配，这为维护安全性增加了{ref "props-proofs-indexing"}[证明义务]。
 2. 从左到右处理整个数组的循环是一个尾递归函数，但它没有会在每次调用时递减的参数。

/-
Making effective use of arrays requires knowing how to prove to Lean that an array index is in bounds, and how to prove that an array index that approaches the size of the array also causes the program to terminate.
Both of these are expressed using an inequality proposition, rather than propositional equality.
-/
高效地使用数组需要知道如何向 Lean 证明数组索引在范围内，
以及如何证明接近数组大小的数组索引也会使程序停机。这两个都使用不等式命题，而非命题等式表示。

/-- Inequality -/
# 不等式

/-
Because different types have different notions of ordering, inequality is governed by two type classes, called {anchorName ordSugarClasses (module := Examples.Classes)}`LE` and {anchorName ordSugarClasses (module := Examples.Classes)}`LT`.
The table in the section on {ref "equality-and-ordering"}[standard type classes] describes how these classes relate to the syntax:
-/
由于不同的类型有不同的序概念，不等式需要由两个类来控制，分别称为 {anchorName ordSugarClasses (module := Examples.Classes)}`LE` 和 {anchorName ordSugarClasses (module := Examples.Classes)}`LT`。
{ref "equality-and-ordering"}[标准类型类]一节中的表格描述了这些类与语法的关系：

:::table (header := true)
*
  * Expression
  * Desugaring
  * Class Name

*
  * {anchorTerm ltDesugar (module := Examples.Classes)}`x < y`
  * {anchorTerm ltDesugar (module := Examples.Classes)}`LT.lt x y`
  * {anchorName ordSugarClasses (module := Examples.Classes)}`LT`

*
  * {anchorTerm leDesugar (module := Examples.Classes)}`x ≤ y`
  * {anchorTerm leDesugar (module := Examples.Classes)}`LE.le x y`
  * {anchorName ordSugarClasses (module := Examples.Classes)}`LE`

*
  * {anchorTerm gtDesugar (module := Examples.Classes)}`x > y`
  * {anchorTerm gtDesugar (module := Examples.Classes)}`LT.lt y x`
  * {anchorName ordSugarClasses (module := Examples.Classes)}`LT`

*
  * {anchorTerm geDesugar (module := Examples.Classes)}`x ≥ y`
  * {anchorTerm geDesugar (module := Examples.Classes)}`LE.le y x`
  * {anchorName ordSugarClasses (module := Examples.Classes)}`LE`

:::

/-
In other words, a type may customize the meaning of the {anchorTerm ltDesugar (module:=Examples.Classes)}`<` and {anchorTerm leDesugar (module:=Examples.Classes)}`≤` operators, while {anchorTerm gtDesugar (module:=Examples.Classes)}`>` and {anchorTerm geDesugar (module:=Examples.Classes)}`≥` derive their meanings from {anchorTerm ltDesugar (module:=Examples.Classes)}`<` and {anchorTerm leDesugar (module:=Examples.Classes)}`≤`.
The classes {anchorName ordSugarClasses (module := Examples.Classes)}`LT` and {anchorName ordSugarClasses (module := Examples.Classes)}`LE` have methods that return propositions rather than {anchorName CoeBoolProp (module:=Examples.Classes)}`Bool`s:
-/
换句话说，一个类型可以定制 {anchorTerm ltDesugar (module:=Examples.Classes)}`<` 和 {anchorTerm leDesugar (module:=Examples.Classes)}`≤` 运算符的含义，而 {anchorTerm gtDesugar (module:=Examples.Classes)}`>` 和 {anchorTerm geDesugar (module:=Examples.Classes)}`≥` 可以从
{anchorTerm ltDesugar (module:=Examples.Classes)}`<` 和 {anchorTerm leDesugar (module:=Examples.Classes)}`≤` 中派生它们的含义。{anchorName ordSugarClasses (module := Examples.Classes)}`LT` 和 {anchorName ordSugarClasses (module := Examples.Classes)}`LE` 类具有返回命题而非 {anchorName CoeBoolProp (module:=Examples.Classes)}`Bool` 的方法：

```anchor less
class LE (α : Type u) where
  le : α → α → Prop

class LT (α : Type u) where
  lt : α → α → Prop
```

/-
The instance of {anchorName LENat}`LE` for {anchorName LENat}`Nat` delegates to {anchorName LENat}`Nat.le`:
-/
{anchorName LENat}`Nat` 的 {anchorName LENat}`LE` 实例会委托给 {anchorName LENat}`Nat.le`：

```anchor LENat
instance : LE Nat where
  le := Nat.le
```
/-
Defining {anchorName LENat}`Nat.le` requires a feature of Lean that has not yet been presented: it is an inductively-defined relation.
-/
定义 {anchorName LENat}`Nat.le` 需要 Lean 的一个尚未介绍的特性：它是一个归纳定义的关系。

/-- Inductively-Defined Propositions, Predicates, and Relations -/
## 归纳定义的命题、谓词和关系

/-
{anchorName LENat}`Nat.le` is an _inductively-defined relation_.
Just as {kw}`inductive` can be used to create new datatypes, it can be used to create new propositions.
When a proposition takes an argument, it is referred to as a _predicate_ that may be true for some, but not all, potential arguments.
-/
{anchorName LENat}`Nat.le` 是一个 _归纳定义的关系_。
正如 {kw}`inductive` 可以用来创建新的数据类型，它也可以用来创建新的命题。
当一个命题接受参数时，它被称为 _谓词_，对于一些潜在的参数可能为真，但对于其他参数可能为假。
/-
Propositions that take multiple arguments are called _relations_.
-/
接受多个参数的命题被称为 _关系_。

/-
Each constructor of an inductively defined proposition is a way to prove it.
In other words, the declaration of the proposition describes the different forms of evidence that it is true.
A proposition with no arguments that has a single constructor can be quite easy to prove:
-/
归纳定义命题的每个构造子都是证明它的一种方式。
换句话说，命题的声明描述了它为真的证据的不同形式。
有单个构造子且不接受参数的命题很容易证明：

```anchor EasyToProve
inductive EasyToProve : Prop where
  | heresTheProof : EasyToProve
```
/-
The proof consists of using its constructor:
-/
证明包括使用它的构造子：

```anchor fairlyEasy
theorem fairlyEasy : EasyToProve := by
  constructor
```
/-
In fact, the proposition {anchorName True}`True`, which should always be easy to prove, is defined just like {anchorName EasyToProve}`EasyToProve`:
-/
实际上，应该总是容易证明的命题 {anchorName True}`True`，其定义就像 {anchorName EasyToProve}`EasyToProve` 一样：

```anchor True
inductive True : Prop where
  | intro : True
```

/-
Inductively-defined propositions that don't take arguments are not nearly as interesting as inductively-defined datatypes.
This is because data is interesting in its own right—the natural number {anchorTerm IsThree}`3` is different from the number {lit}`35`, and someone who has ordered 3 pizzas will be upset if 35 arrive at their door 30 minutes later.
The constructors of a proposition describe ways in which the proposition can be true, but once a proposition has been proved, there is no need to know _which_ underlying constructors were used.
This is why most interesting inductively-defined types in the {anchorTerm IsThree}`Prop` universe take arguments.
-/
不接受参数的归纳定义命题远不如归纳定义数据类型有趣。
这是因为数据本身就很有趣——自然数 {anchorTerm IsThree}`3` 与数字 {lit}`35` 是不同的，如果有人订了 3 个披萨，但 30 分钟后有 35 个到了门口，他们会很沮丧。
命题的构造子描述了命题可以为真的方式，但一旦命题被证明了，就不需要知道使用了 _哪些_ 底层构造子。
这就是为什么在 {anchorTerm IsThree}`Prop` 宇宙中大多数有趣的归纳定义类型都接受参数。

:::paragraph
/-
The inductively-defined predicate {anchorName IsThree}`IsThree` states that its argument is three:
-/
归纳定义的谓词 {anchorName IsThree}`IsThree` 声明其参数是三：

```anchor IsThree
inductive IsThree : Nat → Prop where
  | isThree : IsThree 3
```
/-
The mechanism used here is just like {ref "column-pointers"}[indexed families such as {moduleName module := Examples.DependentTypes.DB}`HasCol`], except the resulting type is a proposition that can be proved rather than data that can be used.
-/
这里使用的机制就像{ref "column-pointers"}[诸如 {moduleName module := Examples.DependentTypes.DB}`HasCol` 的索引族]一样，只是结果类型是可以证明的命题，而不是可以使用的数据。
:::

/-
Using this predicate, it is possible to prove that three is indeed three:
-/
使用这个谓词，可以证明三确实是三：

```anchor threeIsThree
theorem three_is_three : IsThree 3 := by
  constructor
```
/-
Similarly, {anchorName IsFive}`IsFive` is a predicate that states that its argument is {anchorTerm IsFive}`5`:
-/
类似地，{anchorName IsFive}`IsFive` 是一个谓词，声明其参数是 {anchorTerm IsFive}`5`：

```anchor IsFive
inductive IsFive : Nat → Prop where
  | isFive : IsFive 5
```

/-
If a number is three, then the result of adding two to it should be five.
This can be expressed as a theorem statement:
-/
如果一个数是三，那么给它加二的结果应该是五。
这可以表示为一个定理语句：
```anchor threePlusTwoFive0
theorem three_plus_two_five : IsThree n → IsFive (n + 2) := by
  skip
```
/-
The resulting goal has a function type:
-/
得到的目标具有函数类型：
```anchorError threePlusTwoFive0
unsolved goals
n : Nat
⊢ IsThree n → IsFive (n + 2)
```
/-
Thus, the {anchorTerm threePlusTwoFive1}`intro` tactic can be used to convert the argument into an assumption:
-/
因此，可以使用 {anchorTerm threePlusTwoFive1}`intro` 策略将参数转换为假设：
```anchor threePlusTwoFive1
theorem three_plus_two_five : IsThree n → IsFive (n + 2) := by
  intro three
```
```anchorError threePlusTwoFive1
unsolved goals
n : Nat
three : IsThree n
⊢ IsFive (n + 2)
```
/-
Given the assumption that {anchorName threePlusTwoFive1a}`n` is three, it should be possible to use the constructor of {anchorName threePlusTwoFive1a}`IsFive` to complete the proof:
-/
给定 {anchorName threePlusTwoFive1a}`n` 是三的假设，应该可以使用 {anchorName threePlusTwoFive1a}`IsFive` 的构造子来完成证明：
```anchor threePlusTwoFive1a
theorem three_plus_two_five : IsThree n → IsFive (n + 2) := by
  intro three
  constructor
```
/-
However, this results in an error:
-/
然而，这会导致错误：
```anchorError threePlusTwoFive1a
tactic 'constructor' failed, no applicable constructor found
n : Nat
three : IsThree n
⊢ IsFive (n + 2)
```
/-
This error occurs because {anchorTerm threePlusTwoFive2}`n + 2` is not definitionally equal to {anchorTerm IsFive}`5`.
In an ordinary function definition, dependent pattern matching on the assumption {anchorName threePlusTwoFive2}`three` could be used to refine {anchorName threePlusTwoFive2}`n` to {anchorTerm threeIsThree}`3`.
The tactic equivalent of dependent pattern matching is {anchorTerm threePlusTwoFive2}`cases`, which has a syntax similar to that of {kw}`induction`:
-/
此错误的发生是因为 {anchorTerm threePlusTwoFive2}`n + 2` 在定义上不等于 {anchorTerm IsFive}`5`。
在普通的函数定义中，可以对假设 {anchorName threePlusTwoFive2}`three` 进行依赖模式匹配，将 {anchorName threePlusTwoFive2}`n` 细化为 {anchorTerm threeIsThree}`3`。
依赖模式匹配的策略等价物是 {anchorTerm threePlusTwoFive2}`cases`，它的语法类似于 {kw}`induction`：
```anchor threePlusTwoFive2
theorem three_plus_two_five : IsThree n → IsFive (n + 2) := by
  intro three
  cases three with
  | isThree => skip
```
/-
In the remaining case, {anchorName threePlusTwoFive2}`n` has been refined to {anchorTerm IsThree}`3`:
-/
在剩余的情况中，{anchorName threePlusTwoFive2}`n` 已被细化为 {anchorTerm IsThree}`3`：
```anchorError threePlusTwoFive2
unsolved goals
case isThree
⊢ IsFive (3 + 2)
```
/-
Because {anchorTerm various}`3 + 2` is definitionally equal to {anchorTerm IsFive}`5`, the constructor is now applicable:
-/
因为 {anchorTerm various}`3 + 2` 在定义上等于 {anchorTerm IsFive}`5`，构造子现在是适用的：

```anchor threePlusTwoFive3
theorem three_plus_two_five : IsThree n → IsFive (n + 2) := by
  intro three
  cases three with
  | isThree => constructor
```

/-
The standard false proposition {anchorName various}`False` has no constructors, making it impossible to provide direct evidence for.
The only way to provide evidence for {anchorName various}`False` is if an assumption is itself impossible, similarly to how {kw}`nomatch` can be used to mark code that the type system can see is unreachable.
As described in {ref "connectives"}[the initial Interlude on proofs], the negation {anchorTerm various}`Not A` is short for {anchorTerm various}`A → False`.
{anchorTerm various}`Not A` can also be written {anchorTerm various}`¬A`.
-/
标准的假命题 {anchorName various}`False` 没有构造子，使得无法为其提供直接的证据。
为 {anchorName various}`False` 提供证据的唯一方法是假设本身就是不可能的，类似于如何使用 {kw}`nomatch` 来标记类型系统可以看到无法到达的代码。
如在{ref "connectives"}[关于证明的初步插曲]中所述，否定 {anchorTerm various}`Not A` 是 {anchorTerm various}`A → False` 的简写。
{anchorTerm various}`Not A` 也可以写作 {anchorTerm various}`¬A`。

/-
It is not the case that four is three:
-/
四不是三这种情况不成立：
```anchor fourNotThree0
theorem four_is_not_three : ¬ IsThree 4 := by
  skip
```
/-
The initial proof goal contains {anchorName fourNotThree1}`Not`:
-/
初始证明目标包含 {anchorName fourNotThree1}`Not`：
```anchorError fourNotThree0
unsolved goals
⊢ ¬IsThree 4
```
/-
The fact that it's actually a function type can be exposed using {anchorTerm fourNotThree1}`unfold`:
-/
它实际上是函数类型这一事实可以通过使用 {anchorTerm fourNotThree1}`unfold` 暴露出来：
```anchor fourNotThree1
theorem four_is_not_three : ¬ IsThree 4 := by
  unfold Not
```
```anchorError fourNotThree1
unsolved goals
⊢ IsThree 4 → False
```
/-
Because the goal is a function type, {anchorTerm fourNotThree2}`intro` can be used to convert the argument into an assumption.
There is no need to keep {anchorTerm fourNotThree1}`unfold`, as {anchorTerm fourNotThree2}`intro` can unfold the definition of {anchorName fourNotThree1}`Not` itself:
-/
因为目标是函数类型，可以使用 {anchorTerm fourNotThree2}`intro` 将参数转换为假设。
不需要保留 {anchorTerm fourNotThree1}`unfold`，因为 {anchorTerm fourNotThree2}`intro` 本身可以展开 {anchorName fourNotThree1}`Not` 的定义：
```anchor fourNotThree2
theorem four_is_not_three : ¬ IsThree 4 := by
  intro h
```
```anchorError fourNotThree2
unsolved goals
h : IsThree 4
⊢ False
```
/-
In this proof, the {anchorTerm fourNotThreeDone}`cases` tactic solves the goal immediately:
-/
在这个证明中，{anchorTerm fourNotThreeDone}`cases` 策略立即解决了目标：

```anchor fourNotThreeDone
theorem four_is_not_three : ¬ IsThree 4 := by
  intro h
  cases h
```
/-
Just as a pattern match on a {anchorTerm otherEx (module:=Examples.DependentTypes)}`Vect String 2` doesn't need to include a case for {anchorName otherEx (module:=Examples.DependentTypes)}`Vect.nil`, a proof by cases over {anchorTerm fourNotThreeDone}`IsThree 4` doesn't need to include a case for {anchorName IsThree}`isThree`.
-/
就像对 {anchorTerm otherEx (module:=Examples.DependentTypes)}`Vect String 2` 的模式匹配不需要包含 {anchorName otherEx (module:=Examples.DependentTypes)}`Vect.nil` 的情况一样，对 {anchorTerm fourNotThreeDone}`IsThree 4` 的情况证明不需要包含 {anchorName IsThree}`isThree` 的情况。

/-- Inequality of Natural Numbers -/
## 自然数的不等式

/-
The definition of {anchorName NatLe}`Nat.le` has a parameter and an index:
-/
{anchorName NatLe}`Nat.le` 的定义有一个参数和一个索引：

```anchor NatLe
inductive Nat.le (n : Nat) : Nat → Prop
  | refl : Nat.le n n
  | step : Nat.le n m → Nat.le n (m + 1)
```
/-
The parameter {anchorName NatLe}`n` is the number that should be smaller, while the index is the number that should be greater than or equal to {anchorName NatLe}`n`.
The {anchorName NatLe}`refl` constructor is used when both numbers are equal, while the {anchorName NatLe}`step` constructor is used when the index is greater than {anchorName NatLe}`n`.
-/
参数 {anchorName NatLe}`n` 是应该较小的数，而索引是应该大于或等于 {anchorName NatLe}`n` 的数。
当两个数相等时使用 {anchorName NatLe}`refl` 构造子，当索引大于 {anchorName NatLe}`n` 时使用 {anchorName NatLe}`step` 构造子。

/-
From the perspective of evidence, a proof that $`n \leq k` consists of finding some number $`d` such that $`n + d = m`.
In Lean, the proof then consists of a {anchorName leNames}`Nat.le.refl` constructor wrapped by $`d` instances of {anchorName leNames}`Nat.le.step`.
Each {anchorName NatLe}`step` constructor adds one to its index argument, so $`d` {anchorName NatLe}`step` constructors adds $`d` to the larger number.
For example, evidence that four is less than or equal to seven consists of three {anchorName NatLe}`step`s around a {anchorName NatLe}`refl`:
-/
从证据的角度来看，$`n \leq k` 的证明包括找到某个数 $`d` 使得 $`n + d = m`。
在 Lean 中，证明然后包括一个被 $`d` 个 {anchorName leNames}`Nat.le.step` 实例包裹的 {anchorName leNames}`Nat.le.refl` 构造子。
每个 {anchorName NatLe}`step` 构造子给其索引参数加一，所以 $`d` 个 {anchorName NatLe}`step` 构造子给较大的数加上 $`d`。
例如，四小于或等于七的证据由围绕一个 {anchorName NatLe}`refl` 的三个 {anchorName NatLe}`step` 组成：

```anchor four_le_seven
theorem four_le_seven : 4 ≤ 7 :=
  open Nat.le in
  step (step (step refl))
```

/-
The strict less-than relation is defined by adding one to the number on the left:
-/
严格小于关系是通过给左边的数加一来定义的：

```anchor NatLt
def Nat.lt (n m : Nat) : Prop :=
  Nat.le (n + 1) m

instance : LT Nat where
  lt := Nat.lt
```
/-
Evidence that four is strictly less than seven consists of two {anchorName four_lt_seven}`step`'s around a {anchorName four_lt_seven}`refl`:
-/
四严格小于七的证据由围绕一个 {anchorName four_lt_seven}`refl` 的两个 {anchorName four_lt_seven}`step` 组成：

```anchor four_lt_seven
theorem four_lt_seven : 4 < 7 :=
  open Nat.le in
  step (step refl)
```
/-
This is because {anchorTerm four_lt_seven}`4 < 7` is equivalent to {anchorTerm four_lt_seven_alt}`5 ≤ 7`.
-/
这是因为 {anchorTerm four_lt_seven}`4 < 7` 等价于 {anchorTerm four_lt_seven_alt}`5 ≤ 7`。

/-- Proving Termination -/
# 证明停机性
%%%
tag := "proving-termination"
%%%

/-
The function {anchorName ArrayMap}`Array.map` transforms an array with a function, returning a new array that contains the result of applying the function to each element of the input array.
Writing it as a tail-recursive function follows the usual pattern of delegating to a function that passes the output array in an accumulator.
The accumulator is initialized with an empty array.
The accumulator-passing helper function also takes an argument that tracks the current index into the array, which starts at {anchorTerm ArrayMap}`0`:
-/
函数 {anchorName ArrayMap}`Array.map` 用一个函数转换数组，返回一个新数组，该数组包含将函数应用于输入数组每个元素的结果。
将其写成尾递归函数遵循通常的模式，即委托给一个在累加器中传递输出数组的函数。
累加器用空数组初始化。
传递累加器的辅助函数还接受一个参数，该参数跟踪数组中的当前索引，从 {anchorTerm ArrayMap}`0` 开始：

```anchor ArrayMap
def Array.map (f : α → β) (arr : Array α) : Array β :=
  arrayMapHelper f arr Array.empty 0
```

The helper should, at each iteration, check whether the index is still in bounds.
If so, it should loop again with the transformed element added to the end of the accumulator and the index incremented by {anchorTerm mapHelperIndexIssue}`1`.
If not, then it should terminate and return the accumulator.
An initial implementation of this code fails because Lean is unable to prove that the array index is valid:
```anchor mapHelperIndexIssue
def arrayMapHelper (f : α → β) (arr : Array α)
    (soFar : Array β) (i : Nat) : Array β :=
  if i < arr.size then
    arrayMapHelper f arr (soFar.push (f arr[i])) (i + 1)
  else soFar
```
```anchorError mapHelperIndexIssue
failed to prove index is valid, possible solutions:
  - Use `have`-expressions to prove the index is valid
  - Use `a[i]!` notation instead, runtime check is performed, and 'Panic' error message is produced if index is not valid
  - Use `a[i]?` notation instead, result is an `Option` type
  - Use `a[i]'h` notation instead, where `h` is a proof that index is valid
α : Type ?u.1811
β : Type ?u.1814
f : α → β
arr : Array α
soFar : Array β
i : Nat
⊢ i < arr.size
```
-- However, the conditional expression already checks the precise condition that the array index's validity demands (namely, {anchorTerm arrayMapHelperTermIssue}`i < arr.size`).
-- Adding a name to the {kw}`if` resolves the issue, because it adds an assumption that the array indexing tactic can use:

然而，条件表达式已经检查了有效数组索引所要求的精确条件（即 {anchorTerm arrayMapHelperTermIssue}`i < arr.size`）。
为 {kw}`if` 添加一个名称可以解决此问题，因为它添加了一个前提供数组索引策略使用：

```anchor arrayMapHelperTermIssue
def arrayMapHelper (f : α → β) (arr : Array α)
    (soFar : Array β) (i : Nat) : Array β :=
  if inBounds : i < arr.size then
    arrayMapHelper f arr (soFar.push (f arr[i])) (i + 1)
  else soFar
```
/-
Lean accepts the modified program, even though the recursive call is not made on an argument to one of the input constructors.
In fact, both the accumulator and the index grow, rather than shrinking.
-/
Lean 接受修改后的程序，即使递归调用不是在输入构造子的参数上进行的。
实际上，累加器和索引都在增长，而不是缩小。

/-
Behind the scenes, Lean's proof automation constructs a termination proof.
Reconstructing this proof can make it easier to understand the cases that Lean cannot automatically recognize.
-/
在幕后，Lean 的证明自动化构造了一个停机性证明。
重构这个证明可以使理解 Lean 无法自动识别的情况变得更容易。

/-
Why does {anchorName arrayMapHelperTermIssue}`arrayMapHelper` terminate?
Each iteration checks whether the index {anchorName arrayMapHelperTermIssue}`i` is still in bounds for the array {anchorName arrayMapHelperTermIssue}`arr`.
If so, {anchorName arrayMapHelperTermIssue}`i` is incremented and the loop repeats.
If not, the program terminates.
Because {anchorTerm arrayMapHelperTermIssue}`arr.size` is a finite number, {anchorName arrayMapHelperTermIssue}`i` can be incremented only a finite number of times.
Even though no argument to the function decreases on each call, {anchorTerm ArrayMapHelperOk}`arr.size - i` decreases toward zero.
-/
为什么 {anchorName arrayMapHelperTermIssue}`arrayMapHelper` 会停机？
每次迭代都检查索引 {anchorName arrayMapHelperTermIssue}`i` 是否仍在数组 {anchorName arrayMapHelperTermIssue}`arr` 的边界内。
如果是，{anchorName arrayMapHelperTermIssue}`i` 递增并重复循环。
如果不是，程序停机。
因为 {anchorTerm arrayMapHelperTermIssue}`arr.size` 是一个有限数，{anchorName arrayMapHelperTermIssue}`i` 只能递增有限次。
尽管函数的任何参数在每次调用时都不会减少，但 {anchorTerm ArrayMapHelperOk}`arr.size - i` 向零递减。

/-
The value that decreases at each recursive call is called a _measure_.
Lean can be instructed to use a specific expression as the measure of termination by providing a {kw}`termination_by` clause at the end of a definition.
For {anchorName ArrayMapHelperOk}`arrayMapHelper`, the explicit measure looks like this:
-/
在每次递归调用时减少的值称为 _度量_。
可以通过在定义的末尾提供一个 {kw}`termination_by` 子句来指示 Lean 使用特定表达式作为停机性的度量。
对于 {anchorName ArrayMapHelperOk}`arrayMapHelper`，显式度量如下所示：

```anchor ArrayMapHelperOk
def arrayMapHelper (f : α → β) (arr : Array α)
    (soFar : Array β) (i : Nat) : Array β :=
  if inBounds : i < arr.size then
    arrayMapHelper f arr (soFar.push (f arr[i])) (i + 1)
  else soFar
termination_by arr.size - i
```

/-
A similar termination proof can be used to write {anchorName ArrayFind}`Array.find`, a function that finds the first element in an array that satisfies a Boolean function and returns both the element and its index:
-/
类似的停机性证明可以用来编写 {anchorName ArrayFind}`Array.find`，这是一个函数，用于查找数组中满足布尔函数的第一个元素，并返回该元素及其索引：

```anchor ArrayFind
def Array.find (arr : Array α) (p : α → Bool) :
    Option (Nat × α) :=
  findHelper arr p 0
```
/-
Once again, the helper function terminates because {lit}`arr.size - i` decreases as {lit}`i` increases:
-/
再一次，辅助函数停机是因为随着 {lit}`i` 的增加，{lit}`arr.size - i` 递减：

```anchor ArrayFindHelper
def findHelper (arr : Array α) (p : α → Bool)
    (i : Nat) : Option (Nat × α) :=
  if h : i < arr.size then
    let x := arr[i]
    if p x then
      some (i, x)
    else findHelper arr p (i + 1)
  else none
```

/-
Adding a question mark to {kw}`termination_by` (that is, using {kw}`termination_by?`) causes Lean to explicitly suggest the measure that it chose:
-/
在 {kw}`termination_by` 后添加问号（即使用 {kw}`termination_by?`）会导致 Lean 明确建议它选择的度量：
```anchor ArrayFindHelperSugg
def findHelper (arr : Array α) (p : α → Bool)
    (i : Nat) : Option (Nat × α) :=
  if h : i < arr.size then
    let x := arr[i]
    if p x then
      some (i, x)
    else findHelper arr p (i + 1)
  else none
termination_by?
```
```anchorInfo ArrayFindHelperSugg
Try this: termination_by arr.size - i
```
/-
Not all termination arguments are as quite as simple as this one.
However, the basic structure of identifying some expression based on the function's arguments that will decrease in each call occurs in all termination proofs.
Sometimes, creativity can be required in order to figure out just why a function terminates, and sometimes Lean requires additional proofs in order to accept that the measure in fact decreases.
-/
并非所有停机参数都像这个参数一样简单。但是，在所有停机证明中，
都会出现"基于函数的参数找出在每次调用时都会减少的某个表达式"这种基本结构。
有时，为了弄清楚函数为何停机，可能需要一点创造力，有时 Lean 需要额外的证明才能接受停机参数。
/-
# Exercises

 * Implement a {anchorTerm ForMArr}`ForM m (Array α)` instance on arrays using a tail-recursive accumulator-passing function and a {kw}`termination_by` clause.
 * Reimplement {anchorName ArrayMap}`Array.map`, {anchorName ArrayFind}`Array.find`, and the {anchorName ForMArr}`ForM` instance using {kw}`for`{lit}` ... `{kw}`in`{lit}` ...` loops in the identity monad and compare the resulting code.
 * Reimplement array reversal using a {kw}`for`{lit}` ... `{kw}`in`{lit}` ...` loop in the identity monad. Compare it to the tail-recursive function.
-/

## 练习

 * 使用尾递归累加器传递函数和 {kw}`termination_by` 子句在数组上实现 {anchorTerm ForMArr}`ForM m (Array α)` 实例。
 * 使用 __不需要__ {kw}`termination_by` 子句的尾递归累加器传递函数实现一个用于反转数组的函数。
 * 使用恒等单子中的 {kw}`for`{lit}` ... `{kw}`in`{lit}` ...` 循环重新实现 {anchorName ArrayMap}`Array.map`、{anchorName ArrayFind}`Array.find` 和 {anchorName ForMArr}`ForM` 实例，
   并比较结果代码。
 * 使用恒等单子中的 {kw}`for`{lit}` ... `{kw}`in`{lit}` ...` 循环重新实现数组反转。将其与尾递归函数的版本进行比较。
