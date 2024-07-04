<!--
# Interlude: Propositions, Proofs, and Indexing
-->

# 插曲：命题、证明与索引

<!--
Like many languages, Lean uses square brackets for indexing into arrays and lists.
For instance, if `woodlandCritters` is defined as follows:
-->

与许多语言一样，Lean 使用方括号对数组和列表进行索引。
例如，若 `woodlandCritters` 定义如下：

```lean
{{#example_decl Examples/Props.lean woodlandCritters}}
```

<!--
then the individual components can be extracted:
-->

则可以提取各个组件：

```lean
{{#example_decl Examples/Props.lean animals}}
```

<!--
However, attempting to extract the fourth element results in a compile-time error, rather than a run-time error:
-->

然而，试图提取第四个元素会导致编译时错误，而非运行时错误：

```lean
{{#example_in Examples/Props.lean outOfBounds}}
```

```output error
{{#example_out Examples/Props.lean outOfBounds}}
```

<!--
This error message is saying Lean tried to automatically mathematically prove that `3 < List.length woodlandCritters`, which would mean that the lookup was safe, but that it could not do so.
Out-of-bounds errors are a common class of bugs, and Lean uses its dual nature as a programming language and a theorem prover to rule out as many as possible.
-->

此错误消息表明 Lean 尝试自动数学证明 `3 < List.length oodlandCritters`，
这意味着查找是安全的，但它无法做到。越界错误是一类常见的错误，而 Lean
会利用其作为编程语言和定理证明器的双重特性来排除尽可能多的错误。

<!--
Understanding how this works requires an understanding of three key ideas: propositions, proofs, and tactics.
-->

要理解它是如何工作的，需要理解三个关键概念：命题、证明与策略。

<!--
## Propositions and Proofs
-->

## 命题与证明

<!--
A _proposition_ is a statement that can be true or false.
All of the following are propositions:

 * 1 + 1 = 2
 * Addition is commutative
 * There are infinitely many prime numbers
 * 1 + 1 = 15
 * Paris is the capital of France
 * Buenos Aires is the capital of South Korea
 * All birds can fly
-->

**命题（Proposition）** 是可以为真或为假的陈述句。以下所有句子都是命题：

 * 1 + 1 = 2
 * 加法满足交换律
 * 质数有无穷多个
 * 1 + 1 = 15
 * 巴黎是法国的首都
 * 布宜诺斯艾利斯是韩国的首都
 * 所有鸟都会飞

<!--
On the other hand, nonsense statements are not propositions.
None of the following are propositions:

 * 1 + green = ice cream
 * All capital cities are prime numbers
 * At least one gorg is a fleep
-->

另一方面，无意义的陈述不是命题。以下都不是命题：

 * 1 + 绿色 = 冰激凌
 * 所有首都都是质数
 * 至少有一个韟韚是一个棴囄䪖

<!--
Propositions come in two varieties: those that are purely mathematical, relying only on our definitions of concepts, and those that are facts about the world.
Theorem provers like Lean are concerned with the former category, and have nothing to say about the flight capabilities of penguins or the legal status of cities.
-->

命题有两种类型：纯粹的数学命题，仅依赖于我们对概念的定义；以及关于世界的事实。
像 Lean 这样的定理证明器关注的是前一类，而对企鹅的飞行能力或城市的法律地位无话可说。

<!--
A _proof_ is a convincing argument that a proposition is true.
For mathematical propositions, these arguments make use of the definitions of the concepts that are involved as well as the rules of logical argumentation.
Most proofs are written for people to understand, and leave out many tedious details.
Computer-aided theorem provers like Lean are designed to allow mathematicians to write proofs while omitting many details, and it is the software's responsibility to fill in the missing explicit steps.
This decreases the likelihood of oversights or mistakes.
-->

**证明（Proof）** 是说明命题是否为真的令人信服的论证。对于数学命题，
这些论证利用了所涉及概念的定义以及逻辑论证规则。
大多数证明都是为人的理解而写的，并省略了许多繁琐的细节。
像 Lean 这样的计算机辅助定理证明器旨在允许数学家在省略许多细节的情况下编写证明，
而软件负责填写缺失的明显步骤。这降低了疏忽或出错的可能性。

<!--
In Lean, a program's type describes the ways it can be interacted with.
For instance, a program of type `Nat → List String` is a function that takes a `Nat` argument and produces a list of strings.
In other words, each type specifies what counts as a program with that type.
-->

在 Lean 中，程序的类型描述了与它交互的方式。例如，类型为 `Nat → List String`
的程序是一个函数，它接受一个 `Nat` 参数并生成一个字符串列表。
换句话说，每个类型都指定了具有该类型的程序的内容。

<!--
In Lean, propositions are in fact types.
They specify what counts as evidence that the statement is true.
The proposition is proved by providing this evidence.
On the other hand, if the proposition is false, then it will be impossible to construct this evidence.
-->

在 Lean 中，命题即是类型。它们指定了语句为真的证据应有的内容。
通过提供此证据即可证明命题。另一方面，如果命题为假，则不可能构造此证据。

<!--
For example, the proposition "1 + 1 = 2" can be written directly in Lean.
The evidence for this proposition is the constructor `rfl`, which is short for _reflexivity_:
-->
例如，命题「1 + 1 = 2」可以直接写在 Lean 中。此命题的证据是构造子 `rfl`，
它是 **自反性（Reflexivity）** 的缩写：

```lean
{{#example_decl Examples/Props.lean onePlusOneIsTwo}}
```

<!--
On the other hand, `rfl` does not prove the false proposition "1 + 1 = 15":
-->

另一方面，`rfl` 不能证明错误命题「1 + 1 = 15」：

```lean
{{#example_in Examples/Props.lean onePlusOneIsFifteen}}
```

```output error
{{#example_out Examples/Props.lean onePlusOneIsFifteen}}
```

<!--
This error message indicates that `rfl` can prove that two expressions are equal when both sides of the equality statement are already the same number.
Because `1 + 1` evaluates directly to `2`, they are considered to be the same, which allows `onePlusOneIsTwo` to be accepted.
Just as `Type` describes types such as `Nat`, `String`, and `List (Nat × String × (Int → Float))` that represent data structures and functions, `Prop` describes propositions.
-->

此错误消息表明，当等式语句的两边已经是相同的数字时，`rfl` 可以证明两个表达式相等。
因为 `1 + 1` 直接计算为 `2`，所以它们被认为是相同的，这允许接受 `onePlusOneIsTwo`。
就像 `Type` 描述了表示数据结构和函数的类型（例如 `Nat`、`String` 和
`List (Nat × String × (Int → Float))`）一样，`Prop` 描述了命题。

<!--
When a proposition has been proven, it is called a _theorem_.
In Lean, it is conventional to declare theorems with the `theorem` keyword instead of `def`.
This helps readers see which declarations are intended to be read as mathematical proofs, and which are definitions.
Generally speaking, with a proof, what matters is that there is evidence that a proposition is true, but it's not particularly important _which_ evidence was provided.
With definitions, on the other hand, it matters very much which particular value is selected—after all, a definition of addition that always returns `0` is clearly wrong.
-->

当一个命题被证明后，它被称为一个 **定理（Theorem）** 。
在 Lean 中，惯例是用 `theorem` 关键字而非 `def` 来声明定理。
这有助于读者看出哪些声明旨在被解读为数学证明，哪些是定义。
一般来说，对于一个证明，重要的是有证据表明一个命题是正确的，
但提供 **哪个** 个证据并不特别重要。另一方面，对于定义，选择哪个特定值非常重要。
毕竟，一个总是返回 `0` 的加法定义显然是错误的。

<!--
The prior example could be rewritten as follows:
-->

前面的例子可以改写如下：

```lean
{{#example_decl Examples/Props.lean onePlusOneIsTwoProp}}
```

<!--
## Tactics
-->

## 策略

<!--
Proofs are normally written using _tactics_, rather than by providing evidence directly.
Tactics are small programs that construct evidence for a proposition.
These programs run in a _proof state_ that tracks the statement that is to be proved (called the _goal_) along with the assumptions that are available to prove it.
Running a tactic on a goal results in a new proof state that contains new goals.
The proof is complete when all goals have been proven.
-->

证明通常使用 **策略（Tactic）** 来编写，而非直接提供证据。策略是为命题构建证据的小程序。
这些程序在一个 **证明状态（Proof Statemen）** 中运行，该状态跟踪要证明的陈述（称为 **目标（Goal）**）
以及可用于证明它的假设。在目标上运行策略会产生一个包含新目标的新证明状态。
当所有目标都被证明后，证明就完成了。

<!--
To write a proof with tactics, begin the definition with `by`.
Writing `by` puts Lean into tactic mode until the end of the next indented block.
While in tactic mode, Lean provides ongoing feedback about the current proof state.
Written with tactics, `onePlusOneIsTwo` is still quite short:
-->

要使用策略编写证明，请以 `by` 开始定义。编写 `by` 会将 Lean 置于策略模式，
直到下一个缩进块的末尾。在策略模式下，Lean 会持续提供有关当前证明状态的反馈。
使用策略编写的 `onePlusOneIsTwo` 仍然很短：

```leantac
{{#example_decl Examples/Props.lean onePlusOneIsTwoTactics}}
```

<!--
The `simp` tactic, short for "simplify", is the workhorse of Lean proofs.
It rewrites the goal to as simple a form as possible, taking care of parts of the proof that are small enough.
In particular, it proves simple equality statements.
Behind the scenes, a detailed formal proof is constructed, but using `simp` hides this complexity.
-->

`simp` 策略，即「化简（Simplify）」的缩写，是 Lean 证明的主力。
它将目标重写为尽可能简单的形式，处理足够小的证明部分。特别是，它用于证明简单的相等陈述。
在幕后，它会构建一个详细的形式化证明，但使用 `simp` 隐藏了这种复杂性。

<!--
Tactics are useful for a number of reasons:
 1. Many proofs are complicated and tedious when written out down to the smallest detail, and tactics can automate these uninteresting parts.
 2. Proofs written with tactics are easier to maintain over time, because flexible automation can paper over small changes to definitions.
 3. Because a single tactic can prove many different theorems, Lean can use tactics behind the scenes to free users from writing proofs by hand. For instance, an array lookup requires a proof that the index is in bounds, and a tactic can typically construct that proof without the user needing to worry about it.
-->

策略在许多方面很有用：

 1. 许多证明在写到最小的细节时都很复杂且乏味，而策略可以自动完成这些无趣的部分。
 2. 使用策略编写的证明更容易维护，因为灵活的自动化可以弥补定义的细微更改。
 3. 由于一个策略可以证明许多不同的定理，Lean 可以使用幕后的策略来解放用户亲手写证明。
    例如，数组查找需要证明索引在范围内，而策略通常可以在用户无需担心它的情况下构造该证明。

<!--
Behind the scenes, indexing notation uses a tactic to prove that the user's lookup operation is safe.
This tactic is `simp`, configured to take certain arithmetic identities into account.
-->

在幕后，索引记法使用策略来证明用户的查找操作是安全的。
这个策略是 `simp`，它被配置为考虑某些算术恒等式。

<!--
## Connectives
-->

## 连词

<!--
The basic building blocks of logic, such as "and", "or", "true", "false", and "not", are called _logical connectives_.
Each connective defines what counts as evidence of its truth.
For example, to prove a statement "_A_ and _B_", one must prove both _A_ and _B_.
This means that evidence for "_A_ and _B_" is a pair that contains both evidence for _A_ and evidence for _B_.
Similarly, evidence for "_A_ or _B_" consists of either evidence for _A_ or evidence for _B_.
-->

逻辑的基本构建块，例如「与」、「或」、「真」、「假」和「非」，称为 **逻辑连词（Logical Connective）**。
每个连词定义了什么算作其真值的证据。例如，要证明一个陈述「_A_ 与 _B_」，必须证明 _A_ 和 _B_。
这意味着「_A_ 与 _B_」的证据是一对，其中包含 _A_ 的证据和 _B_ 的证据。
类似地，「_A_ 或 _B_」的证据由 _A_ 的证据或 _B_ 的证据组成。

<!--
In particular, most of these connectives are defined like datatypes, and they have constructors.
If `A` and `B` are propositions, then "`A` and `B`" (written `{{#example_in Examples/Props.lean AndProp}}`) is a proposition.
Evidence for `A ∧ B` consists of the constructor `{{#example_in Examples/Props.lean AndIntro}}`, which has the type `{{#example_out Examples/Props.lean AndIntro}}`.
Replacing `A` and `B` with concrete propositions, it is possible to prove `{{#example_out Examples/Props.lean AndIntroEx}}` with `{{#example_in Examples/Props.lean AndIntroEx}}`.
Of course, `simp` is also powerful enough to find this proof:
-->

特别是，大多数这些连词都像数据类型一样定义，并且它们有构造子。若 `A` 和 `B` 是命题，
则「`A` 与 `B`」（写作 `{{#example_in Examples/Props.lean AndProp}}`）也是一个命题。
`A ∧ B` 的证据由构造子 `{{#example_in Examples/Props.lean AndIntro}}` 组成，
其类型为 `{{#example_out Examples/Props.lean AndIntro}}`。用具体命题替换 `A` 和 `B`，
可以用 `{{#example_in Examples/Props.lean AndIntroEx}}` 证明
`{{#example_out Examples/Props.lean AndIntroEx}}`。
当然，`simp` 也足够强大到可以找到这个证明：

```leantac
{{#example_decl Examples/Props.lean AndIntroExTac}}
```

<!--
Similarly, "`A` or `B`" (written `{{#example_in Examples/Props.lean OrProp}}`) has two constructors, because a proof of "`A` or `B`" requires only that one of the two underlying propositions be true.
There are two constructors: `{{#example_in Examples/Props.lean OrIntro1}}`, with type `{{#example_out Examples/Props.lean OrIntro1}}`, and `{{#example_in Examples/Props.lean OrIntro2}}`, with type `{{#example_out Examples/Props.lean OrIntro2}}`.
-->

与此类似，「`A` 或 `B`」（写作 `{{#example_in Examples/Props.lean OrProp}}`）有两个构造子，
因为「`A` 或 `B`」的证明仅要求两个底层命题中的一个为真。它有两个构造子：
`{{#example_in Examples/Props.lean OrIntro1}}`，
类型为 `{{#example_out Examples/Props.lean OrIntro1}}`，
以及 `{{#example_in Examples/Props.lean OrIntro2}}`，
类型为 `{{#example_out Examples/Props.lean OrIntro2}}`。

<!--
Implication (if _A_ then _B_) is represented using functions.
In particular, a function that transforms evidence for _A_ into evidence for _B_ is itself evidence that _A_ implies _B_.
This is different from the usual description of implication, in which `A → B` is shorthand for `¬A ∨ B`, but the two formulations are equivalent.
-->

蕴含（若 _A_ 则 _B_）使用函数表示。特别是，将 _A_ 的证据转换为 _B_
的证据的函数本身就是 _A_ 蕴涵 _B_ 的证据。这与蕴涵的通常描述不同，
其中 `A → B` 是 `¬A ∨ B` 的简写，但这两个式子是等价的。

<!--
Because evidence for an "and" is a constructor, it can be used with pattern matching.
For instance, a proof that _A_ and _B_ implies _A_ or _B_ is a function that pulls the evidence of _A_ (or of _B_) out of the evidence for _A_ and _B_, and then uses this evidence to produce evidence of _A_ or _B_:
-->

由于「与」的证据是一个构造子，所以它可以与模式匹配一起使用。
例如，证明 _A_ 且 _B_ 蕴涵 _A_ 或 _B_ 的证明是一个函数，
它从 _A_ 和 _B_ 的证据中提取 _A_（或 _B_）的证据，然后使用此证据来生成 _A_ 或 _B_ 的证据：

```lean
{{#example_decl Examples/Props.lean andImpliesOr}}
```

<!--
| Connective      | Lean Syntax | Evidence     |
|-----------------|-------------|--------------|
| True            | `True`      | `True.intro : True` |
| False           | `False`     | No evidence  |
| _A_ and _B_     | `A ∧ B`     | `And.intro : A → B → A ∧ B` |
| _A_ or _B_      | `A ∨ B`     | Either `Or.inl : A → A ∨ B` or `Or.inr : B → A ∨ B` |
| _A_ implies _B_ | `A → B`     | A function that transforms evidence of _A_ into evidence of _B_ |
| not _A_         | `¬A`        | A function that would transform evidence of _A_ into evidence of `False` |
-->

| 连词         | Lean 语法 | 证据                                         |
| ------------ | --------- | -------------------------------------------- |
| 真           | `True`    | `True.intro : True`                          |
| 假           | `False`   | 无证据                                       |
| _A_ 与 _B_   | `A ∧ B`   | `And.intro : A → B → A ∧ B`                  |
| _A_ 或 _B_   | `A ∨ B`   | `Or.inl : A → A ∨ B` 或 `Or.inr : B → A ∨ B` |
| _A_ 蕴含 _B_ | `A → B`   | 将 _A_ 的证据转换到 _B_ 的证据的函数         |
| 非 _A_       | `¬A`      | 将 _A_ 的证据转换到 `False` 的证据的函数     |

<!--
The `simp` tactic can prove theorems that use these connectives.
For example:
-->

The `simp` 策略可以证明使用了这些连接词的定理。例如：

```leantac
{{#example_decl Examples/Props.lean connectives}}
```

<!--
## Evidence as Arguments
-->

## 证据作为参数

<!--
While `simp` does a great job proving propositions that involve equalities and inequalities of specific numbers, it is not very good at proving statements that involve variables.
For instance, `simp` can prove that `4 < 15`, but it can't easily tell that because `x < 4`, it's also true that `x < 15`.
Because index notation uses `simp` behind the scenes to prove that array access is safe, it can require a bit of hand-holding.
-->

尽管 `simp` 在证明涉及特定数字的等式和不等式的命题时表现出色，
但它在证明涉及变量的语句时效果不佳。例如，`simp` 可以证明 `4 < 15`，
但它不能轻易地判断出因为 `x < 4`，所以 `x < 15` 也成立。由于索引记法在幕后使用
`simp` 来证明数组访问是安全的，因此它可能需要一些人工干预。

<!--
One of the easiest ways to make indexing notation work well is to have the function that performs a lookup into a data structure take the required evidence of safety as an argument.
For instance, a function that returns the third entry in a list is not generally safe because lists might contain zero, one, or two entries:
-->

要让索引记法正常工作的最简单的方式之一，就是让执行数据结构查找的函数将所需的安全性证据作为参数。
例如，返回列表中第三个条目的函数通常不安全，因为列表可能包含零、一或两个条目：

```lean
{{#example_in Examples/Props.lean thirdErr}}
```

```output error
{{#example_out Examples/Props.lean thirdErr}}
```

<!--
However, the obligation to show that the list has at least three entries can be imposed on the caller by adding an argument that consists of evidence that the indexing operation is safe:
-->

然而，可以通过添加一个参数来强制调用者证明列表至少有三个条目，该参数包含索引操作安全的证据：

```lean
{{#example_decl Examples/Props.lean third}}
```

<!--
In this example, `xs.length > 2` is not a program that checks _whether_ `xs` has more than 2 entries.
It is a proposition that could be true or false, and the argument `ok` must be evidence that it is true.
-->

在本例中，`xs.length > 2` 并不是一个检查 `xs` 是否有 2 个以上条目的程序。
它是一个可能是真或假的命题，参数 `ok` 必须是它为真的证据。

<!--
When the function is called on a concrete list, its length is known.
In these cases, `by simp` can construct the evidence automatically:
-->

当函数在一个具体的列表上调用时，它的长度是已知的。在这些情况下，`by simp` 可以自动构造证据：

```leantac
{{#example_in Examples/Props.lean thirdCritters}}
```

```output info
{{#example_out Examples/Props.lean thirdCritters}}
```

<!--
## Indexing Without Evidence
-->

## 无证据索引

<!--
In cases where it's not practical to prove that an indexing operation is in bounds, there are other alternatives.
Adding a question mark results in an `Option`, where the result is `some` if the index is in bounds, and `none` otherwise.
For example:
-->

在无法证明索引操作在边界内的情况下，还有其他选择。添加一个问号会产生一个 `Option`，
如果索引在边界内，结果为 `some`，否则为 `none`。例如：

```lean
{{#example_decl Examples/Props.lean thirdOption}}

{{#example_in Examples/Props.lean thirdOptionCritters}}
```

```output info
{{#example_out Examples/Props.lean thirdOptionCritters}}
```

```lean
{{#example_in Examples/Props.lean thirdOptionTwo}}
```

```output info
{{#example_out Examples/Props.lean thirdOptionTwo}}
```

<!--
There is also a version that crashes the program when the index is out of bounds, rather than returning an `Option`:
-->

还有一个版本，当索引超出边界时会使程序崩溃，而非返回一个 `Option`：

```lean
{{#example_in Examples/Props.lean crittersBang}}
```

```output info
{{#example_out Examples/Props.lean crittersBang}}
```

<!--
Be careful!
Because code that is run with `#eval` runs in the context of the Lean compiler, selecting the wrong index can crash your IDE.
-->

小心！因为使用 `#eval` 运行的代码在 Lean 编译器的上下文中运行，
选择错误的索引可能会使你的 IDE 崩溃。

<!--
## Messages You May Meet
-->

## 你可能会遇到的信息

<!--
In addition to the error that occurs when Lean is unable to find compile-time evidence that an indexing operation is safe, polymorphic functions that use unsafe indexing may produce the following message:
-->

除了 Lean 在找不到编译时证据而无法证明索引操作安全时产生的错误之外，
使用不安全索引的多态函数可能会产生以下消息：

```lean
{{#example_in Examples/Props.lean unsafeThird}}
```

```output error
{{#example_out Examples/Props.lean unsafeThird}}
```

<!--
This is due to a technical restriction that is part of keeping Lean usable as both a logic for proving theorems and a programming language.
In particular, only programs whose types contain at least one value are allowed to crash.
This is because a proposition in Lean is a kind of type that classifies evidence of its truth.
False propositions have no such evidence.
If a program with an empty type could crash, then that crashing program could be used as a kind of fake evidence for a false proposition.
-->

这是由于技术限制，该限制是将 Lean 同时用作证明定理的逻辑和编程语言的一部分。
特别是，只有类型中至少包含一个值的程序才允许崩溃。
这是因为 Lean 中的命题是一种对真值证据进行分类的类型。假命题没有这样的证据。
如果具有空类型的程序可能崩溃，那么该崩溃程序可以用作对假命题的一种假的证据。

<!--
Internally, Lean contains a table of types that are known to have at least one value.
This error is saying that some arbitrary type `α` is not necessarily in that table.
The next chapter describes how to add to this table, and how to successfully write functions like `unsafeThird`.
-->

在内部，Lean 包含一个已知至少有一个值的类型的表。此错误表明某个任意类型 `α` 不一定在该表中。
下一章描述如何向此表添加内容，以及如何成功编写诸如 `unsafeThird` 之类的函数。

<!--
Adding whitespace between a list and the brackets used for lookup can cause another message:
-->

在列表和用于查找的括号之间添加空格会产生另一条消息：

```lean
{{#example_in Examples/Props.lean extraSpace}}
```

```output error
{{#example_out Examples/Props.lean extraSpace}}
```

<!--
Adding a space causes Lean to treat the expression as a function application, and the index as a list that contains a single number.
This error message results from having Lean attempt to treat `woodlandCritters` as a function.
-->

添加空格会导致 Lean 将表达式视为函数应用，并将索引视为包含单个数字的列表。
此错误消息是由 Lean 尝试将 `woodlandCritters` 视为函数而产生的。

<!--
## Exercises
-->

## 练习

<!--
* Prove the following theorems using `rfl`: `2 + 3 = 5`, `15 - 8 = 7`, `"Hello, ".append "world" = "Hello, world"`. What happens if `rfl` is used to prove `5 < 18`? Why?
* Prove the following theorems using `by simp`: `2 + 3 = 5`, `15 - 8 = 7`, `"Hello, ".append "world" = "Hello, world"`, `5 < 18`.
* Write a function that looks up the fifth entry in a list. Pass the evidence that this lookup is safe as an argument to the function.
-->

* 使用 `rfl` 证明以下定理：`2 + 3 = 5`、`15 - 8 = 7`、
  `"Hello, ".append "world" = "Hello, world"`。
  如果使用 `rfl` 证明 `5 < 18` 会发生什么？为什么？
* 使用 `by simp` 证明以下定理：`2 + 3 = 5`、`15 - 8 = 7`、
  `"Hello, ".append "world" = "Hello, world"`、`5 < 18`。
* 编写一个函数，用于查找列表中的第五个条目。将此查找安全的证据作为参数传递给函数。
