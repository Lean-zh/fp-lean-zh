import VersoManual
import FPLeanZh.Examples

open Verso.Genre Manual
open Verso Code External

open FPLeanZh

set_option verso.exampleProject "../examples"
set_option verso.exampleModule "Examples.Monads.Class"

-- Example: Arithmetic in Monads
#doc (Manual) "例子：利用单子实现算术表达式求值" =>
%%%
file := "Arithmetic"
tag := "monads-arithmetic-example"
%%%

-- Monads are a way of encoding programs with side effects into a language that does not have them.
-- It would be easy to read this as a sort of admission that pure functional programs are missing something important, requiring programmers to jump through hoops just to write a normal program.
-- However, while using the {moduleName}`Monad` API does impose a syntactic cost on a program, it brings two important benefits:
-- 1. Programs must be honest about which effects they use in their types. A quick glance at a type signature describes _everything_ that the program can do, rather than just what it accepts and what it returns.
-- 2. Not every language provides the same effects. For example, only some languages have exceptions. Other languages have unique, exotic effects, such as [Icon's searching over multiple values](https://www2.cs.arizona.edu/icon/) and Scheme or Ruby's continuations. Because monads can encode _any_ effect, programmers can choose which ones are the best fit for a given application, rather than being stuck with what the language developers provided.

单子是一种将具有副作用的程序编入没有副作用的语言中的范式。
但很容易将此误解为：承认纯函数式编程缺少一些重要的东西，程序员要越过这些障碍才能编写一个普通的程序。
虽然使用 {moduleName}`Monad` API 确实给程序带来了语法上的成本，但它带来了两个重要的优点：
 1. 程序必须在类型中诚实地告知它们使用的作用。因此看一眼类型签名就可以知道程序能做的所有事情，而不只是知道它接受什么和返回什么。
 2. 并非每种语言都提供相同的作用。例如只有某些语言有异常。其他语言具有独特的新奇作用，例如 [Icon's searching over multiple values](https://www2.cs.arizona.edu/icon/) 以及 Scheme 或 Ruby 的 continuations。由于单子可以编码 _任何_ 作用，因此程序员可以选择最适合给定应用的作用，而不是局限于语言开发者提供的作用。

-- One example of a program that can make sense in a variety of monads is an evaluator for arithmetic expressions.

对许多单子都有意义的一个例子是算术表达式的求值器。

-- # Arithmetic Expressions
# Arithmetic Expressions
%%%
tag := "monads-arithmetic-example-expr"
%%%

-- An arithmetic expression is either a literal integer or a primitive binary operator applied to two expressions. The operators are addition, subtraction, multiplication, and division:

一条算术表达式要么是一个字面量整数，要么是应用于两个表达式的原始二元运算符。运算符包括加法、减法、乘法和除法：

```anchor ExprArith
inductive Expr (op : Type) where
  | const : Int → Expr op
  | prim : op → Expr op → Expr op → Expr op


inductive Arith where
  | plus
  | minus
  | times
  | div
```

-- The expression {lit}`2 + 3` is represented:

表达式 {lit}`2 + 3` 表示为：

```anchor twoPlusThree
open Expr in
open Arith in
def twoPlusThree : Expr Arith :=
  prim plus (const 2) (const 3)
```
-- and {lit}`14 / (45 - 5 * 9)` is represented:

而 {lit}`14 / (45 - 5 * 9)` 表示为：
```anchor exampleArithExpr
open Expr in
open Arith in
def fourteenDivided : Expr Arith :=
  prim div (const 14)
    (prim minus (const 45)
      (prim times (const 5)
        (const 9)))
```

-- # Evaluating Expressions
# Evaluating Expressions
%%%
tag := "monads-arithmetic-example-eval"
%%%

-- Because expressions include division, and division by zero is undefined, evaluation might fail.
-- One way to represent failure is to use {anchorName evaluateOptionCommingled}`Option`:

由于表达式包含除法，而除以零是未定义的，因此求值可能会失败。
表示失败的一种方法是使用 {anchorName evaluateOptionCommingled}`Option`：

```anchor evaluateOptionCommingled
def evaluateOption : Expr Arith → Option Int
  | Expr.const i => pure i
  | Expr.prim p e1 e2 =>
    evaluateOption e1 >>= fun v1 =>
    evaluateOption e2 >>= fun v2 =>
    match p with
    | Arith.plus => pure (v1 + v2)
    | Arith.minus => pure (v1 - v2)
    | Arith.times => pure (v1 * v2)
    | Arith.div => if v2 == 0 then none else pure (v1 / v2)
```

-- This definition uses the {anchorTerm MonadOptionExcept}`Monad Option` instance to propagate failures from evaluating both branches of a binary operator.
-- However, the function mixes two concerns: evaluating subexpressions and applying a binary operator to the results.
-- It can be improved by splitting it into two functions:

此定义使用 {anchorTerm MonadOptionExcept}`Monad Option` 实例来传播从二元运算符的两个分支求值产生的失败。
然而该函数混合了两个问题：对子表达式的求值和对运算符的计算。
可以将其拆分为两个函数：

```anchor evaluateOptionSplit
def applyPrim : Arith → Int → Int → Option Int
  | Arith.plus, x, y => pure (x + y)
  | Arith.minus, x, y => pure (x - y)
  | Arith.times, x, y => pure (x * y)
  | Arith.div, x, y => if y == 0 then none else pure (x / y)

def evaluateOption : Expr Arith → Option Int
  | Expr.const i => pure i
  | Expr.prim p e1 e2 =>
    evaluateOption e1 >>= fun v1 =>
    evaluateOption e2 >>= fun v2 =>
    applyPrim p v1 v2
```

-- Running {anchorTerm fourteenDivOption}`#eval evaluateOption fourteenDivided` yields {anchorInfo fourteenDivOption}`none`, as expected, but this is not a very useful error message.
-- Because the code was written using {lit}`>>=` rather than by explicitly handling the {anchorName MonadOptionExcept}`none` constructor, only a small modification is required for it to provide an error message on failure:

运行 {anchorTerm fourteenDivOption}`#eval evaluateOption fourteenDivided` 产生 {anchorInfo fourteenDivOption}`none`，与预期一样，但这个报错信息却并不十分有用。
由于代码使用 {lit}`>>=` 而非显式处理 {anchorName MonadOptionExcept}`none` 构造子，所以只需少量修改即可在失败时提供错误消息：

```anchor evaluateExcept
def applyPrim : Arith → Int → Int → Except String Int
  | Arith.plus, x, y => pure (x + y)
  | Arith.minus, x, y => pure (x - y)
  | Arith.times, x, y => pure (x * y)
  | Arith.div, x, y =>
    if y == 0 then
      Except.error s!"Tried to divide {x} by zero"
    else pure (x / y)

def evaluateExcept : Expr Arith → Except String Int
  | Expr.const i => pure i
  | Expr.prim p e1 e2 =>
    evaluateExcept e1 >>= fun v1 =>
    evaluateExcept e2 >>= fun v2 =>
    applyPrim p v1 v2
```
-- The only difference is that the type signature mentions {anchorTerm evaluateExcept}`Except String` instead of {anchorName Names}`Option`, and the failing case uses {anchorName evaluateExcept}`Except.error` instead of {anchorName evaluateM}`none`.
-- By making the evaluator polymorphic over its monad and passing it {anchorName evaluateM}`applyPrim` as an argument, a single evaluator becomes capable of both forms of error reporting:

唯一区别是：类型签名提到的是 {anchorTerm evaluateExcept}`Except String` 而非 {anchorName Names}`Option`，并且失败时使用 {anchorName evaluateExcept}`Except.error` 而不是 {anchorName evaluateM}`none`。
通过让求值器对单子多态，并将 {anchorName evaluateM}`applyPrim` 作为参数传递，单个求值器就足够以两种形式报告错误：

```anchor evaluateM
def applyPrimOption : Arith → Int → Int → Option Int
  | Arith.plus, x, y => pure (x + y)
  | Arith.minus, x, y => pure (x - y)
  | Arith.times, x, y => pure (x * y)
  | Arith.div, x, y =>
    if y == 0 then
      none
    else pure (x / y)

def applyPrimExcept : Arith → Int → Int → Except String Int
  | Arith.plus, x, y => pure (x + y)
  | Arith.minus, x, y => pure (x - y)
  | Arith.times, x, y => pure (x * y)
  | Arith.div, x, y =>
    if y == 0 then
      Except.error s!"Tried to divide {x} by zero"
    else pure (x / y)

def evaluateM [Monad m]
    (applyPrim : Arith → Int → Int → m Int) :
    Expr Arith → m Int
  | Expr.const i => pure i
  | Expr.prim p e1 e2 =>
    evaluateM applyPrim e1 >>= fun v1 =>
    evaluateM applyPrim e2 >>= fun v2 =>
    applyPrim p v1 v2
```

-- Using it with {anchorName evaluateMOption}`applyPrimOption` works just like the first evaluator:

将其与 {anchorName evaluateMOption}`applyPrimOption` 一起使用作用就和最初的求值器一样：
```anchor evaluateMOption
#eval evaluateM applyPrimOption fourteenDivided
```
```anchorInfo evaluateMOption
none
```
-- Similarly, using it with {anchorName evaluateMExcept}`applyPrimExcept` works just like the version with error messages:

类似地，和 {anchorName evaluateMExcept}`applyPrimExcept` 函数一起使用时作用与带有错误消息的版本相同：
```anchor evaluateMExcept
#eval evaluateM applyPrimExcept fourteenDivided
```
```anchorInfo evaluateMExcept
Except.error "Tried to divide 14 by zero"
```

-- The code can still be improved.
-- The functions {anchorName evaluateMOption}`applyPrimOption` and {anchorName evaluateMExcept}`applyPrimExcept` differ only in their treatment of division, which can be extracted into another parameter to the evaluator:

代码仍有改进空间。
{anchorName evaluateMOption}`applyPrimOption` 和 {anchorName evaluateMExcept}`applyPrimExcept` 函数仅在除法处理上有所不同，因此可以将它提取到另一个参数中：

```anchor evaluateMRefactored
def applyDivOption (x : Int) (y : Int) : Option Int :=
    if y == 0 then
      none
    else pure (x / y)

def applyDivExcept (x : Int) (y : Int) : Except String Int :=
    if y == 0 then
      Except.error s!"Tried to divide {x} by zero"
    else pure (x / y)

def applyPrim [Monad m]
    (applyDiv : Int → Int → m Int) :
    Arith → Int → Int → m Int
  | Arith.plus, x, y => pure (x + y)
  | Arith.minus, x, y => pure (x - y)
  | Arith.times, x, y => pure (x * y)
  | Arith.div, x, y => applyDiv x y

def evaluateM [Monad m]
    (applyDiv : Int → Int → m Int) :
    Expr Arith → m Int
  | Expr.const i => pure i
  | Expr.prim p e1 e2 =>
    evaluateM applyDiv e1 >>= fun v1 =>
    evaluateM applyDiv e2 >>= fun v2 =>
    applyPrim applyDiv p v1 v2
```

-- In this refactored code, the fact that the two code paths differ only in their treatment of failure has been made fully apparent.

在重构后的代码中，两条路径仅在对失败情况的处理上有所不同，这一事实显而易见。

-- # Further Effects
# Further Effects
%%%
tag := "monads-arithmetic-example-effects"
%%%

-- Failure and exceptions are not the only kinds of effects that can be interesting when working with an evaluator.
-- While division's only side effect is failure, adding other primitive operators to the expressions make it possible to express other effects.

在考虑求值器时，失败和异常并不是唯一值得在意的作用。虽然除法的唯一副作用是失败，但若要增加其他运算符的支持，则可能需要表达对应的作用。

-- The first step is an additional refactoring, extracting division from the datatype of primitives:

第一步是重构，从原始数据类型中提取除法：

```anchor PrimCanFail
inductive Prim (special : Type) where
  | plus
  | minus
  | times
  | other : special → Prim special

inductive CanFail where
  | div
```
-- The name {anchorName PrimCanFail}`CanFail` suggests that the effect introduced by division is potential failure.

名称 {anchorName PrimCanFail}`CanFail` 表明被除法引入的作用是可能发生的失败。

-- The second step is to broaden the scope of the division handler argument to {anchorName evaluateMMorePoly}`evaluateM` so that it can process any special operator:

第二步是将除法处理器的参数扩展到 {anchorName evaluateMMorePoly}`evaluateM`，以便它可以处理任何特殊运算符：

```anchor evaluateMMorePoly
def divOption : CanFail → Int → Int → Option Int
  | CanFail.div, x, y => if y == 0 then none else pure (x / y)

def divExcept : CanFail → Int → Int → Except String Int
  | CanFail.div, x, y =>
    if y == 0 then
      Except.error s!"Tried to divide {x} by zero"
    else pure (x / y)

def applyPrim [Monad m]
    (applySpecial : special → Int → Int → m Int) :
    Prim special → Int → Int → m Int
  | Prim.plus, x, y => pure (x + y)
  | Prim.minus, x, y => pure (x - y)
  | Prim.times, x, y => pure (x * y)
  | Prim.other op, x, y => applySpecial op x y

def evaluateM [Monad m]
    (applySpecial : special → Int → Int → m Int) :
    Expr (Prim special) → m Int
  | Expr.const i => pure i
  | Expr.prim p e1 e2 =>
    evaluateM applySpecial e1 >>= fun v1 =>
    evaluateM applySpecial e2 >>= fun v2 =>
    applyPrim applySpecial p v1 v2
```

-- ## No Effects
## No Effects
%%%
tag := "monads-arithmetic-example-no-effects"
%%%

-- The type {anchorName applyEmpty}`Empty` has no constructors, and thus no values, like the {Kotlin}`Nothing` type in Scala or Kotlin.
-- In Scala and Kotlin, {Kotlin}`Nothing` can represent computations that never return a result, such as functions that crash the program, throw exceptions, or always fall into infinite loops.
-- An argument to a function or method of type {Kotlin}`Nothing` indicates dead code, as there will never be a suitable argument value.
-- Lean doesn't support infinite loops and exceptions, but {anchorName applyEmpty}`Empty` is still useful as an indication to the type system that a function cannot be called.
-- Using the syntax {anchorTerm nomatch}`nomatch E` when {anchorName nomatch}`E` is an expression whose type has no constructors indicates to Lean that the current expression need not return a result, because it could never have been called.

类型 {anchorName applyEmpty}`Empty` 没有构造子，因此没有任何取值，就像Scala或Kotlin中的 {Kotlin}`Nothing` 类型。
在Scala和Kotlin中，{Kotlin}`Nothing` 可以表示永不返回结果的计算，例如导致程序崩溃、或引发异常、或陷入无限循环的函数。
参数类型为 {Kotlin}`Nothing` 表示函数是死代码，因为我们永远无法构造出合适的参数值来调用它。
Lean 不支持无限循环和异常，但 {anchorName applyEmpty}`Empty` 仍然可作为向类型系统说明函数不可被调用的标志。
当 {anchorName nomatch}`E` 是一条表达式，但它的类型没有任何取值时，使用语法 {anchorTerm nomatch}`nomatch E` 向Lean说明当前表达式不返回结果，因为它永远不会被调用。

-- Using {anchorName applyEmpty}`Empty` as the parameter to {anchorName PrimCanFail}`Prim` indicates that there are no additional cases beyond {anchorName evaluateMMorePoly}`Prim.plus`, {anchorName evaluateMMorePoly}`Prim.minus`, and {anchorName evaluateMMorePoly}`Prim.times`, because it is impossible to come up with a value of type {anchorName nomatch}`Empty` to place in the {anchorName evaluateMMorePoly}`Prim.other` constructor.
-- Because a function to apply an operator of type {anchorName nomatch}`Empty` to two integers can never be called, it doesn't need to return a result.
-- Thus, it can be used in _any_ monad:

将 {anchorName applyEmpty}`Empty` 用作 {anchorName PrimCanFail}`Prim` 的参数，表示除了 {anchorName evaluateMMorePoly}`Prim.plus`、{anchorName evaluateMMorePoly}`Prim.minus` 和 {anchorName evaluateMMorePoly}`Prim.times` 之外没有其他情况，因为不可能找到一个类型为 {anchorName nomatch}`Empty` 的值来放在 {anchorName evaluateMMorePoly}`Prim.other` 构造子中。
由于类型为 {anchorName nomatch}`Empty` 的运算符应用于两个整数的函数永远不会被调用，所以它不需要返回结果。
因此，它可以在 _任何_ 单子中使用：

```anchor applyEmpty
def applyEmpty [Monad m] (op : Empty) (_ : Int) (_ : Int) : m Int :=
  nomatch op
```
-- This can be used together with {anchorName evalId}`Id`, the identity monad, to evaluate expressions that have no effects whatsoever:

这可以与恒等单子 {anchorName evalId}`Id` 一起使用，用来计算没有任何副作用的表达式：
```anchor evalId
open Expr Prim in
#eval evaluateM (m := Id) applyEmpty (prim plus (const 5) (const (-14)))
```
```anchorInfo evalId
-9
```

-- ## Nondeterministic Search
## Nondeterministic Search
%%%
tag := "nondeterministic-search"
%%%

-- Instead of simply failing when encountering division by zero, it would also be sensible to backtrack and try a different input.
-- Given the right monad, the very same {anchorName evalId}`evaluateM` can perform a nondeterministic search for a _set_ of answers that do not result in failure.
-- This requires, in addition to division, some means of specifying a choice of results.
-- One way to do this is to add a function {lit}`choose` to the language of expressions that instructs the evaluator to pick either of its arguments while searching for non-failing results.

遇到除以零时，除了直接失败并结束之外，还可以回溯并尝试不同的输入。
给定适当的单子，同一个 {anchorName evalId}`evaluateM` 可以对不致失败的答案 _集合_ 执行非确定性搜索。
这要求除了除法之外，还需要指定选择结果的方式。
一种方法是在表达式的语言中添加一个函数 {lit}`choose`，告诉求值器在搜索非失败结果时选择其中一个参数。

-- The result of the evaluator is now a multiset of values, rather than a single value.
-- The rules for evaluation into a multiset are:
-- * Constants $`n` evaluate to singleton sets $`\{n\}`.
-- * Arithmetic operators other than division are called on each pair from the Cartesian product of the operators, so $`X + Y` evaluates to $`\{ x + y \mid x ∈ X, y ∈ Y \}`.
-- * Division $`X / Y` evaluates to $`\{ x / y \mid x ∈ X, y ∈ Y, y ≠ 0\}`. In other words, all $`0` values in $`Y`  are thrown out.
-- * A choice $`\mathrm{choose}(x, y)` evaluates to $`\{ x, y \}`.

求值结果现在变成一个多重集合，而不是一个单一值。
求值到多重集合的规则如下：
 * 常量 $`n` 求值为单元素集合 $`\{n\}`。
 * 除法以外的算术运算符作用于两个参数的笛卡尔积中的每一对，所以 $`X + Y` 求值为 $`\{ x + y \mid x ∈ X, y ∈ Y \}`。
 * 除法 $`X / Y` 求值为 $`\{ x / y \mid x ∈ X, y ∈ Y, y ≠ 0\}`。换句话说，所有 $`Y` 中的 $`0` 都被丢弃。
 * 选择 $`\mathrm{choose}(x, y)` 求值为 $`\{ x, y \}`。

-- For example, $`1 + \mathrm{choose}(2, 5)` evaluates to $`\{ 3, 6 \}`, $`1 + 2 / 0` evaluates to $`\{\}`, and $`90 / (\mathrm{choose}(-5, 5) + 5)` evaluates to $`\{ 9 \}`.
-- Using multisets instead of true sets simplifies the code by removing the need to check for uniqueness of elements.

例如，$`1 + \mathrm{choose}(2, 5)` 求值为 $`\{ 3, 6 \}`，$`1 + 2 / 0` 求值为 $`\{\}`，并且 $`90 / (\mathrm{choose}(-5, 5) + 5)` 求值为 $`\{ 9 \}`。
使用多重集合而非集合，是为了避免处理元素重复的情况而使代码过于复杂。

-- A monad that represents this non-deterministic effect must be able to represent a situation in which there are no answers, and a situation in which there is at least one answer together with any remaining answers:

表示这种非确定性作用的单子必须能够处理没有答案的情况，以及至少有一个答案和其他答案的情况：

```anchor Many (module := Examples.Monads.Many)
inductive Many (α : Type) where
  | none : Many α
  | more : α → (Unit → Many α) → Many α
```
-- This datatype looks very much like {anchorName fromList (module:=Examples.Monads.Many)}`List`.
-- The difference is that where {anchorName etc}`List.cons` stores the rest of the list, {anchorName Many (module:=Examples.Monads.Many)}`more` stores a function that should compute the remaining values on demand.
-- This means that a consumer of {anchorName Many (module:=Examples.Monads.Many)}`Many` can stop the search when some number of results have been found.

该数据类型看起来非常像 {anchorName fromList (module:=Examples.Monads.Many)}`List`。
不同之处在于，{anchorName etc}`List.cons` 存储列表的其余部分，而 {anchorName Many (module:=Examples.Monads.Many)}`more` 存储一个函数，该函数应计算剩余的值。
这意味着 {anchorName Many (module:=Examples.Monads.Many)}`Many` 的使用者可以在找到一定数量的结果后停止搜索。

-- A single result is represented by a {anchorName Many (module:=Examples.Monads.Many)}`more` constructor that returns no further results:

单个结果由 {anchorName Many (module:=Examples.Monads.Many)}`more` 构造子表示，该构造子不返回任何进一步的结果：

```anchor one (module := Examples.Monads.Many)
def Many.one (x : α) : Many α := Many.more x (fun () => Many.none)
```

-- The union of two multisets of results can be computed by checking whether the first multiset is empty.
-- If so, the second multiset is the union.
-- If not, the union consists of the first element of the first multiset followed by the union of the rest of the first multiset with the second multiset:

两个作为结果的多重集合的并集，可以通过检查第一个是否为空来计算。
如果第一个为空则第二个多重集合就是并集。
如果非空，则并集由第一个多重集合的第一个元素，紧跟着其余部分与第二个多重集的并集：

```anchor union (module := Examples.Monads.Many)
def Many.union : Many α → Many α → Many α
  | Many.none, ys => ys
  | Many.more x xs, ys => Many.more x (fun () => union (xs ()) ys)
```

-- It can be convenient to start a search process with a list of values.
-- {anchorName fromList (module:=Examples.Monads.Many)}`Many.fromList` converts a list into a multiset of results:

对值列表搜索会比手动构造多重集合更方便。
{anchorName fromList (module:=Examples.Monads.Many)}`Many.fromList` 将列表转换为结果的多重集合：

```anchor fromList (module := Examples.Monads.Many)
def Many.fromList : List α → Many α
  | [] => Many.none
  | x :: xs => Many.more x (fun () => fromList xs)
```

-- Similarly, once a search has been specified, it can be convenient to extract either a number of values, or all the values:

类似地，一旦搜索已经确定，就可以方便地提取固定数量的值或所有值：

```anchor take (module := Examples.Monads.Many)
def Many.take : Nat → Many α → List α
  | 0, _ => []
  | _ + 1, Many.none => []
  | n + 1, Many.more x xs => x :: (xs ()).take n

def Many.takeAll : Many α → List α
  | Many.none => []
  | Many.more x xs => x :: (xs ()).takeAll
```

-- A {anchorTerm MonadMany (module:=Examples.Monads.Many)}`Monad Many` instance requires a {anchorName MonadContract}`bind` operator.
-- In a nondeterministic search, sequencing two operations consists of taking all possibilities from the first step and running the rest of the program on each of them, taking the union of the results.
-- In other words, if the first step returns three possible answers, the second step needs to be tried for all three.
-- Because the second step can return any number of answers for each input, taking their union represents the entire search space.

{anchorTerm MonadMany (module:=Examples.Monads.Many)}`Monad Many` 实例需要一个 {anchorName MonadContract}`bind` 运算符。
在非确定性搜索中，对两个操作进行排序包括：从第一步中获取所有可能性，并对每种可能性都运行程序的其余部分，取结果的并集。
换句话说，如果第一步返回三个可能的答案，则需要对这三个答案分别尝试第二步。
由于第二步为每个输入都可以返回任意数量的答案，因此取它们的并集表示整个搜索空间。

```anchor bind (module := Examples.Monads.Many)
def Many.bind : Many α → (α → Many β) → Many β
  | Many.none, _ =>
    Many.none
  | Many.more x xs, f =>
    (f x).union (bind (xs ()) f)
```

-- {anchorName MonadMany (module:=Examples.Monads.Many)}`Many.one` and {anchorName MonadMany (module:=Examples.Monads.Many)}`Many.bind` obey the monad contract.
-- To check that {anchorTerm bindLeft (module:=Examples.Monads.Many)}`Many.bind (Many.one v) f` is the same as {anchorTerm bindLeft (module:=Examples.Monads.Many)}`f v`, start by evaluating the expression as far as possible:

{anchorName MonadMany (module:=Examples.Monads.Many)}`Many.one` 和 {anchorName MonadMany (module:=Examples.Monads.Many)}`Many.bind` 遵循单子约定。
要检查 {anchorTerm bindLeft (module:=Examples.Monads.Many)}`Many.bind (Many.one v) f` 是否与 {anchorTerm bindLeft (module:=Examples.Monads.Many)}`f v` 相同，首先应最大限度地计算表达式：
```anchorEvalSteps bindLeft (module := Examples.Monads.Many)
Many.bind (Many.one v) f
===>
Many.bind (Many.more v (fun () => Many.none)) f
===>
(f v).union (Many.bind Many.none f)
===>
(f v).union Many.none
```
-- The empty multiset is a right identity of {anchorName union (module:=Examples.Monads.Many)}`union`, so the answer is equivalent to {anchorTerm bindLeft (module:=Examples.Monads.Many)}`f v`.
-- To check that {anchorTerm bindOne (module:=Examples.Monads.Many)}`Many.bind v Many.one` is the same as {anchorName bindOne (module:=Examples.Monads.Many)}`v`, consider that {anchorName bindOne (module:=Examples.Monads.Many)}`Many.bind` takes the union of applying {anchorName one (module:=Examples.Monads.Many)}`Many.one` to each element of {anchorName bindOne (module:=Examples.Monads.Many)}`v`.
-- In other words, if {anchorName bindOne (module:=Examples.Monads.Many)}`v` has the form {anchorTerm vSet (module:=Examples.Monads.Many)}`{v₁, v₂, v₃, …, vₙ}`, then {anchorTerm bindOne (module:=Examples.Monads.Many)}`Many.bind v Many.one` is {anchorTerm vSets (module:=Examples.Monads.Many)}`{v₁} ∪ {v₂} ∪ {v₃} ∪ … ∪ {vₙ}`, which is {anchorTerm vSet (module:=Examples.Monads.Many)}`{v₁, v₂, v₃, …, vₙ}`.

空集是 {anchorName union (module:=Examples.Monads.Many)}`union` 的右单位元，因此答案等同于 {anchorTerm bindLeft (module:=Examples.Monads.Many)}`f v`。
要检查 {anchorTerm bindOne (module:=Examples.Monads.Many)}`Many.bind v Many.one` 是否与 {anchorName bindOne (module:=Examples.Monads.Many)}`v` 相同，需要考虑 {anchorName bindOne (module:=Examples.Monads.Many)}`Many.bind` 取 {anchorName one (module:=Examples.Monads.Many)}`Many.one` 应用于 {anchorName bindOne (module:=Examples.Monads.Many)}`v` 的每个元素的并集。
换句话说，如果 {anchorName bindOne (module:=Examples.Monads.Many)}`v` 的形式为 {anchorTerm vSet (module:=Examples.Monads.Many)}`{v₁, v₂, v₃, …, vₙ}`，则 {anchorTerm bindOne (module:=Examples.Monads.Many)}`Many.bind v Many.one` 是 {anchorTerm vSets (module:=Examples.Monads.Many)}`{v₁} ∪ {v₂} ∪ {v₃} ∪ … ∪ {vₙ}`，即 {anchorTerm vSet (module:=Examples.Monads.Many)}`{v₁, v₂, v₃, …, vₙ}`。

-- Finally, to check that {anchorName bind (module:=Examples.Monads.Many)}`Many.bind` is associative, check that {anchorTerm bindBindLeft (module:=Examples.Monads.Many)}`Many.bind (Many.bind v f) g` is the same as {anchorTerm bindBindRight (module:=Examples.Monads.Many)}`Many.bind v (fun x => Many.bind (f x) g)`.
-- If {anchorName bindBindRight (module:=Examples.Monads.Many)}`v` has the form {anchorTerm vSet (module:=Examples.Monads.Many)}`{v₁, v₂, v₃, …, vₙ}`, then:

最后，要检查 {anchorName bind (module:=Examples.Monads.Many)}`Many.bind` 是否满足结合律，需要检查 {anchorTerm bindBindLeft (module:=Examples.Monads.Many)}`Many.bind (Many.bind v f) g` 是否与 {anchorTerm bindBindRight (module:=Examples.Monads.Many)}`Many.bind v (fun x => Many.bind (f x) g)` 相同。
如果 {anchorName bindBindRight (module:=Examples.Monads.Many)}`v` 的形式为 {anchorTerm vSet (module:=Examples.Monads.Many)}`{v₁, v₂, v₃, …, vₙ}`，则：
```anchorEvalSteps bindUnion (module := Examples.Monads.Many)
Many.bind v f
===>
f v₁ ∪ f v₂ ∪ f v₃ ∪ … ∪ f vₙ
```
which means that
```anchorEvalSteps bindBindLeft (module := Examples.Monads.Many)
Many.bind (Many.bind v f) g
===>
Many.bind (f v₁) g ∪
Many.bind (f v₂) g ∪
Many.bind (f v₃) g ∪
… ∪
Many.bind (f vₙ) g
```
Similarly,
```anchorEvalSteps bindBindRight (module := Examples.Monads.Many)
Many.bind v (fun x => Many.bind (f x) g)
===>
(fun x => Many.bind (f x) g) v₁ ∪
(fun x => Many.bind (f x) g) v₂ ∪
(fun x => Many.bind (f x) g) v₃ ∪
… ∪
(fun x => Many.bind (f x) g) vₙ
===>
Many.bind (f v₁) g ∪
Many.bind (f v₂) g ∪
Many.bind (f v₃) g ∪
… ∪
Many.bind (f vₙ) g
```
-- Thus, both sides are equal, so {anchorName bindAssoc (module:=Examples.Monads.Many)}`Many.bind` is associative.

因此两边相等，所以 {anchorName bindAssoc (module:=Examples.Monads.Many)}`Many.bind` 满足结合律。

-- The resulting monad instance is:

由此得到的单子实例为：

```anchor MonadMany (module := Examples.Monads.Many)
instance : Monad Many where
  pure := Many.one
  bind := Many.bind
```
-- An example search using this monad finds all the combinations of numbers in a list that add to 15:

利用此单子，下例可找到列表中所有加起来等于15的数字组合：

```anchor addsTo (module := Examples.Monads.Many)
def addsTo (goal : Nat) : List Nat → Many (List Nat)
  | [] =>
    if goal == 0 then
      pure []
    else
      Many.none
  | x :: xs =>
    if x > goal then
      addsTo goal xs
    else
      (addsTo goal xs).union
        (addsTo (goal - x) xs >>= fun answer =>
         pure (x :: answer))
```
-- The search process is recursive over the list.
-- The empty list is a successful search when the goal is {anchorTerm addsTo (module:=Examples.Monads.Many)}`0`; otherwise, it fails.
-- When the list is non-empty, there are two possibilities: either the head of the list is greater than the goal, in which case it cannot participate in any successful searches, or it is not, in which case it can.
-- If the head of the list is _not_ a candidate, then the search proceeds to the tail of the list.
-- If the head is a candidate, then there are two possibilities to be combined with {anchorName union (module:=Examples.Monads.Many)}`Many.union`: either the solutions found contain the head, or they do not.
-- The solutions that do not contain the head are found with a recursive call on the tail, while the solutions that do contain it result from subtracting the head from the goal, and then attaching the head to the solutions that result from the recursive call.

对列表进行递归搜索。
当列表为空且目标为 {anchorTerm addsTo (module:=Examples.Monads.Many)}`0` 时，返回空列表表示成功；否则，返回 `Many.none` 表示失败。
当列表非空时，有两种可能性：要么列表的头部大于目标，在这种情况下它不能参与任何成功的搜索，要么它不大于，在这种情况下可以参与。
如果列表的头部 _不是_ 候选者，则对列表的尾部进行递归搜索。
如果头部是候选者，则有两种用 {anchorName union (module:=Examples.Monads.Many)}`Many.union` 合并起来的可能性：找到的解含有头部，或者不含有。
不含头部的解通过递归调用尾部找到，而含有头部的解通过从目标中减去头部，然后将头部附加到递归调用的解中得到。

-- The helper {anchorName printList (module:=Examples.Monads.Many)}`printList` ensures that one result is displayed per line:

辅助函数 {anchorName printList (module:=Examples.Monads.Many)}`printList` 确保每行显示一个结果：

```anchor printList (module := Examples.Monads.Many)
def printList [ToString α] : List α → IO Unit
  | [] => pure ()
  | x :: xs => do
    IO.println x
    printList xs
```
```anchor addsToFifteen (module := Examples.Monads.Many)
#eval printList (addsTo 15 [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]).takeAll
```
```anchorInfo addsToFifteen (module := Examples.Monads.Many)
[7, 8]
[6, 9]
[5, 10]
[4, 5, 6]
[3, 5, 7]
[3, 4, 8]
[2, 6, 7]
[2, 5, 8]
[2, 4, 9]
[2, 3, 10]
[2, 3, 4, 6]
[1, 6, 8]
[1, 5, 9]
[1, 4, 10]
[1, 3, 5, 6]
[1, 3, 4, 7]
[1, 2, 5, 7]
[1, 2, 4, 8]
[1, 2, 3, 9]
[1, 2, 3, 4, 5]
```

-- Returning to the arithmetic evaluator that produces multisets of results, the {anchorName NeedsSearch}`choose` operator can be used to nondeterministically select a value, with division by zero rendering prior selections invalid.

让我们回到产生多重集合的算术求值器，{anchorName NeedsSearch}`choose` 运算符可以用来非确定性地选择一个值，除以零会使之前的选择失效：

```anchor NeedsSearch
inductive NeedsSearch
  | div
  | choose

def applySearch : NeedsSearch → Int → Int → Many Int
  | NeedsSearch.choose, x, y =>
    Many.fromList [x, y]
  | NeedsSearch.div, x, y =>
    if y == 0 then
      Many.none
    else Many.one (x / y)
```

-- Using these operators, the earlier examples can be evaluated:

可以用这些运算符对前面的示例求值：

```anchor opening
open Expr Prim NeedsSearch
```
```anchor searchA
#eval
  (evaluateM applySearch
    (prim plus (const 1)
      (prim (other choose) (const 2)
        (const 5)))).takeAll
```
```anchorInfo searchA
[3, 6]
```
```anchor searchB
#eval
  (evaluateM applySearch
    (prim plus (const 1)
      (prim (other div) (const 2)
        (const 0)))).takeAll
```
```anchorInfo searchB
[]
```
```anchor searchC
#eval
  (evaluateM applySearch
    (prim (other div) (const 90)
      (prim plus (prim (other choose) (const (-5)) (const 5))
        (const 5)))).takeAll
```
```anchorInfo searchC
[9]
```

-- ## Custom Environments
## Custom Environments
%%%
tag := "custom-environments"
%%%

-- The evaluator can be made user-extensible by allowing strings to be used as operators, and then providing a mapping from strings to a function that implements them.
-- For example, users could extend the evaluator with a remainder operator or with one that returns the maximum of its two arguments.
-- The mapping from function names to function implementations is called an _environment_.

可以通过允许将字符串当作运算符，然后提供从字符串到它们的实现函数之间的映射，使求值器可由用户扩展。
例如，用户可以用余数运算或最大值运算来扩展求值器。
从函数名称到函数实现的映射称为 _环境_。

-- The environments needs to be passed in each recursive call.
-- Initially, it might seem that {anchorName evaluateM}`evaluateM` needs an extra argument to hold the environment, and that this argument should be passed to each recursive invocation.
-- However, passing an argument like this is another form of monad, so an appropriate {anchorName evaluateM}`Monad` instance allows the evaluator to be used unchanged.

环境需要在每层递归调用之间传递。
因此一开始 {anchorName evaluateM}`evaluateM` 看起来需要一个额外的参数来保存环境，并且该参数需要在每次递归调用时传递。
然而，像这样传递参数是单子的另一种形式，因此一个适当的 {anchorName evaluateM}`Monad` 实例允许求值器本身保持不变。

-- Using functions as a monad is typically called a _reader_ monad.
-- When evaluating expressions in the reader monad, the following rules are used:
-- * Constants $`n` evaluate to constant functions $`λ e . n`,
-- * Arithmetic operators evaluate to functions that pass their arguments on, so $`f + g` evaluates to $`λ e . f(e) + g(e)`, and
-- * Custom operators evaluate to the result of applying the custom operator to the arguments, so $`f \ \mathrm{OP}\ g` evaluates to
--   $$`
--     λ e .
--     \begin{cases}
--     h(f(e), g(e)) & \mathrm{if}\ e\ \mathrm{contains}\ (\mathrm{OP}, h) \\
--     0 & \mathrm{otherwise}
--     \end{cases}
--   `
--   with $`0` serving as a fallback in case an unknown operator is applied.

将函数当作单子，这通常称为 _reader_ 单子。
在reader单子中对表达式求值使用以下规则：
 * 常量 $`n` 求值为常量函数 $`λ e . n`，
 * 算术运算符求值为将参数各自传递然后计算的函数，因此 $`f + g` 求值为 $`λ e . f(e) + g(e)`，并且
 * 自定义运算符求值为将自定义运算符应用于参数的结果，因此 $`f \ \mathrm{OP}\ g` 求值为
   $$`
     λ e .
     \begin{cases}
     h(f(e), g(e)) & \mathrm{if}\ e\ \mathrm{contains}\ (\mathrm{OP}, h) \\
     0 & \mathrm{otherwise}
     \end{cases}
   `
   其中 $`0` 用于运算符未知的情况。

-- To define the reader monad in Lean, the first step is to define the {anchorName Reader}`Reader` type and the effect that allows users to get ahold of the environment:

要在Lean中定义reader单子，第一步是定义 {anchorName Reader}`Reader` 类型，和用户获取环境的作用：

```anchor Reader
def Reader (ρ : Type) (α : Type) : Type := ρ → α

def read : Reader ρ ρ := fun env => env
```
-- By convention, the Greek letter {anchorName Reader}`ρ`, which is pronounced “rho”, is used for environments.

按照惯例，希腊字母 {anchorName Reader}`ρ`（发音为“rho”）用于表示环境。

-- The fact that constants in arithmetic expressions evaluate to constant functions suggests that the appropriate definition of {anchorName IdMonad}`pure` for {anchorName Reader}`Reader` is a a constant function:

算术表达式中的常量映射为常量函数这一事实表明，{anchorName Reader}`Reader` 的 {anchorName IdMonad}`pure` 的适当定义是一个常量函数：

```anchor ReaderPure
def Reader.pure (x : α) : Reader ρ α := fun _ => x
```

-- On the other hand, {anchorName MonadContract}`bind` is a bit tricker.
-- Its type is {anchorTerm readerBindType}`Reader ρ α → (α → Reader ρ β) → Reader ρ β`.
-- This type can be easier to understand by unfolding the definition of {anchorName Reader}`Reader`, which yields {anchorTerm readerBindTypeEval}`(ρ → α) → (α → ρ → β) → (ρ → β)`.
-- It should take an environment-accepting function as its first argument, while the second argument should transform the result of the environment-accepting function into yet another environment-accepting function.
-- The result of combining these is itself a function, waiting for an environment.

另一方面，{anchorName MonadContract}`bind` 则有点棘手。
它的类型是 {anchorTerm readerBindType}`Reader ρ α → (α → Reader ρ β) → Reader ρ β`。
通过展开 {anchorName Reader}`Reader` 的定义，可以更容易地理解此类型，从而产生 {anchorTerm readerBindTypeEval}`(ρ → α) → (α → ρ → β) → (ρ → β)`。
它将读取环境的函数作为第一个参数，而第二个参数将第一个参数的结果转换为另一个读取环境的函数。
组合这些结果本身就是一个读取环境的函数。

-- It's possible to use Lean interactively to get help writing this function.
-- The first step is to write down the arguments and return type, being very explicit in order to get as much help as possible, with an underscore for the definition's body:

可以交互式地使用Lean，获得编写该函数的帮助。
为了获得尽可能多的帮助，第一步是非常明确地写下参数的类型和返回的类型，用下划线表示定义的主体：
```anchor readerbind0
def Reader.bind {ρ : Type} {α : Type} {β : Type}
  (result : ρ → α) (next : α → ρ → β) : ρ → β :=
  _
```
-- Lean provides a message that describes which variables are available in scope, and the type that's expected for the result.
-- The {lit}`⊢` symbol, called a {deftech}_turnstile_ due to its resemblance to subway entrances, separates the local variables from the desired type, which is {anchorTerm readerbind0}`ρ → β` in this message:

Lean提供的消息描述了哪些变量在作用域内可用，以及结果的预期类型。
{lit}`⊢` 符号，由于它类似于地铁入口而被称为 _turnstile_，将局部变量与所需类型分开，在此消息中为 {anchorTerm readerbind0}`ρ → β`：
```anchorError readerbind0
don't know how to synthesize placeholder
context:
ρ α β : Type
result : ρ → α
next : α → ρ → β
⊢ ρ → β
```

-- Because the return type is a function, a good first step is to wrap a {kw}`fun` around the underscore:

因为返回类型是一个函数，所以第一步最好在下划线外套一层 {kw}`fun`：

```anchor readerbind1
def Reader.bind {ρ : Type} {α : Type} {β : Type}
  (result : ρ → α) (next : α → ρ → β) : ρ → β :=
  fun env => _
```
-- The resulting message now shows the function's argument as a local variable:

产生的消息说明现在函数的参数已经成为一个局部变量：
```anchorError readerbind1
don't know how to synthesize placeholder
context:
ρ α β : Type
result : ρ → α
next : α → ρ → β
env : ρ
⊢ β
```

-- The only thing in the context that can produce a {anchorName readerbind2a}`β` is {anchorName readerbind2a}`next`, and it will require two arguments to do so.
-- Each argument can itself be an underscore:

上下文中唯一可以产生 {anchorName readerbind2a}`β` 的是 {anchorName readerbind2a}`next`， 并且它需要两个参数。
每个参数都可以用下划线表示：
```anchor readerbind2a
def Reader.bind {ρ : Type} {α : Type} {β : Type}
  (result : ρ → α) (next : α → ρ → β) : ρ → β :=
  fun env => next _ _
```
-- The two underscores have the following respective messages associated with them:

这两个下划线分别有如下的消息：
```anchorError readerbind2a
don't know how to synthesize placeholder
context:
ρ α β : Type
result : ρ → α
next : α → ρ → β
env : ρ
⊢ α
```
```anchorError readerbind2b
don't know how to synthesize placeholder
context:
ρ α β : Type
result : ρ → α
next : α → ρ → β
env : ρ
⊢ ρ
```

-- Attacking the first underscore, only one thing in the context can produce an {anchorName readerbind3}`α`, namely {anchorName readerbind3}`result`:

先处理第一条下划线，注意到上下文中只有一个东西可以产生 {anchorName readerbind3}`α`，即 {anchorName readerbind3}`result`：

```anchor readerbind3
def Reader.bind {ρ : Type} {α : Type} {β : Type}
  (result : ρ → α) (next : α → ρ → β) : ρ → β :=
  fun env => next (result _) _
```
-- Now, both underscores have the same error message:

现在两条下划线都有一样的报错了：
```anchorError readerbind3
don't know how to synthesize placeholder
context:
ρ α β : Type
result : ρ → α
next : α → ρ → β
env : ρ
⊢ ρ
```
-- Happily, both underscores can be replaced by {anchorName readerbind4}`env`, yielding:

值得高兴的是，两条下划线都可以被 {anchorName readerbind4}`env` 替换，得到：

```anchor readerbind4
def Reader.bind {ρ : Type} {α : Type} {β : Type}
  (result : ρ → α) (next : α → ρ → β) : ρ → β :=
  fun env => next (result env) env
```

-- The final version can be obtained by undoing the unfolding of {anchorName Readerbind}`Reader` and cleaning up the explicit details:

要得到最后的版本，只需要把我们前面对 {anchorName Readerbind}`Reader` 的展开撤销，并且去掉过于明确的细节：

```anchor Readerbind
def Reader.bind
    (result : Reader ρ α)
    (next : α → Reader ρ β) : Reader ρ β :=
  fun env => next (result env) env
```

-- It's not always possible to write correct functions by simply “following the types”, and it carries the risk of not understanding the resulting program.
-- However, it can also be easier to understand a program that has been written than one that has not, and the process of filling in the underscores can bring insights.
-- In this case, {anchorName Readerbind}`Reader.bind` works just like {anchorName IdMonad}`bind` for {anchorName IdMonad}`Id`, except it accepts an additional argument that it then passes down to its arguments, and this intuition can help in understanding how it works.

仅仅跟着类型信息走并不总是能写出正确的函数，并且有未能完全理解产生的程序的风险。
然而理解一个已经写出的程序比理解还没写出的要简单，而且逐步填充下划线的内容也可以提供思路。
这张情况下，{anchorName Readerbind}`Reader.bind` 和 {anchorName IdMonad}`Id` 的 {anchorName IdMonad}`bind` 很像，唯一区别在于它接受一个额外的参数并传递到其他参数中。这个直觉可以帮助理解它的原理。

-- {anchorName ReaderPure}`Reader.pure` (which generates constant functions) and {anchorName Readerbind}`Reader.bind` obey the monad contract.
-- To check that {anchorTerm ReaderMonad1}`Reader.bind (Reader.pure v) f` is the same as {anchorTerm ReaderMonad1}`f v`, it's enough to replace definitions until the last step:

{anchorName ReaderPure}`Reader.pure`（生成常量函数）和 {anchorName Readerbind}`Reader.bind` 遵循单子约定。
要检查 {anchorTerm ReaderMonad1}`Reader.bind (Reader.pure v) f` 与 {anchorTerm ReaderMonad1}`f v` 等价, 只需要不断地展开定义即可：
```anchorEvalSteps ReaderMonad1
Reader.bind (Reader.pure v) f
===>
fun env => f ((Reader.pure v) env) env
===>
fun env => f ((fun _ => v) env) env
===>
fun env => f v env
===>
f v
```
-- For every function {anchorName eta}`f`, {anchorTerm eta}`fun x => f x` is the same as {anchorName eta}`f`, so the first part of the contract is satisfied.
-- To check that {anchorTerm ReaderMonad2}`Reader.bind r Reader.pure` is the same as {anchorName ReaderMonad2}`r`, a similar technique works:

对任意函数 {anchorName eta}`f` 来说，{anchorTerm eta}`fun x => f x` 和 {anchorName eta}`f` 是等价的，所以约定的第一部分已经满足。
要检查 {anchorTerm ReaderMonad2}`Reader.bind r Reader.pure` 与 {anchorName ReaderMonad2}`r` 等价，只需要相似的技巧：
```anchorEvalSteps ReaderMonad2
Reader.bind r Reader.pure
===>
fun env => Reader.pure (r env) env
===>
fun env => (fun _ => (r env)) env
===>
fun env => r env
```
-- Because reader actions {anchorName ReaderMonad2}`r` are themselves functions, this is the same as {anchorName ReaderMonad2}`r`.
-- To check associativity, the same thing can be done for both {anchorEvalStep ReaderMonad3a 0}`Reader.bind (Reader.bind r f) g` and {anchorEvalStep ReaderMonad3b 0}`Reader.bind r (fun x => Reader.bind (f x) g)`:

因为 reader actions {anchorName ReaderMonad2}`r` 本身是函数，所以这和 {anchorName ReaderMonad2}`r` 也是等价的。
要检查结合律，只需要对 {anchorEvalStep ReaderMonad3a 0}`Reader.bind (Reader.bind r f) g` 和 {anchorEvalStep ReaderMonad3b 0}`Reader.bind r (fun x => Reader.bind (f x) g)` 重复同样的步骤：
```anchorEvalSteps ReaderMonad3a
Reader.bind (Reader.bind r f) g
===>
fun env => g ((Reader.bind r f) env) env
===>
fun env => g ((fun env' => f (r env') env') env) env
===>
fun env => g (f (r env) env) env
```

-- {anchorEvalStep ReaderMonad3b 0}`Reader.bind r (fun x => Reader.bind (f x) g)` reduces to the same expression:

{anchorEvalStep ReaderMonad3b 0}`Reader.bind r (fun x => Reader.bind (f x) g)` 展开为同样的表达式：
```anchorEvalSteps ReaderMonad3b
Reader.bind r (fun x => Reader.bind (f x) g)
===>
Reader.bind r (fun x => fun env => g (f x env) env)
===>
fun env => (fun x => fun env' => g (f x env') env') (r env) env
===>
fun env => (fun env' => g (f (r env) env') env') env
===>
fun env => g (f (r env) env) env
```

-- Thus, a {anchorTerm MonadReaderInst}`Monad (Reader ρ)` instance is justified:

至此，{anchorTerm MonadReaderInst}`Monad (Reader ρ)` 实例已经得到了充分验证：

```anchor MonadReaderInst
instance : Monad (Reader ρ) where
  pure x := fun _ => x
  bind x f := fun env => f (x env) env
```

-- The custom environments that will be passed to the expression evaluator can be represented as lists of pairs:

要被传递给表达式求值器的环境可以用键值对的列表来表示：

```anchor Env
abbrev Env : Type := List (String × (Int → Int → Int))
```
-- For instance, {anchorName exampleEnv}`exampleEnv` contains maximum and modulus functions:

例如，{anchorName exampleEnv}`exampleEnv` 包含最大值和模函数：

```anchor exampleEnv
def exampleEnv : Env := [("max", max), ("mod", (· % ·))]
```

-- Lean already has a function {anchorName etc}`List.lookup` that finds the value associated with a key in a list of pairs, so {anchorName applyPrimReader}`applyPrimReader` needs only check whether the custom function is present in the environment. It returns {anchorTerm applyPrimReader}`0` if the function is unknown:

Lean已提供函数 {anchorName etc}`List.lookup` 用来在键值对的列表中根据键寻找对应的值，所以 {anchorName applyPrimReader}`applyPrimReader` 只需要确认自定义函数是否存在于环境中即可。如果不存在则返回 {anchorTerm applyPrimReader}`0`：

```anchor applyPrimReader
def applyPrimReader (op : String) (x : Int) (y : Int) : Reader Env Int :=
  read >>= fun env =>
  match env.lookup op with
  | none => pure 0
  | some f => pure (f x y)
```

-- Using {anchorName readerEval}`evaluateM` with {anchorName readerEval}`applyPrimReader` and an expression results in a function that expects an environment.
-- Luckily, {anchorName readerEval}`exampleEnv` is available:

将 {anchorName readerEval}`evaluateM`、{anchorName readerEval}`applyPrimReader`、和一条表达式一起使用，即得到一个接受环境的函数。
而我们前面已经准备好了 {anchorName readerEval}`exampleEnv`：

```anchor readerEval
open Expr Prim in
#eval
  evaluateM applyPrimReader
    (prim (other "max") (prim plus (const 5) (const 4))
      (prim times (const 3)
        (const 2)))
    exampleEnv
```
```anchorInfo readerEval
9
```

-- Like {anchorName Many (module:=Examples.Monads.Many)}`Many`, {anchorName Reader}`Reader` is an example of an effect that is difficult to encode in most languages, but type classes and monads make it just as convenient as any other effect.
-- The dynamic or special variables found in Common Lisp, Clojure, and Emacs Lisp can be used like {anchorName Reader}`Reader`.
-- Similarly, Scheme and Racket's parameter objects are an effect that exactly correspond to {anchorName Reader}`Reader`.
-- The Kotlin idiom of context objects can solve a similar problem, but they are fundamentally a means of passing function arguments automatically, so this idiom is more like the encoding as a reader monad than it is an effect in the language.

与 {anchorName Many (module:=Examples.Monads.Many)}`Many` 一样，{anchorName Reader}`Reader` 是难以在大多数语言中编码的作用，但类型类和单子使其与任何其他作用一样方便。
Common Lisp、Clojure和Emacs Lisp中的动态或特殊变量可以用作 {anchorName Reader}`Reader`。
类似地，Scheme和Racket的参数对象是一个与 {anchorName Reader}`Reader` 完全对应的作用。
Kotlin的上下文对象可以解决类似的问题，但根本上是一种自动传递函数参数的方式，因此更像是作为reader单子的编码，而不是语言中实现的作用。

-- ## Exercises
## Exercises
%%%
tag := "monads-arithmetic-example-exercises"
%%%

练习

-- ### Checking Contracts
### 检查约定
%%%
tag := "monads-arithmetic-example-checking-contracts"
%%%

-- Check the monad contract for {anchorTerm StateMonad}`State σ` and {anchorTerm MonadOptionExcept}`Except ε`.

检查 {anchorTerm StateMonad}`State σ` 和 {anchorTerm MonadOptionExcept}`Except ε` 满足单子约定。

-- ### Readers with Failure
### 允许Reader失败
%%%
tag := "monads-arithmetic-example-readers-with-failure"
%%%
-- Adapt the reader monad example so that it can also indicate failure when the custom operator is not defined, rather than just returning zero.
-- In other words, given these definitions:

调整例子中的reader单子，使得它可以在自定义的运算符不存在时提供错误信息而不是直接返回0。
换句话说，给定这些定义：

```anchor ReaderFail
def ReaderOption (ρ : Type) (α : Type) : Type := ρ → Option α

def ReaderExcept (ε : Type) (ρ : Type) (α : Type) : Type := ρ → Except ε α
```
-- do the following:
-- 1. Write suitable {lit}`pure` and {lit}`bind` functions
-- 2. Check that these functions satisfy the {anchorName evaluateM}`Monad` contract
-- 3. Write {anchorName evaluateM}`Monad` instances for {anchorName ReaderFail}`ReaderOption` and {anchorName ReaderFail}`ReaderExcept`
-- 4. Define suitable {anchorName evaluateM}`applyPrim` operators and test them with {anchorName evaluateM}`evaluateM` on some example expressions

要做的是：

 1. 实现恰当的 {lit}`pure` 和 {lit}`bind` 函数
 2. 验证这些函数满足 {anchorName evaluateM}`Monad` 约定
 3. 为 {anchorName ReaderFail}`ReaderOption` 和 {anchorName ReaderFail}`ReaderExcept` 实现 {anchorName evaluateM}`Monad` 实例
 4. 为它们定义恰当的 {anchorName evaluateM}`applyPrim` 运算符，并且将它们和 {anchorName evaluateM}`evaluateM` 一起测试一些例子

-- ### A Tracing Evaluator
### 带有跟踪信息的求值器
%%%
tag := "monads-arithmetic-example-exercise-trace"
%%%

-- The {anchorName MonadWriter}`WithLog` type can be used with the evaluator to add optional tracing of some operations.
-- In particular, the type {anchorName ToTrace}`ToTrace` can serve as a signal to trace a given operator:

{anchorName MonadWriter}`WithLog` 类型可以和求值器一起使用，来实现对某些运算的跟踪。
特别地，可以使用 {anchorName ToTrace}`ToTrace` 类型来追踪某个给定的运算符：

```anchor ToTrace
inductive ToTrace (α : Type) : Type where
  | trace : α → ToTrace α
```
-- For the tracing evaluator, expressions should have type {anchorTerm ToTraceExpr}`Expr (Prim (ToTrace (Prim Empty)))`.
-- This says that the operators in the expression consist of addition, subtraction, and multiplication, augmented with traced versions of each. The innermost argument is {anchorName ToTraceExpr}`Empty` to signal that there are no further special operators inside of {anchorName ToTrace}`trace`, only the three basic ones.

对于带有跟踪信息的求值器，表达式应该具有类型 {anchorTerm ToTraceExpr}`Expr (Prim (ToTrace (Prim Empty)))`。
这说明表达式中的运算符由附加参数的加、减、乘运算组成。最内层的参数是 {anchorName ToTraceExpr}`Empty`，说明在 {anchorName ToTrace}`trace` 内部没有特殊运算符，只有三种基本运算。

-- Do the following:
-- 1. Implement a {anchorTerm MonadWriter}`Monad (WithLog logged)` instance
-- 2. Write an {anchorName applyTracedType}`applyTraced` function to apply traced operators to their arguments, logging both the operator and the arguments, with type {anchorTerm applyTracedType}`ToTrace (Prim Empty) → Int → Int → WithLog (Prim Empty × Int × Int) Int`

要做的是：

 1. 实现 {anchorTerm MonadWriter}`Monad (WithLog logged)` 实例
 2. 写一个 {anchorName applyTracedType}`applyTraced` 来将被追踪的运算符应用到参数，将运算符和参数记录到日志，类型为：{anchorTerm applyTracedType}`ToTrace (Prim Empty) → Int → Int → WithLog (Prim Empty × Int × Int) Int`

-- If the exercise has been completed correctly, then

如果练习已经正确实现，那么

```anchor evalTraced
open Expr Prim ToTrace in
#eval
  evaluateM applyTraced
    (prim (other (trace times))
      (prim (other (trace plus)) (const 1)
        (const 2))
      (prim (other (trace minus)) (const 3)
        (const 4)))
```
-- should result in

将有如下结果

```anchorInfo evalTraced
{ log := [(Prim.plus, 1, 2), (Prim.minus, 3, 4), (Prim.times, 3, -1)], val := -3 }
```

--  Hint: values of type {anchorTerm ToTraceExpr}`Prim Empty` will appear in the resulting log. In order to display them as a result of {kw}`#eval`, the following instances are required:

 提示：类型为 {anchorTerm ToTraceExpr}`Prim Empty` 的值会出现在日志中。为了让它们能被 {kw}`#eval` 输出，需要下面几个实例：

```anchor ReprInstances
deriving instance Repr for WithLog
deriving instance Repr for Empty
deriving instance Repr for Prim
```
