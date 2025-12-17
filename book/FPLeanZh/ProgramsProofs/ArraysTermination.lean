import VersoManual
import FPLeanZh.Examples

open Verso.Genre Manual
open Verso.Code.External

open FPLeanZh

set_option verso.exampleProject "../examples"
set_option verso.exampleModule "Examples.ProgramsProofs.Arrays"

#doc (Manual) "数组与停机性" =>
%%%
tag := "array-termination"
file := "ArraysTermination"
%%%
-- Arrays and Termination

-- To write efficient code, it is important to select appropriate data structures.
-- Linked lists have their place: in some applications, the ability to share the tails of lists is very important.
-- However, most use cases for a variable-length sequential collection of data are better served by arrays, which have both less memory overhead and better locality.

为了编写高效的代码，选择合适的数据结构非常重要。链表有它的用途：在某些应用程序中，
共享列表的尾部非常重要。但是，大多数可变长有序数据集合的用例都能由数组更好地提供服务，
数组既有较少的内存开销，又有更好的局部性。

-- Arrays, however, have two drawbacks relative to lists:
--  1. Arrays are accessed through indexing, rather than by pattern matching, which imposes {ref "props-proofs-indexing"}[proof obligations] in order to maintain safety.
--  2. A loop that processes an entire array from left to right is a tail-recursive function, but it does not have an argument that decreases on each call.

然而，数组相对于列表来说有两个缺点：

 1. 数组是通过索引访问的，而非通过模式匹配，这为维护安全性增加了 {ref "props-proofs-indexing"}[证明义务]。
 2. 从左到右处理整个数组的循环是一个尾递归函数，但它没有会在每次调用时递减的参数。

-- Making effective use of arrays requires knowing how to prove to Lean that an array index is in bounds, and how to prove that an array index that approaches the size of the array also causes the program to terminate.
-- Both of these are expressed using an inequality proposition, rather than propositional equality.

高效地使用数组需要知道如何向 Lean 证明数组索引在范围内，
以及如何证明接近数组大小的数组索引也会使程序停机。这两个都使用不等式命题，而非命题等式表示。

-- # Inequality
# 不等式
%%%
tag := "inequality"
%%%

-- Because different types have different notions of ordering, inequality is governed by two type classes, called {anchorName ordSugarClasses (module := Examples.Classes)}`LE` and {anchorName ordSugarClasses (module := Examples.Classes)}`LT`.
-- The table in the section on {ref "equality-and-ordering"}[standard type classes] describes how these classes relate to the syntax:

由于不同的类型有不同的序概念，不等式需要由两个类来控制，分别称为 {anchorName ordSugarClasses (module := Examples.Classes)}`LE` 和 {anchorName ordSugarClasses (module := Examples.Classes)}`LT`。
{ref "equality-and-ordering"}[标准类型类] 一节中的表格描述了这些类与语法的关系：

-- * Expression
-- * Desugaring
-- * Class Name
:::table +header
*
  * 表达式
  * 脱糖结果
  * 类名

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

-- In other words, a type may customize the meaning of the {anchorTerm ltDesugar (module:=Examples.Classes)}`<` and {anchorTerm leDesugar (module:=Examples.Classes)}`≤` operators, while {anchorTerm gtDesugar (module:=Examples.Classes)}`>` and {anchorTerm geDesugar (module:=Examples.Classes)}`≥` derive their meanings from {anchorTerm ltDesugar (module:=Examples.Classes)}`<` and {anchorTerm leDesugar (module:=Examples.Classes)}`≤`.
-- The classes {anchorName ordSugarClasses (module := Examples.Classes)}`LT` and {anchorName ordSugarClasses (module := Examples.Classes)}`LE` have methods that return propositions rather than {anchorName CoeBoolProp (module:=Examples.Classes)}`Bool`s:

换句话说，一个类型可以定制 {anchorTerm ltDesugar (module:=Examples.Classes)}`<` 和 {anchorTerm leDesugar (module:=Examples.Classes)}`≤` 运算符的含义，而 {anchorTerm gtDesugar (module:=Examples.Classes)}`>` 和 {anchorTerm geDesugar (module:=Examples.Classes)}`≥` 可以从 {anchorTerm ltDesugar (module:=Examples.Classes)}`<` 和 {anchorTerm leDesugar (module:=Examples.Classes)}`≤` 中派生它们的含义。
{anchorName ordSugarClasses (module := Examples.Classes)}`LT` 和 {anchorName ordSugarClasses (module := Examples.Classes)}`LE` 类具有返回命题而非 {anchorName CoeBoolProp (module:=Examples.Classes)}`Bool` 的方法：

```anchor less
class LE (α : Type u) where
  le : α → α → Prop

class LT (α : Type u) where
  lt : α → α → Prop
```

-- The instance of {anchorName LENat}`LE` for {anchorName LENat}`Nat` delegates to {anchorName LENat}`Nat.le`:

{anchorName LENat}`Nat` 的 {anchorName LENat}`LE` 实例会委托给 {anchorName LENat}`Nat.le`：

```anchor LENat
instance : LE Nat where
  le := Nat.le
```
-- Defining {anchorName LENat}`Nat.le` requires a feature of Lean that has not yet been presented: it is an inductively-defined relation.

定义 {anchorName LENat}`Nat.le` 需要 Lean 中尚未介绍的一个特性：它是一个归纳定义的关系。

-- ## Inductively-Defined Propositions, Predicates, and Relations
## 归纳定义的命题、谓词和关系
%%%
tag := "inductive-props"
%%%

-- {anchorName LENat}`Nat.le` is an _inductively-defined relation_.
-- Just as {kw}`inductive` can be used to create new datatypes, it can be used to create new propositions.
-- When a proposition takes an argument, it is referred to as a _predicate_ that may be true for some, but not all, potential arguments.
-- Propositions that take multiple arguments are called _relations_.

{anchorName LENat}`Nat.le` 是一个 *归纳定义的关系*。
就像 {kw}`inductive` 可以用来创建新的数据类型一样，它也可以用来创建新的命题。
当一个命题接受一个参数时，它被称为 *谓词*，它可能对某些（但不是所有）潜在参数为真。
接受多个参数的命题称为 *关系*。

-- Each constructor of an inductively defined proposition is a way to prove it.
-- In other words, the declaration of the proposition describes the different forms of evidence that it is true.
-- A proposition with no arguments that has a single constructor can be quite easy to prove:

归纳定义命题的每个构造函数都是证明它的一种方法。
换句话说，命题的声明描述了它为真的不同形式的证据。
一个没有参数且只有一个构造函数的命题很容易证明：

```anchor EasyToProve
inductive EasyToProve : Prop where
  | heresTheProof : EasyToProve
```
-- The proof consists of using its constructor:

证明包括使用其构造子：

```anchor fairlyEasy
theorem fairlyEasy : EasyToProve := by
  constructor
```
-- In fact, the proposition {anchorName True}`True`, which should always be easy to prove, is defined just like {anchorName EasyToProve}`EasyToProve`:

实际上，命题 {anchorName True}`True` 应该总是很容易证明，它的定义就像 {anchorName EasyToProve}`EasyToProve`：

```anchor True
inductive True : Prop where
  | intro : True
```

-- Inductively-defined propositions that don't take arguments are not nearly as interesting as inductively-defined datatypes.
-- This is because data is interesting in its own right—the natural number {anchorTerm IsThree}`3` is different from the number {lit}`35`, and someone who has ordered 3 pizzas will be upset if 35 arrive at their door 30 minutes later.
-- The constructors of a proposition describe ways in which the proposition can be true, but once a proposition has been proved, there is no need to know _which_ underlying constructors were used.
-- This is why most interesting inductively-defined types in the {anchorTerm IsThree}`Prop` universe take arguments.

不带参数的归纳定义命题远不如归纳定义的数据类型有趣。
这是因为数据本身很有趣——自然数 {anchorTerm IsThree}`3` 不同于数字 {lit}`35`，而订购了 3 个披萨的人如果
30 分钟后收到 35 个披萨会很沮丧。命题的构造子描述了命题可以为真的方式，
但一旦命题被证明，就不需要知道它使用了 *哪些* 底层构造子。
这就是为什么 {anchorTerm IsThree}`Prop` 宇宙中最有趣的归纳定义类型带参数的原因。

-- :::paragraph
-- The inductively-defined predicate {anchorName IsThree}`IsThree` states that its argument is three:

归纳定义谓词 {anchorName IsThree}`IsThree` 陈述其参数为 3：

```anchor IsThree
inductive IsThree : Nat → Prop where
  | isThree : IsThree 3
```
-- The mechanism used here is just like {ref "column-pointers"}[indexed families such as {moduleName (module := Examples.DependentTypes.DB)}`HasCol`], except the resulting type is a proposition that can be proved rather than data that can be used.
-- :::

这里使用的机制就像 {ref "column-pointers"}[索引族，如 {moduleName (module := Examples.DependentTypes.DB)}`HasCol`]，
只不过结果类型是一个可以被证明的命题，而非可以被使用的数据。

-- Using this predicate, it is possible to prove that three is indeed three:

使用此谓词，可以证明三确实等于三：

```anchor threeIsThree
theorem three_is_three : IsThree 3 := by
  constructor
```
-- Similarly, {anchorName IsFive}`IsFive` is a predicate that states that its argument is {anchorTerm IsFive}`5`:

类似地，{anchorName IsFive}`IsFive` 是一个谓词，它陈述了其参数为 {anchorTerm IsFive}`5`：

```anchor IsFive
inductive IsFive : Nat → Prop where
  | isFive : IsFive 5
```

-- If a number is three, then the result of adding two to it should be five.
-- This can be expressed as a theorem statement:

如果一个数字是三，那么将它加二的结果应该是五。这可以表示为定理陈述：

```anchor threePlusTwoFive0
theorem three_plus_two_five : IsThree n → IsFive (n + 2) := by
  skip
```
-- The resulting goal has a function type:

结果目标具有函数类型：

```anchorError threePlusTwoFive0
unsolved goals
n : Nat
⊢ IsThree n → IsFive (n + 2)
```
-- Thus, the {anchorTerm threePlusTwoFive1}`intro` tactic can be used to convert the argument into an assumption:

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
-- Given the assumption that {anchorName threePlusTwoFive1a}`n` is three, it should be possible to use the constructor of {anchorName threePlusTwoFive1a}`IsFive` to complete the proof:

给定假设 {anchorName threePlusTwoFive1a}`n` 是三，应该可以使用 {anchorName threePlusTwoFive1a}`IsFive` 的构造子来完成证明：

```anchor threePlusTwoFive1a
theorem three_plus_two_five : IsThree n → IsFive (n + 2) := by
  intro three
  constructor
```
-- However, this results in an error:

然而，这会产生一个错误：

```anchorError threePlusTwoFive1a
Tactic `constructor` failed: no applicable constructor found

n : Nat
three : IsThree n
⊢ IsFive (n + 2)
```
-- This error occurs because {anchorTerm threePlusTwoFive2}`n + 2` is not definitionally equal to {anchorTerm IsFive}`5`.
-- In an ordinary function definition, dependent pattern matching on the assumption {anchorName threePlusTwoFive2}`three` could be used to refine {anchorName threePlusTwoFive2}`n` to {anchorTerm threeIsThree}`3`.
-- The tactic equivalent of dependent pattern matching is {anchorTerm threePlusTwoFive2}`cases`, which has a syntax similar to that of {kw}`induction`:

出现此错误是因为 {anchorTerm threePlusTwoFive2}`n + 2` 与 {anchorTerm IsFive}`5` 在定义上不相等。
在普通的函数定义中，可以对假设 {anchorName threePlusTwoFive2}`three` 使用依值模式匹配来将 {anchorName threePlusTwoFive2}`n` 细化为 {anchorTerm threeIsThree}`3`。
依值模式匹配的策略等价为 {anchorTerm threePlusTwoFive2}`cases`，其语法类似于 {kw}`induction`：

```anchor threePlusTwoFive2
theorem three_plus_two_five : IsThree n → IsFive (n + 2) := by
  intro three
  cases three with
  | isThree => skip
```
-- In the remaining case, {anchorName threePlusTwoFive2}`n` has been refined to {anchorTerm IsThree}`3`:

在剩余情况下，{anchorName threePlusTwoFive2}`n` 已细化为 {anchorTerm IsThree}`3`：

```anchorError threePlusTwoFive2
unsolved goals
case isThree
⊢ IsFive (3 + 2)
```
-- Because {anchorTerm various}`3 + 2` is definitionally equal to {anchorTerm IsFive}`5`, the constructor is now applicable:

由于 {anchorTerm various}`3 + 2` 在定义上等于 {anchorTerm IsFive}`5`，因此构造子现在适用了：

```anchor threePlusTwoFive3
theorem three_plus_two_five : IsThree n → IsFive (n + 2) := by
  intro three
  cases three with
  | isThree => constructor
```

-- The standard false proposition {anchorName various}`False` has no constructors, making it impossible to provide direct evidence for.
-- The only way to provide evidence for {anchorName various}`False` is if an assumption is itself impossible, similarly to how {kw}`nomatch` can be used to mark code that the type system can see is unreachable.
-- As described in {ref "connectives"}[the initial Interlude on proofs], the negation {anchorTerm various}`Not A` is short for {anchorTerm various}`A → False`.
-- {anchorTerm various}`Not A` can also be written {anchorTerm various}`¬A`.

标准假命题 {anchorName various}`False` 没有构造子，因此无法提供直接证据。
为 {anchorName various}`False` 提供证据的唯一方法是假设本身不可能，类似于用 {kw}`nomatch`
来标记类型系统认为无法访问的代码。如 {ref "connectives"}[插曲中的证明一节]
所述，否定 {anchorTerm various}`Not A` 是 {anchorTerm various}`A → False` 的缩写。{anchorTerm various}`Not A` 也可以写成 {anchorTerm various}`¬A`。

-- It is not the case that four is three:

四不是三：

```anchor fourNotThree0
theorem four_is_not_three : ¬ IsThree 4 := by
  skip
```
-- The initial proof goal contains {anchorName fourNotThree1}`Not`:

初始证明目标包含 {anchorName fourNotThree1}`Not`：

```anchorError fourNotThree0
unsolved goals
⊢ ¬IsThree 4
```
-- The fact that it's actually a function type can be exposed using {anchorTerm fourNotThree1}`unfold`:

它实际上是一个函数类型的事实可以使用 {anchorTerm fourNotThree1}`unfold` 来揭示：

```anchor fourNotThree1
theorem four_is_not_three : ¬ IsThree 4 := by
  unfold Not
```
```anchorError fourNotThree1
unsolved goals
⊢ IsThree 4 → False
```
-- Because the goal is a function type, {anchorTerm fourNotThree2}`intro` can be used to convert the argument into an assumption.
-- There is no need to keep {anchorTerm fourNotThree1}`unfold`, as {anchorTerm fourNotThree2}`intro` can unfold the definition of {anchorName fourNotThree1}`Not` itself:

因为目标是函数类型，所以可以使用 {anchorTerm fourNotThree2}`intro` 将参数转换为假设。
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
-- In this proof, the {anchorTerm fourNotThreeDone}`cases` tactic solves the goal immediately:

在此证明中，{anchorTerm fourNotThreeDone}`cases` 策略直接解决了目标：

```anchor fourNotThreeDone
theorem four_is_not_three : ¬ IsThree 4 := by
  intro h
  cases h
```
-- Just as a pattern match on a {anchorTerm otherEx (module:=Examples.DependentTypes)}`Vect String 2` doesn't need to include a case for {anchorName otherEx (module:=Examples.DependentTypes)}`Vect.nil`, a proof by cases over {anchorTerm fourNotThreeDone}`IsThree 4` doesn't need to include a case for {anchorName IsThree}`isThree`.

就像对 {anchorTerm otherEx (module:=Examples.DependentTypes)}`Vect String 2` 的模式匹配不需要包含 {anchorName otherEx (module:=Examples.DependentTypes)}`Vect.nil` 的情况一样，
对 {anchorTerm fourNotThreeDone}`IsThree 4` 的情况证明不需要包含 {anchorName IsThree}`isThree` 的情况。

-- ## Inequality of Natural Numbers
## 自然数不等式
%%%
tag := "inequality-of-natural-numbers"
%%%

-- The definition of {anchorName NatLe}`Nat.le` has a parameter and an index:

{anchorName NatLe}`Nat.le` 的定义有一个参数和一个索引：

```anchor NatLe
inductive Nat.le (n : Nat) : Nat → Prop
  | refl : Nat.le n n
  | step : Nat.le n m → Nat.le n (m + 1)
```
-- The parameter {anchorName NatLe}`n` is the number that should be smaller, while the index is the number that should be greater than or equal to {anchorName NatLe}`n`.
-- The {anchorName NatLe}`refl` constructor is used when both numbers are equal, while the {anchorName NatLe}`step` constructor is used when the index is greater than {anchorName NatLe}`n`.

参数 {anchorName NatLe}`n` 应该是较小的数字，而索引应该是大于或等于 {anchorName NatLe}`n` 的数字。
当两个数字相等时使用 {anchorName NatLe}`refl` 构造子，而当索引大于 {anchorName NatLe}`n` 时使用 {anchorName NatLe}`step` 构造子。

-- From the perspective of evidence, a proof that $`n \leq k` consists of finding some number $`d` such that $`n + d = m`.
-- In Lean, the proof then consists of a {anchorName leNames}`Nat.le.refl` constructor wrapped by $`d` instances of {anchorName leNames}`Nat.le.step`.
-- Each {anchorName NatLe}`step` constructor adds one to its index argument, so $`d` {anchorName NatLe}`step` constructors adds $`d` to the larger number.
-- For example, evidence that four is less than or equal to seven consists of three {anchorName NatLe}`step`s around a {anchorName NatLe}`refl`:

从证据的视角来看，证明 $`n \leq k` 需要找到一些数字 $`d` 使得 $`n + d = m`。
在 Lean 中，证明由 $`d` 个 {anchorName leNames}`Nat.le.step` 实例包裹的 {anchorName leNames}`Nat.le.refl` 构造子组成。
每个 {anchorName NatLe}`step` 构造子将其索引参数加一，因此 $`d` 个 {anchorName NatLe}`step` 构造子将 $`d` 加到较大的数字上。
例如，证明四小于或等于七由 {anchorName NatLe}`refl` 周围的三个 {anchorName NatLe}`step` 组成：

```anchor four_le_seven
theorem four_le_seven : 4 ≤ 7 :=
  open Nat.le in
  step (step (step refl))
```

-- The strict less-than relation is defined by adding one to the number on the left:

严格小于关系通过在左侧数字上加一来定义：

```anchor NatLt
def Nat.lt (n m : Nat) : Prop :=
  Nat.le (n + 1) m

instance : LT Nat where
  lt := Nat.lt
```
-- Evidence that four is strictly less than seven consists of two {anchorName four_lt_seven}`step`'s around a {anchorName four_lt_seven}`refl`:

证明四严格小于七由 {anchorName four_lt_seven}`refl` 周围的两个 {anchorName four_lt_seven}`step` 组成：

```anchor four_lt_seven
theorem four_lt_seven : 4 < 7 :=
  open Nat.le in
  step (step refl)
```
-- This is because {anchorTerm four_lt_seven}`4 < 7` is equivalent to {anchorTerm four_lt_seven_alt}`5 ≤ 7`.

这是因为 {anchorTerm four_lt_seven}`4 < 7` 等价于 {anchorTerm four_lt_seven_alt}`5 ≤ 7`。

-- # Proving Termination
# 证明停机性
%%%
tag := "proving-termination"
%%%

-- The function {anchorName ArrayMap}`Array.map` transforms an array with a function, returning a new array that contains the result of applying the function to each element of the input array.
-- Writing it as a tail-recursive function follows the usual pattern of delegating to a function that passes the output array in an accumulator.
-- The accumulator is initialized with an empty array.
-- The accumulator-passing helper function also takes an argument that tracks the current index into the array, which starts at {anchorTerm ArrayMap}`0`:

函数 {anchorName ArrayMap}`Array.map` 使用一个函数转换数组，返回一个新数组，其中包含将该函数应用于输入数组的每个元素的结果。
将其编写为尾递归函数遵循通常的模式，即委托给一个在累加器中传递输出数组的函数。
累加器初始化为空数组。
传递累加器的辅助函数还接受一个参数来跟踪数组中的当前索引，该索引从 {anchorTerm ArrayMap}`0` 开始：

```anchor ArrayMap
def Array.map (f : α → β) (arr : Array α) : Array β :=
  arrayMapHelper f arr Array.empty 0
```

-- The helper should, at each iteration, check whether the index is still in bounds.
-- If so, it should loop again with the transformed element added to the end of the accumulator and the index incremented by {anchorTerm mapHelperIndexIssue}`1`.
-- If not, then it should terminate and return the accumulator.
-- An initial implementation of this code fails because Lean is unable to prove that the array index is valid:

辅助函数应在每次迭代时检查索引是否仍在范围内。
如果是，它应该再次循环，将转换后的元素添加到累加器的末尾，并将索引增加 {anchorTerm mapHelperIndexIssue}`1`。
如果不是，那么它应该终止并返回累加器。
此代码的初始实现失败，因为 Lean 无法证明数组索引有效：

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
-- Lean accepts the modified program, even though the recursive call is not made on an argument to one of the input constructors.
-- In fact, both the accumulator and the index grow, rather than shrinking.

Lean 接受修改后的程序，即使递归调用不是针对输入构造子之一的参数进行的。
实际上，累加器和索引都在增长，而非缩小。

-- Behind the scenes, Lean's proof automation constructs a termination proof.
-- Reconstructing this proof can make it easier to understand the cases that Lean cannot automatically recognize.

在幕后，Lean 的证明自动化构建了一个停机性证明。
重建这个证明可以更容易地理解 Lean 无法自动识别的情况。

-- Why does {anchorName arrayMapHelperTermIssue}`arrayMapHelper` terminate?
-- Each iteration checks whether the index {anchorName arrayMapHelperTermIssue}`i` is still in bounds for the array {anchorName arrayMapHelperTermIssue}`arr`.
-- If so, {anchorName arrayMapHelperTermIssue}`i` is incremented and the loop repeats.
-- If not, the program terminates.
-- Because {anchorTerm arrayMapHelperTermIssue}`arr.size` is a finite number, {anchorName arrayMapHelperTermIssue}`i` can be incremented only a finite number of times.
-- Even though no argument to the function decreases on each call, {anchorTerm ArrayMapHelperOk}`arr.size - i` decreases toward zero.

为什么 {anchorName arrayMapHelperTermIssue}`arrayMapHelper` 会停机？
每次迭代都会检查索引 {anchorName arrayMapHelperTermIssue}`i` 是否仍在数组 {anchorName arrayMapHelperTermIssue}`arr` 的范围内。
如果是，{anchorName arrayMapHelperTermIssue}`i` 增加，循环重复。
如果不是，程序终止。
因为 {anchorTerm arrayMapHelperTermIssue}`arr.size` 是一个有限的数字，{anchorName arrayMapHelperTermIssue}`i` 只能增加有限次。
即使每次调用时函数的参数都没有减少，{anchorTerm ArrayMapHelperOk}`arr.size - i` 也会向零减少。

-- The value that decreases at each recursive call is called a _measure_.
-- Lean can be instructed to use a specific expression as the measure of termination by providing a {kw}`termination_by` clause at the end of a definition.
-- For {anchorName ArrayMapHelperOk}`arrayMapHelper`, the explicit measure looks like this:

每次递归调用时减小的值称为 *度量（Measure）*。
可以通过在定义末尾提供 {kw}`termination_by` 子句来指示 Lean 使用特定表达式作为停机度量。
对于 {anchorName ArrayMapHelperOk}`arrayMapHelper`，显式度量如下所示：

```anchor ArrayMapHelperOk
def arrayMapHelper (f : α → β) (arr : Array α)
    (soFar : Array β) (i : Nat) : Array β :=
  if inBounds : i < arr.size then
    arrayMapHelper f arr (soFar.push (f arr[i])) (i + 1)
  else soFar
termination_by arr.size - i
```

-- A similar termination proof can be used to write {anchorName ArrayFind}`Array.find`, a function that finds the first element in an array that satisfies a Boolean function and returns both the element and its index:

类似的停机证明可用于编写 {anchorName ArrayFind}`Array.find`，该函数查找数组中满足布尔函数的第一个元素，并返回该元素及其索引：

```anchor ArrayFind
def Array.find (arr : Array α) (p : α → Bool) :
    Option (Nat × α) :=
  findHelper arr p 0
```
-- Once again, the helper function terminates because {lit}`arr.size - i` decreases as {lit}`i` increases:

同样，辅助函数会停机，因为随着 {lit}`i` 的增加，{lit}`arr.size - i` 会减少：

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

-- Adding a question mark to {kw}`termination_by` (that is, using {kw}`termination_by?`) causes Lean to explicitly suggest the measure that it chose:

在 {kw}`termination_by` 后添加问号（即使用 {kw}`termination_by?`）会让 Lean 显式建议它选择的度量：

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

-- Not all termination arguments are as quite as simple as this one.
-- However, the basic structure of identifying some expression based on the function's arguments that will decrease in each call occurs in all termination proofs.
-- Sometimes, creativity can be required in order to figure out just why a function terminates, and sometimes Lean requires additional proofs in order to accept that the measure in fact decreases.

并非所有的停机论证都像这个这么简单。
然而，基于函数参数识别出某个在每次调用中都会减小的表达式，这种基本结构出现在所有停机证明中。
有时，需要创造力才能弄清楚函数为何停机，有时 Lean 需要额外的证明才能接受度量实际上在减小。



-- # Exercises
# 练习
%%%
tag := "array-termination-exercises"
%%%

--  * Implement a {anchorTerm ForMArr}`ForM m (Array α)` instance on arrays using a tail-recursive accumulator-passing function and a {kw}`termination_by` clause.
--  * Reimplement {anchorName ArrayMap}`Array.map`, {anchorName ArrayFind}`Array.find`, and the {anchorName ForMArr}`ForM` instance using {kw}`for`{lit}` ... `{kw}`in`{lit}` ...` loops in the identity monad and compare the resulting code.
--  * Reimplement array reversal using a {kw}`for`{lit}` ... `{kw}`in`{lit}` ...` loop in the identity monad. Compare it to the tail-recursive function.

 * 使用尾递归累加器传递函数和 {kw}`termination_by` 子句在数组上实现 {anchorTerm ForMArr}`ForM m (Array α)` 实例。
 * 在恒等单子中使用 {kw}`for`{lit}` ... `{kw}`in`{lit}` ...` 循环重新实现 {anchorName ArrayMap}`Array.map`、{anchorName ArrayFind}`Array.find` 和 {anchorName ForMArr}`ForM` 实例，并比较生成的代码。
 * 在恒等单子中使用 {kw}`for`{lit}` ... `{kw}`in`{lit}` ...` 循环重新实现数组反转。将其与尾递归函数进行比较。
