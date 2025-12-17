import VersoManual
import FPLeanZh.Examples

open Verso.Genre Manual
open Verso.Code.External

open FPLeanZh

set_option verso.exampleProject "../examples"
set_option verso.exampleModule "Examples.MonadTransformers.Conveniences"

#doc (Manual) "其他便利功能" =>
%%%
file := "Conveniences"
tag := "monad-transformer-conveniences"
%%%
-- Additional Conveniences

-- # Pipe Operators
# 管道操作符
%%%
tag := "pipe-operators"
%%%

-- Functions are normally written before their arguments.
-- When reading a program from left to right, this promotes a view in which the function's _output_ is paramount—the function has a goal to achieve (that is, a value to compute), and it receives arguments to support it in this process.
-- But some programs are easier to understand in terms of an input that is successively refined to produce the output.
-- For these situations, Lean provides a _pipeline_ operator which is similar to the that provided by F#.
-- Pipeline operators are useful in the same situations as Clojure's threading macros.

函数通常写在参数之前。
当从左往右阅读程序时，这种做法会让人觉得函数的 _输出_ 是最重要的 —— 函数有一个要实现的目标（也就是要计算的值），在这个过程中，函数会得到参数的支持。
但有些程序更容易理解，通过想象不断完善输入来产生输出。
针对这些情况，Lean 提供了与 F# 类似的 _管道_ 操作符。
管道操作符在与 Clojure 的线程宏相同的情况下非常有用。

-- The pipeline {anchorTerm pipelineShort}`E₁ |> E₂` is short for {anchorTerm pipelineShort}`E₂ E₁`.
-- For example, evaluating:

管道 {anchorTerm pipelineShort}`E₁ |> E₂` 是 {anchorTerm pipelineShort}`E₂ E₁` 的缩写。
举个例子，求值：

```anchor some5
#eval some 5 |> toString
```
-- results in:

可得：

```anchorInfo some5
"(some 5)"
```
-- While this change of emphasis can make some programs more convenient to read, pipelines really come into their own when they contain many components.

虽然这种侧重点的变化可以使某些程序的阅读更加方便，但当管道包含许多组件时，才是它真正派上用场的时刻。

-- With the definition:

有如下定义：

```anchor times3
def times3 (n : Nat) : Nat := n * 3
```
-- the following pipeline:

下面的管道：

```anchor itIsFive
#eval 5 |> times3 |> toString |> ("It is " ++ ·)
```
-- yields:

会产生：

```anchorInfo itIsFive
"It is 15"
```
-- More generally, a series of pipelines {anchorTerm pipeline}`E₁ |> E₂ |> E₃ |> E₄` is short for nested function applications {anchorTerm pipeline}`E₄ (E₃ (E₂ E₁))`.

更一般地说，一系列管道 {anchorTerm pipeline}`E₁ |> E₂ |> E₃ |> E₄` 是嵌套函数应用 {anchorTerm pipeline}`E₄ (E₃ (E₂ E₁))` 的简称。

-- Pipelines may also be written in reverse.
-- In this case, they do not place the subject of data transformation first; however, in cases where many nested parentheses pose a challenge for readers, they can clarify the steps of application.
-- The prior example could be equivalently written as:

管道也可以反过来写。
在这种情况下，它们并不优先考虑数据转换这个主旨；而是在许多嵌套括号给读者带来困难的情况下，给出明确应用的步骤。
前面的例子可以这样写成等价形式：

```anchor itIsAlsoFive
#eval ("It is " ++ ·) <| toString <| times3 <| 5
```
-- which is short for:

是下面代码的缩写：

```anchor itIsAlsoFiveParens
#eval ("It is " ++ ·) (toString (times3 5))
```

-- Lean's method dot notation that uses the name of the type before the dot to resolve the namespace of the operator after the dot serves a similar purpose to pipelines.
-- Even without the pipeline operator, it is possible to write {anchorTerm listReverse}`[1, 2, 3].reverse` instead of {anchorTerm listReverse}`List.reverse [1, 2, 3]`.
-- However, the pipeline operator is also useful for dotted functions when using many of them.
-- {anchorTerm listReverseDropReverse}`([1, 2, 3].reverse.drop 1).reverse` can also be written as {anchorTerm listReverseDropReverse}`[1, 2, 3] |> List.reverse |> List.drop 1 |> List.reverse`.
-- This version avoids having to parenthesize expressions simply because they accept arguments, and it recovers the convenience of a chain of method calls in languages like Kotlin or C#.
-- However, it still requires the namespace to be provided by hand.
-- As a final convenience, Lean provides the “pipeline dot” operator, which groups functions like the pipeline but uses the name of the type to resolve namespaces.
-- With “pipeline dot”, the example can be rewritten to {anchorTerm listReverseDropReversePipe}`[1, 2, 3] |>.reverse |>.drop 1 |>.reverse`.

Lean 的方法点符号（Dot notation）使用点前的类型名称来解析点后操作符的命名空间，其作用与管道类似。
即使没有管道操作符，我们也可以写出 {anchorTerm listReverse}`[1, 2, 3].reverse` 而不是 {anchorTerm listReverse}`List.reverse [1, 2, 3]` 。
不过，管道运算符也适用于使用多个带点函数的情况。
{anchorTerm listReverseDropReverse}`([1, 2, 3].reverse.drop 1).reverse` 也可以写成 {anchorTerm listReverseDropReverse}`[1, 2, 3] |> List.reverse |> List.drop 1 |> List.reverse` 。
该版本避免了表达式因接受参数而必须使用括号的麻烦，和 Kotlin 或 C# 等语言中方法调用链一样简便。
不过，它仍然需要手动提供命名空间。
作为最后一种便利功能，Lean 提供了“管道点”（Pipeline dot）操作符，它像管道一样对函数进行分组，但使用类型名称来解析命名空间。
使用“管道点”，可以将示例改写为 {anchorTerm listReverseDropReversePipe}`[1, 2, 3] |>.reverse |>.drop 1 |>.reverse` 。

-- # Infinite Loops
# 无限循环
%%%
tag := "infinite-loops"
%%%

-- Within a {kw}`do`-block, the {kw}`repeat` keyword introduces an infinite loop.
-- For example, a program that spams the string {anchorTerm spam}`"Spam!"` can use it:

在一个 {kw}`do` 块中，{kw}`repeat` 关键字会引入一个无限循环。
例如，一个发送垃圾邮件字符串 {anchorTerm spam}`"Spam!"` 的程序可用它完成：

```anchor spam
def spam : IO Unit := do
  repeat IO.println "Spam!"
```
-- A {kw}`repeat` loop supports {kw}`break` and {kw}`continue`, just like {kw}`for` loops.

{kw}`repeat` 循环还支持和 {kw}`break` 和 {kw}`continue`，和 {kw}`for` 循环一样。

-- The {anchorName dump (module := FelineLib)}`dump` function from the {ref "streams"}[implementation of {lit}`feline`] uses a recursive function to run forever:

{ref "streams"}[`feline`实现] 中的函数 {anchorName dump (module := FelineLib)}`dump` 使用递归函数来永远运行：

```anchor dump (module := FelineLib)
partial def dump (stream : IO.FS.Stream) : IO Unit := do
  let buf ← stream.read bufsize
  if buf.isEmpty then
    pure ()
  else
    let stdout ← IO.getStdout
    stdout.write buf
    dump stream
```
-- This function can be greatly shortened using {kw}`repeat`:

利用 {kw}`repeat` 可将这个函数大大缩短：

```anchor dump
def dump (stream : IO.FS.Stream) : IO Unit := do
  let stdout ← IO.getStdout
  repeat do
    let buf ← stream.read bufsize
    if buf.isEmpty then break
    stdout.write buf
```

-- Neither {anchorName spam}`spam` nor {anchorName dump}`dump` need to be declared as {kw}`partial` because they are not themselves infinitely recursive.
-- Instead, {kw}`repeat` makes use of a type whose {anchorTerm names}`ForM` instance is {kw}`partial`.
-- Partiality does not “infect” calling functions.

无论是 {anchorName spam}`spam` 还是 {anchorName dump}`dump` 都不需要声明为 {kw}`partial` 类型，因为它们本身并不是无限递归的。
相反，{kw}`repeat` 使用了一个类型，该类型的 {anchorTerm names}`ForM` 实例是 {kw}`partial`。
部分性不会“感染”函数调用者。

-- # While Loops
# While 循环
%%%
tag := "while-loops"
%%%

-- When programming with local mutability, {kw}`while` loops can be a convenient alternative to {kw}`repeat` with an {kw}`if`-guarded {kw}`break`:

在使用局部可变性编程时，{kw}`while` 循环可以方便地替代带有 {kw}`if` 修饰的 {kw}`break` 的 {kw}`repeat` 循环：

```anchor dumpWhile
def dump (stream : IO.FS.Stream) : IO Unit := do
  let stdout ← IO.getStdout
  let mut buf ← stream.read bufsize
  while not buf.isEmpty do
    stdout.write buf
    buf ← stream.read bufsize
```
-- Behind the scenes, {kw}`while` is just a simpler notation for {kw}`repeat`.

在后端， {kw}`while` 只是 {kw}`repeat` 的一个更简单的标记。
