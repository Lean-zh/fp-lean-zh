<!--
# More Inequalities
-->

# 更多不等式

<!--
Lean's built-in proof automation is sufficient to check that `arrayMapHelper` and `findHelper` terminate.
All that was needed was to provide an expression whose value decreases with each recursive call.
However, Lean's built-in automation is not magic, and it often needs some help.
-->

Lean 的内置证明自动化足以检查 `arrayMapHelper` 和 `findHelper` 是否停机。
所需要做的就是提供一个值随着每次递归调用而减小的表达式。
但是，Lean 的内置自动化不是万能的，它通常需要一些帮助。

<!--
## Merge Sort
-->

## 归并排序

一个停机证明非平凡的函数示例是 `List` 上的归并排序。归并排序包含两个阶段：
首先，将列表分成两半。使用归并排序对每一半进行排序，
然后使用一个将两个已排序列表合并为一个更大的已排序列表的函数合并结果。
基本情况是空列表和单元素列表，它们都被认为已经排序。

<!--
To merge two sorted lists, there are two basic cases to consider:

 1. If one of the input lists is empty, then the result is the other list.
 2. If both lists are non-empty, then their heads should be compared. The result of the function is the smaller of the two heads, followed by the result of merging the remaining entries of both lists.
-->

要合并两个已排序列表，需要考虑两个基本情况：

 1. 如果一个输入列表为空，则结果是另一个列表。
 2. 如果两个列表都不为空，则应比较它们的头部。该函数的结果是两个头部中较小的一个，
    后面是合并两个列表的剩余项的结果。

<!--
This is not structurally recursive on either list.
The recursion terminates because an entry is removed from one of the two lists in each recursive call, but it could be either list.
The `termination_by` clause uses the sum of the length of both lists as a decreasing value:
-->

这在任何列表上都不是结构化递归。递归停机是因为在每次递归调用中都会从两个列表中的一个中删除一个项，
但它可能是任何一个列表。`termination_by` 子句使用两个列表长度的和作为递减值：

```lean
{{#example_decl Examples/ProgramsProofs/Inequalities.lean merge}}
```

<!--
In addition to using the lengths of the lists, a pair that contains both lists can also be provided:
-->

除了使用列表的长度外，还可以提供一个包含两个列表的偶对：

```lean
{{#example_decl Examples/ProgramsProofs/Inequalities.lean mergePairTerm}}
```

<!--
This works because Lean has a built-in notion of sizes of data, expressed through a type class called `WellFoundedRelation`.
The instance for pairs automatically considers them to be smaller if either the first or the second item in the pair shrinks.
-->

它有效是因为 Lean 有一个内置的数据大小概念，通过一个称为 `WellFoundedRelation`
的类型类来表示。如果偶对中的第一个或第二个项缩小，偶对的实例会自动认为它们会变小。

<!--
A simple way to split a list is to add each entry in the input list to two alternating output lists:
-->

分割列表的一个简单方法是将输入列表中的每个项添加到两个交替的输出列表中：

```lean
{{#example_decl Examples/ProgramsProofs/Inequalities.lean splitList}}
```

<!--
Merge sort checks whether a base case has been reached.
If so, it returns the input list.
If not, it splits the input, and merges the result of sorting each half:
-->

归并排序检查是否已达到基本情况。如果是，则返回输入列表。
如果不是，则分割输入，并合并对每一半排序的结果：

```lean
{{#example_in Examples/ProgramsProofs/Inequalities.lean mergeSortNoTerm}}
```

<!--
Lean's pattern match compiler is able to tell that the assumption `h` introduced by the `if` that tests whether `xs.length < 2` rules out lists longer than one entry, so there is no "missing cases" error.
However, even though this program always terminates, it is not structurally recursive:
-->

Lean 的模式匹配编译器能够判断由测试 `xs.length < 2` 的 `if` 引入的前提 `h`
排除了长度超过一个条目的列表，因此没有「缺少情况」的错误。
然而，即使此程序总是停机，它也不是结构化递归的：

```output error
{{#example_out Examples/ProgramsProofs/Inequalities.lean mergeSortNoTerm}}
```

<!--
The reason it terminates is that `splitList` always returns lists that are shorter than its input.
Thus, the length of `halves.fst` and `halves.snd` are less than the length of `xs`.
This can be expressed using a `termination_by` clause:
-->

它能停机的原因是 `splitList` 总是返回比其输入更短的列表。
因此，`halves.fst` 和 `halves.snd` 的长度小于 `xs` 的长度。
这可以使用 `termination_by` 子句来表示：

```lean
{{#example_in Examples/ProgramsProofs/Inequalities.lean mergeSortGottaProveIt}}
```

<!--
With this clause, the error message changes.
Instead of complaining that the function isn't structurally recursive, Lean instead points out that it was unable to automatically prove that `(splitList xs).fst.length < xs.length`:
-->

有了这个子句，错误信息就变了。Lean 不会抱怨函数不是结构化递归的，
而是指出它无法自动证明 `(splitList xs).fst.length < xs.length`：

```output error
{{#example_out Examples/ProgramsProofs/Inequalities.lean mergeSortGottaProveIt}}
```

<!--
## Splitting a List Makes it Shorter
-->

## 分割列表使其变短

<!--
It will also be necessary to prove that `(splitList xs).snd.length < xs.length`.
Because `splitList` alternates between adding entries to the two lists, it is easiest to prove both statements at once, so the structure of the proof can follow the algorithm used to implement `splitList`.
In other words, it is easiest to prove that `∀(lst : List), (splitList lst).fst.length < lst.length ∧ (splitList lst).snd.length < lst.length`.
-->

还需要证明 `(splitList xs).snd.length < xs.length`。由于 `splitList`
在向两个列表添加条目之间交替进行，因此最简单的方法是同时证明这两个语句，
这样证明的结构就可以遵循用于实现 `splitList` 的算法。换句话说，最简单的方法是证明
`∀(lst : List), (splitList lst).fst.length < lst.length ∧ (splitList lst).snd.length < lst.length`。

<!--
Unfortunately, the statement is false.
In particular, `{{#example_in Examples/ProgramsProofs/Inequalities.lean splitListEmpty}}` is `{{#example_out Examples/ProgramsProofs/Inequalities.lean splitListEmpty}}`. Both output lists have length `0`, which is not less than `0`, the length of the input list.
Similarly, `{{#example_in Examples/ProgramsProofs/Inequalities.lean splitListOne}}` evaluates to `{{#example_out Examples/ProgramsProofs/Inequalities.lean splitListOne}}`, and `["basalt"]` is not shorter than `["basalt"]`.
However, `{{#example_in Examples/ProgramsProofs/Inequalities.lean splitListTwo}}` evaluates to `{{#example_out Examples/ProgramsProofs/Inequalities.lean splitListTwo}}`, and both of these output lists are shorter than the input list.
-->

不幸的是，这个陈述是错误的。特别是，
`{{#example_in Examples/ProgramsProofs/Inequalities.lean splitListEmpty}}` 是
`{{#example_out Examples/ProgramsProofs/Inequalities.lean splitListEmpty}}`。
两个输出列表的长度都是 `0`，这并不小于输入列表的长度 `0`。类似地，
`{{#example_in Examples/ProgramsProofs/Inequalities.lean splitListOne}}` 求值为
`([\"basalt\"], [])`，而 `["basalt"]` 并不比 `["basalt"]` 短。然而，
`{{#example_in Examples/ProgramsProofs/Inequalities.lean splitListTwo}}` 求值为
`{{#example_out Examples/ProgramsProofs/Inequalities.lean splitListTwo}}`，
这两个输出列表都比输入列表短。

<!--
It turns out that the lengths of the output lists are always less than or equal to the length of the input list, but they are only strictly shorter when the input list contains at least two entries.
It turns out to be easiest to prove the former statement, then extend it to the latter statement.
Begin with a theorem statement:
-->

输出列表的长度始终小于或等于输入列表的长度，但仅当输入列表至少包含两个条目时，
它们才严格更短。事实证明，最容易证明前一个陈述，然后将其扩展到后一个陈述。
从定理的陈述开始：

```leantac
{{#example_in Examples/ProgramsProofs/Inequalities.lean splitList_shorter_le0}}
```

```output error
{{#example_out Examples/ProgramsProofs/Inequalities.lean splitList_shorter_le0}}
```

<!--
Because `splitList` is structurally recursive on the list, the proof should use induction.
The structural recursion in `splitList` fits a proof by induction perfectly: the base case of the induction matches the base case of the recursion, and the inductive step matches the recursive call.
The `induction` tactic gives two goals:
-->

由于 `splitList` 在列表上是结构化递归的，因此证明应使用归纳法。
`splitList` 中的结构化递归非常适合归纳证明：归纳法的基本情况与递归的基本情况匹配，
归纳步骤与递归调用匹配。`induction` 策略给出了两个目标：

```leantac
{{#example_in Examples/ProgramsProofs/Inequalities.lean splitList_shorter_le1a}}
```

```output error
{{#example_out Examples/ProgramsProofs/Inequalities.lean splitList_shorter_le1a}}
```

```output error
{{#example_out Examples/ProgramsProofs/Inequalities.lean splitList_shorter_le1b}}
```

<!--
The goal for the `nil` case can be proved by invoking the simplifier and instructing it to unfold the definition of `splitList`, because the length of the empty list is less than or equal to the length of the empty list.
Similarly, simplifying with `splitList` in the `cons` case places `Nat.succ` around the lengths in the goal:
-->

可以通过调用简化器并指示它展开 `splitList` 的定义来证明 `nil` 情况的目标，
因为空列表的长度小于或等于空列表的长度。类似地，在 `cons` 情况下使用 `splitList`
简化会在目标中的长度周围放置 `Nat.succ`：

```leantac
{{#example_in Examples/ProgramsProofs/Inequalities.lean splitList_shorter_le2}}
```

```output error
{{#example_out Examples/ProgramsProofs/Inequalities.lean splitList_shorter_le2}}
```

<!--
This is because the call to `List.length` consumes the head of the list `x :: xs`, converting it to a `Nat.succ`, in both the length of the input list and the length of the first output list.
-->

这是因为对 `List.length` 的调用消耗了列表 `x :: xs` 的头部，将其转换为 `Nat.succ`，
既在输入列表的长度中，也在第一个输出列表的长度中。

<!--
Writing `A ∧ B` in Lean is short for `And A B`.
`And` is a structure type in the `Prop` universe:
-->

在 Lean 中编写 `A ∧ B` 是 `And A B` 的缩写。
`And` 是 `Prop` 宇宙中的一个结构体类型：

```lean
{{#example_decl Examples/ProgramsProofs/Inequalities.lean And}}
```

<!--
In other words, a proof of `A ∧ B` consists of the `And.intro` constructor applied to a proof of `A` in the `left` field and a proof of `B` in the `right` field.
-->

换句话说，`A ∧ B` 的证明包括应用于 `left` 字段中 `A` 的证明和应用于 `right`
字段中 `B` 的证明的 `And.intro` 构造子。

<!--
The `cases` tactic allows a proof to consider each constructor of a datatype or each potential proof of a proposition in turn.
It corresponds to a `match` expression without recursion.
Using `cases` on a structure results in the structure being broken apart, with an assumption added for each field of the structure, just as a pattern match expression extracts the field of a structure for use in a program.
Because structures have only one constructor, using `cases` on a structure does not result in additional goals.
-->

`cases` 策略允许证明依次考虑数据类型的每个构造子或命题的每个潜在证明。
它对应于没有递归的 `match` 表达式。对结构体使用 `cases` 会导致结构体被分解，
并为结构体的每个字段添加一个假设，就像模式匹配表达式提取结构体的字段以用于程序中一样。
由于结构体只有一个构造子，因此对结构体使用 `cases` 不会产生额外的目标。

<!--
Because `ih` is a proof of `List.length (splitList xs).fst ≤ List.length xs ∧ List.length (splitList xs).snd ≤ List.length xs`, using `cases ih` results in an assumption that `List.length (splitList xs).fst ≤ List.length xs` and an assumption that `List.length (splitList xs).snd ≤ List.length xs`:
-->

由于 `ih` 是
`List.length (splitList xs).fst ≤ List.length xs ∧ List.length (splitList xs).snd ≤ List.length xs`
的一个证明，使用 `cases ih` 会产生一个 `List.length (splitList xs).fst ≤ List.length xs` 的假设
和一个 `List.length (splitList xs).snd ≤ List.length xs` 的假设:

```leantac
{{#example_in Examples/ProgramsProofs/Inequalities.lean splitList_shorter_le3}}
```

```output error
{{#example_out Examples/ProgramsProofs/Inequalities.lean splitList_shorter_le3}}
```

<!--
Because the goal of the proof is also an `And`, the `constructor` tactic can be used to apply `And.intro`, resulting in a goal for each argument:
-->

由于证明的目标也是一个 `And`，因此可以使用 `constructor` 策略应用 `And.intro`，
从而为每个参数生成一个目标：

```leantac
{{#example_in Examples/ProgramsProofs/Inequalities.lean splitList_shorter_le4}}
```

```output error
{{#example_out Examples/ProgramsProofs/Inequalities.lean splitList_shorter_le4}}
```

<!--
The `left` goal is very similar to the `left✝` assumption, except the goal wraps both sides of the inequality in `Nat.succ`.
Likewise, the `right` goal resembles the `right✝` assumption, except the goal adds a `Nat.succ` only to the length of the input list.
It's time to prove that these wrappings of `Nat.succ` preserve the truth of the statement.
-->

`left` 目标与 `left✝` 假设非常相似，除了目标用 `Nat.succ` 包装不等式的两侧。
同样，`right` 目标类似于 `right✝` 假设，除了目标仅将 `Nat.succ` 添加到输入列表的长度。
现在是时候证明 `Nat.succ` 的这些包装保留了陈述的真值了。

<!--
### Adding One to Both Sides
-->

### 两边同时加一

<!--
For the `left` goal, the statement to prove is `Nat.succ_le_succ : n ≤ m → Nat.succ n ≤ Nat.succ m`.
In other words, if `n ≤ m`, then adding one to both sides doesn't change this fact.
Why is this true?
The proof that `n ≤ m` is a `Nat.le.refl` constructor with `m - n` instances of the `Nat.le.step` constructor wrapped around it.
Adding one to both sides simply means that the `refl` applies to a number that's one larger than before, with the same number of `step` constructors.
-->

对于 `left` 目标，要证明的语句是 `Nat.succ_le_succ : n ≤ m → Nat.succ n ≤ Nat.succ m`。
换句话说，如果 `n ≤ m`，那么在两边都加一并不会改变这一事实。为什么这是真的？
证明 `n ≤ m` 是一个 `Nat.le.refl` 构造子，周围有 `m - n` 个 `Nat.le.step` 构造子的实例。
在两边都加一只是意味着 `refl` 应用于比之前大一的数，并且具有相同数量的 `step` 构造子。

<!--
More formally, the proof is by induction on the evidence that `n ≤ m`.
If the evidence is `refl`, then `n = m`, so `Nat.succ n = Nat.succ m` and `refl` can be used again.
If the evidence is `step`, then the induction hypothesis provides evidence that `Nat.succ n ≤ Nat.succ m`, and the goal is to show that `Nat.succ n ≤ Nat.succ (Nat.succ m)`.
This can be done by using `step` together with the induction hypothesis.
-->

更形式化地说，证明是通过归纳法来证明 `n ≤ m` 的证据。如果证据是 `refl`，则 `n = m`，
因此 `Nat.succ n = Nat.succ m`，并且可以再次使用 `refl`。
如果证据是 `step`，则归纳假设提供了 `Nat.succ n ≤ Nat.succ m` 的证据，
并且目标是证明 `Nat.succ n ≤ Nat.succ (Nat.succ m)`。
这可以通过将 `step` 与归纳假设一起使用来完成。

<!--
In Lean, the theorem statement is:
-->

在 Lean 中，该定理陈述为：

```leantac
{{#example_in Examples/ProgramsProofs/Inequalities.lean succ_le_succ0}}
```

<!--
and the error message recapitulates it:
-->

错误信息对其进行了概括：

```output error
{{#example_out Examples/ProgramsProofs/Inequalities.lean succ_le_succ0}}
```

<!--
The first step is to use the `intro` tactic, bringing the hypothesis that `n ≤ m` into scope and giving it a name:
-->

第一步是使用 `intro` 策略，将假设 `n ≤ m` 引入作用域并为其命名：

```leantac
{{#example_in Examples/ProgramsProofs/Inequalities.lean succ_le_succ1}}
```

```output error
{{#example_out Examples/ProgramsProofs/Inequalities.lean succ_le_succ1}}
```

<!--
Because the proof is by induction on the evidence that `n ≤ m`, the next tactic is `induction h`:
-->

由于证明是通过归纳法对证据 `n ≤ m` 进行的，因此下一个策略是 `induction h`：

```leantac
{{#example_in Examples/ProgramsProofs/Inequalities.lean succ_le_succ3}}
```

<!--
This results in two goals, once for each constructor of `Nat.le`:
-->

这会产生两个目标，每个目标对应于 `Nat.le` 的一个构造子：

```output error
{{#example_out Examples/ProgramsProofs/Inequalities.lean succ_le_succ3}}
```

<!--
The goal for `refl` can itself be solved using `refl`, which the `constructor` tactic selects.
The goal for `step` will also require a use of the `step` constructor:
-->

`refl` 的目标可以使用 `refl` 本身来解决，`constructor` 策略会选择它。
`step` 的目标还需要使用 `step` 构造子：

```leantac
{{#example_in Examples/ProgramsProofs/Inequalities.lean succ_le_succ4}}
```

```output error
{{#example_out Examples/ProgramsProofs/Inequalities.lean succ_le_succ4}}
```

<!--
The goal is no longer shown using the `≤` operator, but it is equivalent to the induction hypothesis `ih`.
The `assumption` tactic automatically selects an assumption that fulfills the goal, and the proof is complete:
-->

该目标不再使用 `≤` 运算符显示，但它等价于归纳假设 `ih`。
`assumption` 策略会自动选择一个满足目标的假设，证明完毕：

```leantac
{{#example_decl Examples/ProgramsProofs/Inequalities.lean succ_le_succ5}}
```

<!--
Written as a recursive function, the proof is:
-->

写成递归函数，证明如下：

```lean
{{#example_decl Examples/ProgramsProofs/Inequalities.lean succ_le_succ_recursive}}
```

<!--
It can be instructional to compare the tactic-based proof by induction with this recursive function.
Which proof steps correspond to which parts of the definition?
-->

将基于策略的归纳证明与这个递归函数进行比较是有指导意义的。哪些证明步骤对应于定义的哪些部分？

<!--
### Adding One to the Greater Side
-->

### 在较大的一侧加一

<!--
The second inequality needed to prove `splitList_shorter_le` is `∀(n m : Nat), n ≤ m → n ≤ Nat.succ m`.
This proof is almost identical to `Nat.succ_le_succ`.
Once again, the incoming assumption that `n ≤ m` essentially tracks the difference between `n` and `m` in the number of `Nat.le.step` constructors.
Thus, the proof should add an extra `Nat.le.step` in the base case.
The proof can be written:
-->

证明 `splitList_shorter_le` 所需的第二个不等式是 `∀(n m : Nat), n ≤ m → n ≤ Nat.succ m`。
这个证明几乎与 `Nat.succ_le_succ` 相同。同样，传入的假设 `n ≤ m` 基本上跟踪了 `n` 和 `m`
在 `Nat.le.step` 构造子数量上的差异。因此，证明应该在基本情况下添加一个额外的 `Nat.le.step`。
证明可以写成：

```leantac
{{#example_decl Examples/ProgramsProofs/Inequalities.lean le_succ_of_le}}
```

<!--
To reveal what's going on behind the scenes, the `apply` and `exact` tactics can be used to indicate exactly which constructor is being applied.
The `apply` tactic solves the current goal by applying a function or constructor whose return type matches, creating new goals for each argument that was not provided, while `exact` fails if any new goals would be needed:
-->

为了揭示幕后发生的事情，`apply` 和 `exact` 策略可用于准确指示正在应用哪个构造子。
`apply` 策略通过应用一个返回类型匹配的函数或构造子来解决当前目标，
为每个未提供的参数创建新的目标，而如果需要任何新目标，`exact` 就会失败：

```leantac
{{#example_decl Examples/ProgramsProofs/Inequalities.lean le_succ_of_le_apply}}
```

<!--
The proof can be golfed:
-->

证明可以简化：

```leantac
{{#example_decl Examples/ProgramsProofs/Inequalities.lean le_succ_of_le_golf}}
```

<!--
In this short tactic script, both goals introduced by `induction` are addressed using `repeat (first | constructor | assumption)`.
The tactic `first | T1 | T2 | ... | Tn` means to use try `T1` through `Tn` in order, using the first tactic that succeeds.
In other words, `repeat (first | constructor | assumption)` applies constructors as long as it can, and then attempts to solve the goal using an assumption.
-->

在这个简短的策略脚本中，由 `induction` 引入的两个目标都使用
`repeat (first | constructor | assumption)` 来解决。策略 `first | T1 | T2 | ... | Tn`
表示按顺序尝试 `T1` 到 `Tn`，然后使用第一个成功的策略。
换句话说，`repeat (first | constructor | assumption)` 会尽可能地应用构造子，
然后尝试使用假设来解决目标。

<!--
Finally, the proof can be written as a recursive function:
-->

最后，证明可以写成一个递归函数：

```lean
{{#example_decl Examples/ProgramsProofs/Inequalities.lean le_succ_of_le_recursive}}
```

<!--
Each style of proof can be appropriate to different circumstances.
The detailed proof script is useful in cases where beginners may be reading the code, or where the steps of the proof provide some kind of insight.
The short, highly-automated proof script is typically easier to maintain, because automation is frequently both flexible and robust in the face of small changes to definitions and datatypes.
The recursive function is typically both harder to understand from the perspective of mathematical proofs and harder to maintain, but it can be a useful bridge for programmers who are beginning to work with interactive theorem proving.
-->

每种证明风格都适用于不同的情况。详细的证明脚本在初学者阅读代码或证明步骤提供某种见解的情况下很有用。
简短、高度自动化的证明脚本通常更容易维护，因为自动化通常在面对定义和数据类型的细微更改时既灵活又健壮。
递归函数通常从数学证明的角度来看更难理解，也更难维护，但对于开始使用交互式定理证明的程序员来说，
它可能是一个有用的桥梁。

<!--
### Finishing the Proof
-->

### 完成证明

<!--
Now that both helper theorems have been proved, the rest of `splitList_shorter_le` will be completed quickly.
The current proof state has two goals, for the left and right sides of the `And`:
-->

现在已经证明了两个辅助定理，`splitList_shorter_le` 的其余部分将很快完成。
当前的证明状态有两个目标，用于 `And` 的左侧和右侧：

```output error
{{#example_out Examples/ProgramsProofs/Inequalities.lean splitList_shorter_le4}}
```

<!--
The goals are named for the fields of the `And` structure. This means that the `case` tactic (not to be confused with `cases`) can be used to focus on each of them in turn:
-->

目标以 `And` 结构体的字段命名。这意味着 `case` 策略（不要与 `cases` 混淆）可以依次关注于每个目标：

```leantac
{{#example_in Examples/ProgramsProofs/Inequalities.lean splitList_shorter_le5a}}
```

<!--
Instead of a single error that lists both unsolved goals, there are now two messages, one on each `skip`.
For the `left` goal, `Nat.succ_le_succ` can be used:
-->

现在不再是一个错误列出两个未解决的目标，而是有两个错误信息，
每个 `skip` 上一个。对于`left`目标，可以使用`Nat.succ_le_succ`：

```output error
{{#example_out Examples/ProgramsProofs/Inequalities.lean splitList_shorter_le5a}}
```

<!--
In the right goal, `Nat.le_suc_of_le` fits:
-->

在右侧目标中，`Nat.le_suc_of_le` 适合：

```output error
{{#example_out Examples/ProgramsProofs/Inequalities.lean splitList_shorter_le5b}}
```

<!--
Both theorems include the precondition that `n ≤ m`.
These can be found as the `left✝` and `right✝` assumptions, which means that the `assumption` tactic takes care of the final goals:
-->

这两个定理都包含前提条件 `n ≤ m`。它们可以作为 `left✝` 和 `right✝` 假设找到，
这意味着 `assumption` 策略可以处理最终目标：

```leantac
{{#example_decl Examples/ProgramsProofs/Inequalities.lean splitList_shorter_le}}
```

<!--
The next step is to return to the actual theorem that is needed to prove that merge sort terminates: that so long as a list has at least two entries, both results of splitting it are strictly shorter.
-->

下一步是返回到证明归并排序停机所需的实际定理：只要一个列表至少有两个条目，
则分割它的两个结果都严格短于它。

```leantac
{{#example_in Examples/ProgramsProofs/Inequalities.lean splitList_shorter_start}}
```

```output error
{{#example_out Examples/ProgramsProofs/Inequalities.lean splitList_shorter_start}}
```

<!--
Pattern matching works just as well in tactic scripts as it does in programs.
Because `lst` has at least two entries, they can be exposed with `match`, which also refines the type through dependent pattern matching:
-->

模式匹配在策略脚本中与在程序中一样有效。因为 `lst` 至少有两个条目，
所以它们可以用 `match` 暴露出来，它还通过依值模式匹配来细化类型：

```leantac
{{#example_in Examples/ProgramsProofs/Inequalities.lean splitList_shorter_1}}
```

```output error
{{#example_out Examples/ProgramsProofs/Inequalities.lean splitList_shorter_1}}
```

<!--
Simplifying using `splitList` removes `x` and `y`, resulting in the computed lengths of lists each gaining a `Nat.succ`:
-->

使用 `splitList` 简化会删除 `x` 和 `y`，导致列表的计算长度每个都获得 `Nat.succ`：

```leantac
{{#example_in Examples/ProgramsProofs/Inequalities.lean splitList_shorter_2}}
```

```output error
{{#example_out Examples/ProgramsProofs/Inequalities.lean splitList_shorter_2}}
```

<!--
Replacing `simp` with `simp_arith` removes these `Nat.succ` constructors, because `simp_arith` makes use of the fact that `n + 1 < m + 1` implies `n < m`:
-->

用 `simp_arith` 替换 `simp` 会删除这些 `Nat.succ` 构造子，
因为 `simp_arith` 利用了 `n + 1 < m + 1` 意味着 `n < m` 的事实：

```leantac
{{#example_in Examples/ProgramsProofs/Inequalities.lean splitList_shorter_2b}}
```

```output error
{{#example_out Examples/ProgramsProofs/Inequalities.lean splitList_shorter_2b}}
```

<!--
This goal now matches `splitList_shorter_le`, which can be used to conclude the proof:
-->

此目标现在匹配 `splitList_shorter_le`，可用于结束证明：

```leantac
{{#example_decl Examples/ProgramsProofs/Inequalities.lean splitList_shorter}}
```

<!--
The facts needed to prove that `mergeSort` terminates can be pulled out of the resulting `And`:
-->

证明 `mergeSort` 停机所需的事实可以从结果 `And` 中提取出来：

```leantac
{{#example_decl Examples/ProgramsProofs/Inequalities.lean splitList_shorter_sides}}
```

<!--
## Merge Sort Terminates
-->

## 归并排序停机证明

<!--
Merge sort has two recursive calls, one for each sub-list returned by `splitList`.
Each recursive call will require a proof that the length of the list being passed to it is shorter than the length of the input list.
It's usually convenient to write a termination proof in two steps: first, write down the propositions that will allow Lean to verify termination, and then prove them.
Otherwise, it's possible to put a lot of effort into proving the propositions, only to find out that they aren't quite what's needed to establish that the recursive calls are on smaller inputs.
-->

归并排序有两个递归调用，一个用于 `splitList` 返回的每个子列表。
每个递归调用都需要证明传递给它的列表的长度短于输入列表的长度。
通常分两步编写停机证明会更方便：首先，写下允许 Lean 验证停机的命题，然后证明它们。
否则，可能会投入大量精力来证明命题，却发现它们并不是所需的在更小的输入上建立递归调用的内容。

<!--
The `sorry` tactic can prove any goal, even false ones.
It isn't intended for use in production code or final proofs, but it is a convenient way to "sketch out" a proof or program ahead of time.
Any definitions or theorems that use `sorry` are annotated with a warning.
-->

`sorry` 策略可以证明任何目标，即使是错误的目标。它不适用于生产代码或最终证明，
但它是一种便捷的方法，可以提前「勾勒出」证明或程序。任何使用 `sorry` 的定义或定理都会附有警告。

<!--
The initial sketch of `mergeSort`'s termination argument that uses `sorry` can be written by copying the goals that Lean couldn't prove into `have`-expressions.
In Lean, `have` is similar to `let`.
When using `have`, the name is optional.
Typically, `let` is used to define names that refer to interesting values, while `have` is used to locally prove propositions that can be found when Lean is searching for evidence that an array lookup is in-bounds or that a function terminates.
-->

使用 `sorry` 的 `mergeSort` 停机论证的初始草图可以通过将 Lean 无法证明的目标复制到
`have` 表达式中来编写。在 Lean 中，`have` 类似于 `let`。使用 `have` 时，名称是可选的。
通常，`let` 用于定义引用关键值的名称，而 `have` 用于局部证明命题，
当 Lean 在寻找「数组查找是否在范围内」或「函数是否停机」的证据时，可以找到这些命题。

```leantac
{{#example_in Examples/ProgramsProofs/Inequalities.lean mergeSortSorry}}
```

<!--
The warning is located on the name `mergeSort`:
-->

警告位于名称 `mergeSort` 上：

```output warning
{{#example_out Examples/ProgramsProofs/Inequalities.lean mergeSortSorry}}
```

<!--
Because there are no errors, the proposed propositions are enough to establish termination.
-->

因为没有错误，所以建议的命题足以建立停机证明。

<!--
The proofs begin by applying the helper theorems:
-->

证明从应用辅助定理开始：

```leantac
{{#example_in Examples/ProgramsProofs/Inequalities.lean mergeSortNeedsGte}}
```

<!--
Both proofs fail, because `splitList_shorter_fst` and `splitList_shorter_snd` both require a proof that `xs.length ≥ 2`:
-->

两个证明都失败了，因为 `splitList_shorter_fst` 和 `splitList_shorter_snd`
都需要证明 `xs.length ≥ 2`：

```output error
{{#example_out Examples/ProgramsProofs/Inequalities.lean mergeSortNeedsGte}}
```

<!--
To check that this will be enough to complete the proof, add it using `sorry` and check for errors:
-->

要检查这是否足以完成证明，请使用 `sorry` 添加它并检查错误：

```leantac
{{#example_in Examples/ProgramsProofs/Inequalities.lean mergeSortGteStarted}}
```

<!--
Once again, there is only a warning.
-->

同样，只会有一个警告。

```output warning
{{#example_out Examples/ProgramsProofs/Inequalities.lean mergeSortGteStarted}}
```

<!--
There is one promising assumption available: `h : ¬List.length xs < 2`, which comes from the `if`.
Clearly, if it is not the case that `xs.length < 2`, then `xs.length ≥ 2`.
The Lean library provides this theorem under the name `Nat.ge_of_not_lt`.
The program is now complete:
-->

有一个有希望的假设可用：`h : ¬List.length xs < 2`，它来自 `if`。
显然，如果不是 `xs.length < 2`，那么 `xs.length ≥ 2`。
Lean 库以 `Nat.ge_of_not_lt` 的名称提供了此定理。程序现在已完成：

```leantac
{{#example_decl Examples/ProgramsProofs/Inequalities.lean mergeSort}}
```

<!--
The function can be tested on examples:
-->

该函数可以在示例上进行测试：

```lean
{{#example_in Examples/ProgramsProofs/Inequalities.lean mergeSortRocks}}
```

```output info
{{#example_out Examples/ProgramsProofs/Inequalities.lean mergeSortRocks}}
```

```lean
{{#example_in Examples/ProgramsProofs/Inequalities.lean mergeSortNumbers}}
```

```output info
{{#example_out Examples/ProgramsProofs/Inequalities.lean mergeSortNumbers}}
```

<!--
## Division as Iterated Subtraction
-->

## 用减法迭代表示除法

<!--
Just as multiplication is iterated addition and exponentiation is iterated multiplication, division can be understood as iterated subtraction.
The [very first description of recursive functions in this book](../getting-to-know/datatypes-and-patterns.md#recursive-functions) presents a version of division that terminates when the divisor is not zero, but that Lean does not accept.
Proving that division terminates requires the use of a fact about inequalities.
-->

正如乘法是迭代的加法，指数是迭代的乘法，除法可以理解为迭代的减法。
[本书中对递归函数的第一个描述](../getting-to-know/datatypes-and-patterns.md#递归函数)
给出了除法的一个版本，当除数不为零时停机，但 Lean 并不接受。证明除法终止需要使用关于不等式的事实。

<!--
The first step is to refine the definition of division so that it requires evidence that the divisor is not zero:
-->

第一步是细化除法的定义，使其需要证据证明除数不为零：

```lean
{{#example_in Examples/ProgramsProofs/Div.lean divTermination}}
```

<!--
The error message is somewhat longer, due to the additional argument, but it contains essentially the same information:
-->

由于增加了参数，错误信息会稍长一些，但它包含基本相同的信息：

```output error
{{#example_out Examples/ProgramsProofs/Div.lean divTermination}}
```

<!--
This definition of `div` terminates because the first argument `n` is smaller on each recursive call.
This can be expressed using a `termination_by` clause:
-->

`div` 的这个定义会停机，因为第一个参数 `n` 在每次递归调用时都更小。
这可以使用 `termination_by` 子句来表示：

```lean
{{#example_in Examples/ProgramsProofs/Div.lean divRecursiveNeedsProof}}
```

<!--
Now, the error is confined to the recursive call:
-->

现在，错误仅限于递归调用：

```output error
{{#example_out Examples/ProgramsProofs/Div.lean divRecursiveNeedsProof}}
```

<!--
This can be proved using a theorem from the standard library, `Nat.sub_lt`.
This theorem states that `{{#example_out Examples/ProgramsProofs/Div.lean NatSubLt}}` (the curly braces indicate that `n` and `k` are implicit arguments).
Using this theorem requires demonstrating that both `n` and `k` are greater than zero.
Because `k > 0` is syntactic sugar for `0 < k`, the only necessary goal is to show that `0 < n`.
There are two possibilities: either `n` is `0`, or it is `n' + 1` for some other `Nat` `n'`.
But `n` cannot be `0`.
The fact that the `if` selected the second branch means that `¬ n < k`, but if `n = 0` and `k > 0` then `n` must be less than `k`, which would be a contradiction.
This, `n = Nat.succ n'`, and `Nat.succ n'` is clearly greater than `0`.
-->

This can be proved using a theorem from the standard library, `Nat.sub_lt`.
This theorem states that  (the curly braces indicate that `n` and `k` are implicit arguments).
Using this theorem requires demonstrating that both `n` and `k` are greater than zero.
Because `k > 0` is syntactic sugar for `0 < k`, the only necessary goal is to show that `0 < n`.
There are two possibilities: either `n` is `0`, or it is `n' + 1` for some other `Nat` `n'`.
But `n` cannot be `0`.
The fact that the `if` selected the second branch means that `¬ n < k`, but if `n = 0` and `k > 0` then `n` must be less than `k`, which would be a contradiction.
This, `n = Nat.succ n'`, and `Nat.succ n'` is clearly greater than `0`.
这可以使用标准库中的定理 `Nat.sub_lt` 来证明。该定理指出
`{{#example_out Examples/ProgramsProofs/Div.lean NatSubLt}}`
（花括号表示 `n` 和 `k` 是隐式参数）。使用此定理需要证明 `n` 和 `k` 都大于零。
因为 `k > 0` 是 `0 < k` 的语法糖，所以唯一必要的目标是证明 `0 < n`。
有两种可能性：`n` 为 `0`，或它为某个其他 `Nat n'` 的 `n' + 1`。
但 `n` 不能为 `0`。`if` 选择第二个分支的事实意味着 `¬ n < k`，
但如果 `n = 0` 且 `k > 0`，则 `n` 必须小于 `k`，这将会产生矛盾。
在这里，`n = Nat.succ n'`，而 `Nat.succ n'` 明显大于 `0`。

<!--
The full definition of `div`, including the termination proof, is:
-->

`div` 的完整定义，包括停机证明：

```leantac
{{#example_decl Examples/ProgramsProofs/Div.lean div}}
```

<!--
## Exercises
-->

## 练习

<!--
Prove the following theorems:

 * For all natural numbers \\( n \\), \\( 0 < n + 1 \\).
 * For all natural numbers \\( n \\), \\( 0 \\leq n \\).
 * For all natural numbers \\( n \\) and \\( k \\), \\( (n + 1) - (k + 1) = n - k \\)
 * For all natural numbers \\( n \\) and \\( k \\), if \\( k < n \\) then \\( n \neq 0 \\)
 * For all natural numbers \\( n \\), \\( n - n = 0 \\)
 * For all natural numbers \\( n \\) and \\( k \\), if \\( n + 1 < k \\) then \\( n < k \\)
-->

证明以下定理：

 * 对于所有的自然数 \\( n \\)，\\( 0 < n + 1 \\)。
 * 对于所有的自然数 \\( n \\)，\\( 0 \\leq n \\)。
 * 对于所有的自然数 \\( n \\) 和 \\( k \\)，\\( (n + 1) - (k + 1) = n - k \\)
 * 对于所有的自然数 \\( n \\) 和 \\( k \\), 若 \\( k < n \\) 则 \\( n \neq 0 \\)
 * 对于所有的自然数 \\( n \\)，\\( n - n = 0 \\)
 * 对于所有的自然数 \\( n \\) 和 \\( k \\)，若 \\( n + 1 < k \\) 则 \\( n < k \\)
