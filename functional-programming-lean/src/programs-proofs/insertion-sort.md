<!--
# Insertion Sort and Array Mutation
-->

# 插入排序与数组可变性

<!--
While insertion sort does not have the optimal worst-case time complexity for a sorting algorithm, it still has a number of useful properties:

 * It is simple and straightforward to implement and understand
 * It is an in-place algorithm, requiring no additional space to run
 * It is a stable sort
 * It is fast when the input is already almost sorted
-->

虽然插入排序的最差时间复杂度并不是最优，但它仍然有一些有用的属性：

 * 它简单明了，易于实现和理解
 * 它是一种原地排序算法，不需要额外的空间来运行
 * 它是一种稳定排序
 * 当输入已经排序得差不多时，它很快

<!--
In-place algorithms are particularly useful in Lean due to the way it manages memory.
In some cases, operations that would normally copy an array can be optimized into mutation.
This includes swapping elements in an array.
-->

原地算法在 Lean 中特别有用，因为它管理内存的方式。
在某些情况下，会复制数组的操作通常可以优化为直接修改。这包括交换数组中的元素。

<!--
Most languages and run-time systems with automatic memory management, including JavaScript, the JVM, and .NET, use tracing garbage collection.
When memory needs to be reclaimed, the system starts at a number of _roots_ (such as the call stack and global values) and then determines which values can be reached by recursively chasing pointers.
Any values that can't be reached are deallocated, freeing memory.
-->

大多数语言和具有自动内存管理的运行时系统，包括 JavaScript、JVM 和 .NET，都使用跟踪垃圾回收。
当需要回收内存时，系统从许多 **根**（例如调用栈和全局值）开始，
然后通过递归地追踪指针来确定可以到达哪些值。任何无法到达的值都会被释放，从而释放内存。

<!--
Reference counting is an alternative to tracing garbage collection that is used by a number of languages, including Python, Swift, and Lean.
In a system with reference counting, each object in memory has a field that tracks how many references there are to it.
When a new reference is established, the counter is incremented.
When a reference ceases to exist, the counter is decremented.
When the counter reaches zero, the object is immediately deallocated.
-->

引用计数是追踪式垃圾回收的替代方法，它被许多语言使用，包括 Python、Swift 和 Lean。
在引用计数系统中，内存中的每个对象都有一个字段来跟踪对它的引用数。
当建立一个新引用时，计数器会增加。当一个引用不再存在时，计数器会减少。
当计数器达到零时，对象会立即被释放。

<!--
Reference counting has one major disadvantage compared to a tracing garbage collector: circular references can lead to memory leaks.
If object \\( A \\) references object \\( B \\) , and object \\( B \\) references object \\( A \\), they will never be deallocated, even if nothing else in the program references either \\( A \\) or \\( B \\).
Circular references result either from uncontrolled recursion or from mutable references.
Because Lean supports neither, it is impossible to construct circular references.
-->

与追踪式垃圾回收器相比，引用计数有一个主要的缺点：循环引用会导致内存泄漏。
如果对象 \\( A \\) 引用对象 \\( B \\)，而对象 \\( B \\) 引用对象 \\( A \\)，
它们将永远不会被释放，即使程序中没有其他内容引用 \\( A \\) 或 \\( B \\)。
循环引用要么是由不受控制的递归引起的，要么是由可变引用引起的。由于 Lean 不支持这两者，
因此不可能构造循环引用。

<!--
Reference counting means that the Lean runtime system's primitives for allocating and deallocating data structures can check whether a reference count is about to fall to zero, and re-use an existing object instead of allocating a new one.
This is particularly important when working with large arrays.
-->

引用计数意味着 Lean 运行时系统用于分配和释放数据结构的原语可以检查引用计数是否即将降至零，
并重新使用现有对象而非分配一个新对象。当使用大型数组时，这一点尤其重要。

<!--
An implementation of insertion sort for Lean arrays should satisfy the following criteria:

 1. Lean should accept the function without a `partial` annotation
 2. If passed an array to which there are no other references, it should modify the array in-place rather than allocating a new one
-->

针对 Lean 数组的插入排序的实现应满足以下条件：

 1. Lean 应当接受没有 `partial` 标注的函数
 2. 若传递了一个没有其他引用的数组，它应原地修改数组，而非分配一个新数组

<!--
The first criterion is easy to check: if Lean accepts the definition, then it is satisfied.
The second, however, requires a means of testing it.
Lean provides a built-in function called `dbgTraceIfShared` with the following signature:
-->

第一个条件很容易检查：如果 Lean 接受该定义，则满足该条件。
然而，第二个条件需要一种测试方法。Lean 提供了一个名为 `dbgTraceIfShared` 的内置函数，其签名如下：

```lean
{{#example_in Examples/ProgramsProofs/InsertionSort.lean dbgTraceIfSharedSig}}
```

```output info
{{#example_out Examples/ProgramsProofs/InsertionSort.lean dbgTraceIfSharedSig}}
```

<!--
It takes a string and a value as arguments, and prints a message that uses the string to standard error if the value has more than one reference, returning the value.
This is not, strictly speaking, a pure function.
However, it is intended to be used only during development to check that a function is in fact able to re-use memory rather than allocating and copying.
-->

它以一个字符串和一个值作为参数，如果该值有多个引用，则使用该字符串打印一条消息到标准错误，
并返回该值。严格来说，它不是一个纯函数。
但是，它仅在开发期间用于检查函数实际上能够重用内存而非分配和复制。

<!--
When learning to use `dbgTraceIfShared`, it's important to know that `#eval` will report that many more values are shared than in compiled code.
This can be confusing.
It's important to build an executable with `lake` rather than experimenting in an editor.
-->

在学习使用 `dbgTraceIfShared` 时，重要的是要知道 `#eval` 会报告的值比已编译的代码中共享的值更多，
这可能会令人困惑。重要的是使用 `lake` 构建可执行文件，而非在编辑器中进行实验。

<!--
Insertion sort consists of two loops.
The outer loop moves a pointer from left to right across the array to be sorted.
After each iteration, the region of the array to the left of the pointer is sorted, while the region to the right may not yet be sorted.
The inner loop takes the element pointed to by the pointer and moves it to the left until the appropriate location has been found and the loop invariant has been restored.
In other words, each iteration inserts the next element of the array into the appropriate location in the sorted region.
-->

插入排序由两个循环组成。外层循环将指针从左向右移动到要排序的数组中。
每次迭代后，指针左边的数组区域都会被排序，而右边的区域可能尚未被排序。
内层循环获取指针指向的元素，并将其向左移动，直到找到合适的位置并恢复循环不变式。
换句话说，每次迭代都会将数组的下一个元素插入到已排序区域的合适位置。

<!--
## The Inner Loop
-->

## 内层循环

<!--
The inner loop of insertion sort can be implemented as a tail-recursive function that takes the array and the index of the element being inserted as arguments.
The element being inserted is repeatedly swapped with the element to its left until either the element to the left is smaller or the beginning of the array is reached.
The inner loop is structurally recursive on the `Nat` that is inside the `Fin` used to index into the array:
-->

插入排序的内层循环可以实现为一个尾递归函数，该函数将数组和要插入的元素的索引作为参数。
要插入的元素会与它左边的元素反复交换，直到左边的元素更小或到达数组的开头。
内层循环会在用来索引数组的 `Fin` 中的 `Nat` 上进行结构化递归：

```leantac
{{#example_decl Examples/ProgramsProofs/InsertionSort.lean insertSorted}}
```

<!--
If the index `i` is `0`, then the element being inserted into the sorted region has reached the beginning of the region and is the smallest.
If the index is `i' + 1`, then the element at `i'` should be compared to the element at `i`.
Note that while `i` is a `Fin arr.size`, `i'` is just a `Nat` because it results from the `val` field of `i`.
It is thus necessary to prove that `i' < arr.size` before `i'` can be used to index into `arr`.
-->

若索引 `i` 为 `0`，则插入到已排序区域的元素已到达该区域的开头，并且是最小的。
若索引为 `i' + 1`，则应将 `i'` 处的元素与 `i` 处的元素进行比较。
请注意，虽然 `i` 是 `Fin arr.size`，但 `i'` 只是一个 `Nat`，因为它是由 `i` 的 `val` 字段产生的。
因此，在使用 `i'` 对 `arr` 进行索引之前，有必要证明 `i' < arr.size`。

<!--
Omitting the `have`-expression with the proof that `i' < arr.size` reveals the following goal:
-->

省略带有证明 `i' < arr.size` 的 `have` 表达式，将显示以下目标：

```output error
{{#example_out Examples/ProgramsProofs/InsertionSort.lean insertSortedNoProof}}
```

<!--
The hint `Nat.lt_of_succ_lt` is a theorem from Lean's standard library.
Its signature, found by `{{#example_in Examples/ProgramsProofs/InsertionSort.lean lt_of_succ_lt_type}}`, is
-->

提示 `Nat.lt_of_succ_lt` 是 Lean 标准库中的一个定理。
它的签名可以通过 `#check Nat.lt_of_succ_lt` 查看：

```output info
{{#example_out Examples/ProgramsProofs/InsertionSort.lean lt_of_succ_lt_type}}
```

<!--
In other words, it states that if `n + 1 < m`, then `n < m`.
The `*` passed to `simp` causes it to combine `Nat.lt_of_succ_lt` with the `isLt` field from `i` to get the final proof.
-->

换句话说，它指出如果 `n + 1 < m`，则 `n < m`。传递给 `simp` 的 `*` 会使其将
`Nat.lt_of_succ_lt` 与 `i` 中的 `isLt` 字段结合起来以获得最终证明。

<!--
Having established that `i'` can be used to look up the element to the left of the element being inserted, the two elements are looked up and compared.
If the element to the left is less than or equal to the element being inserted, then the loop is finished and the invariant has been restored.
If the element to the left is greater than the element being inserted, then the elements are swapped and the inner loop begins again.
`Array.swap` takes both of its indices as `Fin`s, and the `by assumption` that establishes that `i' < arr.size` makes use of the `have`.
The index to be examined on the next round through the inner loop is also `i'`, but `by assumption` is not sufficient in this case.
This is because the proof was written for the original array `arr`, not the result of swapping two elements.
The `simp` tactic's database contains the fact that swapping two elements of an array doesn't change its size, and the `[*]` argument instructs it to additionally use the assumption introduced by `have`.
-->

在确定 `i'` 可用于查找要插入元素左侧的元素后，就要查找并比较这两个元素。
若左侧元素小于或等于要插入的元素，则循环结束并且不变量被恢复。
若左侧元素大于要插入的元素，则交换元素并重新开始内层循环。
`Array.swap` 将其两个索引都作为 `Fin`，并且利用 `have` 建立 `i' < arr.size` 的 `by assumption`。
在内层循环的下一轮中要检查的索引也是 `i'`，但在这种情况下 `by assumption` 并足够。
这是因为该证明是针对原始数组 `arr` 编写的，而非交换两个元素的结果。
`simp` 策略的数据库包含这样一个事实：交换数组的两个元素不会改变其大小，
并且 `[*]` 参数会指示它额外使用 `have` 引入的假设。

<!--
## The Outer Loop
-->

## 外层循环

<!--
The outer loop of insertion sort moves the pointer from left to right, invoking `insertSorted` at each iteration to insert the element at the pointer into the correct position in the array.
The basic form of the loop resembles the implementation of `Array.map`:
-->

插入排序的外层循环将指针从左向右移动，在每次迭代中调用 `insertSorted`
将指针处的元素插入到数组中正确的位置。循环的基本形式类似于 `Array.map` 的实现：

```lean
{{#example_in Examples/ProgramsProofs/InsertionSort.lean insertionSortLoopTermination}}
```

<!--
The resulting error is also the same as the error that occurs without a `termination_by` clause on `Array.map`, because there is no argument that decreases at every recursive call:
-->

它产生的错误也与在 `Array.map` 上没有 `termination_by` 子句时发生的错误相同，
因为没有在每次递归调用时都会减少的参数：

```output error
{{#example_out Examples/ProgramsProofs/InsertionSort.lean insertionSortLoopTermination}}
```

<!--
Before constructing the termination proof, it can be convenient to test the definition with a `partial` modifier to make sure that it returns the expected answers:
-->

在构建停机证明之前，可以使用 `partial` 修饰符测试定义以确保它返回预期的答案：

```lean
{{#example_decl Examples/ProgramsProofs/InsertionSort.lean partialInsertionSortLoop}}
```

```lean
{{#example_in Examples/ProgramsProofs/InsertionSort.lean insertionSortPartialOne}}
```

```output info
{{#example_out Examples/ProgramsProofs/InsertionSort.lean insertionSortPartialOne}}
```

```lean
{{#example_in Examples/ProgramsProofs/InsertionSort.lean insertionSortPartialTwo}}
```

```output info
{{#example_out Examples/ProgramsProofs/InsertionSort.lean insertionSortPartialTwo}}
```

<!--
### Termination
-->

### 停机性

<!--
Once again, the function terminates because the difference between the index and the size of the array being processed decreases on each recursive call.
This time, however, Lean does not accept the `termination_by`:
-->

同样，该函数会停机是因为正在处理的索引和数组大小之差在每次递归调用时都会减小。
然而，这一次，Lean 不接受 `termination_by`：

```lean
{{#example_in Examples/ProgramsProofs/InsertionSort.lean insertionSortLoopProof1}}
```

```output error
{{#example_out Examples/ProgramsProofs/InsertionSort.lean insertionSortLoopProof1}}
```

<!--
The problem is that Lean has no way to know that `insertSorted` returns an array that's the same size as the one it is passed.
In order to prove that `insertionSortLoop` terminates, it is necessary to first prove that `insertSorted` doesn't change the size of the array.
Copying the unproved termination condition from the error message to the function and "proving" it with `sorry` allows the function to be temporarily accepted:
-->

问题在于 Lean 无法知道 `insertSorted` 返回的数组与传递给它的数组大小相同。
为了证明 `insertionSortLoop` 会停机，首先有必要证明 `insertSorted` 不会改变数组的大小。
将未经证明的停机条件从错误消息复制到函数中，并使用 `sorry`「证明」它，可以暂时接受该函数：

```leantac
{{#example_in Examples/ProgramsProofs/InsertionSort.lean insertionSortLoopSorry}}
```

```output warning
{{#example_out Examples/ProgramsProofs/InsertionSort.lean insertionSortLoopSorry}}
```

<!--
Because `insertSorted` is structurally recursive on the index of the element being inserted, the proof should be by induction on the index.
In the base case, the array is returned unchanged, so its length certainly does not change.
For the inductive step, the induction hypothesis is that a recursive call on the next smaller index will not change the length of the array.
There are two cases two consider: either the element has been fully inserted into the sorted region and the array is returned unchanged, in which case the length is also unchanged, or the element is swapped with the next one before the recursive call.
However, swapping two elements in an array doesn't change the size of it, and the induction hypothesis states that the recursive call with the next index returns an array that's the same size as its argument.
Thus, the size remains unchanged.
-->

由于 `insertSorted` 在要插入的元素的索引上是结构化递归的，所以应该通过索引归纳进行证明。
在基本情况下，数组返回不变，因此其长度肯定不会改变。对于归纳步骤，
归纳假设是在下一个更小的索引上的递归调用不会改变数组的长度。
这里有两种情况需要考虑：要么元素已完全插入到已排序区域中，并且数组返回不变，
在这种情况下长度也不会改变，要么元素在递归调用之前与下一个元素交换。
然而，在数组中交换两个元素不会改变它的大小，
并且归纳假设指出以下一个索引的递归调用返回的数组与其参数大小相同。因此，大小仍然保持不变。

<!--
Translating this English-language theorem statement to Lean and proceeding using the techniques from this chapter is enough to prove the base case and make progress in the inductive step:
-->

将自然语言的定理陈述翻译为 Lean，并使用本章中的技术进行操作，足以证明基本情况并在归纳步骤中取得进展：

```leantac
{{#example_in Examples/ProgramsProofs/InsertionSort.lean insert_sorted_size_eq_0}}
```

<!--
The simplification using `insertSorted` in the inductive step revealed the pattern match in `insertSorted`:
-->

在归纳步骤中使用 `insertSorted` 的简化揭示了 `insertSorted` 中的模式匹配：

```output error
{{#example_out Examples/ProgramsProofs/InsertionSort.lean insert_sorted_size_eq_0}}
```

<!--
When faced with a goal that includes `if` or `match`, the `split` tactic (not to be confused with the `split` function used in the definition of merge sort) replaces the goal with one new goal for each path of control flow:
-->

当面对包含 `if` 或 `match` 的目标时，`split` 策略（不要与归并排序定义中使用的 `split` 函数混淆）
会用一个新目标替换原目标，用于控制流的每条路径：

```leantac
{{#example_in Examples/ProgramsProofs/InsertionSort.lean insert_sorted_size_eq_1}}
```

<!--
Additionally, each new goal has an assumption that indicates which branch led to that goal, named `heq✝` in this case:
-->

此外，每个新目标都有一个假设，表明哪个分支导致了该目标，在本例中命名为 `heq✝`：

```output error
{{#example_out Examples/ProgramsProofs/InsertionSort.lean insert_sorted_size_eq_1}}
```

<!--
Rather than write proofs for both simple cases, adding `<;> try rfl` after `split` causes the two straightforward cases to disappear immediately, leaving only a single goal:
-->

与其为这两个简单情况编写证明，不如在 `split` 后添加 `<;> try rfl`，
这样这两个直接的情况会立即消失，只留下一个目标：

```leantac
{{#example_in Examples/ProgramsProofs/InsertionSort.lean insert_sorted_size_eq_2}}
```

```output error
{{#example_out Examples/ProgramsProofs/InsertionSort.lean insert_sorted_size_eq_2}}
```

<!--
Unfortunately, the induction hypothesis is not strong enough to prove this goal.
The induction hypothesis states that calling `insertSorted` on `arr` leaves the size unchanged, but the proof goal is to show that the result of the recursive call with the result of swapping leaves the size unchanged.
Successfully completing the proof requires an induction hypothesis that works for _any_ array that is passed to `insertSorted` together with the smaller index as an argument
-->

不幸的是，归纳假设不足以证明这个目标。归纳假设指出对 `arr` 调用 `insertSorted` 不会改变大小，
但证明目标是要证明用交换的结果来进行递归调用的结果不会改变大小。成功完成证明需要一个归纳假设，
该假设适用于传递给 `insertSorted` 的任何数组，以及作为参数的更小的索引。

<!--
It is possible to get a strong induction hypothesis by using the `generalizing` option to the `induction` tactic.
This option brings additional assumptions from the context into the statement that's used to generate the base case, the induction hypothesis, and the goal to be shown in the inductive step.
Generalizing over `arr` leads to a stronger hypothesis:
-->

可以使用 `induction` 策略的 `generalizing` 选项来获得强归纳假设。
此选项会将语境中的附加假设引入到一个语句中，该语句用于生成基本情况、归纳假设和在归纳步骤中显示的目标。
对 `arr` 进行推广会产生更强的假设：

```leantac
{{#example_in Examples/ProgramsProofs/InsertionSort.lean insert_sorted_size_eq_3}}
```

<!--
In the resulting goal, `arr` is now part of a "for all" statement in the inductive hypothesis:
-->

在生成的证明目标中，`arr` 现在是归纳假设中「对于所有」语句的一部分：

```output error
{{#example_out Examples/ProgramsProofs/InsertionSort.lean insert_sorted_size_eq_3}}
```

<!--
However, this whole proof is beginning to get unmanageable.
The next step would be to introduce a variable standing for the length of the result of swapping, show that it is equal to `arr.size`, and then show that this variable is also equal to the length of the array that results from the recursive call.
These equality statement can then be chained together to prove the goal.
It's much easier, however, to carefully reformulate the theorem statement such that the induction hypothesis is automatically strong enough and the variables are already introduced.
The reformulated statement reads:
-->

然而，整个证明开始变得难以控制。下一步是引入一个变量表示交换结果的长度，
证明它等于 `arr.size`，然后证明这个变量也等于递归调用产生的数组的长度。
之后可以将这些相等语句链接在一起来证明目标。
然而，仔细地重新表述定理的陈述要容易得多，这样归纳假设就能自动变得足够强，变量也会被引入。
重新表述的陈述如下：

```leantac
{{#example_in Examples/ProgramsProofs/InsertionSort.lean insert_sorted_size_eq_redo_0}}
```

<!--
This version of the theorem statement is easier to prove for a few reasons:

 1. Rather than bundling up the index and the proof of its validity in a `Fin`, the index comes before the array.
    This allows the induction hypothesis to naturally generalize over the array and the proof that `i` is in bounds.
 2. An abstract length `len` is introduced to stand for `array.size`.
    Proof automation is often better at working with explicit statements of equality.
-->

这个版本的定理陈述更容易证明，原因有以下几个：

 1. 与其将索引及其有效性证明捆绑在 `Fin` 中，不如将索引放在数组之前。
    这使得归纳假设可以自然地推广到整个数组，并证明 `i` 在范围内。
 2. 引入了一个抽象长度 `len` 来表示 `array.size`。证明自动化通常更擅长处理显式相等性陈述。

<!--
The resulting proof state shows the statement that will be used to generate the induction hypothesis, as well as the base case and the goal of the inductive step:
-->

生成的证明状态显示了将要用于生成归纳假设的语句，以及基本情况和归纳步骤的目标：

```output error
{{#example_out Examples/ProgramsProofs/InsertionSort.lean insert_sorted_size_eq_redo_0}}
```

<!--
Compare the statement with the goals that result from the `induction` tactic:
-->

将该语句与 `induction` 策略产生的目标进行比较：

```leantac
{{#example_in Examples/ProgramsProofs/InsertionSort.lean insert_sorted_size_eq_redo_1a}}
```

<!--
In the base case, each occurrence of `i` has been replaced by `0`.
Using `intro` to introduce each assumption and then simplifying using `insertSorted` will prove the goal, because `insertSorted` at index `zero` returns its argument unchanged:
-->

在基本情况下，每个 `i` 的出现都会被替换为 `0`。使用 `intro` 引入每个假设，
然后使用 `insertSorted` 简化就能证明目标，因为在索引 `zero` 处的 `insertSorted` 会返回其参数不变：

```output error
{{#example_out Examples/ProgramsProofs/InsertionSort.lean insert_sorted_size_eq_redo_1a}}
```

<!--
In the inductive step, the induction hypothesis has exactly the right strength.
It will be useful for _any_ array, so long as that array has length `len`:
-->

在归纳步骤中，归纳假设具有恰当的强度。它对 **任何** 数组都适用，只要该数组的长度为 `len`：

```output error
{{#example_out Examples/ProgramsProofs/InsertionSort.lean insert_sorted_size_eq_redo_1b}}
```

<!--
In the base case, `simp` reduces the goal to `arr.size = len`:
-->

在基本情况下，`simp` 将目标简化为 `arr.size = len`：

```leantac
{{#example_in Examples/ProgramsProofs/InsertionSort.lean insert_sorted_size_eq_redo_2}}
```

```output error
{{#example_out Examples/ProgramsProofs/InsertionSort.lean insert_sorted_size_eq_redo_2}}
```

<!--
This can be proved using the assumption `hLen`.
Adding the `*` parameter to `simp` instructs it to additionally use assumptions, which solves the goal:
-->

这可以使用假设 `hLen` 来证明。向 `simp` 添加 `*` 参数指示它额外使用假设，这解决了目标：

```leantac
{{#example_in Examples/ProgramsProofs/InsertionSort.lean insert_sorted_size_eq_redo_2b}}
```

<!--
In the inductive step, introducing assumptions and simplifying the goal results once again in a goal that contains a pattern match:
-->

在归纳步骤中，引入假设并简化目标会再次产生包含模式匹配的目标：

```leantac
{{#example_in Examples/ProgramsProofs/InsertionSort.lean insert_sorted_size_eq_redo_3}}
```

```output error
{{#example_out Examples/ProgramsProofs/InsertionSort.lean insert_sorted_size_eq_redo_3}}
```

<!--
Using the `split` tactic results in one goal for each pattern.
Once again, the first two goals result from branches without recursive calls, so the induction hypothesis is not necessary:
-->

使用 `split` 策略会为每个模式生成一个目标。同样，前两个目标来自没有递归调用的分支，因此不需要归纳假设：

```leantac
{{#example_in Examples/ProgramsProofs/InsertionSort.lean insert_sorted_size_eq_redo_4}}
```

```output error
{{#example_out Examples/ProgramsProofs/InsertionSort.lean insert_sorted_size_eq_redo_4}}
```

<!--
Running `try assumption` in each goal that results from `split` eliminates both of the non-recursive goals:
-->

在 `split` 产生的每个目标中运行 `try assumption` 会消除两个非递归目标：

```leantac
{{#example_in Examples/ProgramsProofs/InsertionSort.lean insert_sorted_size_eq_redo_5}}
```

```output error
{{#example_out Examples/ProgramsProofs/InsertionSort.lean insert_sorted_size_eq_redo_5}}
```

<!--
The new formulation of the proof goal, in which a constant `len` is used for the lengths of all the arrays involved in the recursive function, falls nicely within the kinds of problems that `simp` can solve.
This final proof goal can be solved by `simp [*]`, because the assumptions that relate the array's length to `len` are important:
-->

对于证明目标的全新表述，其中常量 `len` 用于递归函数中涉及的所有数组的长度，
恰好属于 `simp` 可以解决的问题类型。最终的证明目标可以通过 `simp [*]` 来解决，
因为将数组的长度与 `len` 联系起来的假设很重要：

```leantac
{{#example_decl Examples/ProgramsProofs/InsertionSort.lean insert_sorted_size_eq_redo_6}}
```

<!--
Finally, because `simp [*]` can use assumptions, the `try assumption` line can be replaced by `simp [*]`, shortening the proof:
-->

最后，因为 `simp [*]` 可以使用假设，所以 `try assumption` 一行可以用 `simp [*]` 替换来缩短证明：

```leantac
{{#example_decl Examples/ProgramsProofs/InsertionSort.lean insert_sorted_size_eq_redo}}
```

<!--
This proof can now be used to replace the `sorry` in `insertionSortLoop`.
Providing `arr.size` as the `len` argument to the theorem causes the final conclusion to be `(insertSorted arr ⟨i, isLt⟩).size = arr.size`, so the rewrite ends with a very manageable proof goal:
-->

现在可以使用这个证明来替换 `insertionSortLoop` 中的 `sorry`。
将 `arr.size` 作为定理的 `len` 参数会导致最终结论为 `(insertSorted arr ⟨i, isLt⟩).size = arr.size`，
因此重写以一个非常易于管理的证明目标结束：

```leantacnorfl
{{#example_in Examples/ProgramsProofs/InsertionSort.lean insertionSortLoopRw}}
```

```output error
{{#example_out Examples/ProgramsProofs/InsertionSort.lean insertionSortLoopRw}}
```

<!--
The proof `{{#example_in Examples/ProgramsProofs/InsertionSort.lean sub_succ_lt_self_type}}` is part of Lean's standard library.
It's type is `{{#example_out Examples/ProgramsProofs/InsertionSort.lean sub_succ_lt_self_type}}`, which is exactly what's needed:
-->

证明 `{{#example_in Examples/ProgramsProofs/InsertionSort.lean sub_succ_lt_self_type}}`
是 Lean 标准库的一部分，其类型为
`{{#example_out Examples/ProgramsProofs/InsertionSort.lean sub_succ_lt_self_type}}`
它刚好就是我们所需要的：

```leantacnorfl
{{#example_decl Examples/ProgramsProofs/InsertionSort.lean insertionSortLoop}}
```

<!--
## The Driver Function
-->

## 驱动函数

<!--
Insertion sort itself calls `insertionSortLoop`, initializing the index that demarcates the sorted region of the array from the unsorted region to `0`:
-->

插入排序本身会调用 `insertionSortLoop`，以将数组中已排序区域与未排序区域的分界索引初始化为 `0`：

```lean
{{#example_decl Examples/ProgramsProofs/InsertionSort.lean insertionSort}}
```

<!--
A few quick tests show the function is at least not blatantly wrong:
-->

一些快速测试表明该函数至少不是明显错误的：

```lean
{{#example_in Examples/ProgramsProofs/InsertionSort.lean insertionSortNums}}
```

```output info
{{#example_out Examples/ProgramsProofs/InsertionSort.lean insertionSortNums}}
```

```lean
{{#example_in Examples/ProgramsProofs/InsertionSort.lean insertionSortStrings}}
```

```output info
{{#example_out Examples/ProgramsProofs/InsertionSort.lean insertionSortStrings}}
```

<!--
## Is This Really Insertion Sort?
-->

## 它真的是插入排序吗？

<!--
Insertion sort is _defined_ to be an in-place sorting algorithm.
What makes it useful, despite its quadratic worst-case run time, is that it is a stable sorting algorithm that doesn't allocate extra space and that handles almost-sorted data efficiently.
If each iteration of the inner loop allocated a new array, then the algorithm wouldn't _really_ be insertion sort.
-->

插入排序被 **定义** 为原地排序算法。尽管它具有二次最差运行时间，但它仍然有用，
因为它是一种稳定的排序算法，不会分配额外的空间，并且可以有效处理几乎已排序的数据。
如果内层循环的每次迭代都分配一个新数组，那么该算法就不会真正成为插入排序。

<!--
Lean's array operations, such as `Array.set` and `Array.swap`, check whether the array in question has a reference count that is greater than one.
If so, then the array is visible to multiple parts of the code, which means that it must be copied.
Otherwise, Lean would no longer be a pure functional language.
However, when the reference count is exactly one, there are no other potential observers of the value.
In these cases, the array primitives mutate the array in place.
What other parts of the program don't know can't hurt them.
-->

Lean 的数组操作（例如 `Array.set` 和 `Array.swap`）会检查所讨论的数组的引用计数是否大于 1。
如果是，则该数组对代码的多个部分可见，这意味着它必须被复制。
否则，Lean 将不再是一种纯函数式语言。但是，当引用计数恰好为 1 时，没有其他潜在的值观察者。
在这种情况下，数组原语会就地改变数组。程序其他不知道的部分不会对它造成破坏。

<!--
Lean's proof logic works at the level of pure functional programs, not the underlying implementation.
This means that the best way to discover whether a program unnecessarily copies data is to test it.
Adding calls to `dbgTraceIfShared` at each point where mutation is desired causes the provided message to be printed to `stderr` when the value in question has more than one reference.
-->

Lean 的证明逻辑在纯函数式程序的级别上，而非在底层实现上工作。
这意味着发现程序是否不必要地复制了数据的最好方法是测试它。
在需要改变的每个点添加对 `dbgTraceIfShared` 的调用，当所讨论的值有多个引用时，
它会将提供的消息打印到 `stderr`。

<!--
Insertion sort has precisely one place that is at risk of copying rather than mutating: the call to `Array.swap`.
Replacing `arr.swap ⟨i', by assumption⟩ i` with `((dbgTraceIfShared "array to swap" arr).swap ⟨i', by assumption⟩ i)` causes the program to emit `shared RC array to swap` whenever it is unable to mutate the array.
However, this change to the program changes the proofs as well, because now there's a call to an additional function.
Because `dbgTraceIfShared` returns its second argument directly, adding it to the calls to `simp` is enough to fix the proofs.
-->

插入排序刚好有一个地方有复制而非改变的风险：调用 `Array.swap`。将 `arr.swap ⟨i', by assumption⟩ i`
替换为 `((dbgTraceIfShared "array to swap" arr).swap ⟨i', by assumption⟩ i)`
会让程序在无法改变数组时发出 `shared RC array to swap`。然而，对程序的这一更改也会更改证明，
因为现在调用了一个附加函数。由于 `dbgTraceIfShared` 直接返回其第二个参数，
因此将其添加到对 `simp` 的调用中足以修复证明。

<!--
The complete instrumented code for insertion sort is:
-->

插入排序的完整形式化验证代码为：

```leantacnorfl
{{#include ../../../examples/Examples/ProgramsProofs/InstrumentedInsertionSort.lean:InstrumentedInsertionSort}}
```

<!--
A bit of cleverness is required to check whether the instrumentation actually works.
First off, the Lean compiler aggressively optimizes function calls away when all their arguments are known at compile time.
Simply writing a program that applies `insertionSort` to a large array is not sufficient, because the resulting compiled code may contain only the sorted array as a constant.
The easiest way to ensure that the compiler doesn't optimize away the sorting routine is to read the array from `stdin`.
Secondly, the compiler performs dead code elimination.
Adding extra `let`s to the program won't necessarily result in more references in running code if the `let`-bound variables are never used.
To ensure that the extra reference is not eliminated entirely, it's important to ensure that the extra reference is somehow used.
-->

要检查形式化验证是否实际起作用，需要一点技巧。首先，当所有参数在编译时都已知时，
Lean 编译器会积极地优化函数调用。仅仅编写一个将 `insertionSort` 应用于大数组的程序是不够的，
因为生成的编译代码可能只包含已排序的数组作为常量。确保编译器不会优化排序例程的最简单方法是从
`stdin` 读取数组。其次，编译器会执行死代码消除。如果从未使用 `let` 绑定的变量，
则向程序中添加额外的 `let` 并不一定会导致运行代码中更多的引用。为了确保不会完全消除额外的引用，
重点在于确保以某种方式使用了额外的引用。

<!--
The first step in testing the instrumentation is to write `getLines`, which reads an array of lines from standard input:
-->

测试形式化验证代码的第一步是编写 `getLines`，它从标准输入读取一行数组：

```lean
{{#include ../../../examples/Examples/ProgramsProofs/InstrumentedInsertionSort.lean:getLines}}
```

<!--
`IO.FS.Stream.getLine` returns a complete line of text, including the trailing newline.
It returns `""` when the end-of-file marker has been reached.
-->

`IO.FS.Stream.getLine` 返回一行完整的文本，包括结尾的换行。当到达文件结尾标记时，它返回空字符串 `""`。

<!--
Next, two separate `main` routines are needed.
Both read the array to be sorted from standard input, ensuring that the calls to `insertionSort` won't be replaced by their return values at compile time.
Both then print to the console, ensuring that the calls to `insertionSort` won't be optimized away entirely.
One of them prints only the sorted array, while the other prints both the sorted array and the original array.
The second function should trigger a warning that `Array.swap` had to allocate a new array:
-->

接下来，需要两个单独的 `main` 例程。两者都从标准输入读取要排序的数组，
确保在编译时不会用它们的返回值替换对 `insertionSort` 的调用。然后两者都打印到控制台，
确保对 `insertionSort` 的调用不会被完全优化掉。其中一个只打印排序后的数组，
而另一个同时打印排序后的数组和原始数组。第二个函数应该触发一个警告，
即 `Array.swap` 必须分配一个新数组：

```lean
{{#include ../../../examples/Examples/ProgramsProofs/InstrumentedInsertionSort.lean:mains}}
```

<!--
The actual `main` simply selects one of the two main actions based on the provided command-line arguments:
-->

实际的 `main` 只需根据提供的命令行参数选择两个 main 活动二者之一：

```lean
{{#include ../../../examples/Examples/ProgramsProofs/InstrumentedInsertionSort.lean:main}}
```

<!--
Running it with no arguments produces the expected usage information:
-->

在没有参数的情况下运行它会产生预期的用法信息：

```
$ {{#command {sort-demo} {sort-sharing} {./run-usage} {sort}}}
{{#command_out {sort-sharing} {./run-usage} }}
```

<!--
The file `test-data` contains the following rocks:
-->

`test-data` 文件包含以下岩石：

```
{{#file_contents {sort-sharing} {sort-demo/test-data}}}
```

<!--
Using the instrumented insertion sort on these rocks results them being printed in alphabetical order:
-->

对这些岩石使用形式化验证的插入排序，结果按字母顺序打印出来：

```
$ {{#command {sort-demo} {sort-sharing} {sort --unique < test-data}}}
{{#command_out {sort-sharing} {sort --unique < test-data} }}
```

<!--
However, the version in which a reference is retained to the original array results in a notification on `stderr` (namely, `shared RC array to swap`) from the first call to `Array.swap`:
-->

然而，保留对原始数组的引用的版本会导致对 `Array.swap` 的第一次调用在 `stderr`
上发出通知（即 `shared RC array to swap`）：

```
$ {{#command {sort-demo} {sort-sharing} {sort --shared < test-data}}}
{{#command_out {sort-sharing} {sort --shared < test-data} }}
```

<!--
The fact that only a single `shared RC` notification appears means that the array is copied only once.
This is because the copy that results from the call to `Array.swap` is itself unique, so no further copies need to be made.
In an imperative language, subtle bugs can result from forgetting to explicitly copy an array before passing it by reference.
When running `sort --shared`, the array is copied as needed to preserve the pure functional meaning of Lean programs, but no more.
-->

仅出现一个 `shared RC` 通知这一事实意味着数组仅被复制了一次。
这是因为由对 `Array.swap` 的调用产生的副本本身是唯一的，因此不需要进行进一步的复制。
在命令式语言中，由于忘记在按引用传递数组之前显式复制数组，可能会导致微妙的 Bug。
在运行 `sort --shared` 时，数组会安需复制，以保持 Lean 程序的纯函数语义，但仅此而已。

<!--
## Other Opportunities for Mutation
-->

## 其他可变性的机会

<!--
The use of mutation instead of copying when references are unique is not limited to array update operators.
Lean also attempts to "recycle" constructors whose reference counts are about to fall to zero, reusing them instead of allocating new data.
This means, for instance, that `List.map` will mutate a linked list in place, at least in cases when nobody could possibly notice.
One of the most important steps in optimizing hot loops in Lean code is making sure that the data being modified is not referred to from multiple locations.
-->

当引用唯一时，使用修改而非复制并不仅限于数组更新操作。
Lean 还会尝试「回收」引用计数即将降至零的构造函数，重新使用它们而不是分配新数据。
这意味着，例如，`List.map` 将原地修改链表，至少在无人能注意到的情况下。
优化 Lean 代码中的热循环最重要的步骤之一是确保被修改的数据不会被从多个位置引用。

<!--
## Exercises
-->

## 练习

<!--
 * Write a function that reverses arrays. Test that if the input array has a reference count of one, then your function does not allocate a new array.
-->

 * 编写一个反转数组的函数。测试如果输入数组的引用计数为一，则你的函数不会分配一个新数组。

<!--
 * Implement either merge sort or quicksort for arrays. Prove that your implementation terminates, and test that it doesn't allocate more arrays than expected. This is a challenging exercise!
-->

 * 为数组实现归并排序或快速排序。证明你的实现会停机，并测试它不会分配比预期更多的数组。
   这是一个具有挑战性的练习！
