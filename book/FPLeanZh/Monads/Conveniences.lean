import VersoManual
import FPLeanZh.Examples

open Verso.Genre Manual
open Verso Code External

open FPLeanZh

set_option verso.exampleProject "../examples"
set_option verso.exampleModule "Examples.Monads.Conveniences"

-- Additional Conveniences
#doc (Manual) "其他便利功能" =>
%%%
file := "Conveniences"
tag := "monads-conveniences"
%%%


-- # Shared Argument Types
# 共享参数类型
%%%
tag := "shared-argument-types"
%%%

-- When defining a function that takes multiple arguments that have the same type, both can be written before the same colon.
-- For example,
定义具有相同类型的多个参数时，可以把它们写在同一个冒号之前。
例如：

```anchor equalHuhOld
def equal? [BEq α] (x : α) (y : α) : Option α :=
  if x == y then
    some x
  else
    none
```
-- can be written
可以写成

```anchor equalHuhNew
def equal? [BEq α] (x y : α) : Option α :=
  if x == y then
    some x
  else
    none
```
-- This is especially useful when the type signature is large.
这在类型签名很长的时候特别有用。

-- # Leading Dot Notation
# 开头的点号
%%%
tag := "leading-dot-notation"
%%%

-- The constructors of an inductive type are in a namespace.
-- This allows multiple related inductive types to use the same constructor names, but it can lead to programs becoming verbose.
-- In contexts where the inductive type in question is known, the namespace can be omitted by preceding the constructor's name with a dot, and Lean uses the expected type to resolve the constructor names.
-- For example, a function that mirrors a binary tree can be written:
一个归纳类型的所有构造子都存在于一个命名空间中。
因此允许不同的归纳类型有同名构造子，但是这也会导致程序变得啰嗦。
当问题中的归纳类型已知时，可以命名空间可以省略，只需要在构造子前保留点号，Lean可以根据该处期望的类型来决定如何选择构造子。
例如将二叉树镜像的函数：

```anchor mirrorOld
def BinTree.mirror : BinTree α → BinTree α
  | BinTree.leaf => BinTree.leaf
  | BinTree.branch l x r => BinTree.branch (mirror r) x (mirror l)
```
-- Omitting the namespaces makes it significantly shorter, at the cost of making the program harder to read in contexts like code review tools that don't include the Lean compiler:
省略命名空间使代码显著变短，但代价是在没有Lean编译器，例如code review时，代码会变得难以阅读：

```anchor mirrorNew
def BinTree.mirror : BinTree α → BinTree α
  | .leaf => .leaf
  | .branch l x r => .branch (mirror r) x (mirror l)
```

-- Using the expected type of an expression to disambiguate a namespace is also applicable to names other than constructors.
-- If {anchorName BinTreeEmpty}`BinTree.empty` is defined as an alternative way of creating {anchorName BinTreeEmpty}`BinTree`s, then it can also be used with dot notation:
通过期望的类型来消除命名空间的歧义，同样可以应用于构造子之外的名称。
例如{anchorName BinTreeEmpty}`BinTree.empty`定义为一种创建{anchorName BinTreeEmpty}`BinTree`的方式，那么它也可以和点号一起使用：

```anchor BinTreeEmpty
def BinTree.empty : BinTree α := .leaf
```
```anchor emptyDot
#check (.empty : BinTree Nat)
```
```anchorInfo emptyDot
BinTree.empty : BinTree Nat
```

-- # Or-Patterns
# 或-模式
%%%
tag := "or-patterns"
%%%

-- In contexts that allow multiple patterns, such as {kw}`match`-expressions, multiple patterns may share their result expressions.
-- The datatype {anchorName Weekday}`Weekday` that represents days of the week:
当有多个模式匹配的分支时，例如{kw}`match`表达式，那么不同的模式可以共享同一个结果表达式。
表示一周的每一天的类型{anchorName Weekday}`Weekday`：

```anchor Weekday
inductive Weekday where
  | monday
  | tuesday
  | wednesday
  | thursday
  | friday
  | saturday
  | sunday
deriving Repr
```

-- Pattern matching can be used to check whether a day is a weekend:
可以用模式匹配检查某一天是否是周末：

```anchor isWeekendA
def Weekday.isWeekend (day : Weekday) : Bool :=
  match day with
  | Weekday.saturday => true
  | Weekday.sunday => true
  | _ => false
```
-- This can already be simplified by using constructor dot notation:
首先可以用点号来简化：

```anchor isWeekendB
def Weekday.isWeekend (day : Weekday) : Bool :=
  match day with
  | .saturday => true
  | .sunday => true
  | _ => false
```
-- Because both weekend patterns have the same result expression ({anchorName isWeekendC}`true`), they can be condensed into one:
因为周末的两天都有相同的结果{anchorName isWeekendC}`true`，所以可以精简成：

```anchor isWeekendC
def Weekday.isWeekend (day : Weekday) : Bool :=
  match day with
  | .saturday | .sunday => true
  | _ => false
```
-- This can be further simplified into a version in which the argument is not named:
进一步可以简化成没有参数名称的函数：

```anchor isWeekendD
def Weekday.isWeekend : Weekday → Bool
  | .saturday | .sunday => true
  | _ => false
```

-- Behind the scenes, the result expression is simply duplicated across each pattern.
-- This means that patterns can bind variables, as in this example that removes the {anchorName SumNames}`inl` and {anchorName SumNames}`inr` constructors from a sum type in which both contain the same type of value:
实际上结果表达式只是简单地被复制。所以模式也可以绑定变量，这个例子在和类型(Sum Type)两边具有相同类型时，将{anchorName SumNames}`inl`和{anchorName SumNames}`inr`构造子去除：

```anchor condense
def condense : α ⊕ α → α
  | .inl x | .inr x => x
```
-- Because the result expression is duplicated, the variables bound by the patterns are not required to have the same types.
-- Overloaded functions that work for multiple types may be used to write a single result expression that works for patterns that bind variables of different types:
但是因为结果表达式只是被复制，所以模式绑定的变量也可以具有不同类型。
重载的函数可以让同一个结果表达式用于多个绑定不同类型的变量的模式：

```anchor stringy
def stringy : Nat ⊕ Weekday → String
  | .inl x | .inr x => s!"It is {repr x}"
```
-- In practice, only variables shared in all patterns can be referred to in the result expression, because the result must make sense for each pattern.
-- In {anchorName getTheNat}`getTheNat`, only {anchorName getTheNat}`n` can be accessed, and attempts to use either {anchorName getTheNat}`x` or {anchorName getTheNat}`y` lead to errors.
实践中，只有在所有模式都存在的变量才可以在结果表达式中引用，因为这条表达式必须对所有分支都有意义。
{anchorName getTheNat}`getTheNat`中只有{anchorName getTheNat}`n`可以被访问，使用{anchorName getTheNat}`x`或{anchorName getTheNat}`y`将会导致错误。

```anchor getTheNat
def getTheNat : (Nat × α) ⊕ (Nat × β) → Nat
  | .inl (n, x) | .inr (n, y) => n
```
-- Attempting to access {anchorName getTheAlpha}`x` in a similar definition causes an error because there is no {anchorName getTheAlpha}`x` available in the second pattern:
这种类似的情况中访问{anchorName getTheAlpha}`x`同样会导致错误，因为{anchorName getTheAlpha}`x`在第二个模式中不存在：
```anchor getTheAlpha
def getTheAlpha : (Nat × α) ⊕ (Nat × α) → α
  | .inl (n, x) | .inr (n, y) => x
```
```anchorError getTheAlpha
Unknown identifier `x`
```

-- The fact that the result expression is essentially copy-pasted to each branch of the pattern match can lead to some surprising behavior.
-- For example, the following definitions are acceptable because the {anchorName SumNames}`inr` version of the result expression refers to the global definition of {anchorName getTheString}`str`:
简单地对结果表达式进行复制，会导致某些令人惊讶的行为。
例如，下列定义是合法的，因为{anchorName SumNames}`inr`分支实际上引用的是全局定义{anchorName getTheString}`str`：

```anchor getTheString
def str := "Some string"

def getTheString : (Nat × String) ⊕ (Nat × β) → String
  | .inl (n, str) | .inr (n, y) => str
```
-- Calling this function on both constructors reveals the confusing behavior.
-- In the first case, a type annotation is needed to tell Lean which type {anchorName getTheString}`β` should be:
在不同分支上调用该函数会让人困惑。
第一种情况中，需要提供类型标记告诉Lean类型{anchorName getTheString}`β`是什么：

```anchor getOne
#eval getTheString (.inl (20, "twenty") : (Nat × String) ⊕ (Nat × String))
```
```anchorInfo getOne
"twenty"
```
-- In the second case, the global definition is used:
第二种情况被使用的是全局定义：

```anchor getTwo
#eval getTheString (.inr (20, "twenty"))
```
```anchorInfo getTwo
"Some string"
```

-- Using or-patterns can vastly simplify some definitions and increase their clarity, as in {anchorName isWeekendD}`Weekday.isWeekend`.
-- Because there is a potential for confusing behavior, it's a good idea to be careful when using them, especially when variables of multiple types or disjoint sets of variables are involved.
使用或-模式可以极大简化某些定义，让它们更加清晰，例如{anchorName isWeekendD}`Weekday.isWeekend`。
但因为存在可能导致困惑的行为，需要十分小心地使用，特别是涉及不同类型的变量，或不相交的变量集合时。
