<!--
# Functions and Definitions
-->

# 函数与定义

<!--
In Lean, definitions are introduced using the `def` keyword. For instance, to define the name `{{#example_in Examples/Intro.lean helloNameVal}}` to refer to the string `{{#example_out Examples/Intro.lean helloNameVal}}`, write:
-->

在 Lean 中，使用 `def` 关键字引入定义。例如，若要定义名称
`{{#example_in Examples/Intro.lean helloNameVal}}` 来引用字符串
`{{#example_out Examples/Intro.lean helloNameVal}}`，请编写：

```lean
{{#example_decl Examples/Intro.lean hello}}
```

<!--
In Lean, new names are defined using the colon-equal operator`:=`
rather than `=`. This is because `=` is used to describe equalities
between existing expressions, and using two different operators helps
prevent confusion.
-->

在 Lean 中，使用冒号加等号运算符 `:=` 而不是 `=` 来定义新名称。这是因为 `=`
用于描述现有表达式之间的相等性，而使用两个不同的运算符有助于防止混淆。

<!--
In the definition of `{{#example_in Examples/Intro.lean helloNameVal}}`, the expression `{{#example_out Examples/Intro.lean helloNameVal}}` is simple enough that Lean is able to determine the definition's type automatically.
However, most definitions are not so simple, so it will usually be necessary to add a type.
This is done using a colon after the name being defined.
-->

在 `{{#example_in Examples/Intro.lean helloNameVal}}` 的定义中，表达式
`{{#example_out Examples/Intro.lean helloNameVal}}` 足够简单，Lean
能够自动确定定义的类型。但是，大多数定义并不那么简单，因此通常需要添加类型。
这可以通过在要定义的名称后使用冒号来完成。

```lean
{{#example_decl Examples/Intro.lean lean}}
```

<!--
Now that the names have been defined, they can be used, so
-->

现在定义了名称，就可以使用它们了，因此

``` Lean
{{#example_in Examples/Intro.lean helloLean}}
```

<!--
outputs
-->

会输出

``` Lean info
{{#example_out Examples/Intro.lean helloLean}}
```

<!--
In Lean, defined names may only be used after their definitions.
-->

在 Lean 中，定义的名称只能在其定义之后使用。

<!--
In many languages, definitions of functions use a different syntax than definitions of other values.
For instance, Python function definitions begin with the `def` keyword, while other definitions are defined with an equals sign.
In Lean, functions are defined using the same `def` keyword as other values.
Nonetheless, definitions such as `hello` introduce names that refer _directly_ to their values, rather than to zero-argument functions that return equivalent results each time they are called.
-->

在很多语言中，函数定义的语法与其他值的不同。例如，Python 函数定义以 `def` 关键字开头，
而其他定义则以等号定义。在 Lean 中，函数使用与其他值相同的 `def` 关键字定义。
尽管如此，像 `hello` 这类的定义引入的名字会  **直接** 引用其值，而非每次调用一个零参函数返回等价的值。

<!--
## Defining Functions
-->

## 定义函数

<!--
There are a variety of ways to define functions in Lean. The simplest is to place the function's arguments before the definition's type, separated by spaces. For instance, a function that adds one to its argument can be written:
-->

在 Lean 中有各种方法可以定义函数。最简单的方法是在定义的类型之前放置函数的参数，并用空格分隔。
例如，可以编写一个将其参数加 1 的函数：

```lean
{{#example_decl Examples/Intro.lean add1}}
```

<!--
Testing this function with `#eval` gives `{{#example_out Examples/Intro.lean add1_7}}`, as expected:
-->

测试此函数时，`#eval` 给出了 `{{#example_out Examples/Intro.lean add1_7}}`，符合预期：

```lean
{{#example_in Examples/Intro.lean add1_7}}
```

<!--
Just as functions are applied to multiple arguments by writing spaces between each argument, functions that accept multiple arguments are defined with spaces between the arguments' names and types. The function `maximum`, whose result is equal to the greatest of its two arguments, takes two `Nat` arguments `n` and `k` and returns a `Nat`.
-->

就像将函数应用于多个参数会用空格分隔一样，接受多个参数的函数定义也是在参数名与类型之间添加空格。
函数 `maximum` 的结果等于其两个参数中最大的一个，它接受两个 `Nat` 参数 `n` 和 `k`，并返回一个 `Nat`。


```lean
{{#example_decl Examples/Intro.lean maximum}}
```

<!--
When a defined function like `maximum` has been provided with its arguments, the result is determined by first replacing the argument names with the provided values in the body, and then evaluating the resulting body. For example:
-->

当向 `maximum` 这样的已定义函数被提供参数时，其结果会首先用提供的值替换函数体中对应的参数名称，
然后对产生的函数体求值。例如：

```lean
{{#example_eval Examples/Intro.lean maximum_eval}}
```

<!--
Expressions that evaluate to natural numbers, integers, and strings have types that say this (`Nat`, `Int`, and `String`, respectively).
This is also true of functions.
A function that accepts a `Nat` and returns a `Bool` has type `Nat → Bool`, and a function that accepts two `Nat`s and returns a `Nat` has type `Nat → Nat → Nat`.
-->

求值结果为自然数、整数和字符串的表达式具有表示它们的类型（分别为 `Nat`、`Int` 和 `String`）。
函数也是如此，接受一个 `Nat` 并返回一个 `Bool` 的函数的类型为 `Nat → Bool`，接受两个 `Nat`
并返回一个 `Nat` 的函数的类型为 `Nat → Nat → Nat`。

<!--
As a special case, Lean returns a function's signature when its name is used directly with `#check`.
Entering `{{#example_in Examples/Intro.lean add1sig}}` yields `{{#example_out Examples/Intro.lean add1sig}}`.
However, Lean can be "tricked" into showing the function's type by writing the function's name in parentheses, which causes the function to be treated as an ordinary expression, so `{{#example_in Examples/Intro.lean add1type}}` yields `{{#example_out Examples/Intro.lean add1type}}` and `{{#example_in Examples/Intro.lean maximumType}}` yields `{{#example_out Examples/Intro.lean maximumType}}`.
This arrow can also be written with an ASCII alternative arrow `->`, so the preceding function types can be written `{{#example_out Examples/Intro.lean add1typeASCII}}` and `{{#example_out Examples/Intro.lean maximumTypeASCII}}`, respectively.
-->

作为一个特例，当函数的名称直接与 `#check` 一起使用时，Lean 会返回函数的签名。
输入 `{{#example_in Examples/Intro.lean add1sig}}`
会产生 `{{#example_out Examples/Intro.lean add1sig}}`。
但是，可以通过用括号括住函数名称来「欺骗」Lean 显示函数的类型，
这会导致函数被视为一个普通表达式，所以 `{{#example_in Examples/Intro.lean add1type}}`
会产生 `{{#example_out Examples/Intro.lean add1type}}`
而 `{{#example_in Examples/Intro.lean maximumType}}`
会产生 `{{#example_out Examples/Intro.lean maximumType}}`。
此箭头也可以写作 ASCII 的箭头 `->`，因此前面的函数类型可以分别写作
`{{#example_out Examples/Intro.lean add1typeASCII}}` 和
`{{#example_out Examples/Intro.lean maximumTypeASCII}}`。

<!--
Behind the scenes, all functions actually expect precisely one argument.
Functions like `maximum` that seem to take more than one argument are in fact functions that take one argument and then return a new function.
This new function takes the next argument, and the process continues until no more arguments are expected.
This can be seen by providing one argument to a multiple-argument function: `{{#example_in Examples/Intro.lean maximum3Type}}` yields `{{#example_out Examples/Intro.lean maximum3Type}}` and `{{#example_in Examples/Intro.lean stringAppendHelloType}}` yields `{{#example_out Examples/Intro.lean stringAppendHelloType}}`.
Using a function that returns a function to implement multiple-argument functions is called _currying_ after the mathematician Haskell Curry.
Function arrows associate to the right, which means that `Nat → Nat → Nat` should be parenthesized `Nat → (Nat → Nat)`.
-->

在幕后，所有函数实际上都刚好接受一个参数。像 `maximum` 这样的函数看起来需要多个参数，
但实际上它们时接受一个参数并返回一个新的函数。这个新函数接受下一个参数，
一直持续到不再需要更多参数。可以通过向一个多参数函数提供一个参数来看到这一点：
`{{#example_in Examples/Intro.lean maximum3Type}}`
会产生 `{{#example_out Examples/Intro.lean maximum3Type}}`，
而 `{{#example_in Examples/Intro.lean stringAppendHelloType}}`
会产生 `{{#example_out Examples/Intro.lean stringAppendHelloType}}`。
使用返回函数的函数来实现多参数函数被称为"  **柯里化（Currying）** ，
以数学家哈斯克尔·柯里（Haskell Curry）命名。
函数箭头是右结合的，这意味着 `Nat → Nat → Nat` 等价于 `Nat → (Nat → Nat)`。

<!--
### Exercises
-->

### 练习

<!--
 * Define the function `joinStringsWith` with type `String -> String -> String -> String` that creates a new string by placing its first argument between its second and third arguments. `{{#example_eval Examples/Intro.lean joinStringsWithEx 0}}` should evaluate to `{{#example_eval Examples/Intro.lean joinStringsWithEx 1}}`.
 * What is the type of `joinStringsWith ": "`? Check your answer with Lean.
 * Define a function `volume` with type `Nat → Nat → Nat → Nat` that computes the volume of a rectangular prism with the given height, width, and depth.
-->

* 定义函数 `joinStringsWith`，类型为 `String -> String -> String -> String`，
  它通过将第一个参数放在第二个和第三个参数之间来创建一个新字符串。
  `{{#example_eval Examples/Intro.lean joinStringsWithEx 0}}` 应当会求值为
  `{{#example_eval Examples/Intro.lean joinStringsWithEx 1}}`。
* `joinStringsWith ": "` 的类型是什么？用 Lean 检查你的答案。
* 定义一个函数 `volume`，类型为 `Nat → Nat → Nat → Nat`，
  它计算给定高度、宽度和深度的矩形棱柱的体积。

<!--
## Defining Types
-->

## 定义类型

<!--
Most typed programming languages have some means of defining aliases for types, such as C's `typedef`.
In Lean, however, types are a first-class part of the language - they are expressions like any other.
This means that definitions can refer to types just as well as they can refer to other values.
-->

大多数类型化编程语言都有一些方法来定义类型的别名，例如 C 语言的 `typedef`。
然而，在 Lean 中，类型是语言的一等部分——它们与其他任何表达式一样都是表达式，
这意味着定义可以引用类型，就像它们可以引用其他值一样。

<!--
For instance, if ``String`` is too much to type, a shorter abbreviation ``Str`` can be defined:
-->

例如，如果 `String` 输入起来太长，可以定义一个较短的缩写 `Str`：

```lean
{{#example_decl Examples/Intro.lean StringTypeDef}}
```

<!--
It is then possible to use ``Str`` as a definition's type instead of ``String``:
-->

然后就可以使用 `Str` 作为定义的类型，而非 `String`：

```lean
{{#example_decl Examples/Intro.lean aStr}}
```

<!--
The reason this works is that types follow the same rules as the rest of Lean.
Types are expressions, and in an expression, a defined name can be replaced with its definition.
Because ``Str`` has been defined to mean ``String``, the definition of ``aStr`` makes sense.
-->

这之所以可行，是因为类型遵循与 Lean 其他部分相同的规则。
类型是表达式，而在表达式中，已定义的名称可以用其定义替换。由于 `Str` 已被定义为
`String`，因此 `aStr` 的定义是有意义的。

<!--
### Messages You May Meet
-->

### 你可能会遇到的信息

<!--
Experimenting with using definitions for types is made more complicated by the way that Lean supports overloaded integer literals.
If ``Nat`` is too short, a longer name ``NaturalNumber`` can be defined:
-->

由于 Lean 支持重载整数字面量，因此使用定义作为类型进行实验会变得更加复杂。
如果 `Nat` 太短，可以定义一个较长的名称 `NaturalNumber`：

```lean
{{#example_decl Examples/Intro.lean NaturalNumberTypeDef}}
```

<!--
However, using ``NaturalNumber`` as a definition's type instead of ``Nat`` does not have the expected effect.
In particular, the definition:
-->

然而，使用 `NaturalNumber` 作为定义的类型而非 `Nat` 并没有预期的效果。特别是，定义：

```lean
{{#example_in Examples/Intro.lean thirtyEight}}
```

<!--
results in the following error:
-->

会导致以下错误：

```output error
{{#example_out Examples/Intro.lean thirtyEight}}
```

<!--
This error occurs because Lean allows number literals to be _overloaded_.
When it makes sense to do so, natural number literals can be used for new types, just as if those types were built in to the system.
This is part of Lean's mission of making it convenient to represent mathematics, and different branches of mathematics use number notation for very different purposes.
The specific feature that allows this overloading does not replace all defined names with their definitions before looking for overloading, which is what leads to the error message above.
-->

产生该错误的原因是 Lean 允许数字字面量被  **重载（Overload）** 。
当有意义时，自然数字面量可用作新类型，就像这些类型内置在系统中一样。
这能让 Lean 方便地表示数学，而数学的不同分支会将数字符号用作完全不同的目的。
这种允许重载的特性，并不会在找到重载之前用其定义替换所有已定义的名称，
这正是导致出现以上错误消息的原因。

<!--
One way to work around this limitation is by providing the type `Nat` on the right-hand side of the definition, causing `Nat`'s overloading rules to be used for `38`:
-->

解决此限制的一种方法是在定义的右侧提供类型 `Nat`，从而让 `Nat` 的重载规则用于 `38`：

```lean
{{#example_decl Examples/Intro.lean thirtyEightFixed}}
```

<!--
The definition is still type-correct because `{{#example_eval Examples/Intro.lean NaturalNumberDef 0}}` is the same type as `{{#example_eval Examples/Intro.lean NaturalNumberDef 1}}`—by definition!
-->

该定义的类型仍然正确，因为根据定义，`{{#example_eval Examples/Intro.lean NaturalNumberDef 0}}`
与 `{{#example_eval Examples/Intro.lean NaturalNumberDef 1}}` 是同一种类型！

<!--
Another solution is to define an overloading for `NaturalNumber` that works equivalently to the one for `Nat`.
This requires more advanced features of Lean, however.
-->

另一种解决方案是为 `NaturalNumber` 定义一个重载，其作用等同于 `Nat` 的重载。
然而，这需要 Lean 的更多高级特性。

<!--
Finally, defining the new name for `Nat` using `abbrev` instead of `def` allows overloading resolution to replace the defined name with its definition.
Definitions written using `abbrev` are always unfolded.
For instance,
-->

最后，使用 `abbrev` 而非 `def` 来为 `Nat` 定义新名称，
能够让重载解析以其定义来替换所定义的名称。使用 `abbrev` 编写的定义总是会展开。例如，

```lean
{{#example_decl Examples/Intro.lean NTypeDef}}
```

<!--
and
-->

和

```lean
{{#example_decl Examples/Intro.lean thirtyNine}}
```

<!--
are accepted without issue.
-->

会被接受而不会出现问题。

<!--
Behind the scenes, some definitions are internally marked as being unfoldable during overload resolution, while others are not.
Definitions that are to be unfolded are called _reducible_.
Control over reducibility is essential to allow Lean to scale: fully unfolding all definitions can result in very large types that are slow for a machine to process and difficult for users to understand.
Definitions produced with `abbrev` are marked as reducible.
-->

在幕后，一些定义会在重载解析期间被内部标记为可展开的，而另一些则不会标记。
可展开的定义称为  **可约的（Reducible）** 。控制可约性对 Lean 的灵活性而言至关重要：
完全展开所有的定义可能会产生非常大的类型，这对于机器处理和用户理解来说都很困难。
使用 `abbrev` 生成的定义会被标记为可约定义。
