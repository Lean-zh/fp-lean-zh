<!--
# Arrays and Termination
-->

# 数组与停机性

<!--
To write efficient code, it is important to select appropriate data structures.
Linked lists have their place: in some applications, the ability to share the tails of lists is very important.
However, most use cases for a variable-length sequential collection of data are better served by arrays, which have both less memory overhead and better locality.
-->

为了编写高效的代码，选择合适的数据结构非常重要。链表有它的用途：在某些应用程序中，
共享列表的尾部非常重要。但是，大多数可变长有序数据集合的用例都能由数组更好地提供服务，
数组既有较少的内存开销，又有更好的局部性。

<!--
Arrays, however, have two drawbacks relative to lists:

 1. Arrays are accessed through indexing, rather than by pattern matching, which imposes [proof obligations](../props-proofs-indexing.md) in order to maintain safety.
 2. A loop that processes an entire array from left to right is a tail-recursive function, but it does not have an argument that decreases on each call.
-->

然而，数组相对于列表来说有两个缺点：

 1. 数组是通过索引访问的，而非通过模式匹配，这为维护安全性增加了
    [证明义务](../props-proofs-indexing.md)。
 2. 从左到右处理整个数组的循环是一个尾递归函数，但它没有会在每次调用时递减的参数。

<!--
Making effective use of arrays requires knowing how to prove to Lean that an array index is in bounds, and how to prove that an array index that approaches the size of the array also causes the program to terminate.
Both of these are expressed using an inequality proposition, rather than propositional equality.
-->

高效地使用数组需要知道如何向 Lean 证明数组索引在范围内，
以及如何证明接近数组大小的数组索引也会使程序停机。这两个都使用不等式命题，而非命题等式表示。

<!--
## Inequality
-->

## 不等式

<!--
Because different types have different notions of ordering, inequality is governed by two type classes, called `LE` and `LT`.
The table in the section on [standard type classes](../type-classes/standard-classes.md#equality-and-ordering) describes how these classes relate to the syntax:
-->

由于不同的类型有不同的序概念，不等式需要由两个类来控制，分别称为 `LE` 和 `LT`。
[标准类型类](../type-classes/standard-classes.md#相等性与有序性)
一节中的表格描述了这些类与语法的关系：

<!--
| Expression | Desugaring | Class Name |
-->

| 表达式 | 脱糖结果 | 类名 |
|------------|------------|------------|
| `{{#example_in Examples/Classes.lean ltDesugar}}` | `{{#example_out Examples/Classes.lean ltDesugar}}` | `LT` |
| `{{#example_in Examples/Classes.lean leDesugar}}` | `{{#example_out Examples/Classes.lean leDesugar}}` | `LE` |
| `{{#example_in Examples/Classes.lean gtDesugar}}` | `{{#example_out Examples/Classes.lean gtDesugar}}` | `LT` |
| `{{#example_in Examples/Classes.lean geDesugar}}` | `{{#example_out Examples/Classes.lean geDesugar}}` | `LE` |

<!--
In other words, a type may customize the meaning of the `<` and `≤` operators, while `>` and `≥` derive their meanings from `<` and `≤`.
The classes `LT` and `LE` have methods that return propositions rather than `Bool`s:
-->

换句话说，一个类型可以定制 `<` 和 `≤` 运算符的含义，而 `>` 和 `≥` 可以从
`<` 和 `≤` 中派生它们的含义。`LT` 和 `LE` 类具有返回命题而非 `Bool` 的方法：

```lean
{{#example_decl Examples/ProgramsProofs/Arrays.lean less}}
```

<!--
The instance of `LE` for `Nat` delegates to `Nat.le`:
-->

`Nat` 的 `LE` 实例会委托给 `Nat.le`：

```lean
{{#example_decl Examples/ProgramsProofs/Arrays.lean LENat}}
```

<!--
Defining `Nat.le` requires a feature of Lean that has not yet been presented: it is an inductively-defined relation.
-->

定义 `Nat.le` 需要 Lean 中尚未介绍的一个特性：它是一个归纳定义的关系。

<!--
### Inductively-Defined Propositions, Predicates, and Relations
-->

### 归纳定义的命题、谓词和关系

<!--
`Nat.le` is an _inductively-defined relation_.
Just as `inductive` can be used to create new datatypes, it can also be used to create new propositions.
When a proposition takes an argument, it is referred to as a _predicate_ that may be true for some, but not all, potential arguments.
Propositions that take multiple arguments are called _relations_.
-->

`Nat.le` 是一个 **归纳定义的关系（Inductively-Defined Relation）**。
就像 `inductive` 可以用来创建新的数据类型一样，它也可以用来创建新的命题。
当一个命题接受一个参数时，它被称为 **谓词（Predicate）**，它可能对某些潜在参数为真，
但并非对所有参数都为真。接受多个参数的命题称为 **关系（Relation）**。"

<!--
Each constructor of an inductively defined proposition is a way to prove it.
In other words, the declaration of the proposition describes the different forms of evidence that it is true.
A proposition with no arguments that has a single constructor can be quite easy to prove:
-->

每个归纳定义命题的构造子都是证明它的方法。换句话说，命题的声明描述了它为真的不同形式的证据。
一个没有参数且只有一个构造子的命题很容易证明：

```lean
{{#example_decl Examples/ProgramsProofs/Arrays.lean EasyToProve}}
```

<!--
The proof consists of using its constructor:
-->

证明包括使用其构造子：

```lean
{{#example_decl Examples/ProgramsProofs/Arrays.lean fairlyEasy}}
```

<!--
In fact, the proposition `True`, which should always be easy to prove, is defined just like `EasyToProve`:
-->

实际上，命题 `True` 应该总是很容易证明，它的定义就像 `EasyToProve`：

```lean
{{#example_decl Examples/ProgramsProofs/Arrays.lean True}}
```

<!--
Inductively-defined propositions that don't take arguments are not nearly as interesting as inductively-defined datatypes.
This is because data is interesting in its own right—the natural number `3` is different from the number `35`, and someone who has ordered 3 pizzas will be upset if 35 arrive at their door 30 minutes later.
The constructors of a proposition describe ways in which the proposition can be true, but once a proposition has been proved, there is no need to know _which_ underlying constructors were used.
This is why most interesting inductively-defined types in the `Prop` universe take arguments.
-->

不带参数的归纳定义命题远不如归纳定义的数据类型有趣。
这是因为数据本身很有趣——自然数 `3` 不同于数字 `35`，而订购了 3 个披萨的人如果
30 分钟后收到 35 个披萨会很沮丧。命题的构造子描述了命题可以为真的方式，
但一旦命题被证明，就不需要知道它使用了哪些底层构造子。
这就是为什么 `Prop` 宇宙中最有趣的归纳定义类型带参数的原因。

<!--
The inductively-defined predicate `IsThree` states that its argument is three:
-->

归纳定义谓词 `IsThree` 陈述它有三个参数：

```lean
{{#example_decl Examples/ProgramsProofs/Arrays.lean IsThree}}
```

<!--
The mechanism used here is just like [indexed families such as `HasCol`](../dependent-types/typed-queries.md#column-pointers), except the resulting type is a proposition that can be proved rather than data that can be used.
-->

这里使用的机制就像[索引族，如 `HasCol`](../dependent-types/typed-queries.md#列指针)，
只不过结果类型是一个可以被证明的命题，而非可以被使用的数据。

<!--
Using this predicate, it is possible to prove that three is indeed three:
-->

使用此谓词，可以证明三确实等于三：

```lean
{{#example_decl Examples/ProgramsProofs/Arrays.lean threeIsThree}}
```

<!--
Similarly, `IsFive` is a predicate that states that its argument is `5`:
-->

类似地，`IsFive` 是一个谓词，它陈述了其参数为 `5`：

```lean
{{#example_decl Examples/ProgramsProofs/Arrays.lean IsFive}}
```

<!--
If a number is three, then the result of adding two to it should be five.
This can be expressed as a theorem statement:
-->

如果一个数字是三，那么将它加二的结果应该是五。这可以表示为定理陈述：

```leantac
{{#example_in Examples/ProgramsProofs/Arrays.lean threePlusTwoFive0}}
```

<!--
The resulting goal has a function type:
-->

由此产生的目标具有函数类型：

```output error
{{#example_out Examples/ProgramsProofs/Arrays.lean threePlusTwoFive0}}
```

<!--
Thus, the `intro` tactic can be used to convert the argument into an assumption:
-->

因此，`intro` 策略可用于将参数转换为假设：

```leantac
{{#example_in Examples/ProgramsProofs/Arrays.lean threePlusTwoFive1}}
```

```output error
{{#example_out Examples/ProgramsProofs/Arrays.lean threePlusTwoFive1}}
```

<!--
Given the assumption that `n` is three, it should be possible to use the constructor of `IsFive` to complete the proof:
-->

假设 `n` 为三，则应该可以使用 `IsFive` 的构造子来完成证明：

```leantac
{{#example_in Examples/ProgramsProofs/Arrays.lean threePlusTwoFive1a}}
```

<!--
However, this results in an error:
-->

然而，这会产生一个错误：

```output error
{{#example_out Examples/ProgramsProofs/Arrays.lean threePlusTwoFive1a}}
```

<!--
This error occurs because `n + 2` is not definitionally equal to `5`.
In an ordinary function definition, dependent pattern matching on the assumption `three` could be used to refine `n` to `3`.
The tactic equivalent of dependent pattern matching is `cases`, which has a syntax similar to that of `induction`:
-->

出现此错误是因为 `n + 2` 与 `5` 在定义上不相等。在普通的函数定义中，
可以对假设 `three` 使用依值模式匹配来将 `n` 细化为 `3`。
依值模式匹配的策略等价为 `cases`，其语法类似于 `induction`：

```leantac
{{#example_in Examples/ProgramsProofs/Arrays.lean threePlusTwoFive2}}
```

<!--
In the remaining case, `n` has been refined to `3`:
-->

在剩余情况下，`n` 已细化为 `3`：

```output error
{{#example_out Examples/ProgramsProofs/Arrays.lean threePlusTwoFive2}}
```

<!--
Because `3 + 2` is definitionally equal to `5`, the constructor is now applicable:
-->

由于 `3 + 2` 在定义上等于 `5`，因此构造子现在适用了：

```leantac
{{#example_decl Examples/ProgramsProofs/Arrays.lean threePlusTwoFive3}}
```

<!--
The standard false proposition `False` has no constructors, making it impossible to provide direct evidence for.
The only way to provide evidence for `False` is if an assumption is itself impossible, similarly to how `nomatch` can be used to mark code that the type system can see is unreachable.
As described in [the initial Interlude on proofs](../props-proofs-indexing.md#connectives), the negation `Not A` is short for `A → False`.
`Not A` can also be written `¬A`.
-->

标准假命题 `False` 没有构造子，因此无法提供直接证据。
为 `False` 提供证据的唯一方法是假设本身不可能，类似于用 `nomatch`
来标记类型系统认为无法访问的代码。如 [插曲中的证明一节](../props-proofs-indexing.md#连词)
所述，否定 `Not A` 是 `A → False` 的缩写。`Not A` 也可以写成 `¬A`。

<!--
It is not the case that four is three:
-->

四不是三：

```leantac
{{#example_in Examples/ProgramsProofs/Arrays.lean fourNotThree0}}
```

<!--
The initial proof goal contains `Not`:
-->

初始证明目标包含 `Not`：

```output error
{{#example_out Examples/ProgramsProofs/Arrays.lean fourNotThree0}}
```

<!--
The fact that it's actually a function type can be exposed using `simp`:
-->

可以使用 `simp` 显示出它实际上是一个函数类型：

```leantac
{{#example_in Examples/ProgramsProofs/Arrays.lean fourNotThree1}}
```

```output error
{{#example_out Examples/ProgramsProofs/Arrays.lean fourNotThree1}}
```

<!--
Because the goal is a function type, `intro` can be used to convert the argument into an assumption.
There is no need to keep `simp`, as `intro` can unfold the definition of `Not` itself:
-->

因为目标是一个函数类型，所以 `intro` 可用于将参数转换为假设。
无需保留 `simp`，因为 `intro` 可以展开 `Not` 本身的定义：

```leantac
{{#example_in Examples/ProgramsProofs/Arrays.lean fourNotThree2}}
```

```output error
{{#example_out Examples/ProgramsProofs/Arrays.lean fourNotThree2}}
```

<!--
In this proof, the `cases` tactic solves the goal immediately:
-->

在此证明中，`cases` 策略直接解决了目标：

```leantac
{{#example_decl Examples/ProgramsProofs/Arrays.lean fourNotThreeDone}}
```

<!--
Just as a pattern match on a `Vect String 2` doesn't need to include a case for `Vect.nil`, a proof by cases over `IsThree 4` doesn't need to include a case for `isThree`.
-->

就像对 `Vect String 2` 的模式匹配不需要包含 `Vect.nil` 的情况一样，
对 `IsThree 4` 的情况证明不需要包含 `isThree` 的情况。

<!--
### Inequality of Natural Numbers
-->

### 自然数不等式

<!--
The definition of `Nat.le` has a parameter and an index:
-->

`Nat.le` 的定义有一个参数和一个索引：

```lean
{{#example_decl Examples/ProgramsProofs/Arrays.lean NatLe}}
```

<!--
The parameter `n` is the number that should be smaller, while the index is the number that should be greater than or equal to `n`.
The `refl` constructor is used when both numbers are equal, while the `step` constructor is used when the index is greater than `n`.
-->

参数 `n` 应该是较小的数字，而索引应该是大于或等于 `n` 的数字。
当两个数字相等时使用 `refl` 构造子，而当索引大于 `n` 时使用 `step` 构造子。

<!--
From the perspective of evidence, a proof that \\( n \leq k \\) consists of finding some number \\( d \\) such that \\( n + d = m \\).
In Lean, the proof then consists of a `Nat.le.refl` constructor wrapped by \\( d \\) instances of `Nat.le.step`.
Each `step` constructor adds one to its index argument, so \\( d \\) `step` constructors adds \\( d \\) to the larger number.
For example, evidence that four is less than or equal to seven consists of three `step`s around a `refl`:
-->

从证据的视角来看，证明 \\( n \leq k \\) 需要找到一些数字 \\( d \\) 使得 \\( n + d = m \\)。
在 Lean 中，证明由 \\( d \\) 个 `Nat.le.step` 实例包裹的 `Nat.le.refl` 构造子组成。
每个 `step` 构造子将其索引参数加一，因此 \\( d \\) 个 `step` 构造子将 \\( d \\) 加到较大的数字上。
例如，证明四小于或等于七由 `refl` 周围的三个 `step` 组成：

```lean
{{#example_decl Examples/ProgramsProofs/Arrays.lean four_le_seven}}
```

<!--
The strict less-than relation is defined by adding one to the number on the left:
-->

严格小于关系通过在左侧数字上加一来定义：

```lean
{{#example_decl Examples/ProgramsProofs/Arrays.lean NatLt}}
```

<!--
Evidence that four is strictly less than seven consists of two `step`'s around a `refl`:
-->

证明四严格小于七由 `refl` 周围的两个 `step` 组成：

```lean
{{#example_decl Examples/ProgramsProofs/Arrays.lean four_lt_seven}}
```

<!--
This is because `4 < 7` is equivalent to `5 ≤ 7`.
-->

这是因为 `4 < 7` 等价于 `5 ≤ 7`。

<!--
## Proving Termination
-->

## 停机性证明

<!--
The function `Array.map` transforms an array with a function, returning a new array that contains the result of applying the function to each element of the input array.
Writing it as a tail-recursive function follows the usual pattern of delegating to a function that passes the output array in an accumulator.
The accumulator is initialized with an empty array.
The accumulator-passing helper function also takes an argument that tracks the current index into the array, which starts at `0`:
-->

函数 `Array.map` 接受一个函数和一个数组，它将接受的函数应用于输入数组的每个元素后，返回产生的新数组。
将其写成尾递归函数遵循通常的累加器模式，即将输入委托给一个函数，该函数将输出的数组传递给累加器。
累加器用空数组初始化。传递累加器的辅助函数还接受一个参数来跟踪数组中的当前索引，该索引从 `0` 开始：

```lean
{{#example_decl Examples/ProgramsProofs/Arrays.lean ArrayMap}}
```

<!--
The helper should, at each iteration, check whether the index is still in bounds.
If so, it should loop again with the transformed element added to the end of the accumulator and the index incremented by `1`.
If not, then it should terminate and return the accumulator.
An initial implementation of this code fails because Lean is unable to prove that the array index is valid:
-->

辅助函数应在每次迭代时检查索引是否仍在范围内。如果是，则应再次循环，
将转换后的元素添加到累加器的末尾，并将索引加 `1`。如果不是，则应终止并返回累加器。
此代码的最初实现会失败，因为 Lean 无法证明数组索引有效：

```lean
{{#example_in Examples/ProgramsProofs/Arrays.lean mapHelperIndexIssue}}
```

```output error
{{#example_out Examples/ProgramsProofs/Arrays.lean mapHelperIndexIssue}}
```

<!--
However, the conditional expression already checks the precise condition that the array index's validity demands (namely, `i < arr.size`).
Adding a name to the `if` resolves the issue, because it adds an assumption that the array indexing tactic can use:
-->

然而，条件表达式已经检查了有效数组索引所要求的精确条件（即 `i < arr.size`）。
为 `if` 添加一个名称可以解决此问题，因为它添加了一个前提供数组索引策略使用：

```lean
{{#example_in Examples/ProgramsProofs/Arrays.lean arrayMapHelperTermIssue}}
```

<!--
Lean does not, however, accept the modified program, because the recursive call is not made on an argument to one of the input constructors.
In fact, both the accumulator and the index grow, rather than shrinking:
-->

然而，Lean 不接受修改后的程序，因为递归调用不是针对输入构造子之一的参数进行的。
实际上，累加器和索引都在增长，而非缩小：

```output error
{{#example_out Examples/ProgramsProofs/Arrays.lean arrayMapHelperTermIssue}}
```

<!--
Nevertheless, this function terminates, so simply marking it `partial` would be unfortunate.
-->

尽管如此，此函数仍然会停机，因此简单地将其标记为 `partial` 非常不妥。

<!--
Why does `arrayMapHelper` terminate?
Each iteration checks whether the index `i` is still in bounds for the array `arr`.
If so, `i` is incremented and the loop repeats.
If not, the program terminates.
Because `arr.size` is a finite number, `i` can be incremented only a finite number of times.
Even though no argument to the function decreases on each call, `arr.size - i` decreases toward zero.
-->

为什么 `arrayMapHelper` 会停机？每次迭代都会检查索引 `i` 是否仍在数组 `arr` 的范围内。
如果是，则 `i` 将增加并且循环将重复。如果不是，则程序将停机。因为 `arr.size` 是一个有限数，
所以 `i` 只可以增加有限次。即使函数的每个参数在每次调用时都不会减少，`arr.size - i` 也会减小到零。

<!--
Lean can be instructed to use another expression for termination by providing a `termination_by` clause at the end of a definition.
The `termination_by` clause has two components: names for the function's arguments and an expression using those names that should decrease on each call.
For `arrayMapHelper`, the final definition looks like this:
-->

可以通过在定义的末尾提供 `termination_by` 子句来指示 Lean 使用另一个表达式判定停机。
`termination_by` 子句有两个组成部分：函数参数的名称和使用这些名称的表达式，
该表达式应在每次调用时减少。对于 `arrayMapHelper`，最终定义如下所示：

```lean
{{#example_decl Examples/ProgramsProofs/Arrays.lean ArrayMapHelperOk}}
```

<!--
A similar termination proof can be used to write `Array.find`, a function that finds the first element in an array that satisfies a Boolean function and returns both the element and its index:
-->

类似的停机证明可用于编写 `Array.find`，这是一个在数组中查找满足布尔函数的第一个元素，
并返回该元素及其索引的函数：

```lean
{{#example_decl Examples/ProgramsProofs/Arrays.lean ArrayFind}}
```

<!--
Once again, the helper function terminates because `arr.size - i` decreases as `i` increases:
-->

同样，辅助函数会停机，因为随着 `i` 的增加，`arr.size - i` 会减少：

```lean
{{#example_decl Examples/ProgramsProofs/Arrays.lean ArrayFindHelper}}
```

<!--
Not all termination arguments are as quite as simple as this one.
However, the basic structure of identifying some expression based on the function's arguments that will decrease in each call occurs in all termination proofs.
Sometimes, creativity can be required in order to figure out just why a function terminates, and sometimes Lean requires additional proofs in order to accept the termination argument.
-->

并非所有停机参数都像这个参数一样简单。但是，在所有停机证明中，
都会出现「基于函数的参数找出在每次调用时都会减少的某个表达式」这种基本结构。
有时，为了弄清楚函数为何停机，可能需要一点创造力，有时 Lean 需要额外的证明才能接受停机参数。

<!--
## Exercises
-->

## 练习

<!--
 * Implement a `ForM (Array α)` instance on arrays using a tail-recursive accumulator-passing function and a `termination_by` clause.
 * Implement a function to reverse arrays using a tail-recursive accumulator-passing function that _doesn't_ need a `termination_by` clause.
 * Reimplement `Array.map`, `Array.find`, and the `ForM` instance using `for ... in ...` loops in the identity monad and compare the resulting code.
 * Reimplement array reversal using a `for ... in ...` loop in the identity monad. Compare it to the tail-recursive function.
-->

 * 使用尾递归累加器传递函数和 `termination_by` 子句在数组上实现 `ForM (Array α)` 实例。
 * 使用 **不需要** `termination_by` 子句的尾递归累加器传递函数实现一个用于反转数组的函数。
 * 使用恒等单子中的 `for ... in ...` 循环重新实现 `Array.map`、`Array.find` 和 `ForM` 实例，
   并比较结果代码。
 * 使用恒等单子中的 `for ... in ...` 循环重新实现数组反转。将其与尾递归函数的版本进行比较。
