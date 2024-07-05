<!--
# Summary
-->

# 总结

<!--
## Tail Recursion
-->

## 尾递归

<!--
Tail recursion is recursion in which the results of recursive calls are returned immediately, rather than being used in some other way.
These recursive calls are called _tail calls_.
Tail calls are interesting because they can be compiled to a jump instruction rather than a call instruction, and the current stack frame can be re-used instead of pushing a new frame.
In other words, tail-recursive functions are actually loops.
-->

尾递归是一种递归，其中递归调用的结果会立即返回，而非以其他方式使用。
这些递归调用称为「尾调用」。尾调用很有趣，因为它们可以编译成跳转指令而非调用指令，
并且可以重新使用当前栈帧，而非压入新的一帧。换句话说，尾递归函数实际上就是循环。

<!--
A common way to make a recursive function faster is to rewrite it in accumulator-passing style.
Instead of using the call stack to remember what is to be done with the result of a recursive call, an additional argument called an _accumulator_ is used to collect this information.
For example, an accumulator for a tail-recursive function that reverses a list contains the already-seen list entries, in reverse order.
-->

使递归函数更快的常用方法是使用累加器传递风格对其进行重写。
它不使用调用栈来记住如何处理递归调用的结果，而是使用一个名为「累加器」的附加参数来收集此信息。
例如，用于反转列表的尾递归函数的累加器按相反顺序包含已经处理过的列表项。

<!--
In Lean, only self-tail-calls are optimized into loops.
In other words, two functions that each end with a tail call to the other will not be optimized.
-->

在 Lean 中，只有自尾调用（self-tail-call）会被优化为循环。
换句话说，两个以互相尾调用结束的函数不会被优化。

<!--
## Reference Counting and In-Place Updates
-->

## 引用计数与原地更新

<!--
Rather than using a tracing garbage collector, as is done in Java, C#, and most JavaScript implementations, Lean uses reference counting for memory management.
This means that each value in memory contains a field that tracks how many other values refer to it, and the run-time system maintains these counts as references appear or disappear.
Reference counting is also used in Python, PHP, and Swift.
-->

与 Java、C# 和大多数 JavaScript 实现中那样使用跟踪垃圾收集器不同，
Lean 使用引用计数进行内存管理。这意味着内存中的每个值都包含一个字段，
该字段跟踪引用它的其他值的数量，并且运行时系统在引用出现或消失时维护这些计数。
引用计数也用在了 Python、PHP 和 Swift 中。

<!--
When asked to allocate a fresh object, Lean's run-time system is able to recycle existing objects whose reference counts are falling to zero.
Additionally, array operations such as `Array.set` and `Array.swap` will mutate an array if its reference count is one, rather than allocating a modified copy.
If `Array.swap` holds the only reference to an array, then no other part of the program can tell that it was mutated rather than copied.
-->

当要求分配一个新对象时，Lean 的运行时系统能够回收引用计数降为零的现有对象。
此外，如果数组的引用计数为一，则数组操作（如 `Array.set` 和 `Array.swap`）将修改原数组，
而非分配一个修改后的副本。如果 `Array.swap` 持有对数组的唯一引用，
那么程序的其他部分就无法分辨它是被改变了还是被复制了。

<!--
Writing efficient code in Lean requires the use of tail recursion and being careful to ensure that large arrays are used uniquely.
While tail calls can be identified by inspecting the function's definition, understanding whether a value is referred to uniquely may require reading the whole program.
The debugging helper `dbgTraceIfShared` can be used at key locations in the program to check that a value is not shared.
-->

在 Lean 中编写高效的代码需要使用尾递归，并小心确保大数组被唯一使用。
虽然可以通过检查函数的定义来识别尾调用，但了解一个值是否被唯一引用可能需要阅读整个程序。
调试辅助函数 `dbgTraceIfShared` 可以用在程序的关键位置来检查一个值是否被共享。

<!--
## Proving Programs Correct
-->

## 证明程序的正确性

<!--
Rewriting a program in accumulator-passing style, or making other transformations that make it run faster, can also make it more difficult to understand.
It can be useful to keep the original version of the program that is more clearly correct, and then use it as an executable specification for the optimized version.
While techniques such as unit testing work just as well in Lean as in any other language, Lean also enables the use of mathematical proofs that completely ensure that both versions of the function return the same result for _all possible_ inputs.
-->

以累加器传递样式重写程序，或进行其他使程序运行更快的转换，也可能会让程序更难理解。
保留程序的原始版本（正确性更加明显）是有用的，然后将其用作优化版本的可执行规范。
虽然单元测试等技术在 Lean 中与在任何其他语言中一样有效，
但 Lean 还允许使用数学证明来完全确保函数的两个版本对 **所有** 可能的输入返回相同的结果。

<!--
Typically, proving that two functions are equal is done using function extensionality (the `funext` tactic), which is the principle that two functions are equal if they return the same values for every input.
If the functions are recursive, then induction is usually a good way to prove that their outputs are the same.
Usually, the recursive definition of the function will make recursive calls on one particular argument; this argument is a good choice for induction.
In some cases, the induction hypothesis is not strong enough.
Fixing this problem usually requires thought about how to construct a more general version of the theorem statement that provides induction hypotheses that are strong enough.
In particular, to prove that a function is equivalent to an accumulator-passing version, a theorem statement that relates arbitrary initial accumulator values to the final result of the original function is needed.
-->

通常，证明两个函数相等是使用函数外延性（`funext` 策略）完成的，
即如果两个函数对每个输入返回相同的值，则它们相等。如果函数是递归的，
那么归纳法通常是证明其输出相同的好方法。通常，函数的递归定义将对一个特定参数进行递归调用；
这个参数是归纳的一个好选择。在某些情况下，归纳假设不够充分。
解决这个问题通常需要考虑如何构建定理陈述的更通用版本，以提供足够充分的归纳假设。
特别是，为了证明一个函数等价于一个累加器传递版本，
需要一个将任意初始累加器值与原始函数的最终结果联系起来的定理陈述。

<!--
## Safe Array Indices
-->

## 安全的数组索引

<!--
The type `Fin n` represents natural numbers that are strictly less than `n`.
`Fin` is short for "finite".
As with subtypes, a `Fin n` is a structure that contains a `Nat` and a proof that this `Nat` is less than `n`.
There are no values of type `Fin 0`.
-->

类型 `Fin n` 表示严格小于 `n` 的自然数。`Fin` 是「有限」的缩写。
与子类型一样，`Fin n` 是一个包含 `Nat` 和证明这个 `Nat` 小于 `n` 的结构体。
不存在类型为 `Fin 0` 的值。

<!--
If `arr` is an `Array α`, then `Fin arr.size` always contains a number that is a suitable index into `arr`.
Many of the built-in array operators, such as `Array.swap`, take `Fin` values as arguments rather than separated proof objects.
-->

如果 `arr` 是一个 `Array α`，那么 `Fin arr.size` 总是包含一个适合作为 `arr` 索引的数字。
许多内置数组运算符（例如 `Array.swap`）会将 `Fin` 值作为参数，而非独立的证明对象。

<!--
Lean provides instances of most of the useful numeric type classes for `Fin`.
The `OfNat` instances for `Fin` perform modular arithmetic rather than failing at compile time if the number provided is larger than the `Fin` can accept.
-->

Lean 为 `Fin` 提供了大多数有用的数字类型类的实例。`Fin` 的 `OfNat` 实例会执行模运算，
而非在提供的数字大于 `Fin` 可接受的数字时在编译时失败。

<!--
## Provisional Proofs
-->

## 临时性证明

<!--
Sometimes, it can be useful to pretend that a statement is proved without actually doing the work of proving it.
This can be useful when making sure that a proof of a statement would be suitable for some task, such as a rewrite in another proof, determining that an array access is safe, or showing that a recursive call is made on a smaller value than the original argument.
It's very frustrating to spend time proving something, only to discover that some other proof would have been more useful.
-->

有时，当某个陈述实际上尚未被证明，而假装它已被证明是有用的。
这在确保一个陈述的证明是否适用于某些任务时很有用，例如在另一个证明中重写、
确定数组访问是否安全、或显示递归调用是在比原始参数更小的值上进行的。
花时间证明某件事，却发现其他一些证明更有用，这是非常令人沮丧的。

<!--
The `sorry` tactic causes Lean to provisionally accept a statement as if it were a real proof.
It can be seen as analogous to a stub method that throws a `NotImplementedException` in C#.
Any proof that relies on `sorry` includes a warning in Lean.
-->

`sorry` 策略使 Lean 临时接受一个陈述，就好像它是真正的证明一样。
它可以看作类似于在 C# 中抛出 `NotImplementedException` 的桩（stub）方法。
任何依赖于 `sorry` 的证明都会在 Lean 中包含一个警告。

<!--
Be careful!
The `sorry` tactic can prove _any_ statement, even false statements.
Proving that `3 < 2` can cause an out-of-bounds array access to persist to runtime, unexpectedly crashing a program.
Using `sorry` is convenient during development, but keeping it in the code is dangerous.
-->

小心！`sorry` 策略可以证明 **任何** 陈述，甚至是错误的陈述。
证明 `3 < 2` 可能会导致数组越界访问持续到运行时，意外地使程序崩溃。
在开发过程中使用 `sorry` 很方便，但将其保留在代码中很危险。

<!--
## Proving Termination
-->

## 停机证明

<!--
When a recursive function does not use structural recursion, Lean cannot automatically determine that it terminates.
In these situations, the function could just be marked `partial`.
However, it is also possible to provide a proof that the function terminates.
-->

当一个递归函数不使用结构体递归时，Lean 无法自动确定它是否停机。
在这些情况下，该函数可以用 `partial` 标记为偏函数。但是，也可以提供证明函数停机的证明。

<!--
Partial functions have a key downside: they can't be unfolded during type checking or in proofs.
This means that Lean's value as an interactive theorem prover can't be applied to them.
Additionally, showing that a function that is expected to terminate actually always does terminate removes one more potential source of bugs.
-->

偏函数有一个关键的缺点：它们不能在类型检查或证明中展开。
这意味着 Lean 作为交互式定理证明器的价值不能应用于它们。
此外，证明一个预期停机的函数实际上总是停机，可以消除更多潜在的 bug 来源。

<!--
The `termination_by` clause that's allowed at the end of a function can be used to specify the reason why a recursive function terminates.
The clause maps the function's arguments to an expression that is expected to be smaller for each recursive call.
Some examples of expressions that might decrease are the difference between a growing index into an array and the array's size, the length of a list that's cut in half at each recursive call, or a pair of lists, exactly one of which shrinks on each recursive call.
-->

递归函数末尾允许的 `termination_by` 子句可用于指定递归函数停机的原因。
该子句将函数的参数映射到一个表达式，该表达式预期在每次递归调用时都会变小。
可能减小的表达式的示例包括不断增长的数组索引与数组大小之间的差、
每次递归调用时减半的列表长度，或一对列表，其中恰好一个在每次递归调用时都会缩小。

<!--
Lean contains proof automation that can automatically determine that some expressions shrink with each call, but many interesting programs will require manual proofs.
These proofs can be provided with `have`, a version of `let` that's intended for locally providing proofs rather than values.
-->

Lean 包含的证明自动化可以自动确定某些表达式在每次调用时都会缩小，但许多有趣的程序需要手动证明。
这些证明可以使用 `have` 提供，`have` 是 `let` 的一个版本，旨在局部提供证明而非值。

<!--
A good way to write recursive functions is to begin by declaring them `partial` and debugging them with testing until they return the right answers.
Then, `partial` can be removed and replaced with a `termination_by` clause.
Lean will place error highlights on each recursive call for which a proof is needed that contains the statement that needs to be proved.
Each of these statements can be placed in a `have`, with the proof being `sorry`.
If Lean accepts the program and it still passes its tests, the final step is to actually prove the theorems that enable Lean to accept it.
This approach can prevent wasting time on proving that a buggy program terminates.
-->

编写递归函数的一个好方法是从声明它们为 `partial` 开始，并通过测试调试它们，
直到它们返回正确的答案。然后，可以删除 `partial` 并用 `termination_by` 子句替换它。
Lean 会在需要证明的每个递归调用上放置错误高亮，其中包含需要证明的语句。
每个这样的语句都可以放在 `have` 中，证明为 `sorry`。
如果 Lean 接受该程序并且它仍然通过测试，最后一步就是实际证明使 Lean 接受它的定理。
这种方法可以防止浪费时间来证明一个有缺陷的程序的停机性。
