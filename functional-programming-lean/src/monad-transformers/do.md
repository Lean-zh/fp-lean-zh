<!-- # More do Features -->
# 更多 do 的特性
<!-- Lean's `do`-notation provides a syntax for writing programs with monads that resembles imperative programming languages.
In addition to providing a convenient syntax for programs with monads, `do`-notation provides syntax for using certain monad transformers. -->
Lean 的 `do`-标记为使用单子编写程序提供了一种类似命令式编程语言的语法。
除了为使用单子的程序提供方便的语法外，`do`-标记还提供了使用某些单子转换器的语法。

<!-- ## Single-Branched `if` -->
## 单分支 `if`

<!-- When working in a monad, a common pattern is to carry out a side effect only if some condition is true.
For instance, `countLetters` contains a check for vowels or consonants, and letters that are neither have no effect on the state.
This is captured by having the `else` branch evaluate to `pure ()`, which has no effects: -->
在单子中工作时，一种常见的模式是只有当某些条件为真时才执行副作用。
例如，`countLetters` 包含对元音或辅音的检查，而两者都不是的字母对状态没有影响。
通过将 `else` 分支设置为 `pure ()`，可以达成这一目的，因为 `pure ()` 不会产生任何影响：
```lean
{{#example_decl Examples/MonadTransformers/Defs.lean countLettersModify}}
```

<!-- When an `if` is a statement in a `do`-block, rather than being an expression, then `else pure ()` can simply be omitted, and Lean inserts it automatically.
The following definition of `countLetters` is completely equivalent: -->
如果 `if` 是一个 `do` 块中的语句，而不是一个表达式，那么 `else pure ()` 可以直接省略，Lean 会自动插入它。
下面的 `countLetters` 定义完全等价：
```lean
{{#example_decl Examples/MonadTransformers/Do.lean countLettersNoElse}}
```
<!-- A program that uses a state monad to count the entries in a list that satisfy some monadic check can be written as follows: -->
使用状态单子计算列表中满足某种单子检查的条目的程序，可以写成下面这样：
```lean
{{#example_decl Examples/MonadTransformers/Do.lean count}}
```

<!-- Similarly, `if not E1 then STMT...` can instead be written `unless E1 do STMT...`.
The converse of `count` that counts entries that don't satisfy the monadic check can be written by replacing `if` with `unless`: -->
同样，`if not E1 then STMT...` 可以写成 `unless E1 do STMT...` 。
`count` 的相反（计算不满足单子检查的条目），的可以用 `unless` 代替 `if`：
```lean
{{#example_decl Examples/MonadTransformers/Do.lean countNot}}
```

<!-- Understanding single-branched `if` and `unless` does not require thinking about monad transformers.
They simply replace the missing branch with `pure ()`.
The remaining extensions in this section, however, require Lean to automatically rewrite the `do`-block to add a local transformer on top of the monad that the `do`-block is written in. -->
理解单分支的 `if` 和 `unless` 不需要考虑单子转换器。
它们只需用 `pure ()` 替换缺失的分支。
然而，本节中的其余扩展要求 Lean 自动重写 `do` 块，以便在写入 `do` 块的单子上添加一个局部转换器。

<!-- ## Early Return -->
## 提前返回

<!-- The standard library contains a function `List.find?` that returns the first entry in a list that satisfies some check.
A simple implementation that doesn't make use of the fact that `Option` is a monad loops over the list using a recursive function, with an `if` to stop the loop when the desired entry is found: -->
标准库中有一个函数 `List.find?`，用于返回列表中满足某些检查条件的第一个条目。
一个简单的实现并没有利用 `Option` 是一个单子的事实，而是使用一个递归函数在列表中循环，并使用 `if` 在找到所需条目时停止循环：
```lean
{{#example_decl Examples/MonadTransformers/Do.lean findHuhSimple}}
```

<!-- Imperative languages typically sport the `return` keyword that aborts the execution of a function, immediately returning some value to the caller.
In Lean, this is available in `do`-notation, and `return` halts the execution of a `do`-block, with `return`'s argument being the value returned from the monad.
In other words, `List.find?` could have been written like this: -->
命令式语言通常会使用 `return` 关键字来终止函数的执行，并立即将某个值返回给调用者。
在 Lean 中，这个关键字在 `do`-标记中可用，`return` 停止了一个 `do` 块的执行，且 `return` 的参数是从单子返回的值。
换句话说，`List.find?` 可以这样写：
```lean
{{#example_decl Examples/MonadTransformers/Do.lean findHuhFancy}}
```

<!-- Early return in imperative languages is a bit like an exception that can only cause the current stack frame to be unwound.
Both early return and exceptions terminate execution of a block of code, effectively replacing the surrounding code with the thrown value.
Behind the scenes, early return in Lean is implemented using a version of `ExceptT`.
Each `do`-block that uses early return is wrapped in an exception handler (in the sense of the function `tryCatch`).
Early returns are translated to throwing the value as an exception, and the handlers catch the thrown value and return it immediately.
In other words, the `do`-block's original return value type is also used as the exception type. -->
在命令式语言中，提前返回有点像异常，只能导致当前堆栈帧被释放。
提前返回和异常都会终止代码块的执行，从而有效地用抛出的值替换周围的代码。
在后台，Lean 中的提前返回是使用 `ExceptT` 的一个版本实现的。
每个使用提前返回的 `do` 代码块都被包裹在异常处理程序中（在函数 `tryCatch` 的意义上）。
提前返回被转换为将值作为异常抛出，处理程序捕获抛出的值并立即返回。
换句话说，`do` 块的原始返回值类型也被用作异常类型。

<!-- Making this more concrete, the helper function `runCatch` strips a layer of `ExceptT` from the top of a monad transformer stack when the exception type and return type are the same: -->
更具体地说，当异常类型和返回类型相同时，辅助函数 `runCatch` 会从单子转换器栈的顶部删除一层 `ExceptT` ：
```lean
{{#example_decl Examples/MonadTransformers/Do.lean runCatch}}
```
<!-- The `do`-block in `List.find?` that uses early return is translated to a `do`-block that does not use early return by wrapping it in a use of `runCatch`, and replacing early returns with `throw`: -->
将 `List.find?` 中使用提前返回的 `do` 块封装为使用 `runCatch` 的 `do` 块，并用 `throw` 代替提前返回，从而将其转换为不使用提前返回的 `do` 块：
```lean
{{#example_decl Examples/MonadTransformers/Do.lean desugaredFindHuh}}
```

<!-- Another situation in which early return is useful is command-line applications that terminate early if the arguments or input are incorrect.
Many programs begin with a section that validates arguments and inputs before proceeding to the main body of the program.
The following version of [the greeting program `hello-name`](../hello-world/running-a-program.md) checks that no command-line arguments were provided: -->
提前返回有用的另一种情况是，如果参数或输入不正确，命令行应用程序会提前终止。
许多程序在进入主体部分之前，都会有一个验证参数和输入的部分。
以下版本的 [问候程序 `hello-name`](../hello-world/running-a-program.md) 会检查是否没有提供命令行参数：

```lean
{{#include ../../../examples/early-return/EarlyReturn.lean:main}}
```
<!-- Running it with no arguments and typing the name `David` yields the same result as the previous version: -->
在不带参数的情况下运行该程序并输入姓名 `David`，得到的结果与前一版本相同：
```
$ {{#command {early-return} {early-return} {./run} {lean --run EarlyReturn.lean}}}
{{#command_out {early-return} {./run} {early-return/expected}}}
```

<!-- Providing the name as a command-line argument instead of an answer causes an error: -->
将名称作为命令行参数而不是答案提供会导致错误：
```
$ {{#command {early-return} {early-return} {./too-many-args} {lean --run EarlyReturn.lean David}}}
{{#command_out {early-return} {./too-many-args} }}
```

<!-- And providing no name causes the other error: -->
不提供名字也会导致其他错误：
```
$ {{#command {early-return} {early-return} {./no-name} {lean --run EarlyReturn.lean}}}
{{#command_out {early-return} {./no-name} }}
```

<!-- The program that uses early return avoids needing to nest the control flow, as is done in this version that does not use early return: -->
使用提前返回的程序可以避免像下面这个不使用提前返回的版本一样嵌套控制流：
```lean
{{#include ../../../examples/early-return/EarlyReturn.lean:nestedmain}}
```

<!-- One important difference between early return in Lean and early return in imperative languages is that Lean's early return applies only to the current `do`-block.
When the entire definition of a function is in the same `do` block, this difference doesn't matter.
But if `do` occurs underneath some other structures, then the difference becomes apparent.
For example, given the following definition of `greet`: -->
Lean 中的提前返回与命令式语言中的提前返回之间的一个重要区别是，Lean 的提前返回仅适用于当前的 `do` 块。
当函数的整个定义都在同一个 `do` 块中时，这个区别并不重要。
但如果 `do` 出现在其他结构之下，那么这种差异就会变得很明显。
例如，下面这个 `greet` 的定义：
```lean
{{#example_decl Examples/MonadTransformers/Do.lean greet}}
```
<!-- the expression `{{#example_in Examples/MonadTransformers/Do.lean greetDavid}}` evaluates to `{{#example_out Examples/MonadTransformers/Do.lean greetDavid}}`, not just `"David"`. -->
表达式 `{{#example_in Examples/MonadTransformers/Do.lean greetDavid}}` 被求值为 `{{#example_out Examples/MonadTransformers/Do.lean greetDavid}}` ，而不只是 `"David"` 。

<!-- ## Loops -->
## 循环

<!-- Just as every program with mutable state can be rewritten to a program that passes the state as arguments, every loop can be rewritten as a recursive function.
From one perspective, `List.find?` is most clear as a recursive function.
After all, its definition mirrors the structure of the list: if the head passes the check, then it should be returned; otherwise look in the tail.
When no more entries remain, the answer is `none`.
From another perspective, `List.find?` is most clear as a loop.
After all, the program consults the entries in order until a satisfactory one is found, at which point it terminates.
If the loop terminates without having returned, the answer is `none`. -->
正如每个具有可变状态的程序都可以改写成将状态作为参数传递的程序一样，每个循环都可以改写成递归函数。
从某个角度看，`List.find?` 作为递归函数是最清晰不过的了。
毕竟，它的定义反映了列表的结构：如果头部通过了检查，那么就应该返回；否则就在尾部查找。
当没有条目时，答案就是 `none`。
从另一个角度看，`List.find?` 作为一个循环最为清晰。
毕竟，程序会按顺序查询条目，直到找到合适的条目，然后终止。
如果循环没有返回就终止了，那么答案就是 `none`。

<!-- ### Looping with ForM -->
### 使用 ForM 循环

<!-- Lean includes a type class that describes looping over a container type in some monad.
This class is called `ForM`: -->
Lean 包含一个类型类，用于描述在某个单子中对容器类型的循环。
这个类型类叫做 `ForM`：
```lean
{{#example_decl Examples/MonadTransformers/Do.lean ForM}}
```
<!-- This class is quite general.
The parameter `m` is a monad with some desired effects, `γ` is the collection to be looped over, and `α` is the type of elements from the collection.
Typically, `m` is allowed to be any monad, but it is possible to have a data structure that e.g. only supports looping in `IO`.
The method `forM` takes a collection, a monadic action to be run for its effects on each element from the collection, and is then responsible for running the actions. -->
该类型类非常通用。
参数 `m` 是一个具有某些预期作用的单子， `γ` 是要循环的集合，`α` 是集合中元素的类型。
通常情况下，`m` 可以是任何单子，但也可以是只支持在 `IO` 中循环的数据结构。
方法 `forM` 接收一个集合、一个要对集合中每个元素产生影响的单子操作，然后负责运行这些动作。

<!-- The instance for `List` allows `m` to be any monad, it sets `γ` to be `List α`, and sets the class's `α` to be the same `α` found in the list: -->
`List` 的实例允许 `m` 是任何单子，它将 `γ` 设置为 `List α`，并将类型类的 `α` 设置为列表中的 `α`：
```lean
{{#example_decl Examples/MonadTransformers/Do.lean ListForM}}
```
<!-- The [function `doList` from `doug`](reader-io.md#implementation) is `forM` for lists.
Because `forM` is intended to be used in `do`-blocks, it uses `Monad` rather than `Applicative`.
`forM` can be used to make `countLetters` much shorter: -->
[来自 `doug` 的函数 `doList`](reader-io.md#implementation) 是针对列表的 `forM`。
由于 `forM` 的目的是在 `do` 块中使用，它使用了 `Monad` 而不是 `Applicative`。
使用 `forM` 可以使 `countLetters` 更短：
```lean
{{#example_decl Examples/MonadTransformers/Do.lean countLettersForM}}
```


<!-- The instance for `Many` is very similar: -->
`Many` 的实例也差不多：
```lean
{{#example_decl Examples/MonadTransformers/Do.lean ManyForM}}
```

<!-- Because `γ` can be any type at all, `ForM` can support non-polymorphic collections.
A very simple collection is one of the natural numbers less than some given number, in reverse order: -->
因为 `γ` 可以是任何类型，所以 `ForM` 可以支持非多态集合。
一个非常简单的集合是按相反顺序排列的小于某个给定数的自然数：
```lean
{{#example_decl Examples/MonadTransformers/Do.lean AllLessThan}}
```
<!-- Its `forM` operator applies the provided action to each smaller `Nat`: -->
它的 `forM` 操作符将给定的操作应用于每个更小的 `Nat`：
```lean
{{#example_decl Examples/MonadTransformers/Do.lean AllLessThanForM}}
```
<!-- Running `IO.println` on each number less than five can be accomplished with `forM`: -->
在每个小于 5 的数字上运行 `IO.println` 可以用 `forM` 来实现：
```lean
{{#example_in Examples/MonadTransformers/Do.lean AllLessThanForMRun}}
```
```output info
{{#example_out Examples/MonadTransformers/Do.lean AllLessThanForMRun}}
```

<!-- An example `ForM` instance that works only in a particular monad is one that loops over the lines read from an IO stream, such as standard input: -->
一个仅在特定单子中工作的 `ForM` 实例示例是，循环读取从 IO 流（如标准输入）获取的行：
```lean
{{#include ../../../examples/formio/ForMIO.lean:LinesOf}}
```
<!-- The definition of `forM` is marked `partial` because there is no guarantee that the stream is finite.
In this case, `IO.FS.Stream.getLine` works only in the `IO` monad, so no other monad can be used for looping. -->
`forM` 的定义被标记为 `partial` ，因为无法保证流是有限的。
在这种情况下，`IO.FS.Stream.getLine` 只在 `IO` 单子中起作用，因此不能使用其他单子进行循环。

<!-- This example program uses this looping construct to filter out lines that don't contain letters: -->
本示例程序使用这种循环结构过滤掉不包含字母的行：
```lean
{{#include ../../../examples/formio/ForMIO.lean:main}}
```
<!-- The file `test-data` contains: -->
`test-data` 文件包含：
```
{{#include ../../../examples/formio/test-data}}
```
<!-- Invoking this program, which is stored in `ForMIO.lean`, yields the following output: -->
调用保存在 `ForMIO.lean` 的这个程序，产生如下输出：
```
$ {{#command {formio} {formio} {lean --run ForMIO.lean < test-data}}}
{{#command_out {formio} {lean --run ForMIO.lean < test-data} {formio/expected}}}
```

<!-- ### Stopping Iteration -->
### 中止循环

<!-- Terminating a loop early is difficult to do with `forM`.
Writing a function that iterates over the `Nat`s in an `AllLessThan` only until `3` is reached requires a means of stopping the loop partway through.
One way to achieve this is to use `forM` with the `OptionT` monad transformer.
The first step is to define `OptionT.exec`, which discards information about both the return value and whether or not the transformed computation succeeded: -->
使用 `forM` 时很难提前终止循环。
要编写一个在 `AllLessThan` 中遍历 `Nat` 直到 `3` 的函数，就需要一种中途停止循环的方法。
实现这一点的方法之一是使用 `forM` 和 `OptionT` 单子转换器。
第一步是定义 `OptionT.exec`，它会丢弃有关返回值和转换计算是否成功的信息：
```lean
{{#example_decl Examples/MonadTransformers/Do.lean OptionTExec}}
```
<!-- Then, failure in the `OptionT` instance of `Alternative` can be used to terminate looping early: -->
然后，`Alternative` 的 `OptionT` 实例中的失败可以用来提前终止循环：
```lean
{{#example_decl Examples/MonadTransformers/Do.lean OptionTcountToThree}}
```
<!-- A quick test demonstrates that this solution works: -->
快速测试表明，这一解决方案是可行的：
```lean
{{#example_in Examples/MonadTransformers/Do.lean optionTCountSeven}}
```
```output info
{{#example_out Examples/MonadTransformers/Do.lean optionTCountSeven}}
```

<!-- However, this code is not so easy to read.
Terminating a loop early is a common task, and Lean provides more syntactic sugar to make this easier.
This same function can also be written as follows: -->
然而，这段代码并不容易阅读。
提前终止循环是一项常见的任务，Lean 提供了更多语法糖来简化这项任务。
同样的函数也可以写成下面这样：
```lean
{{#example_decl Examples/MonadTransformers/Do.lean countToThree}}
```
<!-- Testing it reveals that it works just like the prior version: -->
测试后发现，它用起来与之前的版本一样：
```lean
{{#example_in Examples/MonadTransformers/Do.lean countSevenFor}}
```
```output info
{{#example_out Examples/MonadTransformers/Do.lean countSevenFor}}
```

<!-- At the time of writing, the `for ... in ... do ...` syntax desugars to the use of a type class called `ForIn`, which is a somewhat more complicated version of `ForM` that keeps track of state and early termination.
However, there is a plan to refactor `for` loops to use the simpler `ForM`, with monad transformers inserted as necessary.
In the meantime, an adapter is provided that converts a `ForM` instance into a `ForIn` instance, called `ForM.forIn`.
To enable `for` loops based on a `ForM` instance, add something like the following, with appropriate replacements for `AllLessThan` and `Nat`: -->
在撰写本文时，`for ... in ... do ...` 语法会解糖为使用一个名为 `ForIn` 的类型类，它是 `ForM` 的一个更为复杂的版本，可以跟踪状态和提前终止。
不过，我们计划重构 `for` 循环，使用更简单的 `ForM`，并在必要时插入单子转换器。
与此同时，我们还提供了一个适配器，可将 `ForM` 实例转换为 `ForIn` 实例，称为 `ForM.forIn`。
要启用基于 `ForM` 实例的 `for` 循环，请添加类似下面的内容，并适当替换 `AllLessThan` 和 `Nat`：
```lean
{{#example_decl Examples/MonadTransformers/Do.lean ForInIOAllLessThan}}
```
<!-- Note, however, that this adapter only works for `ForM` instances that keep the monad unconstrained, as most of them do.
This is because the adapter uses `StateT` and `ExceptT`, rather than the underlying monad. -->
但请注意，这个适配器只适用于保持无约束单子的 `ForM` 实例，大多数实例都是如此。
这是因为适配器使用的是 `StateT` 和 `ExceptT` 而不是底层单子。

<!-- Early return is supported in `for` loops.
The translation of `do` blocks with early return into a use of an exception monad transformer applies equally well underneath `forM` as the earlier use of `OptionT` to halt iteration does.
This version of `List.find?` makes use of both: -->
`for` 循环支持提前返回。
将提前返回的 `do` 块转换为异常单子转换器的使用，与之前使用 `OptionT` 来停止迭代一样，同样适用于 `forM` 循环。
这个版本的 `List.find?` 同时使用了这两种方法：
```lean
{{#example_decl Examples/MonadTransformers/Do.lean findHuh}}
```

<!-- In addition to `break`, `for` loops support `continue` to skip the rest of the loop body in an iteration.
An alternative (but confusing) formulation of `List.find?` skips elements that don't satisfy the check: -->
除了 `break` 以外，`for` 循环还支持 `continue` 以在迭代中跳过循环体的其余部分。
`List.find?` 的另一种表述方式（但容易引起混淆）是跳过不满足检查条件的元素：
```lean
{{#example_decl Examples/MonadTransformers/Do.lean findHuhCont}}
```

<!-- A `Range` is a structure that consists of a starting number, an ending number, and a step.
They represent a sequence of natural numbers, from the starting number to the ending number, increasing by the step each time.
Lean has special syntax to construct ranges, consisting of square brackets, numbers, and colons that comes in four varieties.
The stopping point must always be provided, while the start and the step are optional, defaulting to `0` and `1`, respectively: -->
`Range` 是一个由起始数、终止数和步长组成的结构。
它们代表一个自然数序列，从起始数到终止数，每次增加一个步长。
Lean 有特殊的语法来构造范围，由方括号、数字和冒号组成，有四种类型。
必须始终提供终止数，而起始数和步长是可选的，默认值分别为 `0` 和 `1`：

<!-- | Expression | Start      | Stop       | Step | As List |
|------------|------------|------------|------|---------|
| `[:10]` | `0` | `10` | `1` | `{{#example_out Examples/MonadTransformers/Do.lean rangeStopContents}}` |
| `[2:10]` | `2` | `10` | `1` | `{{#example_out Examples/MonadTransformers/Do.lean rangeStartStopContents}}` |
| `[:10:3]` | `0` | `10` | `3` | `{{#example_out Examples/MonadTransformers/Do.lean rangeStopStepContents}}` |
| `[2:10:3]` | `2` | `10` | `3` | `{{#example_out Examples/MonadTransformers/Do.lean rangeStartStopStepContents}}` | -->

| 表达式 | 起始数      | 终止数       | 步长 | 转化为列表 |
|------------|------------|------------|------|---------|
| `[:10]` | `0` | `10` | `1` | `{{#example_out Examples/MonadTransformers/Do.lean rangeStopContents}}` |
| `[2:10]` | `2` | `10` | `1` | `{{#example_out Examples/MonadTransformers/Do.lean rangeStartStopContents}}` |
| `[:10:3]` | `0` | `10` | `3` | `{{#example_out Examples/MonadTransformers/Do.lean rangeStopStepContents}}` |
| `[2:10:3]` | `2` | `10` | `3` | `{{#example_out Examples/MonadTransformers/Do.lean rangeStartStopStepContents}}` |

<!-- Note that the starting number _is_ included in the range, while the stopping numbers is not.
All three arguments are `Nat`s, which means that ranges cannot count down—a range where the starting number is greater than or equal to the stopping number simply contains no numbers. -->

请注意，起始数 _包含_ 在范围内，而终止数不包含在范围内。
所有三个参数都是 `Nat`，这意味着范围不能向下计数 —— 当起始数大于或等于终止数时，范围中就不包含任何数字。

<!-- Ranges can be used with `for` loops to draw numbers from the range.
This program counts even numbers from four to eight: -->
范围可与 `for` 循环一起使用，从范围中抽取数字。
该程序将偶数从 4 数到 8：
```lean
{{#example_decl Examples/MonadTransformers/Do.lean fourToEight}}
```
<!-- Running it yields: -->
运行它会输出：
```output info
{{#example_out Examples/MonadTransformers/Do.lean fourToEightOut}}
```


<!-- Finally, `for` loops support iterating over multiple collections in parallel, by separating the `in` clauses with commas.
Looping halts when the first collection runs out of elements, so the declaration: -->
最后，`for` 循环支持并行迭代多个集合，方法是用逗号分隔 `in` 子句。
当第一个集合中的元素用完时，循环就会停止，因此定义：
```lean
{{#example_decl Examples/MonadTransformers/Do.lean parallelLoop}}
```
<!-- produces three lines of output: -->
产生如下输出：
```lean
{{#example_in Examples/MonadTransformers/Do.lean parallelLoopOut}}
```
```output info
{{#example_out Examples/MonadTransformers/Do.lean parallelLoopOut}}
```

<!-- ## Mutable Variables -->
## 可变变量

<!-- In addition to early `return`, `else`-less `if`, and `for` loops, Lean supports local mutable variables within a `do` block.
Behind the scenes, these mutable variables desugar to a use of `StateT`, rather than being implemented by true mutable variables.
Once again, functional programming is used to simulate imperative programming. -->
除了提前 `return`、无 `if` 的 `else` 和 `for` 循环之外，Lean 还支持在 `do` 代码块中使用局部可变变量。
在后台，这些可变变量是通过使用 `StateT` 来实现的，而不是通过真正的可变变量来实现。
函数式编程再次被用来模拟命令式编程。

<!-- A local mutable variable is introduced with `let mut` instead of plain `let`.
The definition `two`, which uses the identity monad `Id` to enable `do`-syntax without introducing any effects, counts to `2`: -->
使用 `let mut` 而不是普通的 `let` 来引入局部可变变量。
定义 `two` 使用恒等单子 `Id` 来启用 `do` 语法，但不引入任何副作用，计数到 `2`：
```lean
{{#example_decl Examples/MonadTransformers/Do.lean two}}
```
<!-- This code is equivalent to a definition that uses `StateT` to add `1` twice: -->
这段代码等同于使用 `StateT` 添加两次 `1` 的定义：
```lean
{{#example_decl Examples/MonadTransformers/Do.lean twoStateT}}
```

<!-- Local mutable variables work well with all the other features of `do`-notation that provide convenient syntax for monad transformers.
The definition `three` counts the number of entries in a three-entry list: -->
局部可变变量与 `do`-标记的所有其他特性配合得很好，这些特性为单子转换器提供了方便的语法。
定义 `three` 计算一个三条目列表中的条目数：
```lean
{{#example_decl Examples/MonadTransformers/Do.lean three}}
```
<!-- Similarly, `six` adds the entries in a list: -->
同样，`six` 将条目添加到一个列表中：
```lean
{{#example_decl Examples/MonadTransformers/Do.lean six}}
```

<!-- `List.count` counts the number of entries in a list that satisfy some check: -->
`List.count` 计算列表中满足某些检查条件的条目的数量：
```lean
{{#example_decl Examples/MonadTransformers/Do.lean ListCount}}
```

<!-- Local mutable variables can be more convenient to use and easier to read than an explicit local use of `StateT`.
However, they don't have the full power of unrestricted mutable variables from imperative languages.
In particular, they can only be modified in the `do`-block in which they are introduced.
This means, for instance, that `for`-loops can't be replaced by otherwise-equivalent recursive helper functions.
This version of `List.count`: -->
局部可变变量比局部显式使用 `StateT` 更方便，也更易于阅读。
然而，它们并不具备命令式语言中无限制的可变变量的全部功能。
特别是，它们只能在引入它们的 `do` 块中被修改。
例如，这意味着 `for` 循环不能被其他等价的递归辅助函数所替代。
该版本的 `List.count`：
```lean
{{#example_in Examples/MonadTransformers/Do.lean nonLocalMut}}
```
<!-- yields the following error on the attempted mutation of `found`: -->
在尝试修改 `found` 时产生以下错误：
```output info
{{#example_out Examples/MonadTransformers/Do.lean nonLocalMut}}
```
<!-- This is because the recursive function is written in the identity monad, and only the monad of the `do`-block in which the variable is introduced is transformed with `StateT`. -->
这是因为递归函数是用恒等单子编写的，只有引入变量的 `do` 块的单子才会被 `StateT` 转换。

<!-- ## What counts as a `do` block? -->
## 什么算作 `do` 区块？

<!-- Many features of `do`-notation apply only to a single `do`-block.
Early return terminates the current block, and mutable variables can only be mutated in the block that they are defined in.
To use them effectively, it's important to know what counts as "the same block". -->
`do`-标记的许多特性只适用于单个 `do` 块。
提前返回会终止当前代码块，可变变量只能在其定义的代码块中被改变。
要有效地使用它们，了解什么是 “同一代码块” 尤为重要。

<!-- Generally speaking, the indented block following the `do` keyword counts as a block, and the immediate sequence of statements underneath it are part of that block.
Statements in independent blocks that are nonetheless contained in a block are not considered part of the block.
However, the rules that govern what exactly counts as the same block are slightly subtle, so some examples are in order.
The precise nature of the rules can be tested by setting up a program with a mutable variable and seeing where the mutation is allowed.
This program has a mutation that is clearly in the same block as the mutable variable: -->
一般来说，`do` 关键字后的缩进块算作一个块，其下的语句序列是该块的一部分。
独立代码块中的语句如果包含在另一个代码块中，则不被视为该独立代码块的一部分。
不过，关于哪些语句属于同一代码块的规则略有微妙，因此需要举例说明。
可以通过设置一个带有可变变量的程序来测试规则的精确性，并查看允许修改的地方。
这个程序中的允许可变的区域显然与可变变量位于同一快中：
```lean
{{#example_decl Examples/MonadTransformers/Do.lean sameBlock}}
```

<!-- When a mutation occurs in a `do`-block that is part of a `let`-statement that defines a name using `:=`, then it is not considered to be part of the block: -->
如果变化发生在使用 `:=` 定义名称的 `let` 语句的一部分的 `do` 块中，则它不被视为该块的一部分：
```lean
{{#example_in Examples/MonadTransformers/Do.lean letBodyNotBlock}}
```
```output error
{{#example_out Examples/MonadTransformers/Do.lean letBodyNotBlock}}
```
<!-- However, a `do`-block that occurs under a `let`-statement that defines a name using `←` is considered part of the surrounding block.
The following program is accepted: -->
但是，在 `let` 语句下，使用 `←` 定义名称的 `do` 块被视为周围块的一部分。
以下程序是可以接受的：
```lean
{{#example_decl Examples/MonadTransformers/Do.lean letBodyArrBlock}}
```

<!-- Similarly, `do`-blocks that occur as arguments to functions are independent of their surrounding blocks.
The following program is not accepted: -->
同样，作为函数参数出现的 `do` 块与周围的块无关。
以下程序并不合理：
```lean
{{#example_in Examples/MonadTransformers/Do.lean funArgNotBlock}}
```
```output error
{{#example_out Examples/MonadTransformers/Do.lean funArgNotBlock}}
```

<!-- If the `do` keyword is completely redundant, then it does not introduce a new block.
This program is accepted, and is equivalent to the first one in this section: -->
如果 `do` 关键字完全是多余的，那么它就不会引入一个新的程序块。
这个程序可以接受，等同于本节的第一个程序：
```lean
{{#example_decl Examples/MonadTransformers/Do.lean collapsedBlock}}
```

<!-- The contents of branches under a `do` (such as those introduced by `match` or `if`) are considered to be part of the surrounding block, whether or not a redundant `do` is added.
The following programs are all accepted: -->
无论是否添加了多余的 `do` ，`do` 下的分支内容（例如由 `match` 或 `if` 引入的分支）都被视为周围程序块的一部分。
以下程序均可接受：
```lean
{{#example_decl Examples/MonadTransformers/Do.lean ifDoSame}}

{{#example_decl Examples/MonadTransformers/Do.lean ifDoDoSame}}

{{#example_decl Examples/MonadTransformers/Do.lean matchDoSame}}

{{#example_decl Examples/MonadTransformers/Do.lean matchDoDoSame}}
```
<!-- Similarly, the `do` that occurs as part of the `for` and `unless` syntax is just part of their syntax, and does not introduce a fresh `do`-block.
These programs are also accepted: -->
同样，作为 `for` 和 `unless` 语法的一部分出现的 `do` 只是其语法的一部分，并不引入新的 `do` 块。
这些程序也被接受：
```lean
{{#example_decl Examples/MonadTransformers/Do.lean doForSame}}

{{#example_decl Examples/MonadTransformers/Do.lean doUnlessSame}}
```


<!-- ## Imperative or Functional Programming? -->
## 命令式还是函数式编程？

<!-- The imperative features provided by Lean's `do`-notation allow many programs to very closely resemble their counterparts in languages like Rust, Java, or C#.
This resemblance is very convenient when translating an imperative algorithm into Lean, and some tasks are just most naturally thought of imperatively.
The introduction of monads and monad transformers enables imperative programs to be written in purely functional languages, and `do`-notation as a specialized syntax for monads (potentially locally transformed) allows functional programmers to have the best of both worlds: the strong reasoning principles afforded by immutability and a tight control over available effects through the type system are combined with syntax and libraries that allow programs that use effects to look familiar and be easy to read.
Monads and monad transformers allow functional versus imperative programming to be a matter of perspective. -->

Lean 的 `do`-标记提供的命令式特性让许多程序与 Rust、Java 或 C# 等语言中的对应程序非常相似。
在将命令式算法转化为 Lean 的算法时，这种相似性非常方便，而且有些任务可以很自然地以命令式的方式进行思考。
单子和单子转换器的引入使得命令式程序可以用纯函数式语言编写，而作为单子（可能是局部转换的）专用语法的 `do`-标记则让函数式程序员获得了两全其美的结果：不变性提供了强大的推理原则，通过类型系统对可用作用进行了严格控制，同时还结合了语法和库，使得具有副作用的程序看起来熟悉且易于阅读。
单子和单子转换器让函数式编程与命令式编程成为一个视角问题。

<!-- ## Exercises -->
## 练习

 <!-- * Rewrite `doug` to use `for` instead of the `doList` function. Are there other opportunities to use the features introduced in this section to improve the code? If so, use them! -->

 * 重写 `doug` 以使用 `for` 代替 `doList` 函数。是否还有其他机会使用本节介绍的功能来改进代码？如果有，请使用它们！