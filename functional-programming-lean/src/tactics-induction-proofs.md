# 小插曲：策略，归纳与证明 { #interlude-tactics-induction-and-proofs }

## 一个关于证明与用户界面的说明 { #a-note-on-proofs-and-user-interfaces }
<!--
This book presents the process of writing proofs as if they are written in one go and submitted to Lean, which then replies with error messages that describe what remains to be done. The actual process of interacting with Lean is much more pleasant. Lean provides information about the proof as the cursor is moved through it and there are a number of interactive features that make proving easier. Please consult the documentation of your Lean development environment for more information.
-->
本书展现了编写证明的过程，仿佛它们是一次就写就并交付给 Lean 运行似的，接着 Lean 会报错，描述剩余任务的错误信息。实际上，与 Lean 互动的过程要愉快得多。Lean 在光标移动时提供有关证明的信息，并且有许多互动功能使证明更容易。请查阅您的 Lean 开发环境的文档以获取更多信息。

<!--
The approach in this book that focuses on incrementally building a proof and showing the messages that result demonstrates the kinds of interactive feedback that Lean provides while writing a proof, even though it is much slower than the process used by experts. At the same time, seeing incomplete proofs evolve towards completeness is a useful perspective on proving. As your skill in writing proofs increases, Lean's feedback will come to feel less like errors and more like support for your own thought processes. Learning the interactive approach is very important.
-->
本书中的方法侧重于逐步构建证明并显示产生的消息，这展示了 Lean 在编写证明时提供的各种互动反馈，尽管这比专家使用的过程慢得多。同时，看到不完整的证明逐步趋向完整是一种对证明有益的视角。随着您编写证明技能的提高，Lean 的反馈将不再感觉像错误，而更像是对您自己思维过程的支持。学习互动方法非常重要。

## 递归和归纳 { #recursion-and-induction }
<!--
The functions plusR_succ_left and plusR_zero_left from the preceding chapter can be seen from two perspectives. On the one hand, they are recursive functions that build up evidence for a proposition, just as other recursive functions might construct a list, a string, or any other data structure. On the other, they also correspond to proofs by mathematical induction.
-->
上一章中的函数 **plusR_succ_left** 和 **plusR_zero_left** 可以从两个角度看待。从一方面看，它们是递归函数，构建了命题的证明，就像其他递归函数可能构建列表、字符串或任何其他数据结构一样。从另一方面上看，它们也对应于 **数学归纳法 (Mathematical Induction)** 的证明。

<!--
Mathematical induction is a proof technique where a statement is proven for all natural numbers in two steps:

    1.The statement is shown to hold for 0. This is called the base case.
    2.Under the assumption that the statement holds for some arbitrarily chosen number n, it is shown to hold for n+1. This is called the induction step. The assumption that the statement holds for n is called the induction hypothesis.
-->
数学归纳是一种证明技术，通过两个步骤证明一个命题对所有自然数成立：

1. 证明该命题对 0 成立。这称为 **基本情况(Base Case)**。
2. 在假设命题对某个任意选择的数 n 成立的前提下，证明它对 n+1 成立。这称为 **归纳步骤(Induction Step)**。假设命题对 n 成立的假设称为 **归纳假设(Induction Hypothesis)**。

<!--
Because it's impossible to check the statement for every natural number, induction provides a means of writing a proof that could, in principle, be expanded to any particular natural number. For example, if a concrete proof were desired for the number 3, then it could be constructed by using first the base case and then the induction step three times, to show the statement for 0, 1, 2, and finally 3. Thus, it proves the statement for all natural numbers.
-->
因为我们不可能对**每个**自然数进行检查，归纳提供了一种手段来编写原则上可以扩展到任何特定自然数的证明。例如，如果需要对数字 3 进行具体证明，那么可以首先使用基本情况，然后归纳步骤三次，分别证明命题对 0、1、2，最后对 3 成立。因此，它证明了该命题对所有自然数成立。

## 归纳策略 { #the-induction-tactic }
<!--
Writing proofs by induction as recursive functions that use helpers such as congrArg does not always do a good job of expressing the intentions behind the proof. While recursive functions indeed have the structure of induction, they should probably be viewed as an encoding of a proof. Furthermore, Lean's tactic system provides a number of opportunities to automate the construction of a proof that are not available when writing the recursive function explicitly. Lean provides an induction tactic that can carry out an entire proof by induction in a single tactic block. Behind the scenes, Lean constructs the recursive function that corresponds the use of induction.
-->
通过递归函数编写归纳证明，使用诸如 **congrArg** 之类的辅助函数并不总是能很好地表达证明背后的意图。虽然递归函数确实具有归纳的结构，但它们应该被视为一种证明的编码。此外，Lean 的策略系统提供了许多自动构建证明的机会，这是显式编写递归函数时无法实现的。Lean 提供了一种归纳策略，可以在单个策略块中完成整个归纳证明。在幕后，Lean 构建了对应于归纳使用的递归函数。
<!--
To prove plusR_zero_left with the induction tactic, begin by writing its signature (using theorem, because this really is a proof). Then, use by induction k as the body of the definition:
-->
要使用归纳策略证明 **plusR_zero_left**，首先编写其签名（使用 **定理(Theorem)**，因为这确实是一个证明）。然后，使用 **by induction k** 作为定义的主体：

```lean
theorem plusR_zero_left (k : Nat) : k = Nat.plusR 0 k := by
  induction k
```
<!--
The resulting message states that there are two goals:
-->
产生的消息表明有两个目标：

```lean
unsolved goals
case zero
⊢ Nat.zero = Nat.plusR 0 Nat.zero

case succ
n✝ : Nat
n_ih✝ : n✝ = Nat.plusR 0 n✝
⊢ Nat.succ n✝ = Nat.plusR 0 (Nat.succ n✝)
```
<!--
A tactic block is a program that is run while the Lean type checker processes a file, somewhat like a much more powerful C preprocessor macro. The tactics generate the actual program.
-->
策略块是在 Lean 类型检查器处理文件时运行的程序，有点像功能更强大的 C 预处理器宏。策略生成实际的程序。

<!--
In the tactic language, there can be a number of goals. Each goal consists of a type together with some assumptions. These are analogous to using underscores as placeholders—the type in the goal represents what is to be proved, and the assumptions represent what is in-scope and can be used. In the case of the goal case zero, there are no assumptions and the type is Nat.zero = Nat.plusR 0 Nat.zero—this is the theorem statement with 0 instead of k. In the goal case succ, there are two assumptions, named n✝ and n_ih✝. Behind the scenes, the induction tactic creates a dependent pattern match that refines the overall type, and n✝ represents the argument to Nat.succ in the pattern. The assumption n_ih✝ represents the result of calling the generated function recursively on n✝. Its type is the overall type of the theorem, just with n✝ instead of k. The type to be fulfilled as part of the goal case succ is the overall theorem statement, with Nat.succ n✝ instead of k.
-->
在策略语言中，可能有多个目标。每个目标由类型和一些假设组成。这些类似于使用下划线作为占位符——目标中的类型表示要证明的内容，假设表示在作用域内且可以使用的内容。在 **case zero** 的目标中，没有假设，类型是 **Nat.zero = Nat.plusR 0 Nat.zero** ——这是定理陈述，其中 **0** 代替 **k**。在 **case succ** 的目标中，有两个假设，分别命名为 **n✝** 和 **n_ih✝**。在幕后，归纳策略创建了一个依赖模式匹配来优化整体类型，**n✝** 表示模式中 **Nat.succ** 的参数。假设 **n_ih✝** 表示递归调用生成的函数在 **n✝** 上的结果。其类型是定理的整体类型，只是用 **n✝** 代替 **k**。**case succ** 目标的类型是定理陈述的整体，用 **Nat.succ n✝** 代替 **k**。
<!--
The two goals that result from the use of the induction tactic correspond to the base case and the induction step in the description of mathematical induction. The base case is case zero. In case succ, n_ih✝ corresponds to the induction hypothesis, while the whole of case succ is the induction step.
-->
使用归纳策略得到的两个目标对应于数学归纳描述中的基本情况和归纳步骤。基本情况是 **case zero**。在 **case succ** 中，**n_ih✝** 对应于归纳假设，而整个 **case succ** 是归纳步骤。
<!--
The next step in writing the proof is to focus on each of the two goals in turn. Just as pure () can be used in a do block to indicate "do nothing", the tactic language has a statement skip that also does nothing. This can be used when Lean's syntax requires a tactic, but it's not yet clear which one should be used. Adding with to the end of the induction statement provides a syntax that is similar to pattern matching:
-->
编写证明的下一步是依次关注两个目标中的每一个。就像在 **do** 块中使用 **pure ( )** 来表示“什么也不做”一样，策略语言有一个语句 **skip** 也什么也不做。当 Lean 的语法需要一个策略时，但尚不清楚应该使用哪个策略时，可以使用 **skip**。将 **with** 添加到**归纳语句(Induction Statement)**的末尾提供了一种类似于模式匹配的语法：

```lean
theorem plusR_zero_left (k : Nat) : k = Nat.plusR 0 k := by
  induction k with
  | zero => skip
  | succ n ih => skip
```
<!--
Each of the two skip statements has a message associated with it. The first shows the base case:
-->
每个 **skip** 语句都有一个与之关联的消息。第一个显示了基本情况：

```lean
unsolved goals
case zero
⊢ Nat.zero = Nat.plusR 0 Nat.zero
```
<!--
The second shows the induction step:
-->
第二个显示了归纳步骤：

```lean
unsolved goals
case succ
n : Nat
ih : n = Nat.plusR 0 n
⊢ Nat.succ n = Nat.plusR 0 (Nat.succ n)
```
<!--
In the induction step, the inaccessible names with daggers have been replaced with the names provided after succ, namely n and ih.
-->
在归纳步骤中，不可访问的带匕首的名称已被提供的名称替换，分别为 **succ** 后的 **n** 和 **ih**。
<!--
The cases after induction ... with are not patterns: they consist of the name of a goal followed by zero or more names. The names are used for assumptions introduced in the goal; it is an error to provide more names than the goal introduces:
-->
**induction ... with** 后的 **cases** 不是模式：它们由目标的名称和零个或多个名称组成。名称用于在目标中引入的假设；如果提供的名称超过目标引入的名称数，则会出现错误：

```lean
theorem plusR_zero_left (k : Nat) : k = Nat.plusR 0 k := by
  induction k with
  | zero => skip
  | succ n ih lots of names => skip

too many variable names provided at alternative 'succ', #5 provided, but #2 expected
```
<!--
Focusing on the base case, the rfl tactic works just as well inside of the induction tactic as it does in a recursive function:
-->
关注基本情况，**rfl** 策略在 **归纳策略(Induction Tactics)** 中与在递归函数中一样有效：

```lean
theorem plusR_zero_left (k : Nat) : k = Nat.plusR 0 k := by
  induction k with
  | zero => rfl
  | succ n ih => skip
```
<!--
In the recursive function version of the proof, a type annotation made the expected type something that was easier to understand. In the tactic language, there are a number of specific ways to transform a goal to make it easier to solve. The unfold tactic replaces a defined name with its definition:
-->
在递归函数版本的证明中，类型注释使得预期类型更容易理解。在策略语言中，有许多具体的方法可以转换目标，使其更容易解决。**unfold** 策略用其定义替换定义的名称：

```lean
theorem plusR_zero_left (k : Nat) : k = Nat.plusR 0 k := by
  induction k with
  | zero => rfl
  | succ n ih =>
    unfold Nat.plusR
```
<!--
Now, the right-hand side of the equality in the goal has become Nat.plusR 0 n + 1 instead of Nat.plusR 0 (Nat.succ n):
-->
现在，目标中等式的右侧已变为 **Nat.plusR 0 n + 1** 而不是 **Nat.plusR 0 (Nat.succ n)**：

```lean
unsolved goals
case succ
n : Nat
ih : n = Nat.plusR 0 n
⊢ Nat.succ n = Nat.plusR 0 n + 1
```
<!--
Instead of appealing to functions like congrArg and operators like ▸, there are tactics that allow equality proofs to be used to transform proof goals. One of the most important is rw, which takes a list of equality proofs and replaces the left side with the right side in the goal. This almost does the right thing in plusR_zero_left:
-->
代替使用诸如 **congrArg** 之类的函数和运算符，存在允许使用等式证明转换证明目标的策略。最重要的策略之一是 **rw**，它接受等式证明列表，并在目标中用右侧替换左侧。这几乎在 **plusR_zero_left** 中完成了正确的操作：

```lean
theorem plusR_zero_left (k : Nat) : k = Nat.plusR 0 k := by
  induction k with
  | zero => rfl
  | succ n ih =>
    unfold Nat.plusR
    rw [ih]
```
<!--
However, the direction of the rewrite was incorrect. Replacing n with Nat.plusR 0 n made the goal more complicated rather than less complicated:
-->
然而，重写的方向不正确。将 **n** 替换为 **Nat.plusR 0 n** 使得目标更复杂而不是更简单：

```lean
unsolved goals
case succ
n : Nat
ih : n = Nat.plusR 0 n
⊢ Nat.succ (Nat.plusR 0 n) = Nat.plusR 0 (Nat.plusR 0 n) + 1
```
<!--
This can be remedied by placing a left arrow before ih in the call to rewrite, which instructs it to replace the right-hand side of the equality with the left-hand side:
-->
通过在 **重写(Rewrite)** 调用中的 **ih** 前加一个左箭头，可以解决这个问题，指示它用左侧替换等式的右侧：

```lean
theorem plusR_zero_left (k : Nat) : k = Nat.plusR 0 k := by
  induction k with
  | zero => rfl
  | succ n ih =>
    unfold Nat.plusR
    rw [←ih]
```
<!--
This rewrite makes both sides of the equation identical, and Lean takes care of the rfl on its own. The proof is complete.
-->
这个重写使得等式的两边相同，Lean 会自己处理 **rfl**。证毕。

## 策略高尔夫 { #tactic-golf }
<!--
So far, the tactic language has not shown its true value. The above proof is no shorter than the recursive function; it's merely written in a domain-specific language instead of the full Lean language. But proofs with tactics can be shorter, easier, and more maintainable. Just as a lower score is better in the game of golf, a shorter proof is better in the game of tactic golf.

The induction step of plusR_zero_left can be proved using the simplification tactic simp. Using simp on its own does not help:
-->
到目前为止，策略语言尚未显示出其真正的价值。上面的证明并不比递归函数短，只是用特定领域的语言而不是完整的 Lean 语言编写。但是，用策略编写的证明可以更短、更容易、更易维护。就像高尔夫比赛中分数越低越好一样，策略高尔夫比赛中的证明越短越好。

**plusR_zero_left** 的归纳步骤可以使用简化策略 **simp** 证明。单独使用 **simp** 并没有帮助：

```lean
theorem plusR_zero_left (k : Nat) : k = Nat.plusR 0 k := by
  induction k with
  | zero => rfl
  | succ n ih =>
    simp

simp made no progress
```
<!--
However, simp can be configured to make use of a set of definitions. Just like rw, these arguments are provided in a list. Asking simp to take the definition of Nat.plusR into account leads to a simpler goal:
-->
然而，**simp** 可以配置为使用一组定义。就像 **rw** 一样，这些参数在列表中提供。要求 **simp** 考虑 **Nat.plusR** 的定义导致一个更简单的目标：

```lean
theorem plusR_zero_left (k : Nat) : k = Nat.plusR 0 k := by
  induction k with
  | zero => rfl
  | succ n ih =>
    simp [Nat.plusR]

unsolved goals
case succ
n : Nat
ih : n = Nat.plusR 0 n
⊢ n = Nat.plusR 0 n
```
<!--
In particular, the goal is now identical to the induction hypothesis. In addition to automatically proving simple equality statements, the simplifier automatically replaces goals like Nat.succ A = Nat.succ B with A = B. Because the induction hypothesis ih has exactly the right type, the exact tactic can indicate that it should be used:
-->
特别是，目标现在与归纳假设相同。除了自动证明简单的等式外，简化器还会自动将目标如 **Nat.succ A = Nat.succ B** 替换为 **A = B**。由于归纳假设 **ih** 具有完全正确的类型，**exact** 策略可以指示它应该被使用：

```lean
theorem plusR_zero_left (k : Nat) : k = Nat.plusR 0 k := by
  induction k with
  | zero => rfl
  | succ n ih =>
    simp [Nat.plusR]
    exact ih
```
<!--
However, the use of exact is somewhat fragile. Renaming the induction hypothesis, which may happen while "golfing" the proof, would cause this proof to stop working. The assumption tactic solves the current goal if any of the assumptions match it:
-->
然而，使用 **exact** 有点脆弱。重命名归纳假设（在“打高尔夫”证明时可能会发生）会导致此证明停止工作。假设策略解决了当前目标，如果任何假设与之匹配：

```lean
theorem plusR_zero_left (k : Nat) : k = Nat.plusR 0 k := by
  induction k with
  | zero => rfl
  | succ n ih =>
    simp [Nat.plusR]
    assumption
```
<!--
This proof is no shorter than the prior proof that used unfolding and explicit rewriting. However, a series of transformations can make it much shorter, taking advantage of the fact that simp can solve many kinds of goals. The first step is to drop the with at the end of induction. For structured, readable proofs, the with syntax is convenient. It complains if any cases are missing, and it shows the structure of the induction clearly. But shortening proofs can often require a more liberal approach.
-->
这个证明并不比使用展开和显式重写的先前证明短。然而，一系列变换可以使它更短，利用 **simp** 可以解决许多类型的目标这一事实。第一步是去掉归纳末尾的 **with**。对于结构化、可读的证明，**with** 语法是方便的。如果缺少任何情况，它会抱怨，并且它清楚地显示归纳的结构。但是缩短证明通常需要更宽松的方法。
<!--
Using induction without with simply results in a proof state with two goals. The case tactic can be used to select one of them, just as in the branches of the induction ... with tactic. In other words, the following proof is equivalent to the prior proof:
-->
使用不带 **with** 的归纳仅会产生两个目标。**case** 策略可以像在**induction...with** 策略的分支中一样选择其中一个目标。换句话说，以下证明等同于前一个证明：

```lean
theorem plusR_zero_left (k : Nat) : k = Nat.plusR 0 k := by
  induction k
  case zero => rfl
  case succ n ih =>
    simp [Nat.plusR]
    assumption
```
<!--
In a context with a single goal (namely, k = Nat.plusR 0 k), the induction k tactic yields two goals. In general, a tactic will either fail with an error or take a goal and transform it into zero or more new goals. Each new goal represents what remains to be proved. If the result is zero goals, then the tactic was a success, and that part of the proof is done.
-->
在具有单个目标的上下文中（即 **k = Nat.plusR 0 k**），归纳 **k** 策略产生两个目标。通常，策略要么失败并产生错误，要么接受一个目标并将其转换为零个或多个新目标。每个新目标表示剩下要证明的内容。如果结果是零个目标，则策略成功，该部分证明完成。
<!--
The <;> operator takes two tactics as arguments, resulting in a new tactic. T1 <;> T2 applies T1 to the current goal, and then applies T2 in all goals created by T1. In other words, <;> enables a general tactic that can solve many kinds of goals to be used on multiple new goals all at once. One such general tactic is simp.
-->
**<;>** 运算符接受两个策略作为参数，生成一个新策略。**T1 <;> T2** 将 **T1** 应用于当前目标，然后在 **T1** 创建的所有目标中应用 **T2**。换句话说，**<;>** 允许通用策略一次性用于多个新目标。一个这样的通用策略是 **simp**。
<!--
Because simp can both complete the proof of the base case and make progress on the proof of the induction step, using it with induction and <;> shortens the proof:
-->
因为 **simp** 既可以完成基本情况的证明，又可以在归纳步骤的证明中取得进展，所以使用它与归纳和 **<;>** 缩短了证明：

```lean
theorem plusR_zero_left (k : Nat) : k = Nat.plusR 0 k := by
  induction k <;> simp [Nat.plusR]
```
<!--
This results in only a single goal, the transformed induction step:
-->
这仅产生一个目标，即转换后的归纳步骤：

```lean
unsolved goals
case succ
n✝ : Nat
n_ih✝ : n✝ = Nat.plusR 0 n✝
⊢ n✝ = Nat.plusR 0 n✝
```
<!--
Running assumption in this goal completes the proof:
-->
在这个目标中运行 **assumption** 完成了证明：

```lean
theorem plusR_zero_left (k : Nat) : k = Nat.plusR 0 k := by
  induction k <;> simp [Nat.plusR] <;> assumption
```
<!--
Here, exact would not have been possible, because ih was never explicitly named.
-->
在这里，**exact** 是不可能的，因为 **ih** 从未被显式命名。
<!--
For beginners, this proof is not easier to read. However, a common pattern for expert users is to take care of a number of simple cases with powerful tactics like simp, allowing them to focus the text of the proof on the interesting cases. Additionally, these proofs tend to be more robust in the face of small changes to the functions and datatypes involved in the proof. The game of tactic golf is a useful part of developing good taste and style when writing proofs.
-->
对于初学者来说，这个证明并不容易阅读。然而，专家用户的常见模式是使用像 **simp** 这样的强大策略处理一些简单情况，使他们可以将证明的文本集中在有趣的情况下。此外，这些证明在面对函数和数据类型的小变化时往往更稳健。策略高尔夫游戏是培养编写证明时的良好品味和风格的有用部分。

## 其他数据类型的归纳 { #induction-on-other-datatypes }
<!--
Mathematical induction proves a statement for natural numbers by providing a base case for Nat.zero and an induction step for Nat.succ. The principle of induction is also valid for other datatypes. Constructors without recursive arguments form the base cases, while constructors with recursive arguments form the induction steps. The ability to carry out proofs by induction is the very reason why they are called inductive datatypes.
-->
数学归纳通过为 **Nat.zero** 提供基本情况和为 **Nat.succ** 提供归纳步骤来证明自然数的命题。归纳原则对于其他数据类型也是有效的。没有递归参数的构造函数形成基本情况，而具有递归参数的构造函数形成归纳步骤。进行归纳证明的能力是它们被称为归纳数据类型的原因。
<!--
One example of this is induction on binary trees. Induction on binary trees is a proof technique where a statement is proven for all binary trees in two steps:

   1.The statement is shown to hold for BinTree.leaf. This is called the base case.
   2.Under the assumption that the statement holds for some arbitrarily chosen trees l and r, it is shown to hold for BinTree.branch l x r, where x is an arbitrarily-chosen new data point. This is called the induction step. The assumptions that the statement holds for l and r are called the induction hypotheses.
-->
这方面的一个例子是对二叉树的归纳。对二叉树进行归纳是一种证明技术，通过两个步骤证明一个命题对所有二叉树成立：

1. 证明该命题对 **BinTree.leaf** 成立。这称为基本情况。
2. 在假设该命题对某些任意选择的树 **l** 和 **r** 成立的前提下，证明它对 **BinTree.branch l x r** 成立，其中 **x** 是任意选择的新数据点。这称为归纳步骤。假设该命题对 **l** 和 **r** 成立的假设称为归纳假设。
<!--
BinTree.count counts the number of branches in a tree:
-->
**BinTree.count** 计算树中分支的数量：

```lean
def BinTree.count : BinTree α → Nat
  | .leaf => 0
  | .branch l _ r =>
    1 + l.count + r.count
```
<!--
Mirroring a tree does not change the number of branches in it. This can be proven using induction on trees. The first step is to state the theorem and invoke induction:
-->
镜像树不会改变树中的分支数量。可以通过对树进行归纳证明这一点。第一步是声明定理并调用归纳：

```lean
theorem BinTree.mirror_count (t : BinTree α) : t.mirror.count = t.count := by
  induction t with
  | leaf => skip
  | branch l x r ihl ihr => skip
```
<!--
The base case states that counting the mirror of a leaf is the same as counting the leaf:
-->
基本情况表明，计算镜像叶子的数量与计算叶子相同：

```lean
unsolved goals
case leaf
α : Type
⊢ count (mirror leaf) = count leaf
```
<!--
The induction step allows the assumption that mirroring the left and right subtrees won't affect their branch counts, and requests a proof that mirroring a branch with these subtrees also preserves the overall branch count:
-->
归纳步骤允许假设镜像左右子树不会影响其分支计数，并要求证明镜像具有这些子树的分支也保留整体分支计数：

```lean
unsolved goals
case branch
α : Type
l : BinTree α
x : α
r : BinTree α
ihl : count (mirror l) = count l
ihr : count (mirror r) = count r
⊢ count (mirror (branch l x r)) = count (branch l x r)
```
<!--
The base case is true because mirroring leaf results in leaf, so the left and right sides are definitionally equal. This can be expressed by using simp with instructions to unfold BinTree.mirror:
-->
基本情况成立，因为镜像 **leaf** 结果为 **leaf**，因此左右两边定义上相等。这可以通过使用带有展开 **BinTree.mirror** 指令的 **simp** 表达：

```lean
theorem BinTree.mirror_count (t : BinTree α) : t.mirror.count = t.count := by
  induction t with
  | leaf => simp [BinTree.mirror]
  | branch l x r ihl ihr => skip
```
<!--
In the induction step, nothing in the goal immediately matches the induction hypotheses. Simplifying using the definitions of BinTree.count and BinTree.mirror reveals the relationship:
-->
在归纳步骤中，目标中没有任何东西与归纳假设立即匹配。使用 **BinTree.count** 和 **BinTree.mirror** 的定义简化显示了关系：

```lean
theorem BinTree.mirror_count (t : BinTree α) : t.mirror.count = t.count := by
  induction t with
  | leaf => simp [BinTree.mirror]
  | branch l x r ihl ihr =>
    simp [BinTree.mirror, BinTree.count]

unsolved goals
case branch
α : Type
l : BinTree α
x : α
r : BinTree α
ihl : count (mirror l) = count l
ihr : count (mirror r) = count r
⊢ 1 + count (mirror r) + count (mirror l) = 1 + count l + count r
```
<!--
Both induction hypotheses can be used to rewrite the left-hand side of the goal into something almost like the right-hand side:
-->
可以使用两个归纳假设重写目标的左侧，使其与右侧几乎相同：

```lean
theorem BinTree.mirror_count (t : BinTree α) : t.mirror.count = t.count := by
  induction t with
  | leaf => simp [BinTree.mirror]


  | branch l x r ihl ihr =>
    simp [BinTree.mirror, BinTree.count]
    rw [ihl, ihr]

unsolved goals
case branch
α : Type
l : BinTree α
x : α
r : BinTree α
ihl : count (mirror l) = count l
ihr : count (mirror r) = count r
⊢ 1 + count r + count l = 1 + count l + count r
```
<!--
The simp_arith tactic, a version of simp that can use additional arithmetic identities, is enough to prove this goal, yielding:
-->
使用 **simp_arith** 策略（一个可以使用额外算术等式的 **simp** 版本）足以证明此目标，从而得到：

```lean
theorem BinTree.mirror_count (t : BinTree α) : t.mirror.count = t.count := by
  induction t with
  | leaf => simp [BinTree.mirror]
  | branch l x r ihl ihr =>
    simp [BinTree.mirror, BinTree.count]
    rw [ihl, ihr]
    simp_arith
```
<!--
In addition to definitions to be unfolded, the simplifier can also be passed names of equality proofs to use as rewrites while it simplifies proof goals. BinTree.mirror_count can also be written:
-->
除了要展开的定义外，简化器还可以传递等式证明的名称以在简化证明目标时用作重写。**BinTree.mirror_count** 还可以这样写：

```lean
theorem BinTree.mirror_count (t : BinTree α) : t.mirror.count = t.count := by
  induction t with
  | leaf => simp [BinTree.mirror]
  | branch l x r ihl ihr =>
    simp_arith [BinTree.mirror, BinTree.count, ihl, ihr]
```
<!--
As proofs grow more complicated, listing assumptions by hand can become tedious. Furthermore, manually writing assumption names can make it more difficult to re-use proof steps for multiple subgoals. The argument * to simp or simp_arith instructs them to use all assumptions while simplifying or solving the goal. In other words, the proof could also be written:
-->
随着证明变得更加复杂，手动列出假设会变得繁琐。此外，手动编写假设名称可能会使重复使用证明步骤来处理多个子目标变得更加困难。**simp** 或 **simp_arith** 的参数 * 指示它们在简化或解决目标时使用所有假设。换句话说，证明也可以这样写：

```lean
theorem BinTree.mirror_count (t : BinTree α) : t.mirror.count = t.count := by
  induction t with
  | leaf => simp [BinTree.mirror]
  | branch l x r ihl ihr =>
    simp_arith [BinTree.mirror, BinTree.count, *]
```
<!--
Because both branches are using the simplifier, the proof can be reduced to:
-->
因为两个分支都在使用简化器，证明可以简化为：

```lean
theorem BinTree.mirror_count (t : BinTree α) : t.mirror.count = t.count := by
  induction t <;> simp_arith [BinTree.mirror, BinTree.count, *]
```

## 练习 { #exercises }

<!--
1. Prove plusR_succ_left using the induction ... with tactic.
2. Rewrite the proof of plus_succ_left to use <;> in a single line.
3. Prove that appending lists is associative using induction on lists: theorem List.append_assoc (xs ys zs : List α) : xs ++ (ys ++ zs) = (xs ++ ys) ++ zs
-->
1. 使用**induction...with** 策略证明 **plusR_succ_left**。
2. 重写 **plus_succ_left** 的证明，使用 **<;>** 并写成一行。
3. 使用列表归纳证明列表追加是结合的：**theorem List.append_assoc (xs ys zs : List α) : xs ++ (ys ++ zs) = (xs ++ ys) ++ zs**