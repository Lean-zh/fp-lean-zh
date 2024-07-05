<!--
# Step By Step
-->

# 逐步执行

<!--
A `do` block can be executed one line at a time.
Start with the program from the prior section:
-->

`do` 块可以逐行执行。从上一节的程序开始：

```lean
{{#include ../../../examples/hello-name/HelloName.lean:block1}}
```

<!--
## Standard IO
-->

## 标准 IO

<!--
The first line is `{{#include ../../../examples/hello-name/HelloName.lean:line1}}`, while the remainder is:
-->

第一行是 `{{#include ../../../examples/hello-name/HelloName.lean:line1}}`，其余部分是：

```lean
{{#include ../../../examples/hello-name/HelloName.lean:block2}}
```

<!--
To execute a `let` statement that uses a `←`, start by evaluating the expression to the right of the arrow (in this case, `IO.getStdIn`).
Because this expression is just a variable, its value is looked up.
The resulting value is a built-in primitive `IO` action.
The next step is to execute this `IO` action, resulting in a value that represents the standard input stream, which has type `IO.FS.Stream`.
Standard input is then associated with the name to the left of the arrow (here `stdin`) for the remainder of the `do` block.
-->

要执行使用 `←` 的 `let` 语句，首先求值箭头右侧的表达式（在本例中为 `IO.getStdIn`）。
因为该表达式只是一个变量，所以查找它的值。结果值是一个内置的 `IO` 原语活动。
下一步是执行此 `IO` 活动，结果是一个表示标准输入流的值，其类型为 `IO.FS.Stream`。
然后将标准输入与箭头左侧的名称（此处为 `stdin`）关联，以用于 `do` 块的其余部分。"

<!--
Executing the second line, `{{#include ../../../examples/hello-name/HelloName.lean:line2}}`, proceeds similarly.
First, the expression `IO.getStdout` is evaluated, yielding an `IO` action that will return the standard output.
Next, this action is executed, actually returning the standard output.
Finally, this value is associated with the name `stdout` for the remainder of the `do` block.
-->

执行第二行 `{{#include ../../../examples/hello-name/HelloName.lean:line2}}` 的过程类似。
首先，求值表达式 `IO.getStdout`，得到一个 `IO` 活动，该活动将返回标准输出。
接下来，执行此活动，实际返回标准输出。最后，将此值与 `do` 块的其余部分关联起来，并命名为 `stdout`。"

<!--
## Asking a Question
-->

## 提问

<!--
Now that `stdin` and `stdout` have been found, the remainder of the block consists of a question and an answer:
-->

现在已经有了 `stdin` 和 `stdout`，该代码块的其余部分包括一个问题和一个答案：

```lean
{{#include ../../../examples/hello-name/HelloName.lean:block3}}
```

<!--
The first statement in the block, `{{#include ../../../examples/hello-name/HelloName.lean:line3}}`, consists of an expression.
To execute an expression, it is first evaluated.
In this case, `IO.FS.Stream.putStrLn` has type `IO.FS.Stream → String → IO Unit`.
This means that it is a function that accepts a stream and a string, returning an `IO` action.
The expression uses [accessor notation](../getting-to-know/structures.md#behind-the-scenes) for a function call.
This function is applied to two arguments: the standard output stream and a string.
The value of the expression is an `IO` action that will write the string and a newline character to the output stream.
Having found this value, the next step is to execute it, which causes the string and newline to actually be written to `stdout`.
Statements that consist only of expressions do not introduce any new variables.
-->

该代码块中的第一个语句 `{{#include ../../../examples/hello-name/HelloName.lean:line3}}`
由一个表达式组成。要执行一个表达式，首先要对其进行求值。在这种情况下，`IO.FS.Stream.putStrLn`
的类型为 `IO.FS.Stream → String → IO Unit`。这意味着它是一个接受流和字符串并返回 `IO` 活动的函数。
该表达式使用[访问器记法](../getting-to-know/structures.md#幕后)进行函数调用。
此函数应用于两个参数：标准输出流和字符串。表达式的值为一个 `IO` 活动，
该活动将字符串和换行符写入输出流。得到此值后，下一步是执行它，这会导致字符串和换行符写入到
`stdout`。仅由表达式组成的语句不会引入任何新变量。

<!--
The next statement in the block is `{{#include ../../../examples/hello-name/HelloName.lean:line4}}`.
`IO.FS.Stream.getLine` has type `IO.FS.Stream → IO String`, which means that it is a function from a stream to an `IO` action that will return a string.
Once again, this is an example of accessor notation.
This `IO` action is executed, and the program waits until the user has typed a complete line of input.
Assume the user writes "`David`".
The resulting line (`"David\n"`) is associated with `input`, where the escape sequence `\n` denotes the newline character.
-->

下一条语句是 `{{#include ../../../examples/hello-name/HelloName.lean:line4}}`。
`IO.FS.Stream.getLine` 的类型为 `IO.FS.Stream → IO String`，
这意味着它是一个从流到 `IO` 活动的函数，该函数将返回一个字符串。
同样，这也是访问器表示法的示例。此 `IO` 活动被执行时，程序会等待用户键入一行完整的输入。
假设用户输入了「`David`」，则结果行（「`David\n`」）会与 `input` 关联，其中转义序列 `\n` 表示换行符。

```lean
{{#include ../../../examples/hello-name/HelloName.lean:block5}}
```

<!--
The next line, `{{#include ../../../examples/hello-name/HelloName.lean:line5}}`, is a `let` statement.
Unlike the other `let` statements in this program, it uses `:=` instead of `←`.
This means that the expression will be evaluated, but the resulting value need not be an `IO` action and will not be executed.
In this case, `String.dropRightWhile` takes a string and a predicate over characters and returns a new string from which all the characters at the end of the string that satisfy the predicate have been removed.
For example,
-->

下一行 `let name := input.dropRightWhile Char.isWhitespace` 是一个 `let` 语句。
与本程序中的其他 `let` 语句不同，它使用 `:=` 而不是 `←`。这意味着将计算表达式，
但结果值不必是 `IO` 活动，并且不会执行。在这种情况下，`String.dropRightWhile`
接受一个字符串和一个字符的谓词，并返回一个新字符串，其中字符串末尾满足谓词的所有字符都会被删除。例如，

```lean
{{#example_in Examples/HelloWorld.lean dropBang}}
```

<!--
yields
-->

会产生

```output info
{{#example_out Examples/HelloWorld.lean dropBang}}
```

<!--
and
-->

而

```lean
{{#example_in Examples/HelloWorld.lean dropNonLetter}}
```

<!--
yields
-->

会产生

```output info
{{#example_out Examples/HelloWorld.lean dropNonLetter}}
```

<!--
in which all non-alphanumeric characters have been removed from the right side of the string.
In the current line of the program, whitespace characters (including the newline) are removed from the right side of the input string, resulting in `"David"`, which is associated with `name` for the remainder of the block.
-->

其中所有非字母数字的字符均已从字符串的右侧删除。在程序的当前行中，
空格符（包括换行符）从输入字符串的右侧删除，得到 「`David`」，
它在代码块的剩余部分与 `name` 关联。

<!--
## Greeting the User
-->

## 向用户问好

<!--
All that remains to be executed in the `do` block is a single statement:
-->

`do` 块中剩余要执行的只有一条语句：

```lean
{{#include ../../../examples/hello-name/HelloName.lean:line6}}
```

<!--
The string argument to `putStrLn` is constructed via string interpolation, yielding the string `"Hello, David!"`.
Because this statement is an expression, it is evaluated to yield an `IO` action that will print this string with a newline to standard output.
Once the expression has been evaluated, the resulting `IO` action is executed, resulting in the greeting.
-->

传递给 `putStrLn` 的字符串参数通过字符串插值构建，生成字符串 `"Hello, David!"`。
由于此语句是一个表达式，因此它被求值以生成一个 `IO` 活动，
该活动会将此字符串后加上换行符打印到标准输出。表达式求值后，将执行生成的 `IO` 活动，从而生成问候语。

<!--
## `IO` Actions as Values
-->

<!--
## `IO` Actions as Values
-->

## `IO` 活动作为值

<!--
In the above description, it can be difficult to see why the distinction between evaluating expressions and executing `IO` actions is necessary.
After all, each action is executed immediately after it is produced.
Why not simply carry out the effects during evaluation, as is done in other languages?
-->

在上面的描述中，可能很难看出为什么需要区分求值表达式和执行 `IO` 活动。
毕竟，每个活动在生成后都会立即执行。为什么不干脆在求值期间执行副作用，
就像在其他语言中所做的那样呢？

<!--
The answer is twofold.
First off, separating evaluation from execution means that programs must be explicit about which functions can have side effects.
Because the parts of the program that do not have effects are much more amenable to mathematical reasoning, whether in the heads of programmers or using Lean's facilities for formal proof, this separation can make it easier to avoid bugs.
Secondly, not all `IO` actions need be executed at the time that they come into existence.
The ability to mention an action without carrying it out allows ordinary functions to be used as control structures.
-->

答案有两个。首先，将求值与执行分开意味着程序必须明确说明哪些函数可以产生副作用。
由于没有副作用的程序部分更适合数学推理，无论是在程序员的头脑中还是使用 Lean 的形式化证明工具，
这种分离可以更容易地避免错误。其次，并非所有 `IO` 活动都需要在它们产生时执行。
在不执行活动的情况下提及活动的能力能够将普通函数用作控制结构。

<!--
For instance, the function `twice` takes an `IO` action as its argument, returning a new action that will execute the first one twice.
-->

例如，函数 `twice` 将 `IO` 活动作为其参数，返回一个新的活动，该活动将第一个活动执行两次。

```lean
{{#example_decl Examples/HelloWorld.lean twice}}
```

<!--
For instance, executing
-->

例如，执行

```lean
{{#example_in Examples/HelloWorld.lean twiceShy}}
```

<!--
results in
-->

会打印

```output info
{{#example_out Examples/HelloWorld.lean twiceShy}}
```

<!--
being printed.
This can be generalized to a version that runs the underlying action any number of times:
-->

这可以推广为一个通用函数，它可以运行底层活动任意次：

```lean
{{#example_decl Examples/HelloWorld.lean nTimes}}
```

<!--
In the base case for `Nat.zero`, the result is `pure ()`.
The function `pure` creates an `IO` action that has no side effects, but returns `pure`'s argument, which in this case is the constructor for `Unit`.
As an action that does nothing and returns nothing interesting, `pure ()` is at the same time utterly boring and very useful.
In the recursive step, a `do` block is used to create an action that first executes `action` and then executes the result of the recursive call.
Executing `{{#example_in Examples/HelloWorld.lean nTimes3}}` causes the following output:
-->

在 `Nat.zero` 的基本情况下，结果是 `pure ()`。函数 `pure` 创建一个没有副作用的 `IO` 活动，
但返回 `pure` 的参数，在本例中是 `Unit` 的构造子。作为不执行任何活动且不返回任何有趣内容的活动，
`pure ()` 既非常无聊又非常有用。在递归步骤中，`do` 块用于创建一个活动，该活动首先执行 `action`，
然后执行递归调用的结果。执行 `{{#example_in Examples/HelloWorld.lean nTimes3}}` 会输出以下内容：

```output info
{{#example_out Examples/HelloWorld.lean nTimes3}}
```

<!--
In addition to using functions as control structures, the fact that `IO` actions are first-class values means that they can be saved in data structures for later execution.
For instance, the function `countdown` takes a `Nat` and returns a list of unexecuted `IO` actions, one for each `Nat`:
-->

除了将函数用作控制结构体之外，`IO` 活动是一等值的事实意味着它们可以保存在数据结构中供以后执行。
例如，函数 `countdown` 接受一个 `Nat` 并返回一个未执行的 `IO` 活动列表，每个 `Nat` 对应一个：

```lean
{{#example_decl Examples/HelloWorld.lean countdown}}
```

<!--
This function has no side effects, and does not print anything.
For example, it can be applied to an argument, and the length of the resulting list of actions can be checked:
-->

此函数没有副作用，并且不打印任何内容。例如，它可以应用于一个参数，并且可以检查结果活动列表的长度：

```lean
{{#example_decl Examples/HelloWorld.lean from5}}
```

<!--
This list contains six elements (one for each number, plus a `"Blast off!"` action for zero):
-->

此列表包含六个元素（每个数字一个，外加一个对应零的 `"Blast off!"` 活动）：

```lean
{{#example_in Examples/HelloWorld.lean from5length}}
```

```output info
{{#example_out Examples/HelloWorld.lean from5length}}
```

<!--
The function `runActions` takes a list of actions and constructs a single action that runs them all in order:
-->

函数 `runActions` 接受一个活动列表，并构造一个按顺序运行所有活动的单个活动：

```lean
{{#example_decl Examples/HelloWorld.lean runActions}}
```

<!--
Its structure is essentially the same as that of `nTimes`, except instead of having one action that is executed for each `Nat.succ`, the action under each `List.cons` is to be executed.
Similarly, `runActions` does not itself run the actions.
It creates a new action that will run them, and that action must be placed in a position where it will be executed as a part of `main`:
-->

其结构本质上与 `nTimes` 相同，只是没有一个对每个 `Nat.succ` 执行的活动，
而是在每个 `List.cons` 下的活动将被执行。类似地，`runActions` 本身不会运行这些活动。
而是创建一个将要运行这些活动的新活动，并且该活动必须放置在将作为 `main` 的一部分执行的位置：

```lean
{{#example_decl Examples/HelloWorld.lean main}}
```

<!--
Running this program results in the following output:
-->

运行此程序会产生以下输出：

```output info
{{#example_out Examples/HelloWorld.lean countdown5}}
```

<!--
What happens when this program is run?
The first step is to evaluate `main`. That occurs as follows:
-->

当运行此程序时会发生什么？第一步是求值 `main`，它产生如下输出：

```lean
{{#example_eval Examples/HelloWorld.lean evalMain}}
```

<!--
The resulting `IO` action is a `do` block.
Each step of the `do` block is then executed, one at a time, yielding the expected output.
The final step, `pure ()`, does not have any effects, and it is only present because the definition of `runActions` needs a base case.
-->

产生的 `IO` 活动是一个 `do` 块。然后逐个执行 `do` 块的每个步骤，产生预期的输出。
最后一步 `pure ()` 没有产生任何作用，它的存在只是因为 `runActions` 的定义需要一个基本情况。

<!--
## Exercise
-->

## 练习

<!--
Step through the execution of the following program on a piece of paper:
-->

在纸上逐步执行以下程序：

```lean
{{#example_decl Examples/HelloWorld.lean ExMain}}
```

<!--
While stepping through the program's execution, identify when an expression is being evaluated and when an `IO` action is being executed.
When executing an `IO` action results in a side effect, write it down.
After doing this, run the program with Lean and double-check that your predictions about the side effects were correct.
-->

在逐步执行程序时，要察觉到何时正在求值表达式，以及何时正在执行 `IO` 活动。
当执行 `IO` 活动产生副作用时，请将其写下来。在纸上执行完毕后，使用 Lean 运行程序，
并仔细检查你对副作用的预测是否正确。
