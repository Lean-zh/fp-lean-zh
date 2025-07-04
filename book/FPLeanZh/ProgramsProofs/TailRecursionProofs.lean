import VersoManual
import FPLeanZh.Examples

open Verso.Genre Manual
open Verso.Code.External

open FPLeanZh

set_option verso.exampleProject "../examples"
set_option verso.exampleModule "Examples.ProgramsProofs.TCO"

#doc (Manual) "证明等价" =>
/-
Proving Equivalence

Programs that have been rewritten to use tail recursion and an accumulator can look quite different from the original program.
The original recursive function is often much easier to understand, but it runs the risk of exhausting the stack at run time.
After testing both versions of the program on examples to rule out simple bugs, proofs can be used to show once and for all that the programs are equivalent.
-/
重写为使用尾递归和累加器的程序可能看起来与原始程序非常不同。
原始递归函数通常更容易理解，但它有在运行时耗尽栈的风险。
在用示例测试程序的两个版本以排除简单错误后，可以使用证明来一劳永逸地证明二者是等价的。

-- # Proving {lit}`sum` Equal
# 证明 {lit}`sum` 相等

/-
To prove that both versions of {lit}`sum` are equal, begin by writing the theorem statement with a stub proof:
-/
要证明 {lit}`sum` 的两个版本相等，首先用桩（stub）证明编写定理的陈述：
```anchor sumEq0
theorem non_tail_sum_eq_tail_sum : NonTail.sum = Tail.sum := by
  skip
```
/-
As expected, Lean describes an unsolved goal:
-/
正如预期，Lean 描述了一个未解决的目标：
```anchorError sumEq0
unsolved goals
⊢ NonTail.sum = Tail.sum
```

/-
The {kw}`rfl` tactic cannot be applied here because {anchorName sumEq0}`NonTail.sum` and {anchorName sumEq0}`Tail.sum` are not definitionally equal.
Functions can be equal in more ways than just definitional equality, however.
It is also possible to prove that two functions are equal by proving that they produce equal outputs for the same input.
In other words, $`f = g` can be proved by proving that $`f(x) = g(x)` for all possible inputs $`x`.
This principle is called _function extensionality_.
Function extensionality is exactly the reason why {anchorName sumEq0}`NonTail.sum` equals {anchorName sumEq0}`Tail.sum`: they both sum lists of numbers.
-/
{kw}`rfl` 策略无法在此处应用，因为 {anchorName sumEq0}`NonTail.sum` 和 {anchorName sumEq0}`Tail.sum` 在定义上不相等。
然而，函数除了定义相等外还存在更多相等的方式。还可以通过证明两个函数对相同输入产生相等输出，
来证明它们相等。换句话说，可以通过证明「对于所有可能的输入 $`x`，
都有 $`f(x) = g(x)`」来证明 $`f = g`。此原理称为 __函数外延性（Function Extensionality）__。
函数外延性正是 {anchorName sumEq0}`NonTail.sum` 等于 {anchorName sumEq0}`Tail.sum` 的原因：它们都对数字列表求和。

/-
In Lean's tactic language, function extensionality is invoked using {anchorTerm sumEq1}`funext`, followed by a name to be used for the arbitrary argument.
The arbitrary argument is added as an assumption to the context, and the goal changes to require a proof that the functions applied to this argument are equal:
-/
在 Lean 的策略语言中，可使用 {anchorTerm sumEq1}`funext` 调用函数外延性，后跟一个用于任意参数的名称。
任意参数会作为假设添加到语境中，目标变为证明应用于此参数的函数相等：
```anchor sumEq1
theorem non_tail_sum_eq_tail_sum : NonTail.sum = Tail.sum := by
  funext xs
```
```anchorError sumEq1
unsolved goals
case h
xs : List Nat
⊢ NonTail.sum xs = Tail.sum xs
```

/-
This goal can be proved by induction on the argument {anchorName sumEq1}`xs`.
Both {lit}`sum` functions return {anchorTerm TailSum}`0` when applied to the empty list, which serves as a base case.
Adding a number to the beginning of the input list causes both functions to add that number to the result, which serves as an induction step.
Invoking the {anchorTerm sumEq2a}`induction` tactic results in two goals:
-/
此目标可通过对参数 {anchorName sumEq1}`xs` 进行归纳来证明。当应用于空列表时，{lit}`sum` 函数都返回 {anchorTerm TailSum}`0`，这是基本情况。
在输入列表的开头添加一个数字会让两个函数都将该数字添加到结果中，这是归纳步骤。
调用 {anchorTerm sumEq2a}`induction` 策略会产生两个目标：
```anchor sumEq2a
theorem non_tail_sum_eq_tail_sum : NonTail.sum = Tail.sum := by
  funext xs
  induction xs with
  | nil => skip
  | cons y ys ih => skip
```
```anchorError sumEq2a
unsolved goals
case h.nil
⊢ NonTail.sum [] = Tail.sum []
```
```anchorError sumEq2b
unsolved goals
case h.cons
y : Nat
ys : List Nat
ih : NonTail.sum ys = Tail.sum ys
⊢ NonTail.sum (y :: ys) = Tail.sum (y :: ys)
```

/-
The base case for {anchorName sumEq3}`nil` can be solved using {anchorTerm sumEq3}`rfl`, because both functions return {anchorTerm TailSum}`0` when passed the empty list:
-/
{anchorName sumEq3}`nil` 的基本情况可以使用 {anchorTerm sumEq3}`rfl` 解决，因为当传递空列表时，两个函数都返回 {anchorTerm TailSum}`0`：
```anchor sumEq3
theorem non_tail_sum_eq_tail_sum : NonTail.sum = Tail.sum := by
  funext xs
  induction xs with
  | nil => rfl
  | cons y ys ih => skip
```

/-
The first step in solving the induction step is to simplify the goal, asking {anchorTerm sumEq4}`simp` to unfold {anchorName sumEq4}`NonTail.sum` and {anchorName sumEq4}`Tail.sum`:
-/
解决归纳步骤的第一步是简化目标，要求 {anchorTerm sumEq4}`simp` 展开 {anchorName sumEq4}`NonTail.sum` 和 {anchorName sumEq4}`Tail.sum`：
```anchor sumEq4
theorem non_tail_sum_eq_tail_sum : NonTail.sum = Tail.sum := by
  funext xs
  induction xs with
  | nil => rfl
  | cons y ys ih =>
    simp [NonTail.sum, Tail.sum]
```
```anchorError sumEq4
unsolved goals
case h.cons
y : Nat
ys : List Nat
ih : NonTail.sum ys = Tail.sum ys
⊢ y + NonTail.sum ys = Tail.sumHelper 0 (y :: ys)
```
/-
Unfolding {anchorName sumEq5}`Tail.sum` revealed that it immediately delegates to {anchorName sumEq5}`Tail.sumHelper`, which should also be simplified:
-/
展开 {anchorName sumEq5}`Tail.sum` 会发现它直接委托给了 {anchorName sumEq5}`Tail.sumHelper`，它也应该被简化：
```anchor sumEq5
theorem non_tail_sum_eq_tail_sum : NonTail.sum = Tail.sum := by
  funext xs
  induction xs with
  | nil => rfl
  | cons y ys ih =>
    simp [NonTail.sum, Tail.sum, Tail.sumHelper]
```
/-
In the resulting goal, {anchorName TailSum}`sumHelper` has taken a step of computation and added {anchorName sumEq5}`y` to the accumulator:
-/
在结果目标中，{anchorName TailSum}`sumHelper` 执行了一步计算并将 {anchorName sumEq5}`y` 加到累加器上：
```anchorError sumEq5
unsolved goals
case h.cons
y : Nat
ys : List Nat
ih : NonTail.sum ys = Tail.sum ys
⊢ y + NonTail.sum ys = Tail.sumHelper y ys
```
/-
Rewriting with the induction hypothesis removes all mentions of {anchorName sumEq6}`NonTail.sum` from the goal:
-/
使用归纳假设重写会从目标中删除所有 {anchorName sumEq6}`NonTail.sum` 的引用：
```anchor sumEq6
theorem non_tail_sum_eq_tail_sum : NonTail.sum = Tail.sum := by
  funext xs
  induction xs with
  | nil => rfl
  | cons y ys ih =>
    simp [NonTail.sum, Tail.sum, Tail.sumHelper]
    rw [ih]
```
```anchorError sumEq6
unsolved goals
case h.cons
y : Nat
ys : List Nat
ih : NonTail.sum ys = Tail.sum ys
⊢ y + Tail.sum ys = Tail.sumHelper y ys
```
/-
This new goal states that adding some number to the sum of a list is the same as using that number as the initial accumulator in {anchorName TailSum}`sumHelper`.
For the sake of clarity, this new goal can be proved as a separate theorem:
-/
这个新目标表明，将某个数字加到列表的和中与在 {anchorName TailSum}`sumHelper` 中使用该数字作为初始累加器相同。
为了清晰起见，这个新目标可以作为独立的定理来证明：
```anchor sumEqHelperBad0
theorem helper_add_sum_accum (xs : List Nat) (n : Nat) :
    n + Tail.sum xs = Tail.sumHelper n xs := by
  skip
```
```anchorError sumEqHelperBad0
unsolved goals
xs : List Nat
n : Nat
⊢ n + Tail.sum xs = Tail.sumHelper n xs
```
/-
Once again, this is a proof by induction where the base case uses {anchorTerm sumEqHelperBad1}`rfl`:
-/
这又是一次归纳证明，其中基本情况使用 {anchorTerm sumEqHelperBad1}`rfl` 证明：
```anchor sumEqHelperBad1
theorem helper_add_sum_accum (xs : List Nat) (n : Nat) :
    n + Tail.sum xs = Tail.sumHelper n xs := by
  induction xs with
  | nil => rfl
  | cons y ys ih => skip
```
```anchorError sumEqHelperBad1
unsolved goals
case cons
n y : Nat
ys : List Nat
ih : n + Tail.sum ys = Tail.sumHelper n ys
⊢ n + Tail.sum (y :: ys) = Tail.sumHelper n (y :: ys)
```
/-
Because this is an inductive step, the goal should be simplified until it matches the induction hypothesis {anchorName sumEqHelperBad2}`ih`.
Simplifying, using the definitions of {anchorName sumEqHelperBad2}`Tail.sum` and {anchorName sumEqHelperBad2}`Tail.sumHelper`, results in the following:
-/
由于这是一个归纳步骤，因此目标应该被简化，直到它与归纳假设 {anchorName sumEqHelperBad2}`ih` 匹配。
简化，然后使用 {anchorName sumEqHelperBad2}`Tail.sum` 和 {anchorName sumEqHelperBad2}`Tail.sumHelper` 的定义，得到以下结果：
```anchor sumEqHelperBad2
theorem helper_add_sum_accum (xs : List Nat) (n : Nat) :
    n + Tail.sum xs = Tail.sumHelper n xs := by
  induction xs with
  | nil => rfl
  | cons y ys ih =>
    simp [Tail.sum, Tail.sumHelper]
```
```anchorError sumEqHelperBad2
unsolved goals
case cons
n y : Nat
ys : List Nat
ih : n + Tail.sum ys = Tail.sumHelper n ys
⊢ n + Tail.sumHelper y ys = Tail.sumHelper (y + n) ys
```
/-
Ideally, the induction hypothesis could be used to replace {lit}`Tail.sumHelper (y + n) ys`, but they don't match.
The induction hypothesis can be used for {lit}`Tail.sumHelper n ys`, not {lit}`Tail.sumHelper (y + n) ys`.
In other words, this proof is stuck.
-/
理想情况下，归纳假设可用于替换 {lit}`Tail.sumHelper (y + n) ys`，但它们不匹配。
归纳假设可用于 {lit}`Tail.sumHelper n ys`，而非 {lit}`Tail.sumHelper (y + n) ys`。
换句话说，这个证明被卡住了。

# 第二次尝试

/-
Rather than attempting to muddle through the proof, it's time to take a step back and think.
Why is it that the tail-recursive version of the function is equal to the non-tail-recursive version?
Fundamentally speaking, at each entry in the list, the accumulator grows by the same amount as would be added to the result of the recursion.
This insight can be used to write an elegant proof.
Crucially, the proof by induction must be set up such that the induction hypothesis can be applied to _any_ accumulator value.
-/
与其试图在证明中胡搅蛮缠，现在是时候退一步思考了。
为什么函数的尾递归版本等于非尾递归版本？
从根本上讲，在列表的每个条目处，累加器增长的量与添加到递归结果中的量相同。
这种洞察可以用来编写一个优雅的证明。
至关重要的是，归纳证明必须设置成使得归纳假设可以应用于 __任何__ 累加器值。

/-
Discarding the prior attempt, the insight can be encoded as the following statement:
-/
抛弃先前的尝试，这种洞察可以编码为以下陈述：
```anchor nonTailEqHelper0
theorem non_tail_sum_eq_helper_accum (xs : List Nat) :
    (n : Nat) → n + NonTail.sum xs = Tail.sumHelper n xs := by
  skip
```
/-
In this statement, it's very important that {anchorName nonTailEqHelper0}`n` is part of the type that's after the colon.
The resulting goal begins with {lit}`∀ (n : Nat)`, which is short for “For all {lit}`n`”:
-/
在这个陈述中，{anchorName nonTailEqHelper0}`n` 是冒号后面类型的一部分，这一点非常重要。
结果目标以 {lit}`∀ (n : Nat)` 开头，这是「对于所有 {lit}`n`」的简写：

```anchorError nonTailEqHelper0
unsolved goals
xs : List Nat
⊢ ∀ (n : Nat), n + NonTail.sum xs = Tail.sumHelper n xs
```
-- Using the induction tactic results in goals that include this “for all” statement:
使用归纳策略会产生包含这个「对于所有」陈述的目标：
```anchor nonTailEqHelper1a
theorem non_tail_sum_eq_helper_accum (xs : List Nat) :
    (n : Nat) → n + NonTail.sum xs = Tail.sumHelper n xs := by
  induction xs with
  | nil => skip
  | cons y ys ih => skip
```
/-
In the {anchorName nonTailEqHelper1a}`nil` case, the goal is:
-/
在 {anchorName nonTailEqHelper1a}`nil` 情况下，目标是：
```anchorError nonTailEqHelper1a
unsolved goals
case nil
⊢ ∀ (n : Nat), n + NonTail.sum [] = Tail.sumHelper n []
```
-- For the induction step for {anchorName nonTailEqHelper1a}`cons`, both the induction hypothesis and the specific goal contain the “for all {lit}`n`”:
对于 {anchorName nonTailEqHelper1a}`cons` 的归纳步骤，归纳假设和具体目标都包含「对于所有 {lit}`n`」：

```anchorError nonTailEqHelper1b
unsolved goals
case cons
y : Nat
ys : List Nat
ih : ∀ (n : Nat), n + NonTail.sum ys = Tail.sumHelper n ys
⊢ ∀ (n : Nat), n + NonTail.sum (y :: ys) = Tail.sumHelper n (y :: ys)
```
In other words, the goal has become more challenging to prove, but the induction hypothesis is correspondingly more useful.

A mathematical proof for a statement that beings with “for all $`x`” should assume some arbitrary $`x`, and prove the statement.
“Arbitrary” means that no additional properties of $`x` are assumed, so the resulting statement will work for _any_ $`x`.
In Lean, a “for all” statement is a dependent function: no matter which specific value it is applied to, it will return evidence of the proposition.
Similarly, the process of picking an arbitrary $`x` is the same as using {lit}`fun x => ...`.
In the tactic language, this process of selecting an arbitrary $`x` is performed using the {kw}`intro` tactic, which produces the function behind the scenes when the tactic script has completed.
The {kw}`intro` tactic should be provided with the name to be used for this arbitrary value.

Using the {kw}`intro` tactic in the {anchorName nonTailEqHelper2}`nil` case removes the {lit}`∀ (n : Nat),` from the goal, and adds an assumption {lit}`n : Nat`:
```anchor nonTailEqHelper2
theorem non_tail_sum_eq_helper_accum (xs : List Nat) :
    (n : Nat) → n + NonTail.sum xs = Tail.sumHelper n xs := by
  induction xs with
  | nil => intro n
  | cons y ys ih => skip
```
```anchorError nonTailEqHelper2
unsolved goals
case nil
n : Nat
⊢ n + NonTail.sum [] = Tail.sumHelper n []
```
/-
Both sides of this propositional equality are definitionally equal to {anchorName nonTailEqHelper3}`n`, so {anchorTerm nonTailEqHelper3}`rfl` suffices:
-/
这个命题相等的两边在定义上都等于 {anchorName nonTailEqHelper3}`n`，所以 {anchorTerm nonTailEqHelper3}`rfl` 足够了：
```anchor nonTailEqHelper3
theorem non_tail_sum_eq_helper_accum (xs : List Nat) :
    (n : Nat) → n + NonTail.sum xs = Tail.sumHelper n xs := by
  induction xs with
  | nil =>
    intro n
    rfl
  | cons y ys ih => skip
```
The {anchorName nonTailEqHelper3}`cons` goal also contains a “for all”:
```anchorError nonTailEqHelper3
unsolved goals
case cons
y : Nat
ys : List Nat
ih : ∀ (n : Nat), n + NonTail.sum ys = Tail.sumHelper n ys
⊢ ∀ (n : Nat), n + NonTail.sum (y :: ys) = Tail.sumHelper n (y :: ys)
```
/-
This suggests the use of {kw}`intro`.
-/
这表明应该使用 {kw}`intro`。
```anchor nonTailEqHelper4
theorem non_tail_sum_eq_helper_accum (xs : List Nat) :
    (n : Nat) → n + NonTail.sum xs = Tail.sumHelper n xs := by
  induction xs with
  | nil =>
    intro n
    rfl
  | cons y ys ih =>
    intro n
```
```anchorError nonTailEqHelper4
unsolved goals
case cons
y : Nat
ys : List Nat
ih : ∀ (n : Nat), n + NonTail.sum ys = Tail.sumHelper n ys
n : Nat
⊢ n + NonTail.sum (y :: ys) = Tail.sumHelper n (y :: ys)
```
/-
The proof goal now contains both {anchorName nonTailEqHelper5}`NonTail.sum` and {anchorName nonTailEqHelper5}`Tail.sumHelper` applied to {lit}`y :: ys`.
The simplifier can make the next step more clear:
-/
证明目标现在包含应用于 {lit}`y :: ys` 的 {anchorName nonTailEqHelper5}`NonTail.sum` 和 {anchorName nonTailEqHelper5}`Tail.sumHelper`。
简化器可以使下一步更清晰：
```anchor nonTailEqHelper5
theorem non_tail_sum_eq_helper_accum (xs : List Nat) :
    (n : Nat) → n + NonTail.sum xs = Tail.sumHelper n xs := by
  induction xs with
  | nil =>
    intro n
    rfl
  | cons y ys ih =>
    intro n
    simp [NonTail.sum, Tail.sumHelper]
```
```anchorError nonTailEqHelper5
unsolved goals
case cons
y : Nat
ys : List Nat
ih : ∀ (n : Nat), n + NonTail.sum ys = Tail.sumHelper n ys
n : Nat
⊢ n + (y + NonTail.sum ys) = Tail.sumHelper (y + n) ys
```
/-
This goal is very close to matching the induction hypothesis.
There are two ways in which it does not match:
 * The left-hand side of the equation is {lit}`n + (y + NonTail.sum ys)`, but the induction hypothesis needs the left-hand side to be a number added to {lit}`NonTail.sum ys`.
   In other words, this goal should be rewritten to {lit}`(n + y) + NonTail.sum ys`, which is valid because addition of natural numbers is associative.
 * When the left side has been rewritten to {lit}`(y + n) + NonTail.sum ys`, the accumulator argument on the right side should be {lit}`n + y` rather than {lit}`y + n` in order to match.
   This rewrite is valid because addition is also commutative.
-/
这个目标非常接近匹配归纳假设。有两个方面不匹配：
 * 等式的左侧是 {lit}`n + (y + NonTail.sum ys)`，但归纳假设需要左侧是某个数字加上 {lit}`NonTail.sum ys`。
   换句话说，这个目标应该被重写为 {lit}`(n + y) + NonTail.sum ys`，这是有效的，因为自然数的加法是结合的。
 * 当左侧被重写为 {lit}`(y + n) + NonTail.sum ys` 时，右侧的累加器参数应该是 {lit}`n + y` 而非 {lit}`y + n` 才能匹配。
   这种重写是有效的，因为加法也是交换的。

/-
The associativity and commutativity of addition have already been proved in Lean's standard library.
The proof of associativity is named {anchorTerm NatAddAssoc}`Nat.add_assoc`, and its type is {anchorTerm NatAddAssoc}`(n m k : Nat) → (n + m) + k = n + (m + k)`, while the proof of commutativity is called {anchorTerm NatAddComm}`Nat.add_comm` and has type {anchorTerm NatAddComm}`(n m : Nat) → n + m = m + n`.
-/
加法的结合律和交换律已经在 Lean 的标准库中得到证明。
结合律的证明名为 {anchorTerm NatAddAssoc}`Nat.add_assoc`，其类型是 {anchorTerm NatAddAssoc}`(n m k : Nat) → (n + m) + k = n + (m + k)`，
而交换律的证明称为 {anchorTerm NatAddComm}`Nat.add_comm`，类型为 {anchorTerm NatAddComm}`(n m : Nat) → n + m = m + n`。
/-
Normally, the {kw}`rw` tactic is provided with an expression whose type is an equality.
However, if the argument is instead a dependent function whose return type is an equality, it attempts to find arguments to the function that would allow the equality to match something in the goal.
There is only one opportunity to apply associativity, though the direction of the rewrite must be reversed because the right side of the equality in {anchorTerm NatAddAssoc}`(n + m) + k = n + (m + k)` is the one that matches the proof goal:
-/
通常，{kw}`rw` 策略接受一个类型为等式的表达式。
但是，如果参数是一个返回类型为等式的依值函数，它会尝试找到函数的参数，使等式能够匹配目标中的某些内容。
只有一个机会应用结合律，尽管重写的方向必须颠倒，因为 {anchorTerm NatAddAssoc}`(n + m) + k = n + (m + k)` 中等式的右侧是与证明目标匹配的那一侧：
```anchor nonTailEqHelper6
theorem non_tail_sum_eq_helper_accum (xs : List Nat) :
    (n : Nat) → n + NonTail.sum xs = Tail.sumHelper n xs := by
  induction xs with
  | nil =>
    intro n
    rfl
  | cons y ys ih =>
    intro n
    simp [NonTail.sum, Tail.sumHelper]
    rw [←Nat.add_assoc]
```
```anchorError nonTailEqHelper6
unsolved goals
case cons
y : Nat
ys : List Nat
ih : ∀ (n : Nat), n + NonTail.sum ys = Tail.sumHelper n ys
n : Nat
⊢ n + y + NonTail.sum ys = Tail.sumHelper (y + n) ys
```
/-
Rewriting directly with {anchorTerm nonTailEqHelper7}`rw [Nat.add_comm]`, however, leads to the wrong result.
The {kw}`rw` tactic guesses the wrong location for the rewrite, leading to an unintended goal:
-/
然而，直接使用 {anchorTerm nonTailEqHelper7}`rw [Nat.add_comm]` 重写会导致错误的结果。
{kw}`rw` 策略猜测了错误的重写位置，导致非预期的目标：
```anchor nonTailEqHelper7
theorem non_tail_sum_eq_helper_accum (xs : List Nat) :
    (n : Nat) → n + NonTail.sum xs = Tail.sumHelper n xs := by
  induction xs with
  | nil =>
    intro n
    rfl
  | cons y ys ih =>
    intro n
    simp [NonTail.sum, Tail.sumHelper]
    rw [←Nat.add_assoc]
    rw [Nat.add_comm]
```
```anchorError nonTailEqHelper7
unsolved goals
case cons
y : Nat
ys : List Nat
ih : ∀ (n : Nat), n + NonTail.sum ys = Tail.sumHelper n ys
n : Nat
⊢ NonTail.sum ys + (n + y) = Tail.sumHelper (y + n) ys
```
/-
This can be fixed by explicitly providing {anchorName nonTailEqHelper8}`y` and {anchorName nonTailEqHelper8}`n` as arguments to {anchorName nonTailEqHelper8}`Nat.add_comm`:
-/
这可以通过显式地将 {anchorName nonTailEqHelper8}`y` 和 {anchorName nonTailEqHelper8}`n` 作为参数提供给 {anchorName nonTailEqHelper8}`Nat.add_comm` 来修复：
```anchor nonTailEqHelper8
theorem non_tail_sum_eq_helper_accum (xs : List Nat) :
    (n : Nat) → n + NonTail.sum xs = Tail.sumHelper n xs := by
  induction xs with
  | nil =>
    intro n
    rfl
  | cons y ys ih =>
    intro n
    simp [NonTail.sum, Tail.sumHelper]
    rw [←Nat.add_assoc]
    rw [Nat.add_comm y n]
```
```anchorError nonTailEqHelper8
unsolved goals
case cons
y : Nat
ys : List Nat
ih : ∀ (n : Nat), n + NonTail.sum ys = Tail.sumHelper n ys
n : Nat
⊢ n + y + NonTail.sum ys = Tail.sumHelper (n + y) ys
```
/-
The goal now matches the induction hypothesis.
In particular, the induction hypothesis's type is a dependent function type.
Applying {anchorName nonTailEqHelperDone}`ih` to {anchorTerm nonTailEqHelperDone}`n + y` results in exactly the desired type.
The {kw}`exact` tactic completes a proof goal if its argument has exactly the desired type:
-/
目标现在匹配归纳假设。特别地，归纳假设的类型是一个依值函数类型。
将 {anchorName nonTailEqHelperDone}`ih` 应用于 {anchorTerm nonTailEqHelperDone}`n + y` 会得到完全期望的类型。
{kw}`exact` 策略在其参数具有完全期望的类型时完成证明目标：

```anchor nonTailEqHelperDone
theorem non_tail_sum_eq_helper_accum (xs : List Nat) :
    (n : Nat) → n + NonTail.sum xs = Tail.sumHelper n xs := by
  induction xs with
  | nil => intro n; rfl
  | cons y ys ih =>
    intro n
    simp [NonTail.sum, Tail.sumHelper]
    rw [←Nat.add_assoc]
    rw [Nat.add_comm y n]
    exact ih (n + y)
```

/-
The actual proof requires only a little additional work to get the goal to match the helper's type.
The first step is still to invoke function extensionality:
-/
实际的证明只需要一点额外的工作来使目标匹配辅助函数的类型。
第一步仍然是调用函数外延性：
```anchor nonTailEqReal0
theorem non_tail_sum_eq_tail_sum : NonTail.sum = Tail.sum := by
  funext xs
```
```anchorError nonTailEqReal0
unsolved goals
case h
xs : List Nat
⊢ NonTail.sum xs = Tail.sum xs
```
/-
The next step is unfold {anchorName nonTailEqReal1}`Tail.sum`, exposing {anchorName TailSum}`Tail.sumHelper`:
-/
下一步是展开 {anchorName nonTailEqReal1}`Tail.sum`，暴露 {anchorName TailSum}`Tail.sumHelper`：
```anchor nonTailEqReal1
theorem non_tail_sum_eq_tail_sum : NonTail.sum = Tail.sum := by
  funext xs
  simp [Tail.sum]
```
```anchorError nonTailEqReal1
unsolved goals
case h
xs : List Nat
⊢ NonTail.sum xs = Tail.sumHelper 0 xs
```
/-
Having done this, the types almost match.
However, the helper has an additional addend on the left side.
In other words, the proof goal is {lit}`NonTail.sum xs = Tail.sumHelper 0 xs`, but applying {anchorName nonTailEqHelper0}`non_tail_sum_eq_helper_accum` to {anchorName nonTailEqReal2}`xs` and {anchorTerm NatZeroAdd}`0` yields the type {lit}`0 + NonTail.sum xs = Tail.sumHelper 0 xs`.
Another standard library proof, {anchorTerm NatZeroAdd}`Nat.zero_add`, has type {anchorTerm NatZeroAdd}`(n : Nat) → 0 + n = n`.
Applying this function to {anchorTerm nonTailEqReal2}`NonTail.sum xs` results in an expression with type {anchorTerm NatZeroAddApplied}`0 + NonTail.sum xs = NonTail.sum xs`, so rewriting from right to left results in the desired goal:
-/
这样做后，类型几乎匹配。但是，辅助函数在左侧有一个额外的加数。
换句话说，证明目标是 {lit}`NonTail.sum xs = Tail.sumHelper 0 xs`，但将 {anchorName nonTailEqHelper0}`non_tail_sum_eq_helper_accum` 应用于 {anchorName nonTailEqReal2}`xs` 和 {anchorTerm NatZeroAdd}`0` 得到类型 {lit}`0 + NonTail.sum xs = Tail.sumHelper 0 xs`。
另一个标准库证明 {anchorTerm NatZeroAdd}`Nat.zero_add` 的类型是 {anchorTerm NatZeroAdd}`(n : Nat) → 0 + n = n`。
将此函数应用于 {anchorTerm nonTailEqReal2}`NonTail.sum xs` 会得到类型为 {anchorTerm NatZeroAddApplied}`0 + NonTail.sum xs = NonTail.sum xs` 的表达式，因此从右到左重写会得到期望的目标：
```anchor nonTailEqReal2
theorem non_tail_sum_eq_tail_sum : NonTail.sum = Tail.sum := by
  funext xs
  simp [Tail.sum]
  rw [←Nat.zero_add (NonTail.sum xs)]
```
```anchorError nonTailEqReal2
unsolved goals
case h
xs : List Nat
⊢ 0 + NonTail.sum xs = Tail.sumHelper 0 xs
```
/-
Finally, the helper can be used to complete the proof:
-/
最后，可以使用辅助函数来完成证明：

```anchor nonTailEqRealDone
theorem non_tail_sum_eq_tail_sum : NonTail.sum = Tail.sum := by
  funext xs
  simp [Tail.sum]
  rw [←Nat.zero_add (NonTail.sum xs)]
  exact non_tail_sum_eq_helper_accum xs 0
```

/-
This proof demonstrates a general pattern that can be used when proving that an accumulator-passing tail-recursive function is equal to the non-tail-recursive version.
The first step is to discover the relationship between the starting accumulator argument and the final result.
For instance, beginning {anchorName TailSum}`Tail.sumHelper` with an accumulator of {anchorName accum_stmt}`n` results in the final sum being added to {anchorName accum_stmt}`n`, and beginning {anchorName accum_stmt}`Tail.reverseHelper` with an accumulator of {anchorName accum_stmt}`ys` results in the final reversed list being prepended to {anchorName accum_stmt}`ys`.
The second step is to write down this relationship as a theorem statement and prove it by induction.
While the accumulator is always initialized with some neutral value in practice, such as {anchorTerm TailSum}`0` or {anchorTerm accum_stmt}`[]`, this more general statement that allows the starting accumulator to be any value is what's needed to get a strong enough induction hypothesis.
Finally, using this helper theorem with the actual initial accumulator value results in the desired proof.
For example, in {anchorName nonTailEqRealDone}`non_tail_sum_eq_tail_sum`, the accumulator is specified to be {anchorTerm TailSum}`0`.
This may require rewriting the goal to make the neutral initial accumulator values occur in the right place.
-/
这个证明演示了一个通用模式，可用于证明累加器传递的尾递归函数等于非尾递归版本。
第一步是发现起始累加器参数和最终结果之间的关系。
例如，以累加器 {anchorName accum_stmt}`n` 开始 {anchorName TailSum}`Tail.sumHelper` 会导致最终和被添加到 {anchorName accum_stmt}`n` 上，
而以累加器 {anchorName accum_stmt}`ys` 开始 {anchorName accum_stmt}`Tail.reverseHelper` 会导致最终反转的列表被前置到 {anchorName accum_stmt}`ys` 上。
第二步是将这种关系写成定理陈述并通过归纳证明它。
虽然在实践中累加器总是用某个中性值初始化，例如 {anchorTerm TailSum}`0` 或 {anchorTerm accum_stmt}`[]`，
但这个更通用的陈述允许起始累加器为任何值，这是获得足够强的归纳假设所需要的。
最后，将这个辅助定理与实际的初始累加器值一起使用会产生所需的证明。
例如，在 {anchorName nonTailEqRealDone}`non_tail_sum_eq_tail_sum` 中，累加器被指定为 {anchorTerm TailSum}`0`。
这可能需要重写目标以使中性初始累加器值出现在正确的位置。



# 练习

## 热身

/-
Write your own proofs for {anchorName NatZeroAdd}`Nat.zero_add`, {anchorName NatAddAssoc}`Nat.add_assoc`, and {anchorName NatAddComm}`Nat.add_comm` using the {kw}`induction` tactic.
-/
使用 {kw}`induction` 策略为 {anchorName NatZeroAdd}`Nat.zero_add`、{anchorName NatAddAssoc}`Nat.add_assoc` 和 {anchorName NatAddComm}`Nat.add_comm` 编写你自己的证明。

## 更多累加器证明

### 反转列表

/-
Adapt the proof for {anchorName NonTailSum}`sum` into a proof for {anchorName NonTailReverse}`NonTail.reverse` and {anchorName TailReverse}`Tail.reverse`.
The first step is to think about the relationship between the accumulator value being passed to {anchorName TailReverse}`Tail.reverseHelper` and the non-tail-recursive reverse.
Just as adding a number to the accumulator in {anchorName TailSum}`Tail.sumHelper` is the same as adding it to the overall sum, using {anchorName names}`List.cons` to add a new entry to the accumulator in {anchorName TailReverse}`Tail.reverseHelper` is equivalent to some change to the overall result.
Try three or four different accumulator values with pencil and paper until the relationship becomes clear.
Use this relationship to prove a suitable helper theorem.
Then, write down the overall theorem.
Because {anchorName reverseEqStart}`NonTail.reverse` and {anchorName TailReverse}`Tail.reverse` are polymorphic, stating their equality requires the use of {lit}`@` to stop Lean from trying to figure out which type to use for {anchorName reverseEqStart}`α`.
Once {anchorName reverseEqStart}`α` is treated as an ordinary argument, {kw}`funext` should be invoked with both {anchorName reverseEqStart}`α` and {anchorName reverseEqStart}`xs`:
-/
将 {anchorName NonTailSum}`sum` 的证明调整为 {anchorName NonTailReverse}`NonTail.reverse` 和 {anchorName TailReverse}`Tail.reverse` 的证明。
第一步是思考传递给 {anchorName TailReverse}`Tail.reverseHelper` 的累加器值与非尾递归反转之间的关系。
正如在 {anchorName TailSum}`Tail.sumHelper` 中向累加器添加数字与向总和添加数字相同，
使用 {anchorName names}`List.cons` 向 {anchorName TailReverse}`Tail.reverseHelper` 中的累加器添加新条目等价于对总体结果的某种更改。
用纸和笔尝试三或四个不同的累加器值，直到关系变得清晰。
使用这种关系来证明一个合适的辅助定理。然后，写下总体定理。
因为 {anchorName reverseEqStart}`NonTail.reverse` 和 {anchorName TailReverse}`Tail.reverse` 是多态的，
陈述它们的相等性需要使用 {lit}`@` 来阻止 Lean 尝试确定对 {anchorName reverseEqStart}`α` 使用哪种类型。
一旦 {anchorName reverseEqStart}`α` 被视为普通参数，应该同时对 {anchorName reverseEqStart}`α` 和 {anchorName reverseEqStart}`xs` 调用 {kw}`funext`：
```anchor reverseEqStart
theorem non_tail_reverse_eq_tail_reverse :
    @NonTail.reverse = @Tail.reverse := by
  funext α xs
```
/-
This results in a suitable goal:
-/
这会产生一个合适的目标：
```anchorError reverseEqStart
unsolved goals
case h.h
α : Type u_1
xs : List α
⊢ NonTail.reverse xs = Tail.reverse xs
```


### 阶乘

/-
Prove that {anchorName NonTailFact}`NonTail.factorial` from the exercises in the previous section is equal to your tail-recursive solution by finding the relationship between the accumulator and the result and proving a suitable helper theorem.
-/
通过找到累加器和结果之间的关系并证明一个合适的辅助定理，
证明上一节练习中的 {anchorName NonTailFact}`NonTail.factorial` 等于你的尾递归版本的解决方案。
