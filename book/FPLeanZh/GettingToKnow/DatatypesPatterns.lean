import VersoManual
import FPLeanZh.Examples

open Verso.Genre Manual
open Verso Code External

open FPLeanZh

example_module Examples.Intro

set_option verso.exampleProject "../examples"
set_option verso.exampleModule "Examples.Intro"

#doc (Manual) "数据类型和模式匹配" =>
%%%
tag := "datatypes-and-patterns"
%%%

-- Structures enable multiple independent pieces of data to be combined into a coherent whole that is represented by a brand new type.
-- Types such as structures that group together a collection of values are called _product types_.
-- Many domain concepts, however, can't be naturally represented as structures.
-- For instance, an application might need to track user permissions, where some users are document owners, some may edit documents, and others may only read them.
-- A calculator has a number of binary operators, such as addition, subtraction, and multiplication.
-- Structures do not provide an easy way to encode multiple choices.

结构使多个独立的数据片段能够组合成一个连贯的整体，由一个全新的类型表示。
将值集合组合在一起的类型（如结构）称为 *积类型（Product Types）*。
但是，许多域概念不能自然地表示为结构。
例如，应用程序可能需要跟踪用户权限，其中一些用户是文档所有者，一些可以编辑文档，其他人只能阅读它们。
计算器有许多二元运算符，如加法、减法和乘法。
结构不提供编码多种选择的简单方法。

-- Similarly, while a structure is an excellent way to keep track of a fixed set of fields, many applications require data that may contain an arbitrary number of elements.
-- Most classic data structures, such as trees and lists, have a recursive structure, where the tail of a list is itself a list, or where the left and right branches of a binary tree are themselves binary trees.
-- In the aforementioned calculator, the structure of expressions themselves is recursive.
-- The summands in an addition expression may themselves be multiplication expressions, for instance.

类似地，虽然结构是跟踪固定字段集的绝佳方法，但许多应用程序需要可能包含任意数量元素的数据。
大多数经典数据结构（如树和列表）都具有递归结构，其中列表的尾部本身就是一个列表，或者二叉树的左右分支本身就是二叉树。
在上述计算器中，表达式本身的结构是递归的。
例如，加法表达式中的被加数本身可能是乘法表达式。

-- Datatypes that allow choices are called _sum types_ and datatypes that can include instances of themselves are called _recursive datatypes_.
-- Recursive sum types are called _inductive datatypes_, because mathematical induction may be used to prove statements about them.
-- When programming, inductive datatypes are consumed through pattern matching and recursive functions.

允许选择的数据类型称为 *和类型（Sum Types）*，可以包含自身实例的数据类型称为 *递归数据类型（Recursive Datatypes）*。
递归和类型称为 *归纳数据类型（Inductive Datatypes）*，因为可以使用数学归纳法来证明关于它们的陈述。
在编程时，归纳数据类型通过模式匹配和递归函数来使用。

:::paragraph
-- Many of the built-in types are actually inductive datatypes in the standard library.
-- For instance, {anchorName Bool}`Bool` is an inductive datatype:

许多内置类型实际上是标准库中的归纳数据类型。
例如，{anchorName Bool}`Bool` 是一个归纳数据类型：

```anchor Bool
inductive Bool where
  | false : Bool
  | true : Bool
```

-- This definition has two main parts.
-- The first line provides the name of the new type ({anchorName Bool}`Bool`), while the remaining lines each describe a constructor.
-- As with constructors of structures, constructors of inductive datatypes are mere inert receivers of and containers for other data, rather than places to insert arbitrary initialization and validation code.
-- Unlike structures, inductive datatypes may have multiple constructors.
-- Here, there are two constructors, {anchorName Bool}`true` and {anchorName Bool}`false`, and neither takes any arguments.
-- Just as a structure declaration places its names in a namespace named after the declared type, an inductive datatype places the names of its constructors in a namespace.
-- In the Lean standard library, {anchorName BoolNames}`true` and {anchorName BoolNames}`false` are re-exported from this namespace so that they can be written alone, rather than as {anchorName BoolNames}`Bool.true` and {anchorName BoolNames}`Bool.false`, respectively.

这个定义有两个主要部分。
第一行提供新类型的名称（{anchorName Bool}`Bool`），而其余行各自描述一个构造器。
与结构的构造器一样，归纳数据类型的构造器仅仅是其他数据的惰性接收者和容器，而不是插入任意初始化和验证代码的地方。
与结构不同，归纳数据类型可以有多个构造器。
这里有两个构造器，{anchorName Bool}`true` 和 {anchorName Bool}`false`，都不接受任何参数。
就像结构声明将其名称放在以声明类型命名的命名空间中一样，归纳数据类型将其构造器的名称放在一个命名空间中。
在 Lean 标准库中，{anchorName BoolNames}`true` 和 {anchorName BoolNames}`false` 从这个命名空间重新导出，以便可以单独编写，而不是分别作为 {anchorName BoolNames}`Bool.true` 和 {anchorName BoolNames}`Bool.false`。
:::

:::paragraph
-- From a data modeling perspective, inductive datatypes are used in many of the same contexts where a sealed abstract class might be used in other languages.
-- In languages like C# or Java, one might write a similar definition of {anchorName Bool}`Bool`:

从数据建模的角度来看，归纳数据类型在许多相同的上下文中使用，其他语言中可能使用密封抽象类。
在 C# 或 Java 等语言中，可能会编写类似的 {anchorName Bool}`Bool` 定义：

```CSharp
abstract class Bool {}
class True : Bool {}
class False : Bool {}
```

-- However, the specifics of these representations are fairly different. In particular, each non-abstract class creates both a new type and new ways of allocating data. In the object-oriented example, {CSharp}`True` and {CSharp}`False` are both types that are more specific than {CSharp}`Bool`, while the Lean definition introduces only the new type {anchorName Bool}`Bool`.

但是，这些表示的具体细节是相当不同的。特别是，每个非抽象类都创建了新类型和新的数据分配方式。在面向对象的示例中，{CSharp}`True` 和 {CSharp}`False` 都是比 {CSharp}`Bool` 更具体的类型，而 Lean 定义仅引入新类型 {anchorName Bool}`Bool`。
:::

-- The type {anchorName Nat}`Nat` of non-negative integers is an inductive datatype:
非负整数的类型 {anchorName Nat}`Nat` 是一个归纳数据类型：

```anchor Nat
inductive Nat where
  | zero : Nat
  | succ (n : Nat) : Nat
```

-- Here, {anchorName NatNames}`zero` represents 0, while {anchorName NatNames}`succ` represents the successor of some other number.
-- The {anchorName Nat}`Nat` mentioned in {anchorName NatNames}`succ`'s declaration is the very type {anchorName Nat}`Nat` that is in the process of being defined.
-- _Successor_ means “one greater than”, so the successor of five is six and the successor of 32,185 is 32,186.
-- Using this definition, {anchorEvalStep four 1}`4` is represented as {anchorEvalStep four 0}`Nat.succ (Nat.succ (Nat.succ (Nat.succ Nat.zero)))`.

这里，{anchorName NatNames}`zero` 表示 0，而 {anchorName NatNames}`succ` 表示某个其他数字的后继。
在 {anchorName NatNames}`succ` 的声明中提到的 {anchorName Nat}`Nat` 正是正在定义的类型 {anchorName Nat}`Nat`。
*后继（Successor）* 意味着"比...大一"，所以五的后继是六，32,185的后继是32,186。
使用这个定义，{anchorEvalStep four 1}`4` 表示为 {anchorEvalStep four 0}`Nat.succ (Nat.succ (Nat.succ (Nat.succ Nat.zero)))`。

-- This definition is almost like the definition of {anchorName even}`Bool` with slightly different names.
-- The only real difference is that {anchorName NatNames}`succ` is followed by {anchorTerm Nat}`(n : Nat)`, which specifies that the constructor {anchorName NatNames}`succ` takes an argument of type {anchorName Nat}`Nat` which happens to be named {anchorName Nat}`n`.
-- The names {anchorName NatNames}`zero` and {anchorName NatNames}`succ` are in a namespace named after their type, so they must be referred to as {anchorName NatNames}`Nat.zero` and {anchorName NatNames}`Nat.succ`, respectively.

这个定义几乎就像 {anchorName even}`Bool` 的定义，只是名称略有不同。
唯一的真正区别是 {anchorName NatNames}`succ` 后面跟着 {anchorTerm Nat}`(n : Nat)`，它指定构造器 {anchorName NatNames}`succ` 接受一个类型为 {anchorName Nat}`Nat` 的参数，恰好命名为 {anchorName Nat}`n`。
名称 {anchorName NatNames}`zero` 和 {anchorName NatNames}`succ` 在以其类型命名的命名空间中，因此必须分别称为 {anchorName NatNames}`Nat.zero` 和 {anchorName NatNames}`Nat.succ`。

-- Argument names, such as {anchorName Nat}`n`, may occur in Lean's error messages and in feedback provided when writing mathematical proofs.
-- Lean also has an optional syntax for providing arguments by name.
-- Generally, however, the choice of argument name is less important than the choice of a structure field name, as it does not form as large a part of the API.

参数名称（如 {anchorName Nat}`n`）可能出现在 Lean 的错误消息中以及编写数学证明时提供的反馈中。
Lean 还有一个可选语法，用于按名称提供参数。
但是，通常参数名称的选择不如结构字段名称的选择重要，因为它不构成 API 的很大一部分。

-- In C# or Java, {CSharp}`Nat` could be defined as follows:
在 C# 或 Java 中，{CSharp}`Nat` 可以定义如下：

```CSharp
abstract class Nat {}
class Zero : Nat {}
class Succ : Nat {
    public Nat n;
    public Succ(Nat pred) {
        n = pred;
    }
}
```

-- Just as in the {anchorName Bool}`Bool` example above, this defines more types than the Lean equivalent.
-- Additionally, this example highlights how Lean datatype constructors are much more like subclasses of an abstract class than they are like constructors in C# or Java, as the constructor shown here contains initialization code to be executed.

就像上面的 {anchorName Bool}`Bool` 示例一样，这定义了比 Lean 等价物更多的类型。
此外，这个示例突出了 Lean 数据类型构造器更像抽象类的子类，而不像 C# 或 Java 中的构造器，因为这里显示的构造器包含要执行的初始化代码。

-- Sum types are also similar to using a string tag to encode discriminated unions in TypeScript.
-- In TypeScript, {typescript}`Nat` could be defined as follows:
和类型也类似于在 TypeScript 中使用字符串标签来编码识别联合。
在 TypeScript 中，{typescript}`Nat` 可以定义如下：

-- Sum types are also similar to using a string tag to encode discriminated unions in TypeScript.
-- In TypeScript, {typescript}`Nat` could be defined as follows:
和类型也类似于在 TypeScript 中使用字符串标签来编码识别联合。
在 TypeScript 中，{typescript}`Nat` 可以定义如下：

```typescript
interface Zero {
    tag: "zero";
}

interface Succ {
    tag: "succ";
    predecessor: Nat;
}

type Nat = Zero | Succ;
```

-- Just like C# and Java, this encoding ends up with more types than in Lean, because {typescript}`Zero` and {typescript}`Succ` are each a type on their own.
-- It also illustrates that Lean constructors correspond to objects in JavaScript or TypeScript that include a tag that identifies the contents.
就像 C# 和 Java 一样，这种编码最终比 Lean 中的类型更多，因为 {typescript}`Zero` 和 {typescript}`Succ` 各自都是一个类型。
它也说明了 Lean 构造器对应于 JavaScript 或 TypeScript 中包含标识内容标签的对象。

-- # Pattern Matching
# 模式匹配
%%%
tag := "pattern-matching"
%%%

-- In many languages, these kinds of data are consumed by first using an instance-of operator to check which subclass has been received and then reading the values of the fields that are available in the given subclass.
-- The instance-of check determines which code to run, ensuring that the data needed by this code is available, while the fields themselves provide the data.
-- In Lean, both of these purposes are simultaneously served by _pattern matching_.
在许多语言中，这些类型的数据通过首先使用实例检查操作符来检查收到的是哪个子类，然后读取给定子类中可用字段的值来使用。
实例检查确定运行哪些代码，确保该代码所需的数据可用，而字段本身提供数据。
在 Lean 中，这两个目的同时由 *模式匹配（Pattern Matching）* 完成。

-- An example of a function that uses pattern matching is {anchorName isZero}`isZero`, which is a function that returns {anchorName isZero}`true` when its argument is {anchorName isZero}`Nat.zero`, or false otherwise.
使用模式匹配的函数示例是 {anchorName isZero}`isZero`，这是一个函数，当其参数为 {anchorName isZero}`Nat.zero` 时返回 {anchorName isZero}`true`，否则返回 false。

```anchor isZero
def isZero (n : Nat) : Bool :=
  match n with
  | Nat.zero => true
  | Nat.succ k => false
```

-- The {kw}`match` expression is provided the function's argument {anchorName isZero}`n` for destructuring.
-- If {anchorName isZero}`n` was constructed by {anchorName isZero}`Nat.zero`, then the first branch of the pattern match is taken, and the result is {anchorName isZero}`true`.
-- If {anchorName isZero}`n` was constructed by {anchorName isZero}`Nat.succ`, then the second branch is taken, and the result is {anchorName isZero}`false`.
{kw}`match` 表达式提供函数的参数 {anchorName isZero}`n` 进行解构。
如果 {anchorName isZero}`n` 由 {anchorName isZero}`Nat.zero` 构造，则采用模式匹配的第一个分支，结果为 {anchorName isZero}`true`。
如果 {anchorName isZero}`n` 由 {anchorName isZero}`Nat.succ` 构造，则采用第二个分支，结果为 {anchorName isZero}`false`。

:::paragraph
-- Step-by-step, evaluation of {anchorEvalStep isZeroZeroSteps 0}`isZero Nat.zero` proceeds as follows:
逐步地，{anchorEvalStep isZeroZeroSteps 0}`isZero Nat.zero` 的求值过程如下：

```anchorEvalSteps  isZeroZeroSteps
isZero Nat.zero
===>
match Nat.zero with
| Nat.zero => true
| Nat.succ k => false
===>
true
```
:::

:::paragraph
-- Evaluation of {anchorEvalStep isZeroFiveSteps 0}`isZero 5` proceeds similarly:
{anchorEvalStep isZeroFiveSteps 0}`isZero 5` 的求值类似地进行：

```anchorEvalSteps  isZeroFiveSteps
isZero 5
===>
isZero (Nat.succ (Nat.succ (Nat.succ (Nat.succ (Nat.succ Nat.zero)))))
===>
match Nat.succ (Nat.succ (Nat.succ (Nat.succ (Nat.succ Nat.zero)))) with
| Nat.zero => true
| Nat.succ k => false
===>
false
```
:::

-- The {anchorName isZero}`k` in the second branch of the pattern in {anchorName isZero}`isZero` is not decorative.
-- It makes the {anchorName isZero}`Nat` that is the argument to {anchorName isZero}`Nat.succ` visible, with the provided name.
-- That smaller number can then be used to compute the final result of the expression.
{anchorName isZero}`isZero` 模式第二分支中的 {anchorName isZero}`k` 不是装饰性的。
它使作为 {anchorName isZero}`Nat.succ` 参数的 {anchorName isZero}`Nat` 以提供的名称可见。
然后可以使用该较小的数字来计算表达式的最终结果。

:::paragraph
-- Just as the successor of some number $`n` is one greater than $`n` (that is, $`n + 1`), the predecessor of a number is one less than it.
-- If {anchorName pred}`pred` is a function that finds the predecessor of a {anchorName pred}`Nat`, then it should be the case that the following examples find the expected result:
正如某个数字 $`n$ 的后继比 $`n$ 大一（即 $`n + 1`），数字的前驱比它小一。
如果 {anchorName pred}`pred` 是一个查找 {anchorName pred}`Nat` 的前驱的函数，那么以下示例应该找到预期的结果：

```anchor  predFive
#eval pred 5
```

```anchorInfo predFive
4
```

```anchor predBig
#eval pred 839
```

```anchorInfo predBig
838
```
:::

:::paragraph
-- Because {anchorName Nat}`Nat` cannot represent negative numbers, {anchorName NatNames}`Nat.zero` is a bit of a conundrum.
-- Usually, when working with {anchorName Nat}`Nat`, operators that would ordinarily produce a negative number are redefined to produce {anchorName NatNames}`zero` itself:
因为 {anchorName Nat}`Nat` 不能表示负数，{anchorName NatNames}`Nat.zero` 有点让人困惑。
通常，在使用 {anchorName Nat}`Nat` 时，通常会产生负数的运算符被重新定义为产生 {anchorName NatNames}`zero` 本身：

```anchor predZero
#eval pred 0
```
```anchorInfo predZero
0
```
:::

-- To find the predecessor of a {anchorName pred}`Nat`, the first step is to check which constructor was used to create it.
-- If it was {anchorName pred}`Nat.zero`, then the result is {anchorName pred}`Nat.zero`.
-- If it was {anchorName pred}`Nat.succ`, then the name {anchorName pred}`k` is used to refer to the {anchorName plus}`Nat` underneath it.
-- And this {anchorName pred}`Nat` is the desired predecessor, so the result of the {anchorName pred}`Nat.succ` branch is {anchorName pred}`k`.
要找到 {anchorName pred}`Nat` 的前驱，第一步是检查使用哪个构造器创建它。
如果是 {anchorName pred}`Nat.zero`，则结果为 {anchorName pred}`Nat.zero`。
如果是 {anchorName pred}`Nat.succ`，则名称 {anchorName pred}`k` 用于引用其下面的 {anchorName plus}`Nat`。
这个 {anchorName pred}`Nat` 是所需的前驱，所以 {anchorName pred}`Nat.succ` 分支的结果是 {anchorName pred}`k`。

```anchor pred
def pred (n : Nat) : Nat :=
  match n with
  | Nat.zero => Nat.zero
  | Nat.succ k => k
```

:::paragraph
-- Applying this function to {anchorTerm predFiveSteps}`5` yields the following steps:
将此函数应用于 {anchorTerm predFiveSteps}`5` 产生以下步骤：

```anchorEvalSteps  predFiveSteps
pred 5
===>
pred (Nat.succ 4)
===>
match Nat.succ 4 with
| Nat.zero => Nat.zero
| Nat.succ k => k
===>
4
```
:::

:::paragraph
-- Pattern matching can be used with structures as well as with sum types.
-- For instance, a function that extracts the third dimension from a {anchorName depth}`Point3D` can be written as follows:
模式匹配可以与结构以及和类型一起使用。
例如，从 {anchorName depth}`Point3D` 提取第三维的函数可以写成如下形式：

```anchor depth
def depth (p : Point3D) : Float :=
  match p with
  | { x:= h, y := w, z := d } => d
```

-- In this case, it would have been much simpler to just use the {anchorName fragments}`Point3D.z` accessor, but structure patterns are occasionally the simplest way to write a function.
在这种情况下，只使用 {anchorName fragments}`Point3D.z` 访问器会简单得多，但结构模式有时是编写函数的最简单方法。
:::

-- # Recursive Functions
# 递归函数
%%%
tag := "recursive-functions"
%%%

-- Definitions that refer to the name being defined are called _recursive definitions_.
-- Inductive datatypes are allowed to be recursive; indeed, {anchorName Nat}`Nat` is an example of such a datatype because {anchorName Nat}`succ` demands another {anchorName Nat}`Nat`.
-- Recursive datatypes can represent arbitrarily large data, limited only by technical factors like available memory.
-- Just as it would be impossible to write down one constructor for each natural number in the datatype definition, it is also impossible to write down a pattern match case for each possibility.
引用正在定义的名称的定义称为 *递归定义（Recursive Definitions）*。
归纳数据类型允许是递归的；实际上，{anchorName Nat}`Nat` 是这种数据类型的示例，因为 {anchorName Nat}`succ` 需要另一个 {anchorName Nat}`Nat`。
递归数据类型可以表示任意大的数据，仅受可用内存等技术因素限制。
正如在数据类型定义中不可能为每个自然数写下一个构造器一样，也不可能为每种可能性写下模式匹配情况。

:::paragraph
-- Recursive datatypes are nicely complemented by recursive functions.
-- A simple recursive function over {anchorName even}`Nat` checks whether its argument is even.
-- In this case, {anchorName even}`Nat.zero` is even.
-- Non-recursive branches of the code like this one are called _base cases_.
-- The successor of an odd number is even, and the successor of an even number is odd.
-- This means that a number built with {anchorName even}`Nat.succ` is even if and only if its argument is not even.
递归数据类型与递归函数很好地互补。
在 {anchorName even}`Nat` 上的简单递归函数检查其参数是否为偶数。
在这种情况下，{anchorName even}`Nat.zero` 是偶数。
像这样的代码的非递归分支称为 *基本情况（Base Cases）*。
奇数的后继是偶数，偶数的后继是奇数。
这意味着用 {anchorName even}`Nat.succ` 构建的数字是偶数当且仅当其参数不是偶数。

```anchor even
def even (n : Nat) : Bool :=
  match n with
  | Nat.zero => true
  | Nat.succ k => not (even k)
```
:::

-- This pattern of thought is typical for writing recursive functions on {anchorName even}`Nat`.
-- First, identify what to do for {anchorName even}`Nat.zero`.
-- Then, determine how to transform a result for an arbitrary {anchorName even}`Nat` into a result for its successor, and apply this transformation to the result of the recursive call.
-- This pattern is called _structural recursion_.
这种思维模式对于在 {anchorName even}`Nat` 上编写递归函数是典型的。
首先，确定对 {anchorName even}`Nat.zero` 做什么。
然后，确定如何将任意 {anchorName even}`Nat` 的结果转换为其后继的结果，并将此转换应用于递归调用的结果。
这种模式称为 *结构递归（Structural Recursion）*。

:::paragraph
-- Unlike many languages, Lean ensures by default that every recursive function will eventually reach a base case.
-- From a programming perspective, this rules out accidental infinite loops.
-- But this feature is especially important when proving theorems, where infinite loops cause major difficulties.
-- A consequence of this is that Lean will not accept a version of {anchorName even}`even` that attempts to invoke itself recursively on the original number:
与许多语言不同，Lean 默认确保每个递归函数最终会到达基本情况。
从编程角度来看，这排除了意外的无限循环。
但这个特性在证明定理时特别重要，因为无限循环会造成重大困难。
其结果是 Lean 不会接受尝试在原始数字上递归调用自身的 {anchorName even}`even` 版本：

```anchor evenLoops
def evenLoops (n : Nat) : Bool :=
  match n with
  | Nat.zero => true
  | Nat.succ k => not (evenLoops n)
```

-- The important part of the error message is that Lean could not determine that the recursive function always reaches a base case (because it doesn't).
错误消息的重要部分是 Lean 无法确定递归函数总是到达基本情况（因为它没有）。

```anchorError evenLoops
fail to show termination for
  evenLoops
with errors
failed to infer structural recursion:
Not considering parameter n of evenLoops:
  it is unchanged in the recursive calls
no parameters suitable for structural recursion

well-founded recursion cannot be used, 'evenLoops' does not take any (non-fixed) arguments
```
:::

:::paragraph
-- Even though addition takes two arguments, only one of them needs to be inspected.
-- To add zero to a number $`n`, just return $`n`.
-- To add the successor of $`k` to $`n`, take the successor of the result of adding $`k` to $`n`.
尽管加法需要两个参数，但只需要检查其中一个。
要将零加到数字 $`n$，只需返回 $`n$。
要将 $`k$ 的后继加到 $`n$，取将 $`k$ 加到 $`n$ 的结果的后继。

```anchor plus
def plus (n : Nat) (k : Nat) : Nat :=
  match k with
  | Nat.zero => n
  | Nat.succ k' => Nat.succ (plus n k')
```
:::

:::paragraph
-- In the definition of {anchorName plus}`plus`, the name {anchorName plus}`k'` is chosen to indicate that it is connected to, but not identical with, the argument {anchorName plus}`k`.
-- For instance, walking through the evaluation of {anchorEvalStep plusThreeTwo 0}`plus 3 2` yields the following steps:
在 {anchorName plus}`plus` 的定义中，选择名称 {anchorName plus}`k'` 来表示它与参数 {anchorName plus}`k` 相关联，但不相同。
例如，走过 {anchorEvalStep plusThreeTwo 0}`plus 3 2` 的求值产生以下步骤：

```anchorEvalSteps  plusThreeTwo
plus 3 2
===>
plus 3 (Nat.succ (Nat.succ Nat.zero))
===>
match Nat.succ (Nat.succ Nat.zero) with
| Nat.zero => 3
| Nat.succ k' => Nat.succ (plus 3 k')
===>
Nat.succ (plus 3 (Nat.succ Nat.zero))
===>
Nat.succ (match Nat.succ Nat.zero with
| Nat.zero => 3
| Nat.succ k' => Nat.succ (plus 3 k'))
===>
Nat.succ (Nat.succ (plus 3 Nat.zero))
===>
Nat.succ (Nat.succ (match Nat.zero with
| Nat.zero => 3
| Nat.succ k' => Nat.succ (plus 3 k')))
===>
Nat.succ (Nat.succ 3)
===>
5
```
:::

:::paragraph
-- One way to think about addition is that $`n + k` applies {anchorName times}`Nat.succ` $`k` times to $`n`.
-- Similarly, multiplication $`n × k` adds $`n` to itself $`k` times and subtraction $`n - k` takes $`n`'s predecessor $`k` times.
思考加法的一种方法是 $`n + k` 将 {anchorName times}`Nat.succ` 应用到 $`n` 上 $`k` 次。
类似地，乘法 $`n × k` 将 $`n` 加到自身 $`k` 次，减法 $`n - k` 取 $`n` 的前驱 $`k` 次。

```anchor times
def times (n : Nat) (k : Nat) : Nat :=
  match k with
  | Nat.zero => Nat.zero
  | Nat.succ k' => plus n (times n k')
```

```anchor minus
def minus (n : Nat) (k : Nat) : Nat :=
  match k with
  | Nat.zero => n
  | Nat.succ k' => pred (minus n k')
```
:::

:::paragraph
-- Not every function can be easily written using structural recursion.
-- The understanding of addition as iterated {anchorName plus}`Nat.succ`, multiplication as iterated addition, and subtraction as iterated predecessor suggests an implementation of division as iterated subtraction.
-- In this case, if the numerator is less than the divisor, the result is zero.
-- Otherwise, the result is the successor of dividing the numerator minus the divisor by the divisor.
不是每个函数都可以使用结构递归轻松编写。
将加法理解为迭代 {anchorName plus}`Nat.succ`，乘法理解为迭代加法，减法理解为迭代前驱，这表明除法的实现是迭代减法。
在这种情况下，如果分子小于除数，结果为零。
否则，结果是将分子分子减去除数再除以除数的后继。

```anchor div
def div (n : Nat) (k : Nat) : Nat :=
  if n < k then
    0
  else Nat.succ (div (n - k) k)
```
:::

:::paragraph
-- As long as the second argument is not {anchorTerm div}`0`, this program terminates, as it always makes progress towards the base case.
-- However, it is not structurally recursive, because it doesn't follow the pattern of finding a result for zero and transforming a result for a smaller {anchorName div}`Nat` into a result for its successor.
-- In particular, the recursive invocation of the function is applied to the result of another function call, rather than to an input constructor's argument.
-- Thus, Lean rejects it with the following message:
只要第二个参数不是 {anchorTerm div}`0`，这个程序就会终止，因为它总是向基本情况进展。
但是，它不是结构递归的，因为它不遵循为零找到结果并将较小 {anchorName div}`Nat` 的结果转换为其后继结果的模式。
特别是，函数的递归调用应用于另一个函数调用的结果，而不是输入构造器的参数。
因此，Lean 用以下消息拒绝它：

```anchorError div
fail to show termination for
  div
with errors
failed to infer structural recursion:
Not considering parameter k of div:
  it is unchanged in the recursive calls
Cannot use parameter k:
  failed to eliminate recursive application
    div (n - k) k


failed to prove termination, possible solutions:
  - Use `have`-expressions to prove the remaining goals
  - Use `termination_by` to specify a different well-founded relation
  - Use `decreasing_by` to specify your own tactic for discharging this kind of goal
k n : Nat
h✝ : ¬n < k
⊢ n - k < n
```

-- This message means that {anchorName div}`div` requires a manual proof of termination.

此消息意味着 {anchorName div}`div` 需要手动终止证明。
这个主题在 *最后一章* 中探讨。
:::
