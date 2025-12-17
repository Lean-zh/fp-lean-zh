import VersoManual
import FPLeanZh.Examples

open Verso.Genre Manual
open Verso.Code.External

open FPLeanZh

set_option verso.exampleProject "../examples"
set_option verso.exampleModule "Examples.DependentTypes.Finite"

#doc (Manual) "宇宙设计模式" =>
%%%
tag := "universe-pattern"
file := "UniversePattern"
%%%
-- The Universe Design Pattern

-- In Lean, types such as {anchorTerm sundries}`Type`, {anchorTerm sundries}`Type 3`, and {anchorTerm sundries}`Prop` that classify other types are known as universes.
-- However, the term _universe_ is also used for a design pattern in which a datatype is used to represent a subset of Lean's types, and a function converts the datatype's constructors into actual types.
-- The values of this datatype are called _codes_ for their types.

在 Lean 中，用于分类其他类型的类型被称为宇宙，如 {anchorTerm sundries}`Type`、{anchorTerm sundries}`Type 3` 和 {anchorTerm sundries}`Prop` 等。
然而，*宇宙（universe）* 也用于表示一种设计模式：使用数据类型来表示 Lean 类型的子集，并通过一个解释函数将数据类型的构造子映射为实际类型。
这种数据类型的值被称为其映射到的类型的 *编码（codes）*。

-- Just like Lean's built-in universes, the universes implemented with this pattern are types that describe some collection of available types, even though the mechanism by which it is done is different.
-- In Lean, there are types such as {anchorTerm sundries}`Type`, {anchorTerm sundries}`Type 3`, and {anchorTerm sundries}`Prop` that directly describe other types.
-- This arrangement is referred to as {deftech}_universes à la Russell_.
-- The user-defined universes described in this section represent all of their types as _data_, and include an explicit function to interpret these codes into actual honest-to-goodness types.
-- This arrangement is referred to as {deftech}_universes à la Tarski_.
-- While languages such as Lean that are based on dependent type theory almost always use Russell-style universes, Tarski-style universes are a useful pattern for defining APIs in these languages.

尽管实现方式不同。使用这种设计模式实现的宇宙是一组类型的类型，与 Lean 内置的宇宙具有相同的含义。
在 Lean 中，{anchorTerm sundries}`Type`、{anchorTerm sundries}`Type 3` 和 {anchorTerm sundries}`Prop` 等类型直接描述其他类型的类型。
这种方式被称为 {deftech}*Russell 风格的宇宙（universes à la Russell）*。
本节中描述的用户定义的宇宙将所有其包含的类型表示为 *数据*，并用一个显式的函数将这些编码映射到实际的类型。
这种方式被称为 {deftech}*Tarski 风格的宇宙（universes à la Tarski）*。
基于依值类型理论的语言（如 Lean）几乎总是使用 Russell 风格的宇宙，而 Tarski 风格的宇宙是这些语言中定义 API 的有用模式。

-- Defining a custom universe makes it possible to carve out a closed collection of types that can be used with an API.
-- Because the collection of types is closed, recursion over the codes allows programs to work for _any_ type in the universe.
-- One example of a custom universe has the codes {anchorName NatOrBool}`nat`, standing for {anchorName NatOrBool}`Nat`, and {anchorName NatOrBool}`bool`, standing for {anchorName NatOrBool}`Bool`:

自定义宇宙使得我们可以划分出一组可以与 API 一起使用的类型的封闭集合。
因为这个集合是封闭的，因此只需要对编码的递归就能使程序适用于该宇宙中的 *任何* 类型。
下面是一个自定义宇宙的例子。它包括具有编码 {anchorName NatOrBool}`nat`（代表 {anchorName NatOrBool}`Nat`）和 {anchorName NatOrBool}`bool`（代表 {anchorName NatOrBool}`Bool`）的数据类型：

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

对编码进行模式匹配允许类型被细化，就像对 {moduleName (module := Examples.DependentTypes)}`Vect` 的构造子进行模式匹配会细化其长度一样。
例如，一个从字符串反序列化此宇宙中的类型的值的程序如下：

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

对 {anchorName decode}`t` 进行依值模式匹配允许将期望的结果类型 {anchorTerm decode}`t.asType` 分别细化为 {anchorTerm natOrBoolExamples}`NatOrBool.nat.asType` 和 {anchorTerm natOrBoolExamples}`NatOrBool.bool.asType`，并且这些计算为实际的类型 {anchorName NatOrBool}`Nat` 和 {anchorName NatOrBool}`Bool`。

-- Like any other data, codes may be recursive.
-- The type {anchorName NestedPairs}`NestedPairs` codes for any possible nesting of the pair and natural number types:

与任何其他数据一样，编码可能是递归的。
类型 {anchorName NestedPairs}`NestedPairs` 编码了任意嵌套的自然数有序对：

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

在这种情况下，解释函数 {anchorName NestedPairs}`NestedPairs.asType` 是递归定义的。
这意味着需要对编码进行递归才能实现该宇宙的 {anchorName NestedPairsbeq}`BEq`：

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

尽管 {anchorName beqNoCases}`NestedPairs` 宇宙中的每种类型已经有一个 {anchorName beqNoCases}`BEq` 实例，但类型类的搜索不会在实例声明中自动检查数据类型的所有情形，因为这样的情形可能有无限多种，就像 {anchorName beqNoCases}`NestedPairs` 一样。
试图直接诉诸 {anchorName beqNoCases}`BEq` 实例，而不是通过对编码进行递归来向 Lean 解释如何找到它们，会导致错误：

```anchor beqNoCases
instance {t : NestedPairs} : BEq t.asType where
  beq x y := x == y
```
```anchorError beqNoCases
failed to synthesize
  BEq t.asType

Hint: Additional diagnostic information may be available using the `set_option diagnostics true` command.
```
-- The {anchorName beqNoCases}`t` in the error message stands for an unknown value of type {anchorName beqNoCases}`NestedPairs`.

错误信息中的 {anchorName beqNoCases}`t` 代表类型 {anchorName beqNoCases}`NestedPairs` 的未知值。

-- # Type Classes vs Universes
# 类型类与宇宙
%%%
tag := "type-classes-vs-universe-pattern"
%%%

-- Type classes allow an open-ended collection of types to be used with an API as long as they have implementations of the necessary interfaces.
-- In most cases, this is preferable.
-- It is hard to predict all use cases for an API ahead of time, and type classes are a convenient way to allow library code to be used with more types than the original author expected.

类型类使得 API 可以被用在任何类型上，只要这些类型实现了必要的接口。
在大多数情况下，这是更合适的做法，因为很难提前预测 API 的所有用例。
类型类允许库代码被原始作者预期之外的更多类型使用。

-- A universe à la Tarski, on the other hand, restricts the API to be usable only with a predetermined collection of types.
-- This is useful in a few situations:
--  * When a function should act very differently depending on which type it is passed—it is impossible to pattern match on types themselves, but pattern matching on codes for types is allowed
--  * When an external system inherently limits the types of data that may be provided, and extra flexibility is not desired
--  * When additional properties of a type are required over and above the implementation of some operations

Tarski 风格的宇宙使得 API 仅能用在实现决定好的一组类型上。在一些情况下，这是有用的：
 * 当一个函数应该根据传递的类型不同而有非常不同的表现时—无法对类型本身进行模式匹配，但可以对类型的编码进行模式匹配；
 * 当外部系统本身就限制了可能提供的数据类型，并且不需要额外的灵活性；
 * 当实现某些操作需要类型的一些额外属性时。

-- Type classes are useful in many of the same situations as interfaces in Java or C#, while a universe à la Tarski can be useful in cases where a sealed class might be used, but where an ordinary inductive datatype is not usable.

类型类在类似 Java 或 C# 中适合使用接口的场景下更加有用，而 Tarski 风格的宇宙则在类似适合使用封闭类（sealed class）的场景下，且一般的归纳定义数据类型无法使用的情况下更加有用。

-- # A Universe of Finite Types
# 一个有限类型的宇宙
%%%
tag := "finite-type-universe"
%%%

-- Restricting the types that can be used with an API to a predetermined collection can enable operations that would be impossible for an open-ended API.
-- For example, functions can't normally be compared for equality.
-- Functions should be considered equal when they map the same inputs to the same outputs.
-- Checking this could take infinite amounts of time, because comparing two functions with type {anchorTerm sundries}`Nat → Bool` would require checking that the functions returned the same {anchorName sundries}`Bool` for each and every {anchorName sundries}`Nat`.

将 API 限制为只能用于给定的类型允许 API 实现通常情况下不可能的操作。
例如，比较函数是否相等。两个函数相等定义为它们总是将相同的输入映射到相同的输出时。
检查这一点可能需要无限长的时间，例如比较两个类型为 {anchorTerm sundries}`Nat → Bool` 的函数需要检查函数对每个 {anchorName sundries}`Nat` 返回相同的 {anchorName sundries}`Bool`。

-- In other words, a function from an infinite type is itself infinite.
-- Functions can be viewed as tables, and a function whose argument type is infinite requires infinitely many rows to represent each case.
-- But functions from finite types require only finitely many rows in their tables, making them finite.
-- Two functions whose argument type is finite can be checked for equality by enumerating all possible arguments, calling the functions on each of them, and then comparing the results.
-- Checking higher-order functions for equality requires generating all possible functions of a given type, which additionally requires that the return type is finite so that each element of the argument type can be mapped to each element of the return type.
-- This is not a _fast_ method, but it does complete in finite time.

换句话说，参数类型为无限类型的函数本身也是无限类型。
函数可以被视为表格，参数类型为无限类型的函数需要无限多行来描述每种情形。
但参数类型为有限类型的函数只需要有限行，意味着该函数类型也是有限类型。
如果两个函数的参数类型均为有限类型，则可以通过枚举参数所有的可能性，然后比较它们在所有这些输入下的输出结果来检查它们是否相等。
检查高阶函数是否相等需要生成给定类型的所有可能函数，此外还需要返回类型是有限的，以便将参数类型的每个元素映射到返回类型的每个元素。
这不是一种 *快速* 的方法，但它确实在有限时间内完成。

-- One way to represent finite types is by a universe:

表示有限类型的一种方法是定义一个宇宙：

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

在这个宇宙中，构造子 {anchorName Finite}`arr` 表示函数类型（因为函数的箭头符号叫做 {anchorName Finite}`arr` ow）。

-- Comparing two values from this universe for equality is almost the same as in the {anchorName NestedPairs}`NestedPairs` universe.
-- The only important difference is the addition of the case for {anchorName Finite}`arr`, which uses a helper called {anchorName FiniteAll}`Finite.enumerate` to generate every value from the type coded for by {anchorName FiniteBeq}`dom`, checking that the two functions return equal results for every possible input:

比较这个宇宙中的两个值是否相等与 {anchorName NestedPairs}`NestedPairs` 宇宙中几乎相同。
唯一重要的区别是增加了 {anchorName Finite}`arr` 的情形，它使用一个名为 {anchorName FiniteAll}`Finite.enumerate` 的辅助函数来生成由 {anchorName FiniteBeq}`dom` 编码的类型的每个值，然后检查两个函数对每个可能的输入返回相同的结果：

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

标准库函数 {anchorName sundries}`List.all` 检查提供的函数在列表的每个条目上返回 {anchorName sundries}`true`。
这个函数可以用来比较布尔值上的函数是否相等：

```anchor arrBoolBoolEq
#eval Finite.beq (.arr .bool .bool) (fun _ => true) (fun b => b == b)
```
```anchorInfo arrBoolBoolEq
true
```
-- It can also be used to compare functions from the standard library:

它也可以用来比较标准库中的函数：

```anchor arrBoolBoolEq2
#eval Finite.beq (.arr .bool .bool) (fun _ => true) not
```
```anchorInfo arrBoolBoolEq2
false
```
-- It can even compare functions built using tools such as function composition:

它甚至可以比较使用函数复合等工具构建的函数：

```anchor arrBoolBoolEq3
#eval Finite.beq (.arr .bool .bool) id (not ∘ not)
```
```anchorInfo arrBoolBoolEq3
true
```
-- This is because the {anchorName Finite}`Finite` universe codes for Lean's _actual_ function type, not a special analogue created by the library.

这是因为 {anchorName Finite}`Finite` 宇宙编码了 Lean 的 *实际* 函数类型，而非某些特殊的近似。

-- The implementation of {anchorName FiniteAll}`enumerate` is also by recursion on the codes from {anchorName FiniteAll}`Finite`.

{anchorName FiniteAll}`enumerate` 的实现也是通过对 {anchorName FiniteAll}`Finite` 的编码进行递归。

```anchor FiniteAll
  def Finite.enumerate (t : Finite) : List t.asType :=
    match t with
    | .unit => [()]
    | .bool => [true, false]
    | .pair t1 t2 => t1.enumerate.product t2.enumerate
    | .arr dom cod => dom.functions cod.enumerate
```
-- In the case for {anchorName Finite}`Unit`, there is only a single value.
-- In the case for {anchorName Finite}`Bool`, there are two values to return ({anchorName sundries}`true` and {anchorName sundries}`false`).
-- In the case for pairs, the result should be the Cartesian product of the values for the type coded for by {anchorName FiniteAll}`t1` and the values for the type coded for by {anchorName FiniteAll}`t2`.
-- In other words, every value from {anchorName FiniteAll}`dom` should be paired with every value from {anchorName FiniteAll}`cod`.
-- The helper function {anchorName ListProduct}`List.product` can certainly be written with an ordinary recursive function, but here it is defined using {kw}`for` in the identity monad:

{anchorName Finite}`Unit` 只有一个值。{anchorName Finite}`Bool` 有两个值（{anchorName sundries}`true` 和 {anchorName sundries}`false`）。
有序对的值则是 {anchorName FiniteAll}`t1` 编码的类型的值和 {anchorName FiniteAll}`t2` 编码的类型的值的笛卡尔积。
换句话说，{anchorName FiniteAll}`dom` 的每个值都应该与 {anchorName FiniteAll}`cod` 的每个值配对。
辅助函数 {anchorName ListProduct}`List.product` 可以用普通的递归函数编写，但这里在恒等单子中定义 {kw}`for` 实现：

```anchor ListProduct
def List.product (xs : List α) (ys : List β) : List (α × β) := Id.run do
  let mut out : List (α × β) := []
  for x in xs do
    for y in ys do
      out := (x, y) :: out
  pure out.reverse
```
-- Finally, the case of {anchorName FiniteAll}`Finite.enumerate` for functions delegates to a helper called {anchorName FiniteFunctionSigStart}`Finite.functions` that takes a list of all of the return values to target as an argument.

最后，{anchorName FiniteAll}`Finite.enumerate` 将对函数的情形的处理委托给一个名为 {anchorName FiniteFunctionSigStart}`Finite.functions` 的辅助函数，该函数将返回类型的所有值的列表作为参数。

-- Generally speaking, generating all of the functions from some finite type to a collection of result values can be thought of as generating the functions' tables.
-- Each function assigns an output to each input, which means that a given function has $`k` rows in its table when there are $`k` possible arguments.
-- Because each row of the table could select any of $`n` possible outputs, there are $`n ^ k` potential functions to generate.

简单来说，生成从某个有限类型到结果的值的所有函数可以被认为是生成函数的表格。
每个函数将一个输出分配给每个输入，这意味着当有 $`k` 个可能的参数时，给定函数的表格有 $`k` 行。
因为表格的每一行都可以选择 $`n` 个可能的输出中的任何一个，所以有 $`n ^ k` 个潜在的函数要生成。

-- Once again, generating the functions from a finite type to some list of values is recursive on the code that describes the finite type:

与之前类似，生成从有限类型到一些值列表的函数是通过对描述有限类型的编码进行递归完成的：

```anchor FiniteFunctionSigStart
def Finite.functions
    (t : Finite)
    (results : List α) : List (t.asType → α) :=
  match t with
```

-- The table for functions from {anchorName Finite}`Unit` contains one row, because the function can't pick different results based on which input it is provided.
-- This means that one function is generated for each potential input.

{anchorName Finite}`Unit` 的函数表格包含一行，因为函数不能根据提供的输入选择不同的结果。
这意味着为每个潜在的输入生成一个函数。

```anchor FiniteFunctionUnit
| .unit =>
  results.map fun r =>
    fun () => r
```
-- There are $`n^2` functions from {anchorName sundries}`Bool` when there are $`n` result values, because each individual function of type {anchorTerm sundries}`Bool → α` uses the {anchorName sundries}`Bool` to select between two particular {anchorName sundries}`α`s:

从 {anchorName sundries}`Bool` 到 $`n` 个结果值时，有 $`n^2` 个函数，因为类型 {anchorTerm sundries}`Bool → α` 的每个函数根据 {anchorName sundries}`Bool` 选择两个特定的 {anchorName sundries}`α` ：

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

从有序对中生成函数可以通过利用柯里化来实现：把这个函数转化为一个接受有序对的第一个元素并返回一个等待有序对的第二个元素的函数。
这样做允许在这种情形下递归使用 {anchorName FiniteFunctionSigStart}`Finite.functions`：

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
一个函数可以根据其输入/输出行为与其他函数区分开来。
高阶函数的输入行为则又依赖于其函数参数的输入/输出行为：
因此高阶函数的所有行为可以表示为将函数参数应用于所有它所有可能的输入值，然后根据该函数应用的结果的不同产生不同的行为。
这提供了一种构造高阶函数的方法：
 * 构造参数函数 `t1 → t2` 的参数 `t1` 的所有可能值。
 * 对于每个可能的值，构造可以由应用参数函数到可能的参数的观察结果产生的所有可能行为。这可以使用 {anchorName FiniteFunctionSigStart}`Finite.functions` 和对其余参数的递归来完成，因为递归的结果表示基于其余可能参数的观察的函数。{anchorName FiniteFunctionSigStart}`Finite.functions` 根据当前对参数的观察构造所有实现这些方式的方法。
 * 对基于每个观察结果的潜在行为，构造一个将函数参数应用于当前可能参数的高阶函数。然后将此结果传递给观察行为。
 * 递归的基情形是对每个结果值观察无事可做的高阶函数——它忽略函数参数，只是返回结果值。

-- Defining this recursive function directly causes Lean to be unable to prove that the whole function terminates.
-- However, using a simpler form of recursion called a _right fold_ can be used to make it clear to the termination checker that the function terminates.
-- A right fold takes three arguments: a step function that combines the head of the list with the result of the recursion over the tail, a default value to return when the list is empty, and the list being processed.
-- It then analyzes the list, essentially replacing each {lit}`::` in the list with a call to the step function and replacing {lit}`[]` with the default value:

直接定义这个递归函数导致 Lean 无法证明整个函数终止。
然而，一种更简单的递归形式，*右折叠（right fold）*，可以让终止检查器明确地知道函数终止。
右折叠接受三个参数：（1）步骤函数，它将列表的头与对尾部的递归得到的结果组合在一起；（2）列表为空时的默认值；（3）需要处理的列表。
这个函数会分析列表，将列表中的每个 {lit}`::` 替换为对步骤函数的调用，并将 {lit}`[]` 替换为默认值：

```anchor foldr
def List.foldr (f : α → β → β) (default : β) : List α → β
  | []     => default
  | a :: l => f a (foldr f default l)
```
-- Finding the sum of the {anchorName sundries}`Nat`s in a list can be done with {anchorName foldrSum}`foldr`:

可以使用 {anchorName foldrSum}`foldr` 求出列表中 {anchorName sundries}`Nat` 的和：

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

使用 {anchorName foldrSum}`foldr`，可以创建如下的高阶函数：

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

因为 {anchorName MutualStart}`Finite.enumerate` 和 {anchorName FiniteFunctions}`Finite.functions` 互相调用，它们必须在一个 {kw}`mutual` 块中定义。
换句话说，在 {anchorName MutualStart}`Finite.enumerate` 的定义前需要加入 {kw}`mutual` 关键字：

```anchor MutualStart
mutual
  def Finite.enumerate (t : Finite) : List t.asType :=
    match t with
```
-- and right after the definition of {anchorName FiniteFunctions}`Finite.functions` is the {kw}`end` keyword:

在 {anchorName FiniteFunctions}`Finite.functions` 的定义后需要加入 {kw}`end` 关键字：

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
-- $$`\left|\mathrm{Bool}\right|^{\left| \left( \mathtt{Bool} \times \mathtt{Bool} \right) \rightarrow \mathtt{Bool} \right| },`
-- which is
-- $$`2^{2^{\left| \mathtt{Bool} \times \mathtt{Bool} \right| }},`
-- which is
-- $$`2^{2^4}`
-- or 65536.
-- Nested exponentials grow quickly, and there are many higher-order functions.

这种比较函数的算法并不特别实用。
要检查的情形数量呈指数增长；即使是一个简单的类型，如 {anchorTerm lots}`((Bool × Bool) → Bool) → Bool`，也描述了 {anchorInfoText nestedFunLength}`65536` 个不同的函数。
为什么会有这么多？
根据上面的推理，并使用 $`\left| T \right|` 表示类型 $`T` 描述的值的数量，那么上述函数的值的数量应该为
$$`\left| \left( \left( \mathtt{Bool} \times \mathtt{Bool} \right) \rightarrow \mathtt{Bool} \right) \rightarrow \mathtt{Bool} \right|`
这个值可以一步步化简为
$$`\left|\mathrm{Bool}\right|^{\left| \left( \mathtt{Bool} \times \mathtt{Bool} \right) \rightarrow \mathtt{Bool} \right| },`
$$`2^{2^{\left| \mathtt{Bool} \times \mathtt{Bool} \right| }},`
$$`2^{2^4}`
65536
指数的嵌套会很快地增长。这样的高阶函数还有很多。

-- # Exercises
# 练习
%%%
tag := "universe-exercises"
%%%

--  * Write a function that converts any value from a type coded for by {anchorName Finite}`Finite` into a string. Functions should be represented as their tables.
--  * Add the empty type {anchorName sundries}`Empty` to {anchorName Finite}`Finite` and {anchorName FiniteBeq}`Finite.beq`.
--  * Add {anchorName sundries}`Option` to {anchorName Finite}`Finite` and {anchorName FiniteBeq}`Finite.beq`.

 * 编写一个函数，将由 {anchorName Finite}`Finite` 编码的类型的值转换为字符串。函数应该以表格的方式表示。
 * 将空类型 {anchorName sundries}`Empty` 添加到 {anchorName Finite}`Finite` 和 {anchorName FiniteBeq}`Finite.beq`。
 * 将 {anchorName sundries}`Option` 添加到 {anchorName Finite}`Finite` 和 {anchorName FiniteBeq}`Finite.beq`。
