<!--
# Additional Conveniences
-->

# 其他便利功能

<!--
## Nested Actions
-->

## 嵌套活动

<!--
Many of the functions in `feline` exhibit a repetitive pattern in which an `IO` action's result is given a name, and then used immediately and only once.
For instance, in `dump`:
-->

`feline` 中的很多函数都表现出一种重复模式，其中 `IO` 操作的结果被赋予一个名称，
然后立即且仅使用一次。例如，在 `dump` 中：

```lean
{{#include ../../../examples/feline/2/Main.lean:dump}}
```

<!--
the pattern occurs for `stdout`:
-->

该模式出现在 `stdout` 中：

```lean
{{#include ../../../examples/feline/2/Main.lean:stdoutBind}}
```

<!--
Similarly, `fileStream` contains the following snippet:
-->

同样，`fileStream` 包含以下片段

```lean
{{#include ../../../examples/feline/2/Main.lean:fileExistsBind}}
```

<!--
When Lean is compiling a `do` block, expressions that consist of a left arrow immediately under parentheses are lifted to the nearest enclosing `do`, and their results are bound to a unique name.
This unique name replaces the origin of the expression.
This means that `dump` can also be written as follows:
-->

当 Lean 编译 `do` 块时，由括号下方的左箭头组成的表达式会被提升到最近的封闭
`do` 中，并且其结果会被绑定到一个唯一的名称。这个唯一名称替换了原始的表达式。
这意味着 `dump` 也可以写成如下形式：

```lean
{{#example_decl Examples/Cat.lean dump}}
```

<!--
This version of `dump` avoids introducing names that are used only once, which can greatly simplify a program.
`IO` actions that Lean lifts from a nested expression context are called _nested actions_.
-->

此版本的 `dump` 避免了引入仅使用一次的名称，这可以极大地简化程序。
Lean 从嵌套表达式上下文中提升的 `IO` 活动称为 **嵌套活动（Nested Action）** 。

<!--
`fileStream` can be simplified using the same technique:
-->

`fileStream` 也可以用相同的技巧来简化：

```lean
{{#example_decl Examples/Cat.lean fileStream}}
```

<!--
In this case, the local name of `handle` could also have been eliminated using nested actions, but the resulting expression would have been long and complicated.
Even though it's often good style to use nested actions, it can still sometimes be helpful to name intermediate results.
-->

在这种情况下，局部名称 `handle` 也可以使用嵌套操作来消除，
但由此产生的表达式会长而复杂。尽管使用嵌套操作通常是一种良好的代码风格，
但有时对中间结果进行命名仍然很有帮助。

<!--
It is important to remember, however, that nested actions are only a shorter notation for `IO` actions that occur in a surrounding `do` block.
The side effects that are involved in executing them still occur in the same order, and execution of side effects is not interspersed with the evaluation of expressions.
For an example of where this might be confusing, consider the following helper definitions that return data after announcing to the world that they have been executed:
-->

但需要记住的是，嵌套操作只是对包围在 `do` 块中的 `IO` 活动的一种简短记法。
执行它们所涉及的副作用仍然会以相同的顺序发生，并且副作用的执行不会与表达式的求值交替进行。
举个可能令人困惑的例子，请考虑以下辅助定义，它们在向世界宣布它们已被执行后才返回数据：

```lean
{{#example_decl Examples/Cat.lean getNumA}}

{{#example_decl Examples/Cat.lean getNumB}}
```

<!--
These definitions are intended to stand in for more complicated `IO` code that might validate user input, read a database, or open a file.
-->

这些定义旨在表达更复杂的 `IO` 代码，这些代码可能用于验证用户输入、读取数据库或打开文件。

<!--
A program that prints `0` when number A is five, or number `B` otherwise, can be written as follows:
-->

一个「当数字 `A` 为 5 时打印 `0`，否则打印数字 `B`」的程序可以写成如下形式：

```lean
{{#example_decl Examples/Cat.lean testEffects}}
```

<!--
However, this program probably has more side effects (such as prompting for user input or reading a database) than was intended.
The definition of `getNumA` makes it clear that it will always return `5`, and thus the program should not read number B.
However, running the program results in the following output:
-->

不过，此程序可能具有比预期更多的副作用（例如提示用户输入或读取数据库）。
`getNumA` 的定义明确指出它将始终返回 `5`，因此程序不应读取数字 `B`。
然而，运行此程序会产生以下输出：

```output info
{{#example_out Examples/Cat.lean runTest}}
```

<!--
`getNumB` was executed because `test` is equivalent to this definition:
-->

`getNumB` 被执行是因为 `test` 等价于以下定义：

```lean
{{#example_decl Examples/Cat.lean testEffectsExpanded}}
```

<!--
This is due to the rule that nested actions are lifted to the _closest enclosing_ `do` block.
The branches of the `if` were not implicitly wrapped in `do` blocks because the `if` is not itself a statement in the `do` block—the statement is the `let` that defines `a`.
Indeed, they could not be wrapped this way, because the type of the conditional expression is `Nat`, not `IO Nat`.
-->

这是因为嵌套活动会被提升到最近的包含 `do` 块的规则。`if` 的分支没有被隐式地包装在 `do` 块中，
因为 `if` 本身不是 `do` 块中的语句，语句是定义 `a` 的 `let`。
事实上，它们不能以这种方式包装，因为条件表达式的类型是 `Nat`，而非 `IO Nat`。

<!--
## Flexible Layouts for `do`
-->

## `do` 的灵活布局

<!--
In Lean, `do` expressions are whitespace-sensitive.
Each `IO` action or local binding in the `do` is expected to start on its own line, and they should all have the same indentation.
Almost all uses of `do` should be written this way.
In some rare contexts, however, manual control over whitespace and indentation may be necessary, or it may be convenient to have multiple small actions on a single line.
In these cases, newlines can be replaced with a semicolon and indentation can be replaced with curly braces.
-->

在 Lean 中，`do` 表达式对空格敏感。`do` 中的每个 `IO` 活动或局部绑定都应该从自己的行开始，
并且它们都应该有相同的缩进。几乎所有 `do` 的用法都应该这样写。
然而，在一些罕见的情况下，可能需要手动控制空格和缩进，或者在单行上有多个小的活动可能会很方便。
在这些情况下，换行符可以替换为分号，缩进可以替换为花括号。

<!--
For instance, all of the following programs are equivalent:
-->

例如，以下所有程序都是等价的：

```lean
{{#example_decl Examples/Cat.lean helloOne}}

{{#example_decl Examples/Cat.lean helloTwo}}

{{#example_decl Examples/Cat.lean helloThree}}
```

<!--
Idiomatic Lean code uses curly braces with `do` very rarely.
-->

地道的 Lean 代码极少使用带有 `do` 的大括号。

<!--
## Running `IO` Actions With `#eval`
-->

## 用 `#eval` 运行 `IO` 活动

<!--
Lean's `#eval` command can be used to execute `IO` actions, rather than just evaluating them.
Normally, adding a `#eval` command to a Lean file causes Lean to evaluate the provided expression, convert the resulting value to a string, and provide that string as a tooltip and in the info window.
Rather than failing because `IO` actions can't be converted to strings, `#eval` executes them, carrying out their side effects.
If the result of execution is the `Unit` value `()`, then no result string is shown, but if it is a type that can be converted to a string, then Lean displays the resulting value.
-->

Lean 的 `#eval` 命令可用于执行 `IO` 活动，而不仅仅是对它们进行求值。
通常，向 Lean 文件添加 `#eval` 命令会让 Lean 求值提供的表达式，然后将结果值转换为字符串，
并在工具提示和信息窗口中提供该字符串。`#eval` 不会因为 `IO` 活动无法转换为字符串而失败，
而是执行它们，并执行它们的副作用。如果执行结果是 `Unit` 值 `()`，则不显示结果字符串，
但如果它是可以转换为字符串的类型，则 Lean 会显示结果值。

<!--
This means that, given the prior definitions of `countdown` and `runActions`,
-->

这意味着，给定 `countdown` 和 `runActions`,

```lean
{{#example_in Examples/HelloWorld.lean evalDoesIO}}
```

<!--
displays
-->

会显示

```output info
{{#example_out Examples/HelloWorld.lean evalDoesIO}}
```

<!--
This is the output produced by running the `IO` action, rather than some opaque representation of the action itself.
In other words, for `IO` actions, `#eval` both _evaluates_ the provided expression and _executes_ the resulting action value.
-->

这是运行 `IO` 活动产生的输出，而不是活动本身的不透明表示。
换句话说，对于 `IO` 活动，`#eval` 既 **求值（Evaluate）** 提供的表达式，
又 **执行（Execute）** 结果活动值。

<!--
Quickly testing `IO` actions with `#eval` can be much more convenient that compiling and running whole programs.
However, there are some limitations.
For instance, reading from standard input simply returns empty input.
Additionally, the `IO` action is re-executed whenever Lean needs to update the diagnostic information that it provides to users, and this can happen at unpredictable times.
An action that reads and writes files, for instance, may do so at inconvenient times.
-->

使用 `#eval` 快速测试 `IO` 动作比编译和运行整个程序方便得多，只是有一些限制。
例如，从标准输入读取只会返回空输入。此外，每当 Lean 需要更新它提供给用户的诊断信息时，
`IO` 动作都会重新执行，这可能会在难以预料的时间发生。
例如，读取和写入文件的动作可能会在不合适的时间执行。
