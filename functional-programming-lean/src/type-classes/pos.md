<!--
# Positive Numbers
-->

# 正数

<!--
In some applications, only positive numbers make sense.
For example, compilers and interpreters typically use one-indexed line and column numbers for source positions, and a datatype that represents only non-empty lists will never report a length of zero.
Rather than relying on natural numbers, and littering the code with assertions that the number is not zero, it can be useful to design a datatype that represents only positive numbers.
-->

在一些应用场景下，我们只需要用到正数。
对于编译器和解释器来说，它们通常使用起始于1的行和列数来表示源代码位置，
并且一个用于表示非空列表的数据结构永远不会出现长度为零的情况。

<!--
One way to represent positive numbers is very similar to `Nat`, except with `one` as the base case instead of `zero`:
-->

一种表示正数的方法其实和 `Nat` 十分相似，只是用 `one` 作为基本情况而不是 `zero` 。

```lean
{{#example_decl Examples/Classes.lean Pos}}
```

<!--
This datatype represents exactly the intended set of values, but it is not very convenient to use.
For example, numeric literals are rejected:
-->

这个数据类型很好的代表了我们期望的值的集合，但是它用起来并不是很方便。比如说，无法使用数字字面量。

```lean
{{#example_in Examples/Classes.lean sevenOops}}
```
```output error
{{#example_out Examples/Classes.lean sevenOops}}
```

<!--
Instead, the constructors must be used directly:
-->

而是必须要直接使用构造子。

```lean
{{#example_decl Examples/Classes.lean seven}}
```

<!--
Similarly, addition and multiplication are not easy to use:
-->

类似地，加法和乘法用起来也很费劲。

```lean
{{#example_in Examples/Classes.lean fourteenOops}}
```
```output error
{{#example_out Examples/Classes.lean fourteenOops}}
```
```lean
{{#example_in Examples/Classes.lean fortyNineOops}}
```
```output error
{{#example_out Examples/Classes.lean fortyNineOops}}
```

<!--
Each of these error messages begins with `failed to synthesize instance`.
This indicates that the error is due to an overloaded operation that has not been implemented, and it describes the type class that must be implemented.
-->

这类错误都会以 `failed to synthesize instance` 开头。这意味着这个错误是因为使用的操作符重载还没有被实现，
并且指出了应该实现的类型类。

<!--
## Classes and Instances
-->

## 类与实例

<!--
A type class consists of a name, some parameters, and a collection of _methods_.
The parameters describe the types for which overloadable operations are being defined, and the methods are the names and type signatures of the overloadable operations.
Once again, there is a terminology clash with object-oriented languages.
In object-oriented programming, a method is essentially a function that is connected to a particular object in memory, with special access to the object's private state.
Objects are interacted with via their methods.
In Lean, the term "method" refers to an operation that has been declared to be overloadable, with no special connection to objects or values or private fields.
-->

一个类型类是由名称，一些参数，和一族**方法（method）**构成的。参数定义了可重载运算符的类型，
而方法则是可重载运算符的名称和类型签名。这里再次出现了与面向对象语言之间的术语冲突。在面向对象编程中，
一个方法本质上是一个与内存中的一个特定对象有关联的函数，并且具有访问该对象的私有状态的特权。我们通过方法与对象进行交互。
在 Lean 中，“方法”这个词项指一个被声明为可重载的运算符，与对象、值或是私有字段并无特殊关联。

<!--
One way to overload addition is to define a type class named `Plus`, with an addition method named `plus`.
Once an instance of `Plus` for `Nat` has been defined, it becomes possible to add two `Nat`s using `Plus.plus`:
-->

一种重载加法的方法是定义一个名为 `Plus` 的类型类，其加法方法名为 `plus`。
一旦为 `Nat` 定义了 `Plus` 的实例，就使得用 `Plus.plus` 将两个 `Nat` 相加成为可能：

```lean
{{#example_in Examples/Classes.lean plusNatFiveThree}}
```
```output info
{{#example_out Examples/Classes.lean plusNatFiveThree}}
```
<!--
Adding more instances allows `Plus.plus` to take more types of arguments.
-->

添加更多的实例可以使 `Plus.plus` 能够接受更多类型的参数

<!--
In the following type class declaration, `Plus` is the name of the class, `α : Type` is the only argument, and `plus : α → α → α` is the only method:
-->

在下面的类型类声明中，`Plus` 是类的名称，`α : Type` 是唯一的参数，并且 `plus : α → α → α` 是唯一的方法：

```lean
{{#example_decl Examples/Classes.lean Plus}}
```

<!--
This declaration says that there is a type class `Plus` that overloads operations with respect to a type `α`.
In particular, there is one overloaded operation called `plus` that takes two `α`s and returns an `α`.
-->

此声明表示存在类型类 `Plus`，它对类型 `α` 的操作进行重载。
具体到这段代码，存在一个称为 `plus` 的重载操作，它接受两个 `α` 并返回一个 `α`。

<!--
Type classes are first class, just as types are first class.
In particular, a type class is another kind of type.
The type of `{{#example_in Examples/Classes.lean PlusType}}` is `{{#example_out Examples/Classes.lean PlusType}}`, because it takes a type as an argument (`α`) and results in a new type that describes the overloading of `Plus`'s operation for `α`.
-->

类型类是一等公民，就像类型是一等公民一样。
我们更可以说，类型类是另一种类型。
`{{#example_in Examples/Classes.lean PlusType}}` 的类型是 `{{#example_out Examples/Classes.lean PlusType}}`，因为它获取一个类型作为参数（`α`），并导致一个新类型，它描述了 `Plus` 的运算符对于 `α` 的重载。


<!--
To overload `plus` for a particular type, write an instance:
-->

写一个实例来为特定类型重载 `Plus`：

```lean
{{#example_decl Examples/Classes.lean PlusNat}}
```
<!--
The colon after `instance` indicates that `Plus Nat` is indeed a type.
Each method of class `Plus` should be assigned a value using `:=`.
In this case, there is only one method: `plus`.
-->

`instance` 后跟的冒号暗示了 `Plus Nat` 的确是一个类型。
`Plus` 类中的每个方法都要用 `:=` 来赋值。
在这个例子中，只有一个 `plus` 方法。

<!--
By default, type class methods are defined in a namespace with the same name as the type class.
It can be convenient to `open` the namespace so that users don't need to type the name of the class first.
Parentheses in an `open` command indicate that only the indicated names from the namespace are to be made accessible:
-->

默认情况下，类型类方法在与类型类同名的命名空间中定义。
如果将该命名空间打开（使用 `open` 指令）会使该方法使用起来十分方便——这样用户就不用先输入类名了。
`open` 指令后跟的括号表示只有括号内指定的名称才可以被访问。

```lean
{{#example_decl Examples/Classes.lean openPlus}}

{{#example_in Examples/Classes.lean plusNatFiveThreeAgain}}
```
```output info
{{#example_out Examples/Classes.lean plusNatFiveThreeAgain}}
```

<!--
Defining an addition function for `Pos` and an instance of `Plus Pos` allows `plus` to be used to add both `Pos` and `Nat` values:
-->

为 `Pos` 定义一个加法函数和一个 `Plus Pos` 的实例，这样就可以使用 `plus` 来相加 `Pos` 和 `Nat` 值。

```lean
{{#example_decl Examples/Classes.lean PlusPos}}
```

<!--
Because there is not yet an instance of `Plus Float`, attempting to add two floating-point numbers with `plus` fails with a familiar message:
-->

因为我们还没有 `Plus Float` 的实例， 所以尝试使用 `plus` 将两个浮点数相加会得到类似的错误信息：

```lean
{{#example_in Examples/Classes.lean plusFloatFail}}
```
```output error
{{#example_out Examples/Classes.lean plusFloatFail}}
```
<!--
These errors mean that Lean was unable to find an instance for a given type class.
-->

这个报错意味着对于所给的类型类，Lean 并不能找到一个实例。

<!--
## Overloaded Addition
-->

## 重载加法运算符

<!--
Lean's built-in addition operator is syntactic sugar for a type class called `HAdd`, which flexibly allows the arguments to addition to have different types.
`HAdd` is short for _heterogeneous addition_.
For example, an `HAdd` instance can be written to allow a `Nat` to be added to a `Float`, resulting in a new `Float`.
When a programmer writes `{{#example_eval Examples/Classes.lean plusDesugar 0}}`, it is interpreted as meaning `{{#example_eval Examples/Classes.lean plusDesugar 1}}`.
-->

Lean 的内置加法运算符是 `HAdd` 类型类的语法糖，这使加法运算符可以灵活的接受不同类型的参数。
`HAdd` 是**异质加法（Heterogeneous Addition）**的缩写。
比如说，我们可以写一个 `HAdd` 实例来允许 `Nat` 和 `Float` 相加，其结果为一个新的 `Float`。
当程序员写了 `{{#example_eval Examples/Classes.lean plusDesugar 0}}` 时，它会被解释为 `{{#example_eval Examples/Classes.lean plusDesugar 1}}`。

<!--
While an understanding of the full generality of `HAdd` relies on features that are discussed in [another section in this chapter](out-params.md), there is a simpler type class called `Add` that does not allow the types of the arguments to be mixed.
The Lean libraries are set up so that an instance of `Add` will be found when searching for an instance of `HAdd` in which both arguments have the same type.
-->

虽然对 `HAdd` 的全部通用性的理解依赖于[另一章节](out-params.md)中讨论的特性，但还有一个更简单的类型类叫做 `Add`，它不允许出现不同类型的参数。
Lean 库被设置成当搜索一个 `HAdd` 实例时，如果两个参数具有相同的类型，就会找到一个 Add 的实例。

<!--
Defining an instance of `Add Pos` allows `Pos` values to use ordinary addition syntax:
-->

定义一个 `Add Pos` 的实例来让 `Pos` 类型的值可以使用常规的加法语法。

```lean
{{#example_decl Examples/Classes.lean AddPos}}

{{#example_decl Examples/Classes.lean betterFourteen}}
```

<!--
## Conversion to Strings
-->

## 转换为字符串

<!--
Another useful built-in class is called `ToString`.
Instances of `ToString` provide a standard way of converting values from a given type into strings.
For example, a `ToString` instance is used when a value occurs in an interpolated string, and it determines how the `IO.println` function used at the [beginning of the description of `IO`](../hello-world/running-a-program.html#running-a-program) will display a value.
-->

另一个有用的内置类叫做 `ToString`。
`ToString` 的实例提供了一种将给定类型转换为字符串的标准方式。
例如，当值出现在插值字符串中时，会使用 ToString 实例。它决定了在[`IO` 的描述开始处](../hello-world/running-a-program.html#running-a-program)使用的 `IO.println` 函数如何显示一个值。

<!--
For example, one way to convert a `Pos` into a `String` is to reveal its inner structure.
The function `posToString` takes a `Bool` that determines whether to parenthesize uses of `Pos.succ`, which should be `true` in the initial call to the function and `false` in all recursive calls.
-->

例如，一种将 `Pos` 转换为 `String` 的方式就是解析它的内部结构。
函数 `posToString` 接受一个决定是否给`Pos.succ`加上括号的 `Bool` 值，该值在第一次调用时应该为 `true`，在后续递归调用中应该为 `false`。

```lean
{{#example_decl Examples/Classes.lean posToStringStructure}}
```
<!--
Using this function for a `ToString` instance:
-->

使用这个函数作为 `ToString` 的一个实例：

```lean
{{#example_decl Examples/Classes.lean UglyToStringPos}}
```
<!--
results in informative, yet overwhelming, output:
-->

会产生信息丰富但可能过于冗长的输出：

```lean
{{#example_in Examples/Classes.lean sevenLong}}
```
```output info
{{#example_out Examples/Classes.lean sevenLong}}
```

<!--
On the other hand, every positive number has a corresponding `Nat`.
Converting it to a `Nat` and then using the `ToString Nat` instance (that is, the overloading of `toString` for `Nat`) is a quick way to generate much shorter output:
-->

另一方面，每个正数都有一个对应的 `Nat`。
将其转换为 Nat，然后使用 `ToString Nat` 实例（即对 `Nat` 的 `toString` 重载）是一种生成更简短输出的快捷方法：

```lean
{{#example_decl Examples/Classes.lean posToNat}}

{{#example_decl Examples/Classes.lean PosToStringNat}}

{{#example_in Examples/Classes.lean sevenShort}}
```
```output info
{{#example_out Examples/Classes.lean sevenShort}}
```
<!--
When more than one instance is defined, the most recent takes precedence.
Additionally, if a type has a `ToString` instance, then it can be used to display the result of `#eval` even if the type in question was not defined with `deriving Repr`, so `{{#example_in Examples/Classes.lean sevenEvalStr}}` outputs `{{#example_out Examples/Classes.lean sevenEvalStr}}`.
-->

当定义了多个实例时，最近的实例优先级最高。
此外，如果一个类型有一个 `ToString` 实例，那么它可以用来显示 `#eval` 的结果，即使该类型并没有使用 `deriving Repr` 定义，所以 `{{#example_in Examples/Classes.lean sevenEvalStr}}` 输出 `{{#example_out Examples/Classes.lean sevenEvalStr}}`。

<!--
## Overloaded Multiplication
-->

## 重载乘法运算符

<!--
For multiplication, there is a type class called `HMul` that allows mixed argument types, just like `HAdd`.
Just as `{{#example_eval Examples/Classes.lean plusDesugar 0}}` is interpreted as `{{#example_eval Examples/Classes.lean plusDesugar 1}}`, `{{#example_eval Examples/Classes.lean timesDesugar 0}}` is interpreted as `{{#example_eval Examples/Classes.lean timesDesugar 1}}`.
For the common case of multiplication of two arguments with the same type, a `Mul` instance suffices.
-->

对乘法来说，也有一个被称为 `HMul` 的类型类可以接受不同类型的参数相乘，就像 `HAdd` 一样。
就像 `{{#example_eval Examples/Classes.lean plusDesugar 0}}` 会被解释为 `{{#example_eval Examples/Classes.lean plusDesugar 1}}`，`{{#example_eval Examples/Classes.lean timesDesugar 0}}` 也会被解释为 `{{#example_eval Examples/Classes.lean timesDesugar 1}}`。
对于两个相同类型的参数的乘法的常见情况，一个 `Mul` 实例就足够了。

<!--
An instance of `Mul` allows ordinary multiplication syntax to be used with `Pos`:
-->

实现一个 `Mul` 的实例就可以使常规乘法语法被用于 `Pos` 类型：

```lean
{{#example_decl Examples/Classes.lean PosMul}}
```
<!--
With this instance, multiplication works as expected:
-->

有了这个实例，乘法就会按我们预想的方式进行了：

```lean
{{#example_in Examples/Classes.lean muls}}
```
```output info
{{#example_out Examples/Classes.lean muls}}
```

<!--
## Literal Numbers
-->

## 数字字面量

<!--
It is quite inconvenient to write out a sequence of constructors for positive numbers.
One way to work around the problem would be to provide a function to convert a `Nat` into a `Pos`.
However, this approach has downsides.
First off, because `Pos` cannot represent `0`, the resulting function would either convert a `Nat` to a bigger number, or it would return `Option Pos`.
Neither is particularly convenient for users.
Secondly, the need to call the function explicitly would make programs that use positive numbers much less convenient to write than programs that use `Nat`.
Having a trade-off between precise types and convenient APIs means that the precise types become less useful.
-->

写一串构造子来表示正数是非常不方便的。
一种解决问题的方法是提供一个将 `Nat` 转换为 `Pos` 的函数。
然而，这种方法也有不足。
首先，因为 `Pos` 并不能表示 `0`，用来表示结果的函数要么将 `Nat` 转换为更大的数字，要么就需要返回 `Option Pos`。
这两种方式对用户来说都非常不方便。
其次，需要显式调用函数会让使用正数的程序不如使用 `Nat` 的程序那么方便。
在精确的类型和方便的 API 之间权衡一下后，精确的类型还是没那么有用。

<!--
In Lean, natural number literals are interpreted using a type class called `OfNat`:
-->

Lean 是通过使用一个叫做 `OfNat` 的类型类来解释数字字面量的：

```lean
{{#example_decl Examples/Classes.lean OfNat}}
```
<!--
This type class takes two arguments: `α` is the type for which a natural number is overloaded, and the unnamed `Nat` argument is the actual literal number that was encountered in the program.
The method `ofNat` is then used as the value of the numeric literal.
Because the class contains the `Nat` argument, it becomes possible to define only instances for those values where the number makes sense.
-->

这个类型类接受两个参数：`α` 是需要重载自然数的类型，未命名的 `Nat` 类型参数是你希望在程序中实际使用的数字字面量。
`ofNat` 方法被用作数字字面量的值。
由于原类包含了 `Nat` 参数，因此可以仅为那些使数字有意义的值定义实例。

<!--
`OfNat` demonstrates that the arguments to type classes do not need to be types.
Because types in Lean are first-class participants in the language that can be passed as arguments to functions and given definitions with `def` and `abbrev`, there is no barrier that prevents non-type arguments in positions where a less-flexible language could not permit them.
This flexibility allows overloaded operations to be provided for particular values as well as particular types.
-->

`OfNat`展示了类型类的参数不需要是类型。
因为在 Lean 中，类型是语言中的一等公民，可以作为参数传递给函数，并且可以使用 `def` 和 `abbrev` 给出定义。
Lean 并不阻止非类型参数出现在类型类的参数位置上，但一些不够灵活的语言则不允许这种操作。
这种灵活性能为特定的值以及特定的类型提供运算符重载。

<!--
For example, a sum type that represents natural numbers less than four can be defined as follows:
-->

例如，一个表示小于4的自然数的和类型可被定义如下：

```lean
{{#example_decl Examples/Classes.lean LT4}}
```

<!--
While it would not make sense to allow _any_ literal number to be used for this type, numbers less than four clearly make sense:
-->

然而，并不是**每个**数字字面量对于这个类型都是合理的，只有小于4的数是合理的：

```lean
{{#example_decl Examples/Classes.lean LT4ofNat}}
```

<!--
With these instances, the following examples work:
-->

有了上面的实例，我们就可以使用它们了：

```lean
{{#example_in Examples/Classes.lean LT4three}}
```
```output info
{{#example_out Examples/Classes.lean LT4three}}
```
```lean
{{#example_in Examples/Classes.lean LT4zero}}
```
```output info
{{#example_out Examples/Classes.lean LT4zero}}
```

<!--
On the other hand, out-of-bounds literals are still not allowed:
-->

另一方面，越界的字面量也是不行的。

```lean
{{#example_in Examples/Classes.lean LT4four}}
```
```output error
{{#example_out Examples/Classes.lean LT4four}}
```

<!--
For `Pos`, the `OfNat` instance should work for _any_ `Nat` other than `Nat.zero`.
Another way to phrase this is to say that for all natural numbers `n`, the instance should work for `n + 1`.
Just as names like `α` automatically become implicit arguments to functions that Lean fills out on its own, instances can take automatic implicit arguments.
In this instance, the argument `n` stands for any `Nat`, and the instance is defined for a `Nat` that's one greater:
-->

对于 `Pos` 来说，`OfNat` 实例应该适用于除 `Nat.zero` 外的**任何**`Nat`。
另一种表达方式是说，对于所有的自然数 `n`，该实例应该适用于 `n + 1`。
就像 `α` 这样的名称会自动成为 Lean 自动填充的函数的隐式参数一样，实例也可以接受自动隐式参数。
在这个实例中，参数 `n` 代表任何 `Nat`，并且该实例是为一个比给定 `Nat` 大一的 `Nat` 定义的：

```lean
{{#example_decl Examples/Classes.lean OfNatPos}}
```
<!--
Because `n` stands for a `Nat` that's one less than what the user wrote, the helper function `natPlusOne` returns a `Pos` that's one greater than its argument.
This makes it possible to use natural number literals for positive numbers, but not for zero:
-->

因为 `n` 代表的数比用户实际写的要小一，所以辅助函数 `natPlusOne` 返回一个比它的参数大一的 `Pos`。这使得用自然数字面量表示正数成为可能，同时不会表示零：

```lean
{{#example_decl Examples/Classes.lean eight}}

{{#example_in Examples/Classes.lean zeroBad}}
```
```output error
{{#example_out Examples/Classes.lean zeroBad}}
```

<!--
## Exercises
-->

## 练习

<!--
### Another Representation
-->

### 另一种表示

<!--
An alternative way to represent a positive number is as the successor of some `Nat`.
Replace the definition of `Pos` with a structure whose constructor is named `succ` that contains a `Nat`:
-->

另一种方式来表示正数是用某个 `Nat` 的后继。
用一个名为 `succ` 的结构体替换 `Pos` 的定义，该结构体包含一个 `Nat`：

```lean
{{#example_decl Examples/Classes.lean AltPos}}
```
<!--
Define instances of `Add`, `Mul`, `ToString`, and `OfNat` that allow this version of `Pos` to be used conveniently.
-->

定义 `Add`，`Mul`，`ToString`，和 `OfNat`的实例来让这个版本的 `Pos` 用起来更方便。

<!--
### Even Numbers
-->

### 偶数

<!--
Define a datatype that represents only even numbers. Define instances of `Add`, `Mul`, and `ToString` that allow it to be used conveniently.
`OfNat` requires a feature that is introduced in [the next section](polymorphism.md).
-->

定义一个只表示偶数的数据类型。定义`Add`，`Mul`，和 `ToString`来让它用起来更方便。
定义 `OfNat` 需要[下一节](polymorphism.md)中介绍的特性。

<!--
### HTTP Requests
-->

### HTTP 请求

<!--
An HTTP request begins with an identification of a HTTP method, such as `GET` or `POST`, along with a URI and an HTTP version.
Define an inductive type that represents an interesting subset of the HTTP methods, and a structure that represents HTTP responses.
Responses should have a `ToString` instance that makes it possible to debug them.
Use a type class to associate different `IO` actions with each HTTP method, and write a test harness as an `IO` action that calls each method and prints the result.
-->

一个 HTTP 请求以一个 HTTP 方法的标识开始，比如 `GET` 或 `POST`，还包括一个 URI 和一个 HTTP 版本。
定义一个归纳类型，代表 HTTP 方法的一个有趣的子集，并且定义一个表示 HTTP 响应的结构体。
响应应该有一个 `ToString` 实例，使得可以对其进行调试。
使用一个类型类来将不同的 `IO` 操作与每个 HTTP 方法关联起来，
并编写一个测试工具作为一个 `IO` 操作，调用每个方法并打印结果。
