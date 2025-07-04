import VersoManual
import FPLeanZh.Examples

open Verso.Genre Manual
open Verso Code External

open FPLeanZh

set_option verso.exampleProject "../examples"
set_option verso.exampleModule "Examples.Classes"

set_option pp.rawOnError true

#doc (Manual) "Positive Numbers" =>
%%%
tag := "positive-numbers"
%%%

-- In some applications, only positive numbers make sense.
-- For example, compilers and interpreters typically use one-indexed line and column numbers for source positions, and a datatype that represents only non-empty lists will never report a length of zero.
-- Rather than relying on natural numbers, and littering the code with assertions that the number is not zero, it can be useful to design a datatype that represents only positive numbers.

在某些应用中，只有正数才有意义。
例如，编译器和解释器通常对源位置使用从 1 开始的行号和列号，并且只表示非空列表的数据类型永远不会报告长度为零。
与其依赖自然数，并在代码中充斥着断言数字不为零的语句，不如设计一个只表示正数的数据类型，这可能很有用。

-- One way to represent positive numbers is very similar to {moduleTerm}`Nat`, except with {anchorTerm Pos}`one` as the base case instead of {anchorTerm Nat.zero}`zero`:

一种表示正数的方法与 {moduleTerm}`Nat` 非常相似，只是基础情况是 {anchorTerm Pos}`one` 而不是 {anchorTerm Nat.zero}`zero`：

```anchor Pos
inductive Pos : Type where
  | one : Pos
  | succ : Pos → Pos
```
-- This datatype represents exactly the intended set of values, but it is not very convenient to use.
-- For example, numeric literals are rejected:
该数据类型精确地表示了预期的值集，但使用起来不是很方便。
例如，数字字面量会被拒绝：

```anchor sevenOops
def seven : Pos := 7
```
```anchorError sevenOops
failed to synthesize
  OfNat Pos 7
numerals are polymorphic in Lean, but the numeral `7` cannot be used in a context where the expected type is
  Pos
due to the absence of the instance above

Additional diagnostic information may be available using the `set_option diagnostics true` command.
```

-- Instead, the constructors must be used directly:

相反，必须直接使用构造函数：

```anchor seven
def seven : Pos :=
  Pos.succ (Pos.succ (Pos.succ (Pos.succ (Pos.succ (Pos.succ Pos.one)))))
```

-- Similarly, addition and multiplication are not easy to use:

同样，加法和乘法也不易使用：

```anchor fourteenOops
def fourteen : Pos := seven + seven
```
```anchorError fourteenOops
failed to synthesize
  HAdd Pos Pos ?m.543

Additional diagnostic information may be available using the `set_option diagnostics true` command.
```

```anchor fortyNineOops
def fortyNine : Pos := seven * seven
```
```anchorError fortyNineOops
failed to synthesize
  HMul Pos Pos ?m.576

Additional diagnostic information may be available using the `set_option diagnostics true` command.
```

-- Each of these error messages begins with {lit}`failed to synthesize`.
-- This indicates that the error is due to an overloaded operation that has not been implemented, and it describes the type class that must be implemented.

这些错误消息都以 {lit}`failed to synthesize` 开头。
这表示错误是由于未实现重载操作，并描述了必须实现的类型类。

-- # Classes and Instances

# 类和实例

-- A type class consists of a name, some parameters, and a collection of {deftech}_methods_.
-- The parameters describe the types for which overloadable operations are being defined, and the methods are the names and type signatures of the overloadable operations.
-- Once again, there is a terminology clash with object-oriented languages.
-- In object-oriented programming, a method is essentially a function that is connected to a particular object in memory, with special access to the object\'s private state.
-- Objects are interacted with via their methods.
-- In Lean, the term “method” refers to an operation that has been declared to be overloadable, with no special connection to objects or values or private fields.

类型类由一个名称、一些参数和一组 {deftech}__方法__ 组成。
参数描述了为其定义可重载操作的类型，而方法是可重载操作的名称和类型签名。
再次，与面向对象语言存在术语冲突。
在面向对象编程中，方法本质上是连接到内存中特定对象的函数，具有对该对象私有状态的特殊访问权限。
通过其方法与对象进行交互。
在 Lean 中，“方法”一词指的是已声明为可重载的操作，与对象、值或私有字段没有特殊联系。

-- One way to overload addition is to define a type class named {anchorName Plus}`Plus`, with an addition method named {anchorName Plus}`plus`.
-- Once an instance of {anchorTerm Plus}`Plus` for {moduleTerm}`Nat` has been defined, it becomes possible to add two {moduleTerm}`Nat`s using {anchorName plusNatFiveThree}`Plus.plus`:

重载加法的一种方法是定义一个名为 {anchorName Plus}`Plus` 的类型类，其加法方法名为 {anchorName Plus}`plus`。
一旦为 {moduleTerm}`Nat` 定义了 {anchorTerm Plus}`Plus` 的实例，就可以使用 {anchorName plusNatFiveThree}`Plus.plus` 将两个 {moduleTerm}`Nat` 相加：

```anchor plusNatFiveThree
#eval Plus.plus 5 3
```
```anchorInfo plusNatFiveThree
8
```

-- Adding more instances allows {anchorName plusNatFiveThree}`Plus.plus` to take more types of arguments.

添加更多实例允许 {anchorName plusNatFiveThree}`Plus.plus` 接受更多类型的参数。

-- In the following type class declaration, {anchorName Plus}`Plus` is the name of the class, {anchorTerm Plus}`α : Type` is the only argument, and {anchorTerm Plus}`plus : α → α → α` is the only method:

在以下类型类声明中，{anchorName Plus}`Plus` 是类的名称，{anchorTerm Plus}`α : Type` 是唯一的参数，{anchorTerm Plus}`plus : α → α → α` 是唯一的方法：

```anchor Plus
class Plus (α : Type) where
  plus : α → α → α
```

-- This declaration says that there is a type class {anchorName Plus}`Plus` that overloads operations with respect to a type {anchorName Plus}`α`.
-- In particular, there is one overloaded operation called {anchorName Plus}`plus` that takes two {anchorName Plus}`α`s and returns an {anchorName Plus}`α`.

该声明表示存在一个类型类 {anchorName Plus}`Plus`，它重载了关于类型 {anchorName Plus}`α` 的操作。
特别是，有一个名为 {anchorName Plus}`plus` 的重载操作，它接受两个 {anchorName Plus}`α` 并返回一个 {anchorName Plus}`α`。

-- Type classes are first class, just as types are first class.
-- In particular, a type class is another kind of type.
-- The type of {anchorTerm PlusType}`Plus` is {anchorTerm PlusType}`Type → Type`, because it takes a type as an argument ({anchorName Plus}`α`) and results in a new type that describes the overloading of {anchorName Plus}`Plus`\'s operation for {anchorName Plus}`α`.

类型类是一等公民，就像类型是一等公民一样。
特别是，类型类是另一种类型。
{anchorTerm PlusType}`Plus` 的类型是 {anchorTerm PlusType}`Type → Type`，因为它接受一个类型作为参数 ({anchorName Plus}`α`) 并产生一个新类型，该类型描述了 {anchorName Plus}`Plus` 的操作对 {anchorName Plus}`α` 的重载。

-- To overload {anchorName PlusNat}`plus` for a particular type, write an instance:

要为特定类型重载 {anchorName PlusNat}`plus`，请编写一个实例：

```anchor PlusNat
instance : Plus Nat where
  plus := Nat.add
```

-- The colon after {anchorTerm PlusNat}`instance` indicates that {anchorTerm PlusNat}`Plus Nat` is indeed a type.
-- Each method of class {anchorName Plus}`Plus` should be assigned a value using {anchorTerm PlusNat}`:=`.
-- In this case, there is only one method: {anchorName PlusNat}`plus`.

{anchorTerm PlusNat}`instance` 后面的冒号表示 {anchorTerm PlusNat}`Plus Nat` 确实是一个类型。
类 {anchorName Plus}`Plus` 的每个方法都应使用 {anchorTerm PlusNat}`:=` 赋值。
在这种情况下，只有一个方法：{anchorName PlusNat}`plus`。

-- By default, type class methods are defined in a namespace with the same name as the type class.
-- It can be convenient to {anchorTerm openPlus}`open` the namespace so that users don\'t need to type the name of the class first.
-- Parentheses in an {kw}`open` command indicate that only the indicated names from the namespace are to be made accessible:

默认情况下，类型类方法定义在与类型类同名的命名空间中。
{anchorTerm openPlus}`open` 命名空间很方便，这样用户就不需要先键入类的名称。
{kw}`open` 命令中的括号表示只允许访问命名空间中指定的名称：

```anchor openPlus
open Plus (plus)
```

```anchor plusNatFiveThreeAgain
#eval plus 5 3
```
```anchorInfo plusNatFiveThreeAgain
8
```

-- Defining an addition function for {anchorName PlusPos}`Pos` and an instance of {anchorTerm PlusPos}`Plus Pos` allows {anchorName PlusPos}`plus` to be used to add both {anchorName PlusPos}`Pos` and {moduleTerm}`Nat` values:

为 {anchorName PlusPos}`Pos` 定义加法函数和 {anchorTerm PlusPos}`Plus Pos` 的实例允许 {anchorName PlusPos}`plus` 用于将 {anchorName PlusPos}`Pos` 和 {moduleTerm}`Nat` 值相加：

```anchor PlusPos
def Pos.plus : Pos → Pos → Pos
  | Pos.one, k => Pos.succ k
  | Pos.succ n, k => Pos.succ (n.plus k)

instance : Plus Pos where
  plus := Pos.plus

def fourteen : Pos := plus seven seven
```

-- Because there is not yet an instance of {moduleTerm}`Plus Float`, attempting to add two floating-point numbers with {anchorName plusFloatFail}`plus` fails with a familiar message:

因为还没有 {moduleTerm}`Plus Float` 的实例，所以尝试用 {anchorName plusFloatFail}`plus` 将两个浮点数相加会失败，并显示一条熟悉的消息：

```anchor plusFloatFail
#eval plus 5.2 917.25861
```
```anchorError plusFloatFail
failed to synthesize
  Plus Float

Additional diagnostic information may be available using the `set_option diagnostics true` command.
```

-- These errors mean that Lean was unable to find an instance for a given type class.

这些错误意味着 Lean 无法为给定的类型类找到实例。

-- # Overloaded Addition

# 重载加法

-- Lean\'s built-in addition operator is syntactic sugar for a type class called {anchorName chapterIntro}`HAdd`, which flexibly allows the arguments to addition to have different types.
-- {anchorName chapterIntro}`HAdd` is short for _heterogeneous addition_.
-- For example, an {anchorName chapterIntro}`HAdd` instance can be written to allow a {moduleName}`Nat` to be added to a {anchorName fiveZeros}`Float`, resulting in a new {anchorName fiveZeros}`Float`.
-- When a programmer writes {anchorTerm plusDesugar}`x + y`, it is interpreted as meaning {anchorTerm plusDesugar}`HAdd.hAdd x y`.

Lean 的内置加法运算符是名为 {anchorName chapterIntro}`HAdd` 的类型类的语法糖，它灵活地允许加法参数具有不同的类型。
{anchorName chapterIntro}`HAdd` 是__异构加法__的缩写。
例如，可以编写一个 {anchorName chapterIntro}`HAdd` 实例，以允许将 {moduleName}`Nat` 添加到 {anchorName fiveZeros}`Float` 中，从而产生一个新的 {anchorName fiveZeros}`Float`。
当程序员编写 {anchorTerm plusDesugar}`x + y` 时，它被解释为 {anchorTerm plusDesugar}`HAdd.hAdd x y`。

-- While an understanding of the full generality of {anchorName chapterIntro}`HAdd` relies on features that are discussed in {ref "out-params"}[another section in this chapter], there is a simpler type class called {anchorName AddPos}`Add` that does not allow the types of the arguments to be mixed.
-- The Lean libraries are set up so that an instance of {anchorName AddPos}`Add` will be found when searching for an instance of {anchorName chapterIntro}`HAdd` in which both arguments have the same type.

虽然对 {anchorName chapterIntro}`HAdd` 的完全通用性的理解依赖于 {ref "out-params"}[本章另一节] 中讨论的功能，但有一个更简单的类型类称为 {anchorName AddPos}`Add`，它不允许混合参数的类型。
Lean 库的设置使得在搜索两个参数具有相同类型的 {anchorName chapterIntro}`HAdd` 实例时，会找到 {anchorName AddPos}`Add` 的实例。

-- Defining an instance of {anchorTerm AddPos}`Add Pos` allows {anchorTerm AddPos}`Pos` values to use ordinary addition syntax:

定义 {anchorTerm AddPos}`Add Pos` 的实例允许 {anchorTerm AddPos}`Pos` 值使用普通的加法语法：

```anchor AddPos
instance : Add Pos where
  add := Pos.plus
```

```anchor betterFourteen
def fourteen : Pos := seven + seven
```

-- # Conversion to Strings

# 转换为字符串

-- Another useful built-in class is called {anchorName UglyToStringPos}`ToString`.
-- Instances of {anchorName UglyToStringPos}`ToString` provide a standard way of converting values from a given type into strings.
-- For example, a {anchorName UglyToStringPos}`ToString` instance is used when a value occurs in an interpolated string, and it determines how the {anchorName printlnType}`IO.println` function used at the {ref "running-a-program"}[beginning of the description of {anchorName readFile}`IO`] will display a value.

另一个有用的内置类称为 {anchorName UglyToStringPos}`ToString`。
{anchorName UglyToStringPos}`ToString` 的实例提供了一种将值从给定类型转换为字符串的标准方法。
例如，当一个值出现在插值字符串中时，会使用 {anchorName UglyToStringPos}`ToString` 实例，它决定了在 {ref "running-a-program"}[{anchorName readFile}`IO` 描述的开头] 使用的 {anchorName printlnType}`IO.println` 函数将如何显示一个值。

-- For example, one way to convert a {anchorName Pos}`Pos` into a {anchorName readFile}`String` is to reveal its inner structure.
-- The function {anchorName posToStringStructure}`posToString` takes a {anchorName posToStringStructure}`Bool` that determines whether to parenthesize uses of {anchorName posToStringStructure}`Pos.succ`, which should be {anchorName CoeBoolProp}`true` in the initial call to the function and {anchorName posToStringStructure}`false` in all recursive calls.

例如，将 {anchorName Pos}`Pos` 转换为 {anchorName readFile}`String` 的一种方法是揭示其内部结构。
函数 {anchorName posToStringStructure}`posToString` 接受一个 {anchorName posToStringStructure}`Bool`，它决定是否对 {anchorName posToStringStructure}`Pos.succ` 的使用进行括号括起来，在对函数的初始调用中应为 {anchorName CoeBoolProp}`true`，在所有递归调用中应为 {anchorName posToStringStructure}`false`。

```anchor posToStringStructure
def posToString (atTop : Bool) (p : Pos) : String :=
  let paren s := if atTop then s else "(" ++ s ++ ")"
  match p with
  | Pos.one => "Pos.one"
  | Pos.succ n => paren s!"Pos.succ {posToString false n}"
```

-- Using this function for a {anchorName UglyToStringPos}`ToString` instance:

将此函数用于 {anchorName UglyToStringPos}`ToString` 实例：

```anchor UglyToStringPos
instance : ToString Pos where
  toString := posToString true
```

-- results in informative, yet overwhelming, output:

结果是信息丰富但又令人不知所措的输出：

```anchor sevenLong
#eval s!"There are {seven}"
```
```anchorInfo sevenLong
"There are Pos.succ (Pos.succ (Pos.succ (Pos.succ (Pos.succ (Pos.succ Pos.one)))))"
```

-- On the other hand, every positive number has a corresponding {moduleTerm}`Nat`.
-- Converting it to a {moduleTerm}`Nat` and then using the {moduleTerm}`ToString Nat` instance (that is, the overloading of {anchorName UglyToStringPos}`ToString` for {moduleTerm}`Nat`) is a quick way to generate much shorter output:

另一方面，每个正数都有一个对应的 {moduleTerm}`Nat`。
将其转换为 {moduleTerm}`Nat`，然后使用 {moduleTerm}`ToString Nat` 实例（即 {anchorName UglyToStringPos}`ToString` 对 {moduleTerm}`Nat` 的重载）是生成更短输出的快捷方法：

```anchor posToNat
def Pos.toNat : Pos → Nat
  | Pos.one => 1
  | Pos.succ n => n.toNat + 1
```

```anchor PosToStringNat
instance : ToString Pos where
  toString x := toString (x.toNat)
```

```anchor sevenShort
#eval s!"There are {seven}"
```
```anchorInfo sevenShort
"There are 7"
```

-- When more than one instance is defined, the most recent takes precedence.
-- Additionally, if a type has a {anchorName UglyToStringPos}`ToString` instance, then it can be used to display the result of {kw}`#eval` even if the type in question was not defined with {anchorTerm JSON}`deriving Repr`, so {anchorTerm sevenEvalStr}`#eval seven` outputs {anchorInfo sevenEvalStr}`7`.

当定义了多个实例时，最新的实例优先。
此外，如果一个类型具有 {anchorName UglyToStringPos}`ToString` 实例，那么即使所讨论的类型没有使用 {anchorTerm JSON}`deriving Repr` 定义，它也可以用于显示 {kw}`#eval` 的结果，因此 {anchorTerm sevenEvalStr}`#eval seven` 输出 {anchorInfo sevenEvalStr}`7`。

-- # Overloaded Multiplication

# 重载乘法

-- For multiplication, there is a type class called {anchorName MulPPoint}`HMul` that allows mixed argument types, just like {anchorName chapterIntro}`HAdd`.
-- Just as {anchorTerm plusDesugar}`x + y` is interpreted as {anchorTerm plusDesugar}[`HAdd.hAdd x y`], {anchorTerm timesDesugar}`x * y` is interpreted as {anchorTerm timesDesugar}`HMul.hMul x y`.
-- For the common case of multiplication of two arguments with the same type, a {moduleTerm}`Mul` instance suffices.

对于乘法，有一个名为 {anchorName MulPPoint}`HMul` 的类型类，它允许混合参数类型，就像 {anchorName chapterIntro}`HAdd` 一样。
就像 {anchorTerm plusDesugar}`x + y` 被解释为 {anchorTerm plusDesugar}[`HAdd.hAdd x y`] 一样，{anchorTerm timesDesugar}`x * y` 被解释为 {anchorTerm timesDesugar}`HMul.hMul x y`。
对于两个相同类型参数相乘的常见情况，一个 {moduleTerm}`Mul` 实例就足够了。

-- An instance of {moduleTerm}`Mul` allows ordinary multiplication syntax to be used with {moduleTerm}`Pos`:

{moduleTerm}`Mul` 的实例允许将普通乘法语法与 {moduleTerm}`Pos` 一起使用：

```anchor PosMul
def Pos.mul : Pos → Pos → Pos
  | Pos.one, k => k
  | Pos.succ n, k => n.mul k + k

instance : Mul Pos where
  mul := Pos.mul
```

-- With this instance, multiplication works as expected:

有了这个实例，乘法就可以正常工作了：

```anchor muls
#eval [seven * Pos.one,
       seven * seven,
       Pos.succ Pos.one * seven]
```
```anchorInfo muls
[7, 49, 14]
```

-- # Literal Numbers

# 字面量数字

-- It is quite inconvenient to write out a sequence of constructors for positive numbers.
-- One way to work around the problem would be to provide a function to convert a {moduleTerm}`Nat` into a {anchorName Pos}`Pos`.
-- However, this approach has downsides.
-- First off, because {moduleTerm}`Pos` cannot represent {anchorTerm nats}`0`, the resulting function would either convert a {moduleTerm}`Nat` to a bigger number, or it would return {moduleTerm}`Option Pos`.
-- Neither is particularly convenient for users.
-- Secondly, the need to call the function explicitly would make programs that use positive numbers much less convenient to write than programs that use {moduleTerm}`Nat`.
-- Having a trade-off between precise types and convenient APIs means that the precise types become less useful.

为正数写出一系列构造函数非常不方便。
解决这个问题的一种方法是提供一个函数将 {moduleTerm}`Nat` 转换为 {anchorName Pos}`Pos`。
然而，这种方法有缺点。
首先，因为 {moduleTerm}`Pos` 不能表示 {anchorTerm nats}`0`，所以生成的函数要么将 {moduleTerm}`Nat` 转换为更大的数字，要么返回 {moduleTerm}`Option Pos`。
这两种方法对用户来说都不是特别方便。
其次，需要显式调用函数会使使用正数的程序比使用 {moduleTerm}`Nat` 的程序编写起来不方便得多。
在精确类型和方便的 API 之间进行权衡意味着精确类型变得不那么有用。

-- There are two type classes that are used to overload numeric literals: {moduleName}`Zero` and {moduleName}`OfNat`.
-- Because many types have values that are naturally written with {anchorTerm nats}`0`, the {moduleName}`Zero` class allow these specific values to be overridden.
-- It is defined as follows:

有两个类型类用于重载数字字面量：{moduleName}`Zero` 和 {moduleName}`OfNat`。
因为许多类型的值很自然地用 {anchorTerm nats}`0` 书写，所以 {moduleName}`Zero` 类允许重写这些特定值。
它的定义如下：

```anchor Zero
class Zero (α : Type) where
  zero : α
```

-- Because {anchorTerm nats}`0` is not a positive number, there should be no instance of {moduleTerm}`Zero Pos`.

因为 {anchorTerm nats}`0` 不是正数，所以不应该有 {moduleTerm}`Zero Pos` 的实例。

-- In Lean, natural number literals are interpreted using a type class called {moduleName}`OfNat`:

在 Lean 中，自然数字面量使用名为 {moduleName}`OfNat` 的类型类来解释：

```anchor OfNat
class OfNat (α : Type) (_ : Nat) where
  ofNat : α
```

-- This type class takes two arguments: {anchorTerm OfNat}`α` is the type for which a natural number is overloaded, and the unnamed {moduleTerm}`Nat` argument is the actual literal number that was encountered in the program.
-- The method {anchorName OfNat}`ofNat` is then used as the value of the numeric literal.
-- Because the class contains the {moduleTerm}`Nat` argument, it becomes possible to define only instances for those values where the number makes sense.

该类型类接受两个参数：{anchorTerm OfNat}`α` 是为其重载自然数的类型，未命名的 {moduleTerm}`Nat` 参数是程序中遇到的实际字面量数字。
然后，方法 {anchorName OfNat}`ofNat` 用作数字字面量的值。
因为该类包含 {moduleTerm}`Nat` 参数，所以可以只为那些数字有意义的值定义实例。

-- {anchorTerm OfNat}`OfNat` demonstrates that the arguments to type classes do not need to be types.
-- Because types in Lean are first-class participants in the language that can be passed as arguments to functions and given definitions with {kw}`def` and {kw}`abbrev`, there is no barrier that prevents non-type arguments in positions where a less-flexible language could not permit them.
-- This flexibility allows overloaded operations to be provided for particular values as well as particular types.
-- Additionally, it allows the Lean standard library to arrange for there to be a {moduleTerm}`Zero α` instance whenever there\'s an {moduleTerm}`OfNat α 0` instance, and vice versa.

{anchorTerm OfNat}`OfNat` 表明类型类的参数不必是类型。
因为 Lean 中的类型是语言的一等公民，可以作为参数传递给函数，并使用 {kw}`def` 和 {kw}`abbrev` 进行定义，所以在灵活性较差的语言无法允许的位置，没有障碍阻止非类型参数。
这种灵活性允许为特定值和特定类型提供重载操作。
此外，它还允许 Lean 标准库安排在存在 {moduleTerm}`OfNat α 0` 实例时存在 {moduleTerm}`Zero α` 实例，反之亦然。

-- A sum type that represents natural numbers less than four can be defined as follows:

表示小于 4 的自然数的和类型可以定义如下：

```anchor LT4
inductive LT4 where
  | zero
  | one
  | two
  | three
deriving Repr
```

-- While it would not make sense to allow _any_ literal number to be used for this type, numbers less than four clearly make sense:

虽然允许将__任何__字面量数字用于此类型没有意义，但小于 4 的数字显然有意义：

```anchor LT4ofNat
instance : OfNat LT4 0 where
  ofNat := LT4.zero

instance : OfNat LT4 1 where
  ofNat := LT4.one

instance : OfNat LT4 2 where
  ofNat := LT4.two

instance : OfNat LT4 3 where
  ofNat := LT4.three
```

-- With these instances, the following examples work:

有了这些实例，以下示例就可以工作了：

```anchor LT4three
#eval (3 : LT4)
```
```anchorInfo LT4three
LT4.three
```

```anchor LT4zero
#eval (0 : LT4)
```
```anchorInfo LT4zero
LT4.zero
```

-- On the other hand, out-of-bounds literals are still not allowed:

另一方面，仍然不允许使用越界字面量：

```anchor LT4four
#eval (4 : LT4)
```
```anchorError LT4four
failed to synthesize
  OfNat LT4 4
numerals are polymorphic in Lean, but the numeral `4` cannot be used in a context where the expected type is
  LT4
due to the absence of the instance above

Additional diagnostic information may be available using the `set_option diagnostics true` command.
```

-- For {moduleTerm}`Pos`, the {anchorTerm OfNat}`OfNat` instance should work for _any_ {moduleTerm}`Nat` other than {moduleTerm}`Nat.zero`.
-- Another way to phrase this is to say that for all natural numbers {anchorTerm posrec}`n`, the instance should work for {anchorTerm posrec}`n + 1`.
-- Just as names like {anchorTerm posrec}`α` automatically become implicit arguments to functions that Lean fills out on its own, instances can take automatic implicit arguments.
-- In this instance, the argument {anchorTerm OfNatPos}`n` stands for any {moduleTerm}`Nat`, and the instance is defined for a {moduleTerm}`Nat` that\'s one greater:

对于 {moduleTerm}`Pos`，{anchorTerm OfNat}`OfNat` 实例应该适用于除 {moduleTerm}`Nat.zero` 之外的__任何__ {moduleTerm}`Nat`。
另一种说法是，对于所有自然数 {anchorTerm posrec}`n`，实例应该适用于 {anchorTerm posrec}`n + 1`。
就像 {anchorTerm posrec}`α` 这样的名称自动成为 Lean 自己填充的函数的隐式参数一样，实例也可以接受自动隐式参数。
在这种情况下，参数 {anchorTerm OfNatPos}`n` 代表任何 {moduleTerm}`Nat`，并且实例是为一个比它大一的 {moduleTerm}`Nat` 定义的：

```anchor OfNatPos
instance : OfNat Pos (n + 1) where
  ofNat :=
    let rec natPlusOne : Nat → Pos
      | 0 => Pos.one
      | k + 1 => Pos.succ (natPlusOne k)
    natPlusOne n
```

-- Because {anchorTerm OfNatPos}`n` stands for a {moduleTerm}`Nat` that\'s one less than what the user wrote, the helper function {anchorName OfNatPos}`natPlusOne` returns a {anchorName OfNatPos}`Pos` that\'s one greater than its argument.
-- This makes it possible to use natural number literals for positive numbers, but not for zero:

因为 {anchorTerm OfNatPos}`n` 代表比用户写的少一的 {moduleTerm}`Nat`，所以辅助函数 {anchorName OfNatPos}`natPlusOne` 返回一个比其参数大一的 {anchorName OfNatPos}`Pos`。
这使得可以对正数使用自然数字面量，但不能对零使用：

```anchor eight
def eight : Pos := 8
```

```anchor zeroBad
def zero : Pos := 0
```
```anchorError zeroBad
failed to synthesize
  OfNat Pos 0
numerals are polymorphic in Lean, but the numeral `0` cannot be used in a context where the expected type is
  Pos
due to the absence of the instance above

Additional diagnostic information may be available using the `set_option diagnostics true` command.
```

-- # Exercises

# 练习

-- ## Another Representation

## 另一种表示法

-- An alternative way to represent a positive number is as the successor of some {moduleTerm}`Nat`.
-- Replace the definition of {moduleName}`Pos` with a structure whose constructor is named {anchorName AltPos}`succ` that contains a {moduleTerm}`Nat`:

表示正数的另一种方法是作为某个 {moduleTerm}`Nat` 的后继。
将 {moduleName}`Pos` 的定义替换为一个结构，其构造函数名为 {anchorName AltPos}`succ`，其中包含一个 {moduleTerm}`Nat`：

```anchor AltPos
structure Pos where
  succ ::
  pred : Nat
```

-- Define instances of {moduleName}`Add`, {moduleName}`Mul`, {anchorName UglyToStringPos}`ToString`, and {moduleName}`OfNat` that allow this version of {anchorName AltPos}`Pos` to be used conveniently.

定义 {moduleName}`Add`、{moduleName}`Mul`、{anchorName UglyToStringPos}`ToString` 和 {moduleName}`OfNat` 的实例，以方便地使用此版本的 {anchorName AltPos}`Pos`。

-- ## Even Numbers

## 偶数

-- Define a datatype that represents only even numbers. Define instances of {moduleName}`Add`, {moduleName}`Mul`, and {anchorName UglyToStringPos}`ToString` that allow it to be used conveniently.
-- {moduleName}`OfNat` requires a feature that is introduced in {ref "tc-polymorphism"}[the next section].

定义一个只表示偶数的数据类型。定义 {moduleName}`Add`、{moduleName}`Mul` 和 {anchorName UglyToStringPos}`ToString` 的实例，以方便地使用它。
{moduleName}`OfNat` 需要在 {ref "tc-polymorphism"}[下一节] 中介绍的功能。

-- ## HTTP Requests

## HTTP 请求

-- An HTTP request begins with an identification of a HTTP method, such as {lit}`GET` or {lit}`POST`, along with a URI and an HTTP version.
-- Define an inductive type that represents an interesting subset of the HTTP methods, and a structure that represents HTTP responses.
-- Responses should have a {anchorName UglyToStringPos}`ToString` instance that makes it possible to debug them.
-- Use a type class to associate different {moduleName}`IO` actions with each HTTP method, and write a test harness as an {moduleName}`IO` action that calls each method and prints the result.

HTTP 请求以 HTTP 方法的标识（例如 {lit}`GET` 或 {lit}`POST`）、URI 和 HTTP 版本开头。
定义一个表示 HTTP 方法的有趣子集的归纳类型，以及一个表示 HTTP 响应的结构。
响应应该有一个 {anchorName UglyToStringPos}`ToString` 实例，以便可以调试它们。
使用类型类将不同的 {moduleName}`IO` 操作与每个 HTTP 方法相关联，并编写一个测试工具作为 {moduleName}`IO` 操作，该操作调用每个方法并打印结果。
