import VersoManual
import FPLeanZh.Examples

open Verso.Genre Manual
open Verso.Code.External

open FPLeanZh

set_option verso.exampleProject "../examples"
set_option verso.exampleModule "Examples.ProgramsProofs.InsertionSort"

#doc (Manual) "插入排序与数组可变性" =>
%%%
file := "InsertionSort"
tag := "insertion-sort-mutation"
%%%
-- Insertion Sort and Array Mutation

-- While insertion sort does not have the optimal worst-case time complexity for a sorting algorithm, it still has a number of useful properties:
--  * It is simple and straightforward to implement and understand
--  * It is an in-place algorithm, requiring no additional space to run
--  * It is a stable sort
--  * It is fast when the input is already almost sorted

虽然插入排序的最差时间复杂度并不是最优，但它仍然有一些有用的属性：

 * 它简单明了，易于实现和理解
 * 它是一种原地排序算法，不需要额外的空间来运行
 * 它是一种稳定排序
 * 当输入已经排序得差不多时，它很快

-- In-place algorithms are particularly useful in Lean due to the way it manages memory.
-- In some cases, operations that would normally copy an array can be optimized into mutation.
-- This includes swapping elements in an array.

原地算法在 Lean 中特别有用，因为它管理内存的方式。
在某些情况下，会复制数组的操作通常可以优化为直接修改。这包括交换数组中的元素。

-- Most languages and run-time systems with automatic memory management, including JavaScript, the JVM, and .NET, use tracing garbage collection.
-- When memory needs to be reclaimed, the system starts at a number of _roots_ (such as the call stack and global values) and then determines which values can be reached by recursively chasing pointers.
-- Any values that can't be reached are deallocated, freeing memory.

大多数语言和具有自动内存管理的运行时系统，包括 JavaScript、JVM 和 .NET，都使用跟踪垃圾回收。
当需要回收内存时，系统从许多 _根_（例如调用栈和全局值）开始，
然后通过递归地追踪指针来确定可以到达哪些值。任何无法到达的值都会被释放，从而释放内存。

-- Reference counting is an alternative to tracing garbage collection that is used by a number of languages, including Python, Swift, and Lean.
-- In a system with reference counting, each object in memory has a field that tracks how many references there are to it.
-- When a new reference is established, the counter is incremented.
-- When a reference ceases to exist, the counter is decremented.
-- When the counter reaches zero, the object is immediately deallocated.

引用计数是追踪式垃圾回收的替代方法，它被许多语言使用，包括 Python、Swift 和 Lean。
在引用计数系统中，内存中的每个对象都有一个字段来跟踪对它的引用数。
当建立一个新引用时，计数器会增加。当一个引用不再存在时，计数器会减少。
当计数器达到零时，对象会立即被释放。

-- Reference counting has one major disadvantage compared to a tracing garbage collector: circular references can lead to memory leaks.
-- If object $`A` references object $`B` , and object $`B` references object $`A`, they will never be deallocated, even if nothing else in the program references either $`A` or $`B`.
-- Circular references result either from uncontrolled recursion or from mutable references.
-- Because Lean supports neither, it is impossible to construct circular references.

与追踪式垃圾回收器相比，引用计数有一个主要的缺点：循环引用会导致内存泄漏。
如果对象 $`A` 引用对象 $`B`，而对象 $`B` 引用对象 $`A`，
它们将永远不会被释放，即使程序中没有其他内容引用 $`A` 或 $`B`。
循环引用要么是由不受控制的递归引起的，要么是由可变引用引起的。由于 Lean 不支持这两者，
因此不可能构造循环引用。

-- Reference counting means that the Lean runtime system's primitives for allocating and deallocating data structures can check whether a reference count is about to fall to zero, and re-use an existing object instead of allocating a new one.
-- This is particularly important when working with large arrays.

引用计数意味着 Lean 运行时系统用于分配和释放数据结构的原语可以检查引用计数是否即将降至零，
并重新使用现有对象而非分配一个新对象。当使用大型数组时，这一点尤其重要。


-- An implementation of insertion sort for Lean arrays should satisfy the following criteria:
--  1. Lean should accept the function without a {kw}`partial` annotation
--  2. If passed an array to which there are no other references, it should modify the array in-place rather than allocating a new one

针对 Lean 数组的插入排序的实现应满足以下条件：

 1. Lean 应当接受没有 {kw}`partial` 标注的函数
 2. 若传递了一个没有其他引用的数组，它应原地修改数组，而非分配一个新数组

-- The first criterion is easy to check: if Lean accepts the definition, then it is satisfied.
-- The second, however, requires a means of testing it.
-- Lean provides a built-in function called {anchorName dbgTraceIfSharedSig}`dbgTraceIfShared` with the following signature:

第一个条件很容易检查：如果 Lean 接受该定义，则满足该条件。
然而，第二个条件需要一种测试方法。Lean 提供了一个名为 {anchorName dbgTraceIfSharedSig}`dbgTraceIfShared` 的内置函数，其签名如下：

```anchor dbgTraceIfSharedSig
#check dbgTraceIfShared
```
```anchorInfo dbgTraceIfSharedSig
dbgTraceIfShared.{u} {α : Type u} (s : String) (a : α) : α
```
-- It takes a string and a value as arguments, and prints a message that uses the string to standard error if the value has more than one reference, returning the value.
-- This is not, strictly speaking, a pure function.
-- However, it is intended to be used only during development to check that a function is in fact able to re-use memory rather than allocating and copying.

它接受一个字符串和一个值作为参数，如果该值有多个引用，则使用该字符串将消息打印到标准错误，并返回值。
严格来说，这不是一个纯函数。
但是，它旨在仅在开发期间使用，以检查函数实际上是否能够重用内存而不是分配和复制。

-- When learning to use {anchorName dbgTraceIfSharedSig}`dbgTraceIfShared`, it's important to know that {kw}`#eval` will report that many more values are shared than in compiled code.
-- This can be confusing.
-- It's important to build an executable with {lit}`lake` rather than experimenting in an editor.

学习使用 {anchorName dbgTraceIfSharedSig}`dbgTraceIfShared` 时，重要的是要知道 {kw}`#eval` 报告的共享值比编译代码中多得多。
这可能会令人困惑。
重要的是使用 {lit}`lake` 构建可执行文件，而不是在编辑器中进行实验。

-- Insertion sort consists of two loops.
-- The outer loop moves a pointer from left to right across the array to be sorted.
-- After each iteration, the region of the array to the left of the pointer is sorted, while the region to the right may not yet be sorted.
-- The inner loop takes the element pointed to by the pointer and moves it to the left until the appropriate location has been found and the loop invariant has been restored.
-- In other words, each iteration inserts the next element of the array into the appropriate location in the sorted region.

插入排序由两个循环组成。
外部循环将指针从左向右移动穿过要排序的数组。
每次迭代后，指针左侧的数组区域已排序，而右侧的区域可能尚未排序。
内部循环获取指针指向的元素并将其向左移动，直到找到合适的位置并恢复循环不变量。
换句话说，每次迭代都将数组的下一个元素插入到已排序区域中的适当位置。

-- # The Inner Loop
# 内部循环
%%%
tag := "inner-insertion-sort-loop"
%%%

-- The inner loop of insertion sort can be implemented as a tail-recursive function that takes the array and the index of the element being inserted as arguments.
-- The element being inserted is repeatedly swapped with the element to its left until either the element to the left is smaller or the beginning of the array is reached.
-- The inner loop is structurally recursive on the {anchorName insertionSortLoop}`Nat` that is inside the {anchorName insertSorted}`Fin` used to index into the array:

插入排序的内部循环可以实现为一个尾递归函数，它接受数组和正在插入的元素的索引作为参数。
正在插入的元素会反复与其左侧的元素交换，直到左侧的元素更小或到达数组的开头。
内部循环在用于索引数组的 {anchorName insertSorted}`Fin` 内部的 {anchorName insertionSortLoop}`Nat` 上是结构递归的：

```anchor insertSorted
def insertSorted [Ord α] (arr : Array α) (i : Fin arr.size) : Array α :=
  match i with
  | ⟨0, _⟩ => arr
  | ⟨i' + 1, _⟩ =>
    have : i' < arr.size := by
      grind
    match Ord.compare arr[i'] arr[i] with
    | .lt | .eq => arr
    | .gt =>
      insertSorted (arr.swap i' i) ⟨i', by simp [*]⟩
```
-- If the index {anchorName insertSorted}`i` is {anchorTerm insertSorted}`0`, then the element being inserted into the sorted region has reached the beginning of the region and is the smallest.
-- If the index is {anchorTerm insertSorted}`i' + 1`, then the element at {anchorName insertSorted}`i'` should be compared to the element at {anchorName insertSorted}`i`.
-- Note that while {anchorName insertSorted}`i` is a {anchorTerm insertSorted}`Fin arr.size`, {anchorName insertSorted}`i'` is just a {anchorName insertionSortLoop}`Nat` because it results from the {anchorName names}`val` field of {anchorName insertSorted}`i`.
-- Nonetheless, the proof automation used for checking array index notation includes a solver for linear integer arithmetic, so {anchorName insertSorted}`i'` is automatically usable as an index.

如果索引 {anchorName insertSorted}`i` 为 {anchorTerm insertSorted}`0`，则插入到已排序区域的元素已到达区域的开头，并且是最小的。
如果索引为 {anchorTerm insertSorted}`i' + 1`，则应将 {anchorName insertSorted}`i'` 处的元素与 {anchorName insertSorted}`i` 处的元素进行比较。
请注意，虽然 {anchorName insertSorted}`i` 是 {anchorTerm insertSorted}`Fin arr.size`，但 {anchorName insertSorted}`i'` 只是一个 {anchorName insertionSortLoop}`Nat`，因为它来自 {anchorName insertSorted}`i` 的 {anchorName names}`val` 字段。
尽管如此，用于检查数组索引符号的证明自动化包括线性整数算术求解器，因此 {anchorName insertSorted}`i'` 自动可用作索引。

-- The two elements are looked up and compared.
-- If the element to the left is less than or equal to the element being inserted, then the loop is finished and the invariant has been restored.
-- If the element to the left is greater than the element being inserted, then the elements are swapped and the inner loop begins again.
-- {anchorName names}`Array.swap` takes both of its indices as {anchorName names}`Nat`s, using the same tactics as array indexing behind the scenes to ensure that they are in bounds.

查找并比较这两个元素。
如果左侧的元素小于或等于正在插入的元素，则循环结束，不变量已恢复。
如果左侧的元素大于正在插入的元素，则交换元素，内部循环重新开始。
{anchorName names}`Array.swap` 将其两个索引都作为 {anchorName names}`Nat`，在幕后使用与数组索引相同的策略来确保它们在范围内。

-- Nonetheless, the {anchorName names}`Fin` used for the recursive call needs a proof that {anchorName insertSorted}`i'` is in bounds for the result of swapping two elements.
-- The {anchorTerm insertSorted}`simp` tactic's database contains the fact that swapping two elements of an array doesn't change its size, and the {anchorTerm insertSorted}`[*]` argument instructs it to additionally use the assumption introduced by {kw}`have`.
-- Omitting the {kw}`have`-expression with the proof that {anchorTerm insertSorted}`i' < arr.size` reveals the following goal:

尽管如此，用于递归调用的 {anchorName names}`Fin` 需要证明 {anchorName insertSorted}`i'` 在交换两个元素的结果范围内。
{anchorTerm insertSorted}`simp` 策略的数据库包含交换数组的两个元素不会改变其大小的事实，并且 {anchorTerm insertSorted}`[*]` 参数指示它另外使用由 {kw}`have` 引入的假设。
省略带有 {anchorTerm insertSorted}`i' < arr.size` 证明的 {kw}`have` 表达式会显示以下目标：

```anchorError insertSortedNoProof
unsolved goals
α : Type ?u.7
inst✝ : Ord α
arr : Array α
i : Fin arr.size
i' : Nat
isLt✝ : i' + 1 < arr.size
⊢ i' < arr.size
```



-- # The Outer Loop
# 外部循环
%%%
tag := "outer-insertion-sort-loop"
%%%

-- The outer loop of insertion sort moves the pointer from left to right, invoking {anchorName insertionSortLoop}`insertSorted` at each iteration to insert the element at the pointer into the correct position in the array.
-- The basic form of the loop resembles the implementation of {anchorTerm etc}`Array.map`:

插入排序的外部循环将指针从左向右移动，在每次迭代时调用 {anchorName insertionSortLoop}`insertSorted`，将指针处的元素插入到数组中的正确位置。
循环的基本形式类似于 {anchorTerm etc}`Array.map` 的实现：

```anchor insertionSortLoopTermination
def insertionSortLoop [Ord α] (arr : Array α) (i : Nat) : Array α :=
  if h : i < arr.size then
    insertionSortLoop (insertSorted arr ⟨i, h⟩) (i + 1)
  else
    arr
```
-- An error occurs because there is no argument that decreases at every recursive call:

发生错误是因为没有在每次递归调用时减少的参数：

```anchorError insertionSortLoopTermination
fail to show termination for
  insertionSortLoop
with errors
failed to infer structural recursion:
Not considering parameter α of insertionSortLoop:
  it is unchanged in the recursive calls
Not considering parameter #2 of insertionSortLoop:
  it is unchanged in the recursive calls
Cannot use parameter arr:
  the type Array α does not have a `.brecOn` recursor
Cannot use parameter i:
  failed to eliminate recursive application
    insertionSortLoop (insertSorted arr ⟨i, h⟩) (i + 1)


Could not find a decreasing measure.
The basic measures relate at each recursive call as follows:
(<, ≤, =: relation proved, ? all proofs failed, _: no proof attempted)
            arr i #1
1) 569:4-55   ? ?  ?

#1: arr.size - i

Please use `termination_by` to specify a decreasing measure.
```
-- While Lean can prove that a {anchorName insertionSortLoop}`Nat` that increases towards a constant bound at each iteration leads to a terminating function, this function has no constant bound because the array is replaced with the result of calling {anchorName insertionSortLoop}`insertSorted` at each iteration.

虽然 Lean 可以证明在每次迭代中向常数界限增加的 {anchorName insertionSortLoop}`Nat` 会导致函数终止，但此函数没有常数界限，因为数组在每次迭代中都被替换为调用 {anchorName insertionSortLoop}`insertSorted` 的结果。

-- Before constructing the termination proof, it can be convenient to test the definition with a {kw}`partial` modifier to make sure that it returns the expected answers:

在构造终止证明之前，使用 {kw}`partial` 修饰符测试定义以确保它返回预期的答案可能会很方便：

```anchor partialInsertionSortLoop
partial def insertionSortLoop [Ord α] (arr : Array α) (i : Nat) : Array α :=
  if h : i < arr.size then
    insertionSortLoop (insertSorted arr ⟨i, h⟩) (i + 1)
  else
    arr
```
```anchor insertionSortPartialOne
#eval insertionSortLoop #[5, 17, 3, 8] 0
```
```anchorInfo insertionSortPartialOne
#[3, 5, 8, 17]
```
```anchor insertionSortPartialTwo
#eval insertionSortLoop #["metamorphic", "igneous", "sedimentary"] 0
```
```anchorInfo insertionSortPartialTwo
#["igneous", "metamorphic", "sedimentary"]
```

-- ## Termination
## 停机性
%%%
tag := "insertionSortLoop-termination"
%%%

-- Once again, the function terminates because the difference between the index and the size of the array being processed decreases on each recursive call.
-- This time, however, Lean does not accept the {kw}`termination_by`:

同样，该函数会停机是因为正在处理的索引和数组大小之差在每次递归调用时都会减小。
然而，这一次，Lean 不接受 {kw}`termination_by`：

```anchor insertionSortLoopProof1
def insertionSortLoop [Ord α] (arr : Array α) (i : Nat) : Array α :=
  if h : i < arr.size then
    insertionSortLoop (insertSorted arr ⟨i, h⟩) (i + 1)
  else
    arr
termination_by arr.size - i
```
```anchorError insertionSortLoopProof1
failed to prove termination, possible solutions:
  - Use `have`-expressions to prove the remaining goals
  - Use `termination_by` to specify a different well-founded relation
  - Use `decreasing_by` to specify your own tactic for discharging this kind of goal
α : Type u_1
inst✝ : Ord α
arr : Array α
i : Nat
h : i < arr.size
⊢ (insertSorted arr ⟨i, h⟩).size - (i + 1) < arr.size - i
```
-- The problem is that Lean has no way to know that {anchorName insertionSortLoop}`insertSorted` returns an array that's the same size as the one it is passed.
-- In order to prove that {anchorName insertionSortLoop}`insertionSortLoop` terminates, it is necessary to first prove that {anchorName insertionSortLoop}`insertSorted` doesn't change the size of the array.
-- Copying the unproved termination condition from the error message to the function and “proving” it with {anchorTerm insertionSortLoopSorry}`sorry` allows the function to be temporarily accepted:

问题在于 Lean 无法知道 {anchorName insertionSortLoop}`insertSorted` 返回的数组与传递给它的数组大小相同。
为了证明 {anchorName insertionSortLoop}`insertionSortLoop` 会停机，首先有必要证明 {anchorName insertionSortLoop}`insertSorted` 不会改变数组的大小。
将未经证明的停机条件从错误消息复制到函数中，并使用 {anchorTerm insertionSortLoopSorry}`sorry`「证明」它，可以暂时接受该函数：

```anchor insertionSortLoopSorry
def insertionSortLoop [Ord α] (arr : Array α) (i : Nat) : Array α :=
  if h : i < arr.size then
    have : (insertSorted arr ⟨i, h⟩).size - (i + 1) < arr.size - i := by
      sorry
    insertionSortLoop (insertSorted arr ⟨i, h⟩) (i + 1)
  else
    arr
termination_by arr.size - i
```
```anchorWarning insertionSortLoopSorry
declaration uses 'sorry'
```

-- Because {anchorName insertionSortLoop}`insertSorted` is structurally recursive on the index of the element being inserted, the proof should be by induction on the index.
-- In the base case, the array is returned unchanged, so its length certainly does not change.
-- For the inductive step, the induction hypothesis is that a recursive call on the next smaller index will not change the length of the array.
-- There are two cases two consider: either the element has been fully inserted into the sorted region and the array is returned unchanged, in which case the length is also unchanged, or the element is swapped with the next one before the recursive call.
-- However, swapping two elements in an array doesn't change the size of it, and the induction hypothesis states that the recursive call with the next index returns an array that's the same size as its argument.
-- Thus, the size remains unchanged.

由于 {anchorName insertionSortLoop}`insertSorted` 在要插入的元素的索引上是结构化递归的，所以应该通过索引归纳进行证明。
在基本情况下，数组返回不变，因此其长度肯定不会改变。对于归纳步骤，
归纳假设是在下一个更小的索引上的递归调用不会改变数组的长度。
这里有两种情况需要考虑：要么元素已完全插入到已排序区域中，并且数组返回不变，
在这种情况下长度也不会改变，要么元素在递归调用之前与下一个元素交换。
然而，在数组中交换两个元素不会改变它的大小，
并且归纳假设指出以下一个索引的递归调用返回的数组与其参数大小相同。因此，大小仍然保持不变。

-- Translating this English-language theorem statement to Lean and proceeding using the techniques from this chapter is enough to prove the base case and make progress in the inductive step:

将自然语言的定理陈述翻译为 Lean，并使用本章中的技术进行操作，足以证明基本情况并在归纳步骤中取得进展：

```anchor insert_sorted_size_eq_0
theorem insert_sorted_size_eq [Ord α] (arr : Array α) (i : Fin arr.size) :
    (insertSorted arr i).size = arr.size := by
  match i with
  | ⟨j, isLt⟩ =>
    induction j with
    | zero => simp [insertSorted]
    | succ j' ih =>
      simp [insertSorted]
```
-- The simplification using {anchorName insert_sorted_size_eq_0}`insertSorted` in the inductive step revealed the pattern match in {anchorName insert_sorted_size_eq_0}`insertSorted`:

在归纳步骤中使用 {anchorName insert_sorted_size_eq_0}`insertSorted` 的简化揭示了 {anchorName insert_sorted_size_eq_0}`insertSorted` 中的模式匹配：

```anchorError insert_sorted_size_eq_0
unsolved goals
case succ
α : Type u_1
inst✝ : Ord α
arr : Array α
i : Fin arr.size
j' : Nat
ih : ∀ (isLt : j' < arr.size), (insertSorted arr ⟨j', isLt⟩).size = arr.size
isLt : j' + 1 < arr.size
⊢ (match compare arr[j'] arr[j' + 1] with
    | Ordering.lt => arr
    | Ordering.eq => arr
    | Ordering.gt => insertSorted (arr.swap j' (j' + 1) ⋯ ⋯) ⟨j', ⋯⟩).size =
  arr.size
```
-- When faced with a goal that includes {kw}`if` or {kw}`match`, the {anchorTerm insert_sorted_size_eq_1}`split` tactic (not to be confused with the {anchorName splitList (module := Examples.ProgramsProofs.Inequalities)}`splitList` function used in the definition of merge sort) replaces the goal with one new goal for each path of control flow:

当面对包含 {kw}`if` 或 {kw}`match` 的目标时，{anchorTerm insert_sorted_size_eq_1}`split` 策略（不要与归并排序定义中使用的 {anchorName splitList (module := Examples.ProgramsProofs.Inequalities)}`splitList` 函数混淆）
会用一个新目标替换原目标，用于控制流的每条路径：

```anchor insert_sorted_size_eq_1
theorem insert_sorted_size_eq [Ord α] (arr : Array α) (i : Fin arr.size) :
    (insertSorted arr i).size = arr.size := by
  match i with
  | ⟨j, isLt⟩ =>
    induction j with
    | zero => simp [insertSorted]
    | succ j' ih =>
      simp [insertSorted]
      split
```
-- Because it typically doesn't matter _how_ a statement was proved, but only _that_ it was proved, proofs in Lean's output are typically replaced by {lit}`⋯`.
-- Additionally, each new goal has an assumption that indicates which branch led to that goal, named {lit}`heq✝` in this case:

因为通常一个陈述 _如何_ 被证明并不重要，重要的是它 _被_ 证明了，所以 Lean 输出中的证明通常被替换为 {lit}`⋯`。
此外，每个新目标都有一个假设，表明哪个分支导致了该目标，在本例中命名为 {lit}`heq✝`：

```anchorError insert_sorted_size_eq_1
unsolved goals
case h_1
α : Type u_1
inst✝ : Ord α
arr : Array α
i : Fin arr.size
j' : Nat
ih : ∀ (isLt : j' < arr.size), (insertSorted arr ⟨j', isLt⟩).size = arr.size
isLt : j' + 1 < arr.size
x✝ : Ordering
heq✝ : compare arr[j'] arr[j' + 1] = Ordering.lt
⊢ arr.size = arr.size

case h_2
α : Type u_1
inst✝ : Ord α
arr : Array α
i : Fin arr.size
j' : Nat
ih : ∀ (isLt : j' < arr.size), (insertSorted arr ⟨j', isLt⟩).size = arr.size
isLt : j' + 1 < arr.size
x✝ : Ordering
heq✝ : compare arr[j'] arr[j' + 1] = Ordering.eq
⊢ arr.size = arr.size

case h_3
α : Type u_1
inst✝ : Ord α
arr : Array α
i : Fin arr.size
j' : Nat
ih : ∀ (isLt : j' < arr.size), (insertSorted arr ⟨j', isLt⟩).size = arr.size
isLt : j' + 1 < arr.size
x✝ : Ordering
heq✝ : compare arr[j'] arr[j' + 1] = Ordering.gt
⊢ (insertSorted (arr.swap j' (j' + 1) ⋯ ⋯) ⟨j', ⋯⟩).size = arr.size
```
-- Rather than write proofs for both simple cases, adding {anchorTerm insert_sorted_size_eq_2}`<;> try rfl` after {anchorTerm insert_sorted_size_eq_2}`split` causes the two straightforward cases to disappear immediately, leaving only a single goal:

与其为这两个简单情况编写证明，不如在 {anchorTerm insert_sorted_size_eq_2}`split` 后添加 {anchorTerm insert_sorted_size_eq_2}`<;> try rfl`，
这样这两个直接的情况会立即消失，只留下一个目标：

```anchor insert_sorted_size_eq_2
theorem insert_sorted_size_eq [Ord α] (arr : Array α) (i : Fin arr.size) :
    (insertSorted arr i).size = arr.size := by
  match i with
  | ⟨j, isLt⟩ =>
    induction j with
    | zero => simp [insertSorted]
    | succ j' ih =>
      simp [insertSorted]
      split <;> try rfl
```
```anchorError insert_sorted_size_eq_2
unsolved goals
case h_3
α : Type u_1
inst✝ : Ord α
arr : Array α
i : Fin arr.size
j' : Nat
ih : ∀ (isLt : j' < arr.size), (insertSorted arr ⟨j', isLt⟩).size = arr.size
isLt : j' + 1 < arr.size
x✝ : Ordering
heq✝ : compare arr[j'] arr[j' + 1] = Ordering.gt
⊢ (insertSorted (arr.swap j' (j' + 1) ⋯ ⋯) ⟨j', ⋯⟩).size = arr.size
```

-- Unfortunately, the induction hypothesis is not strong enough to prove this goal.
-- The induction hypothesis states that calling {anchorName insert_sorted_size_eq_3}`insertSorted` on {anchorName insert_sorted_size_eq_3}`arr` leaves the size unchanged, but the proof goal is to show that the result of the recursive call with the result of swapping leaves the size unchanged.
-- Successfully completing the proof requires an induction hypothesis that works for _any_ array that is passed to {anchorName insert_sorted_size_eq_3}`insertSorted` together with the smaller index as an argument

不幸的是，归纳假设不足以证明这个目标。归纳假设指出对 {anchorName insert_sorted_size_eq_3}`arr` 调用 {anchorName insert_sorted_size_eq_3}`insertSorted` 不会改变大小，
但证明目标是要证明用交换的结果来进行递归调用的结果不会改变大小。成功完成证明需要一个归纳假设，
该假设适用于传递给 {anchorName insert_sorted_size_eq_3}`insertSorted` 的任何数组，以及作为参数的更小的索引。

-- It is possible to get a strong induction hypothesis by using the {anchorTerm insert_sorted_size_eq_3}`generalizing` option to the {anchorTerm insert_sorted_size_eq_3}`induction` tactic.
-- This option brings additional assumptions from the context into the statement that's used to generate the base case, the induction hypothesis, and the goal to be shown in the inductive step.
-- Generalizing over {anchorName insert_sorted_size_eq_3}`arr` leads to a stronger hypothesis:

可以使用 {anchorTerm insert_sorted_size_eq_3}`induction` 策略的 {anchorTerm insert_sorted_size_eq_3}`generalizing` 选项来获得强归纳假设。
此选项会将语境中的附加假设引入到一个语句中，该语句用于生成基本情况、归纳假设和在归纳步骤中显示的目标。
对 {anchorName insert_sorted_size_eq_3}`arr` 进行推广会产生更强的假设：

```anchor insert_sorted_size_eq_3
theorem insert_sorted_size_eq [Ord α] (arr : Array α) (i : Fin arr.size) :
    (insertSorted arr i).size = arr.size := by
  match i with
  | ⟨j, isLt⟩ =>
    induction j generalizing arr with
    | zero => simp [insertSorted]
    | succ j' ih =>
      simp [insertSorted]
      split <;> try rfl
```
-- In the resulting goal, {anchorName insert_sorted_size_eq_3}`arr` is now part of a “for all” statement in the inductive hypothesis:

在生成的证明目标中，{anchorName insert_sorted_size_eq_3}`arr` 现在是归纳假设中「对于所有」语句的一部分：

```anchorError insert_sorted_size_eq_3
unsolved goals
case h_3
α : Type u_1
inst✝ : Ord α
j' : Nat
ih : ∀ (arr : Array α) (i : Fin arr.size) (isLt : j' < arr.size), (insertSorted arr ⟨j', isLt⟩).size = arr.size
arr : Array α
i : Fin arr.size
isLt : j' + 1 < arr.size
x✝ : Ordering
heq✝ : compare arr[j'] arr[j' + 1] = Ordering.gt
⊢ (insertSorted (arr.swap j' (j' + 1) ⋯ ⋯) ⟨j', ⋯⟩).size = arr.size
```

-- However, this whole proof is beginning to get unmanageable.
-- The next step would be to introduce a variable standing for the length of the result of swapping, show that it is equal to {anchorTerm insert_sorted_size_eq_3}`arr.size`, and then show that this variable is also equal to the length of the array that results from the recursive call.
-- These equality statements can then be chained together to prove the goal.
-- It's much easier, however, to use functional induction:

然而，整个证明开始变得难以控制。
下一步是引入一个变量表示交换结果的长度，证明它等于 {anchorTerm insert_sorted_size_eq_3}`arr.size`，然后证明这个变量也等于递归调用产生的数组的长度。
之后可以将这些相等语句链接在一起来证明目标。
然而，使用函数归纳法要容易得多：

```anchor insert_sorted_size_eq_funInd1
theorem insert_sorted_size_eq [Ord α]
    (arr : Array α) (i : Fin arr.size) :
    (insertSorted arr i).size = arr.size := by
  fun_induction insertSorted with
  | case1 arr isLt => skip
  | case2 arr i isLt this isLt => skip
  | case3 arr i isLt this isEq => skip
  | case4 arr i isLt this isGt ih => skip
```
-- The first goal is the case for index {anchorTerm insertSorted}`0`.
-- Here, the array is not modified, so proving that its size is unmodified will not require any complicated steps:

第一个目标是索引 {anchorTerm insertSorted}`0` 的情况。
在这里，数组没有被修改，因此证明其大小未被修改不需要任何复杂的步骤：

```anchorError insert_sorted_size_eq_funInd1
unsolved goals
case case1
α : Type u_1
inst✝ : Ord α
arr✝ arr : Array α
isLt : 0 < arr.size
⊢ arr.size = arr.size
```
-- The next two goals are the same, and cover the {anchorName insertSorted}`.lt` and {anchorName insertSorted}`.eq` cases for the element comparison.
-- The local assumptions {anchorName insert_sorted_size_eq_funInd1}`isLt` and {anchorName insert_sorted_size_eq_funInd1}`isEq` will allow the correct branch of the {anchorTerm insertSorted}`match` to be selected:

接下来的两个目标是相同的，涵盖了元素比较的 {anchorName insertSorted}`.lt` 和 {anchorName insertSorted}`.eq` 情况。
局部假设 {anchorName insert_sorted_size_eq_funInd1}`isLt` 和 {anchorName insert_sorted_size_eq_funInd1}`isEq` 将允许选择 {anchorTerm insertSorted}`match` 的正确分支：

```anchorError insert_sorted_size_eq_funInd1
unsolved goals
case case2
α : Type u_1
inst✝ : Ord α
arr✝ arr : Array α
i : Nat
isLt✝ : i + 1 < arr.size
this : i < arr.size
isLt : compare arr[i] arr[⟨i.succ, isLt✝⟩] = Ordering.lt
⊢ (match compare arr[i] arr[⟨i.succ, isLt✝⟩] with
    | Ordering.lt => arr
    | Ordering.eq => arr
    | Ordering.gt => insertSorted (arr.swap i (↑⟨i.succ, isLt✝⟩) this ⋯) ⟨i, ⋯⟩).size =
  arr.size
```
```anchorError insert_sorted_size_eq_funInd1
unsolved goals
case case3
α : Type u_1
inst✝ : Ord α
arr✝ arr : Array α
i : Nat
isLt : i + 1 < arr.size
this : i < arr.size
isEq : compare arr[i] arr[⟨i.succ, isLt⟩] = Ordering.eq
⊢ (match compare arr[i] arr[⟨i.succ, isLt⟩] with
    | Ordering.lt => arr
    | Ordering.eq => arr
    | Ordering.gt => insertSorted (arr.swap i (↑⟨i.succ, isLt⟩) this ⋯) ⟨i, ⋯⟩).size =
  arr.size
```
-- In the final case, once the {anchorTerm insertSorted}`match` is reduced, there will be some work left to do to prove that the next step of the insertion preserves the size of the array.
-- In particular, the induction hypothesis states that the size of the next step is equal to the size of the result of the swap, but the desired conclusion is that it's equal to the size of the original array:

在最后一种情况下，一旦 {anchorTerm insertSorted}`match` 被归约，还需要做一些工作来证明插入的下一步保留了数组的大小。
特别是，归纳假设指出下一步的大小等于交换结果的大小，但期望的结论是它等于原始数组的大小：

```anchorError insert_sorted_size_eq_funInd1
unsolved goals
case case4
α : Type u_1
inst✝ : Ord α
arr✝ arr : Array α
i : Nat
isLt : i + 1 < arr.size
this : i < arr.size
isGt : compare arr[i] arr[⟨i.succ, isLt⟩] = Ordering.gt
ih : (insertSorted (arr.swap i (↑⟨i.succ, isLt⟩) this ⋯) ⟨i, ⋯⟩).size = (arr.swap i (↑⟨i.succ, isLt⟩) this ⋯).size
⊢ (match compare arr[i] arr[⟨i.succ, isLt⟩] with
    | Ordering.lt => arr
    | Ordering.eq => arr
    | Ordering.gt => insertSorted (arr.swap i (↑⟨i.succ, isLt⟩) this ⋯) ⟨i, ⋯⟩).size =
  arr.size
```

-- The Lean library includes the theorem {anchorName insert_sorted_size_eq_funInd}`Array.size_swap`, which states that swapping two elements of an array doesn't change its size.
-- By default, {tactic}`grind` doesn't use this fact, but once instructed to do so, it can take care of all four cases:

Lean 库包含定理 {anchorName insert_sorted_size_eq_funInd}`Array.size_swap`，它指出交换数组的两个元素不会改变其大小。
默认情况下，{tactic}`grind` 不使用这个事实，但是一旦指示它这样做，它就可以处理所有四种情况：

```anchor insert_sorted_size_eq_funInd
theorem insert_sorted_size_eq [Ord α]
    (arr : Array α) (i : Fin arr.size) :
    (insertSorted arr i).size = arr.size := by
  fun_induction insertSorted <;> grind [Array.size_swap]
```

-- This proof can now be used to replace the {anchorTerm insertionSortLoopSorry}`sorry` in {anchorName insertionSortLoopSorry}`insertionSortLoop`.
-- In particular, this theorem allows {anchorTerm insertionSortLoop}`grind` to succeed:

这个证明现在可以用来替换 {anchorName insertionSortLoopSorry}`insertionSortLoop` 中的 {anchorTerm insertionSortLoopSorry}`sorry`。
特别是，这个定理允许 {anchorTerm insertionSortLoop}`grind` 成功：

```anchor insertionSortLoop
def insertionSortLoop [Ord α] (arr : Array α) (i : Nat) : Array α :=
  if h : i < arr.size then
    have : (insertSorted arr ⟨i, h⟩).size - (i + 1) < arr.size - i := by
      grind [insert_sorted_size_eq]
    insertionSortLoop (insertSorted arr ⟨i, h⟩) (i + 1)
  else
    arr
termination_by arr.size - i
```


-- # The Driver Function
# 驱动函数
%%%
tag := "insertion-sort-driver-function"
%%%

-- Insertion sort itself calls {anchorName insertionSort}`insertionSortLoop`, initializing the index that demarcates the sorted region of the array from the unsorted region to {anchorTerm insertionSort}`0`:

插入排序本身会调用 {anchorName insertionSort}`insertionSortLoop`，以将数组中已排序区域与未排序区域的分界索引初始化为 {anchorTerm insertionSort}`0`：

```anchor insertionSort
def insertionSort [Ord α] (arr : Array α) : Array α :=
   insertionSortLoop arr 0
```

-- A few quick tests show the function is at least not blatantly wrong:

一些快速测试表明该函数至少不是明显错误的：

```anchor insertionSortNums
#eval insertionSort #[3, 1, 7, 4]
```
```anchorInfo insertionSortNums
#[1, 3, 4, 7]
```
```anchor insertionSortStrings
#eval insertionSort #[ "quartz", "marble", "granite", "hematite"]
```
```anchorInfo insertionSortStrings
#["granite", "hematite", "marble", "quartz"]
```

-- # Is This Really Insertion Sort?
# 它真的是插入排序吗？
%%%
tag := "insertion-sort-in-place"
%%%


-- Insertion sort is _defined_ to be an in-place sorting algorithm.
-- What makes it useful, despite its quadratic worst-case run time, is that it is a stable sorting algorithm that doesn't allocate extra space and that handles almost-sorted data efficiently.
-- If each iteration of the inner loop allocated a new array, then the algorithm wouldn't _really_ be insertion sort.

插入排序被 _定义_ 为原地排序算法。尽管它具有二次最差运行时间，但它仍然有用，
因为它是一种稳定的排序算法，不会分配额外的空间，并且可以有效处理几乎已排序的数据。
如果内层循环的每次迭代都分配一个新数组，那么该算法就不会 _真正_ 成为插入排序。

-- Lean's array operations, such as {anchorName names}`Array.set` and {anchorName names}`Array.swap`, check whether the array in question has a reference count that is greater than one.
-- If so, then the array is visible to multiple parts of the code, which means that it must be copied.
-- Otherwise, Lean would no longer be a pure functional language.
-- However, when the reference count is exactly one, there are no other potential observers of the value.
-- In these cases, the array primitives mutate the array in place.
-- What other parts of the program don't know can't hurt them.

Lean 的数组操作（例如 {anchorName names}`Array.set` 和 {anchorName names}`Array.swap`）会检查所讨论的数组的引用计数是否大于 1。
如果是，则该数组对代码的多个部分可见，这意味着它必须被复制。
否则，Lean 将不再是一种纯函数式语言。但是，当引用计数恰好为 1 时，没有其他潜在的值观察者。
在这种情况下，数组原语会就地改变数组。程序其他不知道的部分不会对它造成破坏。

-- Lean's proof logic works at the level of pure functional programs, not the underlying implementation.
-- This means that the best way to discover whether a program unnecessarily copies data is to test it.
-- Adding calls to {anchorName dbgTraceIfSharedSig}`dbgTraceIfShared` at each point where mutation is desired causes the provided message to be printed to {lit}`stderr` when the value in question has more than one reference.

Lean 的证明逻辑在纯函数式程序的级别上，而非在底层实现上工作。
这意味着发现程序是否不必要地复制了数据的最好方法是测试它。
在需要改变的每个点添加对 {anchorName dbgTraceIfSharedSig}`dbgTraceIfShared` 的调用，当所讨论的值有多个引用时，
它会将提供的消息打印到 {lit}`stderr`。

-- Insertion sort has precisely one place that is at risk of copying rather than mutating: the call to {anchorName names}`Array.swap`.
-- Replacing {anchorTerm insertSorted}`arr.swap i' i` with {anchorTerm InstrumentedInsertionSort (module := Examples.ProgramsProofs.InstrumentedInsertionSort)}`(dbgTraceIfShared "array to swap" arr).swap i' i` causes the program to emit {lit}`shared RC array to swap` whenever it is unable to mutate the array.
-- However, this change to the program changes the proofs as well, because now there's a call to an additional function.
-- Adding a local assumption that {anchorName dbgTraceIfSharedSig}`dbgTraceIfShared` preserves the length of its argument and adding it to some calls to {anchorTerm InstrumentedInsertionSort (module:=Examples.ProgramsProofs.InstrumentedInsertionSort)}`simp` is enough to fix the program and proofs.

插入排序刚好有一个地方有复制而非改变的风险：调用 {anchorName names}`Array.swap`。
将 {anchorTerm insertSorted}`arr.swap i' i` 替换为 {anchorTerm InstrumentedInsertionSort (module := Examples.ProgramsProofs.InstrumentedInsertionSort)}`(dbgTraceIfShared "array to swap" arr).swap i' i` 会让程序在无法改变数组时发出 {lit}`shared RC array to swap`。
然而，对程序的这一更改也会更改证明，因为现在调用了一个附加函数。
添加一个局部假设，即 {anchorName dbgTraceIfSharedSig}`dbgTraceIfShared` 保留其参数的长度，并将其添加到对 {anchorTerm InstrumentedInsertionSort (module:=Examples.ProgramsProofs.InstrumentedInsertionSort)}`simp` 的一些调用中，足以修复程序和证明。

-- The complete instrumented code for insertion sort is:

插入排序的完整形式化验证代码为：

```anchor InstrumentedInsertionSort (module := Examples.ProgramsProofs.InstrumentedInsertionSort)
def insertSorted [Ord α] (arr : Array α) (i : Fin arr.size) : Array α :=
  match i with
  | ⟨0, _⟩ => arr
  | ⟨i' + 1, _⟩ =>
    have : i' < arr.size := by
      omega
    match Ord.compare arr[i'] arr[i] with
    | .lt | .eq => arr
    | .gt =>
      have : (dbgTraceIfShared "array to swap" arr).size = arr.size := by
        simp [dbgTraceIfShared]
      insertSorted
        ((dbgTraceIfShared "array to swap" arr).swap i' i)
        ⟨i', by simp [*]⟩

theorem insert_sorted_size_eq [Ord α] (len : Nat) (i : Nat) :
    (arr : Array α) → (isLt : i < arr.size) → (arr.size = len) →
    (insertSorted arr ⟨i, isLt⟩).size = len := by
  induction i with
  | zero =>
    intro arr isLt hLen
    simp [insertSorted, *]
  | succ i' ih =>
    intro arr isLt hLen
    simp [insertSorted, dbgTraceIfShared]
    split <;> simp [*]

def insertionSortLoop [Ord α] (arr : Array α) (i : Nat) : Array α :=
  if h : i < arr.size then
    have : (insertSorted arr ⟨i, h⟩).size - (i + 1) < arr.size - i := by
      rw [insert_sorted_size_eq arr.size i arr h rfl]
      omega
    insertionSortLoop (insertSorted arr ⟨i, h⟩) (i + 1)
  else
    arr
termination_by arr.size - i

def insertionSort [Ord α] (arr : Array α) : Array α :=
  insertionSortLoop arr 0
```

-- A bit of cleverness is required to check whether the instrumentation actually works.
-- First off, the Lean compiler aggressively optimizes function calls away when all their arguments are known at compile time.
-- Simply writing a program that applies {anchorName InstrumentedInsertionSort (module:=Examples.ProgramsProofs.InstrumentedInsertionSort)}`insertionSort` to a large array is not sufficient, because the resulting compiled code may contain only the sorted array as a constant.
-- The easiest way to ensure that the compiler doesn't optimize away the sorting routine is to read the array from {anchorName getLines (module:=Examples.ProgramsProofs.InstrumentedInsertionSort)}`stdin`.
-- Secondly, the compiler performs dead code elimination.
-- Adding extra {kw}`let`s to the program won't necessarily result in more references in running code if the {kw}`let`-bound variables are never used.
-- To ensure that the extra reference is not eliminated entirely, it's important to ensure that the extra reference is somehow used.

要检查形式化验证是否实际起作用，需要一点技巧。首先，当所有参数在编译时都已知时，
Lean 编译器会积极地优化函数调用。仅仅编写一个将 {anchorName InstrumentedInsertionSort (module:=Examples.ProgramsProofs.InstrumentedInsertionSort)}`insertionSort` 应用于大数组的程序是不够的，
因为生成的编译代码可能只包含已排序的数组作为常量。确保编译器不会优化排序例程的最简单方法是从
{anchorName getLines (module:=Examples.ProgramsProofs.InstrumentedInsertionSort)}`stdin` 读取数组。其次，编译器会执行死代码消除。如果从未使用 {kw}`let` 绑定的变量，
则向程序中添加额外的 {kw}`let` 并不一定会导致运行代码中更多的引用。为了确保不会完全消除额外的引用，
重点在于确保以某种方式使用了额外的引用。

-- The first step in testing the instrumentation is to write {anchorName getLines (module := Examples.ProgramsProofs.InstrumentedInsertionSort)}`getLines`, which reads an array of lines from standard input:

测试形式化验证代码的第一步是编写 {anchorName getLines (module := Examples.ProgramsProofs.InstrumentedInsertionSort)}`getLines`，它从标准输入读取一行数组：

```anchor getLines (module := Examples.ProgramsProofs.InstrumentedInsertionSort)
def getLines : IO (Array String) := do
  let stdin ← IO.getStdin
  let mut lines : Array String := #[]
  let mut currLine ← stdin.getLine
  while !currLine.isEmpty do
     -- Drop trailing newline:
    lines := lines.push (currLine.dropRight 1)
    currLine ← stdin.getLine
  pure lines
```
-- {anchorName various (module:=Examples.ProgramsProofs.InstrumentedInsertionSort)}`IO.FS.Stream.getLine` returns a complete line of text, including the trailing newline.
-- It returns {anchorTerm mains (module:=Examples.ProgramsProofs.InstrumentedInsertionSort)}`""` when the end-of-file marker has been reached.

{anchorName various (module:=Examples.ProgramsProofs.InstrumentedInsertionSort)}`IO.FS.Stream.getLine` 返回一行完整的文本，包括结尾的换行。当到达文件结尾标记时，它返回 {anchorTerm mains (module:=Examples.ProgramsProofs.InstrumentedInsertionSort)}`""`。

-- Next, two separate {anchorName main (module:=Examples.ProgramsProofs.InstrumentedInsertionSort)}`main` routines are needed.
-- Both read the array to be sorted from standard input, ensuring that the calls to {anchorName mains (module:=Examples.ProgramsProofs.InstrumentedInsertionSort)}`insertionSort` won't be replaced by their return values at compile time.
-- Both then print to the console, ensuring that the calls to {anchorName insertionSort}`insertionSort` won't be optimized away entirely.
-- One of them prints only the sorted array, while the other prints both the sorted array and the original array.
-- The second function should trigger a warning that {anchorName names}`Array.swap` had to allocate a new array:

接下来，需要两个单独的 {anchorName main (module:=Examples.ProgramsProofs.InstrumentedInsertionSort)}`main` 例程。两者都从标准输入读取要排序的数组，
确保在编译时不会用它们的返回值替换对 {anchorName mains (module:=Examples.ProgramsProofs.InstrumentedInsertionSort)}`insertionSort` 的调用。然后两者都打印到控制台，
确保对 {anchorName insertionSort}`insertionSort` 的调用不会被完全优化掉。其中一个只打印排序后的数组，
而另一个同时打印排序后的数组和原始数组。第二个函数应该触发一个警告，
即 {anchorName names}`Array.swap` 必须分配一个新数组：

```anchor mains (module := Examples.ProgramsProofs.InstrumentedInsertionSort)
def mainUnique : IO Unit := do
  let lines ← getLines
  for line in insertionSort lines do
    IO.println line

def mainShared : IO Unit := do
  let lines ← getLines
  IO.println "--- Sorted lines: ---"
  for line in insertionSort lines do
    IO.println line

  IO.println ""
  IO.println "--- Original data: ---"
  for line in lines do
    IO.println line
```

-- The actual {anchorName main (module:=Examples.ProgramsProofs.InstrumentedInsertionSort)}`main` simply selects one of the two main actions based on the provided command-line arguments:

实际的 {anchorName main (module:=Examples.ProgramsProofs.InstrumentedInsertionSort)}`main` 只需根据提供的命令行参数选择两个 main 活动二者之一：

```anchor main (module := Examples.ProgramsProofs.InstrumentedInsertionSort)
def main (args : List String) : IO UInt32 := do
  match args with
  | ["--shared"] => mainShared; pure 0
  | ["--unique"] => mainUnique; pure 0
  | _ =>
    IO.println "Expected single argument, either \"--shared\" or \"--unique\""
    pure 1
```

-- Running it with no arguments produces the expected usage information:

在没有参数的情况下运行它会产生预期的用法信息：

```commands «sort-sharing» "sort-demo"
$ expect -f ./run-usage # sort
Expected single argument, either "--shared" or "--unique"
```

-- The file {lit}`test-data` contains the following rocks:

文件 {lit}`test-data` 包含以下岩石：

```file «sort-sharing» "sort-demo/test-data"
schist
feldspar
diorite
pumice
obsidian
shale
gneiss
marble
flint
```

-- Using the instrumented insertion sort on these rocks results them being printed in alphabetical order:

对这些岩石使用形式化验证的插入排序，结果按字母顺序打印出来：

```commands «sort-sharing» "sort-demo"
$ sort --unique < test-data
diorite
feldspar
flint
gneiss
marble
obsidian
pumice
schist
shale
```

-- However, the version in which a reference is retained to the original array results in a notification on {lit}`stderr` (namely, {lit}`shared RC array to swap`) from the first call to {anchorName names}`Array.swap`:

然而，保留对原始数组的引用的版本会导致对 {anchorName names}`Array.swap` 的第一次调用在 {lit}`stderr`
上发出通知（即 {lit}`shared RC array to swap`）：

```commands «sort-sharing» "sort-demo"
$ sort --shared < test-data
--- Sorted lines: ---
diorite
feldspar
flint
gneiss
marble
obsidian
pumice
schist
shale

--- Original data: ---
schist
feldspar
diorite
pumice
obsidian
shale
gneiss
marble
flint
shared RC array to swap
```
-- The fact that only a single {lit}`shared RC` notification appears means that the array is copied only once.
-- This is because the copy that results from the call to {anchorName names}`Array.swap` is itself unique, so no further copies need to be made.
-- In an imperative language, subtle bugs can result from forgetting to explicitly copy an array before passing it by reference.
-- When running {lit}`sort --shared`, the array is copied as needed to preserve the pure functional meaning of Lean programs, but no more.

仅出现一个 {lit}`shared RC` 通知这一事实意味着数组仅被复制了一次。
这是因为由对 {anchorName names}`Array.swap` 的调用产生的副本本身是唯一的，因此不需要进行进一步的复制。
在命令式语言中，由于忘记在按引用传递数组之前显式复制数组，可能会导致微妙的 Bug。
在运行 {lit}`sort --shared` 时，数组会安需复制，以保持 Lean 程序的纯函数语义，但仅此而已。


-- # Other Opportunities for Mutation
# 其他可变性的机会
%%%
tag := "insertion-sort-other-mutation-opportunities"
%%%

-- The use of mutation instead of copying when references are unique is not limited to array update operators.
-- Lean also attempts to “recycle” constructors whose reference counts are about to fall to zero, reusing them instead of allocating new data.
-- This means, for instance, that {anchorName names}`List.map` will mutate a linked list in place, at least in cases when nobody could possibly notice.
-- One of the most important steps in optimizing hot loops in Lean code is making sure that the data being modified is not referred to from multiple locations.

当引用唯一时，使用修改而非复制并不仅限于数组更新操作。
Lean 还会尝试「回收」引用计数即“将降至零的构造函数，重新使用它们而不是分配新数据。
这意味着，例如，{anchorName names}`List.map` 将原地修改链表，至少在无人能注意到的情况下。
优化 Lean 代码中的热循环最重要的步骤之一是确保被修改的数据不会被从多个位置引用。

-- # Exercises
# 练习
%%%
tag := "insertion-sort-exercises"
%%%


--  * Write a function that reverses arrays. Test that if the input array has a reference count of one, then your function does not allocate a new array.

 * 编写一个反转数组的函数。测试如果输入数组的引用计数为一，则你的函数不会分配一个新数组。

--  * Implement either merge sort or quicksort for arrays. Prove that your implementation terminates, and test that it doesn't allocate more arrays than expected. This is a challenging exercise!

 * 为数组实现归并排序或快速排序。证明你的实现会停机，并测试它不会分配比预期更多的数组。这是一个具有挑战性的练习！
