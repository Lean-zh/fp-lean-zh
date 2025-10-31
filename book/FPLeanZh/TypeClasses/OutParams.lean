import VersoManual
import FPLeanZh.Examples

open Verso.Genre Manual
open Verso Code External

open FPLeanZh

set_option verso.exampleProject "../examples"
set_option verso.exampleModule "Examples.Classes"

set_option pp.rawOnError true

-- Controlling Instance Search
#doc (Manual) "控制实例搜索" =>
%%%
file := "OutParams"
tag := "out-params"
%%%

-- An instance of the {moduleName}`Add` class is sufficient to allow two expressions with type {moduleName}`Pos` to be conveniently added, producing another {moduleName}`Pos`.
-- However, in many cases, it can be useful to be more flexible and allow _heterogeneous_ operator overloading, where the arguments may have different types.
-- For example, adding a {moduleName}`Nat` to a {moduleName}`Pos` or a {moduleName}`Pos` to a {moduleName}`Nat` will always yield a {moduleName}`Pos`:

{moduleName}`Add` 类的实例足以方便地将两个类型为 {moduleName}`Pos` 的表达式相加，从而产生另一个 {moduleName}`Pos`。
然而，在许多情况下，更灵活并允许*异构*运算符重载可能很有用，其中参数可以具有不同的类型。
例如，将 {moduleName}`Nat` 添加到 {moduleName}`Pos` 或将 {moduleName}`Pos` 添加到 {moduleName}`Nat` 将始终产生一个 {moduleName}`Pos`：

```anchor addNatPos
def addNatPos : Nat → Pos → Pos
  | 0, p => p
  | n + 1, p => Pos.succ (addNatPos n p)

def addPosNat : Pos → Nat → Pos
  | p, 0 => p
  | p, n + 1 => Pos.succ (addPosNat p n)
```

-- These functions allow natural numbers to be added to positive numbers, but they cannot be used with the {moduleName}`Add` type class, which expects both arguments to {moduleName}`add` to have the same type.

这些函数允许将自然数添加到正数中，但它们不能与 {moduleName}`Add` 类型类一起使用，该类型类要求 {moduleName}`add` 的两个参数具有相同的类型。

-- # Heterogeneous Overloadings
# 异构重载
%%%
tag := "heterogeneous-operators"
%%%

-- As mentioned in the section on {ref "overloaded-addition"}[overloaded addition], Lean provides a type class called {anchorName chapterIntro}`HAdd` for overloading addition heterogeneously.
-- The {anchorName chapterIntro}`HAdd` class takes three type parameters: the two argument types and the return type.
-- Instances of {anchorTerm haddInsts}`HAdd Nat Pos Pos` and {anchorTerm haddInsts}`HAdd Pos Nat Pos` allow ordinary addition notation to be used to mix the types:

如 {ref "overloaded-addition"}[重载加法] 部分所述，Lean 提供了一个名为 {anchorName chapterIntro}`HAdd` 的类型类，用于异构地重载加法。
{anchorName chapterIntro}`HAdd` 类接受三个类型参数：两个参数类型和返回类型。
{anchorTerm haddInsts}`HAdd Nat Pos Pos` 和 {anchorTerm haddInsts}`HAdd Pos Nat Pos` 的实例允许使用普通的加法表示法来混合类型：

```anchor haddInsts
instance : HAdd Nat Pos Pos where
  hAdd := addNatPos

instance : HAdd Pos Nat Pos where
  hAdd := addPosNat
```

-- Given the above two instances, the following examples work:
鉴于以上两个实例，以下示例可以工作：

```anchor posNatEx
#eval (3 : Pos) + (5 : Nat)
```
```anchorInfo posNatEx
8
```

```anchor natPosEx
#eval (3 : Nat) + (5 : Pos)
```
```anchorInfo natPosEx
8
```

-- The definition of the {anchorName chapterIntro}`HAdd` type class is very much like the following definition of {moduleName}`HPlus` with the corresponding instances:

{anchorName chapterIntro}`HAdd` 类型类的定义与以下 {moduleName}`HPlus` 的定义及其相应实例非常相似：

```anchor HPlus
class HPlus (α : Type) (β : Type) (γ : Type) where
  hPlus : α → β → γ
```

```anchor HPlusInstances
instance : HPlus Nat Pos Pos where
  hPlus := addNatPos

instance : HPlus Pos Nat Pos where
  hPlus := addPosNat
```

-- However, instances of {moduleName}`HPlus` are significantly less useful than instances of {anchorName chapterIntro}`HAdd`.
-- When attempting to use these instances with {kw}`#eval`, an error occurs:

然而，{moduleName}`HPlus` 的实例远不如 {anchorName chapterIntro}`HAdd` 的实例有用。
当尝试将这些实例与 {kw}`#eval` 一起使用时，会发生错误：

```anchor hPlusOops
#eval toString (HPlus.hPlus (3 : Pos) (5 : Nat))
```
```anchorError hPlusOops
typeclass instance problem is stuck, it is often due to metavariables
  ToString ?m.14563
```

-- This happens because there is a metavariable in the type, and Lean has no way to solve it.

发生这种情况是因为类型中存在元变量，而 Lean 无法解决它。

-- As discussed in {ref "polymorphism"}[the initial description of polymorphism], metavariables represent unknown parts of a program that could not be inferred.
-- When an expression is written following {kw}`#eval`, Lean attempts to determine its type automatically.
-- In this case, it could not.
-- Because the third type parameter for {anchorName HPlusInstances}`HPlus` was unknown, Lean couldn't carry out type class instance search, but instance search is the only way that Lean could determine the expression's type.
-- That is, the {anchorTerm HPlusInstances}`HPlus Pos Nat Pos` instance can only apply if the expression should have type {moduleName}`Pos`, but there's nothing in the program other than the instance itself to indicate that it should have this type.

如 {ref "polymorphism"}[多态性的初步描述] 中所述，元变量表示程序中无法推断的未知部分。
当在 {kw}`#eval` 之后编写表达式时，Lean 会尝试自动确定其类型。
在这种情况下，它无法做到。
因为 {anchorName HPlusInstances}`HPlus` 的第三个类型参数是未知的，所以 Lean 无法执行类型类实例搜索，但实例搜索是 Lean 确定表达式类型的唯一方法。
也就是说，只有当表达式应具有类型 {moduleName}`Pos` 时，{anchorTerm HPlusInstances}`HPlus Pos Nat Pos` 实例才能应用，但程序中除了实例本身之外没有任何东西表明它应具有此类型。

-- One solution to the problem is to ensure that all three types are available by adding a type annotation to the whole expression:

解决该问题的一种方法是通过向整个表达式添加类型注释来确保所有三种类型都可用：

```anchor hPlusLotsaTypes
#eval (HPlus.hPlus (3 : Pos) (5 : Nat) : Pos)
```
```anchorInfo hPlusLotsaTypes
8
```

-- However, this solution is not very convenient for users of the positive number library.

然而，对于正数库的用户来说，这个解决方案不是很方便。

-- # Output Parameters
# 输出参数
%%%
tag := "output-parameters"
%%%

-- This problem can also be solved by declaring {anchorName HPlus}`γ` to be an _output parameter_.
-- Most type class parameters are inputs to the search algorithm: they are used to select an instance.
-- For example, in an {moduleName}`OfNat` instance, both the type and the natural number are used to select a particular interpretation of a natural number literal.
-- However, in some cases, it can be convenient to start the search process even when some of the type parameters are not yet known, and use the instances that are discovered in the search to determine values for metavariables.
-- The parameters that aren't needed to start instance search are outputs of the process, which is declared with the {moduleName}`outParam` modifier:

这个问题也可以通过将 {anchorName HPlus}`γ` 声明为*输出参数*来解决。
大多数类型类参数是搜索算法的输入：它们用于选择实例。
例如，在 {moduleName}`OfNat` 实例中，类型和自然数都用于选择自然数字面量的特定解释。
然而，在某些情况下，即使某些类型参数尚不清楚，也可以方便地启动搜索过程，并使用在搜索中发现的实例来确定元变量的值。
不需要启动实例搜索的参数是该过程的输出，使用 {moduleName}`outParam` 修饰符声明：

```anchor HPlusOut
class HPlus (α : Type) (β : Type) (γ : outParam Type) where
  hPlus : α → β → γ
```

-- With this output parameter, type class instance search is able to select an instance without knowing {anchorName HPlusOut}`γ` in advance.
-- For instance:

有了这个输出参数，类型类实例搜索就能够在不预先知道 {anchorName HPlusOut}`γ` 的情况下选择一个实例。
例如：

```anchor hPlusWorks
#eval HPlus.hPlus (3 : Pos) (5 : Nat)
```
```anchorInfo hPlusWorks
8
```

-- It might be helpful to think of output parameters as defining a kind of function.
-- Any given instance of a type class that has one or more output parameters provides Lean with instructions for determining the outputs from the inputs.
-- The process of searching for an instance, possibly recursively, ends up being more powerful than mere overloading.
-- Output parameters can determine other types in the program, and instance search can assemble a collection of underlying instances into a program that has this type.

将输出参数视为定义一种函数可能会有所帮助。
具有一个或多个输出参数的类型类的任何给定实例都为 Lean 提供了从输入确定输出的指令。
搜索实例的过程（可能递归）最终比单纯的重载更强大。
输出参数可以确定程序中的其他类型，实例搜索可以将底层实例的集合组装成具有此类型的程序。

-- # Default Instances
# 默认实例
%%%
tag := "default-instances"
%%%

-- Deciding whether a parameter is an input or an output controls the circumstances under which Lean will initiate type class search.
-- In particular, type class search does not occur until all inputs are known.
-- However, in some cases, output parameters are not enough, and instance search should also occur when some inputs are unknown.
-- This is a bit like default values for optional function arguments in Python or Kotlin, except default _types_ are being selected.

决定参数是输入还是输出可以控制 Lean 启动类型类搜索的情况。
特别是，在所有输入都已知之前，不会发生类型类搜索。
然而，在某些情况下，输出参数是不够的，当某些输入未知时，也应该进行实例搜索。
这有点像 Python 或 Kotlin 中可选函数参数的默认值，只是正在选择默认*类型*。

-- _Default instances_ are instances that are available for instance search _even when not all their inputs are known_.
-- When one of these instances can be used, it will be used.
-- This can cause programs to successfully type check, rather than failing with errors related to unknown types and metavariables.
-- On the other hand, default instances can make instance selection less predictable.
-- In particular, if an undesired default instance is selected, then an expression may have a different type than expected, which can cause confusing type errors to occur elsewhere in the program.
-- Be selective about where default instances are used!

*默认实例*是即使并非所有输入都已知也适用于实例搜索的实例。
当可以使用这些实例之一时，就会使用它。
这可以使程序成功进行类型检查，而不是因与未知类型和元变量相关的错误而失败。
另一方面，默认实例会使实例选择的可预测性降低。
特别是，如果选择了不需要的默认实例，则表达式的类型可能与预期的不同，这可能会导致程序中其他地方出现令人困惑的类型错误。
请谨慎选择使用默认实例的位置！

-- One example of where default instances can be useful is an instance of {anchorName HPlusOut}`HPlus` that can be derived from an {moduleName}`Add` instance.
-- In other words, ordinary addition is a special case of heterogeneous addition in which all three types happen to be the same.
-- This can be implemented using the following instance:

默认实例有用的一个例子是可以从 {moduleName}`Add` 实例派生的 {anchorName HPlusOut}`HPlus` 实例。
换句话说，普通加法是异构加法的一种特殊情况，其中所有三种类型恰好相同。
这可以使用以下实例来实现：

```anchor notDefaultAdd
instance [Add α] : HPlus α α α where
  hPlus := Add.add
```

-- With this instance, {anchorName notDefaultAdd}`hPlus` can be used for any addable type, like {moduleName}`Nat`:

有了这个实例，{anchorName notDefaultAdd}`hPlus` 就可以用于任何可加类型，比如 {moduleName}`Nat`：

```anchor hPlusNatNat
#eval HPlus.hPlus (3 : Nat) (5 : Nat)
```
```anchorInfo hPlusNatNat
8
```

-- However, this instance will only be used in situations where the types of both arguments are known.
-- For example,

然而，这个实例只会在两个参数的类型都已知的情况下使用。
例如，

```anchor plusFiveThree
#check HPlus.hPlus (5 : Nat) (3 : Nat)
```

-- yields the type
产生类型



```anchorInfo plusFiveThree
HPlus.hPlus 5 3 : Nat
```

-- as expected, but
正如预期的那样，但是

```anchor plusFiveMeta
#check HPlus.hPlus (5 : Nat)
```

-- yields a type that contains two metavariables, one for the remaining argument and one for the return type:
产生一个包含两个元变量的类型，一个用于剩余参数，一个用于返回类型：

```anchorInfo plusFiveMeta
HPlus.hPlus 5 : ?m.15752 → ?m.15754
```

-- In the vast majority of cases, when someone supplies one argument to addition, the other argument will have the same type.
-- To make this instance into a default instance, apply the {anchorTerm defaultAdd}`default_instance` attribute:

在绝大多数情况下，当有人为加法提供一个参数时，另一个参数将具有相同的类型。
要将此实例设为默认实例，请应用 {anchorTerm defaultAdd}`default_instance` 属性：

```anchor defaultAdd
@[default_instance]
instance [Add α] : HPlus α α α where
  hPlus := Add.add
```

-- With this default instance, the example has a more useful type:

有了这个默认实例，这个例子就有了一个更有用的类型：

```anchor plusFive
#check HPlus.hPlus (5 : Nat)
```

-- yields
产生

```anchorInfo plusFive
HPlus.hPlus 5 : Nat → Nat
```

-- Each operator that exists in overloadable heterogeneous and homogeneous versions follows the pattern of a default instance that allows the homogeneous version to be used in contexts where the heterogeneous is expected.
-- The infix operator is replaced with a call to the heterogeneous version, and the homogeneous default instance is selected when possible.

每个存在于可重载异构和同构版本中的运算符都遵循默认实例的模式，该模式允许在需要异构的上下文中使用同构版本。
中缀运算符被替换为对异构版本的调用，并在可能的情况下选择同构默认实例。

-- Similarly, simply writing {anchorTerm fiveType}`5` gives a {anchorTerm fiveType}`Nat` rather than a type with a metavariable that is waiting for more information in order to select an {moduleName}`OfNat` instance.
-- This is because the {moduleName}`OfNat` instance for {moduleName}`Nat` is a default instance.

同样，简单地写 {anchorTerm fiveType}`5` 会得到一个 {anchorTerm fiveType}`Nat`，而不是一个带有元变量的类型，该元变量正在等待更多信息以选择 {moduleName}`OfNat` 实例。
这是因为 {moduleName}`Nat` 的 {moduleName}`OfNat` 实例是默认实例。

-- Default instances can also be assigned _priorities_ that affect which will be chosen in situations where more than one might apply.
-- For more information on default instance priorities, please consult the Lean manual.

默认实例也可以被分配*优先级*，这会影响在多个实例可能适用的情况下选择哪个实例。
有关默认实例优先级的更多信息，请参阅 Lean 手册。

-- # Exercises
# 练习
%%%
tag := "out-params-exercises"
%%%

-- Define an instance of {anchorTerm MulPPoint}`HMul (PPoint α) α (PPoint α)` that multiplies both projections by the scalar.
-- It should work for any type {anchorName MulPPoint}`α` for which there is a {anchorTerm MulPPoint}`Mul α` instance.
-- For example,

定义一个 {anchorTerm MulPPoint}`HMul (PPoint α) α (PPoint α)` 的实例，该实例将两个投影都乘以标量。
它应该适用于任何存在 {anchorTerm MulPPoint}`Mul α` 实例的类型 {anchorName MulPPoint}`α`。
例如，

```anchor HMulPPoint
#eval {x := 2.5, y := 3.7 : PPoint Float} * 2.0
```

-- should yield
应该产生

```anchorInfo HMulPPoint
{ x := 5.000000, y := 7.400000 }
```
