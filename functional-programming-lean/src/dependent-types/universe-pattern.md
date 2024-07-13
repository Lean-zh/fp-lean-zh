<!-- # The Universe Design Pattern -->
# 宇宙设计模式

<!-- In Lean, types such as `Type`, `Type 3`, and `Prop` that classify other types are known as universes.
However, the term _universe_ is also used for a design pattern in which a datatype is used to represent a subset of Lean's types, and a function converts the datatype's constructors into actual types.
The values of this datatype are called _codes_ for their types. -->
在 Lean 中，用于分类其他类型的 `Type`、`Type 3` 和 `Prop` 等类型被称为宇宙。
然而，术语 **宇宙（universe）** 也用于表示一种设计模式，其中使用数据类型来表示 Lean 类型的子集，并且一个函数将数据类型的构造函数转换为实际类型。
这种数据类型的值被称为其类型的 **编码（codes）**。

<!-- Just like Lean's built-in universes, the universes implemented with this pattern are types that describe some collection of available types, even though the mechanism by which it is done is different.
In Lean, there are types such as `Type`, `Type 3`, and `Prop` that directly describe other types.
This arrangement is referred to as _universes à la Russell_.
The user-defined universes described in this section represent all of their types as _data_, and include an explicit function to interpret these codes into actual honest-to-goodness types.
This arrangement is referred to as _universes à la Tarski_.
While languages such as Lean that are based on dependent type theory almost always use Russell-style universes, Tarski-style universes are a useful pattern for defining APIs in these languages. -->
正如 Lean 的内置宇宙一样，使用这种模式实现的宇宙是描述一些可用类型的类型，尽管实现方式不同。
在 Lean 中，有诸如 `Type`、`Type 3` 和 `Prop` 等直接描述其他类型的类型。
这种安排被称为 **Russell 风格的宇宙（universes à la Russell）**。
本节中描述的用户定义的宇宙将所有类型表示为 **数据**，并包括一个明确的函数将这些编码解释为实际的类型。
这种安排被称为 **Tarski 风格的宇宙（universes à la Tarski）**。
基于依赖类型理论的语言（如 Lean）几乎总是使用 Russell 风格的宇宙，而 Tarski 风格的宇宙是这些语言中定义 API 的有用模式。

<!-- Defining a custom universe makes it possible to carve out a closed collection of types that can be used with an API.
Because the collection of types is closed, recursion over the codes allows programs to work for _any_ type in the universe.
One example of a custom universe has the codes `nat`, standing for `Nat`, and `bool`, standing for `Bool`: -->
定义一个自定义宇宙可以划分出一组可以与 API 一起使用的类型的封闭集合。
由于类型集合是封闭的，因此对编码的递归允许程序适用于宇宙中的 **任何** 类型。
一个自定义宇宙的例子是具有编码 `nat`，表示 `Nat`，和 `bool`，表示 `Bool`：

```lean
{{#example_decl Examples/DependentTypes/Finite.lean NatOrBool}}
```
<!-- Pattern matching on a code allows the type to be refined, just as pattern matching on the constructors of `Vect` allows the expected length to be refined.
For instance, a program that deserializes the types in this universe from a string can be written as follows: -->
对编码进行模式匹配允许类型被细化，就像对 `Vect` 的构造函数进行模式匹配允许期望的长度被细化一样。
例如，可以编写一个从字符串反序列化此宇宙中的类型的程序如下：

```lean
{{#example_decl Examples/DependentTypes/Finite.lean decode}}
```
<!-- Dependent pattern matching on `t` allows the expected result type `t.asType` to be respectively refined to `NatOrBool.nat.asType` and `NatOrBool.bool.asType`, and these compute to the actual types `Nat` and `Bool`. -->
对 `t` 进行依赖模式匹配允许将期望的结果类型 `t.asType` 分别细化为 `NatOrBool.nat.asType` 和 `NatOrBool.bool.asType`，并且这些计算为实际的类型 `Nat` 和 `Bool`。

<!-- Like any other data, codes may be recursive.
The type `NestedPairs` codes for any possible nesting of the pair and natural number types: -->
与任何其他数据一样，编码可能是递归的。
类型 `NestedPairs` 为任何可能的对和自然数类型的嵌套编码：

```lean
{{#example_decl Examples/DependentTypes/Finite.lean NestedPairs}}
```
<!-- In this case, the interpretation function `NestedPairs.asType` is recursive.
This means that recursion over codes is required in order to implement `BEq` for the universe: -->
在这种情况下，解释函数 `NestedPairs.asType` 是递归的。
这意味着需要对编码进行递归才能实现该宇宙的 `BEq`：

```lean
{{#example_decl Examples/DependentTypes/Finite.lean NestedPairsbeq}}
```

<!-- Even though every type in the `NestedPairs` universe already has a `BEq` instance, type class search does not automatically check every possible case of a datatype in an instance declaration, because there might be infinitely many such cases, as with `NestedPairs`.
Attempting to appeal directly to the `BEq` instances rather than explaining to Lean how to find them by recursion on the codes results in an error: -->
尽管 `NestedPairs` 宇宙中的每种类型已经有一个 `BEq` 实例，但类型类搜索不会自动检查实例声明中数据类型的每种可能情况，因为可能有无限多种情况，就像 `NestedPairs` 一样。
直接向 `BEq` 实例提出申诉而不是通过对编码进行递归来解释如何找到它们会导致错误：

```lean
{{#example_in Examples/DependentTypes/Finite.lean beqNoCases}}
```
```output error
{{#example_out Examples/DependentTypes/Finite.lean beqNoCases}}
```
<!-- The `t` in the error message stands for an unknown value of type `NestedPairs`. -->
错误消息中的 `t` 代表类型 `NestedPairs` 的未知值。

## Type Classes vs Universes

<!-- Type classes allow an open-ended collection of types to be used with an API as long as they have implementations of the necessary interfaces.
In most cases, this is preferable.
It is hard to predict all use cases for an API ahead of time, and type classes are a convenient way to allow library code to be used with more types than the original author expected. -->
类型类允许使用开放集合的类型与 API 一起使用，只要它们具有必要接口的实现。
在大多数情况下，这是可取的。
很难预测 API 的所有用例，类型类是一种方便的方式，允许库代码与原始作者预期的更多类型一起使用。

<!-- A universe à la Tarski, on the other hand, restricts the API to be usable only with a predetermined collection of types.
This is useful in a few situations:
 * When a function should act very differently depending on which type it is passed—it is impossible to pattern match on types themselves, but pattern matching on codes for types is allowed
 * When an external system inherently limits the types of data that may be provided, and extra flexibility is not desired
 * When additional properties of a type are required over and above the implementation of some operations -->
另一方面，Tarski 风格的宇宙将 API 限制为仅可与预定集合的类型一起使用。
在一些情况下，这是有用的：
 * 当一个函数应该根据传递的类型不同而表现得非常不同时——无法对类型本身进行模式匹配，但允许对类型的编码进行模式匹配
 * 当外部系统固有地限制可能提供的数据类型，并且不希望额外的灵活性
 * 当需要超过一些操作的实现的类型的额外属性

<!-- Type classes are useful in many of the same situations as interfaces in Java or C#, while a universe à la Tarski can be useful in cases where a sealed class might be used, but where an ordinary inductive datatype is not usable. -->
类型类在许多情况下与 Java 或 C# 中的接口相同，而 Tarski 风格的宇宙在封闭类可能被使用的情况下可能有用，但普通的归纳数据类型不可用。

<!-- ## A Universe of Finite Types -->
## 一个有限类型的宇宙

<!-- Restricting the types that can be used with an API to a predetermined collection can enable operations that would be impossible for an open-ended API.
For example, functions can't normally be compared for equality.
Functions should be considered equal when they map the same inputs to the same outputs.
Checking this could take infinite amounts of time, because comparing two functions with type `Nat → Bool` would require checking that the functions returned the same `Bool` for each and every `Nat`. -->

限制可以与 API 一起使用的类型为预定集合可以实现开放 API 不可能的操作。
例如，通常无法比较函数是否相等。
当它们将相同的输入映射到相同的输出时，应该认为函数是相等的。
检查这一点可能需要无限的时间，因为比较两个类型为 `Nat → Bool` 的函数需要检查函数对每个 `Nat` 返回相同的 `Bool`。

<!-- In other words, a function from an infinite type is itself infinite.
Functions can be viewed as tables, and a function whose argument type is infinite requires infinitely many rows to represent each case.
But functions from finite types require only finitely many rows in their tables, making them finite.
Two functions whose argument type is finite can be checked for equality by enumerating all possible arguments, calling the functions on each of them, and then comparing the results.
Checking higher-order functions for equality requires generating all possible functions of a given type, which additionally requires that the return type is finite so that each element of the argument type can be mapped to each element of the return type.
This is not a _fast_ method, but it does complete in finite time. -->
换句话说，来自无限类型的函数本身是无限的。
函数可以被视为表格，其参数类型是无限的函数需要无限多行来表示每种情况。
但来自有限类型的函数在其表格中只需要有限多行，使它们是有限的。
两个参数类型是有限的函数可以通过枚举所有可能的参数，对每个参数调用函数，然后比较结果来检查它们是否相等。
检查高阶函数是否相等需要生成给定类型的所有可能函数，此外还需要返回类型是有限的，以便将参数类型的每个元素映射到返回类型的每个元素。
这不是一种 _快速_ 方法，但它确实在有限时间内完成。


<!-- One way to represent finite types is by a universe: -->
表示有限类型的一种方法是通过一个宇宙：

```lean
{{#example_decl Examples/DependentTypes/Finite.lean Finite}}
```
<!-- In this universe, the constructor `arr` stands for the function type, which is written with an `arr`ow. -->
在这个宇宙中，构造函数 `arr` 表示函数类型，用一个 `arr`ow 表示。

<!-- Comparing two values from this universe for equality is almost the same as in the `NestedPairs` universe.
The only important difference is the addition of the case for `arr`, which uses a helper called `Finite.enumerate` to generate every value from the type coded for by `t1`, checking that the two functions return equal results for every possible input: -->
比较这个宇宙中的两个值是否相等与 `NestedPairs` 宇宙中几乎相同。
唯一重要的区别是增加了 `arr` 的情况，它使用一个名为 `Finite.enumerate` 的辅助函数来生成由 `t1` 编码的类型的每个值，检查两个函数对每个可能的输入返回相同的结果：

```lean
{{#example_decl Examples/DependentTypes/Finite.lean FiniteBeq}}
```
<!-- The standard library function `List.all` checks that the provided function returns `true` on every entry of a list.
This function can be used to compare functions on the Booleans for equality: -->
标准库函数 `List.all` 检查提供的函数在列表的每个条目上返回 `true`。
这个函数可以用来比较布尔值上的函数是否相等：

```lean
{{#example_in Examples/DependentTypes/Finite.lean arrBoolBoolEq}}
```
```output info
{{#example_out Examples/DependentTypes/Finite.lean arrBoolBoolEq}}
```
<!-- It can also be used to compare functions from the standard library: -->
它也可以用来比较标准库中的函数：

```lean
{{#example_in Examples/DependentTypes/Finite.lean arrBoolBoolEq2}}
```
```output info
{{#example_out Examples/DependentTypes/Finite.lean arrBoolBoolEq2}}
```
<!-- It can even compare functions built using tools such as function composition: -->
它甚至可以比较使用函数组合等工具构建的函数：

```lean
{{#example_in Examples/DependentTypes/Finite.lean arrBoolBoolEq3}}
```
```output info
{{#example_out Examples/DependentTypes/Finite.lean arrBoolBoolEq3}}
```
<!-- This is because the `Finite` universe codes for Lean's _actual_ function type, not a special analogue created by the library. -->
这是因为 `Finite` 宇宙编码了 Lean 的 _实际_ 函数类型，而不是库创建的特殊类似物。

<!-- The implementation of `enumerate` is also by recursion on the codes from `Finite`. -->
`enumerate` 的实现也是通过对 `Finite` 的编码进行递归。

```lean
{{#include ../../../examples/Examples/DependentTypes/Finite.lean:FiniteAll}}
```
<!-- In the case for `Unit`, there is only a single value.
In the case for `Bool`, there are two values to return (`true` and `false`).
In the case for pairs, the result should be the Cartesian product of the values for the type coded for by `t1` and the values for the type coded for by `t2`.
In other words, every value from `t1` should be paired with every value from `t2`.
The helper function `List.product` can certainly be written with an ordinary recursive function, but here it is defined using `for` in the identity monad: -->
在 `Unit` 的情况下，只有一个值。
在 `Bool` 的情况下，有两个值要返回（`true` 和 `false`）。
在对中的情况下，结果应该是由 `t1` 编码的类型的值和 `t2` 编码的类型的值的笛卡尔积。
换句话说，`t1` 的每个值都应该与 `t2` 的每个值配对。
辅助函数 `List.product` 当然可以用普通的递归函数编写，但这里它是使用 `for` 在恒等单子中定义的：


```lean
{{#example_decl Examples/DependentTypes/Finite.lean ListProduct}}
```
<!-- Finally, the case of `Finite.enumerate` for functions delegates to a helper called `Finite.functions` that takes a list of all of the return values to target as an argument. -->
最后，`Finite.enumerate` 对函数的情况委托给一个名为 `Finite.functions` 的辅助函数，该函数将所有目标返回值的列表作为参数。


<!-- Generally speaking, generating all of the functions from some finite type to a collection of result values can be thought of as generating the functions' tables.
Each function assigns an output to each input, which means that a given function has \\( k \\) rows in its table when there are \\( k \\) possible arguments.
Because each row of the table could select any of \\( n \\) possible outputs, there are \\( n ^ k \\) potential functions to generate. -->
简单来说，生成从某个有限类型到一组结果值的所有函数可以被认为是生成函数的表格。
每个函数将一个输出分配给每个输入，这意味着当有 \\( k \\) 个可能的参数时，给定函数的表格有 \\( k \\) 行。
因为表格的每一行都可以选择 \\( n \\) 个可能的输出中的任何一个，所以有 \\( n ^ k \\) 个潜在的函数要生成。


<!-- Once again, generating the functions from a finite type to some list of values is recursive on the code that describes the finite type: -->
再一次，生成从有限类型到一些值列表的函数是对描述有限类型的编码进行递归的：

```lean
{{#include ../../../examples/Examples/DependentTypes/Finite.lean:FiniteFunctionSigStart}}
```

<!-- The table for functions from `Unit` contains one row, because the function can't pick different results based on which input it is provided.
This means that one function is generated for each potential input. -->
`Unit` 的函数表格包含一行，因为函数不能根据提供的输入选择不同的结果。
这意味着为每个潜在的输入生成一个函数。

```lean
{{#include ../../../examples/Examples/DependentTypes/Finite.lean:FiniteFunctionUnit}}
```
<!-- There are \\( n^2 \\) functions from `Bool` when there are \\( n \\) result values, because each individual function of type `Bool → α` uses the `Bool` to select between two particular `α`s: -->

从 `Bool` 到 \\( n \\) 个结果值时，有 \\( n^2 \\) 个函数，因为类型 `Bool → α` 的每个单独函数使用 `Bool` 在两个特定的 `α` 之间选择：


```lean
{{#include ../../../examples/Examples/DependentTypes/Finite.lean:FiniteFunctionBool}}
```
<!-- Generating the functions from pairs can be achieved by taking advantage of currying.
A function from a pair can be transformed into a function that takes the first element of the pair and returns a function that's waiting for the second element of the pair.
Doing this allows `Finite.functions` to be used recursively in this case: -->
从对中生成函数可以通过利用柯里化来实现。
从对中的函数可以转换为一个函数，该函数接受对的第一个元素并返回一个等待对的第二个元素的函数。
这样做允许在这种情况下递归使用 `Finite.functions`：

```lean
{{#include ../../../examples/Examples/DependentTypes/Finite.lean:FiniteFunctionPair}}
```

<!-- Generating higher-order functions is a bit of a brain bender.
Each higher-order function takes a function as its argument.
This argument function can be distinguished from other functions based on its input/output behavior.
In general, the higher-order function can apply the argument function to every possible argument, and it can then carry out any possible behavior based on the result of applying the argument function.
This suggests a means of constructing the higher-order functions:
 * Begin with a list of all possible arguments to the function that is itself an argument.
 * For each possible argument, construct all possible behaviors that can result from the observation of applying the argument function to the possible argument. This can be done using `Finite.functions` and recursion over the rest of the possible arguments, because the result of the recursion represents the functions based on the observations of the rest of the possible arguments. `Finite.functions` constructs all the ways of achieving these based on the observation for the current argument.
 * For potential behavior in response to these observations, construct a higher-order function that applies the argument function to the current possible argument. The result of this is then passed to the observation behavior.
 * The base case of the recursion is a higher-order function that observes nothing for each result value—it ignores the argument function and simply returns the result value. -->

生成高阶函数有点令人费解。
每个高阶函数都将一个函数作为其参数。
这个参数函数可以根据其输入/输出行为与其他函数区分开来。
一般来说，高阶函数可以将参数函数应用于每个可能的参数，然后根据应用参数函数的结果执行任何可能的行为。
这提出了构造高阶函数的一种方法：
 * 从一个所有可能参数的列表开始，这个列表本身是一个参数函数。
 * 对于每个可能的参数，构造可以由应用参数函数到可能的参数的观察结果产生的所有可能行为。这可以使用 `Finite.functions` 和对其余可能参数的递归来完成，因为递归的结果表示基于其余可能参数的观察的函数。`Finite.functions` 根据当前参数的观察构造所有实现这些方式的方法。
 * 对于这些观察结果的潜在行为，构造一个将参数函数应用于当前可能参数的高阶函数。然后将此结果传递给观察行为。
 * 递归的基本情况是对每个结果值观察无事可做的高阶函数——它忽略参数函数，只是返回结果值。

<!-- Defining this recursive function directly causes Lean to be unable to prove that the whole function terminates.
However, using a simpler form of recursion called a _right fold_ can be used to make it clear to the termination checker that the function terminates.
A right fold takes three arguments: a step function that combines the head of the list with the result of the recursion over the tail, a default value to return when the list is empty, and the list being processed.
It then analyzes the list, essentially replacing each `::` in the list with a call to the step function and replacing `[]` with the default value: -->
直接定义这个递归函数导致 Lean 无法证明整个函数终止。
然而，可以使用一种更简单的递归形式，称为 _右折叠_，以使终止检查器明确地知道函数终止。
右折叠接受三个参数：一个步骤函数，它将列表的头与对尾的递归结果组合在一起，一个列表为空时返回的默认值，以及正在处理的列表。
然后分析列表，实际上将列表中的每个 `::` 替换为对步骤函数的调用，并将 `[]` 替换为默认值：

```lean
{{#example_decl Examples/DependentTypes/Finite.lean foldr}}
```
<!-- Finding the sum of the `Nat`s in a list can be done with `foldr`: -->
可以使用 `foldr` 找到列表中 `Nat` 的和：

```lean
{{#example_eval Examples/DependentTypes/Finite.lean foldrSum}}
```

<!-- With `foldr`, the higher-order functions can be created as follows: -->
使用 `foldr`，可以创建高阶函数如下：

```lean
{{#include ../../../examples/Examples/DependentTypes/Finite.lean:FiniteFunctionArr}}
```
<!-- The complete definition of `Finite.Functions` is: -->
`Finite.Functions` 的完整定义是：

```lean
{{#include ../../../examples/Examples/DependentTypes/Finite.lean:FiniteFunctions}}
```

<!-- Because `Finite.enumerate` and `Finite.functions` call each other, they must be defined in a `mutual` block.
In other words, right before the definition of `Finite.enumerate` is the `mutual` keyword: -->
因为 `Finite.enumerate` 和 `Finite.functions` 互相调用，它们必须在一个 `mutual` 块中定义。
换句话说，在 `Finite.enumerate` 的定义之前是 `mutual` 关键字：

```lean
{{#include ../../../examples/Examples/DependentTypes/Finite.lean:MutualStart}}
```
and right after the definition of `Finite.functions` is the `end` keyword:
```lean
{{#include ../../../examples/Examples/DependentTypes/Finite.lean:MutualEnd}}
```

<!-- This algorithm for comparing functions is not particularly practical.
The number of cases to check grows exponentially; even a simple type like `((Bool × Bool) → Bool) → Bool` describes {{#example_out Examples/DependentTypes/Finite.lean nestedFunLength}} distinct functions.
Why are there so many?
Based on the reasoning above, and using \\( \\left| T \\right| \\) to represent the number of values described by the type \\( T \\), we should expect that
\\[ \\left| \\left( \\left( \\mathtt{Bool} \\times \\mathtt{Bool} \\right) \\rightarrow \\mathtt{Bool} \\right) \\rightarrow \\mathtt{Bool} \\right| \\]
is 
\\[ \\left|\\mathrm{Bool}\\right|^{\\left| \\left( \\mathtt{Bool} \\times \\mathtt{Bool} \\right) \\rightarrow \\mathtt{Bool} \\right| }, \\]
which is
\\[ 2^{2^{\\left| \\mathtt{Bool} \\times \\mathtt{Bool} \\right| }}, \\]
which is
\\[ 2^{2^4} \\]
or 65536.
Nested exponentials grow quickly, and there are many higher-order functions. -->

这种比较函数的算法并不特别实用。
要检查的情况数量呈指数增长；即使是一个简单的类型，如 `((Bool × Bool) → Bool) → Bool`，也描述了 {{#example_out Examples/DependentTypes/Finite.lean nestedFunLength}} 个不同的函数。
为什么会有这么多？
根据上面的推理，并使用 \\( \\left| T \\right| \\) 表示类型 \\( T \\) 描述的值的数量，我们应该期望
\\[ \\left| \\left( \\left( \\mathtt{Bool} \\times \\mathtt{Bool} \\right) \\rightarrow \\mathtt{Bool} \\right) \\rightarrow \\mathtt{Bool} \\right| \\]。

这个值可以一步步化简为

\\[ \\left|\\mathrm{Bool}\\right|^{\\left| \\left( \\mathtt{Bool} \\times \\mathtt{Bool} \\right) \\rightarrow \\mathtt{Bool} \\right| }, \\]

\\[ 2^{2^{\\left| \\mathtt{Bool} \\times \\mathtt{Bool} \\right| }}, \\]

\\[ 2^{2^4} \\]

65536

指数的嵌套会很快的增长，这样的高阶函数还有很多。



<!-- ## Exercises -->
## 联系

 <!-- * Write a function that converts any value from a type coded for by `Finite` into a string. Functions should be represented as their tables.
 * Add the empty type `Empty` to `Finite` and `Finite.beq`.
 * Add `Option` to `Finite` and `Finite.beq`. -->

* 编写一个函数，将由 `Finite` 编码的任何类型的值转换为字符串。函数应该表示为它们的表格。
* 将空类型 `Empty` 添加到 `Finite` 和 `Finite.beq`。
* 将 `Option` 添加到 `Finite` 和 `Finite.beq`。
