<!--
# The Applicative Contract
-->

# 应用契约

<!--
Just like `Functor`, `Monad`, and types that implement `BEq` and `Hashable`, `Applicative` has a set of rules that all instances should adhere to.
-->

就像 `Functor`、`Monad` 以及实现了 `BEq` 和 `Hashable` 的类型一样，`Applicative` 也有一套所有实例都应遵守的规则。

<!--
There are four rules that an applicative functor should follow:
1. It should respect identity, so `pure id <*> v = v`
2. It should respect function composition, so `pure (· ∘ ·) <*> u <*> v <*> w = u <*> (v <*> w)`
3. Sequencing pure operations should be a no-op, so `pure f <*> pure x = pure (f x)`
4. The ordering of pure operations doesn't matter, so `u <*> pure x = pure (fun f => f x) <*> u`
-->

应用函子应该遵循四条规则：
1. 应遵循同一律，即 `pure id <*> v = v`
2. 应遵循函数复合律，即 `pure (· ∘ ·) <*> u <*> v <*> w = u <*> (v <*> w)`
3. 对纯操作进行排序应等同于无操作，即 `pure f <*> pure x = pure (f x)`
4. 纯操作的顺序不应影响结果，即 `u <*> pure x = pure (fun f => f x) <*> u`

<!--
To check these for the `Applicative Option` instance, start by expanding `pure` into `some`.
-->

要检验对于 `Applicative Option` 实例的这些规则，首先将 `pure` 展开为 `some`。

<!--
The first rule states that `some id <*> v = v`.
The definition of `seq` for `Option` states that this is the same as `id <$> v = v`, which is one of the `Functor` rules that have already been checked.
-->

第一条规则表明 `some id <*> v = v`。
`Option` 的 `seq` 定义指明，这与 `id <$> v = v` 相同，这是已被检查过的 `Functor` 规则之一。

<!--
The second rule states that `some (· ∘ ·) <*> u <*> v <*> w = u <*> (v <*> w)`.
If any of `u`, `v`, or `w` is `none`, then both sides are `none`, so the property holds.
Assuming that `u` is `some f`, that `v` is `some g`, and that `w` is `some x`, then this is equivalent to saying that `some (· ∘ ·) <*> some f <*> some g <*> some x = some f <*> (some g <*> some x)`.
Evaluating the two sides yields the same result:
```lean
{{#example_eval Examples/FunctorApplicativeMonad.lean OptionHomomorphism1}}

{{#example_eval Examples/FunctorApplicativeMonad.lean OptionHomomorphism2}}
```
-->

第二条规则指出 `some (· ∘ ·) <*> u <*> v <*> w = u <*> (v <*> w)`。
如果 `u`、`v` 或 `w` 中有任何一个是 `none`，则两边均为 `none`，因此该属性成立。
假设 `u` 是 `some f`，`v` 是 `some g`，`w` 是 `some x`，那么这等价于声明 `some (· ∘ ·) <*> some f <*> some g <*> some x = some f <*> (some g <*> some x)`。
对两边求值得到相同的结果：
```lean
{{#example_eval Examples/FunctorApplicativeMonad.lean OptionHomomorphism1}}

{{#example_eval Examples/FunctorApplicativeMonad.lean OptionHomomorphism2}}
```

<!--
The third rule follows directly from the definition of `seq`:
```lean
{{#example_eval Examples/FunctorApplicativeMonad.lean OptionPureSeq}}
```
-->

第三条规则直接源于 `seq` 的定义：
```lean
{{#example_eval Examples/FunctorApplicativeMonad.lean OptionPureSeq}}
```

<!--
In the fourth case, assume that `u` is `some f`, because if it's `none`, both sides of the equation are `none`.
`some f <*> some x` evaluates directly to `some (f x)`, as does `some (fun g => g x) <*> some f`.
-->

在第四种情况下，假设 `u` 是 `some f`，因为如果它是 `none`，则等式的两边都是 `none`。
`some f <*> some x` 的求值结果直接为 `some (f x)`，正如 `some (fun g => g x) <*> some f` 也是如此。


<!--
## All Applicatives are Functors
-->

## 所有的应用函子都是函子


<!--
The two operators for `Applicative` are enough to define `map`:
```lean
{{#example_decl Examples/FunctorApplicativeMonad.lean ApplicativeMap}}
```
-->

`Applicative` 的两个运算符足以定义 `map`：
```lean
{{#example_decl Examples/FunctorApplicativeMonad.lean ApplicativeMap}}
```

<!--
This can only be used to implement `Functor` if the contract for `Applicative` guarantees the contract for `Functor`, however.
The first rule of `Functor` is that `id <$> x = x`, which follows directly from the first rule for `Applicative`.
The second rule of `Functor` is that `map (f ∘ g) x = map f (map g x)`.
Unfolding the definition of `map` here results in `pure (f ∘ g) <*> x = pure f <*> (pure g <*> x)`.
Using the rule that sequencing pure operations is a no-op, the left side can be rewritten to `pure (· ∘ ·) <*> pure f <*> pure g <*> x`.
This is an instance of the rule that states that applicative functors respect function composition.
-->

但是，只有当 `Applicative` 的契约保证了 `Functor` 的契约时，这才能用来实现 `Functor`。
`Functor` 的第一条规则是 `id <$> x = x`，这直接源于 `Applicative` 的第一条规则。
`Functor` 的第二条规则是 `map (f ∘ g) x = map f (map g x)`。
在这里展开 `map` 的定义会得到 `pure (f ∘ g) <*> x = pure f <*> (pure g <*> x)`。
使用将纯操作进行排序视为无操作的规则，其左侧可以重写为 `pure (· ∘ ·) <*> pure f <*> pure g <*> x`。
这是应用函子遵守函数复合规则的一个实例。

<!--
This justifies a definition of `Applicative` that extends `Functor`, with a default definition of `map` given in terms of `pure` and `seq`:
```lean
{{#example_decl Examples/FunctorApplicativeMonad.lean ApplicativeExtendsFunctorOne}}
```
-->

这证明了定义一个扩展自 `Functor` 的 `Applicative` 是合理的，其中 `map` 的默认定义可以用 `pure` 和 `seq` 来表示：
```lean
{{#example_decl Examples/FunctorApplicativeMonad.lean ApplicativeExtendsFunctorOne}}
```


<!--
## All Monads are Applicative Functors
-->

## 所有 Monad 都是应用函子

<!--
An instance of `Monad` already requires an implementation of `pure`.
Together with `bind`, this is enough to define `seq`:
```lean
{{#example_decl Examples/FunctorApplicativeMonad.lean MonadSeq}}
```
Once again, checking that the `Monad` contract implies the `Applicative` contract will allow this to be used as a default definition for `seq` if `Monad` extends `Applicative`.
-->

`Monad` 的一个实例已经需要实现 `pure`。
结合 `bind`，这足以定义 `seq`：
```lean
{{#example_decl Examples/FunctorApplicativeMonad.lean MonadSeq}}
```
再一次，检验 `Monad` 的契约暗含 `Applicative` 的契约，如果 `Monad` 扩展自 `Applicative`，这将允许将其用作 `seq` 的默认定义。

<!--
The rest of this section consists of an argument that this implementation of `seq` based on `bind` in fact satisfies the `Applicative` contract.
One of the beautiful things about functional programming is that this kind of argument can be worked out on a piece of paper with a pencil, using the kinds of evaluation rules from [the initial section on evaluating expressions](../getting-to-know/evaluating.md).
Thinking about the meanings of the operations while reading these arguments can sometimes help with understanding.
-->

本节的其余部分包含一个论点，即基于 `bind` 的 `seq` 的这种实现实际上满足了 `Applicative` 契约。
函数式编程的一个美妙之处在于，这种论点可以用铅笔在纸上完成，使用[表达式求值初步小节](../getting-to-know/evaluating.md)中的求值规则。
在阅读这些论点时，思考操作的含义有时有助于理解。

<!--
Replacing `do`-notation with explicit uses of `>>=` makes it easier to apply the `Monad` rules:
```lean
{{#example_decl Examples/FunctorApplicativeMonad.lean MonadSeqDesugar}}
```
-->

将 `do` 表示法替换为 `>>=` 的显式使用可以更容易地应用 `Monad` 规则：
```lean
{{#example_decl Examples/FunctorApplicativeMonad.lean MonadSeqDesugar}}
```

<!--
To check that this definition respects identity, check that `seq (pure id) (fun () => v) = v`.
The left hand side is equivalent to `pure id >>= fun g => (fun () => v) () >>= fun y => pure (g y)`.
The unit function in the middle can be eliminated immediately, yielding `pure id >>= fun g => v >>= fun y => pure (g y)`.
Using the fact that `pure` is a left identity of `>>=`, this is the same as `v >>= fun y => pure (id y)`, which is `v >>= fun y => pure y`.
Because `fun x => f x` is the same as `f`, this is the same as `v >>= pure`, and the fact that `pure` is a right identity of `>>=` can be used to get `v`.
-->

为了检查这个定义遵循恒等性，请检验 `seq (pure id) (fun () => v) = v`。
左侧等价于 `pure id >>= fun g => (fun () => v) () >>= fun y => pure (g y)`。
中间的单位函数可以立即消除，得到 `pure id >>= fun g => v >>= fun y => pure (g y)`。
利用 `pure` 是 `>>=` 的左恒等性这一事实，其等同于 `v >>= fun y => pure (id y)`，也就是 `v >>= fun y => pure y`。
因为 `fun x => f x` 与 `f` 是相同的，所以这与 `v >>= pure` 相同，并且 `pure` 是 `>>=` 的右恒等性可以被用来获取 `v`。

<!--
This kind of informal reasoning can be made easier to read with a bit of reformatting.
In the following chart, read "EXPR1 ={ REASON }= EXPR2" as "EXPR1 is the same as EXPR2 because REASON":
{{#equations Examples/FunctorApplicativeMonad.lean mSeqRespId}}
-->

这种非正式的推理可以通过稍微的重新编排来使其更易阅读。
在下表中，读取 "EXPR1 ={ REASON }= EXPR2" 时，请将其理解为 "EXPR1 因为 REASON 与 EXPR2 相同":
{{#equations Examples/FunctorApplicativeMonad.lean mSeqRespId}}

<!--
To check that it respects function composition, check that `pure (· ∘ ·) <*> u <*> v <*> w = u <*> (v <*> w)`.
The first step is to replace `<*>` with this definition of `seq`.
After that, a (somewhat long) series of steps that use the identity and associativity rules from the `Monad` contract is enough to get from one to the other:
{{#equations Examples/FunctorApplicativeMonad.lean mSeqRespComp}}
-->

要检查它遵守函数复合的规则，请验证 `pure (· ∘ ·) <*> u <*> v <*> w = u <*> (v <*> w)`。
第一步是用 `seq` 的这个定义替换 `<*>`。
之后，使用 `Monad` 契约中的恒等律和结合律规则的一系列（有点长的）步骤，以从一个得到另一个：
{{#equations Examples/FunctorApplicativeMonad.lean mSeqRespComp}}

<!--
To check that sequencing pure operations is a no-op:
{{#equations Examples/FunctorApplicativeMonad.lean mSeqPureNoOp}}
-->

以检验对纯操作进行排序为无操作：
{{#equations Examples/FunctorApplicativeMonad.lean mSeqPureNoOp}}

<!--
And finally, to check that the ordering of pure operations doesn't matter:
{{#equations Examples/FunctorApplicativeMonad.lean mSeqPureNoOrder}}
-->

最后，以检验纯操作的顺序是无关紧要的：
{{#equations Examples/FunctorApplicativeMonad.lean mSeqPureNoOrder}}

<!--
This justifies a definition of `Monad` that extends `Applicative`, with a default definition of `seq`:
```lean
{{#example_decl Examples/FunctorApplicativeMonad.lean MonadExtends}}
```
`Applicative`'s own default definition of `map` means that every `Monad` instance automatically generates `Applicative` and `Functor` instances as well.
-->

这证明了 `Monad` 的定义扩展自 `Applicative`，并提供一个 `seq` 的默认定义：
```lean
{{#example_decl Examples/FunctorApplicativeMonad.lean MonadExtends}}
```
`Applicative` 自身对 `map` 的默认定义意味着每个 `Monad` 实例都会自动生成 `Applicative` 和 `Functor` 实例。


<!--
## Additional Stipulations
-->

## 附加规定

<!--
In addition to adhering to the individual contracts associated with each type class, combined implementations `Functor`, `Applicative` and `Monad` should work equivalently to these default implementations.
In other words, a type that provides both `Applicative` and `Monad` instances should not have an implementation of `seq` that works differently from the version that the `Monad` instance generates as a default implementation.
This is important because polymorphic functions may be refactored to replace a use of `>>=` with an equivalent use of `<*>`, or a use of `<*>` with an equivalent use of `>>=`.
This refactoring should not change the meaning of programs that use this code.
-->

除了遵守每个类型类相关的单独契约之外，`Functor`、`Applicative` 和 `Monad` 的组合实现应与这些默认实现等效。
换句话说，一个同时提供 `Applicative` 和 `Monad` 实例的类型，其 `seq` 的实现不应与 `Monad` 实例生成的默认实现不同。
这很重要，因为多态函数可以被重构，以使用 `<*>` 的等效使用去替换 `>>=`，或者用 `>>=` 的等效使用去替换 `<*>`。
这种重构不应改变使用该代码的程序的含义。

<!--
This rule explains why `Validate.andThen` should not be used to implement `bind` in a `Monad` instance.
On its own, it obeys the monad contract.
However, when it is used to implement `seq`, the behavior is not equivalent to `seq` itself.
To see where they differ, take the example of two computations, both of which return errors.
Start with an example of a case where two errors should be returned, one from validating a function (which could have just as well resulted from a prior argument to the function), and one from validating an argument:
```lean
{{#example_decl Examples/FunctorApplicativeMonad.lean counterexample}}
```
-->

这条规则解释了为什么在 `Monad` 实例中不应使用 `Validate.andThen` 来实现 `bind`。
就其本身而言，它遵守单子契约。
然而，当它用于实现 `seq` 时，其行为并不等同于 `seq` 本身。
要了解它们的区别，举一个两个计算都返回错误的例子。
首先来看一个应该返回两个错误的情况，一个来自函数验证（这也可能是由函数先前的一个参数导致的），另一个来自参数验证：
```lean
{{#example_decl Examples/FunctorApplicativeMonad.lean counterexample}}
```

<!--
Combining them with the version of `<*>` from `Validate`'s `Applicative` instance results in both errors being reported to the user:
```lean
{{#example_eval Examples/FunctorApplicativeMonad.lean realSeq}}
```
-->

将它们与 `Validate` 的 `Applicative` 实例中的 `<*>` 版本结合起来，会导致两个错误都被报告给用户：
```lean
{{#example_eval Examples/FunctorApplicativeMonad.lean realSeq}}
```

<!--
Using the version of `seq` that was implemented with `>>=`, here rewritten to `andThen`, results in only the first error being available:
```lean
{{#example_eval Examples/FunctorApplicativeMonad.lean fakeSeq}}
```
-->

使用由 `>>=` 实现的 `seq` 版本（这里重写为 `andThen`）会导致只出现第一个错误：
```lean
{{#example_eval Examples/FunctorApplicativeMonad.lean fakeSeq}}
```