<!--
# The Complete Definitions
-->

# 完整定义 { #the-complete-definitions }

<!--
Now that all the relevant language features have been presented, this section describes the complete, honest definitions of `Functor`, `Applicative`, and `Monad` as they occur in the Lean standard library.
For the sake of understanding, no details are omitted.
-->

现在所有相关的语言特性都已介绍完毕，本节将讲述 Lean 的标准库中 `Functor`、`Applicative` 和 `Monad` 的完整、准确的定义。
为了便于理解，没有任何细节会被省略。

<!--
## Functor
-->

## 函子 { #functor }

<!--
The complete definition of the `Functor` class makes use of universe polymorphism and a default method implementation:
```lean
{{#example_decl Examples/FunctorApplicativeMonad/ActualDefs.lean HonestFunctor}}
```
In this definition, `Function.comp` is function composition, which is typically written with the `∘` operator.
`Function.const` is the _constant function_, which is a two-argument function that ignores its second argument.
Applying this function to only one argument produces a function that always returns the same value, which is useful when an API demands a function but a program doesn't need to compute different results for different arguments.
A simple version of `Function.const` can be written as follows:
```lean
{{#example_decl Examples/FunctorApplicativeMonad/ActualDefs.lean simpleConst}}
```
Using it with one argument as the function argument to `List.map` demonstrates its utility:
```lean
{{#example_in Examples/FunctorApplicativeMonad/ActualDefs.lean mapConst}}
```
```output info
{{#example_out Examples/FunctorApplicativeMonad/ActualDefs.lean mapConst}}
```
The actual function has the following signature:
```output info
{{#example_out Examples/FunctorApplicativeMonad/ActualDefs.lean FunctionConstType}}
```
Here, the type argument `β` is an explicit argument, so the default definition of `Functor.mapConst` provides an `_` argument that instructs Lean to find a unique type to pass to `Function.const` that would cause the program to type check.
`{{#example_in Examples/FunctorApplicativeMonad/ActualDefs.lean unfoldCompConst}}` is equivalent to `{{#example_out Examples/FunctorApplicativeMonad/ActualDefs.lean unfoldCompConst}}`.
-->

`Functor` 类的完整定义使用了宇宙多态性和默认方法实现：
```lean
{{#example_decl Examples/FunctorApplicativeMonad/ActualDefs.lean HonestFunctor}}
```
在这个定义中，`Function.comp` 是函数复合，通常用 `∘` 运算符表示。
`Function.const` 是 **常量函数**，它是一个忽略第二个参数的二元函数。
将该函数应用于仅一个参数上时，会生成一个总是返回相同值的函数，这在 API 需要一个函数但程序不需要根据不同参数去计算不同结果时非常有用。
一个简单版本的 `Function.const` 可以编写如下：
```lean
{{#example_decl Examples/FunctorApplicativeMonad/ActualDefs.lean simpleConst}}
```
将其与一个参数一起使用作为 `List.map` 的函数参数可以演示它的实用性：
```lean
{{#example_in Examples/FunctorApplicativeMonad/ActualDefs.lean mapConst}}
```
```output info
{{#example_out Examples/FunctorApplicativeMonad/ActualDefs.lean mapConst}}
```
实际的函数具有以下签名：
```output info
{{#example_out Examples/FunctorApplicativeMonad/ActualDefs.lean FunctionConstType}}
```
这里，类型参数 `β` 是一个显式参数，因此 `Functor.mapConst` 的默认定义提供了一个 `_` 参数，这个参数指示着 Lean 去找到一个唯一的类型来传递给 `Function.const`，以使程序通过类型检查。
`{{#example_in Examples/FunctorApplicativeMonad/ActualDefs.lean unfoldCompConst}}` 等价于 `{{#example_out Examples/FunctorApplicativeMonad/ActualDefs.lean unfoldCompConst}}`。

<!--
The `Functor` type class inhabits a universe that is the greater of `u+1` and `v`.
Here, `u` is the level of universes accepted as arguments to `f`, while `v` is the universe returned by `f`.
To see why the structure that implements the `Functor` type class must be in a universe that's larger than `u`, begin with a simplified definition of the class:
```lean
{{#example_decl Examples/FunctorApplicativeMonad/ActualDefs.lean FunctorSimplified}}
```
This type class's structure type is equivalent to the following inductive type:
```lean
{{#example_decl Examples/FunctorApplicativeMonad/ActualDefs.lean FunctorDatatype}}
```
The implementation of the `map` method that is passed as an argument to `Functor.mk` contains a function that takes two types in `Type u` as arguments.
This means that the type of the function itself is in `Type (u+1)`, so `Functor` must also be at a level that is at least `u+1`.
Similarly, other arguments to the function have a type built by applying `f`, so it must also have a level that is at least `v`.
All the type classes in this section share this property.
-->

`Functor` 类型类所处的宇宙是 `u+1` 和 `v` 中较大的一个。
这里，`u` 是作为 `f` 所接受的参数的宇宙层级，而 `v` 是 `f` 返回的宇宙。
要理解实现了 `Functor` 类型类的结构为何必须处于比 `u` 更大的宇宙中，请从该类的简化定义开始：
```lean
{{#example_decl Examples/FunctorApplicativeMonad/ActualDefs.lean FunctorSimplified}}
```
该类型类的结构类型等同于以下的归纳类型：
```lean
{{#example_decl Examples/FunctorApplicativeMonad/ActualDefs.lean FunctorDatatype}}
```
作为参数传递给 `Functor.mk` 的 `map` 方法的实现包含着一个函数，该函数将 `Type u` 中的两个类型作为参数。
这意味着函数本身的类型在 `Type (u+1)` 中，因此 `Functor` 也必须至少处于 `u+1` 层级。
类似地，函数的其他参数的类型是通过应用 `f` 构建的，所以它们也必须至少在 `v` 级别。
本节中的所有类型类都具有这一属性。

<!--
## Applicative
-->

## 应用类型类 { #applicative }

<!--
The `Applicative` type class is actually built from a number of smaller classes that each contain some of the relevant methods.
The first are `Pure` and `Seq`, which contain `pure` and `seq` respectively:
```lean
{{#example_decl Examples/FunctorApplicativeMonad/ActualDefs.lean Pure}}

{{#example_decl Examples/FunctorApplicativeMonad/ActualDefs.lean Seq}}
```
-->

`Applicative` 类型类实际上是由多个较小的类构成的，其中每个较小的类都包含着一些相关的方法。
首先是 `Pure` 和 `Seq`，它们分别包含着 `pure` 和 `seq` 方法：
```lean
{{#example_decl Examples/FunctorApplicativeMonad/ActualDefs.lean Pure}}

{{#example_decl Examples/FunctorApplicativeMonad/ActualDefs.lean Seq}}
```

<!--
In addition to these, `Applicative` also depends on `SeqRight` and an analogous `SeqLeft` class:
```lean
{{#example_decl Examples/FunctorApplicativeMonad/ActualDefs.lean SeqRight}}

{{#example_decl Examples/FunctorApplicativeMonad/ActualDefs.lean SeqLeft}}
```
-->

除了这些之外，`Applicative` 还依赖于 `SeqRight` 以及一个类似的 `SeqLeft` 类：
```lean
{{#example_decl Examples/FunctorApplicativeMonad/ActualDefs.lean SeqRight}}

{{#example_decl Examples/FunctorApplicativeMonad/ActualDefs.lean SeqLeft}}
```

<!--
The `seqRight` function, which was introduced in the [section about alternatives and validation](alternative.md), is easiest to understand from the perspective of effects.
`{{#example_in Examples/FunctorApplicativeMonad.lean seqRightSugar}}`, which desugars to `{{#example_out Examples/FunctorApplicativeMonad.lean seqRightSugar}}`, can be understood as first executing `E1`, and then `E2`, resulting only in `E2`'s result.
Effects from `E1` may result in `E2` not being run, or being run multiple times.
Indeed, if `f` has a `Monad` instance, then `E1 *> E2` is equivalent to `do let _ ← E1; E2`, but `seqRight` can be used with types like `Validate` that are not monads.
-->

`seqRight` 函数在[关于选择子和验证的小节](alternative.md)中介绍过，从作用的角度来看，它是最容易理解的。
`{{#example_in Examples/FunctorApplicativeMonad.lean seqRightSugar}}`，其去除语法糖后的形式为 `{{#example_out Examples/FunctorApplicativeMonad.lean seqRightSugar}}`，可以理解为先执行 `E1`，然后执行 `E2`，最终仅保留 `E2` 的结果。
`E1` 的作用可能导致 `E2` 未被执行，或被多次运行。
实际上，如果 `f` 有一个 `Monad` 实例，那么 `E1 *> E2` 等价于 `do let _ ← E1; E2`，但 `seqRight` 可以与像 `Validate` 这样不是单子的类型一起使用。

<!--
Its cousin `seqLeft` is very similar, except the leftmost expression's value is returned.
`{{#example_in Examples/FunctorApplicativeMonad/ActualDefs.lean seqLeftSugar}}` desugars to `{{#example_out Examples/FunctorApplicativeMonad/ActualDefs.lean seqLeftSugar}}`.
`{{#example_in Examples/FunctorApplicativeMonad/ActualDefs.lean seqLeftType}}` has type `{{#example_out Examples/FunctorApplicativeMonad/ActualDefs.lean seqLeftType}}`, which is identical to that of `seqRight` except for the fact that it returns `f α`.
`{{#example_in Examples/FunctorApplicativeMonad/ActualDefs.lean seqLeftSugar}}` can be understood as a program that first executes `E1`, and then `E2`, returning the original result for `E1`.
If `f` has a `Monad` instance, then `E1 <* E2` is equivalent to `do let x ← E1; _ ← E2; pure x`.
Generally speaking, `seqLeft` is useful for specifying extra conditions on a value in a validation or parser-like workflow without changing the value itself.
-->

它的近亲 `seqLeft` 非常相似，只不过其返回的是最左边的表达式的值。
`{{#example_in Examples/FunctorApplicativeMonad/ActualDefs.lean seqLeftSugar}}` 被去除语法糖后的形式为 `{{#example_out Examples/FunctorApplicativeMonad/ActualDefs.lean seqLeftSugar}}`。
`{{#example_in Examples/FunctorApplicativeMonad/ActualDefs.lean seqLeftType}}` 的类型是 `{{#example_out Examples/FunctorApplicativeMonad/ActualDefs.lean seqLeftType}}`，与 `seqRight` 的类型相同，只是它返回 `f α`。
`{{#example_in Examples/FunctorApplicativeMonad/ActualDefs.lean seqLeftSugar}}` 可以理解为一个先执行 `E1`，然后执行 `E2`，最后返回 `E1` 的原始结果的程序。
如果 `f` 有一个 `Monad` 实例，那么 `E1 <* E2` 等价于 `do let x ← E1; _ ← E2; pure x`。
通常来说，`seqLeft` 在验证或类似解析器的工作流程中，可用于为一个值指定的额外条件而不改变该值本身。

<!--
The definition of `Applicative` extends all these classes, along with `Functor`:
```lean
{{#example_decl Examples/FunctorApplicativeMonad/ActualDefs.lean Applicative}}
```
A complete definition of `Applicative` requires only definitions for `pure` and `seq`.
This is because there are default definitions for all of the methods from `Functor`, `SeqLeft`, and `SeqRight`.
The `mapConst` method of `Functor` has its own default implementation in terms of `Functor.map`.
These default implementations should only be overridden with new functions that are behaviorally equivalent, but more efficient.
The default implementations should be seen as specifications for correctness as well as automatically-created code.
-->

`Applicative` 的定义扩展自所有这些类，以及 `Functor`：
```lean
{{#example_decl Examples/FunctorApplicativeMonad/ActualDefs.lean Applicative}}
```
完整定义 `Applicative` 只需要 `pure` 和 `seq` 的定义。
这是因为 `Functor`、`SeqLeft` 和 `SeqRight` 的所有方法都有默认定义。
`Functor` 的 `mapConst` 方法有一个基于 `Functor.map` 的自己的默认实现。
这些默认实现只应被行为上等价但更高效的新函数覆盖。
默认实现应被视为正确性的规范以及自动创建的代码。

<!--
The default implementation for `seqLeft` is very compact.
Replacing some of the names with their syntactic sugar or their definitions can provide another view on it, so:
```lean
{{#example_in Examples/FunctorApplicativeMonad/ActualDefs.lean unfoldMapConstSeqLeft}}
```
becomes
```lean
{{#example_out Examples/FunctorApplicativeMonad/ActualDefs.lean unfoldMapConstSeqLeft}}
```
How should `(fun x _ => x) <$> a` be understood?
Here, `a` has type `f α`, and `f` is a functor.
If `f` is `List`, then `{{#example_in Examples/FunctorApplicativeMonad/ActualDefs.lean mapConstList}}` evaluates to `{{#example_out Examples/FunctorApplicativeMonad/ActualDefs.lean mapConstList}}`.
If `f` is `Option`, then `{{#example_in Examples/FunctorApplicativeMonad/ActualDefs.lean mapConstOption}}` evaluates to `{{#example_out Examples/FunctorApplicativeMonad/ActualDefs.lean mapConstOption}}`.
In each case, the values in the functor are replaced by functions that return the original value, ignoring their argument.
When combined with `seq`, this function discards the values from `seq`'s second argument.
-->

`seqLeft` 的默认实现非常简洁。
将其中一些名称替换为它们的语法糖或它们的定义可以提供另一种视角，因此：
```lean
{{#example_in Examples/FunctorApplicativeMonad/ActualDefs.lean unfoldMapConstSeqLeft}}
```
变成了
```lean
{{#example_out Examples/FunctorApplicativeMonad/ActualDefs.lean unfoldMapConstSeqLeft}}
```
`(fun x _ => x) <$> a` 应该如何理解？
这里，`a` 的类型是 `f α`，且 `f` 是一个函子。
如果 `f` 是 `List`，那么 `{{#example_in Examples/FunctorApplicativeMonad/ActualDefs.lean mapConstList}}` 的求值结果为 `{{#example_out Examples/FunctorApplicativeMonad/ActualDefs.lean mapConstList}}`。
如果 `f` 是 `Option`，那么 `{{#example_in Examples/FunctorApplicativeMonad/ActualDefs.lean mapConstOption}}` 的求值结果为 `{{#example_out Examples/FunctorApplicativeMonad/ActualDefs.lean mapConstOption}}`。
在每种情况下，函子中的值都被替换为忽略其参数并返回原始值的函数。
当与 `seq` 组合时，该函数会舍弃 `seq` 的第二个参数的值。

<!--
The default implementation for `seqRight` is very similar, except `const` has an additional argument `id`.
This definition can be understood similarly, by first introducing some standard syntactic sugar and then replacing some names with their definitions:
```lean
{{#example_eval Examples/FunctorApplicativeMonad/ActualDefs.lean unfoldMapConstSeqRight}}
```
How should `(fun _ x => x) <$> a` be understood?
Once again, examples are useful.
`{{#example_in Examples/FunctorApplicativeMonad/ActualDefs.lean mapConstIdList}}` is equivalent to `{{#example_out Examples/FunctorApplicativeMonad/ActualDefs.lean mapConstIdList}}`, and `{{#example_in Examples/FunctorApplicativeMonad/ActualDefs.lean mapConstIdOption}}` is equivalent to `{{#example_out Examples/FunctorApplicativeMonad/ActualDefs.lean mapConstIdOption}}`.
In other words, `(fun _ x => x) <$> a` preserves the overall shape of `a`, but each value is replaced by the identity function.
From the perspective of effects, the side effects of `a` occur, but the values are thrown out when it is used with `seq`.
-->

`seqRight` 的默认实现非常相似，只不过 `const` 有一个额外的参数 `id`。
这个定义可以类似地理解，首先引入一些标准的语法糖，然后用它们的定义替换一些名称：
```lean
{{#example_eval Examples/FunctorApplicativeMonad/ActualDefs.lean unfoldMapConstSeqRight}}
```
`(fun _ x => x) <$> a` 应该如何理解？
同样地，例子很有用。
`{{#example_in Examples/FunctorApplicativeMonad/ActualDefs.lean mapConstIdList}}` 等价于 `{{#example_out Examples/FunctorApplicativeMonad/ActualDefs.lean mapConstIdList}}`，而 `{{#example_in Examples/FunctorApplicativeMonad/ActualDefs.lean mapConstIdOption}}` 等价于 `{{#example_out Examples/FunctorApplicativeMonad/ActualDefs.lean mapConstIdOption}}`。
换句话说，`(fun _ x => x) <$> a` 保留了 `a` 的整体形状，但每个值都被恒等函数替换。
从作用的角度来看，`a` 的副作用发生了，但是当它与 `seq` 一起使用时，其值会被丢弃。

<!--
## Monad
-->

## 单子 { #monad }

<!--
Just as the constituent operations of `Applicative` are split into their own type classes, `Bind` has its own class as well:
```lean
{{#example_decl Examples/FunctorApplicativeMonad/ActualDefs.lean Bind}}
```
`Monad` extends `Applicative` with `Bind`:
```lean
{{#example_decl Examples/FunctorApplicativeMonad/ActualDefs.lean Monad}}
```
Tracing the collection of inherited methods and default methods from the entire hierarchy shows that a `Monad` instance requires only implementations of `bind` and `pure`.
In other words, `Monad` instances automatically yield implementations of `seq`, `seqLeft`, `seqRight`, `map`, and `mapConst`.
From the perspective of API boundaries, any type with a `Monad` instance gets instances for `Bind`, `Pure`, `Seq`, `Functor`, `SeqLeft`, and `SeqRight`.
-->

正如 `Applicative` 的组成操作被分成各自的类型类一样，`Bind` 也有它自己的类型类：
```lean
{{#example_decl Examples/FunctorApplicativeMonad/ActualDefs.lean Bind}}
```
`Monad` 扩展自 `Applicative`，以及 `Bind`：
```lean
{{#example_decl Examples/FunctorApplicativeMonad/ActualDefs.lean Monad}}
```
从整个层级结构中追踪继承的方法和默认方法的集合可以看出，一个 `Monad` 实例只需要实现 `bind` 和 `pure`。
换句话说，`Monad` 实例会自动生成 `seq`、`seqLeft`、`seqRight`、`map` 和 `mapConst` 的实现。
从 API 边界的角度来看，任何具有 `Monad` 实例的类型都会获得 `Bind`、`Pure`、`Seq`、`Functor`、`SeqLeft` 和 `SeqRight` 的实例。

<!--
## Exercises
-->

## 练习 { #exercises }

<!--
 1. Understand the default implementations of `map`, `seq`, `seqLeft`, and `seqRight` in `Monad` by working through examples such as `Option` and `Except`. In other words, substitute their definitions for `bind` and `pure` into the default definitions, and simplify them to recover the versions `map`, `seq`, `seqLeft`, and `seqRight` that would be written by hand.
 2. On paper or in a text file, prove to yourself that the default implementations of `map` and `seq` satisfy the contracts for `Functor` and `Applicative`. In this argument, you're allowed to use the rules from the `Monad` contract as well as ordinary expression evaluation.
-->

 1. 通过研究诸如 `Option` 和 `Except` 等例子来理解 `Monad` 中 `map`、`seq`、`seqLeft` 和 `seqRight` 的默认实现。换句话说，将它们对 `bind` 和 `pure` 的定义去替换默认定义，并简化它们以恢复手写版本的 `map`、`seq`、`seqLeft` 和 `seqRight`。
 2. 在纸上或文本文件中，向自己证明 `map` 和 `seq` 的默认实现满足 `Functor` 和 `Applicative` 的契约。在这个论证中，你允许使用 `Monad` 契约中的规则以及普通的表达式求值。