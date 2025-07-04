import VersoManual
import FPLeanZh.Examples

open Verso.Genre Manual
open Verso.Code.External

open FPLeanZh

set_option verso.exampleProject "../examples"
set_option verso.exampleModule "Examples.ProgramsProofs.Inequalities"

#doc (Manual) "More Inequalities" =>

/-
Lean's built-in proof automation is sufficient to check that {anchorName ArrayMapHelperOk (module:=Examples.ProgramsProofs.Arrays)}`arrayMapHelper` and {anchorName ArrayFindHelper (module:=Examples.ProgramsProofs.Arrays)}`findHelper` terminate.
All that was needed was to provide an expression whose value decreases with each recursive call.
However, Lean's built-in automation is not magic, and it often needs some help.
-/
Lean 的内置证明自动化足以检查 {anchorName ArrayMapHelperOk (module:=Examples.ProgramsProofs.Arrays)}`arrayMapHelper` 和 {anchorName ArrayFindHelper (module:=Examples.ProgramsProofs.Arrays)}`findHelper` 是否停机。
所需要做的就是提供一个值随着每次递归调用而减小的表达式。
但是，Lean 的内置自动化不是万能的，它通常需要一些帮助。

/-- Merge Sort -/
# 归并排序

/-
One example of a function whose termination proof is non-trivial is merge sort on {moduleName}`List`.
Merge sort consists of two phases: first, a list is split in half.
Each half is sorted using merge sort, and then the results are merged using a function that combines two sorted lists into a larger sorted list.
The base cases are the empty list and the singleton list, both of which are already considered to be sorted.
-/
一个停机证明非平凡的函数示例是 {moduleName}`List` 上的归并排序。归并排序包含两个阶段：
首先，将列表分成两半。使用归并排序对每一半进行排序，
然后使用一个将两个已排序列表合并为一个更大的已排序列表的函数合并结果。
基本情况是空列表和单元素列表，它们都被认为已经排序。

/-
To merge two sorted lists, there are two basic cases to consider:
 1. If one of the input lists is empty, then the result is the other list.
 2. If both lists are non-empty, then their heads should be compared. The result of the function is the smaller of the two heads, followed by the result of merging the remaining entries of both lists.
-/
要合并两个已排序列表，需要考虑两个基本情况：
 1. 如果一个输入列表为空，则结果是另一个列表。
 2. 如果两个列表都不为空，则应比较它们的头部。该函数的结果是两个头部中较小的一个，
    后面是合并两个列表的剩余项的结果。

/-
This is not structurally recursive on either list.
The recursion terminates because an entry is removed from one of the two lists in each recursive call, but it could be either list.
Behind the scenes, Lean uses this fact to prove that it terminates:
-/
这在任何列表上都不是结构化递归。递归停机是因为在每次递归调用中都会从两个列表中的一个中删除一个项，
但它可能是任何一个列表。在幕后，Lean 使用这个事实来证明它停机：

```anchor merge
def merge [Ord α] (xs : List α) (ys : List α) : List α :=
  match xs, ys with
  | [], _ => ys
  | _, [] => xs
  | x'::xs', y'::ys' =>
    match Ord.compare x' y' with
    | .lt | .eq => x' :: merge xs' (y' :: ys')
    | .gt => y' :: merge (x'::xs') ys'
```


/-
A simple way to split a list is to add each entry in the input list to two alternating output lists:
-/
分割列表的一个简单方法是将输入列表中的每个项添加到两个交替的输出列表中：

```anchor splitList
def splitList (lst : List α) : (List α × List α) :=
  match lst with
  | [] => ([], [])
  | x :: xs =>
    let (a, b) := splitList xs
    (x :: b, a)
```
/-
This splitting function is structurally recursive.
-/
这个分割函数是结构化递归的。

/-
Merge sort checks whether a base case has been reached.
If so, it returns the input list.
If not, it splits the input, and merges the result of sorting each half:
-/
归并排序检查是否已达到基本情况。
如果是，则返回输入列表。
如果不是，则分割输入，并合并对每一半排序的结果：
```anchor mergeSortNoTerm
def mergeSort [Ord α] (xs : List α) : List α :=
  if h : xs.length < 2 then
    match xs with
    | [] => []
    | [x] => [x]
  else
    let halves := splitList xs
    merge (mergeSort halves.fst) (mergeSort halves.snd)
```
/-
Lean's pattern match compiler is able to tell that the assumption {anchorName mergeSortNoTerm}`h` introduced by the {kw}`if` that tests whether {anchorTerm mergeSortNoTerm}`xs.length < 2` rules out lists longer than one entry, so there is no “missing cases” error.
However, even though this program always terminates, it is not structurally recursive, and Lean is unable to automatically discover a decreasing measure:
-/
Lean 的模式匹配编译器能够判断由测试 {anchorTerm mergeSortNoTerm}`xs.length < 2` 的 {kw}`if` 引入的假设 {anchorName mergeSortNoTerm}`h` 排除了长度超过一个条目的列表，因此没有"缺少情况"的错误。
然而，即使此程序总是停机，它也不是结构化递归的，Lean 无法自动发现递减度量：

```anchorError mergeSortNoTerm
fail to show termination for
  mergeSort
with errors
failed to infer structural recursion:
Not considering parameter α of mergeSort:
  it is unchanged in the recursive calls
Not considering parameter #2 of mergeSort:
  it is unchanged in the recursive calls
Cannot use parameter xs:
  failed to eliminate recursive application
    mergeSort halves.fst


failed to prove termination, possible solutions:
  - Use `have`-expressions to prove the remaining goals
  - Use `termination_by` to specify a different well-founded relation
  - Use `decreasing_by` to specify your own tactic for discharging this kind of goal
α : Type u_1
xs : List α
h : ¬xs.length < 2
halves : List α × List α := splitList xs
⊢ sizeOf (splitList xs).fst < sizeOf xs
```
/-
The reason it terminates is that {anchorName mergeSortNoTerm}`splitList` always returns lists that are shorter than its input, at least when applied to lists that contain at least two elements.
Thus, the length of {anchorTerm mergeSortNoTerm}`halves.fst` and {anchorTerm mergeSortNoTerm}`halves.snd` are less than the length of {anchorName mergeSortNoTerm}`xs`.
This can be expressed using a {kw}`termination_by` clause:
-/
它能停机的原因是 {anchorName mergeSortNoTerm}`splitList` 总是返回比其输入更短的列表，至少当应用于包含至少两个元素的列表时是这样。
因此，{anchorTerm mergeSortNoTerm}`halves.fst` 和 {anchorTerm mergeSortNoTerm}`halves.snd` 的长度小于 {anchorName mergeSortNoTerm}`xs` 的长度。
这可以使用 {kw}`termination_by` 子句来表示：
```anchor mergeSortGottaProveIt
def mergeSort [Ord α] (xs : List α) : List α :=
  if h : xs.length < 2 then
    match xs with
    | [] => []
    | [x] => [x]
  else
    let halves := splitList xs
    merge (mergeSort halves.fst) (mergeSort halves.snd)
termination_by xs.length
```
/-
With this clause, the error message changes.
Instead of complaining that the function isn't structurally recursive, Lean instead points out that it was unable to automatically prove that {lit}`(splitList xs).fst.length < xs.length`:
-/
有了这个子句，错误信息就变了。
Lean 不会抱怨函数不是结构化递归的，而是指出它无法自动证明 {lit}`(splitList xs).fst.length < xs.length`：
```anchorError mergeSortGottaProveIt
failed to prove termination, possible solutions:
  - Use `have`-expressions to prove the remaining goals
  - Use `termination_by` to specify a different well-founded relation
  - Use `decreasing_by` to specify your own tactic for discharging this kind of goal
α : Type u_1
xs : List α
h : ¬xs.length < 2
halves : List α × List α := splitList xs
⊢ (splitList xs).fst.length < xs.length
```

/-- Splitting a List Makes it Shorter -/
# 分割列表使其变短

/-
It will also be necessary to prove that {lit}`(splitList xs).snd.length < xs.length`.
Because {anchorName splitList}`splitList` alternates between adding entries to the two lists, it is easiest to prove both statements at once, so the structure of the proof can follow the algorithm used to implement {anchorName splitList}`splitList`.
In other words, it is easiest to prove that {anchorTerm splitList_shorter_bad_ty}`∀(lst : List α), (splitList lst).fst.length < lst.length ∧ (splitList lst).snd.length < lst.length`.
-/
还需要证明 {lit}`(splitList xs).snd.length < xs.length`。
由于 {anchorName splitList}`splitList` 在两个列表之间交替添加项，最容易同时证明这两个语句，
这样证明的结构可以遵循用于实现 {anchorName splitList}`splitList` 的算法。
换句话说，最容易证明 {anchorTerm splitList_shorter_bad_ty}`∀(lst : List α), (splitList lst).fst.length < lst.length ∧ (splitList lst).snd.length < lst.length`。

/-
Unfortunately, the statement is false.
In particular, {anchorTerm splitListEmpty}`splitList []` is {anchorTerm splitListEmpty}`([], [])`. Both output lists have length {anchorTerm ArrayMap (module:=Examples.ProgramsProofs.Arrays)}`0`, which is not less than {anchorTerm ArrayMap (module:=Examples.ProgramsProofs.Arrays)}`0`, the length of the input list.
Similarly, {anchorTerm splitListOne}`splitList ["basalt"]` evaluates to {anchorTerm splitListOne}`(["basalt"], [])`, and {anchorTerm splitListOne}`["basalt"]` is not shorter than {anchorTerm splitListOne}`["basalt"]`.
However, {anchorTerm splitListTwo}`splitList ["basalt", "granite"]` evaluates to {anchorTerm splitListTwo}`(["basalt"], ["granite"])`, and both of these output lists are shorter than the input list.
-/
不幸的是，这个语句是假的。
特别地，{anchorTerm splitListEmpty}`splitList []` 是 {anchorTerm splitListEmpty}`([], [])`。
两个输出列表的长度都是 {anchorTerm ArrayMap (module:=Examples.ProgramsProofs.Arrays)}`0`，
这不小于输入列表的长度 {anchorTerm ArrayMap (module:=Examples.ProgramsProofs.Arrays)}`0`。
同样，{anchorTerm splitListOne}`splitList ["basalt"]` 求值为 {anchorTerm splitListOne}`(["basalt"], [])`，
而 {anchorTerm splitListOne}`["basalt"]` 并不比 {anchorTerm splitListOne}`["basalt"]` 短。
然而，{anchorTerm splitListTwo}`splitList ["basalt", "granite"]` 求值为 {anchorTerm splitListTwo}`(["basalt"], ["granite"])`，
这两个输出列表都比输入列表短。

/-
It turns out that the lengths of the output lists are always less than or equal to the length of the input list, but they are only strictly shorter when the input list contains at least two entries.
It turns out to be easiest to prove the former statement, then extend it to the latter statement.
Begin with a theorem statement:
-/
事实证明，输出列表的长度总是小于或等于输入列表的长度，
但只有当输入列表包含至少两个项时，它们才严格较短。
事实证明，最容易先证明前一个语句，然后将其扩展到后一个语句。
从一个定理语句开始：
```anchor splitList_shorter_le0
theorem splitList_shorter_le (lst : List α) :
    (splitList lst).fst.length ≤ lst.length ∧
      (splitList lst).snd.length ≤ lst.length := by
  skip
```
```anchorError splitList_shorter_le0
unsolved goals
α : Type u_1
lst : List α
⊢ (splitList lst).fst.length ≤ lst.length ∧ (splitList lst).snd.length ≤ lst.length
```
/-
Because {anchorName splitList}`splitList` is structurally recursive on the list, the proof should use induction.
The structural recursion in {anchorName splitList}`splitList` fits a proof by induction perfectly: the base case of the induction matches the base case of the recursion, and the inductive step matches the recursive call.
The {kw}`induction` tactic gives two goals:
-/
由于 {anchorName splitList}`splitList` 在列表上是结构化递归的，证明应该使用归纳法。
{anchorName splitList}`splitList` 中的结构化递归与归纳证明完全匹配：
归纳的基本情况匹配递归的基本情况，归纳步骤匹配递归调用。
{kw}`induction` 策略给出两个目标：
```anchor splitList_shorter_le1a
theorem splitList_shorter_le (lst : List α) :
    (splitList lst).fst.length ≤ lst.length ∧
      (splitList lst).snd.length ≤ lst.length := by
  induction lst with
  | nil => skip
  | cons x xs ih => skip
```
```anchorError splitList_shorter_le1a
unsolved goals
case nil
α : Type u_1
⊢ (splitList []).fst.length ≤ [].length ∧ (splitList []).snd.length ≤ [].length
```
```anchorError splitList_shorter_le1b
unsolved goals
case cons
α : Type u_1
x : α
xs : List α
ih : (splitList xs).fst.length ≤ xs.length ∧ (splitList xs).snd.length ≤ xs.length
⊢ (splitList (x :: xs)).fst.length ≤ (x :: xs).length ∧ (splitList (x :: xs)).snd.length ≤ (x :: xs).length
```

/-
The goal for the {anchorName splitList_shorter_le2}`nil` case can be proved by invoking the simplifier and instructing it to unfold the definition of {anchorName splitList}`splitList`, because the length of the empty list is less than or equal to the length of the empty list.
Similarly, simplifying with {anchorName splitList}`splitList` in the {anchorName splitList_shorter_le2}`cons` case places {anchorName various}`Nat.succ` around the lengths in the goal:
-/
{anchorName splitList_shorter_le2}`nil` 情况的目标可以通过调用简化器并指示它展开 {anchorName splitList}`splitList` 的定义来证明，
因为空列表的长度小于或等于空列表的长度。
类似地，在 {anchorName splitList_shorter_le2}`cons` 情况中使用 {anchorName splitList}`splitList` 进行简化会在目标中的长度周围放置 {anchorName various}`Nat.succ`：
```anchor splitList_shorter_le2
theorem splitList_shorter_le (lst : List α) :
    (splitList lst).fst.length ≤ lst.length ∧
      (splitList lst).snd.length ≤ lst.length := by
  induction lst with
  | nil => simp [splitList]
  | cons x xs ih =>
    simp [splitList]
```
```anchorError splitList_shorter_le2
unsolved goals
case cons
α : Type u_1
x : α
xs : List α
ih : (splitList xs).fst.length ≤ xs.length ∧ (splitList xs).snd.length ≤ xs.length
⊢ (splitList xs).snd.length ≤ xs.length ∧ (splitList xs).fst.length ≤ xs.length + 1
```
/-
This is because the call to {anchorName various}`List.length` consumes the head of the list {anchorTerm splitList}`x :: xs`, converting it to a {anchorName various}`Nat.succ`, in both the length of the input list and the length of the first output list.
-/
这是因为调用 {anchorName various}`List.length` 消耗列表 {anchorTerm splitList}`x :: xs` 的头部，
将其转换为 {anchorName various}`Nat.succ`，无论是在输入列表的长度还是第一个输出列表的长度中。

/-
Writing {anchorTerm various}`A ∧ B` in Lean is short for {anchorTerm various}`And A B`.
{anchorName And}`And` is a structure type in the {anchorTerm And}`Prop` universe:
-/
在 Lean 中写 {anchorTerm various}`A ∧ B` 是 {anchorTerm various}`And A B` 的简写。
{anchorName And}`And` 是 {anchorTerm And}`Prop` 宇宙中的结构类型：

```anchor And
structure And (a b : Prop) : Prop where
  intro ::
  left : a
  right : b
```
/-
In other words, a proof of {anchorTerm various}`A ∧ B` consists of the {anchorName AndUse}`And.intro` constructor applied to a proof of {anchorName AndUse}`A` in the {anchorName And}`left` field and a proof of {anchorName AndUse}`B` in the {anchorName And}`right` field.
-/
换句话说，{anchorTerm various}`A ∧ B` 的证明由 {anchorName AndUse}`And.intro` 构造器组成，
应用于 {anchorName And}`left` 字段中 {anchorName AndUse}`A` 的证明和 {anchorName And}`right` 字段中 {anchorName AndUse}`B` 的证明。

/-
The {kw}`cases` tactic allows a proof to consider each constructor of a datatype or each potential proof of a proposition in turn.
It corresponds to a {kw}`match` expression without recursion.
Using {kw}`cases` on a structure results in the structure being broken apart, with an assumption added for each field of the structure, just as a pattern match expression extracts the field of a structure for use in a program.
Because structures have only one constructor, using {kw}`cases` on a structure does not result in additional goals.
-/
{kw}`cases` 策略允许证明依次考虑数据类型的每个构造器或命题的每个潜在证明。
它对应于没有递归的 {kw}`match` 表达式。
在结构上使用 {kw}`cases` 会导致结构被分解，为结构的每个字段添加一个假设，
就像模式匹配表达式提取结构的字段以在程序中使用一样。
因为结构只有一个构造器，在结构上使用 {kw}`cases` 不会产生额外的目标。

/-
Because {anchorName splitList_shorter_le3}`ih` is a proof of {lit}`List.length (splitList xs).fst ≤ List.length xs ∧ List.length (splitList xs).snd ≤ List.length xs`, using {anchorTerm splitList_shorter_le3}`cases ih` results in an assumption that {lit}`List.length (splitList xs).fst ≤ List.length xs` and an assumption that {lit}`List.length (splitList xs).snd ≤ List.length xs`:
-/
因为 {anchorName splitList_shorter_le3}`ih` 是 {lit}`List.length (splitList xs).fst ≤ List.length xs ∧ List.length (splitList xs).snd ≤ List.length xs` 的证明，
使用 {anchorTerm splitList_shorter_le3}`cases ih` 会产生 {lit}`List.length (splitList xs).fst ≤ List.length xs` 的假设
和 {lit}`List.length (splitList xs).snd ≤ List.length xs` 的假设：
```anchor splitList_shorter_le3
theorem splitList_shorter_le (lst : List α) :
    (splitList lst).fst.length ≤ lst.length ∧
      (splitList lst).snd.length ≤ lst.length := by
  induction lst with
  | nil => simp [splitList]
  | cons x xs ih =>
    simp [splitList]
    cases ih
```
```anchorError splitList_shorter_le3
unsolved goals
case cons.intro
α : Type u_1
x : α
xs : List α
left✝ : (splitList xs).fst.length ≤ xs.length
right✝ : (splitList xs).snd.length ≤ xs.length
⊢ (splitList xs).snd.length ≤ xs.length ∧ (splitList xs).fst.length ≤ xs.length + 1
```

/-
Because the goal of the proof is also an {anchorName AndUse}`And`, the {kw}`constructor` tactic can be used to apply {anchorName AndUse}`And.intro`, resulting in a goal for each argument:
-/
因为证明的目标也是一个 {anchorName AndUse}`And`，可以使用 {kw}`constructor` 策略来应用 {anchorName AndUse}`And.intro`，
从而为每个参数产生一个目标：
```anchor splitList_shorter_le4
theorem splitList_shorter_le (lst : List α) :
    (splitList lst).fst.length ≤ lst.length ∧
      (splitList lst).snd.length ≤ lst.length := by
  induction lst with
  | nil => simp [splitList]
  | cons x xs ih =>
    simp [splitList]
    cases ih
    constructor
```
```anchorError splitList_shorter_le4
unsolved goals
case cons.intro.left
α : Type u_1
x : α
xs : List α
left✝ : (splitList xs).fst.length ≤ xs.length
right✝ : (splitList xs).snd.length ≤ xs.length
⊢ (splitList xs).snd.length ≤ xs.length

case cons.intro.right
α : Type u_1
x : α
xs : List α
left✝ : (splitList xs).fst.length ≤ xs.length
right✝ : (splitList xs).snd.length ≤ xs.length
⊢ (splitList xs).fst.length ≤ xs.length + 1
```

/-
The {anchorTerm splitList_shorter_le5}`left` goal is identical to the {lit}`left✝` assumption, so the {kw}`assumption` tactic dispatches it:
-/
{anchorTerm splitList_shorter_le5}`left` 目标与 {lit}`left✝` 假设相同，因此 {kw}`assumption` 策略可以解决它：
```anchor splitList_shorter_le5
theorem splitList_shorter_le (lst : List α) :
    (splitList lst).fst.length ≤ lst.length ∧
      (splitList lst).snd.length ≤ lst.length := by
  induction lst with
  | nil => simp [splitList]
  | cons x xs ih =>
    simp [splitList]
    cases ih
    constructor
    case left => assumption
```
```anchorError splitList_shorter_le5
unsolved goals
case cons.intro.right
α : Type u_1
x : α
xs : List α
left✝ : (splitList xs).fst.length ≤ xs.length
right✝ : (splitList xs).snd.length ≤ xs.length
⊢ (splitList xs).fst.length ≤ xs.length + 1
```

/-
The {anchorTerm splitList_shorter_le}`right` goal resembles the {lit}`right✝` assumption, except the goal adds a {anchorTerm le_succ_of_le}`+ 1` only to the length of the input list.
It's time to prove that the inequality holds.
-/
{anchorTerm splitList_shorter_le}`right` 目标类似于 {lit}`right✝` 假设，
不同之处在于目标只在输入列表的长度上添加了 {anchorTerm le_succ_of_le}`+ 1`。
现在是证明不等式成立的时候了。

/-- Adding One to the Greater Side -/
## 在较大一侧加一

/-
The inequality needed to prove {anchorName splitList_shorter_le}`splitList_shorter_le` is {anchorTerm le_succ_of_le_statement}`∀(n m : Nat), n ≤ m → n ≤ m + 1`.
The incoming assumption that {anchorTerm le_succ_of_le_statement}`n ≤ m` essentially tracks the difference between {anchorName le_succ_of_le_statement}`n` and {anchorName le_succ_of_le_statement}`m` in the number of {anchorName le_succ_of_le_apply}`Nat.le.step` constructors.
Thus, the proof should add an extra {anchorName le_succ_of_le_apply}`Nat.le.step` in the base case.
-/
证明 {anchorName splitList_shorter_le}`splitList_shorter_le` 所需的不等式是 {anchorTerm le_succ_of_le_statement}`∀(n m : Nat), n ≤ m → n ≤ m + 1`。
传入的 {anchorTerm le_succ_of_le_statement}`n ≤ m` 假设本质上在 {anchorName le_succ_of_le_apply}`Nat.le.step` 构造器的数量中跟踪 {anchorName le_succ_of_le_statement}`n` 和 {anchorName le_succ_of_le_statement}`m` 之间的差异。
因此，证明应该在基本情况中添加一个额外的 {anchorName le_succ_of_le_apply}`Nat.le.step`。

/-
Starting out, the statement reads:
-/
开始时，语句为：
```anchor le_succ_of_le0
theorem Nat.le_succ_of_le : n ≤ m → n ≤ m + 1 := by
  skip
```
```anchorError le_succ_of_le0
unsolved goals
n m : Nat
⊢ n ≤ m → n ≤ m + 1
```

/-
The first step is to introduce a name for the assumption that {anchorTerm le_succ_of_le1}`n ≤ m`:
-/
第一步是为假设 {anchorTerm le_succ_of_le1}`n ≤ m` 引入一个名称：
```anchor le_succ_of_le1
theorem Nat.le_succ_of_le : n ≤ m → n ≤ m + 1 := by
  intro h
```
```anchorError le_succ_of_le1
unsolved goals
n m : Nat
h : n ≤ m
⊢ n ≤ m + 1
```

/-
The proof is by induction on this assumption:
-/
证明通过对这个假设的归纳：
```anchor le_succ_of_le2a
theorem Nat.le_succ_of_le : n ≤ m → n ≤ m + 1 := by
  intro h
  induction h with
  | refl => skip
  | step _ ih => skip
```
/-
In the case for {anchorName le_succ_of_le2a}`refl`, where {lit}`n = m`, the goal is to prove that {lit}`n ≤ n + 1`:
-/
在 {anchorName le_succ_of_le2a}`refl` 的情况下，其中 {lit}`n = m`，目标是证明 {lit}`n ≤ n + 1`：
```anchorError le_succ_of_le2a
unsolved goals
case refl
n m : Nat
⊢ n ≤ n + 1
```
/-
In the case for {anchorName le_succ_of_le2b}`step`, the goal is to prove that {anchorTerm le_succ_of_le2b}`n ≤ m + 1` under the assumption that {anchorTerm le_succ_of_le2b}`n ≤ m`:
-/
在 {anchorName le_succ_of_le2b}`step` 的情况下，目标是在假设 {anchorTerm le_succ_of_le2b}`n ≤ m` 下证明 {anchorTerm le_succ_of_le2b}`n ≤ m + 1`：
```anchorError le_succ_of_le2b
unsolved goals
case step
n m m✝ : Nat
a✝ : n.le m✝
ih : n ≤ m✝ + 1
⊢ n ≤ m✝.succ + 1
```
/-
For the {anchorName le_succ_of_le3}`refl` case, the {anchorName le_succ_of_le3}`step` constructor can be applied:
-/
对于 {anchorName le_succ_of_le3}`refl` 情况，可以应用 {anchorName le_succ_of_le3}`step` 构造器：
```anchor le_succ_of_le3
theorem Nat.le_succ_of_le : n ≤ m → n ≤ m + 1 := by
  intro h
  induction h with
  | refl => constructor
  | step _ ih => skip
```
```anchorError le_succ_of_le3
unsolved goals
case refl.a
n m : Nat
⊢ n.le n
```
/-
After {anchorName Nat.le_ctors}`step`, {anchorName Nat.le_ctors}`refl` can be used, which leaves only the goal for {anchorName le_succ_of_le4}`step`:
-/
在 {anchorName Nat.le_ctors}`step` 之后，可以使用 {anchorName Nat.le_ctors}`refl`，这只留下 {anchorName le_succ_of_le4}`step` 的目标：
```anchor le_succ_of_le4
theorem Nat.le_succ_of_le : n ≤ m → n ≤ m + 1 := by
  intro h
  induction h with
  | refl => constructor; constructor
  | step _ ih => skip
```
```anchorError le_succ_of_le4
unsolved goals
case step
n m m✝ : Nat
a✝ : n.le m✝
ih : n ≤ m✝ + 1
⊢ n ≤ m✝.succ + 1
```
/-
For the step, applying the {anchorName Nat.le_ctors}`step` constructor transforms the goal into the induction hypothesis:
-/
对于步骤，应用 {anchorName Nat.le_ctors}`step` 构造器将目标转换为归纳假设：
```anchor le_succ_of_le5
theorem Nat.le_succ_of_le : n ≤ m → n ≤ m + 1 := by
  intro h
  induction h with
  | refl => constructor; constructor
  | step _ ih => constructor
```
```anchorError le_succ_of_le5
unsolved goals
case step.a
n m m✝ : Nat
a✝ : n.le m✝
ih : n ≤ m✝ + 1
⊢ n.le (m✝ + 1)
```
/-
The final proof is as follows:
-/
最终证明如下：

```anchor le_succ_of_le
theorem Nat.le_succ_of_le : n ≤ m → n ≤ m + 1 := by
  intro h
  induction h with
  | refl => constructor; constructor
  | step => constructor; assumption
```

/-
To reveal what's going on behind the scenes, the {kw}`apply` and {kw}`exact` tactics can be used to indicate exactly which constructor is being applied.
The {kw}`apply` tactic solves the current goal by applying a function or constructor whose return type matches, creating new goals for each argument that was not provided, while {kw}`exact` fails if any new goals would be needed:
-/
为了揭示幕后发生的事情，可以使用 {kw}`apply` 和 {kw}`exact` 策略来准确指示正在应用哪个构造器。
{kw}`apply` 策略通过应用返回类型匹配的函数或构造器来解决当前目标，为每个未提供的参数创建新目标，
而 {kw}`exact` 如果需要任何新目标则失败：

```anchor le_succ_of_le_apply
theorem Nat.le_succ_of_le : n ≤ m → n ≤ m + 1 := by
  intro h
  induction h with
  | refl => apply Nat.le.step; exact Nat.le.refl
  | step _ ih => apply Nat.le.step; exact ih
```

/-
The proof can be golfed:
-/
证明可以简化：

```anchor le_succ_of_le_golf
theorem Nat.le_succ_of_le (h : n ≤ m) : n ≤ m + 1:= by
  induction h <;> repeat (first | constructor | assumption)
```
/-
In this short tactic script, both goals introduced by {kw}`induction` are addressed using {anchorTerm le_succ_of_le_golf}`repeat (first | constructor | assumption)`.
The tactic {lit}`first | T1 | T2 | ... | Tn` means to use try {lit}`T1` through {lit}`Tn` in order, using the first tactic that succeeds.
In other words, {anchorTerm le_succ_of_le_golf}`repeat (first | constructor | assumption)` applies constructors as long as it can, and then attempts to solve the goal using an assumption.
-/
在这个简短的策略脚本中，{kw}`induction` 引入的两个目标都使用 {anchorTerm le_succ_of_le_golf}`repeat (first | constructor | assumption)` 处理。
策略 {lit}`first | T1 | T2 | ... | Tn` 意味着按顺序尝试 {lit}`T1` 到 {lit}`Tn`，使用第一个成功的策略。
换句话说，{anchorTerm le_succ_of_le_golf}`repeat (first | constructor | assumption)` 尽可能地应用构造器，然后尝试使用假设解决目标。

/-
The proof can be shortened even further by using {anchorTerm le_succ_of_le_omega}`omega`, a built-in solver for linear arithmetic:
-/
通过使用 {anchorTerm le_succ_of_le_omega}`omega`（线性算术的内置求解器），证明可以进一步缩短：

```anchor le_succ_of_le_omega
theorem Nat.le_succ_of_le (h : n ≤ m) : n ≤ m + 1:= by
  omega
```

/-
Finally, the proof can be written as a recursive function:
-/
最后，证明可以写成递归函数：

```anchor le_succ_of_le_recursive
theorem Nat.le_succ_of_le : n ≤ m → n ≤ m + 1
  | .refl => .step .refl
  | .step h => .step (Nat.le_succ_of_le h)
```

/-
Each style of proof can be appropriate to different circumstances.
The detailed proof script is useful in cases where beginners may be reading the code, or where the steps of the proof provide some kind of insight.
The short, highly-automated proof script is typically easier to maintain, because automation is frequently both flexible and robust in the face of small changes to definitions and datatypes.
The recursive function is typically both harder to understand from the perspective of mathematical proofs and harder to maintain, but it can be a useful bridge for programmers who are beginning to work with interactive theorem proving.
-/
每种证明风格都适用于不同的情况。
详细的证明脚本在初学者可能阅读代码的情况下很有用，或者在证明步骤提供某种洞察的情况下很有用。
简短、高度自动化的证明脚本通常更容易维护，因为自动化在面对定义和数据类型的小变化时通常既灵活又健壮。
/-
The recursive function is typically both harder to understand from the perspective of mathematical proofs and harder to maintain, but it can be a useful bridge for programmers who are beginning to work with interactive theorem proving.
-/
递归函数从数学证明的角度来看通常既难以理解又难以维护，但对于开始使用交互式定理证明的程序员来说，它可以是一个有用的桥梁。

/-- Finishing the Proof -/
## 完成证明

/-
Now that both helper theorems have been proved, the rest of {anchorName splitList_shorter_le5}`splitList_shorter_le` will be completed quickly.
The current proof state has one goal remaining:
-/
现在两个辅助定理都已经证明了，{anchorName splitList_shorter_le5}`splitList_shorter_le` 的其余部分将很快完成。
当前证明状态有一个剩余目标：
```anchorError splitList_shorter_le5
unsolved goals
case cons.intro.right
α : Type u_1
x : α
xs : List α
left✝ : (splitList xs).fst.length ≤ xs.length
right✝ : (splitList xs).snd.length ≤ xs.length
⊢ (splitList xs).fst.length ≤ xs.length + 1
```

/-
Using {anchorName splitList_shorter_le}`Nat.le_succ_of_le` together with the {lit}`right✝` assumption completes the proof:
-/
使用 {anchorName splitList_shorter_le}`Nat.le_succ_of_le` 与 {lit}`right✝` 假设一起完成证明：

```anchor splitList_shorter_le
theorem splitList_shorter_le (lst : List α) :
    (splitList lst).fst.length ≤ lst.length ∧
      (splitList lst).snd.length ≤ lst.length := by
  induction lst with
  | nil => simp [splitList]
  | cons x xs ih =>
    simp [splitList]
    cases ih
    constructor
    case left => assumption
    case right =>
      apply Nat.le_succ_of_le
      assumption
```

/-
The next step is to return to the actual theorem that is needed to prove that merge sort terminates: that so long as a list has at least two entries, both results of splitting it are strictly shorter.
-/
下一步是返回到证明归并排序停机所需的实际定理：只要一个列表至少有两个条目，则分割它的两个结果都严格短于它。
```anchor splitList_shorter_start
theorem splitList_shorter (lst : List α) (_ : lst.length ≥ 2) :
    (splitList lst).fst.length < lst.length ∧
      (splitList lst).snd.length < lst.length := by
  skip
```
```anchorError splitList_shorter_start
unsolved goals
α : Type u_1
lst : List α
x✝ : lst.length ≥ 2
⊢ (splitList lst).fst.length < lst.length ∧ (splitList lst).snd.length < lst.length
```
/-
Pattern matching works just as well in tactic scripts as it does in programs.
Because {anchorName splitList_shorter_1}`lst` has at least two entries, they can be exposed with {kw}`match`, which also refines the type through dependent pattern matching:
-/
模式匹配在策略脚本中与在程序中一样有效。
因为 {anchorName splitList_shorter_1}`lst` 至少有两个条目，所以它们可以用 {kw}`match` 暴露出来，它还通过依值模式匹配来细化类型：
```anchor splitList_shorter_1
theorem splitList_shorter (lst : List α) (_ : lst.length ≥ 2) :
    (splitList lst).fst.length < lst.length ∧
      (splitList lst).snd.length < lst.length := by
  match lst with
  | x :: y :: xs =>
    skip
```
```anchorError splitList_shorter_1
unsolved goals
α : Type u_1
lst : List α
x y : α
xs : List α
x✝ : (x :: y :: xs).length ≥ 2
⊢ (splitList (x :: y :: xs)).fst.length < (x :: y :: xs).length ∧
    (splitList (x :: y :: xs)).snd.length < (x :: y :: xs).length
```
/-
Simplifying using {anchorName splitList}`splitList` removes {anchorName splitList_shorter_2}`x` and {anchorName splitList_shorter_2}`y`, resulting in the computed lengths of lists each gaining a {anchorTerm le_succ_of_le}`+ 1`:
-/
使用 {anchorName splitList}`splitList` 进行简化会移除 {anchorName splitList_shorter_2}`x` 和 {anchorName splitList_shorter_2}`y`，导致列表的计算长度各自增加一个 {anchorTerm le_succ_of_le}`+ 1`：
```anchor splitList_shorter_2
theorem splitList_shorter (lst : List α) (_ : lst.length ≥ 2) :
    (splitList lst).fst.length < lst.length ∧
      (splitList lst).snd.length < lst.length := by
  match lst with
  | x :: y :: xs =>
    simp [splitList]
```
```anchorError splitList_shorter_2
unsolved goals
α : Type u_1
lst : List α
x y : α
xs : List α
x✝ : (x :: y :: xs).length ≥ 2
⊢ (splitList xs).fst.length < xs.length + 1 ∧ (splitList xs).snd.length < xs.length + 1
```
/-
Replacing {anchorTerm splitList_shorter_2b}`simp` with {anchorTerm splitList_shorter_2b}`simp +arith` removes these {anchorTerm le_succ_of_le}`+ 1`s, because {anchorTerm splitList_shorter_2b}`simp +arith` makes use of the fact that {anchorTerm Nat.lt_imp}`n + 1 < m + 1` implies {anchorTerm Nat.lt_imp}`n < m`:
-/
将 {anchorTerm splitList_shorter_2b}`simp` 替换为 {anchorTerm splitList_shorter_2b}`simp +arith` 会移除这些 {anchorTerm le_succ_of_le}`+ 1`，
因为 {anchorTerm splitList_shorter_2b}`simp +arith` 利用了 {anchorTerm Nat.lt_imp}`n + 1 < m + 1` 意味着 {anchorTerm Nat.lt_imp}`n < m` 的事实：
```anchor splitList_shorter_2b
theorem splitList_shorter (lst : List α) (_ : lst.length ≥ 2) :
    (splitList lst).fst.length < lst.length ∧
      (splitList lst).snd.length < lst.length := by
  match lst with
  | x :: y :: xs =>
    simp +arith [splitList]
```
```anchorError splitList_shorter_2b
unsolved goals
α : Type u_1
lst : List α
x y : α
xs : List α
x✝ : (x :: y :: xs).length ≥ 2
⊢ (splitList xs).fst.length ≤ xs.length ∧ (splitList xs).snd.length ≤ xs.length
```
/-
This goal now matches {anchorName splitList_shorter}`splitList_shorter_le`, which can be used to conclude the proof:
-/
这个目标现在与 {anchorName splitList_shorter}`splitList_shorter_le` 匹配，可以用来完成证明：

```anchor splitList_shorter
theorem splitList_shorter (lst : List α) (_ : lst.length ≥ 2) :
    (splitList lst).fst.length < lst.length ∧
      (splitList lst).snd.length < lst.length := by
  match lst with
  | x :: y :: xs =>
    simp +arith [splitList]
    apply splitList_shorter_le
```

/-
The facts needed to prove that {anchorName mergeSort}`mergeSort` terminates can be pulled out of the resulting {anchorName AndUse}`And`:
-/
证明 {anchorName mergeSort}`mergeSort` 停机所需的事实可以从生成的 {anchorName AndUse}`And` 中提取出来：

```anchor splitList_shorter_sides
theorem splitList_shorter_fst (lst : List α) (h : lst.length ≥ 2) :
    (splitList lst).fst.length < lst.length :=
  splitList_shorter lst h |>.left

theorem splitList_shorter_snd (lst : List α) (h : lst.length ≥ 2) :
    (splitList lst).snd.length < lst.length :=
  splitList_shorter lst h |>.right
```

# Merge Sort Terminates

/-
Merge sort has two recursive calls, one for each sub-list returned by {anchorName splitList}`splitList`.
Each recursive call will require a proof that the length of the list being passed to it is shorter than the length of the input list.
It's usually convenient to write a termination proof in two steps: first, write down the propositions that will allow Lean to verify termination, and then prove them.
Otherwise, it's possible to put a lot of effort into proving the propositions, only to find out that they aren't quite what's needed to establish that the recursive calls are on smaller inputs.
-/
# 归并排序停机

归并排序有两个递归调用，{anchorName splitList}`splitList` 返回的每个子列表各一个。
每个递归调用都需要证明传递给它的列表的长度比输入列表的长度短。
通常方便的做法是分两步写停机证明：首先，写下允许 Lean 验证停机的命题，然后证明它们。
否则，可能会花费大量精力来证明命题，结果却发现它们不完全符合建立递归调用在更小输入上的需要。

/-
The {lit}`sorry` tactic can prove any goal, even false ones.
It isn't intended for use in production code or final proofs, but it is a convenient way to “sketch out” a proof or program ahead of time.
Any definitions or theorems that use {lit}`sorry` are annotated with a warning.

The initial sketch of {anchorName mergeSortSorry}`mergeSort`'s termination argument that uses {lit}`sorry` can be written by copying the goals that Lean couldn't prove into {kw}`have`-expressions.
In Lean, {kw}`have` is similar to {kw}`let`.
When using {kw}`have`, the name is optional.
Typically, {kw}`let` is used to define names that refer to interesting values, while {kw}`have` is used to locally prove propositions that can be found when Lean is searching for evidence that an array lookup is in-bounds or that a function terminates.
-/
{lit}`sorry` 策略可以证明任何目标，甚至是错误的目标。
它不适用于生产代码或最终证明，但它是提前"勾勒"证明或程序的便捷方式。
任何使用 {lit}`sorry` 的定义或定理都会标注警告。

使用 {lit}`sorry` 的 {anchorName mergeSortSorry}`mergeSort` 停机参数的初始草图可以通过将 Lean 无法证明的目标复制到 {kw}`have` 表达式中来编写。
在 Lean 中，{kw}`have` 类似于 {kw}`let`。
使用 {kw}`have` 时，名称是可选的。
通常，{kw}`let` 用于定义引用有趣值的名称，而 {kw}`have` 用于局部证明命题，当 Lean 搜索数组查找在边界内或函数停机的证据时可以找到这些命题。

```anchor mergeSortSorry
def mergeSort [Ord α] (xs : List α) : List α :=
  if h : xs.length < 2 then
    match xs with
    | [] => []
    | [x] => [x]
  else
    let halves := splitList xs
    have : halves.fst.length < xs.length := by
      sorry
    have : halves.snd.length < xs.length := by
      sorry
    merge (mergeSort halves.fst) (mergeSort halves.snd)
termination_by xs.length
```
/-
The warning is located on the name {anchorName mergeSortSorry}`mergeSort`:
-/
警告位于名称 {anchorName mergeSortSorry}`mergeSort` 上：
```anchorWarning mergeSortSorry
declaration uses 'sorry'
```
/-
Because there are no errors, the proposed propositions are enough to establish termination.
-/
因为没有错误，所提出的命题足以建立停机。

/-
The proofs begin by applying the helper theorems:
-/
证明开始时应用辅助定理：
```anchor mergeSortNeedsGte
def mergeSort [Ord α] (xs : List α) : List α :=
  if h : xs.length < 2 then
    match xs with
    | [] => []
    | [x] => [x]
  else
    let halves := splitList xs
    have : halves.fst.length < xs.length := by
      apply splitList_shorter_fst
    have : halves.snd.length < xs.length := by
      apply splitList_shorter_snd
    merge (mergeSort halves.fst) (mergeSort halves.snd)
termination_by xs.length
```
/-
Both proofs fail, because {anchorName mergeSortNeedsGte}`splitList_shorter_fst` and {anchorName mergeSortNeedsGte}`splitList_shorter_snd` both require a proof that {anchorTerm mergeSortGteStarted}`xs.length ≥ 2`:
-/
两个证明都失败了，因为 {anchorName mergeSortNeedsGte}`splitList_shorter_fst` 和 {anchorName mergeSortNeedsGte}`splitList_shorter_snd` 都需要证明 {anchorTerm mergeSortGteStarted}`xs.length ≥ 2`：
```anchorError mergeSortNeedsGte
unsolved goals
case h
α : Type ?u.54766
inst✝ : Ord α
xs : List α
h : ¬xs.length < 2
halves : List α × List α := splitList xs
⊢ xs.length ≥ 2
```
/-
To check that this will be enough to complete the proof, add it using {lit}`sorry` and check for errors:
-/
要检查这是否足以完成证明，使用 {lit}`sorry` 添加它并检查错误：
```anchor mergeSortGteStarted
def mergeSort [Ord α] (xs : List α) : List α :=
  if h : xs.length < 2 then
    match xs with
    | [] => []
    | [x] => [x]
  else
    let halves := splitList xs
    have : xs.length ≥ 2 := by sorry
    have : halves.fst.length < xs.length := by
      apply splitList_shorter_fst
      assumption
    have : halves.snd.length < xs.length := by
      apply splitList_shorter_snd
      assumption
    merge (mergeSort halves.fst) (mergeSort halves.snd)
termination_by xs.length
```
/-
Once again, there is only a warning.
-/
再一次，只有警告。
```anchorWarning mergeSortGteStarted
declaration uses 'sorry'
```

/-
There is one promising assumption available: {lit}`h : ¬List.length xs < 2`, which comes from the {kw}`if`.
Clearly, if it is not the case that {anchorTerm mergeSort}`xs.length < 2`, then {anchorTerm mergeSort}`xs.length ≥ 2`.
The {anchorTerm mergeSort}`omega` tactic solves this goal, and the program is now complete:
-/
有一个有希望的假设可用：{lit}`h : ¬List.length xs < 2`，它来自 {kw}`if`。
显然，如果不是 {anchorTerm mergeSort}`xs.length < 2` 的情况，那么 {anchorTerm mergeSort}`xs.length ≥ 2`。
{anchorTerm mergeSort}`omega` 策略解决了这个目标，程序现在完成了：

```anchor mergeSort
def mergeSort [Ord α] (xs : List α) : List α :=
  if h : xs.length < 2 then
    match xs with
    | [] => []
    | [x] => [x]
  else
    let halves := splitList xs
    have : xs.length ≥ 2 := by
      omega
    have : halves.fst.length < xs.length := by
      apply splitList_shorter_fst
      assumption
    have : halves.snd.length < xs.length := by
      apply splitList_shorter_snd
      assumption
    merge (mergeSort halves.fst) (mergeSort halves.snd)
termination_by xs.length
```

/-
The function can be tested on examples:
-/
该函数可以在示例上测试：
```anchor mergeSortRocks
#eval mergeSort ["soapstone", "geode", "mica", "limestone"]
```
```anchorInfo mergeSortRocks
["geode", "limestone", "mica", "soapstone"]
```
```anchor mergeSortNumbers
#eval mergeSort [5, 3, 22, 15]
```
```anchorInfo mergeSortNumbers
[3, 5, 15, 22]
```

/-- Division as Iterated Subtraction -/
# 作为迭代减法的除法
%%%
tag := "division-as-iterated-subtraction"
%%%

/-
Just as multiplication is iterated addition and exponentiation is iterated multiplication, division can be understood as iterated subtraction.
The {ref "recursive-functions"}[very first description of recursive functions in this book] presents a version of division that terminates when the divisor is not zero, but that Lean does not accept.
Proving that division terminates requires the use of a fact about inequalities.
-/
正如乘法是迭代加法，指数是迭代乘法一样，除法可以理解为迭代减法。
本书中 {ref "recursive-functions"}[对递归函数的最初描述] 提出了一个当除数不为零时停机的除法版本，但 Lean 不接受。
证明除法停机需要使用关于不等式的事实。

/-
Lean cannot prove that this definition of division terminates:
-/
Lean 无法证明这个除法定义会停机：
```anchor divTermination (module := Examples.ProgramsProofs.Div)
def div (n k : Nat) : Nat :=
  if n < k then
    0
  else
    1 + div (n - k) k
```

```anchorError divTermination (module := Examples.ProgramsProofs.Div)
fail to show termination for
  div
with errors
failed to infer structural recursion:
Cannot use parameter n:
  failed to eliminate recursive application
    div (n - k) k
Cannot use parameter k:
  failed to eliminate recursive application
    div (n - k) k


Could not find a decreasing measure.
The basic measures relate at each recursive call as follows:
(<, ≤, =: relation proved, ? all proofs failed, _: no proof attempted)
           n k
1) 30:8-21 ≤ =
Please use `termination_by` to specify a decreasing measure.
```

/-
That's a good thing, because it doesn't!
When {anchorName divTermination (module:=Examples.ProgramsProofs.Div)}`k` is {anchorTerm divTermination (module:=Examples.ProgramsProofs.Div)}`0`, value of {anchorName divTermination (module:=Examples.ProgramsProofs.Div)}`n` does not decrease, so the program is an infinite loop.
-/
这是一件好事，因为它确实不会停机！
当 {anchorName divTermination (module:=Examples.ProgramsProofs.Div)}`k` 是 {anchorTerm divTermination (module:=Examples.ProgramsProofs.Div)}`0` 时，{anchorName divTermination (module:=Examples.ProgramsProofs.Div)}`n` 的值不会减少，所以程序是一个无限循环。

:::paragraph
/-
Rewriting the function to take evidence that {anchorName divRecursiveWithProof (module:=Examples.ProgramsProofs.Div)}`k` is not {anchorTerm divRecursiveNeedsProof (module:=Examples.ProgramsProofs.Div)}`0` allows Lean to automatically prove termination:
-/
重写函数以接受 {anchorName divRecursiveWithProof (module:=Examples.ProgramsProofs.Div)}`k` 不是 {anchorTerm divRecursiveNeedsProof (module:=Examples.ProgramsProofs.Div)}`0` 的证据，允许 Lean 自动证明停机：

```anchor divRecursiveNeedsProof (module := Examples.ProgramsProofs.Div)
def div (n k : Nat) (ok : k ≠ 0) : Nat :=
  if h : n < k then
    0
  else
    1 + div (n - k) k ok
```
:::

/-
This definition of {anchorName divRecursiveWithProof (module:=Examples.ProgramsProofs.Div)}`div` terminates because the first argument {anchorName divRecursiveWithProof (module:=Examples.ProgramsProofs.Div)}`n` is smaller on each recursive call.
This can be expressed using a {kw}`termination_by` clause:
-/
这个 {anchorName divRecursiveWithProof (module:=Examples.ProgramsProofs.Div)}`div` 定义会停机，因为第一个参数 {anchorName divRecursiveWithProof (module:=Examples.ProgramsProofs.Div)}`n` 在每次递归调用时都更小。
这可以使用 {kw}`termination_by` 子句来表达：


```anchor divRecursiveWithProof (module := Examples.ProgramsProofs.Div)
def div (n k : Nat) (ok : k ≠ 0) : Nat :=
  if h : n < k then
    0
  else
    1 + div (n - k) k ok
termination_by n
```

/-
# Exercises

Prove the following theorems:

 * For all natural numbers $`n`, $`0 < n + 1`.
 * For all natural numbers $`n`, $`0 \\leq n`.
 * For all natural numbers $`n` and $`k`, $`(n + 1) - (k + 1) = n - k`
 * For all natural numbers $`n` and $`k`, if $`k < n` then $`n \neq 0`
 * For all natural numbers $`n`, $`n - n = 0`
 * For all natural numbers $`n` and $`k`, if $`n + 1 < k` then $`n < k`
-/
# 练习

证明以下定理：

 * 对于所有自然数 $`n`，$`0 < n + 1`。
 * 对于所有自然数 $`n`，$`0 \\leq n`。
 * 对于所有自然数 $`n` 和 $`k`，$`(n + 1) - (k + 1) = n - k`
 * 对于所有自然数 $`n` 和 $`k`，如果 $`k < n`，则 $`n \neq 0`
 * 对于所有自然数 $`n`，$`n - n = 0`
 * 对于所有自然数 $`n` 和 $`k`，如果 $`n + 1 < k`，则 $`n < k`
