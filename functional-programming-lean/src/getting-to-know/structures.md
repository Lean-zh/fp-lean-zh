<!--
# Structures
-->

# 结构体

<!--
The first step in writing a program is usually to identify the problem domain's concepts, and then find suitable representations for them in code.
Sometimes, a domain concept is a collection of other, simpler, concepts.
In that case, it can be convenient to group these simpler components together into a single "package", which can then be given a meaningful name.
In Lean, this is done using _structures_, which are analogous to `struct`s in C or Rust and `record`s in C#.
-->

编写程序的第一步通常是找出问题域中的概念，然后用合适的代码表示它们。
有时，一个域概念是其他更简单概念的集合。此时，将这些更简单的组件分组到一个「包」中会很方便，
然后可以给它取一个有意义的名称。在 Lean 中，这是使用 **结构体（Structure）** 完成的，
它类似于 C 或 Rust 中的 `struct` 和 C# 中的 `record`。

<!--
Defining a structure introduces a completely new type to Lean that can't be reduced to any other type.
This is useful because multiple structures might represent different concepts that nonetheless contain the same data.
For instance, a point might be represented using either Cartesian or polar coordinates, each being a pair of floating-point numbers.
Defining separate structures prevents API clients from confusing one for another.
-->

定义一个结构体会向 Lean 引入一个全新的类型，该类型不能化简为任何其他类型。
这很有用，因为多个结构体可能表示不同的概念，但它们包含相同的数据。
例如，一个点可以用笛卡尔坐标或极坐标表示，每个都是一对浮点数。
分别定义不同的结构体可以防止 API 的用户将一个与另一个混淆。

<!--
Lean's floating-point number type is called `Float`, and floating-point numbers are written in the usual notation.
-->

Lean 的浮点数类型称为 `Float`，浮点数采用通常的表示法。

```lean
{{#example_in Examples/Intro.lean onePointTwo}}
```

```output info
{{#example_out Examples/Intro.lean onePointTwo}}
```

```lean
{{#example_in Examples/Intro.lean negativeLots}}
```

```output info
{{#example_out Examples/Intro.lean negativeLots}}
```

```lean
{{#example_in Examples/Intro.lean zeroPointZero}}
```

```output info
{{#example_out Examples/Intro.lean zeroPointZero}}
```

<!--
When floating point numbers are written with the decimal point, Lean will infer the type `Float`. If they are written without it, then a type annotation may be necessary.
-->

当浮点数使用小数点书写时，Lean 会推断其类型为 `Float`。
如果不使用小数点书写，则可能需要类型标注。

```lean
{{#example_in Examples/Intro.lean zeroNat}}
```

```output info
{{#example_out Examples/Intro.lean zeroNat}}
```

```lean
{{#example_in Examples/Intro.lean zeroFloat}}
```

```output info
{{#example_out Examples/Intro.lean zeroFloat}}
```

<!--
A Cartesian point is a structure with two `Float` fields, called `x` and `y`.
This is declared using the `structure` keyword.
-->

笛卡尔点是一个结构体，它有两个 `Float` 字段，称为 `x` 和 `y`。
它使用 `structure` 关键字声明。

```lean
{{#example_decl Examples/Intro.lean Point}}
```

<!--
After this declaration, `Point` is a new structure type.
The final line, which says `deriving Repr`, asks Lean to generate code to display values of type `Point`.
This code is used by `#eval` to render the result of evaluation for consumption by programmers, analogous to the `repr` function in Python.
It is also possible to override the compiler's generated display code.
-->

声明之后，`Point` 就是一个新的结构体类型了。最后一行写着 `deriving Repr`，
它要求 Lean 生成代码以显示类型为 `Point` 的值。此代码用于 `#eval`
显示求值结果以供程序员使用，类似于 Python 中的 `repr` 函数。
编译器生成的显示代码也可以被覆盖。

<!--
The typical way to create a value of a structure type is to provide values for all of its fields inside of curly braces.
The origin of a Cartesian plane is where `x` and `y` are both zero:
-->

创建结构体类型值通常的方法是在大括号内为其所有字段提供值。
笛卡尔平面的原点是 `x` 和 `y` 均为零的点：

```lean
{{#example_decl Examples/Intro.lean origin}}
```

<!--
If the `deriving Repr` line in `Point`'s definition were omitted, then attempting `{{#example_in Examples/Intro.lean PointNoRepr}}` would yield an error similar to that which occurs when omitting a function's argument:
-->

如果 `Point` 定义中的 `deriving Repr` 行被省略，则尝试
`{{#example_in Examples/Intro.lean PointNoRepr}}`
会产生类似于省略函数参数时产生的错误："

```output error
{{#example_out Examples/Intro.lean PointNoRepr}}
```

<!--
That message is saying that the evaluation machinery doesn't know how to communicate the result of evaluation back to the user.
-->

该消息表明求值机制不知道如何将求值结果传达给用户。

<!--
Happily, with `deriving Repr`, the result of `{{#example_in Examples/Intro.lean originEval}}` looks very much like the definition of `origin`.
-->

幸运的是，使用 `deriving Repr`，`{{#example_in Examples/Intro.lean originEval}}`
的结果看起来非常像 `origin` 的定义。

```output info
{{#example_out Examples/Intro.lean originEval}}
```

<!--
Because structures exist to "bundle up" a collection of data, naming it and treating it as a single unit, it is also important to be able to extract the individual fields of a structure.
This is done using dot notation, as in C, Python, or Rust.
-->

由于结构体是用来「打包」一组数据，并将其命名并后作为单个单元进行处理的，
因此能够提取结构体的各个字段也很重要。这可以使用点记法，就像在 C、Python 或 Rust 中一样。

```lean
{{#example_in Examples/Intro.lean originx}}
```

```output info
{{#example_out Examples/Intro.lean originx}}
```

```lean
{{#example_in Examples/Intro.lean originy}}
```

```output info
{{#example_out Examples/Intro.lean originy}}
```

<!--
This can be used to define functions that take structures as arguments.
For instance, addition of points is performed by adding the underlying coordinate values.
It should be the case that `{{#example_in Examples/Intro.lean addPointsEx}}` yields
-->

可以定义以结构体作为参数的函数。例如，点的加法可通过底层坐标值相加来执行。
`{{#example_in Examples/Intro.lean addPointsEx}}` 会产生

```output info
{{#example_out Examples/Intro.lean addPointsEx}}
```

<!--
The function itself takes two `Points` as arguments, called `p1` and `p2`.
The resulting point is based on the `x` and `y` fields of both `p1` and `p2`:
-->

该函数本身以两个 `Points` 作为参数，分别为 `p1` 和 `p2`。
结果点基于 `p1` 和 `p2` 的 `x` 和 `y` 字段："

```lean
{{#example_decl Examples/Intro.lean addPoints}}
```

<!--
Similarly, the distance between two points, which is the square root of the sum of the squares of the differences in their `x` and `y` components, can be written:
-->

类似地，两点之间的距离（即其 `x` 和 `y` 分量之差的平方和的平方根）可以写成：

```lean
{{#example_decl Examples/Intro.lean distance}}
```

<!--
For example, the distance between (1, 2) and (5, -1) is 5:
-->

例如，(1, 2) 和 (5, -1) 之间的距离为 5：

```lean
{{#example_in Examples/Intro.lean evalDistance}}
```

```output info
{{#example_out Examples/Intro.lean evalDistance}}
```

<!--
Multiple structures may have fields with the same names.
For instance, a three-dimensional point datatype may share the fields `x` and `y`, and be instantiated with the same field names:
-->

不同结构体可能具有同名的字段。例如，三维点数据类型可能共享字段 `x` 和 `y`，
并使用相同的字段名实例化：

```lean
{{#example_decl Examples/Intro.lean Point3D}}

{{#example_decl Examples/Intro.lean origin3D}}
```

这意味着必须知道结构体的预期类型才能使用大括号语法。
如果类型未知，Lean 将无法实例化结构体。例如，

```lean
{{#example_in Examples/Intro.lean originNoType}}
```

<!--
leads to the error
-->

会导致错误

```output error
{{#example_out Examples/Intro.lean originNoType}}
```

<!--
As usual, the situation can be remedied by providing a type annotation.
-->

通常，可以通过提供类型标注来补救这种情况。

```lean
{{#example_in Examples/Intro.lean originWithAnnot}}
```

```output info
{{#example_out Examples/Intro.lean originWithAnnot}}
```

<!--
To make programs more concise, Lean also allows the structure type annotation inside the curly braces.
-->

为了使程序更加简洁，Lean 还允许在大括号内标注结构体类型。

```lean
{{#example_in Examples/Intro.lean originWithAnnot2}}
```

```output info
{{#example_out Examples/Intro.lean originWithAnnot2}}
```

<!--
## Updating Structures
-->

## 更新结构体

<!--
Imagine a function `zeroX` that replaces the `x` field of a `Point` with `0.0`.
In most programming language communities, this sentence would mean that the memory location pointed to by `x` was to be overwritten with a new value.
However, Lean does not have mutable state.
In functional programming communities, what is almost always meant by this kind of statement is that a fresh `Point` is allocated with the `x` field pointing to the new value, and all other fields pointing to the original values from the input.
One way to write `zeroX` is to follow this description literally, filling out the new value for `x` and manually transferring `y`:
-->

设想一个函数 `zeroX`，它将 `Point` 的 `x` 字段置为 `0.0`。
在大多数编程语言社区中，这句话意味着指向 `x` 的内存位置将被新值覆盖。
但是，Lean 没有可变状态。在函数式编程社区中，这种说法几乎总是意味着分配一个新的 `Point`，
其 `x` 字段指向新值，而其他字段指向输入中的原始值。
编写 `zeroX` 的一种方法是逐字遵循此描述，填写 `x` 的新值并手动传入 `y`：

```lean
{{#example_decl Examples/Intro.lean zeroXBad}}
```

<!--
This style of programming has drawbacks, however.
First off, if a new field is added to a structure, then every site that updates any field at all must be updated, causing maintenance difficulties.
Secondly, if the structure contains multiple fields with the same type, then there is a real risk of copy-paste coding leading to field contents being duplicated or switched.
Finally, the program becomes long and bureaucratic.
-->

然而，这种编程风格也存在一些缺点。首先，如果向结构体中添加了一个新字段，
那么所有更新任何字段的代码都需要更新，这会导致维护困难。
其次，如果结构体中包含多个具有相同类型的字段，那么存在真正的风险，
即复制粘贴代码会导致字段内容被复制或交换。最后，程序会变得冗长且呆板。

<!--
Lean provides a convenient syntax for replacing some fields in a structure while leaving the others alone.
This is done by using the `with` keyword in a structure initialization.
The source of unchanged fields occurs before the `with`, and the new fields occur after.
For instance, `zeroX` can be written with only the new `x` value:
-->

Lean 提供了一种便捷的语法，用于替换结构体中的一些字段，同时保留其他字段。
这是通过在结构体初始化中使用 `with` 关键字来完成的。未更改字段的源代码写在 `with` 之前，
而新字段写在 `with` 之后。例如，`zeroX` 可以仅使用新的 `x` 值编写：

```lean
{{#example_decl Examples/Intro.lean zeroX}}
```

<!--
Remember that this structure update syntax does not modify existing values—it creates new values that share some fields with old values.
For instance, given the point `fourAndThree`:
-->

请记住，此结构体更新语法不会修改现有值，它会创建一些与旧值共享某些字段的新值。
例如，给定点 `fourAndThree`：

```lean
{{#example_decl Examples/Intro.lean fourAndThree}}
```

<!--
evaluating it, then evaluating an update of it using `zeroX`, then evaluating it again yields the original value:
-->

对其进行求值，然后使用 `zeroX` 对其进行更新，然后再次对其进行求值，将产生原始值：

```lean
{{#example_in Examples/Intro.lean fourAndThreeEval}}
```

```output info
{{#example_out Examples/Intro.lean fourAndThreeEval}}
```

```lean
{{#example_in Examples/Intro.lean zeroXFourAndThreeEval}}
```

```output info
{{#example_out Examples/Intro.lean zeroXFourAndThreeEval}}
```

```lean
{{#example_in Examples/Intro.lean fourAndThreeEval}}
```

```output info
{{#example_out Examples/Intro.lean fourAndThreeEval}}
```

<!--
One consequence of the fact that structure updates do not modify the original structure is that it becomes easier to reason about cases where the new value is computed from the old one.
All references to the old structure continue to refer to the same field values in all of the new values provided.
-->

结构体更新不会修改原始结构体，这样更容易推理新值是从旧值计算得出的。
对旧结构体的所有引用会在所有提供的新值中继续引用相同的字段值。

<!--
## Behind the Scenes
-->

## Behind the Scenes

<!--
Every structure has a _constructor_.
Here, the term "constructor" may be a source of confusion.
Unlike constructors in languages such as Java or Python, constructors in Lean are not arbitrary code to be run when a datatype is initialized.
Instead, constructors simply gather the data to be stored in the newly-allocated data structure.
It is not possible to provide a custom constructor that pre-processes data or rejects invalid arguments.
This is really a case of the word "constructor" having different, but related, meanings in the two contexts.
-->

每个结构体都有一个  **构造子（Constructor）** 。「Constructor」一词在英文中可能会引起混淆。
与 Java 或 Python 等语言中的构造函数不同，Lean 中的构造子不是在初始化数据类型时运行的任意代码。
相反，构造子只会收集要存储在新分配的数据结构中的数据。
不可能提供一个预处理数据或拒绝无效参数的自定义构造子。
这实际上是「Constructor」一词在两种情况下具有不同但相关的含义的情况。


<!--
By default, the constructor for a structure named `S` is named `S.mk`.
Here, `S` is a namespace qualifier, and `mk` is the name of the constructor itself.
Instead of using curly-brace initialization syntax, the constructor can also be applied directly.
-->

默认情况下，名为 `S` 的结构体的构造子命名为 `S.mk`。其中，`S` 是命名空间限定符，
`mk` 是构造子本身的名称。除了使用大括号初始化语法外，还可以直接应用构造子。

```lean
{{#example_in Examples/Intro.lean checkPointMk}}
```

<!--
However, this is not generally considered to be good Lean style, and Lean even returns its feedback using the standard structure initializer syntax.
-->

然而，这通常不被认为是良好的 Lean 风格，Lean 甚至使用标准结构体初始化语法返回其结果。

```output info
{{#example_out Examples/Intro.lean checkPointMk}}
```

<!--
Constructors have function types, which means they can be used anywhere that a function is expected.
For instance, `Point.mk` is a function that accepts two `Float`s (respectively `x` and `y`) and returns a new `Point`.
-->

构造子具有函数类型，这意味着它们可以在需要函数的任何地方使用。
例如，`Point.mk` 是一个接受两个 `Float`（分别是 `x` 和 `y`），并返回一个新 `Point` 的函数。

```lean
{{#example_in Examples/Intro.lean Pointmk}}
```

```output info
{{#example_out Examples/Intro.lean Pointmk}}
```

<!--
To override a structure's constructor name, write it with two colons at the beginning.
For instance, to use `Point.point` instead of `Point.mk`, write:
-->

要覆盖结构体的构造子名称，请在开头写出新的名称后跟两个冒号。
例如，要使用 `Point.point` 而非 `Point.mk`，请编写：

```lean
{{#example_decl Examples/Intro.lean PointCtorName}}
```

<!--
In addition to the constructor, an accessor function is defined for each field of a structure.
These have the same name as the field, in the structure's namespace.
For `Point`, accessor functions `Point.x` and `Point.y` are generated.
-->

除了构造子，结构体的每个字段还定义了一个访问器函数。
它们在结构体的命名空间中与字段具有相同的名称。对于 `Point`，
会生成访问器函数 `Point.x` 和 `Point.y`。

```lean
{{#example_in Examples/Intro.lean Pointx}}
```

```output info
{{#example_out Examples/Intro.lean Pointx}}
```

```lean
{{#example_in Examples/Intro.lean Pointy}}
```

```output info
{{#example_out Examples/Intro.lean Pointy}}
```

<!--
In fact, just as the curly-braced structure construction syntax is converted to a call to the structure's constructor behind the scenes, the syntax `p1.x` in the prior definition of `addPoints` is converted into a call to the `Point.x` accessor.
That is, `{{#example_in Examples/Intro.lean originx}}` and `{{#example_in Examples/Intro.lean originx1}}` both yield
-->

实际上，就像大括号结构体构造语法会在幕后转换为对结构体构造函数的调用一样，
`addPoints` 中先前定义中的语法 `p1.x` 会被转换为对 `Point.x` 访问器的调用。
也就是说，`{{#example_in Examples/Intro.lean originx}}`
和 `{{#example_in Examples/Intro.lean originx1}}` 都会产生

```output info
{{#example_out Examples/Intro.lean originx1}}
```

<!--
Accessor dot notation is usable with more than just structure fields.
It can also be used for functions that take any number of arguments.
More generally, accessor notation has the form `TARGET.f ARG1 ARG2 ...`.
If `TARGET` has type `T`, the function named `T.f` is called.
`TARGET` becomes its leftmost argument of type `T`, which is often but not always the first one, and `ARG1 ARG2 ...` are provided in order as the remaining arguments.
For instance, `String.append` can be invoked from a string with accessor notation, even though `String` is not a structure with an `append` field.
-->

访问器的点记法不仅可以与结构字段一起使用。它还可以用于接受任意数量参数的函数。
更一般地说，访问器记法具有以下形式：`TARGET.f ARG1 ARG2 ...`。如果
`TARGET` 的类型为 `T`，则调用名为 `T.f` 的函数。
`TARGET` 是其类型为 `T` 的最左边的参数，它通常但并非总是第一个参数，并且
`ARG1 ARG2 ...` 按顺序作为其余参数提供。例如，即使 `String` 不是具有
`append` 字段的结构，也可以使用访问器记法从字符串中调用 `String.append`。

```lean
{{#example_in Examples/Intro.lean stringAppendDot}}
```

```output info
{{#example_out Examples/Intro.lean stringAppendDot}}
```

<!--
In that example, `TARGET` represents `"one string"` and `ARG1` represents `" and another"`.
-->

在该示例中，`TARGET` 表示 `"one string"`，`ARG1` 表示 `" and another"`。

<!--
The function `Point.modifyBoth` (that is, `modifyBoth` defined in the `Point` namespace) applies a function to both fields in a `Point`:
-->

`Point.modifyBoth` 函数（即在 `Point` 命名空间中定义的 `modifyBoth`）
将一个函数应用于 `Point` 中的两个字段：

```lean
{{#example_decl Examples/Intro.lean modifyBoth}}
```

<!--
Even though the `Point` argument comes after the function argument, it can be used with dot notation as well:
-->

即使 `Point` 参数位于函数参数之后，也可以使用点记法：

```lean
{{#example_in Examples/Intro.lean modifyBothTest}}
```

```output info
{{#example_out Examples/Intro.lean modifyBothTest}}
```

<!--
In this case, `TARGET` represents `fourAndThree`, while `ARG1` is `Float.floor`.
This is because the target of the accessor notation is used as the first argument in which the type matches, not necessarily the first argument.
-->

在这种情况下，`TARGET` 表示 `fourAndThree`，而 `ARG1` 是 `Float.floor`。
这是因为访问器记法的目标用作第一个类型匹配的参数，而不一定是第一个参数。

<!--
## Exercises
-->

## Exercises

<!--
 * Define a structure named `RectangularPrism` that contains the height, width, and depth of a rectangular prism, each as a `Float`.
 * Define a function named `volume : RectangularPrism → Float` that computes the volume of a rectangular prism.
 * Define a structure named `Segment` that represents a line segment by its endpoints, and define a function `length : Segment → Float` that computes the length of a line segment. `Segment` should have at most two fields.
 * Which names are introduced by the declaration of `RectangularPrism`?
 * Which names are introduced by the following declarations of `Hamster` and `Book`? What are their types?
-->

* 定义一个名为 `RectangularPrism` 的结构，其中包含一个矩形棱柱的高度、宽度和深度，每个都是 `Float`。
* 定义一个名为 `volume : RectangularPrism → Float` 的函数，用于计算矩形棱柱的体积。
* 定义一个名为 `Segment` 的结构，它通过其端点表示线段，并定义一个函数
  `length : Segment → Float`，用于计算线段的长度。`Segment` 最多应有两个字段。
* RectangularPrism` 的声明引入了哪些名称？
* 以下 `Hamster` 和 `Book` 的声明引入了哪些名称？它们的类型是什么？

```lean
{{#example_decl Examples/Intro.lean Hamster}}
```

```lean
{{#example_decl Examples/Intro.lean Book}}
```
