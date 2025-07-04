import VersoManual
import FPLeanZh.Examples

open Verso.Genre Manual
open Verso.Code.External

open FPLeanZh

set_option verso.exampleProject "../examples"
set_option verso.exampleModule "Examples.MonadTransformers"

#doc (Manual) "总结" =>

/-- # Combining Monads

When writing a monad from scratch, there are design patterns that tend to describe the ways that each effect is added to the monad.
Reader effects are added by having the monad's type be a function from the reader's environment, state effects are added by including a function from the initial state to the value paired with the final state, failure or exceptions are added by including a sum type in the return type, and logging or other output is added by including a product type in the return type.
Existing monads can be made part of the return type as well, allowing their effects to be included in the new monad.

These design patterns are made into a library of reusable software components by defining _monad transformers_, which add an effect to some base monad.
Monad transformers take the simpler monad types as arguments, returning the enhanced monad types.
At a minimum, a monad transformer should provide the following instances:
 1. A {anchorName Summary}`Monad` instance that assumes the inner type is already a monad
 2. A {anchorName Summary}`MonadLift` instance to translate an action from the inner monad to the transformed monad

Monad transformers may be implemented as polymorphic structures or inductive datatypes, but they are most often implemented as functions from the underlying monad type to the enhanced monad type.
-/

# 组合单子

当从头开始编写单子时，有一些设计模式倾向于描述每个效果被添加到单子中的方式。
读者效果（Reader effects）通过使单子的类型成为从读者环境的函数来添加，状态效果通过包含从初始状态到与最终状态配对的值的函数来添加，失败或异常通过在返回类型中包含和类型来添加，日志记录或其他输出通过在返回类型中包含积类型来添加。
现有的单子也可以成为返回类型的一部分，从而允许它们的效果被包含在新的单子中。

这些设计模式通过定义 _单子变换器（monad transformers）_ 被制作成可重用软件组件的库，单子变换器向某个基础单子添加效果。
单子变换器以较简单的单子类型作为参数，返回增强的单子类型。
至少，单子变换器应该提供以下实例：
 1. 一个 {anchorName Summary}`Monad` 实例，假设内部类型已经是单子
 2. 一个 {anchorName Summary}`MonadLift` 实例，将动作从内部单子转换为变换后的单子

单子变换器可以作为多态结构或归纳数据类型实现，但最常见的是作为从底层单子类型到增强单子类型的函数来实现。

/-- # Type Classes for Effects

A common design pattern is to implement a particular effect by defining a monad that has the effect, a monad transformer that adds it to another monad, and a type class that provides a generic interface to the effect.
This allows programs to be written that merely specify which effects they need, so the caller can provide any monad that has the right effects.

Sometimes, auxiliary type information (e.g. the state's type in a monad that provides state, or the exception's type in a monad that provides exceptions) is an output parameter, and sometimes it is not.
The output parameter is most useful for simple programs that use each kind of effect only once, but it risks having the type checker commit to a the wrong type too early when multiple instances of the same effect are used in a given program.
Thus, both versions are typically provided, with the ordinary-parameter version of the type class having a name that ends in {lit}`-Of`.
-/

# 效果的类型类

一个常见的设计模式是通过定义一个具有该效果的单子、一个将其添加到另一个单子的单子变换器，以及一个为该效果提供通用接口的类型类来实现特定的效果。
这允许编写程序时只需指定它们需要哪些效果，因此调用者可以提供任何具有正确效果的单子。

有时，辅助类型信息（例如提供状态的单子中的状态类型，或提供异常的单子中的异常类型）是输出参数，有时不是。
输出参数对于每种效果只使用一次的简单程序最有用，但当在给定程序中使用同一效果的多个实例时，存在类型检查器过早确定错误类型的风险。
因此，通常提供两个版本，类型类的普通参数版本的名称以 {lit}`-Of` 结尾。

/-- # Monad Transformers Don't Commute

It is important to note that changing the order of transformers in a monad can change the meaning of programs that use the monad.
For instance, re-ordering {anchorName Summary}`StateT` and {anchorTerm Summary}`ExceptT` can result either in programs that lose state modifications when exceptions are thrown or programs that keep changes.
While most imperative languages provide only the latter, the increased flexibility provided by monad transformers demands thought and attention to choose the correct variety for the task at hand.
-/

# 单子变换器不可交换

重要的是要注意，改变单子中变换器的顺序可以改变使用该单子的程序的含义。
例如，重新排列 {anchorName Summary}`StateT` 和 {anchorTerm Summary}`ExceptT` 可能导致程序在抛出异常时丢失状态修改，或者程序保持变更。
虽然大多数命令式语言只提供后者，但单子变换器提供的增强灵活性要求深思熟虑和仔细选择适合手头任务的正确变种。

/-- # {kw}`do`-Notation for Monad Transformers

Lean's {kw}`do`-blocks support early return, in which the block is terminated with some value, locally mutable variables, {kw}`for`-loops with {kw}`break` and {kw}`continue`, and single-branched {kw}`if`-statements.
While this may seem to be introducing imperative features that would get in the way of using Lean to write proofs, it is in fact nothing more than a more convenient syntax for certain common uses of monad transformers.
Behind the scenes, whatever monad the {kw}`do`-block is written in is transformed by appropriate uses of {anchorName Summary}`ExceptT` and {anchorName Summary}`StateT` to support these additional effects.
-/

# 单子变换器的 {kw}`do`-记法

Lean 的 {kw}`do`-块支持早期返回（其中块以某个值终止）、局部可变变量、带有 {kw}`break` 和 {kw}`continue` 的 {kw}`for`-循环，以及单分支 {kw}`if`-语句。
虽然这可能看起来像是引入了命令式特性，会妨碍使用 Lean 编写证明，但实际上这只不过是某些常见单子变换器使用的更方便的语法。
在幕后，无论 {kw}`do`-块是用什么单子编写的，都会通过适当使用 {anchorName Summary}`ExceptT` 和 {anchorName Summary}`StateT` 进行变换，以支持这些额外的效果。
