import VersoManual
import FPLeanZh.Examples
-- import FPLeanZh.FunctorApplicativeMonad.Inheritance
-- import FPLeanZh.FunctorApplicativeMonad.Applicative
-- import FPLeanZh.FunctorApplicativeMonad.ApplicativeContract
-- import FPLeanZh.FunctorApplicativeMonad.Alternative
-- import FPLeanZh.FunctorApplicativeMonad.Universes
-- import FPLeanZh.FunctorApplicativeMonad.Complete
-- import FPLeanZh.FunctorApplicativeMonad.Summary


open Verso.Genre Manual
open Verso Code External

open FPLeanZh

set_option verso.exampleProject "../examples"
set_option verso.exampleModule "Examples.FunctorApplicativeMonad"

-- Functors, Applicative Functors, and Monads
%%%
file := "FunctorApplicativeMonad"
%%%
#doc (Manual) "函子、应用函子和单子" =>
%%%
tag := "functor-applicative-monad"
%%%

-- {anchorTerm FunctorPair}`Functor` and {moduleName}`Monad` both describe operations for types that are still waiting for a type argument.
-- One way to understand them is that {anchorTerm FunctorPair}`Functor` describes containers in which the contained data can be transformed, and {moduleName}`Monad` describes an encoding of programs with side effects.
-- This understanding is incomplete, however.
-- After all, {moduleName}`Option` has instances for both {moduleName}`Functor` and {moduleName}`Monad`, and simultaneously represents an optional value _and_ a computation that might fail to return a value.

{anchorTerm FunctorPair}`Functor` 和 {moduleName}`Monad` 都描述了那些仍在等待类型参数的类型的操作。一种理解它们的方式是，{anchorTerm FunctorPair}`Functor` 描述了容器，其中容器内的数据可以被转换，而 {moduleName}`Monad` 描述了具有副作用的程序编码。然而，这种理解是不完整的。毕竟，{moduleName}`Option` 同时拥有 {anchorTerm FunctorPair}`Functor` 和 {moduleName}`Monad` 的实例，并且同时代表着一个可选值 *和* 一个可能无法返回值的计算。

-- From the perspective of data structures, {anchorName AlternativeOption}`Option` is a bit like a nullable type or like a list that can contain at most one entry.
-- From the perspective of control structures, {anchorName AlternativeOption}`Option` represents a computation that might terminate early without a result.
-- Typically, programs that use the {anchorName FunctorValidate}`Functor` instance are easiest to think of as using {anchorName AlternativeOption}`Option` as a data structure, while programs that use the {anchorName MonadExtends}`Monad` instance are easiest to think of as using {anchorName AlternativeOption}`Option` to allow early failure, but learning to use both of these perspectives fluently is an important part of becoming proficient at functional programming.

从数据结构的角度来看，{anchorName AlternativeOption}`Option` 有点像一个可为空的类型，或者像一个最多可以包含一个条目的列表。从控制结构的角度来看，{anchorName AlternativeOption}`Option` 代表着一种可能会提前终止而没有结果的计算。通常，使用 {anchorName FunctorValidate}`Functor` 实例的程序最容易被理解为将 {anchorName AlternativeOption}`Option` 用作数据结构，而使用 {anchorName MonadExtends}`Monad` 实例的程序则更容易被理解为将 {anchorName AlternativeOption}`Option` 用于支持早期失败，但熟练地掌握这两种视角对于精通函数式编程至关重要。

-- There is a deeper relationship between functors and monads.
-- It turns out that _every monad is a functor_.
-- Another way to say this is that the monad abstraction is more powerful than the functor abstraction, because not every functor is a monad.
-- Furthermore, there is an additional intermediate abstraction, called _applicative functors_, that has enough power to write many interesting programs and yet permits libraries that cannot use the {anchorName MonadExtends}`Monad` interface.
-- The type class {anchorName ApplicativeValidate}`Applicative` provides the overloadable operations of applicative functors.
-- Every monad is an applicative functor, and every applicative functor is a functor, but the converses do not hold.

函子 (Functor) 和 单子 (Monad) 之间有一个更深层次的关系。事实证明，*每个单子都是一个函子*。换句话说，单子抽象 (Monad Abstraction) 比函子抽象 (Functor Abstraction) 更强大，因为不是每个函子都是单子。此外，还有一个额外的中间抽象，被称为*应用函子* (Applicative Functors)，它有足够的能力来编写许多有趣的程序，而且还适用于那些无法使用 {anchorName MonadExtends}`Monad` 接口的库。类型类 {anchorName ApplicativeValidate}`Applicative` 提供了应用函子的可重载操作。每个单子都是一个应用函子，而每个应用函子也都是一个函子，但反之则不成立。
