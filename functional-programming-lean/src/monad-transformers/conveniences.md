<!--
# Additional Conveniences
-->
# 其他便利功能 { #additional-conveniences }

<!--
## Pipe Operators
-->
## 管道操作符 { #pipe-operators }

<!--
Functions are normally written before their arguments.
When reading a program from left to right, this promotes a view in which the function's _output_ is paramount—the function has a goal to achieve (that is, a value to compute), and it receives arguments to support it in this process.
But some programs are easier to understand in terms of an input that is successively refined to produce the output.
For these situations, Lean provides a _pipeline_ operator which is similar to the that provided by F#.
Pipeline operators are useful in the same situations as Clojure's threading macros.
-->

函数通常写在参数之前。
当从左往右阅读程序时，这种做法会让人觉得函数的 _输出_ 是最重要的 —— 函数有一个要实现的目标（也就是要计算的值），在这个过程中，函数会得到参数的支持。
但有些程序更容易理解，通过想象不断完善输入来产生输出。
针对这些情况，Lean 提供了与 F# 类似的 _管道_ 操作符。
管道操作符在与 Clojure 的线程宏相同的情况下非常有用。

<!--
The pipeline `{{#example_in Examples/MonadTransformers/Conveniences.lean pipelineShort}}` is short for `{{#example_out Examples/MonadTransformers/Conveniences.lean pipelineShort}}`.
For example, evaluating:
-->
管道 `{{#example_in Examples/MonadTransformers/Conveniences.lean pipelineShort}}` 是 `{{#example_out Examples/MonadTransformers/Conveniences.lean pipelineShort}}` 的缩写。
举个例子，求值：
```lean
{{#example_in Examples/MonadTransformers/Conveniences.lean some5}}
```
<!--
results in:
-->
可得：
```output info
{{#example_out Examples/MonadTransformers/Conveniences.lean some5}}
```
<!--
While this change of emphasis can make some programs more convenient to read, pipelines really come into their own when they contain many components.
-->
虽然这种侧重点的变化可以使某些程序的阅读更加方便，但当管道包含许多组件时，才是它真正派上用场的时刻。

<!--
With the definition:
-->
有如下定义
```lean
{{#example_decl Examples/MonadTransformers/Conveniences.lean times3}}
```
<!--
the following pipeline:
-->
下面的管道：
```lean
{{#example_in Examples/MonadTransformers/Conveniences.lean itIsFive}}
```
<!--
yields:
-->
会产生：
```output info
{{#example_out Examples/MonadTransformers/Conveniences.lean itIsFive}}
```
<!--
More generally, a series of pipelines `{{#example_in Examples/MonadTransformers/Conveniences.lean pipeline}}` is short for nested function applications `{{#example_out Examples/MonadTransformers/Conveniences.lean pipeline}}`.
-->

更一般地说，一系列管道 `{{#example_in Examples/MonadTransformers/Conveniences.lean pipeline}}` 是嵌套函数应用 `{{#example_out Examples/MonadTransformers/Conveniences.lean pipeline}}` 的简称。

<!--
Pipelines may also be written in reverse.
In this case, they do not place the subject of data transformation first; however, in cases where many nested parentheses pose a challenge for readers, they can clarify the steps of application.
The prior example could be equivalently written as:
-->

管道也可以反过来写。
在这种情况下，它们并不优先考虑数据转换这个主旨；而是在许多嵌套括号给读者带来困难的情况下，给出明确应用的步骤。
前面的例子可以这样写成等价形式：
```lean
{{#example_in Examples/MonadTransformers/Conveniences.lean itIsAlsoFive}}
```
<!--
which is short for:
-->
是下面代码的缩写：
```lean
{{#example_in Examples/MonadTransformers/Conveniences.lean itIsAlsoFiveParens}}
```

<!--
Lean's method dot notation that uses the name of the type before the dot to resolve the namespace of the operator after the dot serves a similar purpose to pipelines.
Even without the pipeline operator, it is possible to write `{{#example_in Examples/MonadTransformers/Conveniences.lean listReverse}}` instead of `{{#example_out Examples/MonadTransformers/Conveniences.lean listReverse}}`.
However, the pipeline operator is also useful for dotted functions when using many of them.
`{{#example_in Examples/MonadTransformers/Conveniences.lean listReverseDropReverse}}` can also be written as `{{#example_out Examples/MonadTransformers/Conveniences.lean listReverseDropReverse}}`.
This version avoids having to parenthesize expressions simply because they accept arguments, and it recovers the convenience of a chain of method calls in languages like Kotlin or C#.
However, it still requires the namespace to be provided by hand.
As a final convenience, Lean provides the "pipeline dot" operator, which groups functions like the pipeline but uses the name of the type to resolve namespaces.
With "pipeline dot", the example can be rewritten to `{{#example_out Examples/MonadTransformers/Conveniences.lean listReverseDropReversePipe}}`.
-->

Lean 的方法点符号（Dot notation）使用点前的类型名称来解析点后操作符的命名空间，其作用与管道类似。
即使没有管道操作符，我们也可以写出 `{{#example_in Examples/MonadTransformers/Conveniences.lean listReverse}}` 而不是 `{{#example_out Examples/MonadTransformers/Conveniences.lean listReverse}}` 。
不过，管道运算符也适用于使用多个带点函数的情况。
`{{#example_in Examples/MonadTransformers/Conveniences.lean listReverseDropReverse}}` 也可以写成 `{{#example_out Examples/MonadTransformers/Conveniences.lean listReverseDropReverse}}` 。
该版本避免了表达式因接受参数而必须使用括号的麻烦，和 Kotlin 或 C# 等语言中方法调用链一样简便。
不过，它仍然需要手动提供命名空间。
作为最后一种便利功能，Lean 提供了“管道点”（Pipeline dot）操作符，它像管道一样对函数进行分组，但使用类型名称来解析命名空间。
使用“管道点”，可以将示例改写为 `{{#example_out Examples/MonadTransformers/Conveniences.lean listReverseDropReversePipe}}` 。

<!--
## Infinite Loops
-->
## 无限循环 { #infinite-loops }

<!--
Within a `do`-block, the `repeat` keyword introduces an infinite loop.
For example, a program that spams the string `"Spam!"` can use it:
-->
在一个 `do` 块中，`repeat` 关键字会引入一个无限循环。
例如，一个发送垃圾邮件字符串“Spam!”的程序可用它完成：
```lean
{{#example_decl Examples/MonadTransformers/Conveniences.lean spam}}
```
<!--
A `repeat` loop supports `break` and `continue`, just like `for` loops.
-->
`repeat` 循环还支持和 `break` 和 `continue`，和 `for` 循环一样。

<!--
The `dump` function from the [implementation of `feline`](../hello-world/cat.md#streams) uses a recursive function to run forever:
-->

[`feline`实现](../hello-world/cat.md#streams) 中的函数 `dump` 使用递归函数来永远运行：
```lean
{{#include ../../../examples/feline/2/Main.lean:dump}}
```
<!--
This function can be greatly shortened using `repeat`:
-->
利用 `repeat` 可将这个函数大大缩短：
```lean
{{#example_decl Examples/MonadTransformers/Conveniences.lean dump}}
```

<!--
Neither `spam` nor `dump` need to be declared as `partial` because they are not themselves infinitely recursive.
Instead, `repeat` makes use of a type whose `ForM` instance is `partial`.
Partiality does not "infect" calling functions.
-->
无论是 `spam` 还是 `dump` 都不需要声明为 `partial` 类型，因为它们本身并不是无限递归的。
相反，`repeat` 使用了一个类型，该类型的 `ForM` 实例是 `partial`。
部分性不会“感染”函数调用者。

<!--
## While Loops
-->
## While 循环 { #while-loops }

<!--
When programming with local mutability, `while` loops can be a convenient alternative to `repeat` with an `if`-guarded `break`:
-->
在使用局部可变性编程时，`while` 循环可以方便地替代带有 `if` 修饰的 `break` 的 `repeat` 循环：
```lean
{{#example_decl Examples/MonadTransformers/Conveniences.lean dumpWhile}}
```
<!--
Behind the scenes, `while` is just a simpler notation for `repeat`.
-->
在后端， `while` 只是 `repeat` 的一个更简单的标记。