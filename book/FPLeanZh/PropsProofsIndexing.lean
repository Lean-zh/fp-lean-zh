import VersoManual
import FPLeanZh.Examples

open Verso.Genre Manual
open Verso Code External

open FPLeanZh -- Changed from FPLean

set_option verso.exampleProject "../examples"

set_option verso.exampleModule "Examples.Props"

set_option pp.rawOnError true

-- Interlude: Propositions, Proofs, and Indexing
#doc (Manual) "插曲：命题、证明与索引" =>
%%%
file := "PropsProofsIndexing"
number := false
htmlSplit := .never
%%%

/- Like many languages, Lean uses square brackets for indexing into arrays and lists.
For instance, if {moduleTerm}`woodlandCritters` is defined as follows:
-/
与许多语言一样，Lean 使用方括号对数组和列表进行索引。
例如，若 {moduleTerm}`woodlandCritters` 定义如下：

```anchor woodlandCritters
def woodlandCritters : List String :=
  ["hedgehog", "deer", "snail"]
```

/- then the individual components can be extracted:
-/
则可以提取各个组件：

```anchor animals
def hedgehog := woodlandCritters[0]
def deer := woodlandCritters[1]
def snail := woodlandCritters[2]
```

/- However, attempting to extract the fourth element results in a compile-time error, rather than a run-time error:
-/
然而，试图提取第四个元素会导致编译时错误，而非运行时错误：

```anchor outOfBounds
def oops := woodlandCritters[3]
```

```anchorError outOfBounds
failed to prove index is valid, possible solutions:
  - Use `have`-expressions to prove the index is valid
  - Use `a[i]!` notation instead, runtime check is performed, and 'Panic' error message is produced if index is not valid
  - Use `a[i]?` notation instead, result is an `Option` type
  - Use `a[i]'h` notation instead, where `h` is a proof that index is valid
⊢ 3 < woodlandCritters.length
```

/- This error message is saying Lean tried to automatically mathematically prove that {moduleTerm}`3 < woodlandCritters.length` (i.e. {moduleTerm}`3 < List.length woodlandCritters`), which would mean that the lookup was safe, but that it could not do so.
Out-of-bounds errors are a common class of bugs, and Lean uses its dual nature as a programming language and a theorem prover to rule out as many as possible.
-/
此错误消息表明 Lean 尝试自动数学证明 {moduleTerm}`3 < woodlandCritters.length`（即 {moduleTerm}`3 < List.length woodlandCritters`），
这意味着查找是安全的，但它无法做到。越界错误是一类常见的错误，而 Lean
会利用其作为编程语言和定理证明器的双重特性来排除尽可能多的错误。

/- Understanding how this works requires an understanding of three key ideas: propositions, proofs, and tactics.
-/
要理解它是如何工作的，需要理解三个关键概念：命题、证明与策略。

-- # Propositions and Proofs
# 命题与证明
%%%
tag := "propositions-and-proofs"
%%%

/- A _proposition_ is a statement that can be true or false.
All of the following English sentences are propositions:

 * $`1 + 1 = 2`
 * Addition is commutative.
 * There are infinitely many prime numbers.
 * $`1 + 1 = 15`
 * Paris is the capital of France.
 * Buenos Aires is the capital of South Korea.
 * All birds can fly.
-/
*命题（Proposition）* 是可以为真或为假的陈述句。以下所有句子都是命题：

 * $`1 + 1 = 2`
 * 加法满足交换律
 * 质数有无穷多个
 * $`1 + 1 = 15`
 * 巴黎是法国的首都
 * 布宜诺斯艾利斯是韩国的首都
 * 所有鸟都会飞

/- On the other hand, nonsense statements are not propositions.
Despite being grammatical, none of the following are propositions:
 * 1 + green = ice cream
 * All capital cities are prime numbers.
 * At least one gorg is a fleep.
-/
另一方面，无意义的陈述不是命题。以下都不是命题：

 * 1 + 绿色 = 冰激凌
 * 所有首都都是质数
 * 至少有一个韟韚是一个棴囄䪖

/- Propositions come in two varieties: those that are purely mathematical, relying only on our definitions of concepts, and those that are facts about the world.
Theorem provers like Lean are concerned with the former category, and have nothing to say about the flight capabilities of penguins or the legal status of cities.
-/
命题有两种类型：纯粹的数学命题，仅依赖于我们对概念的定义；以及关于世界的事实。
像 Lean 这样的定理证明器关注的是前一类，而对企鹅的飞行能力或城市的法律地位无话可说。

/- A _proof_ is a convincing argument that a proposition is true.
For mathematical propositions, these arguments make use of the definitions of the concepts that are involved as well as the rules of logical argumentation.
Most proofs are written for people to understand, and leave out many tedious details.
Computer-aided theorem provers like Lean are designed to allow mathematicians to write proofs while omitting many details, and it is the software's responsibility to fill in the missing explicit steps.
These steps can be mechanically checked.
This decreases the likelihood of oversights or mistakes.
-/
*证明（Proof）* 是说明命题是否为真的令人信服的论证。对于数学命题，
这些论证利用了所涉及概念的定义以及逻辑论证规则。
大多数证明都是为人的理解而写的，并省略了许多繁琐的细节。
像 Lean 这样的计算机辅助定理证明器旨在允许数学家在省略许多细节的情况下编写证明，
而软件负责填写缺失的明显步骤。这些步骤可以机械地检查。这降低了疏忽或出错的可能性。

/- In Lean, a program's type describes the ways it can be interacted with.
For instance, a program of type {moduleTerm}`Nat → List String` is a function that takes a {moduleTerm}`Nat` argument and produces a list of strings.
In other words, each type specifies what counts as a program with that type.
-/
在 Lean 中，程序的类型描述了与它交互的方式。例如，类型为 {moduleTerm}`Nat → List String`
的程序是一个函数，它接受一个 {moduleTerm}`Nat` 参数并生成一个字符串列表。
换句话说，每个类型都指定了具有该类型的程序的内容。

/- In Lean, propositions are in fact types.
They specify what counts as evidence that the statement is true.
The proposition is proved by providing this evidence, which is checked by Lean.
On the other hand, if the proposition is false, then it will be impossible to construct this evidence.
-/
在 Lean 中，命题即是类型。它们指定了语句为真的证据应有的内容。
通过提供此证据即可证明命题。另一方面，如果命题为假，则不可能构造此证据。

/- For example, the proposition $`1 + 1 = 2` can be written directly in Lean.
The evidence for this proposition is the constructor {moduleTerm}`rfl`, which is short for _reflexivity_.
In mathematics, a relation is _reflexive_ if every element is related to itself; this is a basic requirement in order to have a sensible notion of equality.
Because {moduleTerm}`1 + 1` computes to {moduleTerm}`2`, they are really the same thing:
-/
例如，命题 $`1 + 1 = 2` 可以直接写在 Lean 中。此命题的证据是构造子 {moduleTerm}`rfl`，
它是 *自反性（Reflexivity）* 的缩写：
在数学中，如果每个元素都与自身相关，则关系是 *自反的（reflexive）*；这是拥有合理相等概念的基本要求。
因为 {moduleTerm}`1 + 1` 计算为 {moduleTerm}`2`，所以它们实际上是同一件事：

```anchor onePlusOneIsTwo
def onePlusOneIsTwo : 1 + 1 = 2 := rfl
```

/- On the other hand, {moduleTerm}`rfl` does not prove the false proposition $`1 + 1 = 15`:
-/
另一方面，{moduleTerm}`rfl` 不能证明错误命题 $`1 + 1 = 15`：

```anchor onePlusOneIsFifteen
def onePlusOneIsFifteen : 1 + 1 = 15 := rfl
```

```anchorError onePlusOneIsFifteen
Type mismatch
  rfl
has type
  ?m.16 = ?m.16
but is expected to have type
  1 + 1 = 15
```

/- This error message indicates that {moduleTerm}`rfl` can prove that two expressions are equal when both sides of the equality statement are already the same number.
Because {moduleTerm}`1 + 1` evaluates directly to {moduleTerm}`2`, they are considered to be the same, which allows {moduleTerm}`onePlusOneIsTwo` to be accepted.
Just as {moduleTerm}`Type` describes types such as {moduleTerm}`Nat`, {moduleTerm}`String`, and {moduleTerm}`List (Nat × String × (Int → Float))` that represent data structures and functions, {moduleTerm}`Prop` describes propositions.
-/
此错误消息表明，当等式语句的两边已经是相同的数字时，{moduleTerm}`rfl` 可以证明两个表达式相等。
因为 {moduleTerm}`1 + 1` 直接计算为 {moduleTerm}`2`，所以它们被认为是相同的，这允许接受 {moduleTerm}`onePlusOneIsTwo`。
就像 {moduleTerm}`Type` 描述了表示数据结构和函数的类型（例如 {moduleTerm}`Nat`、{moduleTerm}`String` 和
{moduleTerm}`List (Nat × String × (Int → Float))`）一样，{moduleTerm}`Prop` 描述了命题。

/- When a proposition has been proven, it is called a _theorem_.
In Lean, it is conventional to declare theorems with the {kw}`theorem` keyword instead of {kw}`def`.
This helps readers see which declarations are intended to be read as mathematical proofs, and which are definitions.
Generally speaking, with a proof, what matters is that there is evidence that a proposition is true, but it's not particularly important _which_ evidence was provided.
With definitions, on the other hand, it matters very much which particular value is selected—after all, a definition of addition that always returns {anchorTerm SomeNats}`0` is clearly wrong.
-/
当一个命题被证明后，它被称为一个 *定理（Theorem）* 。
在 Lean 中，惯例是使用 {kw}`theorem` 关键字而非 {kw}`def` 来声明定理。
这有助于读者看出哪些声明旨在被解读为数学证明，哪些是定义。
一般来说，对于一个证明，重要的是有证据表明一个命题是真实的，
但提供 *哪个* 个证据并不特别重要。另一方面，对于定义，选择哪个特定值非常重要。
毕竟，一个总是返回 {anchorTerm SomeNats}`0` 的加法定义显然是错误的。

/- Because the details of a proof don't matter for later proofs, using the {kw}`theorem` keyword enables greater parallelism in the Lean compiler.
-/
因为证明的细节对后续证明不重要，所以使用 {kw}`theorem` 关键字可以提高 Lean 编译器的并行性。

/- The prior example could be rewritten as follows:
-/
前面的例子可以改写如下：

```anchor onePlusOneIsTwoProp
def OnePlusOneIsTwo : Prop := 1 + 1 = 2

theorem onePlusOneIsTwo : OnePlusOneIsTwo := rfl
```

-- # Tactics
# 策略
%%%
tag := "tactics"
%%%

/- Proofs are normally written using _tactics_, rather than by providing evidence directly.
Tactics are small programs that construct evidence for a proposition.
These programs run in a _proof state_ that tracks the statement that is to be proved (called the _goal_) along with the assumptions that are available to prove it.
Running a tactic on a goal results in a new proof state that contains new goals.
The proof is complete when all goals have been proven.
-/
证明通常使用 *策略（Tactic）* 来编写，而非直接提供证据。策略是为命题构建证据的小程序。
这些程序在一个 *证明状态（Proof State）* 中运行，该状态跟踪要证明的陈述（称为 *目标（Goal）*）
以及可用于证明它的假设。在目标上运行策略会产生一个包含新目标的新证明状态。
当所有目标都被证明后，证明就完成了。

/- To write a proof with tactics, begin the definition with {kw}`by`.
Writing {kw}`by` puts Lean into tactic mode until the end of the next indented block.
While in tactic mode, Lean provides ongoing feedback about the current proof state.
Written with tactics, {anchorTerm onePlusOneIsTwoTactics}`onePlusOneIsTwo` is still quite short:
-/
要使用策略编写证明，请以 {kw}`by` 开始定义。编写 {kw}`by` 会将 Lean 置于策略模式，
直到下一个缩进块的末尾。在策略模式下，Lean 会持续提供有关当前证明状态的反馈。
使用策略编写的 {anchorTerm onePlusOneIsTwoTactics}`onePlusOneIsTwo` 仍然很短：

```anchor onePlusOneIsTwoTactics
theorem onePlusOneIsTwo : 1 + 1 = 2 := by
  decide
```

/- The {tactic}`decide` tactic invokes a _decision procedure_, which is a program that can check whether a statement is true or false, returning a suitable proof in either case.
It is primarily used when working with concrete values like {anchorTerm SomeNats}`1` and {anchorTerm SomeNats}`2`.
The other important tactics in this book are {tactic}`simp`, short for “simplify,” and {tactic}`grind`, which can automatically prove many theorems.
-/
{tactic}`decide` 策略调用 *判定过程（decision procedure）*，这是一个可以检查语句是真还是假，并在两种情况下返回合适证明的程序。
它主要用于处理像 {anchorTerm SomeNats}`1` 和 {anchorTerm SomeNats}`2` 这样的具体值。
本书中其他重要的策略是 {tactic}`simp`（化简 simplify 的缩写）和策略 {tactic}`grind` ，它们能自动证明很多定理。

/- Tactics are useful for a number of reasons:
 1. Many proofs are complicated and tedious when written out down to the smallest detail, and tactics can automate these uninteresting parts.
 2. Proofs written with tactics are easier to maintain over time, because flexible automation can paper over small changes to definitions.
 3. Because a single tactic can prove many different theorems, Lean can use tactics behind the scenes to free users from writing proofs by hand. For instance, an array lookup requires a proof that the index is in bounds, and a tactic can typically construct that proof without the user needing to worry about it.
-/
策略在许多方面很有用：

 1. 许多证明在写到最小的细节时都复杂且乏味，而策略可以自动完成这些无趣的部分。
 2. 使用策略编写的证明更容易维护，因为灵活的自动化可以弥补定义的细微更改。
 3. 由于一个策略可以证明许多不同的定理，Lean 可以使用幕后的策略来解放用户亲手写证明。例如，数组查找需要证明索引在范围内，而策略通常可以在用户无需担心它的情况下构造该证明。

/- Behind the scenes, indexing notation uses a tactic to prove that the user's lookup operation is safe.
This tactic takes many facts about arithmetic into account, combining them with any locally-known facts to attempt to prove that the index is in bounds.
-/
在幕后，索引记法使用策略来证明用户的查找操作是安全的。
这个策略考虑了许多关于算术的事实，并将它们与任何局部已知的事实结合起来，试图证明索引在界限内。

/- The {tactic}`simp` tactic is a workhorse of Lean proofs.
It rewrites the goal to as simple a form as possible.
In many cases, this rewriting simplifies the statement so much that it can be automatically proved.
Behind the scenes, a detailed formal proof is constructed, but using {tactic}`simp` hides this complexity.
-/
{tactic}`simp` 策略是 Lean 证明的主力。
它将目标重写为尽可能简单的形式。在许多情况下，这种重写将语句简化到可以自动证明的程度。
在幕后，会构造一个详细的形式证明，但使用 {tactic}`simp` 隐藏了这种复杂性。

/- Like {tactic}`decide`, the {tactic}`grind` tactic is used to finish proofs.
It uses a collection of techniques from SMT solvers that can prove a wide variety of theorems.
Unlike {tactic}`simp`, {tactic}`grind` can never make progress towards a proof without completing it entirely; it either succeeds fully or fails.
The {tactic}`grind` tactic is very powerful, customizable, and extensible; due to this power and flexibility, its output when it fails to prove a theorem contains a lot of information that can help trained Lean users diagnose the reason for the failure.
This can be overwhelming in the beginning, so this chapter uses only {tactic}`decide` and {tactic}`simp`.
-/
正如 {tactic}`decide`，{tactic}`grind` 策略也用于完成证明。它运用了一系列来自 SMT 求解器的技术，可以证明各种各样的定理。与 {tactic}`simp` 策略不同，{tactic}`grind` 策略必须完整地完成证明过程才能取得进展；它要么完全成功，要么完全失败。
{tactic}`grind` 策略功能强大、可定制且可扩展；正因如此，当它证明定理失败时，其输出包含大量信息，可以帮助专业 Lean 用户诊断失败原因。一开始可能会觉得信息量太大，因此本章仅使用 {tactic}`decide` 和 {tactic}`simp` 策略。

-- # Connectives
# 连词
%%%
tag := "connectives"
%%%

/- The basic building blocks of logic, such as “and”, “or”, “true”, “false”, and “not”, are called {deftech}_logical connectives_.
Each connective defines what counts as evidence of its truth.
For example, to prove a statement “_A_ and _B_”, one must prove both _A_ and _B_.
This means that evidence for “_A_ and _B_” is a pair that contains both evidence for _A_ and evidence for _B_.
Similarly, evidence for “_A_ or _B_” consists of either evidence for _A_ or evidence for _B_.
-/
逻辑的基本构建块，例如「与」、「或」、「真」、「假」和「非」，称为 {deftech}*逻辑连词（Logical Connective）*。
每个连词定义了什么算作其真值的证据。例如，要证明一个陈述「_A_ 与 _B_」，必须证明 _A_ 和 _B_。
这意味着「_A_ 与 _B_」的证据是一对，其中包含 _A_ 的证据和 _B_ 的证据。
类似地，「_A_ 或 _B_」的证据由 _A_ 的证据或 _B_ 的证据组成。

/- In particular, most of these connectives are defined like datatypes, and they have constructors.
If {anchorTerm AndProp}`A` and {anchorTerm AndProp}`B` are propositions, then “{anchorTerm AndProp}`A` and {anchorTerm AndProp}`B`” (written {anchorTerm AndProp}`A ∧ B`) is a proposition.
Evidence for {anchorTerm AndProp}`A ∧ B` consists of the constructor {anchorTerm AndIntro}`And.intro`, which has the type {anchorTerm AndIntro}`A → B → A ∧ B`.
Replacing {anchorTerm AndIntro}`A` and {anchorTerm AndIntro}`B` with concrete propositions, it is possible to prove {anchorTerm AndIntroEx}`1 + 1 = 2 ∧ "Str".append "ing" = "String"` with {anchorTerm AndIntroEx}`And.intro rfl rfl`.
Of course, {tactic}`decide` is also powerful enough to find this proof:
-/
特别是，大多数这些连词都像数据类型一样定义，并且它们有构造子。若 {anchorTerm AndProp}`A` 和 {anchorTerm AndProp}`B` 是命题，
则「{anchorTerm AndProp}`A` 与 {anchorTerm AndProp}`B`」（写作 {anchorTerm AndProp}`A ∧ B`）也是一个命题。
{anchorTerm AndProp}`A ∧ B` 的证据由构造子 {anchorTerm AndIntro}`And.intro` 组成，
其类型为 {anchorTerm AndIntro}`A → B → A ∧ B`。用具体命题替换 {anchorTerm AndIntro}`A` 和 {anchorTerm AndIntro}`B`，
可以用 {anchorTerm AndIntroEx}`And.intro rfl rfl` 证明
{anchorTerm AndIntroEx}`1 + 1 = 2 ∧ "Str".append "ing" = "String"`。
当然，{tactic}`decide` 也足够强大到可以找到这个证明：

```anchor AndIntroExTac
theorem addAndAppend : 1 + 1 = 2 ∧ "Str".append "ing" = "String" := by
  decide
```


/- Similarly, “{anchorTerm OrProp}`A` or {anchorTerm OrProp}`B`” (written {anchorTerm OrProp}`A ∨ B`) has two constructors, because a proof of “{anchorTerm OrProp}`A` or {anchorTerm OrProp}`B`” requires only that one of the two underlying propositions be true.
There are two constructors: {anchorTerm OrIntro1}`Or.inl`, with type {anchorTerm OrIntro1}`A → A ∨ B`, and {anchorTerm OrIntro2}`Or.inr`, with type {anchorTerm OrIntro2}`B → A ∨ B`.
-/
与此类似，「{anchorTerm OrProp}`A` 或 {anchorTerm OrProp}`B`」（写作 {anchorTerm OrProp}`A ∨ B`）有两个构造子，
因为「{anchorTerm OrProp}`A` 或 {anchorTerm OrProp}`B`」的证明仅要求两个底层命题中的一个为真。它有两个构造子：
{anchorTerm OrIntro1}`Or.inl`，
类型为 {anchorTerm OrIntro1}`A → A ∨ B`；
以及 {anchorTerm OrIntro2}`Or.inr`，
类型为 {anchorTerm OrIntro2}`B → A ∨ B`。

/- Implication (if {anchorTerm impliesDef}`A` then {anchorTerm impliesDef}`B`) is represented using functions.
In particular, a function that transforms evidence for {anchorTerm impliesDef}`A` into evidence for {anchorTerm impliesDef}`B` is itself evidence that {anchorTerm impliesDef}`A` implies {anchorTerm impliesDef}`B`.
This is different from the usual description of implication, in which {anchorTerm impliesDef}`A → B` is shorthand for {anchorTerm impliesDef}`¬A ∨ B`, but the two formulations are equivalent.
-/
蕴含（若 {anchorTerm impliesDef}`A` 则 {anchorTerm impliesDef}`B`）使用函数表示。特别是，将 {anchorTerm impliesDef}`A` 的证据转换为 {anchorTerm impliesDef}`B`
的证据的函数本身就是 {anchorTerm impliesDef}`A` 蕴涵 {anchorTerm impliesDef}`B` 的证据。这与蕴含的通常描述不同，
其中 {anchorTerm impliesDef}`A → B` 是 {anchorTerm impliesDef}`¬A ∨ B` 的简写，但这两个式子是等价的。

/- Because evidence for an “and” is a constructor, it can be used with pattern matching.
For instance, a proof that {anchorTerm andImpliesOr}`A` and {anchorTerm andImpliesOr}`B` implies {anchorTerm andImpliesOr}`A` or {anchorTerm andImpliesOr}`B` is a function that pulls the evidence of {anchorTerm andImpliesOr}`A` (or of {anchorTerm andImpliesOr}`B`) out of the evidence for {anchorTerm andImpliesOr}`A` and {anchorTerm andImpliesOr}`B`, and then uses this evidence to produce evidence of {anchorTerm andImpliesOr}`A` or {anchorTerm andImpliesOr}`B`:
-/
由于「与」的证据是一个构造子，所以它可以与模式匹配一起使用。
例如，证明 {anchorTerm andImpliesOr}`A` 且 {anchorTerm andImpliesOr}`B` 蕴涵 {anchorTerm andImpliesOr}`A` 或 {anchorTerm andImpliesOr}`B` 的证明是一个函数，
它从 {anchorTerm andImpliesOr}`A` 和 {anchorTerm andImpliesOr}`B` 的证据中提取 {anchorTerm andImpliesOr}`A`（或 {anchorTerm andImpliesOr}`B`）的证据，然后使用此证据来生成 {anchorTerm andImpliesOr}`A` 或 {anchorTerm andImpliesOr}`B` 的证据：

```anchor andImpliesOr
theorem andImpliesOr : A ∧ B → A ∨ B :=
  fun andEvidence =>
    match andEvidence with
    | And.intro a b => Or.inl a
```

/-
:::table +header
*
  - Connective
  - Lean Syntax
  - Evidence
*
 -  True
 -  {anchorName connectiveTable}`True`
 -  {anchorTerm connectiveTable}`True.intro : True`

*
 -  False
 -  {anchorName connectiveTable}`False`
 -  No evidence

*
 -  {anchorName connectiveTable}`A` and {anchorName connectiveTable}`B`
 -  {anchorTerm connectiveTable}`A ∧ B`
 -  {anchorTerm connectiveTable}`And.intro : A → B → A ∧ B`

*
 -  {anchorName connectiveTable}`A` or {anchorName connectiveTable}`B`
 -  {anchorTerm connectiveTable}`A ∨ B`
 -  Either {anchorTerm connectiveTable}`Or.inl : A → A ∨ B` or {anchorTerm connectiveTable}`Or.inr : B → A ∨ B`

*
 -  {anchorName connectiveTable}`A` implies {anchorName connectiveTable}`B`
 -  {anchorTerm connectiveTable}`A → B`
 -  A function that transforms evidence of {anchorName connectiveTable}`A` into evidence of {anchorName connectiveTable}`B`

*
 -  not {anchorName connectiveTable}`A`
 -  {anchorTerm connectiveTable}`¬A`
 -  A function that would transform evidence of {anchorName connectiveTable}`A` into evidence of {anchorName connectiveTable}`False`
:::
-/

:::table +header
*
  - 连词
  - Lean 语法
  - 证据
*
 -  真
 -  {anchorName connectiveTable}`True`
 -  {anchorTerm connectiveTable}`True.intro : True`

*
 -  假
 -  {anchorName connectiveTable}`False`
 -  无证据

*
 -  {anchorName connectiveTable}`A` 与 {anchorName connectiveTable}`B`
 -  {anchorTerm connectiveTable}`A ∧ B`
 -  {anchorTerm connectiveTable}`And.intro : A → B → A ∧ B`

*
 -  {anchorName connectiveTable}`A` 或 {anchorName connectiveTable}`B`
 -  {anchorTerm connectiveTable}`A ∨ B`
 -  Either {anchorTerm connectiveTable}`Or.inl : A → A ∨ B` or {anchorTerm connectiveTable}`Or.inr : B → A ∨ B`

*
 -  {anchorName connectiveTable}`A` 蕴含 {anchorName connectiveTable}`B`
 -  {anchorTerm connectiveTable}`A → B`
 -  将 {anchorName connectiveTable}`A` 的证据转换到 {anchorName connectiveTable}`B` 的证据的函数

*
 -  非 {anchorName connectiveTable}`A`
 -  {anchorTerm connectiveTable}`¬A`
 -  将 {anchorName connectiveTable}`A` 的证据转换到 {anchorName connectiveTable}`False` 的证据的函数
:::


/- The {tactic}`decide` tactic can prove theorems that use these connectives.
For example:
-/
{tactic}`decide` 策略可以证明使用了这些连接词的定理。例如：

```anchor connectivesD
theorem onePlusOneOrLessThan : 1 + 1 = 2 ∨ 3 < 5 := by decide
theorem notTwoEqualFive : ¬(1 + 1 = 5) := by decide
theorem trueIsTrue : True := by decide
theorem trueOrFalse : True ∨ False := by decide
theorem falseImpliesTrue : False → True := by decide
```


-- # Evidence as Arguments
# 证据作为参数
%%%
tag := "evidence-passing"
%%%

/- In some cases, safely indexing into a list requires that the list have some minimum size, but the list itself is a variable rather than a concrete value.
For this lookup to be safe, there must be some evidence that the list is long enough.
One of the easiest ways to make indexing safe is to have the function that performs a lookup into a data structure take the required evidence of safety as an argument.
For instance, a function that returns the third entry in a list is not generally safe because lists might contain zero, one, or two entries:
-/
要让索引记法正常工作的最简单的方式之一，就是让执行数据结构查找的函数将所需的安全性证据作为参数。
例如，返回列表中第三个条目的函数通常不安全，因为列表可能包含零、一或两个条目：

```anchor thirdErr
def third (xs : List α) : α := xs[2]
```

```anchorError thirdErr
failed to prove index is valid, possible solutions:
  - Use `have`-expressions to prove the index is valid
  - Use `a[i]!` notation instead, runtime check is performed, and 'Panic' error message is produced if index is not valid
  - Use `a[i]?` notation instead, result is an `Option` type
  - Use `a[i]'h` notation instead, where `h` is a proof that index is valid
α : Type ?u.5379
xs : List α
⊢ 2 < xs.length
```

/- However, the obligation to show that the list has at least three entries can be imposed on the caller by adding an argument that consists of evidence that the indexing operation is safe:
-/
然而，通过添加一个参数来强制调用者证明列表至少有三个条目，该参数包含索引操作安全的证据：

```anchor third
def third (xs : List α) (ok : xs.length > 2) : α := xs[2]
```

/- In this example, {anchorTerm third}`xs.length > 2` is not a program that checks _whether_ {anchorTerm third}`xs` has more than 2 entries.
It is a proposition that could be true or false, and the argument {anchorTerm third}`ok` must be evidence that it is true.
-/
在本例中，{anchorTerm third}`xs.length > 2` 并不是一个检查 *是否* {anchorTerm third}`xs` 有 2 个以上条目的程序。
它是一个可能是真或假的命题，参数 {anchorTerm third}`ok` 必须是它为真的证据。

/- When the function is called on a concrete list, its length is known.
In these cases, {anchorTerm thirdCritters}`by decide` can construct the evidence automatically:
-/
当函数在一个具体的列表上调用时，它的长度是已知的。在这些情况下，{anchorTerm thirdCritters}`by decide` 可以自动构造证据：

```anchor thirdCritters
#eval third woodlandCritters (by decide)
```

```anchorInfo thirdCritters
"snail"
```


-- # Indexing Without Evidence
# 无证据的索引
%%%
tag := "indexing-without-evidence"
%%%

/- In cases where it's not practical to prove that an indexing operation is in bounds, there are other alternatives.
Adding a question mark results in an {anchorName thirdOption}`Option`, where the result is {anchorName OptionNames}`some` if the index is in bounds, and {anchorName OptionNames}`none` otherwise.
For example:
-/
在无法证明索引操作在边界内的情况下，还有其他选择。添加一个问号会产生一个 {anchorName thirdOption}`Option`，
如果索引在边界内，结果为 {anchorName OptionNames}`some`，否则为 {anchorName OptionNames}`none`。例如：


```anchor thirdOption
def thirdOption (xs : List α) : Option α := xs[2]?
```

```anchor thirdOptionCritters
#eval thirdOption woodlandCritters
```

```anchorInfo thirdOptionCritters
some "snail"
```

```anchor thirdOptionTwo
#eval thirdOption ["only", "two"]
```

```anchorInfo thirdOptionTwo
none
```

/- There is also a version that crashes the program when the index is out of bounds, rather than returning an {moduleTerm}`Option`:
-/
还有一个版本，当索引超出边界时会使程序崩溃，而非返回一个 {moduleTerm}`Option`：

```anchor crittersBang
#eval woodlandCritters[1]!
```

```anchorInfo crittersBang
"deer"
```

-- # Messages You May Meet
# 可能遇到的消息
%%%
tag := "props-proofs-indexing-messages"
%%%

/- In addition to proving that a statement is true, the {anchorTerm thirdRabbitErr}`decide` tactic can also prove that it is false.
When asked to prove that a one-element list has more than two elements, it returns an error that indicates that the statement is indeed false:
-/
除了证明一个语句是真实的之外，{anchorTerm thirdRabbitErr}`decide` 策略还可以证明它是假的。
当被要求证明一个单元素列表有超过两个元素时，它会返回一个错误，表明该语句确实是假的：

```anchor thirdRabbitErr
#eval third ["rabbit"] (by decide)
```


```anchorError thirdRabbitErr
Tactic `decide` proved that the proposition
  ["rabbit"].length > 2
is false
```


/- The {tactic}`simp` and {tactic}`decide` tactics do not automatically unfold definitions with {kw}`def`.
Attempting to prove {anchorTerm onePlusOneIsStillTwo}`OnePlusOneIsTwo` using {anchorTerm onePlusOneIsStillTwo}`simp` fails:
-/
{tactic}`simp` 和 {tactic}`decide` 策略不会自动展开 {kw}`def` 定义。
尝试使用 {anchorTerm onePlusOneIsStillTwo}`OnePlusOneIsTwo` 证明 {anchorTerm onePlusOneIsStillTwo}`simp` 失败：

```anchor onePlusOneIsStillTwo
theorem onePlusOneIsStillTwo : OnePlusOneIsTwo := by simp
```

/- The error messages simply states that it could do nothing, because without unfolding {anchorTerm onePlusOneIsStillTwo}`OnePlusOneIsTwo`, no progress can be made:
-/
错误消息只是简单地说明它什么也做不了，因为如果不展开 {anchorTerm onePlusOneIsStillTwo}`OnePlusOneIsTwo`，就无法取得进展：

```anchorError onePlusOneIsStillTwo
`simp` made no progress
```

/- Using {anchorTerm onePlusOneIsStillTwo2}`decide` also fails:
-/
使用 {anchorTerm onePlusOneIsStillTwo2}`decide` 也失败了：

```anchor onePlusOneIsStillTwo2
theorem onePlusOneIsStillTwo : OnePlusOneIsTwo := by decide
```

/- This is also due to it not unfolding {anchorName onePlusOneIsStillTwo2}`OnePlusOneIsTwo`:
-/
这也是因为它没有展开 {anchorName onePlusOneIsStillTwo2}`OnePlusOneIsTwo`：

```anchorError onePlusOneIsStillTwo2
failed to synthesize
  Decidable OnePlusOneIsTwo

Hint: Additional diagnostic information may be available using the `set_option diagnostics true` command.
```

/- Defining {anchorName onePlusOneIsStillTwo}`OnePlusOneIsTwo` with {ref "abbrev-vs-def"}[{kw}`abbrev` fixes the problem] by marking the definition for unfolding.
-/
使用 {ref "getting-to-know/types.md#abbrev-vs-def"}[{kw}`abbrev` 定义 {anchorName onePlusOneIsStillTwo}`OnePlusOneIsTwo`] 通过标记定义以进行展开来解决问题。

/- In addition to the error that occurs when Lean is unable to find compile-time evidence that an indexing operation is safe, polymorphic functions that use unsafe indexing may produce the following message:
-/
除了 Lean 在找不到编译时证据而无法证明索引操作安全时产生的错误之外，
使用不安全索引的多态函数可能会产生以下消息：

```anchor unsafeThird
def unsafeThird (xs : List α) : α := xs[2]!
```


```anchorError unsafeThird
failed to synthesize
  Inhabited α

Hint: Additional diagnostic information may be available using the `set_option diagnostics true` command.
```

/- This is due to a technical restriction that is part of keeping Lean usable as both a logic for proving theorems and a programming language.
In particular, only programs whose types contain at least one value are allowed to crash.
This is because a proposition in Lean is a kind of type that classifies evidence of its truth.
False propositions have no such evidence.
If a program with an empty type could crash, then that crashing program could be used as a kind of fake evidence for a false proposition.
-/
这是由于技术限制，该限制是将 Lean 同时用作证明定理的逻辑和编程语言的一部分。
特别是，只有类型中至少包含一个值的程序才允许崩溃。
这是因为 Lean 中的命题是一种对真值证据进行分类的类型。假命题没有这样的证据。
如果具有空类型的程序可能崩溃，那么该崩溃程序可以用作对假命题的一种假的证据。

/- Internally, Lean contains a table of types that are known to have at least one value.
This error is saying that some arbitrary type {anchorTerm unsafeThird}`α` is not necessarily in that table.
The next chapter describes how to add to this table, and how to successfully write functions like {anchorTerm unsafeThird}`unsafeThird`.
-/
在内部，Lean 包含一个已知至少有一个值的类型的表。此错误表明某个任意类型 {anchorTerm unsafeThird}`α` 不一定在该表中。
下一章描述如何向此表添加内容，以及如何成功编写诸如 {anchorTerm unsafeThird}`unsafeThird` 之类的函数。

/- Adding whitespace between a list and the brackets used for lookup can cause another message:
-/
在列表和用于查找的括号之间添加空格会产生另一条消息：

```anchor extraSpace
#eval woodlandCritters [1]
```


```anchorError extraSpace
Function expected at
  woodlandCritters
but this term has type
  List String

Note: Expected a function because this term is being applied to the argument
  [1]
```

/- Adding a space causes Lean to treat the expression as a function application, and the index as a list that contains a single number.
This error message results from having Lean attempt to treat {anchorTerm woodlandCritters}`woodlandCritters` as a function.
-/
添加空格会导致 Lean 将表达式视为函数应用，并将索引视为包含单个数字的列表。
此错误消息是由 Lean 尝试将 {anchorTerm woodlandCritters}`woodlandCritters` 视为函数而产生的。

-- ## Exercises
## 练习
%%%
tag := "props-proofs-indexing-exercises"
%%%

/- * Prove the following theorems using {anchorTerm exercises}`rfl`: {anchorTerm exercises}`2 + 3 = 5`, {anchorTerm exercises}`15 - 8 = 7`, {anchorTerm exercises}`"Hello, ".append "world" = "Hello, world"`. What happens if {anchorTerm exercises}`rfl` is used to prove {anchorTerm exercises}`5 < 18`? Why?
   * Prove the following theorems using {anchorTerm exercises}`by decide`: {anchorTerm exercises}`2 + 3 = 5`, {anchorTerm exercises}`15 - 8 = 7`, {anchorTerm exercises}`"Hello, ".append "world" = "Hello, world"`, {anchorTerm exercises}`5 < 18`.
   * Write a function that looks up the fifth entry in a list. Pass the evidence that this lookup is safe as an argument to the function.
-/
* 使用 {anchorTerm exercises}`rfl` 证明以下定理：{anchorTerm exercises}`2 + 3 = 5`、{anchorTerm exercises}`15 - 8 = 7`、
  {anchorTerm exercises}`"Hello, ".append "world" = "Hello, world"`。
  如果使用 {anchorTerm exercises}`rfl` 证明 {anchorTerm exercises}`5 < 18` 会发生什么？为什么？
* 使用 {anchorTerm exercises}`by decide` 证明以下定理：{anchorTerm exercises}`2 + 3 = 5`、{anchorTerm exercises}`15 - 8 = 7`、
  {anchorTerm exercises}`"Hello, ".append "world" = "Hello, world"`、{anchorTerm exercises}`5 < 18`。
* 编写一个查找列表中第五个条目的函数。将此查找安全的证据作为参数传递给该函数。
