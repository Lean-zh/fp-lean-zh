<!--
# Type Classes and Polymorphism
-->

# 类型类和多态

<!--
It can be useful to write functions that work for _any_ overloading of a given function.
For instance, `IO.println` works for any type that has an instance of `ToString`.
This is indicated using square brackets around the required instance: the type of `IO.println` is `{{#example_out Examples/Classes.lean printlnType}}`.
This type says that `IO.println` accepts an argument of type `α`, which Lean should determine automatically, and that there must be a `ToString` instance available for `α`.
It returns an `IO` action.
-->

编写适用于给定函数的 **任意** 重载可能会很有用。
例如，`IO.println` 适用于任何具有 `ToString` 实例的类型。这通过在所需实例周围使用方括号来表示：
`IO.println` 的类型是 `{{#example_out Examples/Classes.lean printlnType}}`。
这个类型表示 `IO.println` 接受一个类型为 `α` 的参数，并且 Lean 应该自动确定这个类型，
而且必须有一个可用于 `α` 的 `ToString` 实例。
它返回一个 `IO` 操作。


<!--
## Checking Polymorphic Functions' Types
-->

## 对多态函数的类型检查

<!--
Checking the type of a function that takes implicit arguments or uses type classes requires the use of some additional syntax.
Simply writing
-->

对接受隐式参数，或使用了类型类的函数进行类型检查时，我们需要用到一些额外的语法。
简单地写

```lean
{{#example_in Examples/Classes.lean printlnMetas}}
```
<!--
yields a type with metavariables:
-->

会产生一个包含元变量的类型。

```output info
{{#example_out Examples/Classes.lean printlnMetas}}
```
<!--
This is because Lean does its best to discover implicit arguments, and the presence of metavariables indicates that it did not yet discover enough type information to do so.
To understand the signature of a function, this feature can be suppressed with an at-sign (`@`) before the function's name:
-->

这里显示出了元变量是因为即使 Lean 尽全力去寻找隐式参数，但还是没有找到足够的类型信息来做到这一点。
要理解函数的签名，可以在函数名之前加上一个 at 符号（`@`）来抑制此特性。

```lean
{{#example_in Examples/Classes.lean printlnNoMetas}}
```
```output info
{{#example_out Examples/Classes.lean printlnNoMetas}}
```
<!--
In this output, the instance itself has been given the name `inst`.
Additionally, there is a `u_1` after `Type`, which uses a feature of Lean that has not yet been introduced.
For now, ignore these parameters to `Type`.
-->

在这个输出信息中，实例本身被给予了 `inst` 这个名字。
此外，`Type` 后面有一个 `u_1` ，这是 Lean 
目前，可以忽略这些Type的参数。

<!--
## Defining Polymorphic Functions with Instance Implicits
-->

## 定义含隐式实例的多态函数

<!--
A function that sums all entries in a list needs two instances: `Add` allows the entries to be added, and an `OfNat` instance for `0` provides a sensible value to return for the empty list:
-->

一个对列表中所有条目求和的函数需要两个实例：`Add`允许对条目进行加法运算，而`OfNat`实例为`0`提供了一个合理的值，以便对空列表进行返回。

```lean
{{#example_decl Examples/Classes.lean ListSum}}
```

<!--
This function can be used for a list of `Nat`s:
-->

这个函数可以被用于 `Nat` 列表：

```lean
{{#example_decl Examples/Classes.lean fourNats}}

{{#example_in Examples/Classes.lean fourNatsSum}}
```
```output info
{{#example_out Examples/Classes.lean fourNatsSum}}
```

<!--
but not for a list of `Pos` numbers:
-->

但不能被用于 `Pos` 列表：

```lean
{{#example_decl Examples/Classes.lean fourPos}}

{{#example_in Examples/Classes.lean fourPosSum}}
```
```output error
{{#example_out Examples/Classes.lean fourPosSum}}
```

<!--
Specifications of required instances in square brackets are called _instance implicits_.
Behind the scenes, every type class defines a structure that has a field for each overloaded operation.
Instances are values of that structure type, with each field containing an implementation.
At a call site, Lean is responsible for finding an instance value to pass for each instance implicit argument.
The most important difference between ordinary implicit arguments and instance implicits is the strategy that Lean uses to find an argument value.
In the case of ordinary implicit arguments, Lean uses a technique called _unification_ to find a single unique argument value that would allow the program to pass the type checker.
This process relies only on the specific types involved in the function's definition and the call site.
For instance implicits, Lean instead consults a built-in table of instance values.
-->

在方括号中的所需实例规范被称为 **隐式实例** 。
在幕后，每个类型类都定义了一个结构，该结构具有每个重载操作的字段。
实例是该结构类型的值，每个字段包含一个实现。
在调用时，Lean负责为每个隐式实例参数找到一个实例值传递。
普通的隐式参数和隐式实例最重要的不同就是 Lean 寻找参数值的策略。
对于普通的隐式参数，Lean 使用一种被称为 **归一化** 的技术来找到一个唯一的能使程序通过类型检查的参数值。
这个过程只依赖于函数定义中的具体类型和调用时。

<!--
Just as the `OfNat` instance for `Pos` took a natural number `n` as an automatic implicit argument, instances may also take instance implicit arguments themselves.
The [section on polymorphism](../getting-to-know/polymorphism.md) presented a polymorphic point type:
-->

就像对 `Pos` 的 `OfNat` 实例用一个自然数 `n` 作为自动隐式参数，实例本身也可能接受隐式实例参数。
在[多态那一节](../getting-to-know/polymorphism.md)中展示了一个多态点类型：

```lean
{{#example_decl Examples/Classes.lean PPoint}}
```

<!--
Addition of points should add the underlying `x` and `y` fields.
Thus, an `Add` instance for `PPoint` requires an `Add` instance for whatever type these fields have.
In other words, the `Add` instance for `PPoint` requires a further `Add` instance for `α`:
-->

点之间的加法需要将从属的 `x` 和 `y` 字段相加。
因此，`PPoint` 的 `Add` 实例需要这些字段所具有的类型的 `Add` 实例。
换句话说，`PPoint` 的 `Add` 实例需要进一步的 `α` 的 `Add` 实例。

```lean
{{#example_decl Examples/Classes.lean AddPPoint}}
```

<!--
When Lean encounters an addition of two points, it searches for and finds this instance.
It then performs a further search for the `Add α` instance.
-->

当 Lean 遇到两点之间的加法，它会寻找并找到这个实例。
然后会更进一步寻找 `Add α` 实例。

<!--
The instance values that are constructed in this way are values of the type class's structure type.
A successful recursive instance search results in a structure value that has a reference to another structure value.
An instance of `Add (PPoint Nat)` contains a reference to the instance of `Add Nat` that was found.
-->

用这种方式构造的实例值是类型类的结构体类型的值。
一个成功的递归实例搜索会产生一个结构体值，该结构体值引用了另一个结构体值。
一个 `Add (PPoint Nat)` 实例包含对找到的 `Add Nat` 实例的引用。


<!--
This recursive search process means that type classes offer significantly more power than plain overloaded functions.
A library of polymorphic instances is a set of code building blocks that the compiler will assemble on its own, given nothing but the desired type.
Polymorphic functions that take instance arguments are latent requests to the type class mechanism to assemble helper functions behind the scenes.
The API's clients are freed from the burden of plumbing together all of the necessary parts by hand.
-->

这种递归搜索意味着类型类显著地比普通重载函数更加强大。
一个多态实例库是一个由代码砖块组成的集合，编译器会根据所需的类型自行搭建。
接受实例参数的多态函数是对类型类机制的潜在请求，以在幕后组装辅助函数。
API的客户端无需手工组合所有必要的部分，从而使用户从这类烦人的工作中解放出来。


<!--
## Methods and Implicit Arguments
-->

## 方法与隐式参数


<!--
The type of `{{#example_in Examples/Classes.lean ofNatType}}` may be surprising.
It is `{{#example_out Examples/Classes.lean ofNatType}}`, in which the `Nat` argument `n` occurs as an explicit function argument.
In the declaration of the method, however, `ofNat` simply has type `α`.
This seeming discrepancy is because declaring a type class really results in the following:
-->

`{{#example_in Examples/Classes.lean ofNatType}}` 的类型可能会令人惊讶。
它是 `{{#example_out Examples/Classes.lean ofNatType}}`，其中 `Nat` 参数 `n` 作为显式函数参数出现。
然而，在方法的声明中，`ofNat` 只是类型 `α`。
这种看似的不一致是因为声明一个类型类实际上会产生以下结果：

<!--
 * A structure type to contain the implementation of each overloaded operation
 * A namespace with the same name as the class
 * For each method, a function in the class's namespace that retrieves its implementation from an instance
-->

 * 声明一个包含了每个重载操作的实现的结构体类型
 * 声明一个与类同名的命名空间
 * 对于每个方法，会在类的命名空间中声明一个函数，该函数从实例中获取其实现。

<!--
This is analogous to the way that declaring a new structure also declares accessor functions.
The primary difference is that a structure's accessors take the structure value as an explicit argument, while the type class methods take the instance value as an instance implicit to be found automatically by Lean.
-->

这类似于声明新结构也声明访问器函数的方式。
主要区别在于结构的访问器函数将结构值作为显式参数，而类型类方法将实例值作为隐式实例，由 Lean 自动查找。

<!--
In order for Lean to find an instance, its arguments must be available.
This means that each argument to the type class must be an argument to the method that occurs before the instance.
It is most convenient when these arguments are implicit, because Lean does the work of discovering their values.
For example, `{{#example_in Examples/Classes.lean addType}}` has the type `{{#example_out Examples/Classes.lean addType}}`.
In this case, the type argument `α` can be implicit because the arguments to `Add.add` provide information about which type the user intended.
This type can then be used to search for the `Add` instance.
-->

为了让Lean找到一个实例，它的参数必须是可用的。
这意味着类型类的每个参数必须是出现在实例之前的方法的参数。
当这些参数是隐式的时候最方便，因为Lean会发现它们的值。
例如，`{{#example_in Examples/Classes.lean addType}}` 的类型是 `{{#example_out Examples/Classes.lean addType}}`。
在这种情况下，类型参数 `α` 可以是隐式的，因为对 `Add.add` 的参数提供了关于用户意图的类型信息。
然后，可以使用这种类型来搜索 Add 实例。

<!--
In the case of `ofNat`, however, the particular `Nat` literal to be decoded does not appear as part of any other argument.
This means that Lean would have no information to use when attempting to figure out the implicit argument `n`.
The result would be a very inconvenient API.
Thus, in these cases, Lean uses an explicit argument for the class's method.
-->

而在 `ofNat` 的例子中，要被解码的特定 `Nat` 字面量并没有作为其他参数的一部分出现。
这意味着 Lean 在尝试确定隐式参数 `n` 时将没有足够的信息可以用。
如果Lean选择使用隐式参数，那么结果将是一个非常不方便的 API。
因此，在这些情况下，Lean 选择为类方法提供一个显式参数。



<!--
## Exercises
-->

## 练习

<!--
### Even Number Literals
-->

### 偶数数字字面量

<!--
Write an instance of `OfNat` for the even number datatype from the [previous section's exercises](pos.md#even-numbers) that uses recursive instance search.
For the base instance, it is necessary to write `OfNat Even Nat.zero` instead of `OfNat Even 0`.
-->

为[上一节的练习题](pos.md#even-numbers)中的偶数数据类型写一个使用递归实例搜索的 `OfNat` 实例。
对于基本实例，有必要编写 `OfNat Even Nat.zero` 而不是 `OfNat Even 0`。

<!--
### Recursive Instance Search Depth
-->

### 递归实例搜索深度

<!--
There is a limit to how many times the Lean compiler will attempt a recursive instance search.
This places a limit on the size of even number literals defined in the previous exercise.
Experimentally determine what the limit is.
-->

Lean 编译器尝试进行递归实例搜素的次数是有限的。
这限制了前面的练习中定义的偶数字面量的尺寸。
实验性地确定这个上限是多少。
