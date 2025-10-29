import VersoManual
import FPLeanZh.Examples


open Verso.Genre Manual
open Verso Code External

open FPLeanZh

set_option verso.exampleProject "../examples"
set_option verso.exampleModule "HelloName"

example_module Examples.HelloWorld

-- Step By Step
#doc (Manual) "逐步执行" =>
%%%
file := "HelloWorld/StepByStep"
tag := "step-by-step"
%%%

-- A {moduleTerm}`do` block can be executed one line at a time.
-- Start with the program from the prior section:

{moduleTerm}`do` 块可以一次执行一行。
从前一节的程序开始：

```anchor block1
  let stdin ← IO.getStdin
  let stdout ← IO.getStdout
  stdout.putStrLn "How would you like to be addressed?"
  let input ← stdin.getLine
  let name := input.dropRightWhile Char.isWhitespace
  stdout.putStrLn s!"Hello, {name}!"
```

-- # Standard IO
# 标准 IO
%%%
tag := "stdio"
%%%

-- The first line is {anchor line1}`let stdin ← IO.getStdin`, while the remainder is:

第一行是 {anchor line1}`let stdin ← IO.getStdin`，而其余部分是：
```anchor block2
  let stdout ← IO.getStdout
  stdout.putStrLn "How would you like to be addressed?"
  let input ← stdin.getLine
  let name := input.dropRightWhile Char.isWhitespace
  stdout.putStrLn s!"Hello, {name}!"
```

-- To execute a {kw}`let` statement that uses a {anchorTerm block2}`←`, start by evaluating the expression to the right of the arrow (in this case, {moduleTerm}`IO.getStdin`).
-- Because this expression is just a variable, its value is looked up.
-- The resulting value is a built-in primitive {moduleTerm}`IO` action.
-- The next step is to execute this {moduleTerm}`IO` action, resulting in a value that represents the standard input stream, which has type {moduleTerm}`IO.FS.Stream`.
-- Standard input is then associated with the name to the left of the arrow (here {anchorTerm line1}`stdin`) for the remainder of the {moduleTerm}`do` block.

要执行使用 {anchorTerm block2}`←` 的 {kw}`let` 语句，首先求值箭头右侧的表达式（在这种情况下是 {moduleTerm}`IO.getStdin`）。
因为这个表达式只是一个变量，所以查找其值。
得到的值是内置的原始 {moduleTerm}`IO` 动作。
下一步是执行这个 {moduleTerm}`IO` 动作，得到一个表示标准输入流的值，其类型为 {moduleTerm}`IO.FS.Stream`。
然后在 {moduleTerm}`do` 块的其余部分中，标准输入与箭头左侧的名称（这里是 {anchorTerm line1}`stdin`）关联。

-- Executing the second line, {anchor line2}`let stdout ← IO.getStdout`, proceeds similarly.
-- First, the expression {moduleTerm}`IO.getStdout` is evaluated, yielding an {moduleTerm}`IO` action that will return the standard output.
-- Next, this action is executed, actually returning the standard output.
-- Finally, this value is associated with the name {anchorTerm line2}`stdout` for the remainder of the {moduleTerm}`do` block.

执行第二行 {anchor line2}`let stdout ← IO.getStdout` 也类似进行。
首先，求值表达式 {moduleTerm}`IO.getStdout`，产生一个将返回标准输出的 {moduleTerm}`IO` 动作。
接下来，执行这个动作，实际返回标准输出。
最后，这个值与名称 {anchorTerm line2}`stdout` 关联，用于 {moduleTerm}`do` 块的其余部分。

-- # Asking a Question
# 提问
%%%
tag := "asking-a-question"
%%%

-- Now that {anchorTerm line1}`stdin` and {anchorTerm line2}`stdout` have been found, the remainder of the block consists of a question and an answer:

现在已经找到了 {anchorTerm line1}`stdin` 和 {anchorTerm line2}`stdout`，块的其余部分包括一个问题和一个答案：
```anchor block3
  stdout.putStrLn "How would you like to be addressed?"
  let input ← stdin.getLine
  let name := input.dropRightWhile Char.isWhitespace
  stdout.putStrLn s!"Hello, {name}!"
```

-- The first statement in the block, {anchor line3}`stdout.putStrLn "How would you like to be addressed?"`, consists of an expression.
-- To execute an expression, it is first evaluated.
-- In this case, {moduleTerm}`IO.FS.Stream.putStrLn` has type {moduleTerm}`IO.FS.Stream → String → IO Unit`.
-- This means that it is a function that accepts a stream and a string, returning an {moduleTerm}`IO` action.
-- The expression uses {ref "behind-the-scenes"}[accessor notation] for a function call.
-- This function is applied to two arguments: the standard output stream and a string.
-- The value of the expression is an {moduleTerm}`IO` action that will write the string and a newline character to the output stream.
-- Having found this value, the next step is to execute it, which causes the string and newline to actually be written to {anchorTerm setup}`stdout`.
-- Statements that consist only of expressions do not introduce any new variables.

块中的第一个语句 {anchor line3}`stdout.putStrLn "How would you like to be addressed?"` 由一个表达式组成。
要执行表达式，首先要对其求值。
在这种情况下，{moduleTerm}`IO.FS.Stream.putStrLn` 的类型是 {moduleTerm}`IO.FS.Stream → String → IO Unit`。
这意味着它是一个接受流和字符串的函数，返回一个 {moduleTerm}`IO` 动作。
表达式使用 {ref "behind-the-scenes"}[访问器记法] 进行函数调用。
此函数应用于两个参数：标准输出流和字符串。
表达式的值是一个 {moduleTerm}`IO` 动作，它将把字符串和换行符写入输出流。
找到这个值后，下一步是执行它，这会导致字符串和换行符实际写入 {anchorTerm setup}`stdout`。
仅由表达式组成的语句不引入任何新变量。

-- The next statement in the block is {anchor line4}`let input ← stdin.getLine`.
-- {moduleTerm}`IO.FS.Stream.getLine` has type {moduleTerm}`IO.FS.Stream → IO String`, which means that it is a function from a stream to an {moduleTerm}`IO` action that will return a string.
-- Once again, this is an example of accessor notation.
-- This {moduleTerm}`IO` action is executed, and the program waits until the user has typed a complete line of input.
-- Assume the user writes “{lit}`David`”.
-- The resulting line ({lit}`"David\n"`) is associated with {anchorTerm block5}`input`, where the escape sequence {lit}`\n` denotes the newline character.

块中的下一个语句是 {anchor line4}`let input ← stdin.getLine`。
{moduleTerm}`IO.FS.Stream.getLine` 的类型是 {moduleTerm}`IO.FS.Stream → IO String`，这意味着它是从流到将返回字符串的 {moduleTerm}`IO` 动作的函数。
这又是访问器记法的一个例子。
执行这个 {moduleTerm}`IO` 动作，程序等待用户输入完整的一行。
假设用户写入 “{lit}`David`”。
得到的行（{lit}`"David\n"`）与 {anchorTerm block5}`input` 关联，其中转义序列 {lit}`\n` 表示换行符。

```anchor block5
  let name := input.dropRightWhile Char.isWhitespace
  stdout.putStrLn s!"Hello, {name}!"
```

-- The next line, {anchor line5}`let name := input.dropRightWhile Char.isWhitespace`, is a {kw}`let` statement.
-- Unlike the other {kw}`let` statements in this program, it uses {anchorTerm block5}`:=` instead of {anchorTerm line4}`←`.
-- This means that the expression will be evaluated, but the resulting value need not be an {moduleTerm}`IO` action and will not be executed.
-- In this case, {moduleTerm}`String.dropRightWhile` takes a string and a predicate over characters and returns a new string from which all the characters at the end of the string that satisfy the predicate have been removed.
-- For example,

下一行 {anchor line5}`let name := input.dropRightWhile Char.isWhitespace` 是一个 {kw}`let` 语句。
与该程序中的其他 {kw}`let` 语句不同，它使用 {anchorTerm block5}`:=` 而不是 {anchorTerm line4}`←`。
这意味着表达式将被求值，但结果值不需要是 {moduleTerm}`IO` 动作，也不会被执行。
在这种情况下，{moduleTerm}`String.dropRightWhile` 接受一个字符串和一个字符上的谓词，并返回一个新字符串，从中删除了字符串末尾满足谓词的所有字符。
例如，

```anchorTerm dropBang (module := Examples.HelloWorld)
#eval "Hello!!!".dropRightWhile (· == '!')
```
```anchorInfo dropBang (module := Examples.HelloWorld)
"Hello"
```

-- and
以及

```anchorTerm dropNonLetter (module := Examples.HelloWorld)
#eval "Hello...   ".dropRightWhile (fun c => not (c.isAlphanum))
```

-- yields
产生

```anchorInfo dropNonLetter (module := Examples.HelloWorld)
"Hello"
```

-- in which all non-alphanumeric characters have been removed from the right side of the string.

-- In the current line of the program, whitespace characters (including the newline) are removed from the right side of the input string, resulting in {moduleTerm (module := Examples.HelloWorld)}`"David"`, which is associated with {anchorTerm block5}`name` for the remainder of the block.

其中所有非字母数字字符都从字符串的右侧被删除。
在程序的当前行中，空白字符（包括换行符）从输入字符串的右侧被删除，得到 {moduleTerm (module := Examples.HelloWorld)}`"David"`，它与 {anchorTerm block5}`name` 关联，用于块的其余部分。

-- # Greeting the User
# 问候用户
%%%
tag := "greeting"
%%%

-- All that remains to be executed in the {moduleTerm}`do` block is a single statement:

{moduleTerm}`do` 块中剩下要执行的只有一个语句：
```anchor line6
  stdout.putStrLn s!"Hello, {name}!"
```

-- The string argument to {anchorTerm line6}`putStrLn` is constructed via string interpolation, yielding the string {moduleTerm (module := Examples.HelloWorld)}`"Hello, David!"`.
-- Because this statement is an expression, it is evaluated to yield an {moduleTerm}`IO` action that will print this string with a newline to standard output.
-- Once the expression has been evaluated, the resulting {moduleTerm}`IO` action is executed, resulting in the greeting.

传递给 {anchorTerm line6}`putStrLn` 的字符串参数通过字符串插值构造，产生字符串 {moduleTerm (module := Examples.HelloWorld)}`"Hello, David!"`。
由于这个语句是一个表达式，它被求值以产生一个 {moduleTerm}`IO` 动作，该动作将把这个字符串和换行符打印到标准输出。
一旦表达式被求值，生成的 {moduleTerm}`IO` 动作就被执行，产生问候语。

-- # {lit}`IO` Actions as Values
# {lit}`IO` 动作作为值
%%%
tag := "actions-as-values"
%%%

-- In the above description, it can be difficult to see why the distinction between evaluating expressions and executing {moduleTerm}`IO` actions is necessary.
-- After all, each action is executed immediately after it is produced.
-- Why not simply carry out the effects during evaluation, as is done in other languages?

在上面的描述中，可能很难看出为什么求值表达式和执行 {moduleTerm}`IO` 动作之间的区别是必要的。
毕竟，每个动作都在产生后立即执行。
为什么不像其他语言那样在求值期间简单地执行效果呢？

-- The answer is twofold.
-- First off, separating evaluation from execution means that programs must be explicit about which functions can have side effects.
-- Because the parts of the program that do not have effects are much more amenable to mathematical reasoning, whether in the heads of programmers or using Lean's facilities for formal proof, this separation can make it easier to avoid bugs.
-- Secondly, not all {moduleTerm}`IO` actions need be executed at the time that they come into existence.
-- The ability to mention an action without carrying it out allows ordinary functions to be used as control structures.

答案是双重的。
首先，将求值与执行分离意味着程序必须明确哪些函数可以有副作用。
因为程序中没有效果的部分更容易进行数学推理，无论是在程序员的头脑中还是使用 Lean 的形式证明工具，这种分离可以使避免错误变得更容易。
其次，并非所有的 {moduleTerm}`IO` 动作都需要在产生时立即执行。
在不执行动作的情况下提及动作的能力允许普通函数用作控制结构。


-- For example, the function {anchorName twice (module:=Examples.HelloWorld)}`twice` takes an {moduleTerm}`IO` action as its argument, returning a new action that will execute the argument action twice.

例如，函数 {anchorName twice (module:=Examples.HelloWorld)}`twice` 接受一个 {moduleTerm}`IO` 动作作为其参数，返回一个将执行参数动作两次的新动作。

```anchor twice (module := Examples.HelloWorld)
def twice (action : IO Unit) : IO Unit := do
  action
  action
```

-- Executing
执行

```anchorTerm twiceShy (module := Examples.HelloWorld)
twice (IO.println "shy")
```

-- results in
结果是

```anchorInfo twiceShy (module := Examples.HelloWorld)
shy
shy
```

-- being printed.
-- This can be generalized to a version that runs the underlying action any number of times:

被打印出来。
这可以推广为运行底层动作任意次数的版本：

```anchor nTimes (module := Examples.HelloWorld)
def nTimes (action : IO Unit) : Nat → IO Unit
  | 0 => pure ()
  | n + 1 => do
    action
    nTimes action n
```


-- In the base case for {moduleTerm (module := Examples.HelloWorld)}`Nat.zero`, the result is {moduleTerm (module := Examples.HelloWorld)}`pure ()`.
-- The function {moduleTerm (module := Examples.HelloWorld)}`pure` creates an {moduleTerm (module := Examples.HelloWorld)}`IO` action that has no side effects, but returns {moduleTerm (module := Examples.HelloWorld)}`pure`'s argument, which in this case is the constructor for {moduleTerm (module := Examples.HelloWorld)}`Unit`.
-- As an action that does nothing and returns nothing interesting, {moduleTerm (module := Examples.HelloWorld)}`pure ()` is at the same time utterly boring and very useful.
-- In the recursive step, a {moduleTerm (module := Examples.HelloWorld)}`do` block is used to create an action that first executes {moduleTerm (module := Examples.HelloWorld)}`action` and then executes the result of the recursive call.
-- Executing {anchor nTimes3 (module := Examples.HelloWorld)}`#eval nTimes (IO.println "Hello") 3` causes the following output:

在 {moduleTerm (module := Examples.HelloWorld)}`Nat.zero` 的基本情况中，结果是 {moduleTerm (module := Examples.HelloWorld)}`pure ()`。
函数 {moduleTerm (module := Examples.HelloWorld)}`pure` 创建一个没有副作用的 {moduleTerm (module := Examples.HelloWorld)}`IO` 动作，但返回 {moduleTerm (module := Examples.HelloWorld)}`pure` 的参数，在这种情况下是 {moduleTerm (module := Examples.HelloWorld)}`Unit` 的构造函数。
作为一个什么也不做且不返回任何有趣内容的动作，{moduleTerm (module := Examples.HelloWorld)}`pure ()` 既完全无聊又非常有用。
在递归步骤中，使用 {moduleTerm (module := Examples.HelloWorld)}`do` 块创建一个动作，该动作首先执行 {moduleTerm (module := Examples.HelloWorld)}`action`，然后执行递归调用的结果。
执行 {anchor nTimes3 (module := Examples.HelloWorld)}`#eval nTimes (IO.println "Hello") 3` 会产生以下输出：

```anchorInfo nTimes3 (module := Examples.HelloWorld)
Hello
Hello
Hello
```



-- In addition to using functions as control structures, the fact that {moduleTerm (module := Examples.HelloWorld)}`IO` actions are first-class values means that they can be saved in data structures for later execution.
-- For instance, the function {moduleName (module := Examples.HelloWorld)}`countdown` takes a {moduleTerm (module := Examples.HelloWorld)}`Nat` and returns a list of unexecuted {moduleTerm (module := Examples.HelloWorld)}`IO` actions, one for each {moduleTerm (module := Examples.HelloWorld)}`Nat`:

除了将函数用作控制结构外，{moduleTerm (module := Examples.HelloWorld)}`IO` 动作是一等值的事实意味着它们可以保存在数据结构中以供以后执行。
例如，函数 {moduleName (module := Examples.HelloWorld)}`countdown` 接受一个 {moduleTerm (module := Examples.HelloWorld)}`Nat` 并返回未执行的 {moduleTerm (module := Examples.HelloWorld)}`IO` 动作列表，每个 {moduleTerm (module := Examples.HelloWorld)}`Nat` 对应一个：

```anchor countdown (module := Examples.HelloWorld)
def countdown : Nat → List (IO Unit)
  | 0 => [IO.println "Blast off!"]
  | n + 1 => IO.println s!"{n + 1}" :: countdown n
```

-- This function has no side effects, and does not print anything.
-- For example, it can be applied to an argument, and the length of the resulting list of actions can be checked:

这个函数没有副作用，不打印任何东西。
例如，它可以应用于一个参数，并且可以检查结果动作列表的长度：

```anchor from5  (module := Examples.HelloWorld)
def from5 : List (IO Unit) := countdown 5
```

-- This list contains six elements (one for each number, plus a {moduleTerm (module := Examples.HelloWorld)}`"Blast off!"` action for zero):

这个列表包含六个元素（每个数字一个，加上零对应的 {moduleTerm (module := Examples.HelloWorld)}`"Blast off!"` 动作）：

```anchorTerm from5length (module := Examples.HelloWorld)
#eval from5.length
```

```anchorInfo from5length (module := Examples.HelloWorld)
6
```



-- The function {moduleTerm (module := Examples.HelloWorld)}`runActions` takes a list of actions and constructs a single action that runs them all in order:

函数 {moduleTerm (module := Examples.HelloWorld)}`runActions` 接受动作列表并构造一个按顺序运行所有动作的单个动作：

```anchor runActions (module := Examples.HelloWorld)
def runActions : List (IO Unit) → IO Unit
  | [] => pure ()
  | act :: actions => do
    act
    runActions actions
```

-- Its structure is essentially the same as that of {moduleName (module := Examples.HelloWorld)}`nTimes`, except instead of having one action that is executed for each {moduleName (module := Examples.HelloWorld)}`Nat.succ`, the action under each {moduleName (module := Examples.HelloWorld)}`List.cons` is to be executed.
-- Similarly, {moduleName (module := Examples.HelloWorld)}`runActions` does not itself run the actions.
-- It creates a new action that will run them, and that action must be placed in a position where it will be executed as a part of {moduleName (module := Examples.HelloWorld)}`main`:

其结构本质上与 {moduleName (module := Examples.HelloWorld)}`nTimes` 相同，除了不是为每个 {moduleName (module := Examples.HelloWorld)}`Nat.succ` 执行一个动作，而是要执行每个 {moduleName (module := Examples.HelloWorld)}`List.cons` 下的动作。
类似地，{moduleName (module := Examples.HelloWorld)}`runActions` 本身不运行动作。
它创建一个将运行它们的新动作，该动作必须放在作为 {moduleName (module := Examples.HelloWorld)}`main` 一部分执行的位置：

```anchor main (module := Examples.HelloWorld)
def main : IO Unit := runActions from5
```

-- Running this program results in the following output:
运行这个程序会产生以下输出：

```anchorInfo countdown5 (module := Examples.HelloWorld)
5
4
3
2
1
Blast off!
```



-- What happens when this program is run?
-- The first step is to evaluate {moduleName (module := Examples.HelloWorld)}`main`. That occurs as follows:

运行这个程序时会发生什么？
第一步是求值 {moduleName (module := Examples.HelloWorld)}`main`。这按如下方式进行：

```anchorEvalSteps evalMain  (module := Examples.HelloWorld)
main
===>
runActions from5
===>
runActions (countdown 5)
===>
runActions
  [IO.println "5",
   IO.println "4",
   IO.println "3",
   IO.println "2",
   IO.println "1",
   IO.println "Blast off!"]
===>
do IO.println "5"
   IO.println "4"
   IO.println "3"
   IO.println "2"
   IO.println "1"
   IO.println "Blast off!"
   pure ()
```

-- The resulting {moduleTerm (module := Examples.HelloWorld)}`IO` action is a {moduleTerm (module := Examples.HelloWorld)}`do` block.
-- Each step of the {moduleTerm (module := Examples.HelloWorld)}`do` block is then executed, one at a time, yielding the expected output.
-- The final step, {moduleTerm (module := Examples.HelloWorld)}`pure ()`, does not have any effects, and it is only present because the definition of {moduleTerm (module := Examples.HelloWorld)}`runActions` needs a base case.

得到的 {moduleTerm (module := Examples.HelloWorld)}`IO` 动作是一个 {moduleTerm (module := Examples.HelloWorld)}`do` 块。
然后一次执行 {moduleTerm (module := Examples.HelloWorld)}`do` 块的每个步骤，产生预期的输出。
最后一步 {moduleTerm (module := Examples.HelloWorld)}`pure ()` 没有任何效果，它的存在只是因为 {moduleTerm (module := Examples.HelloWorld)}`runActions` 的定义需要一个基本情况。

-- # Exercise
# 练习
%%%
tag := "step-by-step-exercise"
%%%

-- Step through the execution of the following program on a piece of paper:

在纸上逐步执行以下程序：

```anchor ExMain (module := Examples.HelloWorld)
def main : IO Unit := do
  let englishGreeting := IO.println "Hello!"
  IO.println "Bonjour!"
  englishGreeting
```

-- While stepping through the program's execution, identify when an expression is being evaluated and when an {moduleTerm (module := Examples.HelloWorld)}`IO` action is being executed.
-- When executing an {moduleTerm (module := Examples.HelloWorld)}`IO` action results in a side effect, write it down.
-- After doing this, run the program with Lean and double-check that your predictions about the side effects were correct.

在逐步执行程序时，识别何时求值表达式以及何时执行 {moduleTerm (module := Examples.HelloWorld)}`IO` 动作。
当执行 {moduleTerm (module := Examples.HelloWorld)}`IO` 动作导致副作用时，写下来。
完成后，用 Lean 运行程序并仔细检查您对副作用的预测是否正确。
