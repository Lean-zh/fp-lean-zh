<!--
# Coercions
-->

# 强制转换

<!--
In mathematics, it is common to use the same symbol to stand for different aspects of some object in different contexts.
For example, if a ring is referred to in a context where a set is expected, then it is understood that the ring's underlying set is what's intended.
In programming languages, it is common to have rules to automatically translate values of one type into values of another type.
For instance, Java allows a `byte` to be automatically promoted to an `int`, and Kotlin allows a non-nullable type to be used in a context that expects a nullable version of the type.
-->

在数学中，用同一个符号来在不同的语境中代表数学对象的不同方面是很常见的。
例如，如果在一个需要集合的语境中给出了一个环，那么理解为该环对应的集合也是很有道理的。
在编程语言中，有一些规则自动地将一种类型转换为另一种类型也是很常见的。
例如，Java 允许 `byte` 自动转换为一个 `int`，Kotlin 也允许非空类型在可为空的语境中使用。

<!--
In Lean, both purposes are served by a mechanism called _coercions_.
When Lean encounters an expression of one type in a context that expects a different type, it will attempt to coerce the expression before reporting a type error.
Unlike Java, C, and Kotlin, the coercions are extensible by defining instances of type classes.
-->

在 Lean 中，这两个目的都是用一个叫做**强制转换（coercions）**的机制实现的。
当 Lean 遇到了在某语境中某表达式的类型与期望类型不一致时，Lean 在报错前会尝试进行强制转换。
不像 Java，C，和 Kotlin，强制转换是通过定义类型类实例实现的，并且是可扩展的。

<!--
## Positive Numbers
-->

## 正数

<!--
For example, every positive number corresponds to a natural number.
The function `Pos.toNat` that was defined earlier converts a `Pos` to the corresponding `Nat`:
-->

例如，每个正数都对应一个自然数。
之前定义的函数 `Pos.toNat` 可以将一个 `Pos` 转换成对应的 `Nat`：
```lean
{{#example_decl Examples/Classes.lean posToNat}}
```
<!--
The function `List.drop`, with type `{{#example_out Examples/Classes.lean drop}}`, removes a prefix of a list.
Applying `List.drop` to a `Pos`, however, leads to a type error:
-->

函数 `List.drop`，的类型是 `{{#example_out Examples/Classes.lean drop}}`，它将列表的前缀移除。
将 `List.drop` 应用到 `Pos` 会产生一个类型错误：
```lean
{{#example_in Examples/Classes.lean dropPos}}
```
```output error
{{#example_out Examples/Classes.lean dropPos}}
```
<!--
Because the author of `List.drop` did not make it a method of a type class, it can't be overridden by defining a new instance.
-->

因为 `List.drop` 的作者没有让它成为一个类型类的方法，所以它没有办法通过定义新实例的方式来重写。

<!--
The type class `Coe` describes overloaded ways of coercing from one type to another:
-->

`Coe` 类型类描述了类型间强制转换的重载方法。
```lean
{{#example_decl Examples/Classes.lean Coe}}
```
<!--
An instance of `Coe Pos Nat` is enough to allow the prior code to work:
-->

一个 `Coe Pos Nat` 的实例就足够让先前的代码正常工作了。
```lean
{{#example_decl Examples/Classes.lean CoePosNat}}

{{#example_in Examples/Classes.lean dropPosCoe}}
```
```output info
{{#example_out Examples/Classes.lean dropPosCoe}}
```
<!--
Using `#check` shows the result of the instance search that was used behind the scenes:
-->

用 `#check` 来看隐藏在幕后的实例搜索。
```lean
{{#example_in Examples/Classes.lean checkDropPosCoe}}
```
```output info
{{#example_out Examples/Classes.lean checkDropPosCoe}}
```

<!--
## Chaining Coercions
-->

## 链式强制转换

<!--
When searching for coercions, Lean will attempt to assemble a coercion out of a chain of smaller coercions.
For example, there is already a coercion from `Nat` to `Int`.
Because of that instance, combined with the `Coe Pos Nat` instance, the following code is accepted:
-->

在寻找强制转换时，Lean 会尝试通过一系列较小的强制转换来组成一个完整的强制转换。
例如，已经存在一个从 `Nat` 到 `Int` 的强制转换实例。
由于这个实例结合了 `Coe Pos Nat` 实例，我们就可以写出下面的代码：
```lean
{{#example_decl Examples/Classes.lean posInt}}
```
<!--
This definition uses two coercions: from `Pos` to `Nat`, and then from `Nat` to `Int`.
-->

这个定义用到了两个强制转换：从 `Pos` 到 `Nat`，再从 `Nat` 到 `Int`。

<!--
The Lean compiler does not get stuck in the presence of circular coercions.
For example, even if two types `A` and `B` can be coerced to one another, their mutual coercions can be used to find a path:
-->

Lean 编译器在存在循环强制转换的情况下不会陷入无限循环。
例如，即使两个类型 `A` 和 `B` 可以互相强制转换，在转换中 Lean 也可以找到一个路径。
```lean
{{#example_decl Examples/Classes.lean CoercionCycle}}
```
<!--
Remember: the double parentheses `()` is short for the constructor `Unit.unit`.
After deriving a `Repr B` instance,
-->

提示：双括号 `()` 是构造子 `Unit.unit` 的简写。
在派生 `Repr B` 实例后，
```lean
{{#example_in Examples/Classes.lean coercedToBEval}}
```
<!--
results in:
-->

结果为：
```output info
{{#example_out Examples/Classes.lean coercedToBEval}}
```

<!--
The `Option` type can be used similarly to nullable types in C# and Kotlin: the `none` constructor represents the absence of a value.
The Lean standard library defines a coercion from any type `α` to `Option α` that wraps the value in `some`.
This allows option types to be used in a manner even more similar to nullable types, because `some` can be omitted.
For instance, the function `List.getLast?` that finds the last entry in a list can be written without a `some` around the return value `x`:
-->

`Option` 类型类似于 C# 和 Kotlin 中可为空的类型：`none` 构造子就代表了一个不存在的值。
Lean 标准库定义了一个从任意类型 `α` 到 `Option α` 的强制转换，效果是会将值包裹在 `some` 中。
这使得 option 类型用起来更像是其他语言中可为空的类型，因为 `some` 是可以忽略的。
例如，可以找到列表中最后一个元素的函数 `List.getLast?`，就可以直接返回值 `x` 而无需加上 `some`：
```lean
{{#example_decl Examples/Classes.lean lastHuh}}
```
<!--
Instance search finds the coercion, and inserts a call to `coe`, which wraps the argument in `some`.
These coercions can be chained, so that nested uses of `Option` don't require nested `some` constructors:
-->

实例搜索找到强制转换，并插入对 `coe` 的调用，该调用会将参数包装在 `some` 中。这些强制转换可以是链式的，这样嵌套使用 `Option` 时就不需要嵌套的 `some` 构造子：
```lean
{{#example_decl Examples/Classes.lean perhapsPerhapsPerhaps}}
```

<!--
Coercions are only activated automatically when Lean encounters a mismatch between an inferred type and a type that is imposed from the rest of the program.
In cases with other errors, coercions are not activated.
For example, if the error is that an instance is missing, coercions will not be used:
-->

仅当 Lean 遇到推断出的类型和剩下的程序需要的类型不匹配时，才会自动使用强制转换。
在遇到其它错误时，强制转换不会被使用。
例如，如果遇到的错误是实例缺失，强制类型转换不会被使用：
```lean
{{#example_in Examples/Classes.lean ofNatBeforeCoe}}
```
```output error
{{#example_out Examples/Classes.lean ofNatBeforeCoe}}
```

<!--
This can be worked around by manually indicating the desired type to be used for `OfNat`:
-->

这可以通过手动指定 `OfNat` 所需的类型来解决：
```lean
{{#example_decl Examples/Classes.lean perhapsPerhapsPerhapsNat}}
```
<!--
Additionally, coercions can be manually inserted using an up arrow:
-->

此外，强制转换用一个上箭头手动调用。
```lean
{{#example_decl Examples/Classes.lean perhapsPerhapsPerhapsNatUp}}
```
<!--
In some cases, this can be used to ensure that Lean finds the right instances.
It can also make the programmer's intentions more clear.
-->

在一些情况下，这可以保证 Lean 找到了正确的实例。
这也会让程序员的意图更加清晰。


<!--
## Non-Empty Lists and Dependent Coercions
-->

## 非空列表与依值强制转换

<!--
An instance of `Coe α β` makes sense when the type `β` has a value that can represent each value from the type `α`.
Coercing from `Nat` to `Int` makes sense, because the type `Int` contains all the natural numbers.
Similarly, a coercion from non-empty lists to ordinary lists makes sense because the `List` type can represent every non-empty list:
-->

当 `β` 类型中的值可以对应每一个 `α` 类型中的值时，`Coe α β` 实例才是合理的。
将 `Nat` 强制转换为 `Int` 是合理的，因为 `Int` 类型中包含了全部的自然数。
类似地，一个从非空列表到常规列表的强制转换也是合理的，因为 `List` 类型可以表示每一个非空列表：
```lean
{{#example_decl Examples/Classes.lean CoeNEList}}
```
<!--
This allows non-empty lists to be used with the entire `List` API.
-->

这使得非空列表可以使用全部的 `List` API。

<!--
On the other hand, it is impossible to write an instance of `Coe (List α) (NonEmptyList α)`, because there's no non-empty list that can represent the empty list.
This limitation can be worked around by using another version of coercions, which are called _dependent coercions_.
Dependent coercions can be used when the ability to coerce from one type to another depends on which particular value is being coerced.
Just as the `OfNat` type class takes the particular `Nat` being overloaded as a parameter, dependent coercion takes the value being coerced as a parameter:
-->

另一方面，我们不可能写出一个 `Coe (List α) (NonEmptyList α)` 的实例，因为没有任何一个非空列表可以表示一个空列表。
这个限制可以通过其他方式的强制转换来解决，该强制转换被称为**依值强制转换（dependent coercions）**。
当是否能将一种类型强制转换到另一种类型依赖于具体的值时，依值强制转换就派上用场了。
就像 `OfNat` 类型类需要具体的 `Nat` 来作为参数，依值强制转换也接受要被强制转换的值作为参数：
```lean
{{#example_decl Examples/Classes.lean CoeDep}}
```
<!--
This is a chance to select only certain values, either by imposing further type class constraints on the value or by writing certain constructors directly.
For example, any `List` that is not actually empty can be coerced to a `NonEmptyList`:
-->

这可以使得只选取特定的值，通过加上进一步的类型类约束或者直接写出特定的构造子。
例如，任意非空的 `List` 都可以被强制转换为一个 `NonEmptyList`：
```lean
{{#example_decl Examples/Classes.lean CoeDepListNEList}}
```

<!--
## Coercing to Types
-->

## 强制转换为类型

<!--
In mathematics, it is common to have a concept that consists of a set equipped with additional structure.
For example, a monoid is some set _S_, an element _s_ of _S_, and an associative binary operator on _S_, such that _s_ is neutral on the left and right of the operator.
_S_ is referred to as the "carrier set" of the monoid.
The natural numbers with zero and addition form a monoid, because addition is associative and adding zero to any number is the identity.
Similarly, the natural numbers with one and multiplication also form a monoid.
Monoids are also widely used in functional programming: lists, the empty list, and the append operator form a monoid, as do strings, the empty string, and string append:
-->

在数学中，一个建立在集合上，但是比集合具有额外的结构的概念是很常见的。
例如，一个幺半群就是一些集合 _S_，一个 _S_ 中的元素 _s_，以及一个 _S_ 上结合的二元运算，使得 _s_ 在运算的左侧和右侧都是中性的。
_S_ 是这个幺半群的“载体集”。
自然数集上的零和加法构成一个幺半群，因为加法是满足结合律的，并且为任何一个数字加零都是恒等的。
类似地，自然数上的一和乘法也构成一个幺半群。
幺半群在函数式编程中的应用也很广泛：列表，空列表，和连接运算符构成一个幺半群。
字符串，空字符串，和连接运算符也构成一个幺半群：
```lean
{{#example_decl Examples/Classes.lean Monoid}}
```
<!--
Given a monoid, it is possible to write the `foldMap` function that, in a single pass, transforms the entries in a list into a monoid's carrier set and then combines them using the monoid's operator.
Because monoids have a neutral element, there is a natural result to return when the list is empty, and because the operator is associative, clients of the function don't have to care whether the recursive function combines elements from left to right or from right to left.
-->

给定一个幺半群，我们就可以写出一个 `foldMap` 函数，该函数在一次遍历中将整个列表中的元素映射到载体集中，然后使用幺半群的运算符将它们组合起来。
由于幺半群有单位元，所以当列表为空时我们就可以返回这个值。
又因为运算符是满足结合律的，这个函数的用户不需要关心函数结合元素的顺序到底是从左到右的还是从右到左的。
```lean
{{#example_decl Examples/Classes.lean firstFoldMap}}
```

<!--
Even though a monoid consists of three separate pieces of information, it is common to just refer to the monoid's name in order to refer to its set.
Instead of saying "Let A be a monoid and let _x_ and _y_ be elements of its carrier set", it is common to say "Let _A_ be a monoid and let _x_ and _y_ be elements of _A_".
This practice can be encoded in Lean by defining a new kind of coercion, from the monoid to its carrier set.
-->

尽管一个幺半群是由三部分信息组成的，但在提及它的载体集时使用幺半群的名字也是很常见的。
说“令 _A_ 为一个幺半群，并令 _x_ 和 _y_ 为 _A_ 中的元素”是很常见的，而不是说“令 _A_ 为一个幺半群，并令 _x_ 和 _y_ 为载体集中的元素”。
这种方式可以通过定义一种新的强制转换来在 Lean 中实现，该转换从幺半群到它的载体集。

<!--
The `CoeSort` class is just like the `Coe` class, with the exception that the target of the coercion must be a _sort_, namely `Type` or `Prop`.
The term _sort_ in Lean refers to these types that classify other types—`Type` classifies types that themselves classify data, and `Prop` classifies propositions that themselves classify evidence of their truth.
Just as `Coe` is checked when a type mismatch occurs, `CoeSort` is used when something other than a sort is provided in a context where a sort would be expected.
-->

`CoeSort` 类型类和 `Coe` 大同小异，只是要求强制转换的目标一定要是一个 _sort_，即 `Type` 或 `Prop`。
词语 _sort_ 指的是这些分类其他类型的类型——`Type` 分类那些本身分类数据的类型，而 `Prop` 分类那些本身分类其真实性证据的命题。
正如在类型不匹配时会检查 `Coe` 一样，当在预期为 sort 的上下文中提供了其他东西时，会使用 `CoeSort`。

<!--
The coercion from a monoid into its carrier set extracts the carrier:
-->

从一个幺半群到它的载体集的强制转换会返回该载体集：
```lean
{{#example_decl Examples/Classes.lean CoeMonoid}}
```
<!--
With this coercion, the type signatures become less bureaucratic:
-->

有了这个强制转换，类型签名变得不那么繁琐了：
```lean
{{#example_decl Examples/Classes.lean foldMap}}
```

<!--
Another useful example of `CoeSort` is used to bridge the gap between `Bool` and `Prop`.
As discussed in [the section on ordering and equality](standard-classes.md#equality-and-ordering), Lean's `if` expression expects the condition to be a decidable proposition rather than a `Bool`.
Programs typically need to be able to branch based on Boolean values, however.
Rather than have two kinds of `if` expression, the Lean standard library defines a coercion from `Bool` to the proposition that the `Bool` in question is equal to `true`:
-->

另一个有用的 `CoeSort` 使用场景是它可以让 `Bool` 和 `Prop` 建立联系。
就像在[有序性和等价性那一节](standard-classes.md#equality-and-ordering)我们提到的，Lean 的 `if` 表达式需要条件为一个可判定的命题而不是一个 `Bool`。
然而，程序通常需要能够根据布尔值进行分支。
Lean 标准库并没有定义两种 `if` 表达式，而是定义了一种从 `Bool` 到命题的强制转换，即该 `Bool` 值等于 `true`：
```lean
{{#example_decl Examples/Classes.lean CoeBoolProp}}
```
<!--
In this case, the sort in question is `Prop` rather than `Type`.
-->

如此，这个 sort 将是一个 `Prop` 而不是 `Bool`。

<!--
## Coercing to Functions
-->

## 强制转换为函数 （*本节翻译需要润色*）

<!--
Many datatypes that occur regularly in programming consist of a function along with some extra information about it.
For example, a function might be accompanied by a name to show in logs or by some configuration data.
Additionally, putting a type in a field of a structure, similarly to the `Monoid` example, can make sense in contexts where there is more than one way to implement an operation and more manual control is needed than type classes would allow.
For example, the specific details of values emitted by a JSON serializer may be important because another application expects a particular format.
Sometimes, the function itself may be derivable from just the configuration data.
-->

许多在编程中常见的数据类型都会有一个函数和一些额外的信息组成。
例如，一个函数可能附带一个名称以在日志中显示，或附带一些配置数据。
此外，将一个类型放在结构体的字段中（类似于 `Monoid` 的例子）在某些上下文中是有意义的，这些上下文中存在多种实现操作的方法，并且需要比类型类允许的更手动的控制。
例如，JSON 序列化器生成的值的具体细节可能很重要，因为另一个应用程序期望特定的格式。
有时，仅从配置数据就可以推导出函数本身。

<!--
A type class called `CoeFun` can transform values from non-function types to function types.
`CoeFun` has two parameters: the first is the type whose values should be transformed into functions, and the second is an output parameter that determines exactly which function type is being targeted.
-->

`CoeFun` 类型类可以将非函数类型的值转换为函数类型的值。
`CoeFun` 有两个参数：第一个是需要被转变为函数的值的类型，第二个是一个输出参数，决定了到底应该转换为哪个函数类型。
```lean
{{#example_decl Examples/Classes.lean CoeFun}}
```
<!--
The second parameter is itself a function that computes a type.
In Lean, types are first-class and can be passed to functions or returned from them, just like anything else.
-->

第二个参数本身是一个可以计算类型的函数。
在 Lean 中，类型是一等公民，可以作为函数参数被传递，也可以作为返回值，就像其他东西一样。

<!--
For example, a function that adds a constant amount to its argument can be represented as a wrapper around the amount to add, rather than by defining an actual function:
-->

例如，一个将常量加到其参数的函数可以表示为围绕要添加的量的包装，而不是通过定义一个实际的函数：
```lean
{{#example_decl Examples/Classes.lean Adder}}
```
<!--
A function that adds five to its argument has a `5` in the `howMuch` field:
-->

一个为参数加上5的函数的 `howMuch` 字段为 `5`：
```lean
{{#example_decl Examples/Classes.lean add5}}
```
<!--
This `Adder` type is not a function, and applying it to an argument results in an error:
-->

这个 `Adder` 类型并不是一个函数，将它应用到一个参数会报错：
```lean
{{#example_in Examples/Classes.lean add5notfun}}
```
```output error
{{#example_out Examples/Classes.lean add5notfun}}
```
<!--
Defining a `CoeFun` instance causes Lean to transform the adder into a function with type `Nat → Nat`:
-->

定义一个 `CoeFun` 实例让 Lean 来将 adder 转换为一个 `Nat → Nat` 的函数：
```lean
{{#example_decl Examples/Classes.lean CoeFunAdder}}

{{#example_in Examples/Classes.lean add53}}
```
```output info
{{#example_out Examples/Classes.lean add53}}
```
<!--
Because all `Adder`s should be transformed into `Nat → Nat` functions, the argument to `CoeFun`'s second parameter was ignored.
-->

因为所有的 `Adder` 都应该被转换为 `Nat → Nat` 的函数，`CoeFun` 的第二个参数就被省略了。

<!--
When the value itself is needed to determine the right function type, then `CoeFun`'s second parameter is no longer ignored.
For example, given the following representation of JSON values:
-->

当我们需要这个值来决定正确的函数类型时，`CoeFun` 的第二个参数就派上用场了。
例如，给定下面的 JSON 值表示：
```lean
{{#example_decl Examples/Classes.lean JSON}}
```
<!--
a JSON serializer is a structure that tracks the type it knows how to serialize along with the serialization code itself:
-->

一个 JSON 序列化器是一个结构体，它不仅包含它知道如何序列化的类型，还包含序列化代码本身：
```lean
{{#example_decl Examples/Classes.lean Serializer}}
```
<!--
A serializer for strings need only wrap the provided string in the `JSON.string` constructor:
-->

对字符串的序列化器只需要将所给的字符串包装在 `JSON.string` 构造子中即可：
```lean
{{#example_decl Examples/Classes.lean StrSer}}
```
<!--
Viewing JSON serializers as functions that serialize their argument requires extracting the inner type of serializable data:
-->

将 JSON 序列化器视为序列化其参数的函数需要提取可序列化数据的内部类型：
```lean
{{#example_decl Examples/Classes.lean CoeFunSer}}
```
<!--
Given this instance, a serializer can be applied directly to an argument:
-->

有了这个实例，一个序列化器就能直接应用在参数上。
```lean
{{#example_decl Examples/Classes.lean buildResponse}}
```
<!--
The serializer can be passed directly to `buildResponse`:
-->

这个序列化器可以直接传入 `buildResponse`：
```lean
{{#example_in Examples/Classes.lean buildResponseOut}}
```
```output info
{{#example_out Examples/Classes.lean buildResponseOut}}
```

<!--
### Aside: JSON as a String
-->

### 附注：将 JSON 表示为字符串

<!--
It can be a bit difficult to understand JSON when encoded as Lean objects.
To help make sure that the serialized response was what was expected, it can be convenient to write a simple converter from `JSON` to `String`.
The first step is to simplify the display of numbers.
`JSON` doesn't distinguish between integers and floating point numbers, and the type `Float` is used to represent both.
In Lean, `Float.toString` includes a number of trailing zeros:
-->

当 JSON 被编码为 Lean 对象时可能有点难以理解。
为了帮助保证序列化的响应是我们所期望的，写一个简单的从 `JSON` 到 `String` 的转换器可能会很方便。
第一步是简化数字的显示。
`JSON` 不区分整数和浮点数，`Float` 类型即可用来代表二者。
在 Lean 中，`Float.toString` 包括数字的后继零。
```lean
{{#example_in Examples/Classes.lean fiveZeros}}
```
```output info
{{#example_out Examples/Classes.lean fiveZeros}}
```
<!--
The solution is to write a little function that cleans up the presentation by dropping all trailing zeros, followed by a trailing decimal point:
-->

解决方案是写一个小函数，这个函数可以清理掉所有的后继零，和后继的小数点：
```lean
{{#example_decl Examples/Classes.lean dropDecimals}}
```
<!--
With this definition, `{{#example_in Examples/Classes.lean dropDecimalExample}}` yields `{{#example_out Examples/Classes.lean dropDecimalExample}}`, and `{{#example_in Examples/Classes.lean dropDecimalExample2}}` yields `{{#example_out Examples/Classes.lean dropDecimalExample2}}`.
-->

有了这个定义，`{{#example_in Examples/Classes.lean dropDecimalExample}}` 结果为 `{{#example_out Examples/Classes.lean dropDecimalExample}}`，`{{#example_in Examples/Classes.lean dropDecimalExample2}}` 结果为 `{{#example_out Examples/Classes.lean dropDecimalExample2}}`。

<!--
The next step is to define a helper function to append a list of strings with a separator in between them:
-->

下一步是定义一个辅助函数来连接字符串列表，并在中间添加分隔符：
```lean
{{#example_decl Examples/Classes.lean Stringseparate}}
```
<!--
This function is useful to account for comma-separated elements in JSON arrays and objects.
`{{#example_in Examples/Classes.lean sep2ex}}` yields `{{#example_out Examples/Classes.lean sep2ex}}`, `{{#example_in Examples/Classes.lean sep1ex}}` yields `{{#example_out Examples/Classes.lean sep1ex}}`, and `{{#example_in Examples/Classes.lean sep0ex}}` yields `{{#example_out Examples/Classes.lean sep0ex}}`.
-->

这个函数用于处理 JSON 数组和对象中的逗号分隔元素。
`{{#example_in Examples/Classes.lean sep2ex}}` 结果为 `{{#example_out Examples/Classes.lean sep2ex}}`，`{{#example_in Examples/Classes.lean sep1ex}}` 结果为 `{{#example_out Examples/Classes.lean sep1ex}}`，`{{#example_in Examples/Classes.lean sep0ex}}` 结果为 `{{#example_out Examples/Classes.lean sep0ex}}`。

<!--
Finally, a string escaping procedure is needed for JSON strings, so that the Lean string containing `"Hello!"` can be output as `"\"Hello!\""`.
Fortunately, the Lean compiler contains an internal function for escaping JSON strings already, called `Lean.Json.escape`.
To access this function, add `import Lean` to the beginning of your file.
-->

最后，需要一个字符串转义程序来处理 JSON 字符串，以便包含 "Hello!" 的 Lean 字符串可以输出为 "\"Hello!\"”。
幸运的是，Lean 编译器已经包含了一个用于转义 JSON 字符串的内部函数，叫做 `Lean.Json.escape`。
要使用这个函数，可以在文件开头添加 `import Lean`。

<!--
The function that emits a string from a `JSON` value is declared `partial` because Lean cannot see that it terminates.
This is because recursive calls to `asString` occur in functions that are being applied by `List.map`, and this pattern of recursion is complicated enough that Lean cannot see that the recursive calls are actually being performed on smaller values.
In an application that just needs to produce JSON strings and doesn't need to mathematically reason about the process, having the function be `partial` is not likely to cause problems.
-->

将 `JSON` 值转换为字符串的函数被声明了 `partial`，因为 Lean 并不知道它是否停机。
这是因为出现在函数中的 `asString` 的递归调用被应用到了 `List.map`，这种模式的递归已经复杂到 Lean 无法知道递归过程中值的规模是否是减小的。
在一个只需要产生 JSON 字符串而不需要让过程在数学上是合理的的应用中，让函数是 `partial` 的不太可能造成麻烦。
```lean
{{#example_decl Examples/Classes.lean JSONasString}}
```
<!--
With this definition, the output of serialization is easier to read:
-->

有了这个定义，序列化的结果更加易读了：
```lean
{{#example_in Examples/Classes.lean buildResponseStr}}
```
```output info
{{#example_out Examples/Classes.lean buildResponseStr}}
```


<!--
## Messages You May Meet
-->

## 可能会遇到的问题

<!--
Natural number literals are overloaded with the `OfNat` type class.
Because coercions fire in cases where types don't match, rather than in cases of missing instances, a missing `OfNat` instance for a type does not cause a coercion from `Nat` to be applied:
-->

自然数字面量是通过 `OfNat` 类型类重载的。
因为在类型不匹配时才会触发强制转换，而不是在找不到实例时，所以当对于某类型的 `OfNat` 实例缺失时，并不会触发强制转换：
```lean
{{#example_in Examples/Classes.lean ofNatBeforeCoe}}
```
```output error
{{#example_out Examples/Classes.lean ofNatBeforeCoe}}
```

<!--
## Design Considerations
-->

## 设计原则

<!--
Coercions are a powerful tool that should be used responsibly.
On the one hand, they can allow an API to naturally follow the everyday rules of the domain being modeled.
This can be the difference between a bureaucratic mess of manual conversion functions and a clear program.
As Abelson and Sussman wrote in the preface to _Structure and Interpretation of Computer Programs_ (MIT Press, 1996),
-->

强制转换是一个强大的工具，请负责任地使用它。
一方面，它可以使 API 设计得更贴近领域内使用习惯。
这是繁琐的手动转换函数和一个清晰的程序间的差别。
正如 Abelson 和 Sussman 在《计算机程序的构造和解释》（ _Structure and Interpretation of Computer Programs_ ）（麻省理工学院出版社，1996年）前言中所写的那样：

<!--
> Programs must be written for people to read, and only incidentally for machines to execute.
-->

> 写程序须以让人读明白为主，让计算机执行为辅。

<!--
Coercions, used wisely, are a valuable means of achieving readable code that can serve as the basis for communication with domain experts.
APIs that rely heavily on coercions have a number of important limitations, however.
Think carefully about these limitations before using coercions in your own libraries.
-->

明智地使用强制转换，可以使得代码更加易读——这是与领域内专家的交流的基础。
然而，严重依赖强制转换的 API 会有许多限制。
在你自己的代码中使用强制转换前，认真思考这些限制。

<!--
First off, coercions are only applied in contexts where enough type information is available for Lean to know all of the types involved, because there are no output parameters in the coercion type classes. This means that a return type annotation on a function can be the difference between a type error and a successfully applied coercion.
For example, the coercion from non-empty lists to lists makes the following program work:
-->

首先，强制转换只应该出现在类型信息充足，Lean 能够知道所有参与的类型的语境中。
因为强制转换类型类中并没有输出参数这么一说。
这意味着在函数上添加返回类型注释可以决定是类型错误还是成功应用强制转换。
例如，从非空列表到列表的强制转换使以下程序得以运行：
```lean
{{#example_decl Examples/Classes.lean lastSpiderA}}
```
<!--
On the other hand, if the type annotation is omitted, then the result type is unknown, so Lean is unable to find the coercion:
-->

另一方面，如果类型注释被省略了，那么结果的类型就是未知的，那么 Lean 就无法找到对应的强制转换。
```lean
{{#example_in Examples/Classes.lean lastSpiderB}}
```
```output error
{{#example_out Examples/Classes.lean lastSpiderB}}
```
<!--
More generally, when a coercion is not applied for some reason, the user receives the original type error, which can make it difficult to debug chains of coercions.
-->

通常来讲，如果一个强制转换因为一些原因失败了，用户会收到原始的类型错误，这会使在强制转换链上定位错误变得十分困难。

<!--
Finally, coercions are not applied in the context of field accessor notation.
This means that there is still an important difference between expressions that need to be coerced and those that don't, and this difference is visible to users of your API.
-->

最后，强制转换不会在字段访问符号的上下文中应用。
这意味着需要强制转换的表达式与不需要强制转换的表达式之间仍然存在重要区别，而这个区别对用户来说是肉眼可见的。



