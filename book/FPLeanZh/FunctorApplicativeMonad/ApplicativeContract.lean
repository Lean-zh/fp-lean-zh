import VersoManual
import FPLeanZh.Examples

open Verso.Genre Manual
open Verso Code External

open FPLeanZh

set_option verso.exampleProject "../examples"
set_option verso.exampleModule "Examples.FunctorApplicativeMonad"

#doc (Manual) "Applicative 契约" =>

-- Just like {anchorName ApplicativeLaws}`Functor`, {anchorName ApplicativeLaws}`Monad`, and types that implement {anchorName SizedCreature}`BEq` and {anchorName MonstrousAssistantMore}`Hashable`, {anchorName ApplicativeLaws}`Applicative` has a set of rules that all instances should adhere to.

就像 {anchorName ApplicativeLaws}`Functor`、{anchorName ApplicativeLaws}`Monad` 以及实现 {anchorName SizedCreature}`BEq` 和 {anchorName MonstrousAssistantMore}`Hashable` 的类型一样，{anchorName ApplicativeLaws}`Applicative` 也有一套所有实例都应遵守的规则。

-- There are four rules that an applicative functor should follow:
-- 1. It should respect identity, so {anchorTerm ApplicativeLaws}`pure id <*> v = v`
-- 2. It should respect function composition, so {anchorTerm ApplicativeLaws}`pure (· ∘ ·) <*> u <*> v <*> w = u <*> (v <*> w)`
-- 3. Sequencing pure operations should be a no-op, so {anchorTerm ApplicativeLaws}`pure f <*> pure x`{lit}` = `{anchorTerm ApplicativeLaws}`pure (f x)`
-- 4. The ordering of pure operations doesn't matter, so {anchorTerm ApplicativeLaws}`u <*> pure x = pure (fun f => f x) <*> u`

Applicative 函子应遵循四条规则：
1. 它应遵守恒等性，因此 {anchorTerm ApplicativeLaws}`pure id <*> v = v`
2. 它应遵守函数组合，因此 {anchorTerm ApplicativeLaws}`pure (· ∘ ·) <*> u <*> v <*> w = u <*> (v <*> w)`
3. 纯操作的序列化应是空操作，因此 {anchorTerm ApplicativeLaws}`pure f <*> pure x`{lit}` = `{anchorTerm ApplicativeLaws}`pure (f x)`
4. 纯操作的顺序无关紧要，因此 {anchorTerm ApplicativeLaws}`u <*> pure x = pure (fun f => f x) <*> u`

-- To check these for the {anchorTerm ApplicativeOption}`Applicative Option` instance, start by expanding {anchorName ApplicativeLaws}`pure` into {anchorName ApplicativeOption}`some`.

为了检查 {anchorTerm ApplicativeOption}`Applicative Option` 实例的这些规则，首先将 {anchorName ApplicativeLaws}`pure` 展开为 {anchorName ApplicativeOption}`some`。

-- The first rule states that {anchorTerm ApplicativeOptionLaws1}`some id <*> v = v`.
-- The definition of {anchorName fakeSeq}`seq` for {anchorName ApplicativeOption}`Option` states that this is the same as {anchorTerm ApplicativeOptionLaws1}`id <$> v = v`, which is one of the {anchorName ApplicativeLaws}`Functor` rules that have already been checked.

第一条规则指出 {anchorTerm ApplicativeOptionLaws1}`some id <*> v = v`。
{anchorName ApplicativeOption}`Option` 的 {anchorName fakeSeq}`seq` 定义指出这与 {anchorTerm ApplicativeOptionLaws1}`id <$> v = v` 相同，这是已经检查过的 {anchorName ApplicativeLaws}`Functor` 规则之一。

-- The second rule states that {anchorTerm ApplicativeOptionLaws2}`some (· ∘ ·) <*> u <*> v <*> w = u <*> (v <*> w)`.
-- If any of {anchorName ApplicativeOptionLaws2}`u`, {anchorName ApplicativeOptionLaws2}`v`, or {anchorName ApplicativeOptionLaws2}`w` is {anchorName ApplicativeOption}`none`, then both sides are {anchorName ApplicativeOption}`none`, so the property holds.
-- Assuming that {anchorName ApplicativeOptionLaws2}`u` is {anchorTerm OptionHomomorphism1}`some f`, that {anchorName ApplicativeOptionLaws2}`v` is {anchorTerm OptionHomomorphism1}`some g`, and that {anchorName ApplicativeOptionLaws2}`w` is {anchorTerm OptionHomomorphism1}`some x`, then this is equivalent to saying that {anchorTerm OptionHomomorphism}`some (· ∘ ·) <*> some f <*> some g <*> some x = some f <*> (some g <*> some x)`.
-- Evaluating the two sides yields the same result:

第二条规则指出 {anchorTerm ApplicativeOptionLaws2}`some (· ∘ ·) <*> u <*> v <*> w = u <*> (v <*> w)`。
如果 {anchorName ApplicativeOptionLaws2}`u`、{anchorName ApplicativeOptionLaws2}`v` 或 {anchorName ApplicativeOptionLaws2}`w` 中的任何一个是 {anchorName ApplicativeOption}`none`，那么两边都是 {anchorName ApplicativeOption}`none`，因此该属性成立。
假设 {anchorName ApplicativeOptionLaws2}`u` 是 {anchorTerm OptionHomomorphism1}`some f`，{anchorName ApplicativeOptionLaws2}`v` 是 {anchorTerm OptionHomomorphism1}`some g`，并且 {anchorName ApplicativeOptionLaws2}`w` 是 {anchorTerm OptionHomomorphism1}`some x`，那么这等价于说 {anchorTerm OptionHomomorphism}`some (· ∘ ·) <*> some f <*> some g <*> some x = some f <*> (some g <*> some x)`。
评估两边会产生相同的结果：

```anchorEvalSteps OptionHomomorphism1
some (· ∘ ·) <*> some f <*> some g <*> some x
===>
some (f ∘ ·) <*> some g <*> some x
===>
some (f ∘ g) <*> some x
===>
some ((f ∘ g) x)
===>
some (f (g x))
```

```anchorEvalSteps OptionHomomorphism2
some f <*> (some g <*> some x)
===>
some f <*> (some (g x))
===>
some (f (g x))
```

-- The third rule follows directly from the definition of {anchorName fakeSeq}`seq`:

第三条规则直接来自 {anchorName fakeSeq}`seq` 的定义：

```anchorEvalSteps OptionPureSeq
some f <*> some x
===>
f <$> some x
===>
some (f x)
```

-- In the fourth case, assume that {anchorName ApplicativeLaws}`u` is {anchorTerm OptionPureSeq}`some f`, because if it's {anchorName AlternativeOption}`none`, both sides of the equation are {anchorName AlternativeOption}`none`.
-- {anchorTerm OptionPureSeq}`some f <*> some x` evaluates directly to {anchorTerm OptionPureSeq}`some (f x)`, as does {anchorTerm OptionPureSeq2}`some (fun g => g x) <*> some f`.

在第四种情况下，假设 {anchorName ApplicativeLaws}`u` 是 {anchorTerm OptionPureSeq}`some f`，因为如果它是 {anchorName AlternativeOption}`none`，则等式两边都是 {anchorName AlternativeOption}`none`。
{anchorTerm OptionPureSeq}`some f <*> some x` 直接计算为 {anchorTerm OptionPureSeq}`some (f x)`，{anchorTerm OptionPureSeq2}`some (fun g => g x) <*> some f` 也是如此。


-- # All Applicatives are Functors

# 所有 Applicative 都是 Functor

-- The two operators for {anchorName ApplicativeMap}`Applicative` are enough to define {anchorName ApplicativeMap}`map`:

{anchorName ApplicativeMap}`Applicative` 的两个运算符足以定义 {anchorName ApplicativeMap}`map`：

```anchor ApplicativeMap
def map [Applicative f] (g : α → β) (x : f α) : f β :=
  pure g <*> x
```

-- This can only be used to implement {anchorName ApplicativeLaws}`Functor` if the contract for {anchorName ApplicativeLaws}`Applicative` guarantees the contract for {anchorName ApplicativeLaws}`Functor`, however.
-- The first rule of {anchorName ApplicativeLaws}`Functor` is that {anchorTerm AppToFunTerms}`id <$> x = x`, which follows directly from the first rule for {anchorName ApplicativeLaws}`Applicative`.
-- The second rule of {anchorName ApplicativeLaws}`Functor` is that {anchorTerm AppToFunTerms}`map (f ∘ g) x = map f (map g x)`.
-- Unfolding the definition of {anchorName AppToFunTerms}`map` here results in {anchorTerm AppToFunTerms}`pure (f ∘ g) <*> x = pure f <*> (pure g <*> x)`.
-- Using the rule that sequencing pure operations is a no-op, the left side can be rewritten to {anchorTerm AppToFunTerms}`pure (· ∘ ·) <*> pure f <*> pure g <*> x`.
-- This is an instance of the rule that states that applicative functors respect function composition.

然而，只有当 {anchorName ApplicativeLaws}`Applicative` 的契约保证了 {anchorName ApplicativeLaws}`Functor` 的契约时，这才能用于实现 {anchorName ApplicativeLaws}`Functor`。
{anchorName ApplicativeLaws}`Functor` 的第一条规则是 {anchorTerm AppToFunTerms}`id <$> x = x`，这直接来自 {anchorName ApplicativeLaws}`Applicative` 的第一条规则。
{anchorName ApplicativeLaws}`Functor` 的第二条规则是 {anchorTerm AppToFunTerms}`map (f ∘ g) x = map f (map g x)`。
在这里展开 {anchorName AppToFunTerms}`map` 的定义会得到 {anchorTerm AppToFunTerms}`pure (f ∘ g) <*> x = pure f <*> (pure g <*> x)`。
使用纯操作序列化是空操作的规则，左侧可以重写为 {anchorTerm AppToFunTerms}`pure (· ∘ ·) <*> pure f <*> pure g <*> x`。
这是 Applicative 函子遵守函数组合的规则的一个实例。

-- This justifies a definition of {anchorName ApplicativeMap}`Applicative` that extends {anchorName ApplicativeLaws}`Functor`, with a default definition of {anchorTerm ApplicativeExtendsFunctorOne}`map` given in terms of {anchorName ApplicativeExtendsFunctorOne}`pure` and {anchorName ApplicativeExtendsFunctorOne}`seq`:

这证明了 {anchorName ApplicativeMap}`Applicative` 的定义扩展了 {anchorName ApplicativeLaws}`Functor`，其中 {anchorTerm ApplicativeExtendsFunctorOne}`map` 的默认定义由 {anchorName ApplicativeExtendsFunctorOne}`pure` 和 {anchorName ApplicativeExtendsFunctorOne}`seq` 给出：

```anchor ApplicativeExtendsFunctorOne
class Applicative (f : Type → Type) extends Functor f where
  pure : α → f α
  seq : f (α → β) → (Unit → f α) → f β
  map g x := seq (pure g) (fun () => x)
```

-- # All Monads are Applicative Functors

# 所有 Monad 都是 Applicative Functor

-- An instance of {anchorName MonadExtends}`Monad` already requires an implementation of {anchorName MonadSeq}`pure`.
-- Together with {anchorName MonadExtends}`bind`, this is enough to define {anchorName MonadSeq}`seq`:

{anchorName MonadExtends}`Monad` 的实例已经需要 {anchorName MonadSeq}`pure` 的实现。
结合 {anchorName MonadExtends}`bind`，这足以定义 {anchorName MonadSeq}`seq`：

```anchor MonadSeq
def seq [Monad m] (f : m (α → β)) (x : Unit → m α) : m β := do
  let g ← f
  let y ← x ()
  pure (g y)
```

-- Once again, checking that the {anchorName MonadSeq}`Monad` contract implies the {anchorName MonadExtends}`Applicative` contract will allow this to be used as a default definition for {anchorTerm MonadExtends}`seq` if {anchorName MonadSeq}`Monad` extends {anchorName MonadExtends}`Applicative`.

再次，检查 {anchorName MonadSeq}`Monad` 契约是否蕴含 {anchorName MonadExtends}`Applicative` 契约，如果 {anchorName MonadSeq}`Monad` 扩展了 {anchorName MonadExtends}`Applicative`，则允许将其用作 {anchorTerm MonadExtends}`seq` 的默认定义。

-- The rest of this section consists of an argument that this implementation of {anchorTerm MonadExtends}`seq` based on {anchorName MonadExtends}`bind` in fact satisfies the {anchorName MonadExtends}`Applicative` contract.
-- One of the beautiful things about functional programming is that this kind of argument can be worked out on a piece of paper with a pencil, using the kinds of evaluation rules from {ref "evaluating"}[the initial section on evaluating expressions].
-- Thinking about the meanings of the operations while reading these arguments can sometimes help with understanding.

本节的其余部分论证了基于 {anchorName MonadExtends}`bind` 的 {anchorTerm MonadExtends}`seq` 实现实际上满足 {anchorName MonadExtends}`Applicative` 契约。
函数式编程的美妙之处在于，这种论证可以在纸上用铅笔推导出来，使用 {ref "evaluating"}[评估表达式的初始部分] 中的评估规则。
在阅读这些论证时思考操作的含义有时有助于理解。

-- Replacing {kw}`do`-notation with explicit uses of {lit}`>>=` makes it easier to apply the {anchorName MonadSeqDesugar}`Monad` rules:

用 {lit}`>>=` 的显式使用替换 {kw}`do`-notation 使应用 {anchorName MonadSeqDesugar}`Monad` 规则更容易：

```anchor MonadSeqDesugar
def seq [Monad m] (f : m (α → β)) (x : Unit → m α) : m β := do
  f >>= fun g =>
  x () >>= fun y =>
  pure (g y)
```

-- To check that this definition respects identity, check that {anchorTerm mSeqRespIdInit}`seq (pure id) (fun () => v) = v`.
-- The left hand side is equivalent to {anchorTerm mSeqRespIdInit}`pure id >>= fun g => (fun () => v) () >>= fun y => pure (g y)`.
-- The unit function in the middle can be eliminated immediately, yielding {anchorTerm mSeqRespIdInit}`pure id >>= fun g => v >>= fun y => pure (g y)`.
-- Using the fact that {anchorName mSeqRespIdInit}`pure` is a left identity of {anchorTerm mSeqRespIdInit}`>>=`, this is the same as {anchorTerm mSeqRespIdInit}`v >>= fun y => pure (id y)`, which is {anchorTerm mSeqRespIdInit}`v >>= fun y => pure y`.
-- Because {anchorTerm mSeqRespIdInit}`fun x => f x` is the same as {anchorName mSeqRespIdInit}`f`, this is the same as {anchorTerm mSeqRespIdInit}`v >>= pure`, and the fact that {anchorName mSeqRespIdInit}`pure` is a right identity of {anchorTerm mSeqRespIdInit}`>>=` can be used to get {anchorName mSeqRespIdInit}`v`.

为了检查此定义是否遵守恒等性，请检查 {anchorTerm mSeqRespIdInit}`seq (pure id) (fun () => v) = v`。
左侧等价于 {anchorTerm mSeqRespIdInit}`pure id >>= fun g => (fun () => v) () >>= fun y => pure (g y)`。
中间的 unit 函数可以立即消除，得到 {anchorTerm mSeqRespIdInit}`pure id >>= fun g => v >>= fun y => pure (g y)`。
利用 {anchorName mSeqRespIdInit}`pure` 是 {anchorTerm mSeqRespIdInit}`>>=` 的左单位元这一事实，这与 {anchorTerm mSeqRespIdInit}`v >>= fun y => pure (id y)` 相同，即 {anchorTerm mSeqRespIdInit}`v >>= fun y => pure y`。
因为 {anchorTerm mSeqRespIdInit}`fun x => f x` 与 {anchorName mSeqRespIdInit}`f` 相同，所以这与 {anchorTerm mSeqRespIdInit}`v >>= pure` 相同，并且 {anchorName mSeqRespIdInit}`pure` 是 {anchorTerm mSeqRespIdInit}`>>=` 的右单位元这一事实可以用于得到 {anchorName mSeqRespIdInit}`v`。

-- This kind of informal reasoning can be made easier to read with a bit of reformatting.
-- In the following chart, read “EXPR1 ={ REASON }= EXPR2” as “EXPR1 is the same as EXPR2 because REASON”:

这种非正式推理可以通过一些重新格式化来更容易阅读。
在下图中，将“EXPR1 ={ REASON }= EXPR2”理解为“EXPR1 与 EXPR2 相同，因为 REASON”：

```anchorEqSteps mSeqRespId
pure id >>= fun g => v >>= fun y => pure (g y)
={
/-- `pure` 是 `>>=` 的左单位元 -/
by simp [LawfulMonad.pure_bind]
}=
v >>= fun y => pure (id y)
={
/-- 减少 `id` 的使用 -/
}=
v >>= fun y => pure y
={
/-- `fun x => f x` 等同于 `f` -/
by
  have {α β } {f : α → β} : (fun x => f x) = (f) := rfl
  rfl
}=
v >>= pure
={
/-- `pure` 是 `>>=` 的右单位元 -/
by simp [LawfulMonad.bind_pure_comp]
}=
v
```

-- To check that it respects function composition, check that {anchorTerm ApplicativeLaws}`pure (· ∘ ·) <*> u <*> v <*> w = u <*> (v <*> w)`.
-- The first step is to replace {lit}`<*>` with this definition of {anchorName MonadSeqDesugar}`seq`.
-- After that, a (somewhat long) series of steps that use the identity and associativity rules from the {anchorName ApplicativeLaws}`Monad` contract is enough to get from one to the other:

为了检查它是否遵守函数组合，请检查 {anchorTerm ApplicativeLaws}`pure (· ∘ ·) <*> u <*> v <*> w = u <*> (v <*> w)`。
第一步是将 {lit}`<*>` 替换为 {anchorName MonadSeqDesugar}`seq` 的此定义。
之后，一系列（有点长）使用 {anchorName ApplicativeLaws}`Monad` 契约中的恒等和结合律的步骤足以从一个到另一个：

```anchorEqSteps mSeqRespComp
seq (seq (seq (pure (· ∘ ·)) (fun _ => u))
      (fun _ => v))
  (fun _ => w)
={
/-- 定义 `seq` -/
}=
((pure (· ∘ ·) >>= fun f =>
   u >>= fun x =>
   pure (f x)) >>= fun g =>
  v >>= fun y =>
  pure (g y)) >>= fun h =>
 w >>= fun z =>
 pure (h z)
={
/-- `pure` 是 `>>=` 的左单位元 -/
by simp only [LawfulMonad.pure_bind]
}=
((u >>= fun x =>
   pure (x ∘ ·)) >>= fun g =>
   v >>= fun y =>
  pure (g y)) >>= fun h =>
 w >>= fun z =>
 pure (h z)
={
/-- 为了清晰起见插入括号 -/
}=
((u >>= fun x =>
   pure (x ∘ ·)) >>= (fun g =>
   v >>= fun y =>
  pure (g y))) >>= fun h =>
 w >>= fun z =>
 pure (h z)
={
/-- `>>=` 的结合律 -/
by simp only [LawfulMonad.bind_assoc]
}=
(u >>= fun x =>
  pure (x ∘ ·) >>= fun g =>
 v  >>= fun y => pure (g y)) >>= fun h =>
 w >>= fun z =>
 pure (h z)
={
/-- `pure` 是 `>>=` 的左单位元 -/
by simp only [LawfulMonad.pure_bind]
}=
(u >>= fun x =>
  v >>= fun y =>
  pure (x ∘ y)) >>= fun h =>
 w >>= fun z =>
 pure (h z)
={
/-- `>>=` 的结合律 -/
by simp only [LawfulMonad.bind_assoc]
}=
u >>= fun x =>
v >>= fun y =>
pure (x ∘ y) >>= fun h =>
w >>= fun z =>
pure (h z)
={
/-- `pure` 是 `>>=` 的左单位元 -/
by simp [bind_pure_comp]; rfl
}=
u >>= fun x =>
v >>= fun y =>
w >>= fun z =>
pure ((x ∘ y) z)
={
/-- 函数组合的定义 -/
}=
u >>= fun x =>
v >>= fun y =>
w >>= fun z =>
pure (x (y z))
={
/-- 是时候开始向后移动了！`pure` 是 `>>=` 的左单位元 -/
by simp [LawfulMonad.pure_bind]
}=
u >>= fun x =>
v >>= fun y =>
w >>= fun z =>
pure (y z) >>= fun q =>
pure (x q)
={
/-- `>>=` 的结合律 -/
by simp [LawfulMonad.bind_assoc]
}=
u >>= fun x =>
v >>= fun y =>
 (w >>= fun p =>
  pure (y p)) >>= fun q =>
 pure (x q)
={
/-- `>>=` 的结合律 -/
by simp [LawfulMonad.bind_assoc]
}=
u >>= fun x =>
 (v >>= fun y =>
  w >>= fun q =>
  pure (y q)) >>= fun z =>
 pure (x z)
={
/-- 这包括 `seq` 的定义 -/
}=
seq u (fun () => seq v (fun () => w))
```

-- To check that sequencing pure operations is a no-op:

为了检查纯操作的序列化是否是空操作：

````anchorEqSteps mSeqPureNoOp
seq (pure f) (fun () => pure x)
={
/-- 使用其定义来替换 `seq` -/
}=
pure f >>= fun g =>
pure x >>= fun y =>
pure (g y)
={
/-- `pure` 是 `>>=` 的左单位元 -/
by simp [LawfulMonad.pure_bind]
}=
pure f >>= fun g =>
pure (g x)
={
/-- `pure` 是 `>>=` 的左单位元 -/
by simp [LawfulMonad.pure_bind]
}=
pure (f x)
````

-- And finally, to check that the ordering of pure operations doesn't matter:

最后，检查纯操作的顺序是否无关紧要：

```anchorEqSteps mSeqPureNoOrder
seq u (fun () => pure x)
={
/-- `seq` 的定义 -/
}=
u >>= fun f =>
pure x >>= fun y =>
pure (f y)
={
/-- `pure` 是 `>>=` 的左单位元 -/
by simp [LawfulMonad.pure_bind]
}=
u >>= fun f =>
pure (f x)
={
/-- 聪明地用一个等效的表达式替换一个表达式，使规则匹配 -/
}=
u >>= fun f =>
pure ((fun g => g x) f)
={
/-- `pure` 是 `>>=` 的左单位元 -/
by simp [LawfulMonad.pure_bind]
}=
pure (fun g => g x) >>= fun h =>
u >>= fun f =>
pure (h f)
={
/-- `seq` 的定义 -/
}=
seq (pure (fun f => f x)) (fun () => u)
```

-- This justifies a definition of {anchorName ApplicativeLaws}`Monad` that extends {anchorName ApplicativeLaws}`Applicative`, with a default definition of {anchorTerm MonadExtends}`seq`:

这证明了 {anchorName ApplicativeLaws}`Monad` 的定义扩展了 {anchorName ApplicativeLaws}`Applicative`，并带有 {anchorTerm MonadExtends}`seq` 的默认定义：

```anchor MonadExtends
class Monad (m : Type → Type) extends Applicative m where
  bind : m α → (α → m β) → m β
  seq f x :=
    bind f fun g =>
    bind (x ()) fun y =>
    pure (g y)
```

-- {anchorName MonadExtends}`Applicative`'s own default definition of {anchorTerm ApplicativeExtendsFunctorOne}`map` means that every {anchorName MonadExtends}`Monad` instance automatically generates {anchorName MonadExtends}`Applicative` and {anchorName ApplicativeExtendsFunctorOne}`Functor` instances as well.

{anchorName MonadExtends}`Applicative` 自己的 {anchorTerm ApplicativeExtendsFunctorOne}`map` 默认定义意味着每个 {anchorName MonadExtends}`Monad` 实例都会自动生成 {anchorName MonadExtends}`Applicative` 和 {anchorName ApplicativeExtendsFunctorOne}`Functor` 实例。

-- # Additional Stipulations

# 附加规定

-- In addition to adhering to the individual contracts associated with each type class, combined implementations {anchorName ApplicativeLaws}`Functor`, {anchorName ApplicativeLaws}`Applicative` and {anchorName ApplicativeLaws}`Monad` should work equivalently to these default implementations.
-- In other words, a type that provides both {anchorName ApplicativeLaws}`Applicative` and {anchorName ApplicativeLaws}`Monad` instances should not have an implementation of {anchorTerm MonadExtends}`seq` that works differently from the version that the {anchorName MonadSeq}`Monad` instance generates as a default implementation.
-- This is important because polymorphic functions may be refactored to replace a use of {lit}`>>=` with an equivalent use of {lit}`<*>`, or a use of {lit}`<*>` with an equivalent use of {lit}`>>=`.
-- This refactoring should not change the meaning of programs that use this code.

除了遵守与每个类型类相关的各个契约外，{anchorName ApplicativeLaws}`Functor`、{anchorName ApplicativeLaws}`Applicative` 和 {anchorName ApplicativeLaws}`Monad` 的组合实现应与这些默认实现等效。
换句话说，提供 {anchorName ApplicativeLaws}`Applicative` 和 {anchorName ApplicativeLaws}`Monad` 实例的类型不应具有与 {anchorName MonadSeq}`Monad` 实例作为默认实现生成的版本不同的 {anchorTerm MonadExtends}`seq` 实现。
这很重要，因为多态函数可能会被重构，以将 {lit}`>>=` 的使用替换为等效的 {lit}`<*>` 使用，或者将 {lit}`<*>` 的使用替换为等效的 {lit}`>>=` 使用。
这种重构不应改变使用此代码的程序的含义。

-- This rule explains why {anchorName ValidateAndThen}`Validate.andThen` should not be used to implement {anchorName MonadExtends}`bind` in a {anchorName ApplicativeLaws}`Monad` instance.
-- On its own, it obeys the monad contract.
-- However, when it is used to implement {anchorTerm MonadExtends}`seq`, the behavior is not equivalent to {anchorTerm MonadExtends}`seq` itself.
-- To see where they differ, take the example of two computations, both of which return errors.
-- Start with an example of a case where two errors should be returned, one from validating a function (which could have just as well resulted from a prior argument to the function), and one from validating an argument:

这条规则解释了为什么不应该在 {anchorName ApplicativeLaws}`Monad` 实例中使用 {anchorName ValidateAndThen}`Validate.andThen` 来实现 {anchorName MonadExtends}`bind`。
它本身遵守单子契约。
然而，当它用于实现 {anchorTerm MonadExtends}`seq` 时，其行为与 {anchorTerm MonadExtends}`seq` 本身不等效。
为了了解它们之间的区别，我们以两个计算为例，两者都返回错误。
从一个应该返回两个错误的情况开始，一个来自验证函数（这可能也来自函数的先前参数），另一个来自验证参数：

```anchor counterexample
def notFun : Validate String (Nat → String) :=
  .errors { head := "First error", tail := [] }

def notArg : Validate String Nat :=
  .errors { head := "Second error", tail := [] }
```

-- Combining them with the version of {lit}`<*>` from {anchorName Validate}`Validate`'s {anchorName ApplicativeValidate}`Applicative` instance results in both errors being reported to the user:

将它们与 {anchorName Validate}`Validate` 的 {anchorName ApplicativeValidate}`Applicative` 实例中的 {lit}`<*>` 版本结合，结果是两个错误都报告给用户：

```anchorEvalSteps realSeq
notFun <*> notArg
===>
match notFun with
| .ok g => g <$> notArg
| .errors errs =>
  match notArg with
  | .ok _ => .errors errs
  | .errors errs' => .errors (errs ++ errs')
===>
match notArg with
| .ok _ =>
  .errors { head := "First error", tail := [] }
| .errors errs' =>
  .errors ({ head := "First error", tail := [] } ++
   { head := "Second error", tail := []})
===>
.errors {
  head := "First error",
  tail := ["Second error"]
}
```

-- Using the version of {anchorName MonadSeqDesugar}`seq` that was implemented with {lit}`>>=`, here rewritten to {anchorName fakeSeq}`andThen`, results in only the first error being available:

使用 {anchorName MonadSeqDesugar}`seq` 的版本，该版本使用 {lit}`>>=` 实现，此处重写为 {anchorName fakeSeq}`andThen`，结果只有第一个错误可用：

```anchorEvalSteps fakeSeq
seq notFun (fun () => notArg)
===>
notFun.andThen fun g =>
notArg.andThen fun y =>
pure (g y)
===>
match notFun with
| .errors errs => .errors errs
| .ok val =>
  (fun g =>
    notArg.andThen fun y =>
    pure (g y)) val
===>
.errors { head := "First error", tail := [] }
```
