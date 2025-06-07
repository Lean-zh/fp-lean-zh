<!--
# The IO Monad
-->

# IO 单子 { #the-io-monad }

<!--
`IO` as a monad can be understood from two perspectives, which were described in the section on [running programs](../hello-world/running-a-program.md).
Each can help to understand the meanings of `pure` and `bind` for `IO`.
-->

`IO` 作为单子可以从两个角度理解，这在 [运行程序](../hello-world/running-a-program.md)
一节中进行了描述。每个角度都可以帮助理解 `IO` 的 `pure` 和 `bind` 的含义。

<!--
From the first perspective, an `IO` action is an instruction to Lean's run-time system.
For example, the instruction might be "read a string from this file descriptor, then re-invoke the pure Lean code with the string".
This perspective is an _exterior_ one, viewing the program from the perspective of the operating system.
In this case, `pure` is an `IO` action that does not request any effects from the RTS, and `bind` instructs the RTS to first carry out one potentially-effectful operation and then invoke the rest of the program with the resulting value.
-->

从第一个视角看，`IO` 活动是 Lean 运行时系统的指令。
例如，指令可能是「从该文件描述符读取字符串，然后使用该字符串重新调用纯 Lean 代码」。
这是一种 **外部** 的视角，即从操作系统的视角看待程序。
在这种情况下，`pure` 是一个不请求 RTS 产生任何作用的 `IO` 活动，
而 `bind` 指示 RTS 首先执行一个产生潜在作用的操作，然后使用结果值调用程序的其余部分。

<!--
From the second perspective, an `IO` action transforms the whole world.
`IO` actions are actually pure, because they receive a unique world as an argument and then return the changed world.
This perspective is an _interior_ one that matches how `IO` is represented inside of Lean.
The world is represented in Lean as a token, and the `IO` monad is structured to make sure that each token is used exactly once.
-->

从第二个视角看，`IO` 活动会变换整个世界。`IO` 活动实际上是纯（Pure）的，
因为它接受一个唯一的世界作为参数，然后返回改变后的世界。
这是一种 **内部** 的视角，它对应了 `IO` 在 Lean 中的表示方式。
世界在 Lean 中表示为一个标记，而 `IO` 单子的结构化可以确保标记刚好使用一次。

<!--
To see how this works, it can be helpful to peel back one definition at a time.
The `#print` command reveals the internals of Lean datatypes and definitions.
For example,
-->

为了了解其工作原理，逐层解析它的定义会很有帮助。
`#print` 命令揭示了 Lean 数据类型和定义的内部结构。例如，

```lean
{{#example_in Examples/Monads/IO.lean printNat}}
```

<!--
results in
-->

的结果为

```output info
{{#example_out Examples/Monads/IO.lean printNat}}
```

<!--
and
-->

而

```lean
{{#example_in Examples/Monads/IO.lean printCharIsAlpha}}
```

<!--
results in
-->

的结果为

```output info
{{#example_out Examples/Monads/IO.lean printCharIsAlpha}}
```

<!--
Sometimes, the output of `#print` includes Lean features that have not yet been presented in this book.
For example,
-->

有时，`#print` 的输出包含了本书中尚未展示的 Lean 特性。例如，

```lean
{{#example_in Examples/Monads/IO.lean printListIsEmpty}}
```

<!--
produces
-->

会产生

```output info
{{#example_out Examples/Monads/IO.lean printListIsEmpty}}
```

<!--
which includes a `.{u}` after the definition's name, and annotates types as `Type u` rather than just `Type`.
This can be safely ignored for now.
-->

它在定义名的后面包含了一个 `.{u}` ，并将类型标注为 `Type u` 而非只是 `Type`。
目前可以安全地忽略它。

<!--
Printing the definition of `IO` shows that it's defined in terms of simpler structures:
-->

打印 `IO` 的定义表明它是根据更简单的结构定义的：

```lean
{{#example_in Examples/Monads/IO.lean printIO}}
```

```output info
{{#example_out Examples/Monads/IO.lean printIO}}
```

<!--
`IO.Error` represents all the errors that could be thrown by an `IO` action:
-->

`IO.Error` 表示 `IO` 活动可能抛出的所有错误：

```lean
{{#example_in Examples/Monads/IO.lean printIOError}}
```

```output info
{{#example_out Examples/Monads/IO.lean printIOError}}
```

<!--
`EIO ε α` represents `IO` actions that will either terminate with an error of type `ε` or succeed with a value of type `α`.
This means that, like the `Except ε` monad, the `IO` monad includes the ability to define error handling and exceptions.
-->

`EIO ε α` 表示一个 `IO` 活动，它将以类型为 `ε` 的错误表示终止，或者以类型为 `α` 的值表示成功。
这意味着，与 `Except ε` 单子一样，`IO` 单子也包括定义错误处理和异常的能力。

<!--
Peeling back another layer, `EIO` is itself defined in terms of a simpler structure:
-->

<!--
Peeling back another layer, `EIO` is itself defined in terms of a simpler structure:
-->

剥离另一层，`EIO` 本身又是根据更简单的结构定义的：

```lean
{{#example_in Examples/Monads/IO.lean printEIO}}
```

```output info
{{#example_out Examples/Monads/IO.lean printEIO}}
```

<!--
The `EStateM` monad includes both errors and state—it's a combination of `Except` and `State`.
It is defined using another type, `EStateM.Result`:
-->

`EStateM` 单子同时包括错误和状态——它是 `Except` 和 `State` 的组合。
它使用另一个类型 `EStateM.Result` 定义：

```lean
{{#example_in Examples/Monads/IO.lean printEStateM}}
```

```output info
{{#example_out Examples/Monads/IO.lean printEStateM}}
```

<!--
In other words, a program with type `EStateM ε σ α` is a function that accepts an initial state of type `σ` and returns an `EStateM.Result ε σ α`.
-->

换句话说，类型为 `EStateM ε σ α` 的程序是一个函数，
它接受类型为 `σ` 的初始状态并返回一个 `EStateM.Result ε σ α`。

<!--
`EStateM.Result` is very much like the definition of `Except`, with one constructor that indicates a successful termination and one constructor that indicates an error:
-->

`EStateM.Result` 与 `Except` 的定义非常相似，一个构造子表示成功终止，
令一个构造子表示错误：

```lean
{{#example_in Examples/Monads/IO.lean printEStateMResult}}
```

```output info
{{#example_out Examples/Monads/IO.lean printEStateMResult}}
```

<!--
Just like `Except ε α`, the `ok` constructor includes a result of type `α`, and the `error` constructor includes an exception of type `ε`.
Unlike `Except`, both constructors have an additional state field that includes the final state of the computation.
-->

就像 `Except ε α` 一样，`ok` 构造子包含类型为 `α` 的结果，
`error` 构造子包含类型为 `ε` 的异常。与 `Except` 不同，
这两个构造子都有一个附加的状态字段，其中包含计算的最终状态。

<!--
The `Monad` instance for `EStateM ε σ` requires `pure` and `bind`.
Just as with `State`, the implementation of `pure` for `EStateM` accepts an initial state and returns it unchanged, and just as with `Except`, it returns its argument in the `ok` constructor:
-->

`EStateM ε σ` 的 `Monad` 实例需要 `pure` 和 `bind`。
与 `State` 一样，`EStateM` 的 `pure` 实现接受一个初始状态并将其返回而不改变，
并且与 `Except` 一样，它在 `ok` 构造子中返回其参数：

```lean
{{#example_in Examples/Monads/IO.lean printEStateMpure}}
```

```output info
{{#example_out Examples/Monads/IO.lean printEStateMpure}}
```

<!--
`protected` means that the full name `EStateM.pure` is needed even if the `EStateM` namespace has been opened.
-->

`protected` 意味着即使打开了 `EStateM` 命名空间，也需要完整的名称 `EStateM.pure`。

<!--
Similarly, `bind` for `EStateM` takes an initial state as an argument.
It passes this initial state to its first action.
Like `bind` for `Except`, it then checks whether the result is an error.
If so, the error is returned unchanged and the second argument to `bind` remains unused.
If the result was a success, then the second argument is applied to both the returned value and to the resulting state.
-->

类似地，`EStateM` 的 `bind` 将初始状态作为参数。它将此初始状态传递给其第一个操作。
与 `Except` 的 `bind` 一样，它然后检查结果是否为错误。如果是，则错误将保持不变，
并且 `bind` 的第二个参数保持未使用。如果结果成功，则将第二个参数应用于返回值和结果状态。

```lean
{{#example_in Examples/Monads/IO.lean printEStateMbind}}
```

```output info
{{#example_out Examples/Monads/IO.lean printEStateMbind}}
```

<!--
Putting all of this together, `IO` is a monad that tracks state and errors at the same time.
The collection of available errors is that given by the datatype `IO.Error`, which has constructors that describe many things that can go wrong in a program.
The state is a type that represents the real world, called `IO.RealWorld`.
Each basic `IO` action receives this real world and returns another one, paired either with an error or a result.
In `IO`, `pure` returns the world unchanged, while `bind` passes the modified world from one action into the next action.
-->

综上所述，`IO` 是同时跟踪状态和错误的单子。可用错误的集合由数据类型 `IO.Error` 给出，
该数据类型具有描述程序中可能出错的许多情况的构造子。状态是一种表示现实世界的类型，
称为 `IO.RealWorld`。每个基本的 `IO` 活动都会接收这个现实世界并返回另一个，与错误或结果配对。
在 `IO` 中，`pure` 返回未更改的世界，而 `bind` 将修改后的世界从一个活动传递到下一个活动。

<!--
Because the entire universe doesn't fit in a computer's memory, the world being passed around is just a representation.
So long as world tokens are not re-used, the representation is safe.
This means that world tokens do not need to contain any data at all:
-->

<!--
Because the entire universe doesn't fit in a computer's memory, the world being passed around is just a representation.
So long as world tokens are not re-used, the representation is safe.
This means that world tokens do not need to contain any data at all:
-->

由于计算机内存无法容纳整个宇宙，因此传递的世界仅仅是一种表示。
只要不重复使用世界标记，该表示就是安全的。这意味着世界标记根本不需要包含任何数据：

```lean
{{#example_in Examples/Monads/IO.lean printRealWorld}}
```

```output info
{{#example_out Examples/Monads/IO.lean printRealWorld}}
```