import VersoManual
import FPLeanZh.Examples

open Verso.Genre Manual
open Verso Code External

open FPLeanZh

example_module Examples.Intro

set_option verso.exampleProject "../examples"
set_option verso.exampleModule "Examples.Intro"

#doc (Manual) "结构" =>
-- "Structures"
%%%
tag := "structures"
%%%

-- The first step in writing a program is usually to identify the problem domain's concepts, and then find suitable representations for them in code.
-- Sometimes, a domain concept is a collection of other, simpler, concepts.
-- In that case, it can be convenient to group these simpler components together into a single "package", which can then be given a meaningful name.
-- In Lean, this is done using _structures_, which are analogous to {c}`struct`s in C or Rust and {CSharp}`record`s in C#.

编写程序的第一步通常是识别问题域的概念，然后在代码中为它们找到合适的表示。
有时，一个域概念是其他更简单概念的集合。
在这种情况下，将这些更简单的组件组合到一个单独的"包"中会很方便，然后可以为其赋予有意义的名称。
在 Lean 中，这是通过 __结构（Structure）__ 来完成的，它类似于 C 或 Rust 中的 {c}`struct` 和 C# 中的 {CSharp}`record`。

-- Defining a structure introduces a completely new type to Lean that can't be reduced to any other type.
-- This is useful because multiple structures might represent different concepts that nonetheless contain the same data.
-- For instance, a point might be represented using either Cartesian or polar coordinates, each being a pair of floating-point numbers.
-- Defining separate structures prevents API clients from confusing one for another.

定义结构会向 Lean 引入一个全新的类型，该类型不能化简为任何其他类型。
这很有用，因为多个结构可能表示不同的概念，但包含相同的数据。
例如，一个点可以用笛卡尔坐标或极坐标表示，每个坐标都是一对浮点数。
定义单独的结构可以防止 API 客户端将一个结构与另一个结构混淆。

-- Lean's floating-point number type is called {anchorName zeroFloat}`Float`, and floating-point numbers are written in the usual notation.
Lean 的浮点数类型称为 {anchorName zeroFloat}`Float`，浮点数以通常的记法编写。

```anchorTerm onePointTwo
#check 1.2
```

```anchorInfo onePointTwo
1.2 : Float
```

```anchorTerm negativeLots
#check -454.2123215
```

```anchorInfo negativeLots
-454.2123215 : Float
```

```anchorTerm zeroPointZero
#check 0.0
```

```anchorInfo zeroPointZero
0.0 : Float
```

-- When floating point numbers are written with the decimal point, Lean will infer the type {anchorName zeroFloat}`Float`. If they are written without it, then a type annotation may be necessary.
当浮点数以小数点形式编写时，Lean 会推断类型为 {anchorName zeroFloat}`Float`。如果没有小数点，则可能需要类型注解。

```anchorTerm zeroNat
#check 0
```

```anchorInfo zeroNat
0 : Nat
```

```anchorTerm zeroFloat
#check (0 : Float)
```

```anchorInfo zeroFloat
0 : Float
```

-- A Cartesian point is a structure with two {anchorName zeroFloat}`Float` fields, called {anchorName Point}`x` and {anchorName Point}`y`.
-- This is declared using the {kw}`structure` keyword.
笛卡尔点是一个具有两个 {anchorName zeroFloat}`Float` 字段的结构，分别称为 {anchorName Point}`x` 和 {anchorName Point}`y`。
这使用 {kw}`structure` 关键字声明。

```anchor Point
structure Point where
  x : Float
  y : Float
deriving Repr
```

-- After this declaration, {anchorName Point}`Point` is a new structure type.
-- The final line, which says {anchorTerm Point}`deriving Repr`, asks Lean to generate code to display values of type {anchorName Point}`Point`.
-- This code is used by {kw}`#eval` to render the result of evaluation for consumption by programmers, analogous to the {python}`repr` function in Python.
-- It is also possible to override the compiler's generated display code.

在此声明之后，{anchorName Point}`Point` 是一个新的结构类型。
最后一行，即 {anchorTerm Point}`deriving Repr`，要求 Lean 生成代码来显示 {anchorName Point}`Point` 类型的值。
此代码由 {kw}`#eval` 使用来渲染求值结果供程序员使用，类似于 Python 中的 {python}`repr` 函数。
也可以覆盖编译器生成的显示代码。

-- The typical way to create a value of a structure type is to provide values for all of its fields inside of curly braces.
-- The origin of a Cartesian plane is where {anchorName Point}`x` and {anchorName Point}`y` are both zero:
创建结构类型值的典型方法是在花括号内为其所有字段提供值。
笛卡尔平面的原点是 {anchorName Point}`x` 和 {anchorName Point}`y` 都为零的地方：

```anchor origin
def origin : Point := { x := 0.0, y := 0.0 }
```

-- The result of {anchorTerm originEval}`#eval origin` looks very much like the definition of {anchorName origin}`origin`.
{anchorTerm originEval}`#eval origin` 的结果看起来很像 {anchorName origin}`origin` 的定义。

```anchorInfo originEval
{ x := 0.000000, y := 0.000000 }
```

-- Because structures exist to "bundle up" a collection of data, naming it and treating it as a single unit, it is also important to be able to extract the individual fields of a structure.
-- This is done using dot notation, as in C, Python, Rust, or JavaScript.
因为结构的存在是为了"打包"数据集合，为其命名并将其作为单个单元处理，所以能够提取结构的各个字段也很重要。
这使用点符号完成，就像在 C、Python、Rust 或 JavaScript 中一样。

```anchorTerm originx
#eval origin.x
```

```anchorInfo originx
0.000000
```

```anchorTerm originy
#eval origin.y
```

```anchorInfo originy
0.000000
```

:::paragraph
-- This can be used to define functions that take structures as arguments.
-- For instance, addition of points is performed by adding the underlying coordinate values.
-- It should be the case that

这可以用来定义接受结构作为参数的函数。
例如，点的加法是通过添加底层坐标值来执行的。
应该是这样的情况：

```anchorTerm addPointsEx
#eval addPoints { x := 1.5, y := 32 } { x := -8, y := 0.2 }
```

-- yields
产生

```anchorInfo addPointsEx
{ x := -6.500000, y := 32.200000 }
```
:::

-- The function itself takes two {anchorName Point}`Point`s as arguments, called {anchorName addPoints}`p1` and {anchorName addPoints}`p2`.
-- The resulting point is based on the {anchorName addPoints}`x` and {anchorName addPoints}`y` fields of both {anchorName addPoints}`p1` and {anchorName addPoints}`p2`:
函数本身接受两个 {anchorName Point}`Point` 作为参数，分别称为 {anchorName addPoints}`p1` 和 {anchorName addPoints}`p2`。
结果点基于 {anchorName addPoints}`p1` 和 {anchorName addPoints}`p2` 的 {anchorName addPoints}`x` 和 {anchorName addPoints}`y` 字段：

```anchor addPoints
def addPoints (p1 : Point) (p2 : Point) : Point :=
  { x := p1.x + p2.x, y := p1.y + p2.y }
```

-- Similarly, the distance between two points, which is the square root of the sum of the squares of the differences in their {anchorName Point}`x` and {anchorName Point}`y` components, can be written:
类似地，两点之间的距离，即它们的 {anchorName Point}`x` 和 {anchorName Point}`y` 组件差值的平方和的平方根，可以写成：

```anchor distance
def distance (p1 : Point) (p2 : Point) : Float :=
  Float.sqrt (((p2.x - p1.x) ^ 2.0) + ((p2.y - p1.y) ^ 2.0))
```

-- For example, the distance between $`(1, 2)` and $`(5, -1)` is $`5`:
例如，$`(1, 2)` 和 $`(5, -1)` 之间的距离是 $`5`：

```anchorTerm evalDistance
#eval distance { x := 1.0, y := 2.0 } { x := 5.0, y := -1.0 }
```

```anchorInfo evalDistance
5.000000
```

-- Multiple structures may have fields with the same names.
-- A three-dimensional point datatype may share the fields {anchorName Point3D}`x` and {anchorName Point3D}`y`, and be instantiated with the same field names:
多个结构可能具有相同名称的字段。
三维点数据类型可以共享字段 {anchorName Point3D}`x` 和 {anchorName Point3D}`y`，并用相同的字段名实例化：

```anchor Point3D
structure Point3D where
  x : Float
  y : Float
  z : Float
deriving Repr
```

```anchor origin3D
def origin3D : Point3D := { x := 0.0, y := 0.0, z := 0.0 }
```

-- This means that the structure's expected type must be known in order to use the curly-brace syntax.
-- If the type is not known, Lean will not be able to instantiate the structure.
-- For example,
这意味着必须知道结构的预期类型才能使用花括号语法。
如果类型未知，Lean 将无法实例化结构。
例如，

```anchorTerm originNoType
#check { x := 0.0, y := 0.0 }
```

-- leads to the error
会导致错误

```anchorError originNoType
invalid {...} notation, expected type is not known
```

-- As usual, the situation can be remedied by providing a type annotation.
通常，可以通过提供类型注解来解决这种情况。

```anchorTerm originWithAnnot
#check ({ x := 0.0, y := 0.0 } : Point)
```

```anchorInfo originWithAnnot
{ x := 0.0, y := 0.0 } : Point
```

-- To make programs more concise, Lean also allows the structure type annotation inside the curly braces.
为了使程序更简洁，Lean 还允许在花括号内进行结构类型注解。

```anchorTerm originWithAnnot2
#check { x := 0.0, y := 0.0 : Point}
```

```anchorInfo originWithAnnot2
{ x := 0.0, y := 0.0 } : Point
```

## 更新结构
-- # Updating Structures

-- Imagine a function {anchorName zeroXBad}`zeroX` that replaces the {anchorName zeroXBad}`x` field of a {anchorName zeroXBad}`Point` with {anchorTerm zeroX}`0`.
-- In most programming language communities, this sentence would mean that the memory location pointed to by {anchorName Point}`x` was to be overwritten with a new value.
-- However, Lean is a functional programming language.
-- In functional programming communities, what is almost always meant by this kind of statement is that a fresh {anchorName Point}`Point` is allocated with the {anchorName Point}`x` field pointing to the new value, and all other fields pointing to the original values from the input.
-- One way to write {anchorName zeroXBad}`zeroX` is to follow this description literally, filling out the new value for {anchorName Point}`x` and manually transferring {anchorName Point}`y`:
想象一个函数 {anchorName zeroXBad}`zeroX`，它将 {anchorName zeroXBad}`Point` 的 {anchorName zeroXBad}`x` 字段替换为 {anchorTerm zeroX}`0`。
在大多数编程语言社区中，这句话意味着 {anchorName Point}`x` 指向的内存位置要被新值覆盖。
然而，Lean 是一种函数式编程语言。
在函数式编程社区中，这种陈述几乎总是意味着分配一个新的 {anchorName Point}`Point`，其中 {anchorName Point}`x` 字段指向新值，所有其他字段指向输入的原始值。
编写 {anchorName zeroXBad}`zeroX` 的一种方法是按字面意思遵循此描述，填写 {anchorName Point}`x` 的新值并手动传输 {anchorName Point}`y`：

```anchor zeroXBad
def zeroX (p : Point) : Point :=
  { x := 0, y := p.y }
```

-- This style of programming has drawbacks, however.
-- First off, if a new field is added to a structure, then every site that updates any field at all must be updated, causing maintenance difficulties.
-- Secondly, if the structure contains multiple fields with the same type, then there is a real risk of copy-paste coding leading to field contents being duplicated or switched.
-- Finally, the program becomes long and bureaucratic.
然而，这种编程风格有缺点。
首先，如果向结构添加新字段，那么所有更新任何字段的位置都必须更新，这会导致维护困难。
其次，如果结构包含多个相同类型的字段，那么复制粘贴编码会导致字段内容重复或交换的真正风险。
最后，程序变得冗长且官僚化。

-- Lean provides a convenient syntax for replacing some fields in a structure while leaving the others alone.
-- This is done by using the {kw}`with` keyword in a structure initialization.
-- The source of unchanged fields occurs before the {kw}`with`, and the new fields occur after.
-- For example, {anchorName zeroX}`zeroX` can be written with only the new {anchorName Point}`x` value:
Lean 提供了一种方便的语法来替换结构中的某些字段，同时保持其他字段不变。
这通过在结构初始化中使用 {kw}`with` 关键字来完成。
未更改字段的来源出现在 {kw}`with` 之前，新字段出现在之后。
例如，{anchorName zeroX}`zeroX` 可以只用新的 {anchorName Point}`x` 值编写：

```anchor zeroX
def zeroX (p : Point) : Point :=
  { p with x := 0 }
```

-- Remember that this structure update syntax does not modify existing values—it creates new values that share some fields with old values.
-- Given the point {anchorName fourAndThree}`fourAndThree`:
请记住，此结构更新语法不会修改现有值——它创建与旧值共享某些字段的新值。
给定点 {anchorName fourAndThree}`fourAndThree`：

```anchor fourAndThree
def fourAndThree : Point :=
  { x := 4.3, y := 3.4 }
```

-- evaluating it, then evaluating an update of it using {anchorName zeroX}`zeroX`, then evaluating it again yields the original value:
计算它，然后使用 {anchorName zeroX}`zeroX` 计算它的更新，然后再次计算它会产生原始值：

```anchorTerm fourAndThreeEval
#eval fourAndThree
```

```anchorInfo fourAndThreeEval
{ x := 4.300000, y := 3.400000 }
```

```anchorTerm zeroXFourAndThreeEval
#eval zeroX fourAndThree
```

```anchorInfo zeroXFourAndThreeEval
{ x := 0.000000, y := 3.400000 }
```

```anchorTerm fourAndThreeEval
#eval fourAndThree
```

```anchorInfo fourAndThreeEval
{ x := 4.300000, y := 3.400000 }
```

-- One consequence of the fact that structure updates do not modify the original structure is that it becomes easier to reason about cases where the new value is computed from the old one.
-- All references to the old structure continue to refer to the same field values in all of the new values provided.
结构更新不修改原始结构这一事实的一个后果是，更容易推理从旧值计算新值的情况。
对旧结构的所有引用继续引用所有提供的新值中的相同字段值。

## 幕后原理
-- # Behind the Scenes
%%%
tag := "behind-the-scenes"
%%%

-- Every structure has a _constructor_.
-- Here, the term "constructor" may be a source of confusion.
-- Unlike constructors in languages such as Java or Python, constructors in Lean are not arbitrary code to be run when a datatype is initialized.
-- Instead, constructors simply gather the data to be stored in the newly-allocated data structure.
-- It is not possible to provide a custom constructor that pre-processes data or rejects invalid arguments.
-- This is really a case of the word "constructor" having different, but related, meanings in the two contexts.
每个结构都有一个__构造器__。
这里，术语"构造器"可能是混淆的来源。
与 Java 或 Python 等语言中的构造器不同，Lean 中的构造器不是在数据类型初始化时运行的任意代码。
相反，构造器只是收集要存储在新分配的数据结构中的数据。
不可能提供预处理数据或拒绝无效参数的自定义构造器。
这实际上是"构造器"这个词在两种上下文中具有不同但相关含义的情况。

-- By default, the constructor for a structure named {lit}`S` is named {lit}`S.mk`.
-- Here, {lit}`S` is a namespace qualifier, and {lit}`mk` is the name of the constructor itself.
-- Instead of using curly-brace initialization syntax, the constructor can also be applied directly.
默认情况下，名为 {lit}`S` 的结构的构造器命名为 {lit}`S.mk`。
这里，{lit}`S` 是命名空间限定符，{lit}`mk` 是构造器本身的名称。
除了使用花括号初始化语法外，构造器也可以直接应用。

```anchorTerm checkPointMk
#check Point.mk 1.5 2.8
```

-- However, this is not generally considered to be good Lean style, and Lean even returns its feedback using the standard structure initializer syntax.
然而，这通常不被认为是好的 Lean 风格，Lean 甚至使用标准结构初始化器语法返回其反馈。

```anchorInfo checkPointMk
{ x := 1.5, y := 2.8 } : Point
```

-- Constructors have function types, which means they can be used anywhere that a function is expected.
-- For instance, {anchorName Pointmk}`Point.mk` is a function that accepts two {anchorName Point}`Float`s (respectively {anchorName Point}`x` and {anchorName Point}`y`) and returns a new {anchorName Point}`Point`.
构造器具有函数类型，这意味着它们可以在期望函数的任何地方使用。
例如，{anchorName Pointmk}`Point.mk` 是一个接受两个 {anchorName Point}`Float`（分别为 {anchorName Point}`x` 和 {anchorName Point}`y`）并返回新 {anchorName Point}`Point` 的函数。

```anchorTerm Pointmk
#check (Point.mk)
```

```anchorInfo Pointmk
Point.mk : Float → Float → Point
```

-- To override a structure's constructor name, write it with two colons at the beginning.
-- For instance, to use {anchorName PointCtorNameName}`Point.point` instead of {anchorName Pointmk}`Point.mk`, write:
要覆盖结构的构造器名称，请在开头用两个冒号编写。
例如，要使用 {anchorName PointCtorNameName}`Point.point` 而不是 {anchorName Pointmk}`Point.mk`，请写：

```anchor PointCtorName
structure Point where
  point ::
  x : Float
  y : Float
deriving Repr
```

-- In addition to the constructor, an accessor function is defined for each field of a structure.
-- These have the same name as the field, in the structure's namespace.
-- For {anchorName Point}`Point`, accessor functions {anchorName Pointx}`Point.x` and {anchorName Pointy}`Point.y` are generated.
除了构造器外，还为结构的每个字段定义了访问器函数。
这些函数与字段同名，在结构的命名空间中。
对于 {anchorName Point}`Point`，生成访问器函数 {anchorName Pointx}`Point.x` 和 {anchorName Pointy}`Point.y`。

```anchorTerm Pointx
#check (Point.x)
```

```anchorInfo Pointx
Point.x : Point → Float
```

```anchorTerm Pointy
#check (Point.y)
```

```anchorInfo Pointy
Point.y : Point → Float
```

-- In fact, just as the curly-braced structure construction syntax is converted to a call to the structure's constructor behind the scenes, the syntax {anchorName addPoints}`x` in the prior definition of {anchorName addPoints}`addPoints` is converted into a call to the {anchorName addPoints}`x` accessor.
-- That is, {anchorTerm originx}`#eval origin.x` and {anchorTerm originx1}`#eval Point.x origin` both yield
实际上，正如花括号结构构造语法在幕后被转换为对结构构造器的调用一样，在 {anchorName addPoints}`addPoints` 的先前定义中的语法 {anchorName addPoints}`x` 被转换为对 {anchorName addPoints}`x` 访问器的调用。
也就是说，{anchorTerm originx}`#eval origin.x` 和 {anchorTerm originx1}`#eval Point.x origin` 都产生

```anchorInfo originx1
0.000000
```

-- Accessor dot notation is usable with more than just structure fields.
-- It can also be used for functions that take any number of arguments.
-- More generally, accessor notation has the form {lit}`TARGET.f ARG1 ARG2 ...`.
-- If {lit}`TARGET` has type {lit}`T`, the function named {lit}`T.f` is called.
-- {lit}`TARGET` becomes its leftmost argument of type {lit}`T`, which is often but not always the first one, and {lit}`ARG1 ARG2 ...` are provided in order as the remaining arguments.
-- For instance, {anchorName stringAppend}`String.append` can be invoked from a string with accessor notation, even though {anchorName Inline}`String` is not a structure with an {anchorName stringAppendDot}`append` field.
访问器点符号不仅可用于结构字段。
它也可以用于接受任意数量参数的函数。
更一般地，访问器记法具有形式 {lit}`TARGET.f ARG1 ARG2 ...`。
如果 {lit}`TARGET` 具有类型 {lit}`T`，则调用名为 {lit}`T.f` 的函数。
{lit}`TARGET` 成为其最左边的 {lit}`T` 类型参数，这通常但不总是第一个参数，{lit}`ARG1 ARG2 ...` 按顺序作为其余参数提供。
例如，{anchorName stringAppend}`String.append` 可以使用访问器记法从字符串调用，尽管 {anchorName Inline}`String` 不是具有 {anchorName stringAppendDot}`append` 字段的结构。

```anchorTerm stringAppendDot
#eval "one string".append " and another"
```

```anchorInfo stringAppendDot
"one string and another"
```

-- In that example, {lit}`TARGET` represents {anchorTerm stringAppendDot}`"one string"` and {lit}`ARG1` represents {anchorTerm stringAppendDot}`" and another"`.
在该示例中，{lit}`TARGET` 表示 {anchorTerm stringAppendDot}`"one string"`，{lit}`ARG1` 表示 {anchorTerm stringAppendDot}`" and another"`。

-- The function {anchorName modifyBoth}`Point.modifyBoth` (that is, {anchorName modifyBothTest}`modifyBoth` defined in the {lit}`Point` namespace) applies a function to both fields in a {anchorName Point}`Point`:
函数 {anchorName modifyBoth}`Point.modifyBoth`（即在 {lit}`Point` 命名空间中定义的 {anchorName modifyBothTest}`modifyBoth`）将函数应用于 {anchorName Point}`Point` 中的两个字段：

```anchor modifyBoth
def Point.modifyBoth (f : Float → Float) (p : Point) : Point :=
  { x := f p.x, y := f p.y }
```

-- Even though the {anchorName Point}`Point` argument comes after the function argument, it can be used with dot notation as well:
即使 {anchorName Point}`Point` 参数在函数参数之后，它也可以与点符号一起使用：

```anchorTerm modifyBothTest
#eval fourAndThree.modifyBoth Float.floor
```

```anchorInfo modifyBothTest
{ x := 4.000000, y := 3.000000 }
```

-- In this case, {lit}`TARGET` represents {anchorName fourAndThree}`fourAndThree`, while {lit}`ARG1` is {anchorName modifyBothTest}`Float.floor`.
-- This is because the target of the accessor notation is used as the first argument in which the type matches, not necessarily the first argument.
在这种情况下，{lit}`TARGET` 表示 {anchorName fourAndThree}`fourAndThree`，而 {lit}`ARG1` 是 {anchorName modifyBothTest}`Float.floor`。
这是因为访问器记法的目标用作类型匹配的第一个参数，不一定是第一个参数。

## 练习
-- # Exercises

-- * Define a structure named {anchorName RectangularPrism}`RectangularPrism` that contains the height, width, and depth of a rectangular prism, each as a {anchorName RectangularPrism}`Float`.
-- * Define a function named {anchorTerm RectangularPrism}`volume : RectangularPrism → Float` that computes the volume of a rectangular prism.
-- * Define a structure named {anchorName RectangularPrism}`Segment` that represents a line segment by its endpoints, and define a function {lit}`length : Segment → Float` that computes the length of a line segment. {anchorName RectangularPrism}`Segment` should have at most two fields.
-- * Which names are introduced by the declaration of {anchorName RectangularPrism}`RectangularPrism`?
-- * Which names are introduced by the following declarations of {anchorName Hamster}`Hamster` and {anchorName Book}`Book`? What are their types?

* 定义一个名为 {anchorName RectangularPrism}`RectangularPrism` 的结构，包含长方体的高度、宽度和深度，每个都是 {anchorName RectangularPrism}`Float`。
* 定义一个名为 {anchorTerm RectangularPrism}`volume : RectangularPrism → Float` 的函数，计算长方体的体积。
* 定义一个名为 {anchorName RectangularPrism}`Segment` 的结构，通过其端点表示线段，并定义一个函数 {lit}`length : Segment → Float` 来计算线段的长度。{anchorName RectangularPrism}`Segment` 最多应该有两个字段。
* {anchorName RectangularPrism}`RectangularPrism` 的声明引入了哪些名称？
* 以下 {anchorName Hamster}`Hamster` 和 {anchorName Book}`Book` 的声明引入了哪些名称？它们的类型是什么？

    ```anchor Hamster
    structure Hamster where
      name : String
      fluffy : Bool
    ```

    ```anchor Book
    structure Book where
      makeBook ::
      title : String
      author : String
      price : Float
    ```
