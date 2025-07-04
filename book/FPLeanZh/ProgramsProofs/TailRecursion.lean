import VersoManual
import FPLeanZh.Examples

open Verso.Genre Manual
open Verso.Code.External

open FPLeanZh

set_option verso.exampleProject "../examples"
set_option verso.exampleModule "Examples.ProgramsProofs.TCO"

#doc (Manual) "尾递归" =>
%%%
tag := "tail-recursion"
%%%
/-
While Lean's {kw}`do`-notation makes it possible to use traditional loop syntax such as {kw}`for` and {kw}`while`, these constructs are translated behind the scenes to invocations of recursive functions.
In most programming languages, recursive functions have a key disadvantage with respect to loops: loops consume no space on the stack, while recursive functions consume stack space proportional to the number of recursive calls.
Stack space is typically limited, and it is often necessary to take algorithms that are naturally expressed as recursive functions and rewrite them as loops paired with an explicit mutable heap-allocated stack.
-/
虽然 Lean 的 {kw}`do`-记法允许使用传统的循环语法，例如 {kw}`for` 和 {kw}`while`，
但这些结构在幕后会被翻译为递归函数的调用。在大多数编程语言中，
递归函数相对于循环有一个关键缺点：循环不消耗栈空间，
而递归函数消耗与递归调用次数成正比的栈空间。栈空间通常是有限的，
通常有必要将以递归函数自然表达的算法，重写为用显式可变堆来分配栈的循环。

/-
In functional programming, the opposite is typically true.
Programs that are naturally expressed as mutable loops may consume stack space, while rewriting them to recursive functions can cause them to run quickly.
This is due to a key aspect of functional programming languages: _tail-call elimination_.
A tail call is a call from one function to another that can be compiled to an ordinary jump, replacing the current stack frame rather than pushing a new one, and tail-call elimination is the process of implementing this transformation.
-/
在函数式编程中，情况通常相反。以可变循环自然表达的程序可能会消耗栈空间，
而将它们重写为递归函数可以使它们快速运行。这是函数式编程语言的一个关键方面：
__尾调用消除（Tail-call Elimination）__。尾调用是从一个函数到另一个函数的调用，
可以编译成一个普通的跳转，替换当前的栈帧而非压入一个新的栈帧，
而尾调用消除就是实现此转换的过程。

/-
Tail-call elimination is not just merely an optional optimization.
Its presence is a fundamental part of being able to write efficient functional code.
For it to be useful, it must be reliable.
Programmers must be able to reliably identify tail calls, and they must be able to trust that the compiler will eliminate them.
-/
尾调用消除不仅仅是一种可选的优化。它的存在是编写高效函数式代码的基础部分。
为了使其有效，它必须是可靠的。程序员必须能够可靠地识别尾调用，
并且他们必须相信编译器会消除它们。

/-
The function {anchorName NonTailSum}`NonTail.sum` adds the contents of a list of {anchorName NonTailSum}`Nat`s:
-/
函数 {anchorName NonTailSum}`NonTail.sum` 将 {anchorName NonTailSum}`Nat` 列表的内容加起来:

```anchor NonTailSum
def NonTail.sum : List Nat → Nat
  | [] => 0
  | x :: xs => x + sum xs
```
/-
Applying this function to the list {anchorTerm NonTailSumOneTwoThree}`[1, 2, 3]` results in the following sequence of evaluation steps:
-/
将此函数应用于列表 {anchorTerm NonTailSumOneTwoThree}`[1, 2, 3]` 会产生以下求值步骤：
```anchorEvalSteps NonTailSumOneTwoThree
NonTail.sum [1, 2, 3]
===>
1 + (NonTail.sum [2, 3])
===>
1 + (2 + (NonTail.sum [3]))
===>
1 + (2 + (3 + (NonTail.sum [])))
===>
1 + (2 + (3 + 0))
===>
1 + (2 + 3)
===>
1 + 5
===>
6
```
/-
In the evaluation steps, parentheses indicate recursive calls to {anchorName NonTailSumOneTwoThree}`NonTail.sum`.
In other words, to add the three numbers, the program must first check that the list is non-empty.
To add the head of the list ({anchorTerm NonTailSumOneTwoThree}`1`) to the sum of the tail of the list, it is first necessary to compute the sum of the tail of the list:
-/
在求值步骤中，括号表示对 {anchorName NonTailSumOneTwoThree}`NonTail.sum` 的递归调用。换句话说，要加起来这三个数字，
程序必须首先检查列表是否非空。要将列表的头部（{anchorTerm NonTailSumOneTwoThree}`1`）加到列表尾部的和上，
首先需要计算列表尾部的和：
```anchorEvalStep NonTailSumOneTwoThree 1
1 + (NonTail.sum [2, 3])
```
/-
But to compute the sum of the tail of the list, the program must check whether it is empty.
It is not—the tail is itself a list with {anchorTerm NonTailSumOneTwoThree}`2` at its head.
The resulting step is waiting for the return of {anchorTerm NonTailSumOneTwoThree}`NonTail.sum [3]`:
-/
但是要计算列表尾部的和，程序必须检查它是否为空，然而它不是。
尾部本身是一个列表，头部为 {anchorTerm NonTailSumOneTwoThree}`2`。结果步骤正在等待 {anchorTerm NonTailSumOneTwoThree}`NonTail.sum [3]` 的返回：
```anchorEvalStep NonTailSumOneTwoThree 2
1 + (2 + (NonTail.sum [3]))
```
/-
The whole point of the run-time call stack is to keep track of the values {anchorTerm NonTailSumOneTwoThree}`1`, {anchorTerm NonTailSumOneTwoThree}`2`, and {anchorTerm NonTailSumOneTwoThree}`3` along with the instruction to add them to the result of the recursive call.
As recursive calls are completed, control returns to the stack frame that made the call, so each step of addition is performed.
Storing the heads of the list and the instructions to add them is not free; it takes space proportional to the length of the list.
-/
运行时调用栈的重点在于跟踪值 {anchorTerm NonTailSumOneTwoThree}`1`、{anchorTerm NonTailSumOneTwoThree}`2` 和 {anchorTerm NonTailSumOneTwoThree}`3`，以及一个指令将它们加到递归调用的结果上。
随着递归调用的完成，控制权返回到发出调用的栈帧，于是每一步的加法都被执行了。
存储列表的头部和将它们相加的指令并不是免费的；它占用的空间与列表的长度成正比。

/-
The function {anchorName TailSum}`Tail.sum` also adds the contents of a list of {anchorName TailSum}`Nat`s:
-/
函数 {anchorName TailSum}`Tail.sum` 也将 {anchorName TailSum}`Nat` 列表的内容加起来：

```anchor TailSum
def Tail.sumHelper (soFar : Nat) : List Nat → Nat
  | [] => soFar
  | x :: xs => sumHelper (x + soFar) xs

def Tail.sum (xs : List Nat) : Nat :=
  Tail.sumHelper 0 xs
```
/-
Applying it to the list {anchorTerm TailSumOneTwoThree}`[1, 2, 3]` results in the following sequence of evaluation steps:
-/
将其应用于列表 {anchorTerm TailSumOneTwoThree}`[1, 2, 3]` 会产生以下求值步骤：
```anchorEvalSteps TailSumOneTwoThree
Tail.sum [1, 2, 3]
===>
Tail.sumHelper 0 [1, 2, 3]
===>
Tail.sumHelper (0 + 1) [2, 3]
===>
Tail.sumHelper 1 [2, 3]
===>
Tail.sumHelper (1 + 2) [3]
===>
Tail.sumHelper 3 [3]
===>
Tail.sumHelper (3 + 3) []
===>
Tail.sumHelper 6 []
===>
6
```
/-
The internal helper function calls itself recursively, but it does so in a way where nothing needs to be remembered in order to compute the final result.
When {anchorName TailSum}`Tail.sumHelper` reaches its base case, control can be returned directly to {anchorName TailSum}`Tail.sum`, because the intermediate invocations of {anchorName TailSum}`Tail.sumHelper` simply return the results of their recursive calls unmodified.
In other words, a single stack frame can be re-used for each recursive invocation of {anchorName TailSum}`Tail.sumHelper`.
Tail-call elimination is exactly this re-use of the stack frame, and {anchorName TailSum}`Tail.sumHelper` is referred to as a _tail-recursive function_.
-/
内部的辅助函数以递归方式调用自身，但它以一种新的方式执行此操作，无需记住任何内容即可计算最终结果。
当 {anchorName TailSum}`Tail.sumHelper` 达到其基本情况时，控制权可以直接返回到 {anchorName TailSum}`Tail.sum`，
因为 {anchorName TailSum}`Tail.sumHelper` 的中间调用只是返回其递归调用的结果，而不会修改结果。
换句话说，可以为 {anchorName TailSum}`Tail.sumHelper` 的每个递归调用重新使用一个栈帧。
尾调用消除正是这种栈帧的重新使用，而 {anchorName TailSum}`Tail.sumHelper`
被称为 __尾递归函数（Tail-Recursive Function）__。

/-
The first argument to {anchorName TailSum}`Tail.sumHelper` contains all of the information that would otherwise need to be tracked in the call stack—namely, the sum of the numbers encountered so far.
In each recursive call, this argument is updated with new information, rather than adding new information to the call stack.
Arguments like {anchorName TailSum}`soFar` that replace the information from the call stack are called _accumulators_.
-/
{anchorName TailSum}`Tail.sumHelper` 的第一个参数包含所有其他需要在调用栈中跟踪的信息，即到目前为止遇到的数字的总和。
在每个递归调用中，此参数都会使用新信息进行更新，而非将新信息添加到调用栈中。
替换调用栈中信息的 {anchorName TailSum}`soFar` 等参数称为 __累加器（Accumulator）__。

/-
At the time of writing and on the author's computer, {anchorName NonTailSum}`NonTail.sum` crashes with a stack overflow when passed a list with 216,856 or more entries.
{anchorName TailSum}`Tail.sum`, on the other hand, can sum a list of 100,000,000 elements without a stack overflow.
Because no new stack frames need to be pushed while running {anchorName TailSum}`Tail.sum`, it is completely equivalent to a {kw}`while` loop with a mutable variable that holds the current list.
At each recursive call, the function argument on the stack is simply replaced with the next node of the list.
-/
在撰写本文时，在作者的计算机上，当传入包含 216,856 个或更多条目的列表时，
{anchorName NonTailSum}`NonTail.sum` 会因栈溢出而崩溃。另一方面，{anchorName TailSum}`Tail.sum` 可以对包含
100,000,000 个元素的列表求和，而不会发生栈溢出。由于在运行 {anchorName TailSum}`Tail.sum`
时不需要压入新的栈帧，因此它完全等同于一个 {kw}`while` 循环，其中一个可变变量保存当前列表。
在每次递归调用中，栈上的函数参数都会被简单地替换为列表的下一个节点。


-- # Tail and Non-Tail Positions
# 尾部位置和非尾部位置

/-
The reason why {anchorName TailSum}`Tail.sumHelper` is tail recursive is that the recursive call is in _tail position_.
Informally speaking, a function call is in tail position when the caller does not need to modify the returned value in any way, but will just return it directly.
More formally, tail position can be defined explicitly for expressions.
-/
{anchorName TailSum}`Tail.sumHelper` 是尾递归的原因在于递归调用处于 __尾部位置__。
非正式地说，当调用者不需要以任何方式修改返回值，而是会直接返回它时，
函数调用就处于尾部位置。更正式地说，尾部位置可以显式地为表达式定义。

/-
If a {kw}`match`-expression is in tail position, then each of its branches is also in tail position.
Once a {kw}`match` has selected a branch, control proceeds immediately to it.
Similarly, both branches of an {kw}`if`-expression are in tail position if the {kw}`if`-expression itself is in tail position.
Finally, if a {kw}`let`-expression is in tail position, then its body is as well.
-/
如果 {kw}`match`-表达式处于尾部位置，那么它的每个分支也处于尾部位置。
一旦 {kw}`match` 选择了一个分支，控制权就会立即传递给它。
与此类似，如果 {kw}`if` 表达式本身处于尾部位置，那么 {kw}`if` 表达式的两个分支都处于尾部位置。
最后，如果 {kw}`let` 表达式处于尾部位置，那么它的主体也是如此。

/-
All other positions are not in tail position.
The arguments to a function or a constructor are not in tail position because evaluation must track the function or constructor that will be applied to the argument's value.
The body of an inner function is not in tail position because control may not even pass to it: function bodies are not evaluated until the function is called.
Similarly, the body of a function type is not in tail position.
To evaluate {lit}`E` in {lit}`(x : α) → E`, it is necessary to track that the resulting type must have {lit}`(x : α) → ...` wrapped around it.
-/
所有其他位置都不处于尾部位置。函数或构造子的参数不处于尾部位置，
因为求值必须跟踪会应用到参数值的函数或构造子。内部函数的主体不处于尾部位置，
因为控制权甚至可能不会传递给它：函数主体在函数被调用之前不会被求值。
与此类似，函数类型的函数主体不处于尾部位置。要求值 {lit}`(x : α) → E` 中的 {lit}`E`，
就有必要跟踪结果，结果的类型必须有 {lit}`(x : α) → ...` 包裹在其周围。

/-
In {anchorName NonTailSum}`NonTail.sum`, the recursive call is not in tail position because it is an argument to {anchorTerm NonTailSum}`+`.
In {anchorName TailSum}`Tail.sumHelper`, the recursive call is in tail position because it is immediately underneath a pattern match, which itself is the body of the function.
-/
在 {anchorName NonTailSum}`NonTail.sum` 中，递归调用不在尾部位置，因为它是一个 {anchorTerm NonTailSum}`+` 的参数。
在 {anchorName TailSum}`Tail.sumHelper` 中，递归调用在尾部位置，因为它紧跟在模式匹配之后，
而模式匹配本身是函数的主体。

/-
At the time of writing, Lean only eliminates direct tail calls in recursive functions.
This means that tail calls to {lit}`f` in {lit}`f`'s definition will be eliminated, but not tail calls to some other function {lit}`g`.
While it is certainly possible to eliminate a tail call to some other function, saving a stack frame, this is not yet implemented in Lean.
-/
在撰写本文时，Lean 仅消除了递归函数中的直接尾部调用。
这意味着在 {lit}`f` 的定义中对 {lit}`f` 的尾部调用将被消除，但对其他函数 {lit}`g` 的尾部调用不会被消除。
当然，消除其他函数的尾部调用以节省栈帧是可行的，但这尚未在 Lean 中实现。

-- # Reversing Lists
# 反转列表

/-
The function {anchorName NonTailReverse}`NonTail.reverse` reverses lists by appending the head of each sub-list to the end of the result:
-/
函数 {anchorName NonTailReverse}`NonTail.reverse` 通过将每个子列表的头部追加到结果的末尾来反转列表：

```anchor NonTailReverse
def NonTail.reverse : List α → List α
  | [] => []
  | x :: xs => reverse xs ++ [x]
```
/-
Using it to reverse {anchorTerm NonTailReverseSteps}`[1, 2, 3]` yields the following sequence of steps:
-/
使用它来反转 {anchorTerm NonTailReverseSteps}`[1, 2, 3]` 会产生以下步骤：
```anchorEvalSteps NonTailReverseSteps
NonTail.reverse [1, 2, 3]
===>
(NonTail.reverse [2, 3]) ++ [1]
===>
((NonTail.reverse [3]) ++ [2]) ++ [1]
===>
(((NonTail.reverse []) ++ [3]) ++ [2]) ++ [1]
===>
(([] ++ [3]) ++ [2]) ++ [1]
===>
([3] ++ [2]) ++ [1]
===>
[3, 2] ++ [1]
===>
[3, 2, 1]
```

/-
The tail-recursive version uses {lit}`x :: ·` instead of {lit}`· ++ [x]` on the accumulator at each step:
-/
尾递归版本会在每一步的累加器上使用 {lit}`x :: ·` 而非 {lit}`· ++ [x]`：

```anchor TailReverse
def Tail.reverseHelper (soFar : List α) : List α → List α
  | [] => soFar
  | x :: xs => reverseHelper (x :: soFar) xs

def Tail.reverse (xs : List α) : List α :=
  Tail.reverseHelper [] xs
```
/-
This is because the context saved in each stack frame while computing with {anchorName NonTailReverse}`NonTail.reverse` is applied beginning at the base case.
Each “remembered” piece of context is executed in last-in, first-out order.
On the other hand, the accumulator-passing version modifies the accumulator beginning from the first entry in the list, rather than the original base case, as can be seen in the series of reduction steps:
-/
这是因为在使用 {anchorName NonTailReverse}`NonTail.reverse` 计算时保存在每个栈帧中的上下文从基本情况开始应用。
每个「记住的」上下文片段都按照后进先出的顺序执行。
另一方面，累加器传递版本从列表中的第一个条目而非原始基本情况开始修改累加器，
如以下归约步骤所示：

```anchorEvalSteps TailReverseSteps
Tail.reverse [1, 2, 3]
===>
Tail.reverseHelper [] [1, 2, 3]
===>
Tail.reverseHelper [1] [2, 3]
===>
Tail.reverseHelper [2, 1] [3]
===>
Tail.reverseHelper [3, 2, 1] []
===>
[3, 2, 1]
```
/-
In other words, the non-tail-recursive version starts at the base case, modifying the result of recursion from right to left through the list.
The entries in the list affect the accumulator in a first-in, first-out order.
The tail-recursive version with the accumulator starts at the head of the list, modifying an initial accumulator value from left to right through the list.
-/
换句话说，非尾递归版本从基本情况开始，从右到左通过列表修改递归结果。
列表中的条目以先入先出的顺序影响累加器。带有累加器的尾递归版本从列表的头部开始，
从左到右通过列表修改初始累加器值。

/-
Because addition is commutative, nothing needed to be done to account for this in {anchorName TailSum}`Tail.sum`.
Appending lists is not commutative, so care must be taken to find an operation that has the same effect when run in the opposite direction.
-/
由于加法满足交换律，因此无需在 {anchorName TailSum}`Tail.sum` 中对此进行处理。
列表追加不满足交换律，因此必须注意要找到一个在相反方向运行时具有相同效果的操作。
/-
Appending {anchorTerm NonTailReverse}`[x]` after the result of the recursion in {anchorName NonTailReverse}`NonTail.reverse` is analogous to adding {anchorName NonTailReverse}`x` to the beginning of the list when the result is built in the opposite order.
-/
在 {anchorName NonTailReverse}`NonTail.reverse` 中，在递归结果后追加 {anchorTerm NonTailReverse}`[x]` 与以逆序构建结果时将 {anchorName NonTailReverse}`x` 添加到列表开头类似。

-- # Multiple Recursive Calls
# 多个递归调用

/-
In the definition of {anchorName mirrorNew (module := Examples.Monads.Conveniences)}`BinTree.mirror`, there are two recursive calls:
-/
在 {anchorName mirrorNew (module := Examples.Monads.Conveniences)}`BinTree.mirror` 的定义中，有两个递归调用：

```anchor mirrorNew (module := Examples.Monads.Conveniences)
def BinTree.mirror : BinTree α → BinTree α
  | .leaf => .leaf
  | .branch l x r => .branch (mirror r) x (mirror l)
```
/-
Just as imperative languages would typically use a while loop for functions like {anchorName NonTailReverse}`reverse` and {anchorName NonTailSum}`sum`, they would typically use recursive functions for this kind of traversal.
This function cannot be straightforwardly rewritten to be tail recursive using accumulator-passing style, at least not using the techniques presented in this book.
-/
就像命令式语言通常会对 {anchorName NonTailReverse}`reverse` 和 {anchorName NonTailSum}`sum` 等函数使用 while 循环一样，
它们通常会对这种遍历使用递归函数。此函数无法直接通过累加器传递风格重写为尾递归函数，
至少不能使用本书中介绍的技术。

/-
Typically, if more than one recursive call is required for each recursive step, then it will be difficult to use accumulator-passing style.
This difficulty is similar to the difficulty of rewriting a recursive function to use a loop and an explicit data structure, with the added complication of convincing Lean that the function terminates.
However, as in {anchorName mirrorNew (module:=Examples.Monads.Conveniences)}`BinTree.mirror`, multiple recursive calls often indicate a data structure that has a constructor with multiple recursive occurrences of itself.
In these cases, the depth of the structure is often logarithmic with respect to its overall size, which makes the tradeoff between stack and heap less stark.
There are systematic techniques for making these functions tail-recursive, such as using _continuation-passing style_ and _defunctionalization_, but they are outside the scope of this book.
-/
通常，如果每个递归步骤需要多个递归调用，那么将很难使用累加器传递样式。
这种困难类似于使用循环和显式数据结构重写递归函数的困难，增加了说服 Lean 函数终止的复杂性。
但是，就像在 {anchorName mirrorNew (module:=Examples.Monads.Conveniences)}`BinTree.mirror` 中一样，多个递归调用通常表示一个数据结构，
其构造子具有多次递归出现的情况。在这些情况下，结构的深度通常与其整体大小成对数关系，
这使得栈和堆之间的权衡不那么明显。有一些系统化的技术可以使这些函数成为尾递归，
例如使用 __续体传递风格（Continuation-Passing Style）__ 和 __去函数化（Defunctionalization）__，但它们超出了本书的范围。

-- # Exercises
# 练习

/-
Translate each of the following non-tail-recursive functions into accumulator-passing tail-recursive functions:
-/
将以下所有非尾递归的函数翻译成累加器传递的尾递归函数：


```anchor NonTailLength
def NonTail.length : List α → Nat
  | [] => 0
  | _ :: xs => NonTail.length xs + 1
```


```anchor NonTailFact
def NonTail.factorial : Nat → Nat
  | 0 => 1
  | n + 1 => factorial n * (n + 1)
```

/-
The translation of {anchorName NonTailFilter}`NonTail.filter` should result in a program that takes constant stack space through tail recursion, and time linear in the length of the input list.
A constant factor overhead is acceptable relative to the original:
-/
{anchorName NonTailFilter}`NonTail.filter` 的翻译应当产生一个程序，它通过尾递归占用常量栈空间，
运行时间与输入列表的长度成线性相关。相对于原始情况来说，常数因子的开销是可以接受的：

```anchor NonTailFilter
def NonTail.filter (p : α → Bool) : List α → List α
  | [] => []
  | x :: xs =>
    if p x then
      x :: filter p xs
    else
      filter p xs
```
