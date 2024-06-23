<!--
# Summary
-->

# 总结

<!--
## Encoding Side Effects
-->

## 编码副作用

<!--
Lean is a pure functional language.
This means that it does not include side effects such as mutable variables, logging, or exceptions.
However, most side effects can be _encoded_ using a combination of functions and inductive types or structures.
For example, mutable state can be encoded as a function from an initial state to a pair of a final state and a result, and exceptions can be encoded as an inductive type with constructors for successful termination and errors.
-->

是一种纯函数式语言。这意味着它不包含副作用，例如可变变量、日志记录或异常。
但是，大多数副作用都可以使用函数和归纳类型或结构体的组合进行**编码**。
例如，可变状态可以编码为从初始状态到一对最终状态和结果的函数，
异常可以编码为具有成功终止构造子和错误构造子的归纳类型。

<!--
Each set of encoded effects is a type.
As a result, if a program uses these encoded effects, then this is apparent in its type.
Functional programming does not mean that programs can't use effects, it simply requires that they be *honest* about which effects they use.
A Lean type signature describes not only the types of arguments that a function expects and the type of result that it returns, but also which effects it may use.
-->

每组编码的作用都是一种类型。因此，如果程序使用这些编码作用，那么这在它的类型中是显而易见的。
函数式编程并不意味着程序不能使用作用，它只是要求它们 **诚实地** 说明它们使用的作用。
Lean 类型签名不仅描述了函数期望的参数类型和它返回的结果类型，还描述了它可能使用的作用。

<!--
## The Monad Type Class
-->

## 单子类型类

<!--
It's possible to write purely functional programs in languages that allow effects anywhere.
For example, `2 + 3` is a valid Python program that has no effects at all.
Similarly, combining programs that have effects requires a way to state the order in which the effects must occur.
It matters whether an exception is thrown before or after modifying a variable, after all.
-->

在允许在任何地方使用作用的语言中编写纯函数式程序是可能的。
例如，`2 + 3` 是一个有效的 Python 程序，它没有任何作用。
类似地，组合具有作用的程序需要一种方法来说明作用必须发生的顺序。
毕竟，异常是在修改变量之前还是之后抛出是有区别的。

<!--
The type class `Monad` captures these two important properties.
It has two methods: `pure` represents programs that have no effects, and `bind` sequences effectful programs.
The contract for `Monad` instances ensures that `bind` and `pure` actually capture pure computation and sequencing.
-->

类型类 `Monad` 刻画了这两个重要属性。它有两个方法：`pure` 表示没有副作用的程序，
`bind` 顺序执行有副作用的程序。`Monad` 实例的约束确保了 `bind` 和 `pure` 实际上刻画了纯计算和顺序执行。

<!--
## `do`-Notation for Monads
-->

## 单子的 `do`-记法

<!--
Rather than being limited to `IO`, `do`-notation works for any monad.
It allows programs that use monads to be written in a style that is reminiscent of statement-oriented languages, with statements sequenced after one another.
Additionally, `do`-notation enables a number of additional convenient shorthands, such as nested actions.
A program written with `do` is translated to applications of `>>=` behind the scenes.
-->

`do` 符号不仅限于 `IO`，它也适用于任何单子。
它允许使用单子的程序以类似于面向语句的语言的风格编写，语句一个接一个地顺序执行。
此外，`do`-记法还支持许多其他方便的简写，例如嵌套动作。
使用 `do` 编写的程序在幕后会被翻译为 `>>=` 的应用。

<!--
## Custom Monads
-->

## 定制单子

<!--
Different languages provide different sets of side effects.
While most languages feature mutable variables and file I/O, not all have features like exceptions.
Other languages offer effects that are rare or unique, like Icon's search-based program execution, Scheme and Ruby's continuations, and Common Lisp's resumable exceptions.
An advantage to encoding effects with monads is that programs are not limited to the set of effects that are provided by the language.
Because Lean is designed to make programming with any monad convenient, programmers are free to choose exactly the set of side effects that make sense for any given application.
-->

不同的语言提供不同的副作用集。虽然大多数语言都具有可变变量和文件 I/O，
但并非所有语言都具有异常等特性。其他语言提供罕见或独特的副作用，
例如 Icon 基于搜索的程序执行、Scheme 和 Ruby 的续体以及 Common Lisp 的可恢复异常。
用单子对副作用进行编码的一个优点是，程序不受语言提供的副作用集的限制。
由于 Lean 被设计为能方便地使用任何单子进行编程，
因此程序员可以自由选择最适合任何给定应用的副作用集。

<!--
## The `IO` Monad
-->

## `IO` 单子

<!--
Programs that can affect the real world are written as `IO` actions in Lean.
`IO` is one monad among many.
The `IO` monad encodes state and exceptions, with the state being used to keep track of the state of the world and the exceptions modeling failure and recovery.
-->

可以在现实世界中产生影响的程序在 Lean 中被写作 `IO` 活动。
`IO` 是众多单子中的一个。`IO` 单子对状态和异常进行编码，其中状态用于跟踪世界的状态，
异常则对失败和恢复进行建模。
