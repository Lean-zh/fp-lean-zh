<!--
# Controlling Instance Search
-->

# 控制实例搜索

<!--
An instance of the `Add` class is sufficient to allow two expressions with type `Pos` to be conveniently added, producing another `Pos`.
However, in many cases, it can be useful to be more flexible and allow _heterogeneous_ operator overloading, where the arguments may have different types.
For example, adding a `Nat` to a `Pos` or a `Pos` to a `Nat` will always yield a `Pos`:
-->

要方便地相加两个 `Pos` 类型，并产生另一个 `Pos`，一个 `Add` 类的的实例就足够了。
但是，在许多情况下，参数可能有不同的类型，重载一个灵活的**异质**运算符是更为有用的。
例如，让 `Nat` 和 `Pos`，或 `Pos` 和 `Nat` 相加总会是一个 `Pos`：

```lean
{{#example_decl Examples/Classes.lean addNatPos}}
```
<!--
These functions allow natural numbers to be added to positive numbers, but they cannot be used with the `Add` type class, which expects both arguments to `add` to have the same type.
-->

这些函数允许自然数与正数相加，但他们不能在 `Add` 类型类中，因为它希望 `add` 的两个参数都有同样的类型。

<!--
## Heterogeneous Overloadings
-->

## 异质重载

<!--
As mentioned in the section on [overloaded addition](pos.md#overloaded-addition), Lean provides a type class called `HAdd` for overloading addition heterogeneously.
The `HAdd` class takes three type parameters: the two argument types and the return type.
Instances of `HAdd Nat Pos Pos` and `HAdd Pos Nat Pos` allow ordinary addition notation to be used to mix the types:
-->

就像在[重载加法](pos.md#overloaded-addition)那一节提到的，Lean 提供了名为 `HAdd` 的类型类来重载异质加法。
`HAdd` 类接受三个类型参数：两个参数的类型和一个返回类型。
`HAdd Nat Pos Pos` 和 `HAdd Pos Nat Pos` 的实例可以让常规加法符号可以接受不同类型。

```lean
{{#example_decl Examples/Classes.lean haddInsts}}
```
<!--
Given the above two instances, the following examples work:
-->

有了上面两个实例，就有了下面的例子：

```lean
{{#example_in Examples/Classes.lean posNatEx}}
```
```output info
{{#example_out Examples/Classes.lean posNatEx}}
```
```lean
{{#example_in Examples/Classes.lean natPosEx}}
```
```output info
{{#example_out Examples/Classes.lean natPosEx}}
```

<!--
The definition of the `HAdd` type class is very much like the following definition of `HPlus` with the corresponding instances:
-->

`HAdd` 的定义和下面 `HPlus` 的定义很像。下面是 `HPlus` 和它对应的实例：

```lean
{{#example_decl Examples/Classes.lean HPlus}}

{{#example_decl Examples/Classes.lean HPlusInstances}}
```
<!--
However, instances of `HPlus` are significantly less useful than instances of `HAdd`.
When attempting to use these instances with `#eval`, an error occurs:
-->

然而，`HPlus` 的实例明显没有 `HAdd` 的实例有用。
当尝试用 `#eval` 使用这些实例时，一个错误就出现了：
```lean
{{#example_in Examples/Classes.lean hPlusOops}}
```
```output error
{{#example_out Examples/Classes.lean hPlusOops}}
```
<!--
This happens because there is a metavariable in the type, and Lean has no way to solve it.
-->

发生错误是因为类型中有元变量，Lean 没办法解决它。

<!--
As discussed in [the initial description of polymorphism](../getting-to-know/polymorphism.md), metavariables represent unknown parts of a program that could not be inferred.
When an expression is written following `#eval`, Lean attempts to determine its type automatically.
In this case, it could not.
Because the third type parameter for `HPlus` was unknown, Lean couldn't carry out type class instance search, but instance search is the only way that Lean could determine the expression's type.
That is, the `HPlus Pos Nat Pos` instance can only apply if the expression should have type `Pos`, but there's nothing in the program other than the instance itself to indicate that it should have this type.
-->

就像我们在[多态一开始的描述](../getting-to-know/polymorphism.md)里说的那样，元变量代表了程序无法被推断的未知部分。
当一个表达式被写在 `#eval` 后时，Lean 会尝试去自动确定它的类型。
在这种情况下，它无法做到自动确定类型。
因为 `HPlus` 的第三个类型参数依然是未知的，Lean 没办法进行类型类实例搜索，但是实例搜索是 Lean 唯一可能确定表达式的类型的方式。
也就是说，`HPlus Pos Nat Pos` 实例只能在表达式的类型为 `Pos` 时应用，但除了实例本身之外，程序中没有其他东西表明它应该具有这种类型。

<!--
One solution to the problem is to ensure that all three types are available by adding a type annotation to the whole expression:
-->

一种解决方法是保证全部三个类型都是已知的，通过给整个表达式添加一个类型标记来实现这一点：
```lean
{{#example_in Examples/Classes.lean hPlusLotsaTypes}}
```
```output info
{{#example_out Examples/Classes.lean hPlusLotsaTypes}}
```
<!--
However, this solution is not very convenient for users of the positive number library.
-->

然而，这种解决方式对使用我们的正数库的用户来说并不是很方便。


<!--
## Output Parameters
-->

## 输出参数

<!--
This problem can also be solved by declaring `γ` to be an _output parameter_.
Most type class parameters are inputs to the search algorithm: they are used to select an instance.
For example, in an `OfNat` instance, both the type and the natural number are used to select a particular interpretation of a natural number literal.
However, in some cases, it can be convenient to start the search process even when some of the type parameters are not yet known, and use the instances that are discovered in the search to determine values for metavariables.
The parameters that aren't needed to start instance search are outputs of the process, which is declared with the `outParam` modifier:
-->

刚才的问题也可以通过声明 `γ` 是一个**输出参数**来解决。
多数类型类参数是作为搜索算法的输入：它们被用于选取一个实例。
例如，在 `OfNat` 实例中，类型和自然数都被用于选取一个数字字面量的特定解释。
然而，在一些情况下，在尽管有些类型参数仍然处于未知状态时就开始进行搜索是更方便的。
这样就能使用在搜索中发现的实例来决定元变量的值。
在开始搜索实例时不需要用到的参数就是这个过程的结果，该参数使用 `outParam` 修饰符来声明。
```lean
{{#example_decl Examples/Classes.lean HPlusOut}}
```

<!--
With this output parameter, type class instance search is able to select an instance without knowing `γ` in advance.
For instance:
-->

有了这个输出参数，类型类实例搜索就能够在不需要知道 `γ` 的情况下选取一个实例了。
例如：
```lean
{{#example_in Examples/Classes.lean hPlusWorks}}
```
```output info
{{#example_out Examples/Classes.lean hPlusWorks}}
```

<!--
It might be helpful to think of output parameters as defining a kind of function.
Any given instance of a type class that has one or more output parameters provides Lean with instructions for determining the outputs from the inputs.
The process of searching for an instance, possibly recursively, ends up being more powerful than mere overloading.
Output parameters can determine other types in the program, and instance search can assemble a collection of underlying instances into a program that has this type.
-->

认为输出参数相当于是定义某种函数在思考时可能会有帮助。
任意给定的，类型类的实例都有一个或更多输出参数提供给 Lean。这能指导 Lean 通过输入（的类型参数）来确定输出（的类型）。
一个可能是递归的实例搜索过程，最终会比简单的重载更为强大。
输出参数能够决定程序中的其他类型，实例搜索能够将一族附属实例组合成具有这种类型的程序。

<!--
## Default Instances
-->

## 默认实例

<!--
Deciding whether a parameter is an input or an output controls the circumstances under which Lean will initiate type class search.
In particular, type class search does not occur until all inputs are known.
However, in some cases, output parameters are not enough, and instance search should also occur when some inputs are unknown.
This is a bit like default values for optional function arguments in Python or Kotlin, except default _types_ are being selected.
-->

确定一个参数是否是一个输入或输出参数控制了 Lean 会在何时启动类型类搜索。
具体而言，直到所有输入都变为已知，类型类搜索才会开始。
然而，在一些情况下，输出参数是不足的。此时，即使一些输入参数仍然处于未知状态，实例搜索也应该开始。
这有点像是 Python 或 Kotlin 中可选函数参数的默认值，但在这里是默认**类型**。

<!--
_Default instances_ are instances that are available for instance search _even when not all their inputs are known_.
When one of these instances can be used, it will be used.
This can cause programs to successfully type check, rather than failing with errors related to unknown types and metavariables.
On the other hand, default instances can make instance selection less predictable.
In particular, if an undesired default instance is selected, then an expression may have a different type than expected, which can cause confusing type errors to occur elsewhere in the program.
Be selective about where default instances are used!
-->

**默认实例**是**当并不是全部输入均为已知时**可用的实例。
当一个默认实例能被使用时，他就将会被使用。
这能帮助程序成功通过类型检查，而不是因为关于未知类型和元变量的错误而失败。
但另一方面，默认类型会让实例选取变得不那么可预测。
具体而言，如果一个不合适的实例被选取了，那么表达式将可能具有和预期不同的类型。
这会导致令人困惑的类型错误发生在程序中。
明智地选择要使用默认实例的地方！

<!--
One example of where default instances can be useful is an instance of `HPlus` that can be derived from an `Add` instance.
In other words, ordinary addition is a special case of heterogeneous addition in which all three types happen to be the same.
This can be implemented using the following instance:
-->

默认实例可以发挥作用的一个例子是可以从 `Add` 实例派生出的 `HPlus` 实例。
换句话说，常规的加法是异质加法在三个参数类型都相同时的特殊情况。
这可以用下面的实例来实现：
```lean
{{#example_decl Examples/Classes.lean notDefaultAdd}}
```
<!--
With this instance, `hPlus` can be used for any addable type, like `Nat`:
-->

有了这个实例，`hPlus` 就可以被用于任何可加的类型，就像 `Nat`：
```lean
{{#example_in Examples/Classes.lean hPlusNatNat}}
```
```output info
{{#example_out Examples/Classes.lean hPlusNatNat}}
```

<!--
However, this instance will only be used in situations where the types of both arguments are known.
For example,
-->

然而，这个实例只会用在两个参数类型都已知的情况下。
例如：
```lean
{{#example_in Examples/Classes.lean plusFiveThree}}
```
<!--
yields the type
-->

产生类型
```output info
{{#example_out Examples/Classes.lean plusFiveThree}}
```
<!--
as expected, but
-->

就像我们预想的那样，但是
```lean
{{#example_in Examples/Classes.lean plusFiveMeta}}
```
<!--
yields a type that contains two metavariables, one for the remaining argument and one for the return type:
-->

产生了一个包含剩余参数和返回值类型的两个元变量的类型：
```output info
{{#example_out Examples/Classes.lean plusFiveMeta}}
```

<!--
In the vast majority of cases, when someone supplies one argument to addition, the other argument will have the same type.
To make this instance into a default instance, apply the `default_instance` attribute:
-->

在绝大多数情况下，当提供一个加法参数时，另一个参数也会是同一个类型。
来让这个实例成为默认实例，应用 `default_instance` 属性：
```lean
{{#example_decl Examples/Classes.lean defaultAdd}}
```
<!--
With this default instance, the example has a more useful type:
-->

有了默认实例，这个例子就有了更有用的类型：
```lean
{{#example_in Examples/Classes.lean plusFive}}
```
<!--
yields
-->

结果为：
```output info
{{#example_out Examples/Classes.lean plusFive}}
```

<!--
Each operator that exists in overloadable heterogeneous and homogeneous versions follows the pattern of a default instance that allows the homogeneous version to be used in contexts where the heterogeneous is expected.
The infix operator is replaced with a call to the heterogeneous version, and the homogeneous default instance is selected when possible.
-->

每个同时具有可重载异质和同质版本的操作符都遵循在期望使用异质版本的语境中可以使用同质版本作为默认实例的设计模式。
中缀运算符会被替换为对异质版本的调用，同质的默认实例会在可能的时候被选取。

<!--
Similarly, simply writing `{{#example_in Examples/Classes.lean fiveType}}` gives a `{{#example_out Examples/Classes.lean fiveType}}` rather than a type with a metavariable that is waiting for more information in order to select an `OfNat` instance.
This is because the `OfNat` instance for `Nat` is a default instance.
-->

简单来说，简单地写 `{{#example_in Examples/Classes.lean fiveType}}` 会给出一个 `{{#example_out Examples/Classes.lean fiveType}}` 而不是一个需要更多信息来选取 `OfNat` 实例的一个包含元变量的类型。
这是因为 `OfNat` 以 `Nat` 作为默认实例。

<!--
Default instances can also be assigned _priorities_ that affect which will be chosen in situations where more than one might apply.
For more information on default instance priorities, please consult the Lean manual.
-->

默认实例也可以被赋予**优先级**，这会影响在可能的应用多于一种的情况下的选择。
更多关于默认实例优先级的信息，请查阅 Lean 手册。


<!--
## Exercises
-->

## 练习

<!--
Define an instance of `HMul (PPoint α) α (PPoint α)` that multiplies both projections by the scalar.
It should work for any type `α` for which there is a `Mul α` instance.
For example,
-->

定义一个 `HMul (PPoint α) α (PPoint α)` 的实例，该实例将两个投影都乘以标量。
它应适用于任何存在 `Mul α` 实例的类型 `α`。例如：
```lean
{{#example_in Examples/Classes.lean HMulPPoint}}
```
<!--
should yield
-->

结果应为
```output info
{{#example_out Examples/Classes.lean HMulPPoint}}
```
