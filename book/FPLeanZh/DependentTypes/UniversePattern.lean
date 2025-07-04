import VersoManual
import FPLeanZh.Examples

open Verso.Genre Manual
open Verso.Code.External

open FPLeanZh

set_option verso.exampleProject "../examples"
set_option verso.exampleModule "Examples.DependentTypes.Finite"

#doc (Manual) "宇宙设计模式" =>

-- In Lean, types such as {anchorTerm sundries}`Type`, {anchorTerm sundries}`Type 3`, and {anchorTerm sundries}`Prop` that classify other types are known as universes.
-- However, the term _universe_ is also used for a design pattern in which a datatype is used to represent a subset of Lean's types, and a function converts the datatype's constructors into actual types.
-- The values of this datatype are called _codes_ for their types.

在 Lean 中，像 {anchorTerm sundries}`Type`、{anchorTerm sundries}`Type 3` 和 {anchorTerm sundries}`Prop` 这样对其他类型进行分类的类型被称为宇宙。
然而，术语__宇宙__也用于一种设计模式，其中数据类型用于表示 Lean 类型的一个子集，并且一个函数将数据类型的构造函数转换为实际类型。
这种数据类型的值被称为其类型的__代码__。

-- Just like Lean's built-in universes, the universes implemented with this pattern are types that describe some collection of available types, even though the mechanism by which it is done is different.
-- In Lean, there are types such as {anchorTerm sundries}`Type`, {anchorTerm sundries}`Type 3`, and {anchorTerm sundries}`Prop` that directly describe other types.
-- This arrangement is referred to as {deftech}_universes à la Russell_.
-- The user-defined universes described in this section represent all of their types as _data_, and include an explicit function to interpret these codes into actual honest-to-goodness types.
-- This arrangement is referred to as {deftech}_universes à la Tarski_.
-- While languages such as Lean that are based on dependent type theory almost always use Russell-style universes, Tarski-style universes are a useful pattern for defining APIs in these languages.

就像 Lean 的内置宇宙一样，用这种模式实现的宇宙是描述可用类型集合的类型，尽管其实现机制不同。
在 Lean 中，有像 {anchorTerm sundries}`Type`、{anchorTerm sundries}`Type 3` 和 {anchorTerm sundries}`Prop` 这样直接描述其他类型的类型。
这种安排被称为 {deftech}__罗素式宇宙__。
本节描述的用户定义宇宙将其所有类型表示为__数据__，并包含一个显式函数来将这些代码解释为实际的真实类型。
这种安排被称为 {deftech}__塔斯基式宇宙__。
虽然像 Lean 这样基于依赖类型理论的语言几乎总是使用罗素式宇宙，但塔斯基式宇宙是这些语言中定义 API 的有用模式。

-- Defining a custom universe makes it possible to carve out a closed collection of types that can be used with an API.
-- Because the collection of types is closed, recursion over the codes allows programs to work for _any_ type in the universe.
-- One example of a custom universe has the codes {anchorName NatOrBool}`nat`, standing for {anchorName NatOrBool}`Nat`, and {anchorName NatOrBool}`bool`, standing for {anchorName NatOrBool}`Bool`:

定义自定义宇宙使得可以划分出一个封闭的类型集合，该集合可以与 API 一起使用。
由于类型集合是封闭的，因此对代码的递归允许程序适用于宇宙中的__任何__类型。
自定义宇宙的一个例子是代码 {anchorName NatOrBool}`nat`（代表 {anchorName NatOrBool}`Nat`）和 {anchorName NatOrBool}`bool`（代表 {anchorName NatOrBool}`Bool`）：

```anchor NatOrBool
inductive NatOrBool where
  | nat | bool

abbrev NatOrBool.asType (code : NatOrBool) : Type :=
  match code with
  | .nat => Nat
  | .bool => Bool
```

-- Pattern matching on a code allows the type to be refined, just as pattern matching on the constructors of {moduleName (module := Examples.DependentTypes)}`Vect` allows the expected length to be refined.
-- For instance, a program that deserializes the types in this universe from a string can be written as follows:

对代码进行模式匹配允许细化类型，就像对 {moduleName (module := Examples.DependentTypes)}`Vect` 的构造函数进行模式匹配允许细化预期长度一样。
例如，一个从字符串反序列化此宇宙中类型的程序可以这样编写：

```anchor decode
def decode (t : NatOrBool) (input : String) : Option t.asType :=
  match t with
  | .nat => input.toNat?
  | .bool =>
    match input with
    | "true" => some true
    | "false" => some false
    | _ => none
```

-- Dependent pattern matching on {anchorName decode}`t` allows the expected result type {anchorTerm decode}`t.asType` to be respectively refined to {anchorTerm natOrBoolExamples}`NatOrBool.nat.asType` and {anchorTerm natOrBoolExamples}`NatOrBool.bool.asType`, and these compute to the actual types {anchorName NatOrBool}`Nat` and {anchorName NatOrBool}`Bool`.

对 {anchorName decode}`t` 的依赖模式匹配允许将预期结果类型 {anchorTerm decode}`t.asType` 分别细化为 {anchorTerm natOrBoolExamples}`NatOrBool.nat.asType` 和 {anchorTerm natOrBoolExamples}`NatOrBool.bool.asType`，这些计算结果为实际类型 {anchorName NatOrBool}`Nat` 和 {anchorName NatOrBool}`Bool`。

-- Like any other data, codes may be recursive.
-- The type {anchorName NestedPairs}`NestedPairs` codes for any possible nesting of the pair and natural number types:

像任何其他数据一样，代码可以是递归的。
类型 {anchorName NestedPairs}`NestedPairs` 编码了对和自然数类型的任何可能嵌套：

```anchor NestedPairs
inductive NestedPairs where
  | nat : NestedPairs
  | pair : NestedPairs → NestedPairs → NestedPairs

abbrev NestedPairs.asType : NestedPairs → Type
  | .nat => Nat
  | .pair t1 t2 => asType t1 × asType t2
```

-- In this case, the interpretation function {anchorName NestedPairs}`NestedPairs.asType` is recursive.
-- This means that recursion over codes is required in order to implement {anchorName NestedPairsbeq}`BEq` for the universe:

在这种情况下，解释函数 {anchorName NestedPairs}`NestedPairs.asType` 是递归的。
这意味着为了实现宇宙的 {anchorName NestedPairsbeq}`BEq`，需要对代码进行递归：

```anchor NestedPairsbeq
def NestedPairs.beq (t : NestedPairs) (x y : t.asType) : Bool :=
  match t with
  | .nat => x == y
  | .pair t1 t2 => beq t1 x.fst y.fst && beq t2 x.snd y.snd

instance {t : NestedPairs} : BEq t.asType where
  beq x y := t.beq x y
```

-- Even though every type in the {anchorName beqNoCases}`NestedPairs` universe already has a {anchorName beqNoCases}`BEq` instance, type class search does not automatically check every possible case of a datatype in an instance declaration, because there might be infinitely many such cases, as with {anchorName beqNoCases}`NestedPairs`.
-- Attempting to appeal directly to the {anchorName beqNoCases}`BEq` instances rather than explaining to Lean how to find them by recursion on the codes results in an error:

尽管 {anchorName beqNoCases}`NestedPairs` 宇宙中的每种类型都已有一个 {anchorName beqNoCases}`BEq` 实例，但类型类搜索不会自动检查实例声明中数据类型的每种可能情况，因为可能存在无限多种情况，就像 {anchorName beqNoCases}`NestedPairs` 一样。
尝试直接引用 {anchorName beqNoCases}`BEq` 实例而不是向 Lean 解释如何通过对代码的递归找到它们会导致错误：


```anchor beqNoCases
instance {t : NestedPairs} : BEq t.asType where
  beq x y := x == y
```
```anchorError beqNoCases
failed to synthesize
  BEq t.asType

Additional diagnostic information may be available using the `set_option diagnostics true` command.
```

-- The {anchorName beqNoCases}`t` in the error message stands for an unknown value of type {anchorName beqNoCases}`NestedPairs`.

错误消息中的 {anchorName beqNoCases}`t` 代表类型 {anchorName beqNoCases}`NestedPairs` 的未知值。

-- # Type Classes vs Universes

# 类型类与宇宙

-- Type classes allow an open-ended collection of types to be used with an API as long as they have implementations of the necessary interfaces.
-- In most cases, this is preferable.
-- It is hard to predict all use cases for an API ahead of time, and type classes are a convenient way to allow library code to be used with more types than the original author expected.

类型类允许开放式类型集合与 API 一起使用，只要它们具有必要接口的实现。
在大多数情况下，这是首选。
很难提前预测 API 的所有用例，而类型类是一种方便的方式，允许库代码与比原始作者预期更多的类型一起使用。

-- A universe à la Tarski, on the other hand, restricts the API to be usable only with a predetermined collection of types.
-- This is useful in a few situations:
--  * When a function should act very differently depending on which type it is passed—it is impossible to pattern match on types themselves, but pattern matching on codes for types is allowed
--  * When an external system inherently limits the types of data that may be provided, and extra flexibility is not desired
--  * When additional properties of a type are required over and above the implementation of some operations

另一方面，塔斯基式宇宙将 API 限制为只能与预定类型的集合一起使用。
这在以下几种情况下很有用：
 * 当函数应根据传递的类型而表现出非常不同的行为时——不可能对类型本身进行模式匹配，但允许对类型代码进行模式匹配
 * 当外部系统固有地限制了可以提供的数据类型，并且不需要额外的灵活性时
 * 当除了某些操作的实现之外，还需要类型的附加属性时

-- Type classes are useful in many of the same situations as interfaces in Java or C#, while a universe à la Tarski can be useful in cases where a sealed class might be used, but where an ordinary inductive datatype is not usable.

类型类在许多情况下与 Java 或 C# 中的接口一样有用，而塔斯基式宇宙在可能使用密封类但普通归纳数据类型不可用的情况下可能很有用。

-- # A Universe of Finite Types

# 有限类型宇宙

-- Restricting the types that can be used with an API to a predetermined collection can enable operations that would be impossible for an open-ended API.
-- For example, functions can't normally be compared for equality.
-- Functions should be considered equal when they map the same inputs to the same outputs.
-- Checking this could take infinite amounts of time, because comparing two functions with type {anchorTerm sundries}`Nat → Bool` would require checking that the functions returned the same {anchorName sundries}`Bool` for each and every {anchorName sundries}`Nat`.

将可与 API 一起使用的类型限制为预定集合可以启用开放式 API 不可能实现的操作。
例如，函数通常无法比较相等性。
当函数将相同的输入映射到相同的输出时，应认为它们相等。
检查这可能需要无限量的时间，因为比较两个类型为 {anchorTerm sundries}`Nat → Bool` 的函数需要检查这些函数是否对每个 {anchorName sundries}`Nat` 都返回相同的 {anchorName sundries}`Bool`。

-- In other words, a function from an infinite type is itself infinite.
-- Functions can be viewed as tables, and a function whose argument type is infinite requires infinitely many rows to represent each case.
-- But functions from finite types require only finitely many rows in their tables, making them finite.
-- Two functions whose argument type is finite can be checked for equality by enumerating all possible arguments, calling the functions on each of them, and then comparing the results.
-- Checking higher-order functions for equality requires generating all possible functions of a given type, which additionally requires that the return type is finite so that each element of the argument type can be mapped to each element of the return type.
-- This is not a _fast_ method, but it does complete in finite time.

换句话说，来自无限类型的函数本身就是无限的。
函数可以看作是表，其参数类型为无限的函数需要无限多行来表示每种情况。
但是来自有限类型的函数只需要其表中有限多行，这使得它们是有限的。
两个参数类型为有限的函数可以通过枚举所有可能的参数，对每个参数调用函数，然后比较结果来检查相等性。
检查高阶函数的相等性需要生成给定类型的所有可能函数，这还要求返回类型是有限的，以便参数类型的每个元素都可以映射到返回类型的每个元素。
这不是一种__快速__方法，但它确实在有限时间内完成。

-- One way to represent finite types is by a universe:

表示有限类型的一种方法是使用宇宙：

```anchor Finite
inductive Finite where
  | unit : Finite
  | bool : Finite
  | pair : Finite → Finite → Finite
  | arr : Finite → Finite → Finite

abbrev Finite.asType : Finite → Type
  | .unit => Unit
  | .bool => Bool
  | .pair t1 t2 => asType t1 × asType t2
  | .arr dom cod => asType dom → asType cod
```

-- In this universe, the constructor {anchorName Finite}`arr` stands for the function type, which is written with an {anchorName Finite}`arr`ow.

在这个宇宙中，构造函数 {anchorName Finite}`arr` 代表函数类型，它用 {anchorName Finite}`arr`ow 表示。

-- :::paragraph
-- Comparing two values from this universe for equality is almost the same as in the {anchorName NestedPairs}`NestedPairs` universe.
-- The only important difference is the addition of the case for {anchorName Finite}`arr`, which uses a helper called {anchorName FiniteAll}`Finite.enumerate` to generate every value from the type coded for by {anchorName FiniteBeq}`dom`, checking that the two functions return equal results for every possible input:

比较此宇宙中的两个值是否相等与 {anchorName NestedPairs}`NestedPairs` 宇宙中几乎相同。
唯一重要的区别是增加了 {anchorName Finite}`arr` 的情况，它使用一个名为 {anchorName FiniteAll}`Finite.enumerate` 的辅助函数来生成由 {anchorName FiniteBeq}`dom` 编码的类型中的每个值，检查这两个函数是否对每个可能的输入返回相等的结果：

```anchor FiniteBeq
def Finite.beq (t : Finite) (x y : t.asType) : Bool :=
  match t with
  | .unit => true
  | .bool => x == y
  | .pair t1 t2 => beq t1 x.fst y.fst && beq t2 x.snd y.snd
  | .arr dom cod =>
    dom.enumerate.all fun arg => beq cod (x arg) (y arg)
```

-- The standard library function {anchorName sundries}`List.all` checks that the provided function returns {anchorName sundries}`true` on every entry of a list.
-- This function can be used to compare functions on the Booleans for equality:

标准库函数 {anchorName sundries}`List.all` 检查提供的函数是否对列表的每个条目返回 {anchorName sundries}`true`。
此函数可用于比较布尔函数是否相等：

```anchor arrBoolBoolEq
#eval Finite.beq (.arr .bool .bool) (fun _ => true) (fun b => b == b)
```
```anchorInfo arrBoolBoolEq
true
```

-- It can also be used to compare functions from the standard library:

它也可以用于比较标准库中的函数：

```anchor arrBoolBoolEq2
#eval Finite.beq (.arr .bool .bool) (fun _ => true) not
```
```anchorInfo arrBoolBoolEq2
false
```

-- It can even compare functions built using tools such as function composition:

它甚至可以比较使用函数组合等工具构建的函数：

```anchor arrBoolBoolEq3
#eval Finite.beq (.arr .bool .bool) id (not ∘ not)
```
```anchorInfo arrBoolBoolEq3
true
```

-- This is because the {anchorName Finite}`Finite` universe codes for Lean's _actual_ function type, not a special analogue created by the library.

这是因为 {anchorName Finite}`Finite` 宇宙编码的是 Lean 的__实际__函数类型，而不是库创建的特殊模拟。
:::

-- The implementation of {anchorName FiniteAll}`enumerate` is also by recursion on the codes from {anchorName FiniteAll}`Finite`.

{anchorName FiniteAll}`enumerate` 的实现也是通过对 {anchorName FiniteAll}`Finite` 的代码进行递归。

```anchor FiniteAll
  def Finite.enumerate (t : Finite) : List t.asType :=
    match t with
```

-- In the case for {anchorName Finite}`Unit`, there is only a single value.
-- In the case for {anchorName Finite}`Bool`, there are two values to return ({anchorName sundries}`true` and {anchorName sundries}`false`).
-- In the case for pairs, the result should be the Cartesian product of the values for the type coded for by {anchorName FiniteAll}`t1` and the values for the type coded for by {anchorName FiniteAll}`t2`.
-- In other words, every value from {anchorName FiniteAll}`dom` should be paired with every value from {anchorName FiniteAll}`cod`.
-- The helper function {anchorName ListProduct}`List.product` can certainly be written with an ordinary recursive function, but here it is defined using {kw}`for` in the identity monad:

对于 {anchorName Finite}`Unit` 的情况，只有一个值。
对于 {anchorName Finite}`Bool` 的情况，有两个值要返回（{anchorName sundries}`true` 和 {anchorName sundries}`false`）。
对于对的情况，结果应该是 {anchorName FiniteAll}`t1` 编码的类型的值和 {anchorName FiniteAll}`t2` 编码的类型的值的笛卡尔积。
换句话说，{anchorName FiniteAll}`dom` 中的每个值都应该与 {anchorName FiniteAll}`cod` 中的每个值配对。
辅助函数 {anchorName ListProduct}`List.product` 当然可以用普通的递归函数编写，但这里它是在恒等单子中使用 {kw}`for` 定义的：

```anchor ListProduct
def List.product (xs : List α) (ys : List β) : List (α × β) := Id.run do
  let mut out : List (α × β) := []
  for x in xs do
    for y in ys do
      out := (x, y) :: out
  pure out.reverse
```

-- Finally, the case of {anchorName FiniteAll}`Finite.enumerate` for functions delegates to a helper called {anchorName FiniteFunctionSigStart}`Finite.functions` that takes a list of all of the return values to target as an argument.

最后，{anchorName FiniteAll}`Finite.enumerate` 的函数情况委托给一个名为 {anchorName FiniteFunctionSigStart}`Finite.functions` 的辅助函数，该函数接受所有目标返回值列表作为参数。

-- Generally speaking, generating all of the functions from some finite type to a collection of result values can be thought of as generating the functions' tables.
-- Each function assigns an output to each input, which means that a given function has $`k` rows in its table when there are $`k` possible arguments.
-- Because each row of the table could select any of $`n` possible outputs, there are $`n ^ k` potential functions to generate.

一般来说，从某个有限类型生成所有函数到结果值集合可以看作是生成函数的表。
每个函数为每个输入分配一个输出，这意味着当有 $`k` 个可能的参数时，给定函数在其表中具有 $`k` 行。
因为表的每一行都可以选择 $`n` 个可能的输出中的任何一个，所以有 $`n ^ k` 个潜在函数可以生成。

-- Once again, generating the functions from a finite type to some list of values is recursive on the code that describes the finite type:

再次，从有限类型生成函数到某个值列表是关于描述有限类型的代码的递归：

```anchor FiniteFunctionSigStart
def Finite.functions
    (t : Finite)
    (results : List α) : List (t.asType → α) :=
  match t with
```

-- The table for functions from {anchorName Finite}`Unit` contains one row, because the function can't pick different results based on which input it is provided.
-- This means that one function is generated for each potential input.

来自 {anchorName Finite}`Unit` 的函数的表包含一行，因为函数不能根据提供的输入选择不同的结果。
这意味着为每个潜在输入生成一个函数。

```anchor FiniteFunctionUnit
| .unit =>
  results.map fun r =>
    fun () => r
```

-- There are $`n^2` functions from {anchorName sundries}`Bool` when there are $`n` result values, because each individual function of type {anchorTerm sundries}`Bool → α` uses the {anchorName sundries}`Bool` to select between two particular {anchorName sundries}`α`s:

当有 $`n` 个结果值时，来自 {anchorName sundries}`Bool` 的函数有 $`n^2` 个，因为类型为 {anchorTerm sundries}`Bool → α` 的每个单独函数都使用 {anchorName sundries}`Bool` 在两个特定的 {anchorName sundries}`α` 之间进行选择：

```anchor FiniteFunctionBool
| .bool =>
  (results.product results).map fun (r1, r2) =>
    fun
      | true => r1
      | false => r2
```

-- Generating the functions from pairs can be achieved by taking advantage of currying.
-- A function from a pair can be transformed into a function that takes the first element of the pair and returns a function that's waiting for the second element of the pair.
-- Doing this allows {anchorName FiniteFunctionSigStart}`Finite.functions` to be used recursively in this case:

通过利用柯里化可以生成来自对的函数。
来自对的函数可以转换为一个函数，该函数接受对的第一个元素并返回一个等待对的第二个元素的函数。
这样做允许 {anchorName FiniteFunctionSigStart}`Finite.functions` 在这种情况下递归使用：

```anchor FiniteFunctionPair
| .pair t1 t2 =>
  let f1s := t1.functions <| t2.functions results
  f1s.map fun f =>
    fun (x, y) =>
      f x y
```

-- Generating higher-order functions is a bit of a brain bender.
-- Each higher-order function takes a function as its argument.
-- This argument function can be distinguished from other functions based on its input/output behavior.
-- In general, the higher-order function can apply the argument function to every possible argument, and it can then carry out any possible behavior based on the result of applying the argument function.
-- This suggests a means of constructing the higher-order functions:
--  * Begin with a list of all possible arguments to the function that is itself an argument.
--  * For each possible argument, construct all possible behaviors that can result from the observation of applying the argument function to the possible argument. This can be done using {anchorName FiniteFunctionSigStart}`Finite.functions` and recursion over the rest of the possible arguments, because the result of the recursion represents the functions based on the observations of the rest of the possible arguments. {anchorName FiniteFunctionSigStart}`Finite.functions` constructs all the ways of achieving these based on the observation for the current argument.
--  * For potential behavior in response to these observations, construct a higher-order function that applies the argument function to the current possible argument. The result of this is then passed to the observation behavior.
--  * The base case of the recursion is a higher-order function that observes nothing for each result value—it ignores the argument function and simply returns the result value.

生成高阶函数有点烧脑。
每个高阶函数都接受一个函数作为其参数。
这个参数函数可以根据其输入/输出行为与其他函数区分开来。
通常，高阶函数可以将参数函数应用于每个可能的参数，然后根据应用参数函数的结果执行任何可能的行为。
这暗示了构造高阶函数的方法：
 * 从作为参数的函数的所有可能参数列表开始。
 * 对于每个可能的参数，构造应用参数函数到该可能参数所能产生的所有可能行为。这可以使用 {anchorName FiniteFunctionSigStart}`Finite.functions` 和对其余可能参数的递归来完成，因为递归的结果表示基于对其余可能参数的观察的函数。{anchorName FiniteFunctionSigStart}`Finite.functions` 根据对当前参数的观察构造实现这些目标的所有方法。
 * 对于响应这些观察的潜在行为，构造一个高阶函数，该函数将参数函数应用于当前可能的参数。然后将此结果传递给观察行为。
 * 递归的基本情况是一个高阶函数，它不观察每个结果值——它忽略参数函数并简单地返回结果值。

-- Defining this recursive function directly causes Lean to be unable to prove that the whole function terminates.
-- However, using a simpler form of recursion called a _right fold_ can be used to make it clear to the termination checker that the function terminates.
-- A right fold takes three arguments: a step function that combines the head of the list with the result of the recursion over the tail, a default value to return when the list is empty, and the list being processed.
-- It then analyzes the list, essentially replacing each {lit}`::` in the list with a call to the step function and replacing {lit}`[]` with the default value:

直接定义这个递归函数会导致 Lean 无法证明整个函数会终止。
然而，使用一种更简单的递归形式，称为__右折叠__，可以使终止检查器清楚地知道函数会终止。
右折叠接受三个参数：一个步进函数，它将列表的头部与尾部递归的结果结合起来；一个当列表为空时返回的默认值；以及正在处理的列表。
然后它分析列表，本质上将列表中每个 {lit}`::` 替换为对步进函数的调用，并将 {lit}`[]` 替换为默认值：

```anchor foldr
def List.foldr (f : α → β → β) (default : β) : List α → β
  | []     => default
  | a :: l => f a (foldr f default l)
```

-- Finding the sum of the {anchorName sundries}`Nat`s in a list can be done with {anchorName foldrSum}`foldr`:

查找列表中 {anchorName sundries}`Nat` 的和可以使用 {anchorName foldrSum}`foldr` 完成：

```anchorEvalSteps foldrSum
[1, 2, 3, 4, 5].foldr (· + ·) 0
===>
(1 :: 2 :: 3 :: 4 :: 5 :: []).foldr (· + ·) 0
===>
(1 + 2 + 3 + 4 + 5 + 0)
===>
15
```

-- With {anchorName foldrSum}`foldr`, the higher-order functions can be created as follows:

使用 {anchorName foldrSum}`foldr`，高阶函数可以按如下方式创建：

```anchor FiniteFunctionArr
    | .arr t1 t2 =>
      let args := t1.enumerate
      let base :=
        results.map fun r =>
          fun _ => r
      args.foldr
        (fun arg rest =>
          (t2.functions rest).map fun more =>
            fun f => more (f arg) f)
        base
```

-- The complete definition of {anchorName FiniteFunctions}`Finite.functions` is:

{anchorName FiniteFunctions}`Finite.functions` 的完整定义是：

```anchor FiniteFunctions
def Finite.functions
    (t : Finite)
    (results : List α) : List (t.asType → α) :=
  match t with
| .unit =>
  results.map fun r =>
    fun () => r
| .bool =>
  (results.product results).map fun (r1, r2) =>
    fun
      | true => r1
      | false => r2
| .pair t1 t2 =>
  let f1s := t1.functions <| t2.functions results
  f1s.map fun f =>
    fun (x, y) =>
      f x y
    | .arr t1 t2 =>
      let args := t1.enumerate
      let base :=
        results.map fun r =>
          fun _ => r
      args.foldr
        (fun arg rest =>
          (t2.functions rest).map fun more =>
            fun f => more (f arg) f)
        base
```

-- Because {anchorName MutualStart}`Finite.enumerate` and {anchorName FiniteFunctions}`Finite.functions` call each other, they must be defined in a {kw}`mutual` block.
-- In other words, right before the definition of {anchorName MutualStart}`Finite.enumerate` is the {kw}`mutual` keyword:

因为 {anchorName MutualStart}`Finite.enumerate` 和 {anchorName FiniteFunctions}`Finite.functions` 相互调用，所以它们必须定义在 {kw}`mutual` 块中。
换句话说，在 {anchorName MutualStart}`Finite.enumerate` 的定义之前是 {kw}`mutual` 关键字：

```anchor MutualStart
mutual
  def Finite.enumerate (t : Finite) : List t.asType :=
    match t with
```

-- and right after the definition of {anchorName FiniteFunctions}`Finite.functions` is the {kw}`end` keyword:

在 {anchorName FiniteFunctions}`Finite.functions` 的定义之后是 {kw}`end` 关键字：

```anchor MutualEnd
    | .arr t1 t2 =>
      let args := t1.enumerate
      let base :=
        results.map fun r =>
          fun _ => r
      args.foldr
        (fun arg rest =>
          (t2.functions rest).map fun more =>
            fun f => more (f arg) f)
        base
end
```

-- This algorithm for comparing functions is not particularly practical.
-- The number of cases to check grows exponentially; even a simple type like {anchorTerm lots}`((Bool × Bool) → Bool) → Bool` describes {anchorInfoText nestedFunLength}`65536` distinct functions.
-- Why are there so many?
-- Based on the reasoning above, and using $`\left| T \right|` to represent the number of values described by the type $`T`, we should expect that
-- $$`\left| \left( \left( \mathtt{Bool} \times \mathtt{Bool} \right) \rightarrow \mathtt{Bool} \right) \rightarrow \mathtt{Bool} \right|`
-- is
-- $$`2^{2^{\left| \mathtt{Bool} \times \mathtt{Bool} \right| }},`
-- which is
-- $$`2^{2^4}`
-- or 65536.
-- Nested exponentials grow quickly, and there are many higher-order functions.

这种比较函数的算法并不特别实用。
要检查的情况数量呈指数增长；即使是像 {anchorTerm lots}`((Bool × Bool) → Bool) → Bool` 这样的简单类型也描述了 {anchorInfoText nestedFunLength}`65536` 个不同的函数。
为什么有这么多？
根据上述推理，并使用 $`\left| T \right|` 表示类型 $`T` 描述的值的数量，我们应该期望
$$`\left| \left( \left( \mathtt{Bool} \times \mathtt{Bool} \right) \rightarrow \mathtt{Bool} \right) \rightarrow \mathtt{Bool} \right|`
是
$$`2^{2^{\left| \mathtt{Bool} \times \mathtt{Bool} \right| }},`
即
$$`2^{2^4}`
或 65536。
嵌套指数增长迅速，并且有许多高阶函数。

-- # Exercises

# 练习

--  * Write a function that converts any value from a type coded for by {anchorName Finite}`Finite` into a string. Functions should be represented as their tables.
--  * Add the empty type {anchorName sundries}`Empty` to {anchorName Finite}`Finite` and {anchorName FiniteBeq}`Finite.beq`.
--  * Add {anchorName sundries}`Option` to {anchorName Finite}`Finite` and {anchorName FiniteBeq}`Finite.beq`.
