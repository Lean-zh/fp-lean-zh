import VersoManual
import FPLeanZh.Examples

open Verso.Genre Manual
open Verso Code External

open FPLeanZh

set_option verso.exampleProject "../examples"
set_option verso.exampleModule "Examples.Intro"


#doc (Manual) "Functions and Definitions" =>
%%%
tag := "functions-and-definitions"
%%%

:::paragraph
-- In Lean, definitions are introduced using the {kw}`def` keyword.
-- For instance, to define the name {anchorTerm helloNameVal}`hello` to refer to the string {anchorTerm helloNameVal}`"Hello"`, write:
在 Lean 中，定义使用 {kw}`def` 关键字引入。例如，要定义名称 {anchorTerm helloNameVal}`hello` 来引用字符串 {anchorTerm helloNameVal}`"Hello"`，请编写：

```anchor hello
def hello := "Hello"
```

-- In Lean, new names are defined using the colon-equal operator {anchorTerm hello}`:=` rather than {anchorTerm helloNameVal}`=`.
-- This is because {anchorTerm helloNameVal}`=` is used to describe equalities between existing expressions, and using two different operators helps prevent confusion.
在 Lean 中，新名称使用冒号加等号运算符 {anchorTerm hello}`:=` 而非 {anchorTerm helloNameVal}`=` 定义。这是因为 {anchorTerm helloNameVal}`=` 用于描述现有表达式之间的相等性，而使用两个不同的运算符有助于避免混淆。
:::

:::paragraph
-- In the definition of {anchorTerm helloNameVal}`hello`, the expression {anchorTerm helloNameVal}`"Hello"` is simple enough that Lean is able to determine the definition's type automatically.
-- However, most definitions are not so simple, so it will usually be necessary to add a type.
-- This is done using a colon after the name being defined:
在 {anchorTerm helloNameVal}`hello` 的定义中，表达式 {anchorTerm helloNameVal}`"Hello"` 足够简单，Lean 能够自动确定定义的类型。然而，大多数定义并不那么简单，因此通常需要添加类型。这可以通过在要定义的名称后使用冒号来完成：

```anchor lean
def lean : String := "Lean"
```

:::

:::paragraph
-- Now that the names have been defined, they can be used, so
现在名称已经定义，它们可以使用了，因此

```anchor helloLean
#eval String.append hello (String.append " " lean)
```

-- outputs
输出

```anchorInfo helloLean
"Hello Lean"
```

-- In Lean, defined names may only be used after their definitions.
在 Lean 中，定义的名称只能在其定义之后使用。
:::

-- In many languages, definitions of functions use a different syntax than definitions of other values.
-- For instance, Python function definitions begin with the {kw}`def` keyword, while other definitions are defined with an equals sign.
-- In Lean, functions are defined using the same {kw}`def` keyword as other values.
-- Nonetheless, definitions such as {anchorTerm helloNameVal}`hello` introduce names that refer _directly_ to their values, rather than to zero-argument functions that return equivalent results each time they are called.
在很多语言中，函数定义的语法与其他值的不同。例如，Python 函数定义以 {kw}`def` 关键字开头，而其他定义则以等号定义。在 Lean 中，函数使用与其他值相同的 {kw}`def` 关键字定义。尽管如此，像 {anchorTerm helloNameVal}`hello` 这类的定义引入的名字会 _直接_ 引用其值，而非每次调用一个零参函数返回等价的值。

-- # Defining Functions
# 定义函数
%%%
tag := "defining-functions"
%%%

:::paragraph
-- There are a variety of ways to define functions in Lean. The simplest is to place the function's arguments before the definition's type, separated by spaces. For instance, a function that adds one to its argument can be written:
在 Lean 中有多种方法可以定义函数，最简单的方法是在定义的类型之前放置函数的参数，并用空格分隔。例如，可以编写一个将其参数加 1 的函数：

```anchor add1
def add1 (n : Nat) : Nat := n + 1
```

-- Testing this function with {kw}`#eval` gives {anchorInfo add1_7}`8`, as expected:
使用 {kw}`#eval` 测试此函数会得到 {anchorInfo add1_7}`8`，符合预期：

```anchor add1_7
#eval add1 7
```

:::

:::paragraph
-- Just as functions are applied to multiple arguments by writing spaces between each argument, functions that accept multiple arguments are defined with spaces between the arguments' names and types. The function {anchorName maximum}`maximum`, whose result is equal to the greatest of its two arguments, takes two {anchorName maximum}`Nat` arguments {anchorName Nat}`n` and {anchorName maximum}`k` and returns a {anchorName maximum}`Nat`.
就像将函数应用于多个参数会用空格分隔一样，接受多个参数的函数定义也是在参数名与类型之间加上空格。函数 {anchorName maximum}`maximum` 的结果等于其两个参数中最大的一个，它接受两个 {anchorName maximum}`Nat` 参数 {anchorName Nat}`n` 和 {anchorName maximum}`k`，并返回一个 {anchorName maximum}`Nat`。

```anchor maximum
def maximum (n : Nat) (k : Nat) : Nat :=
  if n < k then
    k
  else n
```

-- Similarly, the function {anchorName spaceBetween}`spaceBetween` joins two strings with a space between them.
类似地，函数 {anchorName spaceBetween}`spaceBetween` 用空格连接两个字符串。

```anchor spaceBetween
def spaceBetween (before : String) (after : String) : String :=
  String.append before (String.append " " after)
```

:::

:::paragraph
-- When a defined function like {anchorName maximum_eval}`maximum` has been provided with its arguments, the result is determined by first replacing the argument names with the provided values in the body, and then evaluating the resulting body. For example:
当向 {anchorName maximum_eval}`maximum` 这样的已定义函数提供参数时，其结果会首先用提供的值替换函数体中对应的参数名称，然后对产生的函数体求值。例如：

```anchorEvalSteps maximum_eval
maximum (5 + 8) (2 * 7)
===>
maximum 13 14
===>
if 13 < 14 then 14 else 13
===>
14
```

:::

-- Expressions that evaluate to natural numbers, integers, and strings have types that say this ({anchorName Nat}`Nat`, {anchorName Positivity}`Int`, and {anchorName Book}`String`, respectively).
-- This is also true of functions.
-- A function that accepts a {anchorName Nat}`Nat` and returns a {anchorName Bool}`Bool` has type {anchorTerm evenFancy}`Nat → Bool`, and a function that accepts two {anchorName Nat}`Nat`s and returns a {anchorName Nat}`Nat` has type {anchorTerm currying}`Nat → Nat → Nat`.
求值为自然数、整数和字符串的表达式具有表明其类型的类型（分别为 {anchorName Nat}`Nat`、{anchorName Positivity}`Int` 和 {anchorName Book}`String`）。函数也是如此。一个接受 {anchorName Nat}`Nat` 并返回 {anchorName Bool}`Bool` 的函数类型为 {anchorTerm evenFancy}`Nat → Bool`，而一个接受两个 {anchorName Nat}`Nat` 并返回一个 {anchorName Nat}`Nat` 的函数类型为 {anchorTerm currying}`Nat → Nat → Nat`。

-- As a special case, Lean returns a function's signature when its name is used directly with {kw}`#check`.
-- Entering {anchorTerm add1sig}`#check add1` yields {anchorInfo add1sig}`add1 (n : Nat) : Nat`.
-- However, Lean can be “tricked” into showing the function's type by writing the function's name in parentheses, which causes the function to be treated as an ordinary expression, so {anchorTerm add1type}`#check (add1)` yields {anchorInfo add1type}`add1 : Nat → Nat` and {anchorTerm maximumType}`#check (maximum)` yields {anchorInfo maximumType}`maximum : Nat → Nat → Nat`.
-- This arrow can also be written with an ASCII alternative arrow {anchorTerm add1typeASCII}`->`, so the preceding function types can be written {anchorTerm add1typeASCII}`example : Nat -> Nat := add1` and {anchorTerm maximumTypeASCII}`example : Nat -> Nat -> Nat := maximum`, respectively.
作为特例，当函数的名称直接与 {kw}`#check` 一起使用时，Lean 会返回函数的签名。输入 {anchorTerm add1sig}`#check add1` 会得到 {anchorInfo add1sig}`add1 (n : Nat) : Nat`。然而，Lean 可以通过将函数名称写在括号中来“欺骗”它显示函数的类型，这会导致函数被视为普通表达式，因此 {anchorTerm add1type}`#check (add1)` 会得到 {anchorInfo add1type}`add1 : Nat → Nat`，而 {anchorTerm maximumType}`#check (maximum)` 会得到 {anchorInfo maximumType}`maximum : Nat → Nat → Nat`。这个箭头也可以用 ASCII 替代箭头 {anchorTerm add1typeASCII}`->` 来写，因此前面的函数类型可以分别写成 {anchorTerm add1typeASCII}`example : Nat -> Nat := add1` 和 {anchorTerm maximumTypeASCII}`example : Nat -> Nat -> Nat := maximum`。

-- Behind the scenes, all functions actually expect precisely one argument.
-- Functions like {anchorName maximum3Type}`maximum` that seem to take more than one argument are in fact functions that take one argument and then return a new function.
-- This new function takes the next argument, and the process continues until no more arguments are expected.
-- This can be seen by providing one argument to a multiple-argument function: {anchorTerm maximum3Type}`#check maximum 3` yields {anchorInfo maximum3Type}`maximum 3 : Nat → Nat` and {anchorTerm stringAppendHelloType}`#check spaceBetween "Hello "` yields {anchorInfo stringAppendHelloType}`spaceBetween "Hello " : String → String`.
-- Using a function that returns a function to implement multiple-argument functions is called _currying_ after the mathematician Haskell Curry.
-- Function arrows associate to the right, which means that {anchorTerm currying}`Nat → Nat → Nat` should be parenthesized {anchorTerm currying}`Nat → (Nat → Nat)`.

在幕后，所有函数实际上都只接受一个参数。像 {anchorName maximum3Type}`maximum` 这样看起来接受多个参数的函数，实际上是接受一个参数然后返回一个新函数。这个新函数接受下一个参数，并且这个过程会一直持续到不再需要更多参数为止。这可以通过向多参数函数提供一个参数来观察：{anchorTerm maximum3Type}`#check maximum 3` 会得到 {anchorInfo maximum3Type}`maximum 3 : Nat → Nat`，而 {anchorTerm stringAppendHelloType}`#check spaceBetween "Hello "` 会得到 {anchorInfo stringAppendHelloType}`spaceBetween "Hello " : String → String`。使用返回函数的函数来实现多参数函数被称为 _柯里化_，以数学家 Haskell Curry 命名。函数箭头是右结合的，这意味着 {anchorTerm currying}`Nat → Nat → Nat` 应该用括号括起来写成 {anchorTerm currying}`Nat → (Nat → Nat)`。

-- ## Exercises
## 练习
%%%
tag := "function-definition-exercises"
%%%

--  * Define the function {anchorName joinStringsWithEx}`joinStringsWith` with type {anchorTerm joinStringsWith}`String → String → String → String` that creates a new string by placing its first argument between its second and third arguments. {anchorEvalStep joinStringsWithEx 0}`joinStringsWith ", " "one" "and another"` should evaluate to {anchorEvalStep joinStringsWithEx 1}`"one, and another"`.
--  * What is the type of {anchorTerm joinStringsWith}`joinStringsWith ": "`? Check your answer with Lean.
--  * Define a function {anchorName volume}`volume` with type {anchorTerm volume}`Nat → Nat → Nat → Nat` that computes the volume of a rectangular prism with the given height, width, and depth.

 * 定义一个函数 {anchorName joinStringsWithEx}`joinStringsWith`，类型为 {anchorTerm joinStringsWith}`String → String → String → String`，它通过将第一个参数放在第二个和第三个参数之间创建一个新的字符串。{anchorEvalStep joinStringsWithEx 0}`joinStringsWith ", " "one" "and another"` 应该求值为 {anchorEvalStep joinStringsWithEx 1}`"one, and another"`。
 * {anchorTerm joinStringsWith}`joinStringsWith ": "` 的类型是什么？用 Lean 检查你的答案。
 * 定义一个函数 {anchorName volume}`volume`，类型为 {anchorTerm volume}`Nat → Nat → Nat → Nat`，它计算给定高度、宽度和深度的长方体的体积。


-- # Defining Types
# 定义类型
%%%
tag := "defining-types"
%%%

-- Most typed programming languages have some means of defining aliases for types, such as C's {c}`typedef`.
-- In Lean, however, types are a first-class part of the language—they are expressions like any other.
-- This means that definitions can refer to types just as well as they can refer to other values.
大多数类型化编程语言都有某种定义类型别名的方法，例如 C 语言的 {c}`typedef`。然而，在 Lean 中，类型是语言的一等公民——它们像任何其他表达式一样。这意味着定义可以引用类型，就像它们可以引用其他值一样。

:::paragraph
-- For example, if {anchorName StringTypeDef}`String` is too much to type, a shorter abbreviation {anchorName StringTypeDef}`Str` can be defined:
例如，如果 {anchorName StringTypeDef}`String` 太长，可以定义一个更短的缩写 {anchorName StringTypeDef}`Str`：

```anchor StringTypeDef
def Str : Type := String
```

-- It is then possible to use {anchorName aStr}`Str` as a definition's type instead of {anchorName StringTypeDef}`String`:
然后可以使用 {anchorName aStr}`Str` 作为定义的类型，而不是 {anchorName StringTypeDef}`String`：

```anchor aStr
def aStr : Str := "This is a string."
```

:::

-- The reason this works is that types follow the same rules as the rest of Lean.
-- Types are expressions, and in an expression, a defined name can be replaced with its definition.
-- Because {anchorName aStr}`Str` has been defined to mean {anchorName Book}`String`, the definition of {anchorName aStr}`aStr` makes sense.
这之所以有效，是因为类型遵循 Lean 的其余规则。类型是表达式，在表达式中，定义的名称可以替换为其定义。因为 {anchorName aStr}`Str` 被定义为 {anchorName Book}`String`，所以 {anchorName aStr}`aStr` 的定义是有意义的。

-- ## Messages You May Meet
## 你可能遇到的消息
%%%
tag := "abbrev-vs-def"
%%%

:::paragraph
-- Experimenting with using definitions for types is made more complicated by the way that Lean supports overloaded integer literals.
-- If {anchorName NaturalNumberTypeDef}`Nat` is too short, a longer name {anchorName NaturalNumberTypeDef}`NaturalNumber` can be defined:
由于 Lean 支持重载整数文字的方式，尝试使用类型定义变得更加复杂。如果 {anchorName NaturalNumberTypeDef}`Nat` 太短，可以定义一个更长的名称 {anchorName NaturalNumberTypeDef}`NaturalNumber`：

```anchor NaturalNumberTypeDef
def NaturalNumber : Type := Nat
```

-- However, using {anchorName NaturalNumberTypeDef}`NaturalNumber` as a definition's type instead of {anchorName NaturalNumberTypeDef}`Nat` does not have the expected effect.
-- In particular, the definition:
然而，使用 {anchorName NaturalNumberTypeDef}`NaturalNumber` 作为定义的类型而不是 {anchorName NaturalNumberTypeDef}`Nat` 并不会产生预期的效果。特别是，定义：

```anchor thirtyEight
def thirtyEight : NaturalNumber := 38
```

-- results in the following error:
导致以下错误：

```anchorError thirtyEight
failed to synthesize
  OfNat NaturalNumber 38
numerals are polymorphic in Lean, but the numeral `38` cannot be used in a context where the expected type is
  NaturalNumber
due to the absence of the instance above

Hint: Additional diagnostic information may be available using the `set_option diagnostics true` command.
```

:::

-- This error occurs because Lean allows number literals to be _overloaded_.
-- When it makes sense to do so, natural number literals can be used for new types, just as if those types were built in to the system.
-- This is part of Lean's mission of making it convenient to represent mathematics, and different branches of mathematics use number notation for very different purposes.
-- The specific feature that allows this overloading does not replace all defined names with their definitions before looking for overloading, which is what leads to the error message above.
此错误发生是因为 Lean 允许数字字面量被 _重载_。当有意义时，自然数字面量可以用于新类型，就像这些类型是内置到系统中一样。这是 Lean 使数学表示方便的使命的一部分，而数学的不同分支使用数字表示法用于非常不同的目的。允许这种重载的特定功能在查找重载之前不会用它们的定义替换所有定义的名称，这就是导致上述错误消息的原因。

:::paragraph
-- One way to work around this limitation is by providing the type {anchorName thirtyEightFixed}`Nat` on the right-hand side of the definition, causing {anchorName thirtyEightFixed}`Nat`'s overloading rules to be used for {anchorTerm thirtyEightFixed}`38`:
解决此限制的一种方法是在定义的右侧提供类型 {anchorName thirtyEightFixed}`Nat`，从而使 {anchorName thirtyEightFixed}`Nat` 的重载规则用于 {anchorTerm thirtyEightFixed}`38`：

```anchor thirtyEightFixed
def thirtyEight : NaturalNumber := (38 : Nat)
```

-- The definition is still type-correct because {anchorEvalStep NaturalNumberDef 0}`NaturalNumber` is the same type as {anchorEvalStep NaturalNumberDef 1}`Nat`—by definition!
该定义仍然是类型正确的，因为 {anchorEvalStep NaturalNumberDef 0}`NaturalNumber` 与 {anchorEvalStep NaturalNumberDef 1}`Nat` 是相同的类型——根据定义！
:::

-- Another solution is to define an overloading for {anchorName NaturalNumberDef}`NaturalNumber` that works equivalently to the one for {anchorName NaturalNumberDef}`Nat`.
-- This requires more advanced features of Lean, however.
另一种解决方案是为 {anchorName NaturalNumberDef}`NaturalNumber` 定义一个重载，其工作方式与 {anchorName NaturalNumberDef}`Nat` 的重载等效。然而，这需要 Lean 更高级的功能。

:::paragraph
-- Finally, defining the new name for {anchorName NaturalNumberDef}`Nat` using {kw}`abbrev` instead of {kw}`def` allows overloading resolution to replace the defined name with its definition.
-- Definitions written using {kw}`abbrev` are always unfolded.
-- For instance,
最后，使用 {kw}`abbrev` 而非 {kw}`def` 为 {anchorName NaturalNumberDef}`Nat` 定义新名称，允许重载解析用其定义替换定义的名称。使用 {kw}`abbrev` 编写的定义总是展开的。例如，

```anchor NTypeDef
abbrev N : Type := Nat
```

-- and
和

```anchor thirtyNine
def thirtyNine : N := 39
```

-- are accepted without issue.
被接受，没有问题。
:::

-- Behind the scenes, some definitions are internally marked as being unfoldable during overload resolution, while others are not.
-- Definitions that are to be unfolded are called _reducible_.
-- Control over reducibility is essential to allow Lean to scale: fully unfolding all definitions can result in very large types that are slow for a machine to process and difficult for users to understand.
-- Definitions produced with {kw}`abbrev` are marked as reducible.
在幕后，一些定义在重载解析期间被内部标记为可展开，而另一些则不被标记。要展开的定义称为 _可归约的_。对可归约性的控制对于 Lean 的扩展至关重要：完全展开所有定义可能导致非常大的类型，这些类型机器处理起来很慢，用户也难以理解。使用 {kw}`abbrev` 生成的定义被标记为可归约的。
