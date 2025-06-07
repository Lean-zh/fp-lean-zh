<!--
# Summary
-->
# 总结 { #summary }

<!--
## Combining Monads
-->
## 组合单子 { #combining-monads }

<!--
When writing a monad from scratch, there are design patterns that tend to describe the ways that each effect is added to the monad.
Reader effects are added by having the monad's type be a function from the reader's environment, state effects are added by including a function from the initial state to the value paired with the final state, failure or exceptions are added by including a sum type in the return type, and logging or other output is added by including a product type in the return type.
Existing monads can be made part of the return type as well, allowing their effects to be included in the new monad.
-->
在从头开始编写单子时，有一些设计模式倾向于描述将每种作用添加到单子中的方式。
读取器作用是通过让单子的类型成为读取器环境中的一个函数来添加的，状态作用是通过包含一个从初始状态到与最终状态配对的值的函数来添加的，失败或异常是通过在返回类型中包含一个和类型来添加的，日志或其他输出是通过在返回类型中包含一个积类型来添加的。
现有的单子也可以成为返回类型的一部分，从而将其作用包含在新的单子中。

<!--
These design patterns are made into a library of reusable software components by defining _monad transformers_, which add an effect to some base monad.
Monad transformers take the simpler monad types as arguments, returning the enhanced monad types.
At a minimum, a monad transformer should provide the following instances:
 1. A `Monad` instance that assumes the inner type is already a monad
 2. A `MonadLift` instance to translate an action from the inner monad to the transformed monad
-->

这些设计模式通过定义单子转换器（Monad transformers），将某种作用添加到某个基本单子中，从而形成一个可重复使用的软件组件库。
单子转换器以较简单的单子类型为参数，返回增强的单子类型。
单子转换器至少应提供以下实例：
 1. 假定内部类型已经是一个单子的 `Monad` 实例
 2. 一个 `MonadLift` 实例，用于将作用从内部单子转换到转换后的单子中

<!--
Monad transformers may be implemented as polymorphic structures or inductive datatypes, but they are most often implemented as functions from the underlying monad type to the enhanced monad type.
-->
单子转换器可以多态结构或归纳数据类型的形式实现，但最常见的形式是从底层单子类型到增强单子类型的函数。

<!--
## Type Classes for Effects
-->
## 作用的类型类 { #type-classes-for-effects }

<!--
A common design pattern is to implement a particular effect by defining a monad that has the effect, a monad transformer that adds it to another monad, and a type class that provides a generic interface to the effect.
This allows programs to be written that merely specify which effects they need, so the caller can provide any monad that has the right effects.
-->
一种常见的设计模式是，通过定义一个具有特定作用的单子、一个将作用添加到另一个单子的单子转换器，以及一个为作用提供通用接口的类型类，来实现特定的作用。
这样编写的程序只需指定所需的作用，因此调用者可以提供任何具有合适作用的单子。

<!--
Sometimes, auxiliary type information (e.g. the state's type in a monad that provides state, or the exception's type in a monad that provides exceptions) is an output parameter, and sometimes it is not.
The output parameter is most useful for simple programs that use each kind of effect only once, but it risks having the type checker commit to a the wrong type too early when multiple instances of the same effect are used in a given program.
Thus, both versions are typically provided, with the ordinary-parameter version of the type class having a name that ends in `-Of`.
-->
有时，辅助类型信息（如提供状态的单子中的状态类型，或提供异常的单子中的异常类型）是输出参数，有时则不是。
输出参数对于每种作用只使用一次的简单程序最有用，但当给定程序中使用同一作用的多个实例时，类型检查器有可能过早提交错误的类型。
因此，通常会提供两种版本（的类型类），普通参数版本的类型类名称以 `-Of` 结尾。

<!--
## Monad Transformers Don't Commute
-->
## 单子转换器不可交换 { #monad-transformers-dont-commute }

<!--
It is important to note that changing the order of transformers in a monad can change the meaning of programs that use the monad.
For instance, re-ordering `StateT` and `ExceptT` can result either in programs that lose state modifications when exceptions are thrown or programs that keep changes.
While most imperative languages provide only the latter, the increased flexibility provided by monad transformers demands thought and attention to choose the correct variety for the task at hand.
-->
需要注意的是，改变单子中转换器的顺序会改变使用该单子的程序的含义。
例如，对 `StateT` 和 `ExceptT` 重新排序可能导致程序在抛出异常时丢失状态修改，也可能导致程序保持变化。
虽然大多数命令式语言只提供了后者，但单子转换器所提供的更大灵活性要求我们深思熟虑，为手头的任务选择正确的转换器。

<!--
## `do`-Notation for Monad Transformers
-->
## 单子转换器的 `do`-标记 { #do-notation-for-monad-transformers }
<!--
Lean's `do`-blocks support early return, in which the block is terminated with some value, locally mutable variables, `for`-loops with `break` and `continue`, and single-branched `if`-statements.
While this may seem to be introducing imperative features that would get in the way of using Lean to write proofs, it is in fact nothing more than a more convenient syntax for certain common uses of monad transformers.
Behind the scenes, whatever monad the `do`-block is written in is transformed by appropriate uses of `ExceptT` and `StateT` to support these additional effects.
-->
Lean 的 `do` 代码块支持提前返回（代码块以某个值结束）、局部可变变量、带有 `break` 和 `continue` 的 `for` 循环，以及单分支的 `if` 语句。
虽然这看似引入了命令式特性，会妨碍使用 Lean 编写证明，但实际上它只不过是为单子转换器的某些常见用法提供了一种更方便的语法。
在幕后，`do` 代码块所使用的单子会通过适当使用 `ExceptT` 和 `StateT` 进行转换，以支持这些附加作用。