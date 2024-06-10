<!--
# Polymorphism
-->

# 多态

<!--
Just as in most languages, types in Lean can take arguments.
For instance, the type `List Nat` describes lists of natural numbers, `List String` describes lists of strings, and `List (List Point)` describes lists of lists of points.
This is very similar to `List<Nat>`, `List<String>`, or `List<List<Point>>` in a language like C# or Java.
Just as Lean uses a space to pass an argument to a function, it uses a space to pass an argument to a type.
-->

和大多数语言一样，Lean 中的类型可以接受参数。例如，类型 `List Nat` 描述自然数列表，
`List String` 描述字符串列表，`List (List Point)` 描述点列表列表。这与 C# 或 Java 中的
`List<Nat>`、`List<String>` 或 `List<List<Point>>` 非常相似。就像 Lean
使用空格将参数传递给函数一样，它也使用空格将参数传递给类型。

<!--
In functional programming, the term _polymorphism_ typically refers to datatypes and definitions that take types as arguments.
This is different from the object-oriented programming community, where the term typically refers to subclasses that may override some behavior of their superclass.
In this book, "polymorphism" always refers to the first sense of the word.
These type arguments can be used in the datatype or definition, which allows the same datatype or definition to be used with any type that results from replacing the arguments' names with some other types.
-->

在函数式编程中，术语  **多态（Polymorphism）** "通常指将类型作为参数的数据类型和定义。
这不同于面向对象编程社区，其中该术语通常指可以覆盖其超类某些行为的子类。
在这本书中，「多态」总是指这个词的第一个含义。这些类型参数可以在数据类型或定义中使用，
通过将数据类型和定义的类型参数替换为其他类型，可以产生新的不同类型。

<!--
The `Point` structure requires that both the `x` and `y` fields are `Float`s.
There is, however, nothing about points that require a specific representation for each coordinate.
A polymorphic version of `Point`, called `PPoint`, can take a type as an argument, and then use that type for both fields:
-->

`Point` 结构体要求 `x` 和 `y` 字段都是 `Float`。然而，对于点来说，
并没有每个坐标都需要特定表示形式的要求。`Point` 的多态版本称为 `PPoint`，
它可以将类型作为参数，然后将该类型用于两个字段：

```lean
{{#example_decl Examples/Intro.lean PPoint}}
```

<!--
Just as a function definition's arguments are written immediately after the name being defined, a structure's arguments are written immediately after the structure's name.
It is customary to use Greek letters to name type arguments in Lean when no more specific name suggests itself.
`Type` is a type that describes other types, so `Nat`, `List String`, and `PPoint Int` all have type `Type`.
-->

就像函数定义的参数紧跟在被定义的名称之后一样，结构体的参数紧跟在结构体的名称之后。
在 Lean 中，当没有更具体的名称时，通常使用希腊字母来命名类型参数。
`Type` 是描述其他类型的类型，因此 `Nat`、`List String` 和 `PPoint Int` 都具有 `Type` 类型。

和 `List` 一样，`PPoint` 可以通过提供特定类型作为其参数来使用：

```lean
{{#example_decl Examples/Intro.lean natPoint}}
```

<!--
In this example, both fields are expected to be `Nat`s.
Just as a function is called by replacing its argument variables with its argument values, providing `PPoint` with the type `Nat` as an argument yields a structure in which the fields `x` and `y` have the type `Nat`, because the argument name `α` has been replaced by the argument type `Nat`.
Types are ordinary expressions in Lean, so passing arguments to polymorphic types (like `PPoint`) doesn't require any special syntax.
-->

在此示例中，期望的两个字段都是 `Nat`。就和通过用其参数值替换其参数变量来调用函数一样，
向 `PPoint` 传入类型参数 `Nat` 会产生一个结构体，其中字段 `x` 和 `y` 具有类型 `Nat`，
因为参数名称 `α` 已被参数类型 `Nat` 替换。类型是 Lean 中的普通表达式，
因此向多态类型（如 `PPoint`）传递参数不需要任何特殊语法。"

<!--
Definitions may also take types as arguments, which makes them polymorphic.
The function `replaceX` replaces the `x` field of a `PPoint` with a new value.
In order to allow `replaceX` to work with _any_ polymorphic point, it must be polymorphic itself.
This is achieved by having its first argument be the type of the point's fields, with later arguments referring back to the first argument's name.
-->

定义也可以将类型作为参数，这使得它们具有多态性。函数 `replaceX` 用新值替换
`PPoint` 的 `x` 字段。为了能够让 `replaceX` 与  **任何** 多态的点一起使用，它本身必须是多态的。
这是通过让其第一个参数成为点字段的类型，后面的参数引用第一个参数的名称来实现的。

```lean
{{#example_decl Examples/Intro.lean replaceX}}
```

<!--
In other words, when the types of the arguments `point` and `newX` mention `α`, they are referring to _whichever type was provided as the first argument_.
This is similar to the way that function argument names refer to the values that were provided when they occur in the function's body.
-->

换句话说，当参数 `point` 和 `newX` 的类型提到 `α` 时，它们指的是
  **作为第一个参数提供的任何类型** 。这类似于函数参数名称引用函数体中提供的值的方式。

<!--
This can be seen by asking Lean to check the type of `replaceX`, and then asking it to check the type of `replaceX Nat`.
-->

可以通过让 Lean 检查 `replaceX` 的类型，然后让它检查 `replaceX Nat` 的类型来看到这一点。

```lean
{{#example_in Examples/Intro.lean replaceXT}}
```

```output info
{{#example_out Examples/Intro.lean replaceXT}}
```

<!--
This function type includes the _name_ of the first argument, and later arguments in the type refer back to this name.
Just as the value of a function application is found by replacing the argument name with the provided argument value in the function's body, the type of a function application is found by replacing the argument's name with the provided value in the function's return type.
Providing the first argument, `Nat`, causes all occurrences of `α` in the remainder of the type to be replaced with `Nat`:
-->

此函数类型包括第一个参数的  **名称** ，类型中的后续参数会引用此名称。
就像函数应用的值，是通过在函数体中，用所提供的参数值替换参数名称来找到的那样，
函数应用的类型，也是通过在函数的返回类型中，用所提供的参数值替换参数的名称来找到的。
提供第一个参数 `Nat`，会导致类型其余部分中所有的 `α` 都替换为 `Nat`：

```lean
{{#example_in Examples/Intro.lean replaceXNatT}}
```

```output info
{{#example_out Examples/Intro.lean replaceXNatT}}
```

<!--
Because the remaining arguments are not explicitly named, no further substitution occurs as more arguments are provided:
-->

由于剩余的参数没有明确命名，所以随着提供更多参数，并不会发生进一步的替换：

```lean
{{#example_in Examples/Intro.lean replaceXNatOriginT}}
```

```output info
{{#example_out Examples/Intro.lean replaceXNatOriginT}}
```

```lean
{{#example_in Examples/Intro.lean replaceXNatOriginFiveT}}
```

```output info
{{#example_out Examples/Intro.lean replaceXNatOriginFiveT}}
```

<!--
The fact that the type of the whole function application expression was determined by passing a type as an argument has no bearing on the ability to evaluate it.
-->

整个函数应用表达式的类型是通过传递类型作为参数来确定的，这一事实与对它进行求值的能力无关。

```lean
{{#example_in Examples/Intro.lean replaceXNatOriginFiveV}}
```

```output info
{{#example_out Examples/Intro.lean replaceXNatOriginFiveV}}
```

<!--
Polymorphic functions work by taking a named type argument and having later types refer to the argument's name.
However, there's nothing special about type arguments that allows them to be named.
Given a datatype that represents positive or negative signs:
-->

多态函数通过接受一个命名的类型参数并让后续类型引用参数的名称来工作。
然而，类型参数并没有什么可以让它们被命名的特殊之处。给定一个表示正负号的数据类型：

```lean
{{#example_decl Examples/Intro.lean Sign}}
```

<!--
it is possible to write a function whose argument is a sign.
If the argument is positive, the function returns a `Nat`, while if it's negative, it returns an `Int`:
-->

可以编写一个函数，其参数是一个符号。如果参数为正，则函数返回 `Nat`，如果为负，则返回 `Int`：

```lean
{{#example_decl Examples/Intro.lean posOrNegThree}}
```

<!--
Because types are first class and can be computed using the ordinary rules of the Lean language, they can be computed by pattern-matching against a datatype.
When Lean is checking this function, it uses the fact that the `match`-expression in the function's body corresponds to the `match`-expression in the type to make `Nat` be the expected type for the `pos` case and to make `Int` be the expected type for the `neg` case.
-->

由于类型是一等公民，且可以使用 Lean 语言的普通规则进行计算，
因此可以通过针对数据类型的模式匹配来计算它们。当 Lean 检查此函数时，它根据函数体中的
`match` 表达式与类型中的 `match` 表达式相对应，使 `Nat` 成为 `pos` 情况的期望类型，
`Int` 成为 `neg` 情况的期望类型。

<!--
Applying `posOrNegThree` to `Sign.pos` results in the argument name `s` in both the body of the function and its return type being replaced by `Sign.pos`.
Evaluation can occur both in the expression and its type:
-->

将 `posOrNegThree` 应用于 `Sign.pos` 会导致函数体和其返回类型中的参数名称 `s`
都被 `Sign.pos` 替换。求值可以在表达式及其类型中同时发生：

```lean
{{#example_eval Examples/Intro.lean posOrNegThreePos}}
```

<!--
## Linked Lists
-->

<!--
## Linked Lists
-->

## 链表

<!--
Lean's standard library includes a canonical linked list datatype, called `List`, and special syntax that makes it more convenient to use.
Lists are written in square brackets.
For instance, a list that contains the prime numbers less than 10 can be written:
-->

Lean 的标准库包含一个典型的链表数据类型，称为 `List`，以及使其更易于使用的特殊语法。
链表写在方括号中。例如，包含小于 10 的质数的链表可以写成：

```lean
{{#example_decl Examples/Intro.lean primesUnder10}}
```

<!--
Behind the scenes, `List` is an inductive datatype, defined like this:
-->

在幕后，`List` 是一个归纳数据类型，其定义如下：

```lean
{{#example_decl Examples/Intro.lean List}}
```

<!--
The actual definition in the standard library is slightly different, because it uses features that have not yet been presented, but it is substantially similar.
This definition says that `List` takes a single type as its argument, just as `PPoint` did.
This type is the type of the entries stored in the list.
According to the constructors, a `List α` can be built with either `nil` or `cons`.
The constructor `nil` represents empty lists and the constructor `cons` is used for non-empty lists.
The first argument to `cons` is the head of the list, and the second argument is its tail.
A list that contains \\( n \\) entries contains \\( n \\) `cons` constructors, the last of which has `nil` as its tail.
-->

标准库中的实际定义略有不同，因为它使用了尚未介绍的特性，但它们大体上是相似的。
此定义表示 `List` 将单个类型作为其参数，就像 `PPoint` 那样。
此类型是存储在列表中的项的类型。根据构造子，`List α` 可以使用 `nil` 或 `cons` 构建。
构造子 `nil` 表示空列表，构造子 `cons` 用于非空列表。
`cons` 的第一个参数是列表的头部，第二个参数是其尾部。包含 \\( n \\)
个项的列表包含 \\( n \\) 个 `cons` 构造子，最后一个以 `nil` 为尾部。

<!--
The `primesUnder10` example can be written more explicitly by using `List`'s constructors directly:
-->

`primesUnder10` 示例可以通过直接使用 `List` 的构造函数更明确地编写：

```lean
{{#example_decl Examples/Intro.lean explicitPrimesUnder10}}
```

<!--
These two definitions are completely equivalent, but `primesUnder10` is much easier to read than `explicitPrimesUnder10`.
-->

这两个定义完全等价，但 `primesUnder10` 比 `explicitPrimesUnder10` 更易读。

<!--
Functions that consume `List`s can be defined in much the same way as functions that consume `Nat`s.
Indeed, one way to think of a linked list is as a `Nat` that has an extra data field dangling off each `succ` constructor.
From this point of view, computing the length of a list is the process of replacing each `cons` with a `succ` and the final `nil` with a `zero`.
Just as `replaceX` took the type of the fields of the point as an argument, `length` takes the type of the list's entries.
For example, if the list contains strings, then the first argument is `String`: `{{#example_eval Examples/Intro.lean length1EvalSummary 0}}`.
It should compute like this:
-->

使用 `List` 的函数可以与使用 `Nat` 的函数以相同的方式定义。
事实上，一种考虑链表的方式是将其视为一个 `Nat`，每个 `succ`
构造函数都悬挂着一个额外的数据字段。从这个角度来看，计算列表的长度的过程是将每个
`cons` 替换为 `succ`，将最终的 `nil` 替换为 `zero`。就像 `replaceX`
将点的字段类型作为参数一样，`length` 采用列表项的类型。例如，如果列表包含字符串，
则第一个参数是 `String`：`{{#example_eval Examples/Intro.lean length1EvalSummary 0}}`。
 它应该这样计算：

```lean
{{#example_eval Examples/Intro.lean length1EvalSummary}}
```

<!--
The definition of `length` is both polymorphic (because it takes the list entry type as an argument) and recursive (because it refers to itself).
Generally, functions follow the shape of the data: recursive datatypes lead to recursive functions, and polymorphic datatypes lead to polymorphic functions.
-->

`length` 的定义既是多态的（因为它将列表项类型作为参数），又是递归的（因为它引用自身）。
通常，函数遵循数据的形状：递归数据类型导致递归函数，多态数据类型导致多态函数。"

```lean
{{#example_decl Examples/Intro.lean length1}}
```

<!--
Names such as `xs` and `ys` are conventionally used to stand for lists of unknown values.
The `s` in the name indicates that they are plural, so they are pronounced "exes" and "whys" rather than "x s" and "y s".
-->

按照惯例，`xs` 和 `ys` 等名称用于表示未知值的列表。名称中的 `s` 表示它们是复数，
因此它们的发音是「exes」和「whys」，而不是「x s」和「y s」。

<!--
To make it easier to read functions on lists, the bracket notation `[]` can be used to pattern-match against `nil`, and an infix `::` can be used in place of `cons`:
-->

为了便于阅读列表上的函数，可以使用方括号记法 `[]` 来匹配模式 `nil`，
并且可以使用中缀 `::` 来代替 `cons`：

```lean
{{#example_decl Examples/Intro.lean length2}}
```

<!--
## Implicit Arguments
-->

## 隐式参数

<!--
Both `replaceX` and `length` are somewhat bureaucratic to use, because the type argument is typically uniquely determined by the later values.
Indeed, in most languages, the compiler is perfectly capable of determining type arguments on its own, and only occasionally needs help from users.
This is also the case in Lean.
Arguments can be declared _implicit_ by wrapping them in curly braces instead of parentheses when defining a function.
For instance, a version of `replaceX` with an implicit type argument looks like this:
-->

`replaceX` 和 `length` 这两个函数使用起来有些繁琐，因为类型参数通常由后面的值唯一确定。
事实上，在大多数语言中，编译器完全有能力自行确定类型参数，并且只需要偶尔从用户那里获得帮助。
在 Lean 中也是如此。在定义函数时，可以通过用大括号而不是括号将参数括起来来声明参数为
  **隐式（Implicit）** 的。例如，一个具有隐式类型参数的 `replaceX` 版本如下所示：

```lean
{{#example_decl Examples/Intro.lean replaceXImp}}
```

<!--
It can be used with `natOrigin` without providing `Nat` explicitly, because Lean can _infer_ the value of `α` from the later arguments:
-->

它可以与 `natOrigin` 一起使用，而无需显式提供 `Nat`，因为 Lean 可以从后面的参数中**推断** `α` 的值：

```lean
{{#example_in Examples/Intro.lean replaceXImpNat}}
```

```output info
{{#example_out Examples/Intro.lean replaceXImpNat}}
```

<!--
Similarly, `length` can be redefined to take the entry type implicitly:
-->

类似地，`length` 可以重新定义为隐式获取输入类型：

```lean
{{#example_decl Examples/Intro.lean lengthImp}}
```

<!--
This `length` function can be applied directly to `primesUnder10`:
-->

此 `length` 函数可以直接应用于 `primesUnder10`：

```lean
{{#example_in Examples/Intro.lean lengthImpPrimes}}
```

```output info
{{#example_out Examples/Intro.lean lengthImpPrimes}}
```

<!--
In the standard library, Lean calls this function `List.length`, which means that the dot syntax that is used for structure field access can also be used to find the length of a list:
-->

在标准库中，Lean 将此函数称为 `List.length`，
这意味着用于结构体字段访问的点语法也可以用于查找列表的长度：

```lean
{{#example_in Examples/Intro.lean lengthDotPrimes}}
```

```output info
{{#example_out Examples/Intro.lean lengthDotPrimes}}
```

<!--
Just as C# and Java require type arguments to be provided explicitly from time to time, Lean is not always capable of finding implicit arguments.
In these cases, they can be provided using their names.
For instance, a version of `List.length` that only works for lists of integers can be specified by setting `α` to `Int`:
-->

正如 C# 和 Java 要求不时显式提供类型参数一样，Lean 并不总是能够找出隐式参数。
在这些情况下，可以使用它们的名称来提供它们。例如，可以通过将 `α` 设置为 `Int`
来指定仅适用于整数列表的 `List.length` 版本：

```lean
{{#example_in Examples/Intro.lean lengthExpNat}}
```

```output info
{{#example_out Examples/Intro.lean lengthExpNat}}
```

<!--
## More Built-In Datatypes
-->

## 更多内置数据类型

<!--
In addition to lists, Lean's standard library contains a number of other structures and inductive datatypes that can be used in a variety of contexts.
-->

除了列表之外，Lean 的标准库还包含许多其他结构体和归纳数据类型，可用于各种场景。

<!--
### `Option`
-->

### `Option` 可选类型

<!--
Not every list has a first entry—some lists are empty.
Many operations on collections may fail to find what they are looking for.
For instance, a function that finds the first entry in a list may not find any such entry.
It must therefore have a way to signal that there was no first entry.
-->

并非每个列表都有第一个条目，有些列表是空的。许多集合操作可能无法找到它们正在寻找的内容。
例如，查找列表中第一个条目的函数可能找不到任何此类条目。因此，它必须有一种方法来表示没有第一个条目。

<!--
Many languages have a `null` value that represents the absence of a value.
Instead of equipping existing types with a special `null` value, Lean provides a datatype called `Option` that equips some other type with an indicator for missing values.
For instance, a nullable `Int` is represented by `Option Int`, and a nullable list of strings is represented by the type `Option (List String)`.
Introducing a new type to represent nullability means that the type system ensures that checks for `null` cannot be forgotten, because an `Option Int` can't be used in a context where an `Int` is expected.
-->

许多语言都有一个 `null` 值来表示没有值。Lean 没有为现有类型配备一个特殊的 `null` 值，
而是提供了一个名为 `Option` 的数据类型，为其他类型配备了一个缺失值指示器。
例如，一个可为空的 `Int` 由 `Option Int` 表示，一个可为空的字符串列表由类型
`Option (List String)` 表示。引入一个新类型来表示可空性意味着类型系统确保无法忘记对
`null` 的检查，因为 `Option Int` 不能在需要 `Int` 的上下文中使用。

<!--
`Option` has two constructors, called `some` and `none`, that respectively represent the non-null and null versions of the underlying type.
The non-null constructor, `some`, contains the underlying value, while `none` takes no arguments:
-->

`Option` 有两个构造函数，称为 `some` 和 `none`，它们分别表示基础类型的非空和空的版本。
非空构造函数 `some` 包含基础值，而 `none` 不带参数：

```lean
{{#example_decl Examples/Intro.lean Option}}
```

<!--
The `Option` type is very similar to nullable types in languages like C# and Kotlin, but it is not identical.
In these languages, if a type (say, `Boolean`) always refers to actual values of the type (`true` and `false`), the type `Boolean?` or `Nullable<Boolean>` additionally admits the `null` value.
Tracking this in the type system is very useful: the type checker and other tooling can help programmers remember to check for null, and APIs that explicitly describe nullability through type signatures are more informative than ones that don't.
However, these nullable types differ from Lean's `Option` in one very important way, which is that they don't allow multiple layers of optionality.
`{{#example_out Examples/Intro.lean nullThree}}` can be constructed with `{{#example_in Examples/Intro.lean nullOne}}`, `{{#example_in Examples/Intro.lean nullTwo}}`, or `{{#example_in Examples/Intro.lean nullThree}}`.
C#, on the other hand, forbids multiple layers of nullability by only allowing `?` to be added to non-nullable types, while Kotlin treats `T??` as being equivalent to `T?`.
This subtle difference is rarely relevant in practice, but it can matter from time to time.
-->

`Option` 类型与 C# 和 Kotlin 等语言中的可空类型非常相似，但并非完全相同。
在这些语言中，如果一个类型（比如 `Boolean`）总是引用该类型的实际值（`true` 和 `false`），
那么类型 `Boolean?` 或 `Nullable<Boolean>` 额外允许 `null` 值。
在类型系统中跟踪这一点非常有用：类型检查器和其他工具可以帮助程序员记住检查 null，
并且通过类型签名明确描述可空性的 API 比不描述可空性的 API 更具信息性量。
然而，这些可空类型与 Lean 的 `Option` 在一个非常重要的方面有所不同，那就是它们不允许多层可选项性。
`{{#example_out Examples/Intro.lean nullThree}}` 可以用 `{{#example_in Examples/Intro.lean nullOne}}`、
`{{#example_in Examples/Intro.lean nullTwo}}` 或 `{{#example_in Examples/Intro.lean nullThree}}`
构造。另一方面，C# 禁止多层可空性，只允许将 `?` 添加到不可空类型，而 Kotlin 将 `T??`
视为等同于 `T?`。这种细微的差别在实践中大多无关紧要，但有时会很重要。

<!--
To find the first entry in a list, if it exists, use `List.head?`.
The question mark is part of the name, and is not related to the use of question marks to indicate nullable types in C# or Kotlin.
In the definition of `List.head?`, an underscore is used to represent the tail of the list.
In patterns, underscores match anything at all, but do not introduce variables to refer to the matched data.
Using underscores instead of names is a way to clearly communicate to readers that part of the input is ignored.
-->

要查找列表中的第一个条目（如果存在），请使用 `List.head?`。
问号是名称的一部分，与在 C# 或 Kotlin 中使用问号表示可空类型并不相同。在 `List.head?`
的定义中，下划线用于表示列表的尾部。在模式匹配中，下划线匹配任何内容，
但不会引入变量来引用匹配的数据。使用下划线而不是名称是一种向读者清楚传达输入部分被忽略的方式。

```lean
{{#example_decl Examples/Intro.lean headHuh}}
```

<!--
A Lean naming convention is to define operations that might fail in groups using the suffixes `?` for a version that returns an `Option`, `!` for a version that crashes when provided with invalid input, and `D` for a version that returns a default value when the operation would otherwise fail.
For instance, `head` requires the caller to provide mathematical evidence that the list is not empty, `head?` returns an `Option`, `head!` crashes the program when passed an empty list, and `headD` takes a default value to return in case the list is empty.
The question mark and exclamation mark are part of the name, not special syntax, as Lean's naming rules are more liberal than many languages.
-->

Lean 的命名约定是使用后缀 `?` 定义可能失败的操作，用于返回 `Option` 的版本，
`！` 用于在提供无效输入时崩溃的版本，`D` 用于在操作在其他情况下失败时返回默认值的版本。
例如，`head` 要求调用者提供数学证据证明列表不为空，`head?` 返回 `Option`，`head!`
在传递空列表时使程序崩溃，`headD` 采用一个默认值，以便在列表为空时返回。
问号和感叹号是名称的一部分，而不是特殊语法，因为 Lean 的命名规则比许多语言更自由。

<!--
Because `head?` is defined in the `List` namespace, it can be used with accessor notation:
-->

由于 `head?` 在 `List` 命名空间中定义，因此它可以使用访问器记法：

```lean
{{#example_in Examples/Intro.lean headSome}}
```

```output info
{{#example_out Examples/Intro.lean headSome}}
```

<!--
However, attempting to test it on the empty list leads to two errors:
-->

然而，尝试在空列表上测试它会导致两个错误：

```lean
{{#example_in Examples/Intro.lean headNoneBad}}
```

```output error
{{#example_out Examples/Intro.lean headNoneBad}}

{{#example_out Examples/Intro.lean headNoneBad2}}
```

<!--
This is because Lean was unable to fully determine the expression's type.
In particular, it could neither find the implicit type argument to `List.head?`, nor could it find the implicit type argument to `List.nil`.
In Lean's output, `?m.XYZ` represents a part of a program that could not be inferred.
These unknown parts are called _metavariables_, and they occur in some error messages.
In order to evaluate an expression, Lean needs to be able to find its type, and the type was unavailable because the empty list does not have any entries from which the type can be found.
Explicitly providing a type allows Lean to proceed:
-->

这是因为 Lean 无法完全确定表达式的类型。特别是，它既找不到 `List.head?` 的隐式类型参数，
也找不到 `List.nil` 的隐式类型参数。在 Lean 的输出中，`?m.XYZ` 表示程序中无法推断的部分。
这些未知部分称为  **元变量（Metavariable）** ，它们出现在一些错误消息中。为了计算一个表达式，
Lean 需要能够找到它的类型，而类型不可用，因为空列表没有任何条目可以从中找到类型。
显式提供类型可以让 Lean 继续：

```lean
{{#example_in Examples/Intro.lean headNone}}
```

```output info
{{#example_out Examples/Intro.lean headNone}}
```

<!--
The type can also be provided with a type annotation:
-->

类型也可以用类型标注提供：

```lean
{{#example_in Examples/Intro.lean headNoneTwo}}
```

```output info
{{#example_out Examples/Intro.lean headNoneTwo}}
```

<!--
The error messages provide a useful clue.
Both messages use the _same_ metavariable to describe the missing implicit argument, which means that Lean has determined that the two missing pieces will share a solution, even though it was unable to determine the actual value of the solution.
-->

错误信息提供了一个有用的线索。两个信息都使用  **相同** 的元变量来描述缺少的隐式参数，
这意味着 Lean 已经确定两个缺少的部分将共享一个解决方案，即使它无法确定解决方案的实际值。

<!--
### `Prod`
-->

### `Prod` 积类型

<!--
The `Prod` structure, short for "Product", is a generic way of joining two values together.
For instance, a `Prod Nat String` contains a `Nat` and a `String`.
In other words, `PPoint Nat` could be replaced by `Prod Nat Nat`.
`Prod` is very much like C#'s tuples, the `Pair` and `Triple` types in Kotlin, and `tuple` in C++.
Many applications are best served by defining their own structures, even for simple cases like `Point`, because using domain terminology can make it easier to read the code.
Additionally, defining structure types helps catch more errors by assigning different types to different domain concepts, preventing them from being mixed up.
-->

`Prod` 结构体，即  **积（Product）** 2的缩写，是一种将两个值连接在一起的通用方法。
例如，`Prod Nat String` 包含一个 `Nat` 和一个 `String`。换句话说，`PPoint Nat`
可以替换为 `Prod Nat Nat`。`Prod` 非常类似于 C# 的元组、Kotlin 中的 `Pair` 和 `Triple`
类型以及 C++ 中的 `tuple`。许多应用最适合定义自己的结构体，即使对于像 `Point`
这样的简单情况也是如此，因为使用领域术语可以使代码更加易读。
此外，定义结构体类型有助于通过为不同的领域概念分配不同的类型来捕获更多错误，防止它们混淆。

<!--
On the other hand, there are some cases where it is not worth the overhead of defining a new type.
Additionally, some libraries are sufficiently generic that there is no more specific concept than "pair".
Finally, the standard library contains a variety of convenience functions that make it easier to work with the built-in pair type.
-->

另一方面，在某些情况下，定义新类型是不值得的开销。此外，一些库足够通用，
以至于没有比  **偶对（Pair）** 更具体的概念。最后，标准库也包含了各种便利函数，
让使用内置对类型变得更容易。

<!--
The standard pair structure is called `Prod`.
-->

标准偶对结构体叫做 `Prod`。

```lean
{{#example_decl Examples/Intro.lean Prod}}
```

<!--
Lists are used so frequently that there is special syntax to make them more readable.
For the same reason, both the product type and its constructor have special syntax.
The type `Prod α β` is typically written `α × β`, mirroring the usual notation for a Cartesian product of sets.
Similarly, the usual mathematical notation for pairs is available for `Prod`.
In other words, instead of writing:
-->

列表的使用如此频繁，以至于有特殊的语法使它们更具可读性。
出于同样的原因，积类型及其构造子都有特殊的语法。类型 `Prod α β` 通常写为 `α × β`，
反映了集合的笛卡尔积的常用记法。与此类似，偶对的常用数学记法可用于 `Prod`。换句话说，不要写：

```lean
{{#example_decl Examples/Intro.lean fivesStruct}}
```

<!--
it suffices to write:
-->

只需编写：

```lean
{{#example_decl Examples/Intro.lean fives}}
```

<!--
Both notations are right-associative.
This means that the following definitions are equivalent:
-->

即可。这两种表示法都是右结合的。这意味着以下定义是等价的：

```lean
{{#example_decl Examples/Intro.lean sevens}}

{{#example_decl Examples/Intro.lean sevensNested}}
```

<!--
In other words, all products of more than two types, and their corresponding constructors, are actually nested products and nested pairs behind the scenes.
-->

换句话说，所有超过两种类型的积及其对应的构造子实际上都是嵌套积和嵌套的偶对。

<!--
### `Sum`
-->

### `Sum` 和类型

<!--
The `Sum` datatype is a generic way of allowing a choice between values of two different types.
For instance, a `Sum String Int` is either a `String` or an `Int`.
Like `Prod`, `Sum` should be used either when writing very generic code, for a very small section of code where there is no sensible domain-specific type, or when the standard library contains useful functions.
In most situations, it is more readable and maintainable to use a custom inductive type.
-->

  **和（`Sum`）** 数据类型是一种允许在两种不同类型的值之间进行选择的一般方式。
例如，`Sum String Int` 要么是 `String`，要么是 `Int`。与 `Prod` 一样，
`Sum` 应该在编写非常通用的代码时使用，对于没有合适的特定领域类型的一小段代码，
或者当标准库包含有用的函数时使用。在大多数情况下，使用自定义归纳类型更具可读性和可维护性。

<!--
Values of type `Sum α β` are either the constructor `inl` applied to a value of type `α` or the constructor `inr` applied to a value of type `β`:
-->

`Sum α β` 类型的取值要么是应用于 `α` 类型的构造子 `inl`，要么是应用于 `β` 类型的构造子 `inr`：

```lean
{{#example_decl Examples/Intro.lean Sum}}
```

<!--
These names are abbreviations for "left injection" and "right injection", respectively.
Just as the Cartesian product notation is used for `Prod`, a "circled plus" notation is used for `Sum`, so `α ⊕ β` is another way to write `Sum α β`.
There is no special syntax for `Sum.inl` and `Sum.inr`.
-->

这些名称分别是「左注入（left injection）」和「右注入（right injection）」的缩写。
就像笛卡尔积符号用于 `Prod` 一样，「圆圈加号」符号用于 `Sum`，因此 `α ⊕ β` 是
`Sum α β` 的另一种记法。`Sum.inl` 和 `Sum.inr` 没有特殊语法。

<!--
For instance, if pet names can either be dog names or cat names, then a type for them can be introduced as a sum of strings:
-->

例如，如果宠物名称可以是狗名或猫名，那么它们的类型可以作为字符串的和来引入：

```lean
{{#example_decl Examples/Intro.lean PetName}}
```

<!--
In a real program, it would usually be better to define a custom inductive datatype for this purpose with informative constructor names.
Here, `Sum.inl` is to be used for dog names, and `Sum.inr` is to be used for cat names.
These constructors can be used to write a list of animal names:
-->

在实际程序中，通常最好为此目的自定义一个归纳数据类型，并使用有意义的构造子名称。
在这里，`Sum.inl` 用于狗的名字，`Sum.inr` 用于猫的名字。这些构造子可用于编写动物名称列表：

```lean
{{#example_decl Examples/Intro.lean animals}}
```

<!--
Pattern matching can be used to distinguish between the two constructors.
For instance, a function that counts the number of dogs in a list of animal names (that is, the number of `Sum.inl` constructors) looks like this:
-->

模式匹配可用于区分两个构造子。例如，一个函数用于统计动物名称列表中狗的数量（即 `Sum.inl`
构造子的数量），如下所示：

```lean
{{#example_decl Examples/Intro.lean howManyDogs}}
```

<!--
Function calls are evaluated before infix operators, so `howManyDogs morePets + 1` is the same as `(howManyDogs morePets) + 1`.
As expected, `{{#example_in Examples/Intro.lean dogCount}}` yields `{{#example_out Examples/Intro.lean dogCount}}`.
-->

函数调用在中缀运算符之前进行求值，因此 `howManyDogs morePets + 1` 等价于
`(howManyDogs morePets) + 1`。如预期的那样，`{{#example_in Examples/Intro.lean dogCount}}`
会产生 `{{#example_out Examples/Intro.lean dogCount}}`。

<!--
### `Unit`
-->

### `Unit` 单位类型

<!--
`Unit` is a type with just one argumentless constructor, called `unit`.
In other words, it describes only a single value, which consists of said constructor applied to no arguments whatsoever.
`Unit` is defined as follows:
-->

`Unit` 是仅有一个无参构造子（称为 `unit`）的类型。换句话说，它只描述一个值，
该值由没有应用于任何参数的构造子组成。`Unit` 定义如下：

```lean
{{#example_decl Examples/Intro.lean Unit}}
```

<!--
On its own, `Unit` is not particularly useful.
However, in polymorphic code, it can be used as a placeholder for data that is missing.
For instance, the following inductive datatype represents arithmetic expressions:
-->

单独使用时，`Unit` 并不是特别有用。但是，在多态代码中，它可以用作缺少数据的占位符。
例如，以下归纳数据类型表示算术表达式：

```lean
{{#example_decl Examples/Intro.lean ArithExpr}}
```

<!--
The type argument `ann` stands for annotations, and each constructor is annotated.
Expressions coming from a parser might be annotated with source locations, so a return type of `ArithExpr SourcePos` ensures that the parser put a `SourcePos` at each subexpression.
Expressions that don't come from the parser, however, will not have source locations, so their type can be `ArithExpr Unit`.
-->

类型参数 `ann` 表示标注，每个构造子都有标注。来自解析器的表达式可能带有源码位置标注，
因此 `ArithExpr SourcePos` 的返回类型需要确保解析器在每个子表达式中放置 `SourcePos`。
然而，不来自于解析器的表达式没有源码位置，因此它们的类型可以是 `ArithExpr Unit`。

<!--
Additionally, because all Lean functions have arguments, zero-argument functions in other languages can be represented as functions that take a `Unit` argument.
In a return position, the `Unit` type is similar to `void` in languages derived from C.
In the C family, a function that returns `void` will return control to its caller, but it will not return any interesting value.
By being an intentionally uninteresting value, `Unit` allows this to be expressed without requiring a special-purpose `void` feature in the type system.
Unit's constructor can be written as empty parentheses: `{{#example_in Examples/Intro.lean unitParens}} : {{#example_out Examples/Intro.lean unitParens}}`.
-->

此外，由于所有 Lean 函数都有参数，因此其他语言中的零参数函数可以表示为接受 `Unit` 参数的函数。
在返回位置，`Unit` 类型类似于 C 的语言中的 `void`。在 C 系列中，
返回 `void` 的函数会将控制权返回给调用者，但不会返回任何有意义的值。
`Unit` 作为一个特意表示无意义的值，可以在类型系统无需具有特殊用途的 `void`
特性的情况下表达这一点。Unit 的构造子可以写成空括号：
`{{#example_in Examples/Intro.lean unitParens}} : {{#example_out Examples/Intro.lean unitParens}}`。

<!--
### `Empty`
-->

### `Empty` 空类型

<!--
The `Empty` datatype has no constructors whatsoever.
Thus, it indicates unreachable code, because no series of calls can ever terminate with a value at type `Empty`.
-->

`Empty` 数据类型没有任何构造子。 因此，它表示不可达代码，因为任何调用序列都无法以
`Empty` 类型的返回值终止。

<!--
`Empty` is not used nearly as often as `Unit`.
However, it is useful in some specialized contexts.
Many polymorphic datatypes do not use all of their type arguments in all of their constructors.
For instance, `Sum.inl` and `Sum.inr` each use only one of `Sum`'s type arguments.
Using `Empty` as one of the type arguments to `Sum` can rule out one of the constructors at a particular point in a program.
This can allow generic code to be used in contexts that have additional restrictions.
-->

`Empty` 的使用频率远不及 `Unit`。然而，它在一些特殊情况下很有用。
许多多态数据类型并非在其所有构造子中使用其所有类型参数。例如，`Sum.inl` 和 `Sum.inr`
各自只使用 `Sum` 的一个类型参数。将 `Empty` 用作 `Sum`
的类型参数之一可以在程序的特定点排除一个构造子。这能让我们在具有额外限制的语境中使用泛型代码。

<!--
### Naming: Sums, Products, and Units
-->

### 命名：和类型，积类型与单位类型

<!--
Generally speaking, types that offer multiple constructors are called _sum types_, while types whose single constructor takes multiple arguments are called _product types_.
These terms are related to sums and products used in ordinary arithmetic.
The relationship is easiest to see when the types involved contain a finite number of values.
If `α` and `β` are types that contain \\( n \\) and \\( k \\) distinct values, respectively, then `α ⊕ β` contains \\( n + k \\) distinct values and `α × β` contains \\( n \times k \\) distinct values.
For instance, `Bool` has two values: `true` and `false`, and `Unit` has one value: `Unit.unit`.
The product `Bool × Unit` has the two values `(true, Unit.unit)` and `(false, Unit.unit)`, and the sum `Bool ⊕ Unit` has the three values `Sum.inl true`, `Sum.inl false`, and `Sum.inr unit`.
Similarly, \\( 2 \times 1 = 2 \\), and \\( 2 + 1 = 3 \\).
-->

一般来说，提供多个构造子的类型称为  **和类型（Sum Type）** ，
而其单个构造子接受多个参数的类型称为  **积类型（Product Type）** 。
这些术语与普通算术中使用的和与积有关。当涉及的类型包含有限数量的值时，这种关系最容易看出。
如果 `α` 和 `β` 是分别包含 \\( n \\) 和 \\( k \\) 个不同值的数据类型，
则 `α ⊕ β` 包含 \\( n + k \\) 个不同值，`α × β` 包含 \\( n \times k \\) 个不同值。
例如，`Bool` 有两个值：`true` 和 `false`，`Unit` 有一个值：`Unit.unit`。
积 `Bool × Unit` 有两个值 `(true, Unit.unit)` 和 `(false, Unit.unit)`，
和 `Bool ⊕ Unit` 有三个值 `Sum.inl true`、`Sum.inl false` 和 `Sum.inr unit`。
类似地，\\( 2 \times 1 = 2 \\)，\\( 2 + 1 = 3 \\)。

<!--
## Messages You May Meet
-->

## 你可能会遇到的信息

<!--
Not all definable structures or inductive types can have the type `Type`.
In particular, if a constructor takes an arbitrary type as an argument, then the inductive type must have a different type.
These errors usually state something about "universe levels".
For example, for this inductive type:
-->

并非所有可定义的结构体或归纳类型都可以具有类型 `Type`。
特别是，如果一个构造子将任意类型作为参数，则归纳类型必须具有不同的类型。
这些错误通常会说明一些关于「宇宙层级」的内容。例如，对于这个归纳类型：

```lean
{{#example_in Examples/Intro.lean TypeInType}}
```

<!--
Lean gives the following error:
-->

Lean 会给出以下错误：

```output error
{{#example_out Examples/Intro.lean TypeInType}}
```

<!--
A later chapter describes why this is the case, and how to modify definitions to make them work.
For now, try making the type an argument to the inductive type as a whole, rather than to the constructor.
-->

后面的章节会描述为什么会这样，以及如何修改定义使其正常工作。
现在，尝试将类型作为参数传递给整个归纳类型，而不是传递给构造子。

<!--
Similarly, if a constructor's argument is a function that takes the datatype being defined as an argument, then the definition is rejected.
For example:
-->

与此类似，如果构造子的参数是一个将正在定义的数据类型作为参数的函数，那么该定义将被拒绝。例如：

```lean
{{#example_in Examples/Intro.lean Positivity}}
```

<!--
yields the message:
-->

会产生以下信息：

```output error
{{#example_out Examples/Intro.lean Positivity}}
```

<!--
For technical reasons, allowing these datatypes could make it possible to undermine Lean's internal logic, making it unsuitable for use as a theorem prover.
-->

出于技术原因，允许这些数据类型可能会破坏 Lean 的内部逻辑，使其不适合用作定理证明器。

<!--
Forgetting an argument to an inductive type can also yield a confusing message.
For example, when the argument `α` is not passed to `MyType` in `ctor`'s type:
-->

忘记归纳类型的参数也可能产生令人困惑的消息。
例如，当参数 `α` 没有传递给 `ctor` 的类型中的 `MyType` 时：

```lean
{{#example_in Examples/Intro.lean MissingTypeArg}}
```

<!--
Lean replies with the following error:
-->

Lean 会返回以下错误：

```output error
{{#example_out Examples/Intro.lean MissingTypeArg}}
```

<!--
The error message is saying that `MyType`'s type, which is `Type → Type`, does not itself describe types.
`MyType` requires an argument to become an actual honest-to-goodness type.
-->

该错误信息表明 `MyType` 的类型 `Type → Type` 本身并不描述类型。
`MyType` 需要一个参数才能成为一个真正的类型。

<!--
The same message can appear when type arguments are omitted in other contexts, such as in a type signature for a definition:
-->

在其他语境中省略类型参数时也会出现相同的消息，例如在定义的类型签名中：

```lean
{{#example_decl Examples/Intro.lean MyTypeDef}}

{{#example_in Examples/Intro.lean MissingTypeArg2}}
```

<!--
## Exercises
-->

## 练习

<!--
 * Write a function to find the last entry in a list. It should return an `Option`.
 * Write a function that finds the first entry in a list that satisfies a given predicate. Start the definition with `def List.findFirst? {α : Type} (xs : List α) (predicate : α → Bool) : Option α :=`
 * Write a function `Prod.swap` that swaps the two fields in a pair. Start the definition with `def Prod.swap {α β : Type} (pair : α × β) : β × α :=`
 * Rewrite the `PetName` example to use a custom datatype and compare it to the version that uses `Sum`.
 * Write a function `zip` that combines two lists into a list of pairs. The resulting list should be as long as the shortest input list. Start the definition with `def zip {α β : Type} (xs : List α) (ys : List β) : List (α × β) :=`.
 * Write a polymorphic function `take` that returns the first \\( n \\) entries in a list, where \\( n \\) is a `Nat`. If the list contains fewer than `n` entries, then the resulting list should be the input list. `{{#example_in Examples/Intro.lean takeThree}}` should yield `{{#example_out Examples/Intro.lean takeThree}}`, and `{{#example_in Examples/Intro.lean takeOne}}` should yield `{{#example_out Examples/Intro.lean takeOne}}`.
 * Using the analogy between types and arithmetic, write a function that distributes products over sums. In other words, it should have type `α × (β ⊕ γ) → (α × β) ⊕ (α × γ)`.
 * Using the analogy between types and arithmetic, write a function that turns multiplication by two into a sum. In other words, it should have type `Bool × α → α ⊕ α`.
-->

* 编写一个函数来查找列表中的最后一个条目。它应该返回一个 `Option`。
* 编写一个函数，在列表中找到满足给定谓词的第一个条目。从
 `def List.findFirst? {α : Type} (xs : List α) (predicate : α → Bool) : Option α :=` 开始定义。
* 编写一个函数 `Prod.swap`，用于交换偶对中的两个字段。
  定义以 `def Prod.swap {α β : Type} (pair : α × β) : β × α :=` 开始。
* 使用自定义数据类型重写 `PetName` 示例，并将其与使用 `Sum` 的版本进行比较。
* 编写一个函数 `zip`，用于将两个列表组合成一个偶对列表。结果列表的长度应与最短的输入列表相同。
  定义以 `def zip {α β : Type} (xs : List α) (ys : List β) : List (α × β) :=` 开始。
* 编写一个多态函数 `take`，返回列表中的前 \\( n \\) 个条目，其中 \\( n \\) 是一个 `Nat`。
  如果列表包含的条目少于 `n` 个，则结果列表应为输入列表。
  `{{#example_in Examples/Intro.lean takeThree}}` 应当产生
  `{{#example_out Examples/Intro.lean takeThree}}`，而
  `{{#example_in Examples/Intro.lean takeOne}}` 应当产生
  `{{#example_out Examples/Intro.lean takeOne}}`。
* 利用类型和算术之间的类比，编写一个将积分配到和上的函数。
  换句话说，它的类型应为 `α × (β ⊕ γ) → (α × β) ⊕ (α × γ)`。
* 利用类型和算术之间的类比，编写一个将乘以 2 转换为和的函数。
  换句话说，它的类型应为 `Bool × α → α ⊕ α`。
