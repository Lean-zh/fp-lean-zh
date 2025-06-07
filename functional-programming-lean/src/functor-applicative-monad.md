<!--
# Functors, Applicative Functors, and Monads
-->

# 函子、应用函子与单子 { #functors-applicative-functors-and-monads }

<!--
`Functor` and `Monad` both describe operations for types that are still waiting for a type argument.
One way to understand them is that `Functor` describes containers in which the contained data can be transformed, and `Monad` describes an encoding of programs with side effects.
This understanding is incomplete, however.
After all, `Option` has instances for both `Functor` and `Monad`, and simultaneously represents an optional value _and_ a computation that might fail to return a value.
-->

`Functor` 和 `Monad` 都描述了那些仍在等待类型参数的类型的操作。
一种理解它们的方式是，`Functor` 描述了容器，其中容器内的数据可以被转换，而 `Monad` 描述了具有副作用的程序编码。
然而，这种理解是不完整的。
毕竟，`Option` 同时拥有 `Functor` 和 `Monad` 的实例，并且同时代表着一个可选值 **和** 一个可能无法返回值的计算。

<!--
From the perspective of data structures, `Option` is a bit like a nullable type or like a list that can contain at most one entry.
From the perspective of control structures, `Option` represents a computation that might terminate early without a result.
Typically, programs that use the `Functor` instance are easiest to think of as using `Option` as a data structure, while programs that use the `Monad` instance are easiest to think of as using `Option` to allow early failure, but learning to use both of these perspectives fluently is an important part of becoming proficient at functional programming.
-->

从数据结构的角度来看，`Option` 有点像一个可为空的类型，或者像一个最多可以包含一个条目的列表。
从控制结构的角度来看，`Option` 代表着一种可能会提前终止而没有结果的计算。
通常，使用 `Functor` 实例的程序最容易被理解为将 `Option` 用作数据结构，而使用 `Monad` 实例的程序则更容易被理解为将 `Option` 用于支持早期失败，但熟练地掌握这两种视角对于精通函数式编程至关重要。

<!--
There is a deeper relationship between functors and monads.
It turns out that _every monad is a functor_.
Another way to say this is that the monad abstraction is more powerful than the functor abstraction, because not every functor is a monad.
Furthermore, there is an additional intermediate abstraction, called _applicative functors_, that has enough power to write many interesting programs and yet permits libraries that cannot use the `Monad` interface.
The type class `Applicative` provides the overloadable operations of applicative functors.
Every monad is an applicative functor, and every applicative functor is a functor, but the converses do not hold.
-->

函子 (Functor) 和 单子 (Monad) 之间有一个更深层次的关系。
事实证明，**每个单子都是一个函子**。
换句话说，单子抽象 (Monad Abstraction) 比函子抽象 (Functor Abstraction) 更强大，因为不是每个函子都是单子。
此外，还有一个额外的中间抽象，被称为 **应用函子 (Applicative Functors)**，它有足够的能力来编写许多有趣的程序，而且还适用于那些无法使用 `Monad` 接口的库。
类型类 `Applicative` 提供了应用函子的可重载操作。
每个单子都是一个应用函子，而每个应用函子也都是一个函子，但反之则不成立。