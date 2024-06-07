<!--
## Example: Arithmetic in Monads
-->

## 例子：利用单子实现算术表达式求值

<!--
Monads are a way of encoding programs with side effects into a language that does not have them.
It would be easy to read this as a sort of admission that pure functional programs are missing something important, requiring programmers to jump through hoops just to write a normal program.
However, while using the `Monad` API does impose a syntactic cost on a program, it brings two important benefits:
 1. Programs must be honest about which effects they use in their types. A quick glance at a type signature describes _everything_ that the program can do, rather than just what it accepts and what it returns.
 2. Not every language provides the same effects. For example, only some language have exceptions. Other languages have unique, exotic effects, such as [Icon's searching over multiple values](https://www2.cs.arizona.edu/icon/) and Scheme or Ruby's continuations. Because monads can encode _any_ effect, programmers can choose which ones are the best fit for a given application, rather than being stuck with what the language developers provided.
-->

单子是一种将具有副作用的程序编入没有副作用的语言中的范式。
但很容易将此误解为：承认纯函数式编程缺少一些重要的东西，程序员要越过这些障碍才能编写一个普通的程序。
虽然使用`Monad`确实给程序带来了语法上的成本，但它带来了两个重要的优点：
 1. 程序必须在类型中诚实地告知它们使用的效应(Effects)。因此看一眼类型签名就可以知道程序能做的所有事情，而不只是知道它接受什么和返回什么。
 2. 并非每种语言都提供相同的效应。例如只有某些语言有异常。其他语言具有独特的新奇效应，例如 [Icon's searching over multiple values](https://www2.cs.arizona.edu/icon/)以及Scheme 或Ruby的continuations。由于单子可以编码 **任何** 效应，因此程序员可以选择最适合给定程序的效应，而不是局限于语言开发者提供的效应。

<!--
One example of a program that can make sense in a variety of monads is an evaluator for arithmetic expressions.
-->

对许多单子都有意义的一个例子是算术表达式的求值器。

<!--
### Arithmetic Expressions
-->

### 算术表达式

<!--
An arithmetic expression is either a literal integer or a primitive binary operator applied to two expressions. The operators are addition, subtraction, multiplication, and division:
-->

一条算术表达式要么是一个字面量(Literal)，要么是应用于两个算术表达式的二元运算。运算符包括加法、减法、乘法和除法：
```lean
{{#example_decl Examples/Monads/Class.lean ExprArith}}
```
<!--
The expression `2 + 3` is represented:
-->

表达式 `2 + 3` 表示为：
```lean
{{#example_decl Examples/Monads/Class.lean twoPlusThree}}
```
<!--
and `14 / (45 - 5 * 9)` is represented:
-->

而 `14 / (45 - 5 * 9)` 表示为：
```lean
{{#example_decl Examples/Monads/Class.lean exampleArithExpr}}
```

<!--
### Evaluating Expressions
-->

### 对表达式求值

<!--
Because expressions include division, and division by zero is undefined, evaluation might fail.
One way to represent failure is to use `Option`:
-->

由于表达式包含除法，而除以零是未定义的，因此求值可能会失败。
表示失败的一种方法是使用`Option`：
```lean
{{#example_decl Examples/Monads/Class.lean evaluateOptionCommingled}}
```
<!--
This definition uses the `Monad Option` instance to propagate failures from evaluating both branches of a binary operator.
However, the function mixes two concerns: evaluating subexpressions and applying a binary operator to the results.
It can be improved by splitting it into two functions:
-->

此定义使用`Monad Option`实例，来传播从二元运算符的两个分支求值产生的失败。
然而该函数混合了两个问题：对子表达式的求值和对运算符的计算。
可以将其拆分为两个函数：
```lean
{{#example_decl Examples/Monads/Class.lean evaluateOptionSplit}}
```

<!--
Running `{{#example_in Examples/Monads/Class.lean fourteenDivOption}}` yields `{{#example_out Examples/Monads/Class.lean fourteenDivOption}}`, as expected, but this is not a very useful error message.
Because the code was written using `>>=` rather than by explicitly handling the `none` constructor, only a small modification is required for it to provide an error message on failure:
-->

运行 `{{#example_in Examples/Monads/Class.lean fourteenDivOption}}` 产生 `{{#example_out Examples/Monads/Class.lean fourteenDivOption}}`, 与预期一样, 但这个报错信息却并不十分有用.
由于代码使用`>>=`而非显式处理`none`，所以只需少量修改即可在失败时提供错误消息：
```lean
{{#example_decl Examples/Monads/Class.lean evaluateExcept}}
```
<!--
The only difference is that the type signature mentions `Except String` instead of `Option`, and the failing case uses `Except.error` instead of `none`.
By making `evaluate` polymorphic over its monad and passing it `applyPrim` as an argument, a single evaluator becomes capable of both forms of error reporting:
-->

唯一区别是：类型签名提到的是`Except String`而非`Option`，并且失败时使用`Except.error`而不是`none`。
通过让`evaluate`对单子多态，并将对应的求值函数作为参数`applyPrim`传递，单个求值器就足够以两种形式报告错误：
```lean
{{#example_decl Examples/Monads/Class.lean evaluateM}}
```
<!--
Using it with `applyPrimOption` works just like the first version of `evaluate`:
-->

将其与`applyPrimOption`一起使用效应就和最初的`evaluate`一样：
```lean
{{#example_in Examples/Monads/Class.lean evaluateMOption}}
```
```output info
{{#example_out Examples/Monads/Class.lean evaluateMOption}}
```
<!--
Similarly, using it with `applyPrimExcept` works just like the version with error messages:
-->

类似地，和`applyPrimExcept`函数一起使用时效应与带有错误消息的版本相同：
```lean
{{#example_in Examples/Monads/Class.lean evaluateMExcept}}
```
```output info
{{#example_out Examples/Monads/Class.lean evaluateMExcept}}
```

<!--
The code can still be improved.
The functions `applyPrimOption` and `applyPrimExcept` differ only in their treatment of division, which can be extracted into another parameter to the evaluator:
-->

代码仍有改进空间。
`applyPrimOption`和`applyPrimExcept`函数仅在除法处理上有所不同，因此可以将它提取到另一个参数中：
```lean
{{#example_decl Examples/Monads/Class.lean evaluateMRefactored}}
```

<!--
In this refactored code, the fact that the two code paths differ only in their treatment of failure has been made fully apparent.
-->

在重构后的代码中，两条路径仅在对失败情况的处理上有所不同，这一事实显而易见。

<!--
### Further Effects
-->

### 额外的效应

<!--
Failure and exceptions are not the only kinds of effects that can be interesting when working with an evaluator.
While division's only side effect is failure, adding other primitive operators to the expressions make it possible to express other effects.
-->

在考虑求值器时，失败和异常并不是唯一值得在意的效应。虽然除法的唯一副作用是失败，但若要增加其他运算符的支持，则可能需要表达对应的效应。

<!--
The first step is an additional refactoring, extracting division from the datatype of primitives:
-->

第一步是重构，从原始数据类型中提取除法：
```lean
{{#example_decl Examples/Monads/Class.lean PrimCanFail}}
```
<!--
The name `CanFail` suggests that the effect introduced by division is potential failure.
-->

名称`CanFail`表明被除法引入的效应是可能发生的失败。

<!--
The second step is to broaden the scope of the division handler argument to `evaluateM` so that it can process any special operator:
-->

第二步是将`evaluateM`的作为除法计算的参数扩展，以便它可以处理任何特殊运算符：
```lean
{{#example_decl Examples/Monads/Class.lean evaluateMMorePoly}}
```

<!--
#### No Effects
-->

#### 无效应

<!--
The type `Empty` has no constructors, and thus no values, like the `Nothing` type in Scala or Kotlin.
In Scala and Kotlin, `Nothing` can represent computations that never return a result, such as functions that crash the program, throw exceptions, or always fall into infinite loops.
An argument to a function or method of type `Nothing` indicates dead code, as there will never be a suitable argument value.
Lean doesn't support infinite loops and exceptions, but `Empty` is still useful as an indication to the type system that a function cannot be called.
Using the syntax `nomatch E` when `E` is an expression whose type has no constructors indicates to Lean that the current expression need not return a result, because it could never have been called.
-->

`Empty`类型没有构造子，因此没有任何取值，就像Scala或Kotlin中的`Nothing`类型。
在Scala和Kotlin中，返回类型为`Nothing`表示永不返回结果的计算，例如导致程序崩溃、或引发异常、或陷入无限循环的函数。
参数类型为`Nothing`表示函数是死代码，因为我们永远无法构造出合适的参数值来调用它。
Lean 不支持无限循环和异常，但`Empty`仍然可作为向类型系统说明函数不可被调用的标志。
当`E`是一条表达式，但它的类型没有任何取值时，使用`nomatch E`向Lean说明当前表达式不返回结果，因为它永远不会被调用。

<!--
Using `Empty` as the parameter to `Prim` indicates that there are no additional cases beyond `Prim.plus`, `Prim.minus`, and `Prim.times`, because it is impossible to come up with a value of type `Empty` to place in the `Prim.other` constructor.
Because a function to apply an operator of type `Empty` to two integers can never be called, it doesn't need to return a result.
Thus, it can be used in _any_ monad:
-->

将`Empty`用作`Prim`的参数，表示除了`Prim.plus`、`Prim.minus`和`Prim.times`之外没有其他情况，因为不可能找到一个`Empty`类型的值来放在`Prim.other`构造子中。
由于类型为`Empty`的运算符应用于两个整数的函数永远不会被调用，所以它不需要返回结果。
因此，它可以在 **任何** 单子中使用：
```lean
{{#example_decl Examples/Monads/Class.lean applyEmpty}}
```
<!--
This can be used together with `Id`, the identity monad, to evaluate expressions that have no effects whatsoever:
-->

这可以与恒等单子`Id`一起使用，用来计算没有任何副作用的表达式：
```lean
{{#example_in Examples/Monads/Class.lean evalId}}
```
```output info
{{#example_out Examples/Monads/Class.lean evalId}}
```

<!--
#### Nondeterministic Search
-->

#### 非确定性搜索

<!--
Instead of simply failing when encountering division by zero, it would also be sensible to backtrack and try a different input.
Given the right monad, the very same `evaluateM` can perform a nondeterministic search for a _set_ of answers that do not result in failure.
This requires, in addition to division, some means of specifying a choice of results.
One way to do this is to add a function `choose` to the language of expressions that instructs the evaluator to pick either of its arguments while searching for non-failing results.
-->

遇到除以零时，除了直接失败并结束之外，还可以回溯并尝试不同的输入。
给定适当的单子，同一个`evaluateM`可以对不致失败的答案 **集合** 执行非确定性搜索。
这要求除了除法之外，还需要指定选择结果的方式。
一种方法是在表达式的语言中添加一个函数`choose`，告诉求值器在搜索非失败结果时选择其中一个参数。

<!--
The result of the evaluator is now a multiset of values, rather than a single value.
The rules for evaluation into a multiset are:
 * Constants \\( n \\) evaluate to singleton sets \\( \{n\} \\).
 * Arithmetic operators other than division are called on each pair from the Cartesian product of the operators, so \\( X + Y \\) evaluates to \\( \\{ x + y \\mid x ∈ X, y ∈ Y \\} \\).
 * Division \\( X / Y \\) evaluates to \\( \\{ x / y \\mid x ∈ X, y ∈ Y, y ≠ 0\\} \\). In other words, all \\( 0 \\) values in \\( Y \\)  are thrown out.
 * A choice \\( \\mathrm{choose}(x, y) \\) evaluates to \\( \\{ x, y \\} \\).
-->

求值结果现在变成一个多重集合(multiset)，而不是一个单一值
求值到多重集合的规则如下：
 * 常量 \\( n \\) 求值为单元素集合 \\( \{n\} \\)。
 * 除法以外的算术运算符作用于两个参数的笛卡尔积中的每一对，所以 \\( X + Y \\) 求值为 \\( \\{ x + y \\mid x ∈ X, y ∈ Y \\} \\)。
 * 除法 \\( X / Y \\) 求值为 \\( \\{ x / y \\mid x ∈ X, y ∈ Y, y ≠ 0\\} \\). 换句话说，所有 \\( Y \\) 中的 \\( 0 \\) 都被丢弃。
 * 选择 \\( \\mathrm{choose}(x, y) \\) 求值为 \\( \\{ x, y \\} \\)。

<!--
For example, \\( 1 + \\mathrm{choose}(2, 5) \\) evaluates to \\( \\{ 3, 6 \\} \\), \\(1 + 2 / 0 \\) evaluates to \\( \\{\\} \\), and \\( 90 / (\\mathrm{choose}(-5, 5) + 5) \\) evaluates to \\( \\{ 9 \\} \\).
Using multisets instead of true sets simplifies the code by removing the need to check for uniqueness of elements.
-->

例如， \\( 1 + \\mathrm{choose}(2, 5) \\) 求值为 \\( \\{ 3, 6 \\} \\)， \\(1 + 2 / 0 \\) 求值为 \\( \\{\\} \\)，并且 \\( 90 / (\\mathrm{choose}(-5, 5) + 5) \\) 求值为 \\( \\{ 9 \\} \\)。
使用多重集合而非集合，是为了避免处理元素重复的情况而使代码过于复杂。

<!--
A monad that represents this non-deterministic effect must be able to represent a situation in which there are no answers, and a situation in which there is at least one answer together with any remaining answers:
-->

表示这种非确定性效应的单子必须能够处理没有答案的情况，以及至少有一个答案和其他答案的情况：
```lean
{{#example_decl Examples/Monads/Many.lean Many}}
```
<!--
This datatype looks very much like `List`.
The difference is that where `cons` stores the rest of the list, `more` stores a function that should compute the next value on demand.
This means that a consumer of `Many` can stop the search when some number of results have been found.
-->

该数据类型看起来非常像`List`。
不同之处在于，`cons`存储列表的其余部分，而`more`存储一个函数，该函数仅在需要时才会被调用来计算下一个值。
这意味着`Many`的使用者可以在找到一定数量的结果后停止搜索。

<!--
A single result is represented by a `more` constructor that returns no further results:
-->

单个结果由`more`构造子表示，该构造子不返回任何进一步的结果：
```lean
{{#example_decl Examples/Monads/Many.lean one}}
```
<!--
The union of two multisets of results can be computed by checking whether the first multiset is empty.
If so, the second multiset is the union.
If not, the union consists of the first element of the first multiset followed by the union of the rest of the first multiset with the second multiset:
-->

两个作为结果的多重集合的并集，可以通过检查第一个是否为空来计算。
如果第一个为空则第二个多重集合就是并集。
如果非空，则并集由第一个多重集合的第一个元素，紧跟着其余部分与第二个多重集的并集：
```lean
{{#example_decl Examples/Monads/Many.lean union}}
```

<!--
It can be convenient to start a search process with a list of values.
`Many.fromList` converts a list into a multiset of results:
-->

对值列表搜索会比手动构造多重集合更方便。
函数`Many.fromList`将列表转换为结果的多重集合：
```lean
{{#example_decl Examples/Monads/Many.lean fromList}}
```
<!--
Similarly, once a search has been specified, it can be convenient to extract either a number of values, or all the values:
-->

类似地，一旦搜索已经确定，就可以方便地提取固定数量的值或所有值：
```lean
{{#example_decl Examples/Monads/Many.lean take}}
```

<!--
A `Monad Many` instance requires a `bind` operator.
In a nondeterministic search, sequencing two operations consists of taking all possibilities from the first step and running the rest of the program on each of them, taking the union of the results.
In other words, if the first step returns three possible answers, the second step needs to be tried for all three.
Because the second step can return any number of answers for each input, taking their union represents the entire search space.
-->

`Monad Many`实例需要一个`bind`运算符。
在非确定性搜索中，对两个操作进行排序包括：从第一步中获取所有可能性，并对每种可能性都运行程序的其余部分，取结果的并集。
换句话说，如果第一步返回三个可能的答案，则需要对这三个答案分别尝试第二步。
由于第二步为每个输入都可以返回任意数量的答案，因此取它们的并集表示整个搜索空间。
```lean
{{#example_decl Examples/Monads/Many.lean bind}}
```

<!--
`Many.one` and `Many.bind` obey the monad contract.
To check that `Many.bind (Many.one v) f` is the same as `f v`, start by evaluating the expression as far as possible:
-->

`Many.one`和`Many.bind`遵循单子约定。
要检查`Many.bind (Many.one v) f`是否与`f v`相同，首先应最大限度地计算表达式：
```lean
{{#example_eval Examples/Monads/Many.lean bindLeft}}
```
<!--
The empty multiset is a right identity of `union`, so the answer is equivalent to `f v`.
To check that `Many.bind v Many.one` is the same as `v`, consider that `bind` takes the union of applying `Many.one` to each element of `v`.
In other words, if `v` has the form `{v1, v2, v3, ..., vn}`, then `Many.bind v Many.one` is `{v1} ∪ {v2} ∪ {v3} ∪ ... ∪ {vn}`, which is `{v1, v2, v3, ..., vn}`.
-->

空集是`union`的右单位元，因此答案等同于`f v`。
要检查`Many.bind v Many.one`是否与`v`相同，需要考虑`Many.one`应用于`v`的各元素结果的并集。
换句话说，如果`v`的形式为`{v1, v2, v3, ..., vn}`，则`Many.bind v Many.one`为`{v1} ∪ {v2} ∪ {v3} ∪ ... ∪ {vn}`，即`{v1, v2, v3, ..., vn}`。

<!--
Finally, to check that `Many.bind` is associative, check that `Many.bind (Many.bind bind v f) g` is the same as `Many.bind v (fun x => Many.bind (f x) g)`.
If `v` has the form `{v1, v2, v3, ..., vn}`, then:
-->

最后，要检查`Many.bind`是否满足结合律，需要检查`Many.bind (Many.bind bind v f) g`是否与`Many.bind v (fun x => Many.bind (f x) g)`相同。
如果`v`的形式为`{v1, v2, v3, ..., vn}`，则：
```lean
Many.bind v f
===>
f v1 ∪ f v2 ∪ f v3 ∪ ... ∪ f vn
```
which means that
```lean
Many.bind (Many.bind bind v f) g
===>
Many.bind (f v1) g ∪
Many.bind (f v2) g ∪
Many.bind (f v3) g ∪
... ∪
Many.bind (f vn) g
```
Similarly,
```lean
Many.bind v (fun x => Many.bind (f x) g)
===>
(fun x => Many.bind (f x) g) v1 ∪
(fun x => Many.bind (f x) g) v2 ∪
(fun x => Many.bind (f x) g) v3 ∪
... ∪
(fun x => Many.bind (f x) g) vn
===>
Many.bind (f v1) g ∪
Many.bind (f v2) g ∪
Many.bind (f v3) g ∪
... ∪
Many.bind (f vn) g
```
<!--
Thus, both sides are equal, so `Many.bind` is associative.
-->

因此两边相等，所以`Many.bind`满足结合律。

由此得到的单子实例为：
```lean
{{#example_decl Examples/Monads/Many.lean MonadMany}}
```
<!--
An example search using this monad finds all the combinations of numbers in a list that add to 15:
-->

利用此单子，下例可找到列表中所有加起来等于15的数字组合：
```lean
{{#example_decl Examples/Monads/Many.lean addsTo}}
```
<!--
The search process is recursive over the list.
The empty list is a successful search when the goal is `0`; otherwise, it fails.
When the list is non-empty, there are two possibilities: either the head of the list is greater than the goal, in which case it cannot participate in any successful searches, or it is not, in which case it can.
If the head of the list is _not_ a candidate, then the search proceeds to the tail of the list.
If the head is a candidate, then there are two possibilities to be combined with `Many.union`: either the solutions found contain the head, or they do not.
The solutions that do not contain the head are found with a recursive call on the tail, while the solutions that do contain it result from subtracting the head from the goal, and then attaching the head to the solutions that result from the recursive call.
-->

(译者注：这是一个动态规划算法)对列表进行递归搜索。
当输入列表为空且目标为`0`时，返回空列表表示成功；否则返回 `Many.none` 表示失败，因为空输入不可能得到非0加和。
当列表非空时，有两种可能性：若输入列表的第一个元素大于goal，此时它的任何加和都大于`0`因此不可能是候选者；若第一个元素不大于goal，可以参与后续的搜索。
如果列表的头部x **不是** 候选者，对列表的尾部xs递归搜索。
如果头部是候选者，则有两种用`Many.union`合并起来的可能性：找到的解含有当前的x，或者不含有。
不含x的解通过xs递归搜索找到；而含有x的解则通过从goal中减去x，然后将x附加到递归的解中得到。

<!--
Returning to the arithmetic evaluator that produces multisets of results, the `both` and `neither` operators can be written as follows:
-->

让我们回到产生多重集合的算术求值器，`both`和`neither`运算符可以写成如下形式：
```lean
{{#example_decl Examples/Monads/Class.lean NeedsSearch}}
```
<!--
Using these operators, the earlier examples can be evaluated:
-->

可以用这些运算符对前面的示例求值：
```lean
{{#example_decl Examples/Monads/Class.lean opening}}

{{#example_in Examples/Monads/Class.lean searchA}}
```
```output info
{{#example_out Examples/Monads/Class.lean searchA}}
```
```lean
{{#example_in Examples/Monads/Class.lean searchB}}
```
```output info
{{#example_out Examples/Monads/Class.lean searchB}}
```
```lean
{{#example_in Examples/Monads/Class.lean searchC}}
```
```output info
{{#example_out Examples/Monads/Class.lean searchC}}
```

<!--
#### Custom Environments
-->

#### 自定义环境

<!--
The evaluator can be made user-extensible by allowing strings to be used as operators, and then providing a mapping from strings to a function that implements them.
For example, users could extend the evaluator with a remainder operator or with one that returns the maximum of its two arguments.
The mapping from function names to function implementations is called an _environment_.
-->

可以通过允许将字符串当作运算符，然后提供从字符串到它们的实现函数之间的映射，使求值器可由用户扩展。
例如，用户可以用余数运算或最大值运算来扩展求值器。
从函数名称到函数实现的映射称为 **环境** 。

<!--
The environments needs to be passed in each recursive call.
Initially, it might seem that `evaluateM` needs an extra argument to hold the environment, and that this argument should be passed to each recursive invocation.
However, passing an argument like this is another form of monad, so an appropriate `Monad` instance allows the evaluator to be used unchanged.
-->

环境需要在每层递归调用之间传递。
因此一开始`evaluateM`看起来需要一个额外的参数来保存环境，并且该参数需要在每次递归调用时传递。
然而，像这样传递参数是单子的另一种形式，因此一个适当的`Monad`实例允许求值器本身保持不变。

<!--
Using functions as a monad is typically called a _reader_ monad.
When evaluating expressions in the reader monad, the following rules are used:
 * Constants \\( n \\) evaluate to constant functions \\( λ e . n \\),
 * Arithmetic operators evaluate to functions that pass their arguments on, so \\( f + g \\) evaluates to \\( λ e . f(e) + g(e) \\), and
 * Custom operators evaluate to the result of applying the custom operator to the arguments, so \\( f \\ \\mathrm{OP}\\ g \\) evaluates to
   \\[
     λ e .
     \\begin{cases}
     h(f(e), g(e)) & \\mathrm{if}\\ e\\ \\mathrm{contains}\\ (\\mathrm{OP}, h) \\\\
     0 & \\mathrm{otherwise}
     \\end{cases}
   \\]
   with \\( 0 \\) serving as a fallback in case an unknown operator is applied.
-->

将函数当作单子，这通常称为 **reader** 单子。
在reader单子中对表达式求值使用以下规则：
 * 常量 \\( n \\) 映射为常量函数 \\( λ e . n \\)，
 * 算术运算符映射为将参数各自传递然后计算的函数，因此 \\( f + g \\) 映射为 \\( λ e . f(e) + g(e) \\)，并且
 * 自定义运算符求值为将自定义运算符应用于参数的结果，因此 \\( f \\ \\mathrm{OP}\\ g \\) 映射为
   \\[
     λ e .
     \\begin{cases}
     h(f(e), g(e)) & \\mathrm{if}\\ e\\ \\mathrm{contains}\\ (\\mathrm{OP}, h) \\\\
     0 & \\mathrm{otherwise}
     \\end{cases}
   \\]
   其中 \\( 0 \\) 用于运算符未知的情况。

<!--
To define the reader monad in Lean, the first step is to define the `Reader` type and the effect that allows users to get ahold of the environment:
-->

要在Lean中定义reader单子，第一步是定义`Reader`类型，和用户获取环境的效应：
```lean
{{#example_decl Examples/Monads/Class.lean Reader}}
```
<!--
By convention, the Greek letter `ρ`, which is pronounced "rho", is used for environments.
-->

按照惯例，希腊字母`ρ`（发音为“rho”）用于表示环境。

<!--
The fact that constants in arithmetic expressions evaluate to constant functions suggests that the appropriate definition of `pure` for `Reader` is a a constant function:
-->

算术表达式中的常量映射为常量函数这一事实表明，`Reader`的`pure`的适当定义是一个常量函数：
```lean
{{#example_decl Examples/Monads/Class.lean ReaderPure}}
```

<!--
On the other hand, `bind` is a bit tricker.
Its type is `{{#example_out Examples/Monads/Class.lean readerBindType}}`.
This type can be easier to understand by expanding the definitions of `Reader`, which yields `{{#example_out Examples/Monads/Class.lean readerBindTypeEval}}`.
It should take an environment-accepting function as its first argument, while the second argument should transform the result of the environment-accepting function into yet another environment-accepting function.
The result of combining these is itself a function, waiting for an environment.
-->

另一方面`bind`则有点棘手。
它的类型是`{{#example_out Examples/Monads/Class.lean readerBindType}}`。
通过展开`Reader`的定义，可以更容易地理解此类型，从而产生`{{#example_out Examples/Monads/Class.lean readerBindTypeEval}}`。
它将读取环境的函数作为第一个参数，而第二个参数将第一个参数的结果转换为另一个读取环境的函数。
组合这些结果本身就是一个读取环境的函数。

<!--
It's possible to use Lean interactively to get help writing this function.
The first step is to write down the arguments and return type, being very explicit in order to get as much help as possible, with an underscore for the definition's body:
-->

可以交互式地使用Lean，获得编写该函数的帮助。
为了获得尽可能多的帮助，第一步是非常明确地写下参数的类型和返回的类型，用下划线表示定义的主体：
```lean
{{#example_in Examples/Monads/Class.lean readerbind0}}
```
<!--
Lean provides a message that describes which variables are available in scope, and the type that's expected for the result.
The `⊢` symbol, called a _turnstile_ due to its resemblance to subway entrances, separates the local variables from the desired type, which is `ρ → β` in this message:
-->

Lean提供的消息描述了哪些变量在作用域内可用，以及结果的预期类型。
`⊢`符号，由于它类似于地铁入口而被称为 **turnstile** ，将局部变量与所需类型分开，在此消息中为`ρ → β`：
```output error
{{#example_out Examples/Monads/Class.lean readerbind0}}
```

<!--
Because the return type is a function, a good first step is to wrap a `fun` around the underscore:
-->

因为返回类型是一个函数，所以第一步最好在下划线外套一层`fun`：
```lean
{{#example_in Examples/Monads/Class.lean readerbind1}}
```
<!--
The resulting message now shows the function's argument as a local variable:
-->

产生的消息说明现在函数的参数已经成为一个局部变量：
```output error
{{#example_out Examples/Monads/Class.lean readerbind1}}
```

<!--
The only thing in the context that can produce a `β` is `next`, and it will require two arguments to do so.
Each argument can itself be an underscore:
-->

上下文中唯一可以产生 `β` 的是 `next`， 并且它需要两个参数。
每个参数都可以用下划线表示：
```lean
{{#example_in Examples/Monads/Class.lean readerbind2a}}
```
<!--
The two underscores have the following respective messages associated with them:
-->

这两个下划线分别有如下的消息：
```output error
{{#example_out Examples/Monads/Class.lean readerbind2a}}
```
```output error
{{#example_out Examples/Monads/Class.lean readerbind2b}}
```

<!--
Attacking the first underscore, only one thing in the context can produce an `α`, namely `result`:
-->

先处理第一条下划线，注意到上下文中只有一个东西可以产生`α`，即`result`：
```lean
{{#example_in Examples/Monads/Class.lean readerbind3}}
```
<!--
Now, both underscores have the same error:
-->

现在两条下划线都有一样的报错了：
```output error
{{#example_out Examples/Monads/Class.lean readerbind3}}
```
<!--
Happily, both underscores can be replaced by `env`, yielding:
-->

值得高兴的是，两条下划线都可以被`env`替换，得到：
```lean
{{#example_decl Examples/Monads/Class.lean readerbind4}}
```

<!--
The final version can be obtained by undoing the expansion of `Reader` and cleaning up the explicit details:
-->

要得到最后的版本，只需要把我们前面对`Reader`的展开撤销，并且去掉过于明确的细节：
```lean
{{#example_decl Examples/Monads/Class.lean Readerbind}}
```

<!--
It's not always possible to write correct functions by simply "following the types", and it carries the risk of not understanding the resulting program.
However, it can also be easier to understand a program that has been written than one that has not, and the process of filling in the underscores can bring insights.
In this case, `Reader.bind` works just like `bind` for `Id`, except it accepts an additional argument that it then passes down to its arguments, and this intuition can help in understanding how it works.
-->

仅仅跟着类型信息走并不总是能写出正确的函数，并且有未能完全理解产生的程序的风险。
然而理解一个已经写出的程序比理解还没写出的要简单，而且逐步填充下划线的内容也可以提供思路。
这张情况下，`Reader.bind`和`Id`的`bind`很像，唯一区别在于它接受一个额外的参数并传递到其他参数中。这个直觉可以帮助理解它的原理。

<!--
`Reader.pure`, which generates constant functions, and `Reader.bind` obey the monad contract.
To check that `Reader.bind (Reader.pure v) f` is the same as `f v`, it's enough to replace definitions until the last step:
-->

`Reader.pure`和`Reader.bind`遵循单子约定。
要检查`Reader.bind (Reader.pure v) f`与`f v`等价, 只需要不断地展开定义即可：
```lean
{{#example_eval Examples/Monads/Class.lean ReaderMonad1}}
```
<!--
For every function `f`, `fun x => f x` is the same as `f`, so the first part of the contract is satisfied.
To check that `Reader.bind r Reader.pure` is the same as `r`, a similar technique works:
-->

对任意函数`f`来说，`fun x => f x`和`f`是等价的，所以约定的第一部分已经满足。
要检查`Reader.bind r Reader.pure`与`r`等价，只需要相似的技巧：
```lean
{{#example_eval Examples/Monads/Class.lean ReaderMonad2}}
```
<!--
Because reader actions `r` are themselves functions, this is the same as `r`.
To check associativity, the same thing can be done for both `{{#example_eval Examples/Monads/Class.lean ReaderMonad3a 0}}` and `{{#example_eval Examples/Monads/Class.lean ReaderMonad3b 0}}`:
-->

因为`r`本身是函数，所以这和`r`也是等价的。
要检查结合律，只需要对 `{{#example_eval Examples/Monads/Class.lean ReaderMonad3a 0}}` 和 `{{#example_eval Examples/Monads/Class.lean ReaderMonad3b 0}}` 重复同样的步骤：
```lean
{{#example_eval Examples/Monads/Class.lean ReaderMonad3a}}
```

```lean
{{#example_eval Examples/Monads/Class.lean ReaderMonad3b}}
```

<!--
Thus, a `Monad (Reader ρ)` instance is justified:
-->

至此，`Monad (Reader ρ)`实例已经得到了充分验证：
```lean
{{#example_decl Examples/Monads/Class.lean MonadReaderInst}}
```

<!--
The custom environments that will be passed to the expression evaluator can be represented as lists of pairs:
-->

要被传递给表达式求值器的环境可以用键值对的列表来表示：
```lean
{{#example_decl Examples/Monads/Class.lean Env}}
```
<!--
For instance, `exampleEnv` contains maximum and modulus functions:
-->

例如，`exampleEnv`包含最大值和模函数：
```lean
{{#example_decl Examples/Monads/Class.lean exampleEnv}}
```

<!--
Lean already has a function `List.lookup` that finds the value associated with a key in a list of pairs, so `applyPrimReader` needs only check whether the custom function is present in the environment. It returns `0` if the function is unknown:
-->

Lean已提供函数`List.lookup`用来在键值对的列表中根据键寻找对应的值，所以`applyPrimReader`只需要确认自定义函数是否存在于环境中即可。如果不存在则返回`0`：
```lean
{{#example_decl Examples/Monads/Class.lean applyPrimReader}}
```

<!--
Using `evaluateM` with `applyPrimReader` and an expression results in a function that expects an environment.
Luckily, `exampleEnv` is available:
-->

将`evaluateM`、`applyPrimReader`、和一条表达式一起使用，即得到一个接受环境的函数。
而我们前面已经准备好了`exampleEnv`：
```lean
{{#example_in Examples/Monads/Class.lean readerEval}}
```
```output info
{{#example_out Examples/Monads/Class.lean readerEval}}
```

<!--
Like `Many`, `Reader` is an example of an effect that is difficult to encode in most languages, but type classes and monads make it just as convenient as any other effect.
The dynamic or special variables found in Common Lisp, Clojure, and Emacs Lisp can be used like `Reader`.
Similarly, Scheme and Racket's parameter objects are an effect that exactly correspond to `Reader`.
The Kotlin idiom of context objects can solve a similar problem, but they are fundamentally a means of passing function arguments automatically, so this idiom is more like the encoding as a reader monad than it is an effect in the language.
-->

与`Many`一样，`Reader`是难以在大多数语言中编码的效应，但类型类和单子使其与任何其他效应一样方便。
Common Lisp、Clojure和Emacs Lisp中的动态或特殊变量可以用作`Reader`。
类似地，Scheme和Racket的参数对象是一个与`Reader`完全对应的效应。
Kotlin的上下文对象可以解决类似的问题，但根本上是一种自动传递函数参数的方式，因此更像是作为reader单子的编码，而不是语言中实现的效应。

<!--
## Exercises
-->

## 练习

<!--
### Checking Contracts
-->

### 检查约定

<!--
Check the monad contract for `State σ` and `Except ε`.
-->

检查`State σ`和`Except ε`满足单子约定。


<!--
### Readers with Failure
-->

### 允许Reader失败
<!--
Adapt the reader monad example so that it can also indicate failure when the custom operator is not defined, rather than just returning zero.
In other words, given these definitions:
-->

调整例子中的reader单子，使得它可以在自定义的运算符不存在时提供错误信息而不是直接返回0。
换句话说，给定这些定义：
```lean
{{#example_decl Examples/Monads/Class.lean ReaderFail}}
```
<!--
do the following:
 1. Write suitable `pure` and `bind` functions
 2. Check that these functions satisfy the `Monad` contract
 3. Write `Monad` instances for `ReaderOption` and `ReaderExcept`
 4. Define suitable `applyPrim` operators and test them with `evaluateM` on some example expressions
-->

要做的是：
 1. 实现恰当的`pure`和`bind`函数
 2. 验证这些函数满足`Monad`约定
 3. 为`ReaderOption`和`ReaderExcept`实现`Monad`实例
 4. 为它们定义恰当的`applyPrim`运算符，并且将它们和`evaluateM`一起测试一些例子

<!--
### A Tracing Evaluator
-->

### 带有跟踪信息的求值器

<!--
The `WithLog` type can be used with the evaluator to add optional tracing of some operations.
In particular, the type `ToTrace` can serve as a signal to trace a given operator:
-->

`WithLog`类型可以和求值器一起使用，来实现对某些运算的跟踪。
特别地，可以使用`ToTrace`类型来追踪某个给定的运算符：
```lean
{{#example_decl Examples/Monads/Class.lean ToTrace}}
```
<!--
For the tracing evaluator, expressions should have type `Expr (Prim (ToTrace (Prim Empty)))`.
This says that the operators in the expression consist of addition, subtraction, and multiplication, augmented with traced versions of each. The innermost argument is `Empty` to signal that there are no further special operators inside of `trace`, only the three basic ones.
-->

对于带有跟踪信息的求值器，表达式应该具有类型`Expr (Prim (ToTrace (Prim Empty)))`.
这说明表达式中的运算符由附加参数的加、减、乘运算组成。最内层的参数是`Empty`，说明在`trace`内部没有特殊运算符，只有三种基本运算。

<!--
Do the following:
 1. Implement a `Monad (WithLog logged)` instance
 2. Write an `{{#example_in Examples/Monads/Class.lean applyTracedType}}` function to apply traced operators to their arguments, logging both the operator and the arguments, with type `{{#example_out Examples/Monads/Class.lean applyTracedType}}`
-->

要做的是：
 1. 实现`Monad (WithLog logged)`实例
 2. 写一个`{{#example_in Examples/Monads/Class.lean applyTracedType}}`来将被追踪的运算符应用到参数，将运算符和参数记录到日志，类型为：`{{#example_out Examples/Monads/Class.lean applyTracedType}}`

<!--
If the exercise has been completed correctly, then
-->

如果练习已经正确实现，那么
```lean
{{#example_in Examples/Monads/Class.lean evalTraced}}
```
<!--
should result in
-->

将有如下结果
```output info
{{#example_out Examples/Monads/Class.lean evalTraced}}
```

<!--
 Hint: values of type `Prim Empty` will appear in the resulting log. In order to display them as a result of `#eval`, the following instances are required:
-->

 提示：`Prim Empty`会出现在日志中。为了让它们能被`#eval`输出，需要下面几个实例：
 ```lean
 {{#example_decl Examples/Monads/Class.lean ReprInstances}}
 ```
