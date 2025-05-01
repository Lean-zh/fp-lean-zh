<!--
# Proving Equivalence
-->

# 证明等价 { #proving-equivalence }

<!--
Programs that have been rewritten to use tail recursion and an accumulator can look quite different from the original program.
The original recursive function is often much easier to understand, but it runs the risk of exhausting the stack at run time.
After testing both versions of the program on examples to rule out simple bugs, proofs can be used to show once and for all that the programs are equivalent.
-->

重写为使用尾递归和累加器的程序可能看起来与原始程序非常不同。
原始递归函数通常更容易理解，但它有在运行时耗尽栈的风险。
在用示例测试程序的两个版本以排除简单错误后，可以使用证明来一劳永逸地证明二者是等价的。

<!--
## Proving `sum` Equal
-->

## 证明 `sum` 相等 { #proving-sum-equal }

<!--
To prove that both versions of `sum` are equal, begin by writing the theorem statement with a stub proof:
-->

要证明 `sum` 的两个版本相等，首先用桩（stub）证明编写定理的陈述：

```leantac
{{#example_in Examples/ProgramsProofs/TCO.lean sumEq0}}
```

<!--
As expected, Lean describes an unsolved goal:
-->

正如预期，Lean 描述了一个未解决的目标：

```output error
{{#example_out Examples/ProgramsProofs/TCO.lean sumEq0}}
```

<!--
The `rfl` tactic cannot be applied here, because `NonTail.sum` and `Tail.sum` are not definitionally equal.
Functions can be equal in more ways than just definitional equality, however.
It is also possible to prove that two functions are equal by proving that they produce equal outputs for the same input.
In other words, \\( f = g \\) can be proved by proving that \\( f(x) = g(x) \\) for all possible inputs \\( x \\).
This principle is called _function extensionality_.
Function extensionality is exactly the reason why `NonTail.sum` equals `Tail.sum`: they both sum lists of numbers.
-->

`rfl` 策略无法在此处应用，因为 `NonTail.sum` 和 `Tail.sum` 在定义上不相等。
然而，函数除了定义相等外还存在更多相等的方式。还可以通过证明两个函数对相同输入产生相等输出，
来证明它们相等。换句话说，可以通过证明「对于所有可能的输入 \\( x \\)，
都有 \\( f(x) = g(x) \\)」来证明 \\( f = g \\)。此原理称为 **函数外延性（Function Extensionality）**。
函数外延性正是 `NonTail.sum` 等于 `Tail.sum` 的原因：它们都对数字列表求和。

<!--
In Lean's tactic language, function extensionality is invoked using `funext`, followed by a name to be used for the arbitrary argument.
The arbitrary argument is added as an assumption to the context, and the goal changes to require a proof that the functions applied to this argument are equal:
-->

在 Lean 的策略语言中，可使用 `funext` 调用函数外延性，后跟一个用于任意参数的名称。
任意参数会作为假设添加到语境中，目标变为证明应用于此参数的函数相等：

```leantac
{{#example_in Examples/ProgramsProofs/TCO.lean sumEq1}}
```

```output error
{{#example_out Examples/ProgramsProofs/TCO.lean sumEq1}}
```

<!--
This goal can be proved by induction on the argument `xs`.
Both `sum` functions return `0` when applied to the empty list, which serves as a base case.
Adding a number to the beginning of the input list causes both functions to add that number to the result, which serves as an induction step.
Invoking the `induction` tactic results in two goals:
-->

此目标可通过对参数 `xs` 进行归纳来证明。当应用于空列表时，`sum` 函数都返回 `0`，这是基本情况。
在输入列表的开头添加一个数字会让两个函数都将该数字添加到结果中，这是归纳步骤。
调用 `induction` 策略会产生两个目标：

```leantac
{{#example_in Examples/ProgramsProofs/TCO.lean sumEq2a}}
```

```output error
{{#example_out Examples/ProgramsProofs/TCO.lean sumEq2a}}
```

```output error
{{#example_out Examples/ProgramsProofs/TCO.lean sumEq2b}}
```

<!--
The base case for `nil` can be solved using `rfl`, because both functions return `0` when passed the empty list:
-->

`nil` 的基本情况可以使用 `rfl` 解决，因为当传递空列表时，两个函数都返回 `0`：

```leantac
{{#example_in Examples/ProgramsProofs/TCO.lean sumEq3}}
```

<!--
The first step in solving the induction step is to simplify the goal, asking `simp` to unfold `NonTail.sum` and `Tail.sum`:
-->

解决归纳步骤的第一步是简化目标，要求 `simp` 展开 `NonTail.sum` 和 `Tail.sum`：

```leantac
{{#example_in Examples/ProgramsProofs/TCO.lean sumEq4}}
```

```output error
{{#example_out Examples/ProgramsProofs/TCO.lean sumEq4}}
```

<!--
Unfolding `Tail.sum` revealed that it immediately delegates to `Tail.sumHelper`, which should also be simplified:
-->

展开 `Tail.sum` 会发现它直接委托给了 `Tail.sumHelper`，它也应该被简化：

```leantac
{{#example_in Examples/ProgramsProofs/TCO.lean sumEq5}}
```

<!--
In the resulting goal, `sumHelper` has taken a step of computation and added `y` to the accumulator:
-->

在结果目标中，`sumHelper` 执行了一步计算并将 `y` 加到累加器上：

```output error
{{#example_out Examples/ProgramsProofs/TCO.lean sumEq5}}
```

<!--
Rewriting with the induction hypothesis removes all mentions of `NonTail.sum` from the goal:
-->

使用归纳假设重写会从目标中删除所有 `NonTail.sum` 的引用：

```leantac
{{#example_in Examples/ProgramsProofs/TCO.lean sumEq6}}
```

```output error
{{#example_out Examples/ProgramsProofs/TCO.lean sumEq6}}
```

<!--
This new goal states that adding some number to the sum of a list is the same as using that number as the initial accumulator in `sumHelper`.
For the sake of clarity, this new goal can be proved as a separate theorem:
-->

这个新目标表明，将某个数字加到列表的和中与在 `sumHelper` 中使用该数字作为初始累加器相同。
为了清晰起见，这个新目标可以作为独立的定理来证明：

```leantac
{{#example_in Examples/ProgramsProofs/TCO.lean sumEqHelperBad0}}
```

```output error
{{#example_out Examples/ProgramsProofs/TCO.lean sumEqHelperBad0}}
```

<!--
Once again, this is a proof by induction where the base case uses `rfl`:
-->

这又是一次归纳证明，其中基本情况使用 `rfl` 证明：

```leantac
{{#example_in Examples/ProgramsProofs/TCO.lean sumEqHelperBad1}}
```

```output error
{{#example_out Examples/ProgramsProofs/TCO.lean sumEqHelperBad1}}
```

<!--
Because this is an inductive step, the goal should be simplified until it matches the induction hypothesis `ih`.
Simplifying, using the definitions of `Tail.sum` and `Tail.sumHelper`, results in the following:
-->

由于这是一个归纳步骤，因此目标应该被简化，直到它与归纳假设 `ih` 匹配。
简化，然后使用 `Tail.sum` 和 `Tail.sumHelper` 的定义，得到以下结果：

```leantac
{{#example_in Examples/ProgramsProofs/TCO.lean sumEqHelperBad2}}
```

```output error
{{#example_out Examples/ProgramsProofs/TCO.lean sumEqHelperBad2}}
```

<!--
Ideally, the induction hypothesis could be used to replace `Tail.sumHelper (y + n) ys`, but they don't match.
The induction hypothesis can be used for `Tail.sumHelper n ys`, not `Tail.sumHelper (y + n) ys`.
In other words, this proof is stuck.
-->

理想情况下，归纳假设可以用来替换 `Tail.sumHelper (y + n) ys`，但它们不匹配。
归纳假设可用于 `Tail.sumHelper n ys`，而非 `Tail.sumHelper (y + n) ys`。
换句话说，这个证明到这里被卡住了。

<!--
## A Second Attempt
-->

## 第二次尝试 { #a-second-attempt }

<!--
Rather than attempting to muddle through the proof, it's time to take a step back and think.
Why is it that the tail-recursive version of the function is equal to the non-tail-recursive version?
Fundamentally speaking, at each entry in the list, the accumulator grows by the same amount as would be added to the result of the recursion.
This insight can be used to write an elegant proof.
Crucially, the proof by induction must be set up such that the induction hypothesis can be applied to _any_ accumulator value.
-->

与其试图弄清楚证明，不如退一步思考。为什么函数的尾递归版本等于非尾递归版本？
从根本上讲，在列表中的每个条目中，累加器都会增加与递归结果中添加的量相同的值。
这个见解可以用来写一个优雅的证明。
重点在于，归纳证明必须设置成归纳假设可以应用于 **任何** 累加器值。

<!--
Discarding the prior attempt, the insight can be encoded as the following statement:
-->

放弃之前的尝试，这个见解可以编码为以下陈述：

```leantac
{{#example_in Examples/ProgramsProofs/TCO.lean nonTailEqHelper0}}
```

<!--
In this statement, it's very important that `n` is part of the type that's after the colon.
The resulting goal begins with `∀ (n : Nat)`, which is short for "For all `n`":
-->

在这个陈述中，非常重要的是 `n` 是冒号后面类型的组成部分。
产生的目标以 `∀ (n : Nat)` 开头，这是「对于所有 `n`」的缩写：

```output error
{{#example_out Examples/ProgramsProofs/TCO.lean nonTailEqHelper0}}
```

<!--
Using the induction tactic results in goals that include this "for all" statement:
-->

使用归纳策略会产生包含这个「对于所有（for all）」语句的目标：

```leantac
{{#example_in Examples/ProgramsProofs/TCO.lean nonTailEqHelper1a}}
```

<!--
In the `nil` case, the goal is:
-->

在 `nil` 情况下，目标是：

```output error
{{#example_out Examples/ProgramsProofs/TCO.lean nonTailEqHelper1a}}
```

<!--
For the induction step for `cons`, both the induction hypothesis and the specific goal contain the "for all `n`":
-->

对于 `cons` 的归纳步骤，归纳假设和具体目标都包含「对于所有 `n`」：

```output error
{{#example_out Examples/ProgramsProofs/TCO.lean nonTailEqHelper1b}}
```

<!--
In other words, the goal has become more challenging to prove, but the induction hypothesis is correspondingly more useful.
-->

换句话说，目标变得更难证明，但归纳假设相应地更加有用。

<!--
A mathematical proof for a statement that beings with "for all \\( x \\)" should assume some arbitrary \\( x \\), and prove the statement.
"Arbitrary" means that no additional properties of \\( x \\) are assumed, so the resulting statement will work for _any_ \\( x \\).
In Lean, a "for all" statement is a dependent function: no matter which specific value it is applied to, it will return evidence of the proposition.
Similarly, the process of picking an arbitrary \\( x \\) is the same as using ``fun x => ...``.
In the tactic language, this process of selecting an arbitrary \\( x \\) is performed using the `intro` tactic, which produces the function behind the scenes when the tactic script has completed.
The `intro` tactic should be provided with the name to be used for this arbitrary value.
-->

对于以「对于所有 \\( x \\)」开头的陈述的数学证明应该假设存在任意的 \\( x \\)，
并证明该阐述。「任意」意味着不假设 \\( x \\) 的任何额外性质，因此结果语句将适用于 **任何** \\( x \\)。
在 Lean 中，「对于所有」语句是一个依值函数：无论将其应用于哪个特定值，它都将返回命题的证据。
类似地，选择任意 \\( x \\) 的过程与使用 `fun x => ...` 相同。在策略语言中，
选择任意 \\( x \\) 的过程是使用 `intro` 策略执行的，当策略脚本完成后，它会在幕后生成函数。
`intro` 策略应当被提供用于此任意值的名称。

<!--
Using the `intro` tactic in the `nil` case removes the `∀ (n : Nat),` from the goal, and adds an assumption `n : Nat`:
-->

在 `nil` 情况下使用 `intro` 策略会从目标中移除 `∀ (n : Nat),`，并添加假设 `n : Nat`：

```leantac
{{#example_in Examples/ProgramsProofs/TCO.lean nonTailEqHelper2}}
```

```output error
{{#example_out Examples/ProgramsProofs/TCO.lean nonTailEqHelper2}}
```

<!--
Both sides of this propositional equality are definitionally equal to `n`, so `rfl` suffices:
-->

此命题等式的两边在定义上等于 `n`，因此 `rfl` 就足够了：

```leantac
{{#example_in Examples/ProgramsProofs/TCO.lean nonTailEqHelper3}}
```

`cons` 目标也包含一个「对于所有」：

```output error
{{#example_out Examples/ProgramsProofs/TCO.lean nonTailEqHelper3}}
```

<!--
This suggests the use of `intro`.
-->

这这里建议使用 `intro`。

```leantac
{{#example_in Examples/ProgramsProofs/TCO.lean nonTailEqHelper4}}
```

```output error
{{#example_out Examples/ProgramsProofs/TCO.lean nonTailEqHelper4}}
```

<!--
The proof goal now contains both `NonTail.sum` and `Tail.sumHelper` applied to `y :: ys`.
The simplifier can make the next step more clear:
-->

现在，证明目标包含应用于 `y :: ys` 的 `NonTail.sum` 和 `Tail.sumHelper`。
简化器可以使下一步更清晰：

```leantac
{{#example_in Examples/ProgramsProofs/TCO.lean nonTailEqHelper5}}
```

```output error
{{#example_out Examples/ProgramsProofs/TCO.lean nonTailEqHelper5}}
```

<!--
This goal is very close to matching the induction hypothesis.
There are two ways in which it does not match:

 * The left-hand side of the equation is `n + (y + NonTail.sum ys)`, but the induction hypothesis needs the left-hand side to be a number added to `NonTail.sum ys`.
   In other words, this goal should be rewritten to `(n + y) + NonTail.sum ys`, which is valid because addition of natural numbers is associative.
 * When the left side has been rewritten to `(y + n) + NonTail.sum ys`, the accumulator argument on the right side should be `n + y` rather than `y + n` in order to match.
   This rewrite is valid because addition is also commutative.
-->

此目标非常接近于匹配归纳假设。它不匹配的方面有两个：

 * 等式的左侧是 `n + (y + NonTail.sum ys)`，但归纳假设需要左侧是一个添加到 `NonTail.sum ys` 的数字。
   换句话说，此目标应重写为 `(n + y) + NonTail.sum ys`，这是有效的，因为自然数加法满足结合律。
 * 当左侧重写为 `(y + n) + NonTail.sum ys` 时，右侧的累加器参数应为 `n + y` 而非 `y + n` 以进行匹配。
   此重写是有效的，因为加法也满足交换律。

<!--
The associativity and commutativity of addition have already been proved in Lean's standard library.
The proof of associativity is named `{{#example_in Examples/ProgramsProofs/TCO.lean NatAddAssoc}}`, and its type is `{{#example_out Examples/ProgramsProofs/TCO.lean NatAddAssoc}}`, while the proof of commutativity is called `{{#example_in Examples/ProgramsProofs/TCO.lean NatAddComm}}` and has type `{{#example_out Examples/ProgramsProofs/TCO.lean NatAddComm}}`.
Normally, the `rw` tactic is provided with an expression whose type is an equality.
However, if the argument is instead a dependent function whose return type is an equality, it attempts to find arguments to the function that would allow the equality to match something in the goal.
There is only one opportunity to apply associativity, though the direction of the rewrite must be reversed because the right side of the equality in `{{#example_in Examples/ProgramsProofs/TCO.lean NatAddAssoc}}` is the one that matches the proof goal:
-->

The associativity and commutativity of addition have already been proved in Lean's standard library.
The proof of associativity is named `{{#example_in Examples/ProgramsProofs/TCO.lean NatAddAssoc}}`, and its type is `{{#example_out Examples/ProgramsProofs/TCO.lean NatAddAssoc}}`, while the proof of commutativity is called `{{#example_in Examples/ProgramsProofs/TCO.lean NatAddComm}}` and has type `{{#example_out Examples/ProgramsProofs/TCO.lean NatAddComm}}`.
Normally, the `rw` tactic is provided with an expression whose type is an equality.
However, if the argument is instead a dependent function whose return type is an equality, it attempts to find arguments to the function that would allow the equality to match something in the goal.
There is only one opportunity to apply associativity, though the direction of the rewrite must be reversed because the right side of the equality in `{{#example_in Examples/ProgramsProofs/TCO.lean NatAddAssoc}}` is the one that matches the proof goal:

加法的结合律和交换律已在 Lean 的标准库中得到证明。结合律的证明名为
`{{#example_in Examples/ProgramsProofs/TCO.lean NatAddAssoc}}`，
其类型为 `{{#example_out Examples/ProgramsProofs/TCO.lean NatAddAssoc}}`，
而交换律的证明称为 `{{#example_in Examples/ProgramsProofs/TCO.lean NatAddComm}}`，
其类型为 `{{#example_out Examples/ProgramsProofs/TCO.lean NatAddComm}}`。
通常，`rw` 策略会提供一个类型为等式的表达式。但是，如果参数是一个返回类型为等式的相关函数，
它会尝试查找函数的参数，以便等式可以匹配目标中的某个内容。
虽然必须反转重写方向，但只有一种机会应用结合律，
因为 `{{#example_in Examples/ProgramsProofs/TCO.lean NatAddAssoc}}`
中等式的右侧是与证明目标匹配的：

```leantac
{{#example_in Examples/ProgramsProofs/TCO.lean nonTailEqHelper6}}
```

```output error
{{#example_out Examples/ProgramsProofs/TCO.lean nonTailEqHelper6}}
```

<!--
Rewriting directly with `{{#example_in Examples/ProgramsProofs/TCO.lean NatAddComm}}`, however, leads to the wrong result.
The `rw` tactic guesses the wrong location for the rewrite, leading to an unintended goal:
-->

然而，直接使用 `{{#example_in Examples/ProgramsProofs/TCO.lean NatAddComm}}`
重写会导致错误的结果。`rw` 策略猜测了错误的重写位置，导致了意料之外的目标：

```leantac
{{#example_in Examples/ProgramsProofs/TCO.lean nonTailEqHelper7}}
```

```output error
{{#example_out Examples/ProgramsProofs/TCO.lean nonTailEqHelper7}}
```

<!--
This can be fixed by explicitly providing `y` and `n` as arguments to `Nat.add_comm`:
-->

可以通过显式地将 `y` 和 `n` 作为参数提供给 `Nat.add_comm` 来解决此问题：

```leantac
{{#example_in Examples/ProgramsProofs/TCO.lean nonTailEqHelper8}}
```

```output error
{{#example_out Examples/ProgramsProofs/TCO.lean nonTailEqHelper8}}
```

<!--
The goal now matches the induction hypothesis.
In particular, the induction hypothesis's type is a dependent function type.
Applying `ih` to `n + y` results in exactly the desired type.
The `exact` tactic completes a proof goal if its argument has exactly the desired type:
-->

现在目标与归纳假设相匹配了。特别是，归纳假设的类型是一个依值函数类型。
将 `ih` 应用于 `n + y` 会产生刚好期望的类型。如果其参数具有期望的类型，
`exact` 策略会完成证明目标：

```leantac
{{#example_decl Examples/ProgramsProofs/TCO.lean nonTailEqHelperDone}}
```

<!--
The actual proof requires only a little additional work to get the goal to match the helper's type.
The first step is still to invoke function extensionality:
-->

实际的证明只需要一些额外的工作即可使目标与辅助函数的类型相匹配。
第一步仍然是调用函数外延性：

```leantac
{{#example_in Examples/ProgramsProofs/TCO.lean nonTailEqReal0}}
```

```output error
{{#example_out Examples/ProgramsProofs/TCO.lean nonTailEqReal0}}
```

<!--
The next step is unfold `Tail.sum`, exposing `Tail.sumHelper`:
-->

下一步是展开 `Tail.sum`，暴露出 `Tail.sumHelper`：

```leantac
{{#example_in Examples/ProgramsProofs/TCO.lean nonTailEqReal1}}
```

```output error
{{#example_out Examples/ProgramsProofs/TCO.lean nonTailEqReal1}}
```

<!--
Having done this, the types almost match.
However, the helper has an additional addend on the left side.
In other words, the proof goal is `NonTail.sum xs = Tail.sumHelper 0 xs`, but applying `non_tail_sum_eq_helper_accum` to `xs` and `0` yields the type `0 + NonTail.sum xs = Tail.sumHelper 0 xs`.
Another standard library proof, `{{#example_in Examples/ProgramsProofs/TCO.lean NatZeroAdd}}`, has type `{{#example_out Examples/ProgramsProofs/TCO.lean NatZeroAdd}}`.
Applying this function to `NonTail.sum xs` results in an expression with type `{{#example_out Examples/ProgramsProofs/TCO.lean NatZeroAddApplied}}`, so rewriting from right to left results in the desired goal:
-->

完成这一步后，类型已经近乎匹配了。但是，辅助类型在左侧有一个额外的加数。
换句话说，证明目标是 `NonTail.sum xs = Tail.sumHelper 0 xs`，
但将 `non_tail_sum_eq_helper_accum` 应用于 `xs` 和 `0` 会产生类型
`0 + NonTail.sum xs = Tail.sumHelper 0 xs`。
另一个标准库证明 `{{#example_in Examples/ProgramsProofs/TCO.lean NatZeroAdd}}` 的类型为
`{{#example_out Examples/ProgramsProofs/TCO.lean NatZeroAdd}}`。
将此函数应用于 `NonTail.sum xs` 会产生类型为
`{{#example_out Examples/ProgramsProofs/TCO.lean NatZeroAddApplied}}` 的表达式，
因此从右往左重写会产生期望的目标：

```leantac
{{#example_in Examples/ProgramsProofs/TCO.lean nonTailEqReal2}}
```

```output error
{{#example_out Examples/ProgramsProofs/TCO.lean nonTailEqReal2}}
```

<!--
Finally, the helper can be used to complete the proof:
-->

最后，可以使用辅助定理来完成证明：

```leantac
{{#example_decl Examples/ProgramsProofs/TCO.lean nonTailEqRealDone}}
```

<!--
This proof demonstrates a general pattern that can be used when proving that an accumulator-passing tail-recursive function is equal to the non-tail-recursive version.
The first step is to discover the relationship between the starting accumulator argument and the final result.
For instance, beginning `Tail.sumHelper` with an accumulator of `n` results in the final sum being added to `n`, and beginning `Tail.reverseHelper` with an accumulator of `ys` results in the final reversed list being prepended to `ys`.
The second step is to write down this relationship as a theorem statement and prove it by induction.
While the accumulator is always initialized with some neutral value in practice, such as `0` or `[]`, this more general statement that allows the starting accumulator to be any value is what's needed to get a strong enough induction hypothesis.
Finally, using this helper theorem with the actual initial accumulator value results in the desired proof.
For example, in `non_tail_sum_eq_tail_sum`, the accumulator is specified to be `0`.
This may require rewriting the goal to make the neutral initial accumulator values occur in the right place.
-->

此证明演示了在证明「累加器传递尾递归函数等于非尾递归版本」时可以使用的通用模式。
第一步是发现起始累加器参数和最终结果之间的关系。
例如，以 `n` 的累加器开始 `Tail.sumHelper` 会导致最终的和被添加到 `n` 中，
而以 `ys` 的累加器开始 `Tail.reverseHelper` 会导致最终反转的列表被前置到 `ys` 中。
第二步是将此关系写成定理陈述，并通过归纳法证明它。虽然在实践中，
累加器总是用一些中性值（Neutral，即幺元，例如 `0` 或 `[]`）初始化，
但允许起始累加器为任何值的更通用的陈述是获得足够强的归纳假设所需要的。
最后，将此辅助定理与实际的初始累加器值一起使用会产生期望的证明。
例如，在 `non_tail_sum_eq_tail_sum` 中，累加器指定为 `0`。
这可能需要重写目标以使中性初始累加器值出现在正确的位置。

<!--
## Exercise
-->

## 练习 { #exercise }

<!--
### Warming Up
-->

### 热身 { #warming-up }

<!--
Write your own proofs for `Nat.zero_add`, `Nat.add_assoc`, and `Nat.add_comm` using the `induction` tactic.
-->

使用 `induction` 策略编写你自己的 `Nat.zero_add`、`Nat.add_assoc` 和 `Nat.add_comm` 的证明。

<!--
### More Accumulator Proofs
-->

### 更多累加器证明 { #more-accumulator-proofs }

<!--
#### Reversing Lists
-->

#### 反转列表 { #reversing-lists }

<!--
Adapt the proof for `sum` into a proof for `NonTail.reverse` and `Tail.reverse`.
The first step is to think about the relationship between the accumulator value being passed to `Tail.reverseHelper` and the non-tail-recursive reverse.
Just as adding a number to the accumulator in `Tail.sumHelper` is the same as adding it to the overall sum, using `List.cons` to add a new entry to the accumulator in `Tail.reverseHelper` is equivalent to some change to the overall result.
Try three or four different accumulator values with pencil and paper until the relationship becomes clear.
Use this relationship to prove a suitable helper theorem.
Then, write down the overall theorem.
Because `NonTail.reverse` and `Tail.reverse` are polymorphic, stating their equality requires the use of `@` to stop Lean from trying to figure out which type to use for `α`.
Once `α` is treated as an ordinary argument, `funext` should be invoked with both `α` and `xs`:
-->

将 `sum` 的证明调整为 `NonTail.reverse` 和 `Tail.reverse` 的证明。
第一步是思考传递给 `Tail.reverseHelper` 的累加器值与非尾递归反转之间的关系。
正如在 `Tail.sumHelper` 中将数字添加到累加器中与将其添加到整体的和中相同，
在 `Tail.reverseHelper` 中使用 `List.cons` 将新条目添加到累加器中相当于对整体结果进行了一些更改。
用纸和笔尝试三个或四个不同的累加器值，直到关系变得清晰。
使用此关系来证明一个合适的辅助定理。然后，写下整体定理。
因为 `NonTail.reverse` 和 `Tail.reverse` 是多态的，所以声明它们的相等性需要使用
`@` 来阻止 Lean 尝试找出为 `α` 使用哪种类型。一旦 `α` 被视为一个普通参数，
`funext` 应该与 `α` 和 `xs` 一起调用：

```leantac
{{#example_in Examples/ProgramsProofs/TCO.lean reverseEqStart}}
```

<!--
This results in a suitable goal:
-->

这会产生一个合适的目标：

```output error
{{#example_out Examples/ProgramsProofs/TCO.lean reverseEqStart}}
```

<!--
#### Factorial
-->

#### 阶乘 { #factorial }

<!--
Prove that `NonTail.factorial` from the exercises in the previous section is equal to your tail-recursive solution by finding the relationship between the accumulator and the result and proving a suitable helper theorem.
-->

通过找到累加器和结果之间的关系并证明一个合适的辅助定理，
证明上一节练习中的 `NonTail.factorial` 等于你的尾递归版本的解决方案。