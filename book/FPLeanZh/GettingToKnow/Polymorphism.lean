import VersoManual
import FPLeanZh.Examples

open Verso.Genre Manual
open Verso Code External

open FPLeanZh

set_option verso.exampleProject "../examples"
set_option verso.exampleModule "Examples.Intro"

#doc (Manual) "多态性" =>
-- "Polymorphism"
%%%
tag := "polymorphism"
%%%

-- Just as in most languages, types in Lean can take arguments.
-- For instance, the type {anchorTerm fragments}`List Nat` describes lists of natural numbers, {anchorTerm fragments}`List String` describes lists of strings, and {anchorTerm fragments}`List (List Point)` describes lists of lists of points.
-- This is very similar to {CSharp}`List<Nat>`, {CSharp}`List<String>`, or {CSharp}`List<List<Point>>` in a language like C# or Java.
-- Just as Lean uses a space to pass an argument to a function, it uses a space to pass an argument to a type.

就像大多数语言一样，Lean 中的类型可以接受参数。
例如，类型 {anchorTerm fragments}`List Nat` 描述自然数列表，{anchorTerm fragments}`List String` 描述字符串列表，{anchorTerm fragments}`List (List Point)` 描述点列表的列表。
这与 C# 或 Java 等语言中的 {CSharp}`List<Nat>`、{CSharp}`List<String>` 或 {CSharp}`List<List<Point>>` 非常相似。
正如 Lean 使用空格向函数传递参数一样，它使用空格向类型传递参数。

-- In functional programming, the term _polymorphism_ typically refers to datatypes and definitions that take types as arguments.
-- This is different from the object-oriented programming community, where the term typically refers to subclasses that may override some behavior of their superclass.
-- In this book, “polymorphism” always refers to the first sense of the word.
-- These type arguments can be used in the datatype or definition, which allows the same datatype or definition to be used with any type that results from replacing the arguments' names with some other types.

在函数式编程中，术语 *多态性（Polymorphism）* 通常指接受类型作为参数的数据类型和定义。
这与面向对象编程社区不同，在那里这个术语通常指可能覆盖其超类某些行为的子类。
在本书中，“多态性”始终指该词的第一种含义。
这些类型参数可以在数据类型或定义中使用，这允许相同的数据类型或定义与通过用其他类型替换参数名称而产生的任何类型一起使用。

:::paragraph
-- The {anchorName Point}`Point` structure requires that both the {anchorName Point}`x` and {anchorName Point}`y` fields are {anchorName Point}`Float`s.
-- There is, however, nothing about points that require a specific representation for each coordinate.
-- A polymorphic version of {anchorName Point}`Point`, called {anchorName PPoint}`PPoint`, can take a type as an argument, and then use that type for both fields:

{anchorName Point}`Point` 结构体要求 {anchorName Point}`x` 和 {anchorName Point}`y` 字段都是 {anchorName Point}`Float`。
然而，关于点没有什么需要为每个坐标使用特定表示的要求。
{anchorName Point}`Point` 的多态版本，称为 {anchorName PPoint}`PPoint`，可以接受一个类型作为参数，然后将该类型用于两个字段：

```anchor PPoint
structure PPoint (α : Type) where
  x : α
  y : α
deriving Repr
```

:::

-- Just as a function definition's arguments are written immediately after the name being defined, a structure's arguments are written immediately after the structure's name.
-- It is customary to use Greek letters to name type arguments in Lean when no more specific name suggests itself.
-- {anchorTerm PPoint}`Type` is a type that describes other types, so {anchorName Nat}`Nat`, {anchorTerm fragments}`List String`, and {anchorTerm fragments}`PPoint Int` all have type {anchorTerm PPoint}`Type`.

就像函数定义的参数紧跟在被定义的名称之后一样，结构的参数紧跟在结构名称之后。
在 Lean 中，当没有更具体的名称时，习惯上使用希腊字母来命名类型参数。
{anchorTerm PPoint}`Type` 是一个描述其他类型的类型，所以 {anchorName Nat}`Nat`、{anchorTerm fragments}`List String` 和 {anchorTerm fragments}`PPoint Int` 都具有类型 {anchorTerm PPoint}`Type`。

:::paragraph
-- Just like {anchorName fragments}`List`, {anchorName PPoint}`PPoint` can be used by providing a specific type as its argument:

就像 {anchorName fragments}`List` 一样，{anchorName PPoint}`PPoint` 可以通过提供特定类型作为其参数来使用：

```anchor natPoint
def natOrigin : PPoint Nat :=
  { x := Nat.zero, y := Nat.zero }
```

-- In this example, both fields are expected to be {anchorName natPoint}`Nat`s.
-- Just as a function is called by replacing its argument variables with its argument values, providing {anchorName PPoint}`PPoint` with the type {anchorName fragments}`Nat` as an argument yields a structure in which the fields {anchorName PPoint}`x` and {anchorName PPoint}`y` have the type {anchorName fragments}`Nat`, because the argument name {anchorName PPoint}`α` has been replaced by the argument type {anchorName fragments}`Nat`.
-- Types are ordinary expressions in Lean, so passing arguments to polymorphic types (like {anchorName PPoint}`PPoint`) doesn't require any special syntax.

在这个例子中，两个字段都被期望是 {anchorName natPoint}`Nat`。
正如通过用参数值替换参数变量来调用函数一样，向 {anchorName PPoint}`PPoint` 提供类型 {anchorName fragments}`Nat` 作为参数会产生一个结构，其中字段 {anchorName PPoint}`x` 和 {anchorName PPoint}`y` 具有类型 {anchorName fragments}`Nat`，因为参数名 {anchorName PPoint}`α` 已被参数类型 {anchorName fragments}`Nat` 替换。
类型是 Lean 中的普通表达式，所以将参数传递给多态类型（如 {anchorName PPoint}`PPoint`）不需要任何特殊语法。
:::
:::paragraph
-- Definitions may also take types as arguments, which makes them polymorphic.
-- The function {anchorName replaceX}`replaceX` replaces the {anchorName replaceX}`x` field of a {anchorName replaceX}`PPoint` with a new value.
-- In order to allow {anchorName replaceX}`replaceX` to work with _any_ polymorphic point, it must be polymorphic itself.
-- This is achieved by having its first argument be the type of the point's fields, with later arguments referring back to the first argument's name.

定义也可能接受类型作为参数，这使它们具有多态性。
函数 {anchorName replaceX}`replaceX` 用新值替换 {anchorName replaceX}`PPoint` 的 {anchorName replaceX}`x` 字段。
为了让 {anchorName replaceX}`replaceX` 能够与 *任何* 多态点一起工作，它本身必须是多态的。
这通过将其第一个参数作为点字段的类型来实现，后续参数引用第一个参数的名称。

```anchor replaceX
def replaceX (α : Type) (point : PPoint α) (newX : α) : PPoint α :=
  { point with x := newX }
```

-- In other words, when the types of the arguments {anchorName replaceX}`point` and {anchorName replaceX}`newX` mention {anchorName replaceX}`α`, they are referring to _whichever type was provided as the first argument_.
-- This is similar to the way that function argument names refer to the values that were provided when they occur in the function's body.

换句话说，当参数 {anchorName replaceX}`point` 和 {anchorName replaceX}`newX` 的类型提到 {anchorName replaceX}`α` 时，它们指的是 *作为第一个参数提供的任何类型*。
这类似于函数参数名称在函数体中出现时引用所提供的值的方式。
:::

:::paragraph
-- This can be seen by asking Lean to check the type of {anchorName replaceX}`replaceX`, and then asking it to check the type of {anchorTerm replaceXNatOriginFiveT}`replaceX Nat`.

这可以通过询问 Lean 检查 {anchorName replaceX}`replaceX` 的类型，然后询问它检查 {anchorTerm replaceXNatOriginFiveT}`replaceX Nat` 的类型来看出。

```anchorTerm replaceXT
#check (replaceX)
```

```anchorInfo replaceXT
replaceX : (α : Type) → PPoint α → α → PPoint α
```

-- This function type includes the _name_ of the first argument, and later arguments in the type refer back to this name.
-- Just as the value of a function application is found by replacing the argument name with the provided argument value in the function's body, the type of a function application is found by replacing the argument's name with the provided value in the function's return type.
-- Providing the first argument, {anchorName replaceXNatT}`Nat`, causes all occurrences of {anchorName replaceX}`α` in the remainder of the type to be replaced with {anchorName replaceXNatT}`Nat`:

这个函数类型包括第一个参数的 *名称*，类型中的后续参数引用这个名称。
正如函数应用的值是通过在函数体中用提供的参数值替换参数名称来找到的一样，函数应用的类型是通过在函数返回类型中用提供的值替换参数名称来找到的。
提供第一个参数 {anchorName replaceXNatT}`Nat` 会导致类型其余部分中 {anchorName replaceX}`α` 的所有出现都被替换为 {anchorName replaceXNatT}`Nat`：

```anchorTerm replaceXNatT
#check replaceX Nat
```

```anchorInfo replaceXNatT
replaceX Nat : PPoint Nat → Nat → PPoint Nat
```

-- Because the remaining arguments are not explicitly named, no further substitution occurs as more arguments are provided:

因为其余参数没有明确命名，所以在提供更多参数时不会发生进一步的替换：

```anchorTerm replaceXNatOriginT
#check replaceX Nat natOrigin
```

```anchorInfo replaceXNatOriginT
replaceX Nat natOrigin : Nat → PPoint Nat
```

```anchorTerm replaceXNatOriginFiveT
#check replaceX Nat natOrigin 5
```

```anchorInfo replaceXNatOriginFiveT
replaceX Nat natOrigin 5 : PPoint Nat
```

:::

:::paragraph
-- The fact that the type of the whole function application expression was determined by passing a type as an argument has no bearing on the ability to evaluate it.

通过将类型作为参数传递来确定整个函数应用表达式的类型这一事实对求值能力没有影响。

```anchorTerm replaceXNatOriginFiveV
#eval replaceX Nat natOrigin 5
```

```anchorInfo replaceXNatOriginFiveV
{ x := 5, y := 0 }
```

:::

:::paragraph
-- Polymorphic functions work by taking a named type argument and having later types refer to the argument's name.
-- However, there's nothing special about type arguments that allows them to be named.
-- Given a datatype that represents positive or negative signs:

多态函数通过接受命名类型参数并让后续类型引用参数名称来工作。
然而，类型参数本身没有什么特殊之处允许它们被命名。
给定一个表示正号或负号的数据类型：

```anchor Sign
inductive Sign where
  | pos
  | neg
```

:::

:::paragraph
-- it is possible to write a function whose argument is a sign.
-- If the argument is positive, the function returns a {anchorName posOrNegThree}`Nat`, while if it's negative, it returns an {anchorName posOrNegThree}`Int`:

可以编写一个以符号为参数的函数。
如果参数是正数，函数返回一个 {anchorName posOrNegThree}`Nat`，如果是负数，则返回一个 {anchorName posOrNegThree}`Int`：

```anchor posOrNegThree
def posOrNegThree (s : Sign) :
    match s with | Sign.pos => Nat | Sign.neg => Int :=
  match s with
  | Sign.pos => (3 : Nat)
  | Sign.neg => (-3 : Int)
```

-- Because types are first class and can be computed using the ordinary rules of the Lean language, they can be computed by pattern-matching against a datatype.
-- When Lean is checking this function, it uses the fact that the {kw}`match`-expression in the function's body corresponds to the {kw}`match`-expression in the type to make {anchorName posOrNegThree}`Nat` be the expected type for the {anchorName Sign}`pos` case and to make {anchorName posOrNegThree}`Int` be the expected type for the {anchorName Sign}`neg` case.

因为类型是第一类的，可以使用 Lean 语言的普通规则来计算，所以它们可以通过对数据类型进行模式匹配来计算。
当 Lean 检查这个函数时，它使用函数体中的 {kw}`match` 表达式对应于类型中的 {kw}`match` 表达式这一事实，使 {anchorName posOrNegThree}`Nat` 成为 {anchorName Sign}`pos` 情况的预期类型，使 {anchorName posOrNegThree}`Int` 成为 {anchorName Sign}`neg` 情况的预期类型。

:::

:::paragraph
-- Applying {anchorName posOrNegThree}`posOrNegThree` to {anchorName Sign}`pos` results in the argument name {anchorName posOrNegThree}`s` in both the body of the function and its return type being replaced by {anchorName Sign}`pos`.
-- Evaluation can occur both in the expression and its type:

将 {anchorName posOrNegThree}`posOrNegThree` 应用于 {anchorName Sign}`pos` 会导致函数体和返回类型中的参数名 {anchorName posOrNegThree}`s` 都被替换为 {anchorName Sign}`pos`。
求值可以在表达式及其类型中发生：

```anchorEvalSteps posOrNegThreePos
(posOrNegThree Sign.pos :
 match Sign.pos with | Sign.pos => Nat | Sign.neg => Int)
===>
((match Sign.pos with
  | Sign.pos => (3 : Nat)
  | Sign.neg => (-3 : Int)) :
 match Sign.pos with | Sign.pos => Nat | Sign.neg => Int)
===>
((3 : Nat) : Nat)
===>
3
```

:::

# 链表
-- # Linked Lists

:::paragraph
-- Lean's standard library includes a canonical linked list datatype, called {anchorName fragments}`List`, and special syntax that makes it more convenient to use.
-- Lists are written in square brackets.
-- For instance, a list that contains the prime numbers less than 10 can be written:

Lean 的标准库包含一个规范的链表数据类型，称为 {anchorName fragments}`List`，以及使其更便于使用的特殊语法。
列表用方括号编写。
例如，包含小于 10 的质数的列表可以写成：

```anchor primesUnder10
def primesUnder10 : List Nat := [2, 3, 5, 7]
```

:::

:::paragraph
-- Behind the scenes, {anchorName List}`List` is an inductive datatype, defined like this:

在幕后，{anchorName List}`List` 是一个归纳数据类型，定义如下：

```anchor List
inductive List (α : Type) where
  | nil : List α
  | cons : α → List α → List α
```

-- The actual definition in the standard library is slightly different, because it uses features that have not yet been presented, but it is substantially similar.
-- This definition says that {anchorName List}`List` takes a single type as its argument, just as {anchorName PPoint}`PPoint` did.
-- This type is the type of the entries stored in the list.
-- According to the constructors, a {anchorTerm List}`List α` can be built with either {anchorName List}`nil` or {anchorName List}`cons`.
-- The constructor {anchorName List}`nil` represents empty lists and the constructor {anchorName List}`cons` is used for non-empty lists.
-- The first argument to {anchorName List}`cons` is the head of the list, and the second argument is its tail.
-- A list that contains $`n` entries contains $`n` {anchorName List}`cons` constructors, the last of which has {anchorName List}`nil` as its tail.

标准库中的实际定义略有不同，因为它使用了尚未介绍的功能，但本质上是相似的。
这个定义说 {anchorName List}`List` 接受单个类型作为其参数，就像 {anchorName PPoint}`PPoint` 一样。
这个类型是存储在列表中的条目的类型。
根据构造器，{anchorTerm List}`List α` 可以用 {anchorName List}`nil` 或 {anchorName List}`cons` 构建。
构造器 {anchorName List}`nil` 表示空列表，构造器 {anchorName List}`cons` 用于非空列表。
{anchorName List}`cons` 的第一个参数是列表的头部，第二个参数是它的尾部。
包含 $`n` 个条目的列表包含 $`n` 个 {anchorName List}`cons` 构造器，其中最后一个以 {anchorName List}`nil` 作为其尾部。

:::

:::paragraph
-- The {anchorName primesUnder10}`primesUnder10` example can be written more explicitly by using {anchorName List}`List`'s constructors directly:

{anchorName primesUnder10}`primesUnder10` 示例可以通过直接使用 {anchorName List}`List` 的构造器更明确地编写：

```anchor explicitPrimesUnder10
def explicitPrimesUnder10 : List Nat :=
  List.cons 2 (List.cons 3 (List.cons 5 (List.cons 7 List.nil)))
```

-- These two definitions are completely equivalent, but {anchorName primesUnder10}`primesUnder10` is much easier to read than {anchorName explicitPrimesUnder10}`explicitPrimesUnder10`.

这两个定义完全等价，但 {anchorName primesUnder10}`primesUnder10` 比 {anchorName explicitPrimesUnder10}`explicitPrimesUnder10` 更容易阅读。
:::

:::paragraph
-- Functions that consume {anchorName List}`List`s can be defined in much the same way as functions that consume {anchorName Nat}`Nat`s.
-- Indeed, one way to think of a linked list is as a {anchorName Nat}`Nat` that has an extra data field dangling off each {anchorName Nat}`succ` constructor.
-- From this point of view, computing the length of a list is the process of replacing each {anchorName List}`cons` with a {anchorName Nat}`succ` and the final {anchorName List}`nil` with a {anchorName Nat}`zero`.
-- Just as {anchorName replaceX}`replaceX` took the type of the fields of the point as an argument, {anchorName length1EvalSummary}`length` takes the type of the list's entries.
-- For example, if the list contains strings, then the first argument is {anchorName length1EvalSummary}`String`: {anchorEvalStep length1EvalSummary 0}`length String ["Sourdough", "bread"]`.
-- It should compute like this:

使用 {anchorName List}`List` 的函数可以用与使用 {anchorName Nat}`Nat` 的函数大致相同的方式定义。
实际上，将链表视为每个 {anchorName Nat}`succ` 构造器都悬挂着额外数据字段的 {anchorName Nat}`Nat` 是一种思考方式。
从这个角度来看，计算列表长度的过程就是将每个 {anchorName List}`cons` 替换为 {anchorName Nat}`succ`，将最后的 {anchorName List}`nil` 替换为 {anchorName Nat}`zero`。
正如 {anchorName replaceX}`replaceX` 将点字段的类型作为参数一样，{anchorName length1EvalSummary}`length` 接受列表条目的类型。
例如，如果列表包含字符串，那么第一个参数是 {anchorName length1EvalSummary}`String`：{anchorEvalStep length1EvalSummary 0}`length String ["Sourdough", "bread"]`。
它应该像这样计算：

```anchorEvalSteps length1EvalSummary
length String ["Sourdough", "bread"]
===>
length String (List.cons "Sourdough" (List.cons "bread" List.nil))
===>
Nat.succ (length String (List.cons "bread" List.nil))
===>
Nat.succ (Nat.succ (length String List.nil))
===>
Nat.succ (Nat.succ Nat.zero)
===>
2
```

:::

:::paragraph
-- The definition of {anchorName length1}`length` is both polymorphic (because it takes the list entry type as an argument) and recursive (because it refers to itself).
-- Generally, functions follow the shape of the data: recursive datatypes lead to recursive functions, and polymorphic datatypes lead to polymorphic functions.

{anchorName length1}`length` 的定义既是多态的（因为它将列表条目类型作为参数），也是递归的（因为它引用自身）。
通常，函数遵循数据的形状：递归数据类型导致递归函数，多态数据类型导致多态函数。

```anchor length1
def length (α : Type) (xs : List α) : Nat :=
  match xs with
  | List.nil => Nat.zero
  | List.cons y ys => Nat.succ (length α ys)
```

-- Names such as {lit}`xs` and {lit}`ys` are conventionally used to stand for lists of unknown values.
-- The {lit}`s` in the name indicates that they are plural, so they are pronounced “exes” and “whys” rather than “x s” and “y s”.

诸如 {lit}`xs` 和 {lit}`ys` 之类的名称通常用来表示未知值的列表。
名称中的 {lit}`s` 表示它们是复数，所以它们读作"exes"和"whys"而不是"x s"和"y s"。

:::paragraph
-- To make it easier to read functions on lists, the bracket notation {anchorTerm length2}`[]` can be used to pattern-match against {anchorName List}`nil`, and an infix {anchorTerm length2}`::` can be used in place of {anchorName List}`cons`:

为了更容易阅读列表上的函数，方括号记法 {anchorTerm length2}`[]` 可以用来对 {anchorName List}`nil` 进行模式匹配，中缀 {anchorTerm length2}`::` 可以用来代替 {anchorName List}`cons`：

```anchor length2
def length (α : Type) (xs : List α) : Nat :=
  match xs with
  | [] => 0
  | y :: ys => Nat.succ (length α ys)
```

:::
# 隐式参数
-- # Implicit Arguments

:::paragraph
-- Both {anchorName replaceX}`replaceX` and {anchorName length1}`length` are somewhat bureaucratic to use, because the type argument is typically uniquely determined by the later values.
-- Indeed, in most languages, the compiler is perfectly capable of determining type arguments on its own, and only occasionally needs help from users.
-- This is also the case in Lean.
-- Arguments can be declared _implicit_ by wrapping them in curly braces instead of parentheses when defining a function.
-- For example, a version of {anchorName replaceXImp}`replaceX` with an implicit type argument looks like this:

{anchorName replaceX}`replaceX` 和 {anchorName length1}`length` 使用起来都有些繁琐，因为类型参数通常由后续值唯一确定。
实际上，在大多数语言中，编译器完全能够自行确定类型参数，只是偶尔需要用户的帮助。
Lean 也是如此。
在定义函数时，可以通过将参数包装在花括号而不是圆括号中来声明参数为 *隐式的*。
例如，具有隐式类型参数的 {anchorName replaceXImp}`replaceX` 版本如下所示：

```anchor replaceXImp
def replaceX {α : Type} (point : PPoint α) (newX : α) : PPoint α :=
  { point with x := newX }
```

-- It can be used with {anchorName replaceXImpNat}`natOrigin` without providing {anchorName NatDoubleFour}`Nat` explicitly, because Lean can _infer_ the value of {anchorName replaceXImp}`α` from the later arguments:

它可以与 {anchorName replaceXImpNat}`natOrigin` 一起使用而无需明确提供 {anchorName NatDoubleFour}`Nat`，因为 Lean 可以从后续参数中 *推断* {anchorName replaceXImp}`α` 的值：

```anchor replaceXImpNat
#eval replaceX natOrigin 5
```

```anchorInfo replaceXImpNat
{ x := 5, y := 0 }
```

:::

:::paragraph
-- Similarly, {anchorName lengthImp}`length` can be redefined to take the entry type implicitly:

类似地，{anchorName lengthImp}`length` 可以重新定义为隐式接受条目类型：

```anchor lengthImp
def length {α : Type} (xs : List α) : Nat :=
  match xs with
  | [] => 0
  | y :: ys => Nat.succ (length ys)
```

-- This {anchorName lengthImp}`length` function can be applied directly to {anchorName lengthImpPrimes}`primesUnder10`:

这个 {anchorName lengthImp}`length` 函数可以直接应用于 {anchorName lengthImpPrimes}`primesUnder10`：

```anchor lengthImpPrimes
#eval length primesUnder10
```

```anchorInfo lengthImpPrimes
4
```

:::

:::paragraph
-- In the standard library, Lean calls this function {anchorName lengthExpNat}`List.length`, which means that the dot syntax that is used for structure field access can also be used to find the length of a list:

在标准库中，Lean 将此函数称为 {anchorName lengthExpNat}`List.length`，这意味着用于结构字段访问的点语法也可以用来查找列表的长度：

```anchor lengthDotPrimes
#eval primesUnder10.length
```

```anchorInfo lengthDotPrimes
4
```

:::

:::paragraph
-- Just as C# and Java require type arguments to be provided explicitly from time to time, Lean is not always capable of finding implicit arguments.
-- In these cases, they can be provided using their names.
-- For example, a version of {anchorName lengthExpNat}`List.length` that only works for lists of integers can be specified by setting {anchorTerm lengthExpNat}`α` to {anchorName lengthExpNat}`Int`:

正如 C# 和 Java 有时需要明确提供类型参数一样，Lean 并不总是能够找到隐式参数。
在这些情况下，可以使用它们的名称来提供它们。
例如，只适用于整数列表的 {anchorName lengthExpNat}`List.length` 版本可以通过将 {anchorTerm lengthExpNat}`α` 设置为 {anchorName lengthExpNat}`Int` 来指定：

```anchor lengthExpNat
#check List.length (α := Int)
```

```anchorInfo lengthExpNat
List.length : List Int → Nat
```

-- # More Built-In Datatypes

# 更多内置数据类型

-- In addition to lists, Lean's standard library contains a number of other structures and inductive datatypes that can be used in a variety of contexts.

除了列表之外，Lean 的标准库还包含许多其他结构体和归纳数据类型，可用于各种场景。

-- ## {lit}`Option`
## {lit}`Option` 可空类型

-- Not every list has a first entry—some lists are empty.
-- Many operations on collections may fail to find what they are looking for.
-- For instance, a function that finds the first entry in a list may not find any such entry.
-- It must therefore have a way to signal that there was no first entry.

-- Many languages have a {CSharp}`null` value that represents the absence of a value.
-- Instead of equipping existing types with a special {CSharp}`null` value, Lean provides a datatype called {anchorName Option}`Option` that equips some other type with an indicator for missing values.
-- For instance, a nullable {anchorName fragments}`Int` is represented by {anchorTerm nullOne}`Option Int`, and a nullable list of strings is represented by the type {anchorTerm fragments}`Option (List String)`.
-- Introducing a new type to represent nullability means that the type system ensures that checks for {CSharp}`null` cannot be forgotten, because an {anchorTerm nullOne}`Option Int` can't be used in a context where an {anchorName nullOne}`Int` is expected.
并非每个列表都有第一个条目，有些列表是空的。许多集合操作可能无法得出它们正在查找的内容。例如，查找列表中第一个条目的函数可能找不到任何此类条目。因此，必须有一种方法来表示没有第一个条目。
许多语言都有一个 {CSharp}`null` 值来表示没有值。Lean 没有为现有类型配备一个特殊的 {CSharp}`null` 值，而是提供了一个名为 {anchorName Option}`Option` 的数据类型，为其他类型配备了一个缺失值指示器。例如，一个可为空的 {anchorName fragments}`Int` 由 {anchorTerm nullOne}`Option Int` 表示，一个可为空的字符串列表由类型 {anchorTerm fragments}`Option (List String)` 表示。引入一个新类型来表示可空性意味着类型系统确保无法忘记对 {CSharp}`null` 的检查，因为 {anchorTerm nullOne}`Option Int` 不能在需要 {anchorName nullOne}`Int` 的上下文中使用。

:::paragraph
-- {anchorName Option}`Option` has two constructors, called {anchorName Option}`some` and {anchorName Option}`none`, that respectively represent the non-null and null versions of the underlying type.
-- The non-null constructor, {anchorName Option}`some`, contains the underlying value, while {anchorName Option}`none` takes no arguments:

{anchorName Option}`Option` 有两个构造器，分别称为 {anchorName Option}`some` 和 {anchorName Option}`none`，分别表示底层类型的非空和空版本。非空构造器 {anchorName Option}`some` 包含基础值，而 {anchorName Option}`none` 不接受任何参数：

```anchor Option
inductive Option (α : Type) : Type where
  | none : Option α
  | some (val : α) : Option α
```

:::

-- The {anchorName Option}`Option` type is very similar to nullable types in languages like C# and Kotlin, but it is not identical.
-- In these languages, if a type (say, {CSharp}`Boolean`) always refers to actual values of the type ({CSharp}`true` and {CSharp}`false`), the type {CSharp}`Boolean?` or {CSharp}`Nullable<Boolean>` additionally admits the {CSharp}`null` value.
-- Tracking this in the type system is very useful: the type checker and other tooling can help programmers remember to check for {CSharp}`null`, and APIs that explicitly describe nullability through type signatures are more informative than ones that don't.
-- However, these nullable types differ from Lean's {anchorName Option}`Option` in one very important way, which is that they don't allow multiple layers of optionality.
-- {anchorTerm nullThree}`Option (Option Int)` can be constructed with {anchorTerm nullOne}`none`, {anchorTerm nullTwo}`some none`, or {anchorTerm nullThree}`some (some 360)`.
-- Kotlin, on the other hand, treats {Kotlin}`T??` as being equivalent to {Kotlin}`T?`.
-- This subtle difference is rarely relevant in practice, but it can matter from time to time.

{anchorName Option}`Option` 类型非常类似于 C# 和 Kotlin 中的可空类型，但并不完全相同。在这些语言中，如果一个类型（例如 {CSharp}`Boolean`）总是引用该类型的实际值（{CSharp}`true` 和 {CSharp}`false`），则类型 {CSharp}`Boolean?` 或 {CSharp}`Nullable<Boolean>` 还额外允许 {CSharp}`null` 值。在类型系统中跟踪这一点非常有用：类型检查器和其他工具可以帮助程序员记住检查 {CSharp}`null`，并且通过类型签名显式描述可空性的 API 比不描述的可空性 API 更有信息量。然而，这些可空类型与 Lean 的 {anchorName Option}`Option` 有一个非常重要的区别，那就是它们不允许多层可空性。{anchorTerm nullThree}`Option (Option Int)` 可以通过 {anchorTerm nullOne}`none`、{anchorTerm nullTwo}`some none` 或 {anchorTerm nullThree}`some (some 360)` 构造。另一方面，Kotlin 将 {Kotlin}`T??` 视为与 {Kotlin}`T?` 等价。这种微妙的差异在实践中很少相关，但有时可能很重要。

:::paragraph
-- To find the first entry in a list, if it exists, use {anchorName headHuh}`List.head?`.
-- The question mark is part of the name, and is not related to the use of question marks to indicate nullable types in C# or Kotlin.
-- In the definition of {anchorName headHuh}`List.head?`, an underscore is used to represent the tail of the list.
-- In patterns, underscores match anything at all, but do not introduce variables to refer to the matched data.
-- Using underscores instead of names is a way to clearly communicate to readers that part of the input is ignored.
要查找列表中的第一个条目（如果存在），使用 {anchorName headHuh}`List.head?`。问号是名称的一部分，与在 C# 或 Kotlin 中使用问号表示可空类型无关。在 {anchorName headHuh}`List.head?` 的定义中，下划线用于表示列表的尾部。在模式匹配中，下划线匹配任何东西，但不会引入变量来引用匹配的数据。使用下划线而不是名称是向读者清楚地传达输入的一部分被忽略的一种方式。

```anchor headHuh
def List.head? {α : Type} (xs : List α) : Option α :=
  match xs with
  | [] => none
  | y :: _ => some y
```

:::

-- A Lean naming convention is to define operations that might fail in groups using the suffixes {lit}`?` for a version that returns an {anchorName Option}`Option`, {lit}`!` for a version that crashes when provided with invalid input, and {lit}`D` for a version that returns a default value when the operation would otherwise fail.
-- Following this pattern, {anchorName fragments}`List.head` requires the caller to provide mathematical evidence that the list is not empty, {anchorName fragments}`List.head?` returns an {anchorName Option}`Option`, {anchorName fragments}`List.head!` crashes the program when passed an empty list, and {anchorName fragments}`List.headD` takes a default value to return in case the list is empty.
-- The question mark and exclamation mark are part of the name, not special syntax, as Lean's naming rules are more liberal than many languages.

Lean 的命名约定是使用后缀 {lit}`?` 定义可能失败的组操作的版本，该版本返回一个 {anchorName Option}`Option`；使用后缀 {lit}`!` 定义版本，当提供无效输入时崩溃；使用后缀 {lit}`D` 定义版本，当操作本应失败时返回默认值。按照这个模式，{anchorName fragments}`List.head` 要求调用者提供数学证据证明列表不为空，{anchorName fragments}`List.head?` 返回一个 {anchorName Option}`Option`，{anchorName fragments}`List.head!` 当传递空列表时崩溃，{anchorName fragments}`List.headD` 接收一个默认值，在列表为空时返回。问号和感叹号是名称的一部分，而不是特殊语法，因为 Lean 的命名规则比许多语言更宽松。

:::paragraph

-- Because {anchorName fragments}`head?` is defined in the {lit}`List` namespace, it can be used with accessor notation:

因为 {anchorName fragments}`head?` 定义在 {lit}`List` 命名空间中，它可以使用访问器表示法：

```anchor headSome
#eval primesUnder10.head?
```

```anchorInfo headSome
some 2
```

-- However, attempting to test it on the empty list leads to two errors:

然而，在空列表上测试它会导致两个错误：

```anchor headNoneBad
#eval [].head?
```

```anchorError headNoneBad
don't know how to synthesize implicit argument 'α'
  @List.nil ?m.41782
context:
⊢ Type ?u.41779
```

```anchorError headNoneBad
don't know how to synthesize implicit argument 'α'
  @_root_.List.head? ?m.41782 []
context:
⊢ Type ?u.41779
```

:::

:::paragraph
-- This is because Lean was unable to fully determine the expression's type.
-- In particular, it could neither find the implicit type argument to {anchorName fragments}`List.head?`, nor the implicit type argument to {anchorName fragments}`List.nil`.
-- In Lean's output, {lit}`?m.XYZ` represents a part of a program that could not be inferred.
-- These unknown parts are called _metavariables_, and they occur in some error messages.
-- In order to evaluate an expression, Lean needs to be able to find its type, and the type was unavailable because the empty list does not have any entries from which the type can be found.
-- Explicitly providing a type allows Lean to proceed:
这是因为 Lean 无法完全确定表达式的类型。特别是，它既找不到 {anchorName fragments}`List.head?` 的隐式类型参数，也找不到 {anchorName fragments}`List.nil` 的隐式类型参数。在 Lean 的输出中，{lit}`?m.XYZ` 表示一个无法推断的部分程序。这些未知部分称为 *元变量*，它们出现在一些错误消息中。为了评估表达式，Lean 需要能够找到它的类型，而类型不可用是因为空列表没有可以从其中找到类型的条目。显式提供类型允许 Lean 继续执行：

```anchor headNone
#eval [].head? (α := Int)
```

```anchorInfo headNone
none
```

-- The type can also be provided with a type annotation:
类型也可以通过类型标注提供：

```anchor headNoneTwo
#eval ([] : List Int).head?
```

```anchorInfo headNoneTwo
none
```

-- The error messages provide a useful clue.
-- Both messages use the _same_ metavariable to describe the missing implicit argument, which means that Lean has determined that the two missing pieces will share a solution, even though it was unable to determine the actual value of the solution.

错误消息提供了一个有用的线索。两个消息都使用 *相同的* 元变量来描述缺失的隐式参数，这意味着 Lean 已经确定两个缺失的部分将共享一个解决方案，即使它无法确定实际值。

:::

## {lit}`Prod` 积类型
-- ## {lit}`Prod`
%%%
tag := "prod"
%%%

-- The {anchorName Prod}`Prod` structure, short for “Product”, is a generic way of joining two values together.
-- For instance, a {anchorTerm fragments}`Prod Nat String` contains a {anchorName fragments}`Nat` and a {anchorName fragments}`String`.
-- In other words, {anchorTerm natPoint}`PPoint Nat` could be replaced by {anchorTerm fragments}`Prod Nat Nat`.
-- {anchorName fragments}`Prod` is very much like C#'s tuples, the {Kotlin}`Pair` and {Kotlin}`Triple` types in Kotlin, and {cpp}`tuple` in C++.
-- Many applications are best served by defining their own structures, even for simple cases like {anchorName Point}`Point`, because using domain terminology can make it easier to read the code.
-- Additionally, defining structure types helps catch more errors by assigning different types to different domain concepts, preventing them from being mixed up.

-- On the other hand, there are some cases where it is not worth the overhead of defining a new type.
-- Additionally, some libraries are sufficiently generic that there is no more specific concept than “pair”.
-- Finally, the standard library contains a variety of convenience functions that make it easier to work with the built-in pair type.

结构体 {anchorName Prod}`Prod` （是“Product”的简称）是一个通用的将两个值连接在一起的方式。例如，{anchorTerm fragments}`Prod Nat String` 包含一个 {anchorName fragments}`Nat` 和一个 {anchorName fragments}`String`。换句话说，{anchorTerm natPoint}`PPoint Nat` 可以被替换为 {anchorTerm fragments}`Prod Nat Nat`。{anchorName fragments}`Prod` 非常类似于 C# 的元组、Kotlin 的 {Kotlin}`Pair` 和 {Kotlin}`Triple` 类型以及 C++ 的 {cpp}`tuple`。许多应用程序最好通过定义自己的结构来实现，即使是简单的案例 {anchorName Point}`Point`，因为使用领域术语可以使代码更易读。此外，定义结构类型通过为不同的领域概念分配不同的类型来捕获更多的错误，防止它们被混淆。另一方面，有些情况下定义新类型的开销不值得，另外一些库已经足够通用，以至于没有比*偶对（Pair）*更具体的概念了。最后，标准库包含许多方便函数，使内置的 Pair 类型更容易使用。

:::paragraph
-- The structure {anchorName Prod}`Prod` is defined with two type arguments:
结构体 {anchorName Prod}`Prod` 使用两个类型参数定义：

```anchor Prod
structure Prod (α : Type) (β : Type) : Type where
  fst : α
  snd : β
```

:::

:::paragraph
-- Lists are used so frequently that there is special syntax to make them more readable.
-- For the same reason, both the product type and its constructor have special syntax.
-- The type {anchorTerm ProdSugar}`Prod α β` is typically written {anchorTerm ProdSugar}`α × β`, mirroring the usual notation for a Cartesian product of sets.
-- Similarly, the usual mathematical notation for pairs is available for {anchorName ProdSugar}`Prod`.
-- In other words, instead of writing:
列表使用非常频繁，因此有特殊的语法使其更易读。出于同样的原因，积类型和其构造器都有特殊的语法。类型 {anchorTerm ProdSugar}`Prod α β` 通常写为 {anchorTerm ProdSugar}`α × β`，模仿集合的笛卡尔积的通常表示法。类似地，{anchorName ProdSugar}`Prod` 可以使用通常的数学表示法表示偶对。换句话说，不必写：

```anchor fivesStruct
def fives : String × Int := { fst := "five", snd := 5 }
```

-- it suffices to write:
只需写：

```anchor fives
def fives : String × Int := ("five", 5)
```

:::

:::paragraph

-- Both notations are right-associative.
-- This means that the following definitions are equivalent:
两种表示法都是右结合的。这意味着以下定义是等价的：

```anchor sevens
def sevens : String × Int × Nat := ("VII", 7, 4 + 3)
```

```anchor sevensNested
def sevens : String × (Int × Nat) := ("VII", (7, 4 + 3))
```

-- In other words, all products of more than two types, and their corresponding constructors, are actually nested products and nested pairs behind the scenes.
换句话说，所有大于两个类型的积类型及其对应的构造器实际上是嵌套的积类型和嵌套的偶对。

:::


-- ## {anchorName Sum}`Sum`
## {anchorName Sum}`Sum` 和类型

-- The {anchorName Sum}`Sum` datatype is a generic way of allowing a choice between values of two different types.
-- For instance, a {anchorTerm fragments}`Sum String Int` is either a {anchorName fragments}`String` or an {anchorName fragments}`Int`.
-- Like {anchorName Prod}`Prod`, {anchorName Sum}`Sum` should be used either when writing very generic code, for a very small section of code where there is no sensible domain-specific type, or when the standard library contains useful functions.
-- In most situations, it is more readable and maintainable to use a custom inductive type.

-- Like {anchorName Prod}`Prod`, {anchorName Sum}`Sum` should be used either when writing very generic code, for a very small section of code where there is no sensible domain-specific type, or when the standard library contains useful functions.
-- In most situations, it is more readable and maintainable to use a custom inductive type.

和类型 {anchorName Sum}`Sum` 是允许在两个不同类型的值之间进行选择的一般方式。例如，{anchorTerm fragments}`Sum String Int` 要么是一个 {anchorName fragments}`String`，要么是一个 {anchorName fragments}`Int`。类似于 {anchorName Prod}`Prod`，当编写非常通用的代码时，在没有任何有意义的领域特定类型的小部分代码中，或者当标准库包含有用函数时，应该使用 {anchorName Sum}`Sum`。在大多数情况下，使用自定义归纳数据类型更可读和更易维护。

正像 {anchorName Prod}`Prod`，当编写非常通用的代码时，在没有任何有意义的领域特定类型的小部分代码中，或者当标准库包含有用函数时，应该使用 {anchorName Sum}`Sum`。在大多数情况下，使用自定义归纳数据类型更可读和更易维护。

:::paragraph
-- Values of type {anchorTerm Sumαβ}`Sum α β` are either the constructor {anchorName Sum}`inl` applied to a value of type {anchorName Sum}`α` or the constructor {anchorName Sum}`inr` applied to a value of type {anchorName Sum}`β`:
类型为 {anchorTerm Sumαβ}`Sum α β` 的值要么是构造器 {anchorName Sum}`inl` 应用于类型为 {anchorName Sum}`α` 的值，要么是构造器 {anchorName Sum}`inr` 应用于类型为 {anchorName Sum}`β` 的值：

```anchor Sum
inductive Sum (α : Type) (β : Type) : Type where
  | inl : α → Sum α β
  | inr : β → Sum α β
```

-- These names are abbreviations for “left injection” and “right injection”, respectively.
-- Just as the Cartesian product notation is used for {anchorName Prod}`Prod`, a “circled plus” notation is used for {anchorName SumSugar}`Sum`, so {anchorTerm SumSugar}`α ⊕ β` is another way to write {anchorTerm SumSugar}`Sum α β`.
-- There is no special syntax for {anchorName FakeSum}`Sum.inl` and {anchorName FakeSum}`Sum.inr`.
这些名字分别是“左注入”（left injection）和“右注入”（right injection）的缩写。正如笛卡尔积表示法用于 {anchorName Prod}`Prod`，“圆加”表示法用于 {anchorName SumSugar}`Sum`，所以 {anchorTerm SumSugar}`α ⊕ β` 是另一种写法 {anchorTerm SumSugar}`Sum α β`。对于 {anchorName FakeSum}`Sum.inl` 和 {anchorName FakeSum}`Sum.inr` 没有特殊的语法。

:::

:::paragraph
-- As an example, if pet names can either be dog names or cat names, then a type for them can be introduced as a sum of strings:
例如，如果宠物名字可以是狗名字或猫名字，那么可以引入一个字符串的和类型：

```anchor PetName
def PetName : Type := String ⊕ String
```

-- In a real program, it would usually be better to define a custom inductive datatype for this purpose with informative constructor names.
-- Here, {anchorName animals}`Sum.inl` is to be used for dog names, and {anchorName animals}`Sum.inr` is to be used for cat names.
-- These constructors can be used to write a list of animal names:
在实际程序中，最好自定义一个归纳数据类型，用于此目的，并使用有意义的构造器名字。这里，{anchorName animals}`Sum.inl` 用于狗名字，{anchorName animals}`Sum.inr` 用于猫名字。这些构造器可以用于编写动物名字的列表：

```anchor animals
def animals : List PetName :=
  [Sum.inl "Spot", Sum.inr "Tiger", Sum.inl "Fifi",
   Sum.inl "Rex", Sum.inr "Floof"]
```

:::

:::paragraph
-- Pattern matching can be used to distinguish between the two constructors.
-- For instance, a function that counts the number of dogs in a list of animal names (that is, the number of {anchorName howManyDogs}`Sum.inl` constructors) looks like this:
模式匹配可以用于区分两个构造器。例如，一个计算动物名字列表中狗数量的函数（即 {anchorName howManyDogs}`Sum.inl` 构造器的数量）看起来像这样：

```anchor howManyDogs
def howManyDogs (pets : List PetName) : Nat :=
  match pets with
  | [] => 0
  | Sum.inl _ :: morePets => howManyDogs morePets + 1
  | Sum.inr _ :: morePets => howManyDogs morePets
```

-- Function calls are evaluated before infix operators, so {anchorTerm howManyDogsAdd}`howManyDogs morePets + 1` is the same as {anchorTerm howManyDogsAdd}`(howManyDogs morePets) + 1`.
-- As expected, {anchor dogCount}`#eval howManyDogs animals` yields {anchorInfo dogCount}`3`.
函数调用在中缀运算符之前求值，所以 {anchorTerm howManyDogsAdd}`howManyDogs morePets + 1` 与 {anchorTerm howManyDogsAdd}`(howManyDogs morePets) + 1` 相同。正如预期的那样，{anchor dogCount}`#eval howManyDogs animals` 得到 {anchorInfo dogCount}`3`。

:::

-- ## {anchorName Unit}`Unit`
## {anchorName Unit}`Unit` 单元类型

:::paragraph
-- {anchorName Unit}`Unit` is a type with just one argumentless constructor, called {anchorName Unit}`unit`.
-- In other words, it describes only a single value, which consists of said constructor applied to no arguments whatsoever.
-- {anchorName Unit}`Unit` is defined as follows:
{anchorName Unit}`Unit` 是一个只有一个无参数构造器的类型，称为 {anchorName Unit}`unit`。换句话说，它只描述一个值，该值由该构造器应用于没有任何参数。{anchorName Unit}`Unit` 定义如下：

```anchor Unit
inductive Unit : Type where
  | unit : Unit
```

:::

:::paragraph
-- On its own, {anchorName Unit}`Unit` is not particularly useful.
-- However, in polymorphic code, it can be used as a placeholder for data that is missing.
-- For instance, the following inductive datatype represents arithmetic expressions:
在自身，{anchorName Unit}`Unit` 并不是特别有用。然而，在多态代码中，它可以用于表示缺失数据的占位符。例如，以下归纳数据类型表示算术表达式：


```anchor ArithExpr
inductive ArithExpr (ann : Type) : Type where
  | int : ann → Int → ArithExpr ann
  | plus : ann → ArithExpr ann → ArithExpr ann → ArithExpr ann
  | minus : ann → ArithExpr ann → ArithExpr ann → ArithExpr ann
  | times : ann → ArithExpr ann → ArithExpr ann → ArithExpr ann
```

-- The type argument {anchorName ArithExpr}`ann` stands for annotations, and each constructor is annotated.
-- Expressions coming from a parser might be annotated with source locations, so a return type of {anchorTerm ArithExprEx}`ArithExpr SourcePos` ensures that the parser put a {anchorName ArithExprEx}`SourcePos` at each subexpression.
-- Expressions that don't come from the parser, however, will not have source locations, so their type can be {anchorTerm ArithExprEx}`ArithExpr Unit`.
类型参数 {anchorName ArithExpr}`ann` 表示标注，每个构造器都标注了。来自解析器的表达式可能带有源位置标注，所以返回类型 {anchorTerm ArithExprEx}`ArithExpr SourcePos` 确保解析器在每个子表达式中放置一个 {anchorName ArithExprEx}`SourcePos`。然而，来自解析器的表达式不会带有源位置，所以它们的类型可以是 {anchorTerm ArithExprEx}`ArithExpr Unit`。

:::

-- Additionally, because all Lean functions have arguments, zero-argument functions in other languages can be represented as functions that take a {anchorName ArithExprEx}`Unit` argument.
-- In a return position, the {anchorName ArithExprEx}`Unit` type is similar to {CSharp}`void` in languages derived from C.
-- In the C family, a function that returns {CSharp}`void` will return control to its caller, but it will not return any interesting value.
-- By being an intentionally uninteresting value, {anchorName ArithExprEx}`Unit` allows this to be expressed without requiring a special-purpose {CSharp}`void` feature in the type system.
-- Unit's constructor can be written as empty parentheses: {anchorTerm unitParens}`() : Unit`.
此外，因为所有 Lean 函数都有参数，其他语言中的零参数函数可以表示为接受 {anchorName ArithExprEx}`Unit` 参数的函数。在返回位置，{anchorName ArithExprEx}`Unit` 类型类似于 C 语言派生语言中的 {CSharp}`void`。在 C 家族中，返回 {CSharp}`void` 的函数将控制权返回给它的调用者，但不会返回任何有趣的价值。通过成为故意无趣的价值，{anchorName ArithExprEx}`Unit` 允许这种情况被表达，而无需在类型系统中要求特殊用途的 {CSharp}`void` 功能。{anchorName ArithExprEx}`Unit` 的构造器可以写为空括号：{anchorTerm unitParens}`() : Unit`。

-- ## {lit}`Empty`
## {lit}`Empty` 空类型

-- The {anchorName fragments}`Empty` datatype has no constructors whatsoever.
-- Thus, it indicates unreachable code, because no series of calls can ever terminate with a value at type {anchorName fragments}`Empty`.

-- {anchorName fragments}`Empty` is not used nearly as often as {anchorName fragments}`Unit`.
-- However, it is useful in some specialized contexts.
-- Many polymorphic datatypes do not use all of their type arguments in all of their constructors.
-- For instance, {anchorName animals}`Sum.inl` and {anchorName animals}`Sum.inr` each use only one of {anchorName fragments}`Sum`'s type arguments.
-- Using {anchorName fragments}`Empty` as one of the type arguments to {anchorName fragments}`Sum` can rule out one of the constructors at a particular point in a program.
-- This can allow generic code to be used in contexts that have additional restrictions.
{anchorName fragments}`Empty` 数据类型没有任何构造子。 因此，它表示不可达代码，因为任何调用序列都无法以 {anchorName fragments}`Empty` 类型的返回值终止。

{anchorName fragments}`Empty` 的使用频率远不及 {anchorName fragments}`Unit`。然而，它在一些特殊情况下很有用。许多多态数据类型并非在其所有构造子中使用其所有类型参数。例如，{anchorName animals}`Sum.inl` 和 {anchorName animals}`Sum.inr` 各自只使用 {anchorName fragments}`Sum` 的一个类型参数。将 {anchorName fragments}`Empty` 用作 {anchorName fragments}`Sum` 的类型参数之一可以在程序的特定点排除一个构造子。这能让我们在具有额外限制的语境中使用泛型代码。

-- ## Naming: Sums, Products, and Units
## 命名：和类型，积类型与单元类型

-- Generally speaking, types that offer multiple constructors are called _sum types_, while types whose single constructor takes multiple arguments are called {deftech}_product types_.
-- These terms are related to sums and products used in ordinary arithmetic.
-- The relationship is easiest to see when the types involved contain a finite number of values.
-- If {anchorName SumProd}`α` and {anchorName SumProd}`β` are types that contain $`n` and $`k` distinct values, respectively, then {anchorTerm SumProd}`α ⊕ β` contains $`n + k` distinct values and {anchorTerm SumProd}`α × β` contains $`n \times k` distinct values.
-- For instance, {anchorName fragments}`Bool` has two values: {anchorName BoolNames}`true` and {anchorName BoolNames}`false`, and {anchorName Unit}`Unit` has one value: {anchorName BooloUnit}`Unit.unit`.
-- The product {anchorTerm fragments}`Bool × Unit` has the two values {anchorTerm BoolxUnit}`(true, Unit.unit)` and {anchorTerm BoolxUnit}`(false, Unit.unit)`, and the sum {anchorTerm fragments}`Bool ⊕ Unit` has the three values {anchorTerm BooloUnit}`Sum.inl true`, {anchorTerm BooloUnit}`Sum.inl false`, and {anchorTerm BooloUnit}`Sum.inr Unit.unit`.
-- Similarly, $`2 \times 1 = 2`, and $`2 + 1 = 3`.

一般来说，提供多个构造器的类型称为*和类型*，而单个构造器接受多个参数的类型称为{deftech}*积类型*。这些术语与普通算术中使用的和与积有关。当涉及的类型包含有限数量的值时，这种关系最容易看到。如果 {anchorName SumProd}`α` 和 {anchorName SumProd}`β` 是分别包含 $`n` 和 $`k` 个不同值的类型，那么 {anchorTerm SumProd}`α ⊕ β` 包含 $`n + k` 个不同值，而 {anchorTerm SumProd}`α × β` 包含 $`n \times k` 个不同值。例如，{anchorName fragments}`Bool` 有两个值：{anchorName BoolNames}`true` 和 {anchorName BoolNames}`false`，而 {anchorName Unit}`Unit` 有一个值：{anchorName BooloUnit}`Unit.unit`。积 {anchorTerm fragments}`Bool × Unit` 有两个值：{anchorTerm BoolxUnit}`(true, Unit.unit)` 和 {anchorTerm BoolxUnit}`(false, Unit.unit)`，而和 {anchorTerm fragments}`Bool ⊕ Unit` 有三个值：{anchorTerm BooloUnit}`Sum.inl true`，{anchorTerm BooloUnit}`Sum.inl false`，和 {anchorTerm BooloUnit}`Sum.inr Unit.unit`。同样，$`2 \times 1 = 2`，和 $`2 + 1 = 3`。

# 你可能遇到的消息
-- # Messages You May Meet

:::
-- Not all definable structures or inductive types can have the type {anchorTerm Prod}`Type`.
-- In particular, if a constructor takes an arbitrary type as an argument, then the inductive type must have a different type.
-- These errors usually state something about “universe levels”.
-- For example, for this inductive type:

并非所有可定义的结构或归纳类型都可以具有类型 {anchorTerm Prod}`Type`。
特别是，如果构造器将任意类型作为参数，那么归纳类型必须具有不同的类型。
这些错误通常会说一些关于"宇宙层级"的内容。
例如，对于这个归纳类型：

```anchor TypeInType
inductive MyType : Type where
  | ctor : (α : Type) → α → MyType
```

-- Lean gives the following error:

Lean 给出以下错误：

```anchorError TypeInType
Invalid universe level in constructor `MyType.ctor`: Parameter `α` has type
  Type
at universe level
  2
which is not less than or equal to the inductive type's resulting universe level
  1
```

-- A later chapter describes why this is the case, and how to modify definitions to make them work.
-- For now, try making the type an argument to the inductive type as a whole, rather than to the constructor.

后面的章节描述了为什么会这样，以及如何修改定义使其工作。
现在，尝试将类型作为整个归纳类型的参数，而不是构造器的参数。
:::

:::
-- Similarly, if a constructor's argument is a function that takes the datatype being defined as an argument, then the definition is rejected.
-- For example:

类似地，如果构造器的参数是一个以正在定义的数据类型为参数的函数，那么定义会被拒绝。
例如：

```anchor Positivity
inductive MyType : Type where
  | ctor : (MyType → Int) → MyType
```

-- yields the message:

产生消息：

```anchorError Positivity
(kernel) arg #1 of 'MyType.ctor' has a non positive occurrence of the datatypes being declared
```

-- For technical reasons, allowing these datatypes could make it possible to undermine Lean's internal logic, making it unsuitable for use as a theorem prover.

出于技术原因，允许这些数据类型可能会破坏 Lean 的内部逻辑，使其不适合用作定理证明器。
:::

:::paragraph
-- Recursive functions that take two parameters should not match against the pair, but rather match each parameter independently.
-- Otherwise, the mechanism in Lean that checks whether recursive calls are made on smaller values is unable to see the connection between the input value and the argument in the recursive call.
-- For example, this function that determines whether two lists have the same length is rejected:

接受两个参数的递归函数不应该对对进行匹配，而应该独立地匹配每个参数。
否则，Lean 中检查递归调用是否在较小值上进行的机制无法看到输入值与递归调用中的参数之间的连接。
例如，这个确定两个列表是否具有相同长度的函数被拒绝：

```anchor sameLengthPair
def sameLength (xs : List α) (ys : List β) : Bool :=
  match (xs, ys) with
  | ([], []) => true
  | (x :: xs', y :: ys') => sameLength xs' ys'
  | _ => false
```

-- The error message is:

错误消息是：

```anchorError sameLengthPair
fail to show termination for
  sameLength
with errors
failed to infer structural recursion:
Not considering parameter α of sameLength:
  it is unchanged in the recursive calls
Not considering parameter β of sameLength:
  it is unchanged in the recursive calls
Cannot use parameter xs:
  failed to eliminate recursive application
    sameLength xs' ys'
Cannot use parameter ys:
  failed to eliminate recursive application
    sameLength xs' ys'


Could not find a decreasing measure.
The basic measures relate at each recursive call as follows:
(<, ≤, =: relation proved, ? all proofs failed, _: no proof attempted)
              xs ys
1) 1760:28-46  ?  ?
Please use `termination_by` to specify a decreasing measure.
```

-- The problem can be fixed through nested pattern matching:

问题可以通过嵌套模式匹配来解决：

```anchor sameLengthOk1
def sameLength (xs : List α) (ys : List β) : Bool :=
  match xs with
  | [] =>
    match ys with
    | [] => true
    | _ => false
  | x :: xs' =>
    match ys with
    | y :: ys' => sameLength xs' ys'
    | _ => false
```

-- {ref "simultaneous-matching"}[Simultaneous matching], described in the next section, is another way to solve the problem that is often more elegant.

下一节描述的{ref "simultaneous-matching"}[同时匹配]是解决问题的另一种方式，通常更优雅。
:::

:::paragraph
-- Forgetting an argument to an inductive type can also yield a confusing message.
-- For example, when the argument {anchorName MissingTypeArg}`α` is not passed to {anchorName MissingTypeArg}`MyType` in {anchorTerm MissingTypeArg}`ctor`'s type:

忘记归纳类型的参数也会产生令人困惑的消息。
例如，当参数 {anchorName MissingTypeArg}`α` 没有在 {anchorTerm MissingTypeArg}`ctor` 的类型中传递给 {anchorName MissingTypeArg}`MyType` 时：

```anchor MissingTypeArg
inductive MyType (α : Type) : Type where
  | ctor : α → MyType
```

-- Lean replies with the following error:

Lean 用以下错误回复：

```anchorError MissingTypeArg
type expected, got
  (MyType : Type → Type)
```

-- The error message is saying that {anchorName MissingTypeArg}`MyType`'s type, which is {anchorTerm MissingTypeArgT}`Type → Type`, does not itself describe types.
-- {anchorName MissingTypeArg}`MyType` requires an argument to become an actual honest-to-goodness type.

错误消息是说 {anchorName MissingTypeArg}`MyType` 的类型，即 {anchorTerm MissingTypeArgT}`Type → Type`，本身并不描述类型。
{anchorName MissingTypeArg}`MyType` 需要一个参数才能成为真正的类型。

:::

:::paragraph
-- The same message can appear when type arguments are omitted in other contexts, such as in a type signature for a definition:

当在其他上下文中省略类型参数时，可能出现相同的消息，比如在定义的类型签名中：

```anchor MyTypeDef
inductive MyType (α : Type) : Type where
  | ctor : α → MyType α
```

```anchor MissingTypeArg2
def ofFive : MyType := ctor 5
```

```anchorError MissingTypeArg2
type expected, got
  (MyType : Type → Type)
```

:::

:::paragraph
-- Evaluating expressions that use polymorphic types may trigger a situation in which Lean is incapable of displaying a value.
-- The {anchorTerm evalAxe}`#eval` command evaluates the provided expression, using the expression's type to determine how to display the result.
-- For some types, such as functions, this process fails, but Lean is perfectly capable of automatically generating display code for most other types.
-- There is no need, for example, to provide Lean with any specific display code for {anchorName WoodSplittingTool}`WoodSplittingTool`:

评估使用多态类型的表达式可能会触发 Lean 无法显示值的情况。
{anchorTerm evalAxe}`#eval` 命令评估提供的表达式，使用表达式的类型来确定如何显示结果。
对于某些类型，例如函数，此过程失败，但 Lean 完全能够自动生成大多数其他类型的显示代码。
例如，不需要为 {anchorName WoodSplittingTool}`WoodSplittingTool` 提供任何特定的显示代码：

```anchor WoodSplittingTool
inductive WoodSplittingTool where
  | axe
  | maul
  | froe
```
```anchor evalAxe
#eval WoodSplittingTool.axe
```
```anchorInfo evalAxe
WoodSplittingTool.axe
```
-- There are limits to the automation that Lean uses here, however.
-- {anchorName allTools}`allTools` is a list of all three tools:

Lean 在这里使用的自动化存在限制。
{anchorName allTools}`allTools` 是所有三个工具的列表：

```anchor allTools
def allTools : List WoodSplittingTool := [
  WoodSplittingTool.axe,
  WoodSplittingTool.maul,
  WoodSplittingTool.froe
]
```
-- Evaluating it leads to an error:

评估它会导致错误：

```anchor evalAllTools
#eval allTools
```
```anchorError evalAllTools
could not synthesize a 'ToExpr', 'Repr', or 'ToString' instance for type
  List WoodSplittingTool
```
-- This is because Lean attempts to use code from a built-in table to display a list, but this code demands that display code for {anchorName WoodSplittingTool}`WoodSplittingTool` already exists.
-- This error can be worked around by instructing Lean to generate this display code when a datatype is defined, instead of at the last moment as part of {anchorTerm evalAllTools}`#eval`, by adding {anchorTerm Firewood}`deriving Repr` to its definition:

这是因为 Lean 试图使用内置表中的代码来显示列表，但此代码要求 {anchorName WoodSplittingTool}`WoodSplittingTool` 的显示代码已经存在。
可以通过指示 Lean 在定义数据类型时生成此显示代码，而不是在 {anchorTerm evalAllTools}`#eval` 的最后时刻作为一部分来解决此错误，方法是向其定义添加 {anchorTerm Firewood}`deriving Repr`：

```anchor Firewood
inductive Firewood where
  | birch
  | pine
  | beech
deriving Repr
```

-- Evaluating a list of {anchorName Firewood}`Firewood` succeeds:

评估 {anchorName Firewood}`Firewood` 列表成功：

```anchor allFirewood
def allFirewood : List Firewood := [
  Firewood.birch,
  Firewood.pine,
  Firewood.beech
]
```
```anchor evalAllFirewood
#eval allFirewood
```
```anchorInfo evalAllFirewood
[Firewood.birch, Firewood.pine, Firewood.beech]
```
:::

-- # Exercises

# 练习

--  * Write a function to find the last entry in a list. It should return an {anchorName fragments}`Option`.
--  * Write a function that finds the first entry in a list that satisfies a given predicate. Start the definition with {anchorTerm List.findFirst?Ex}`def List.findFirst? {α : Type} (xs : List α) (predicate : α → Bool) : Option α := …`.
--  * Write a function {anchorName Prod.switchEx}`Prod.switch` that switches the two fields in a pair for each other. Start the definition with {anchor Prod.switchEx}`def Prod.switch {α β : Type} (pair : α × β) : β × α := …`.
--  * Rewrite the {anchorName PetName}`PetName` example to use a custom datatype and compare it to the version that uses {anchorName Sum}`Sum`.
--  * Write a function {anchorName zipEx}`zip` that combines two lists into a list of pairs. The resulting list should be as long as the shortest input list. Start the definition with {anchor zipEx}`def zip {α β : Type} (xs : List α) (ys : List β) : List (α × β) := …`.
--  * Write a polymorphic function {anchorName takeOne}`take` that returns the first $`n` entries in a list, where $`n` is a {anchorName fragments}`Nat`. If the list contains fewer than $`n` entries, then the resulting list should be the entire input list. {anchorTerm takeThree}`#eval take 3 ["bolete", "oyster"]` should yield {anchorInfo takeThree}`["bolete", "oyster"]`, and {anchor takeOne}`#eval take 1 ["bolete", "oyster"]` should yield {anchorInfo takeOne}`["bolete"]`.
--  * Using the analogy between types and arithmetic, write a function that distributes products over sums. In other words, it should have type {anchorTerm distr}`α × (β ⊕ γ) → (α × β) ⊕ (α × γ)`.
--  * Using the analogy between types and arithmetic, write a function that turns multiplication by two into a sum. In other words, it should have type {anchorTerm distr}`Bool × α → α ⊕ α`.

 * 编写一个函数来查找列表中的最后一个条目。它应该返回一个 {anchorName fragments}`Option`。
 * 编写一个函数，查找列表中满足给定谓词的第一个条目。从 {anchorTerm List.findFirst?Ex}`def List.findFirst? {α : Type} (xs : List α) (predicate : α → Bool) : Option α := …` 开始定义。
 * 编写一个函数 {anchorName Prod.switchEx}`Prod.switch`，它交换偶对中的两个字段。从 {anchor Prod.switchEx}`def Prod.switch {α β : Type} (pair : α × β) : β × α := …` 开始定义。
 * 使用自定义数据类型重写 {anchorName PetName}`PetName` 示例，并将其与使用 {anchorName Sum}`Sum` 的版本进行比较。
 * 编写一个函数 {anchorName zipEx}`zip`，将两个列表合并为一个列表对。结果列表的长度应与最短输入列表的长度相同。从 {anchor zipEx}`def zip {α β : Type} (xs : List α) (ys : List β) : List (α × β) := …` 开始定义。
 * 编写一个多态函数 {anchorName takeOne}`take`，返回列表中的前 $`n` 个条目，其中 $`n` 是一个 {anchorName fragments}`Nat`。如果列表包含少于 $`n` 个条目，则结果列表应为整个输入列表。{anchorTerm takeThree}`#eval take 3 ["bolete", "oyster"]` 应该产生 {anchorInfo takeThree}`["bolete", "oyster"]`，而 {anchor takeOne}`#eval take 1 ["bolete", "oyster"]` 应该产生 {anchorInfo takeOne}`["bolete"]`。
 * 使用类型和算术之间的类比，编写一个函数，将乘法分配到和上。换句话说，它应该具有类型 {anchorTerm distr}`α × (β ⊕ γ) → (α × β) ⊕ (α × γ)`。
 * 使用类型和算术之间的类比，编写一个函数，将乘法分配到和上。换句话说，它应该具有类型 {anchorTerm distr}`Bool × α → α ⊕ α`。
