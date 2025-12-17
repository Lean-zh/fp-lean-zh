import VersoManual
import FPLeanZh.Examples

open Verso.Genre Manual
open Verso.Code.External

open FPLeanZh

set_option verso.exampleProject "../examples"
set_option verso.exampleModule "Examples.MonadTransformers.Defs"

#doc (Manual) "单子构建工具包" =>
%%%
file := "Transformers"
tag := "construction-kit"
%%%

-- A Monad Construction Kit

-- {anchorName m}`ReaderT` is far from the only useful monad transformer.
-- This section describes a number of additional transformers.
-- Each monad transformer consists of the following:
--  1. A definition or datatype {anchorName general}`T` that takes a monad as an argument.
--     It should have a type like {anchorTerm general}`(Type u → Type v) → Type u → Type v`, though it may accept additional arguments prior to the monad.
--  2. A {anchorName general}`Monad` instance for {anchorTerm general}`T m` that relies on an instance of {anchorTerm general}`Monad m`. This enables the transformed monad to be used as a monad.
--  3. A {anchorName general}`MonadLift` instance that translates actions of type {anchorTerm general}`m α` into actions of type {anchorTerm general}`T m α`, for arbitrary monads {anchorName general}`m`. This enables actions from the underlying monad to be used in the transformed monad.

{anchorName m}`ReaderT` 并不是唯一有用的单子转换器。
本节将介绍一些额外的转换器。
每个单子转换器都由以下部分组成：
 1. 一个以单子为参数定义或数据类型 {anchorName general}`T`。
    它的类型应类似于 {anchorTerm general}`(Type u → Type v) → Type u → Type v`，尽管它可以接受单子之前的其他参数。
 2. {anchorTerm general}`T m` 的 {anchorName general}`Monad` 实例依赖于 {anchorTerm general}`Monad m` 实例。这使得转换后的单子也可以作为单子使用。
 3. 一个 {anchorName general}`MonadLift` 实例，可将任意单子 {anchorName general}`m` 的 {anchorTerm general}`m α` 类型的操作转换为 {anchorTerm general}`T m α` 类型的操作。这使得底层单子中的操作可以在转换后的单子中使用。

-- Furthermore, the {anchorName general}`Monad` instance for the transformer should obey the contract for {anchorName general}`Monad`, at least if the underlying {anchorName general}`Monad` instance does.
-- In addition, {anchorTerm general}`monadLift (pure x : m α)` should be equivalent to {anchorTerm general}`pure x` in the transformed monad, and {anchorName general}`monadLift` should distribute over {anchorName MonadStateT}`bind` so that {anchorTerm general}`monadLift (x >>= f : m α)` is the same as {anchorTerm general}`(monadLift x : m α) >>= fun y => monadLift (f y)`.

此外，转换器的 {anchorName general}`Monad` 实例也应该遵守 {anchorName general}`Monad` 的约定，至少在底层的 {anchorName general}`Monad` 实例遵守的情况下。
另外，{anchorTerm general}`monadLift (pure x : m α)` 应该等价于转换后的单子中的 {anchorTerm general}`pure x` ，而且 {anchorName general}`monadLift` 应对于 {anchorName MonadStateT}`bind` 可分配，这样 {anchorTerm general}`monadLift (x >>= f : m α)` 就等同于 {anchorTerm general}`(monadLift x : m α) >>= fun y => monadLift (f y)` 。

-- Many monad transformers additionally define type classes in the style of {anchorName m}`MonadReader` that describe the actual effects available in the monad.
-- This can provide more flexibility: it allows programs to be written that rely only on an interface, and don't constrain the underlying monad to be implemented by a given transformer.
-- The type classes are a way for programs to express their requirements, and monad transformers are a convenient way to meet these requirements.

许多单子转换器还定义了 {anchorName m}`MonadReader` 风格的类型类，用于描述单子中可用的实际作用。
这可以提供更大的灵活性：它允许编写只依赖接口的程序，而不限制底层单子必须由给定的转换器实现。
类型类是程序表达其需求的一种方式，而单子转换器则是满足这些需求的一种便捷方式。

-- # Failure with {lit}`OptionT`
# 使用 {lit}`OptionT` 失败
%%%
tag := "OptionT"
%%%

-- Failure, represented by the {anchorName OptionExcept}`Option` monad, and exceptions, represented by the {anchorName M1eval}`Except` monad, both have corresponding transformers.
-- In the case of {anchorName OptionTdef}`Option`, failure can be added to a monad by having it contain values of type {anchorTerm OptionTdef}`Option α` where it would otherwise contain values of type {anchorName OptionTdef}`α`.
-- For example, {anchorTerm m}`IO (Option α)` represents {anchorName m}`IO` actions that don't always return a value of type {anchorName m}`α`.
-- This suggests the definition of the monad transformer {anchorName OptionTdef}`OptionT`:

由 {anchorName OptionExcept}`Option` 单子表示的失败和由 {anchorName M1eval}`Except` 单子表示的异常都有相应的转换器。
对于 {anchorName OptionTdef}`Option` 单子，可以通过让单子包含 {anchorTerm OptionTdef}`Option α` 类型的值来为单子添加失败，否则单子将包含 {anchorName OptionTdef}`α` 类型的值。
例如，{anchorTerm m}`IO (Option α)` 表示并不总是返回 {anchorName m}`α` 类型值的 {anchorName m}`IO` 操作。
这就需要定义单子转换器 {anchorName OptionTdef}`OptionT`：

```anchor OptionTdef
def OptionT (m : Type u → Type v) (α : Type u) : Type v :=
  m (Option α)
```

-- As an example of {anchorName OptionTdef}`OptionT` in action, consider a program that asks the user questions.
-- The function {anchorName getSomeInput}`getSomeInput` asks for a line of input and removes whitespace from both ends.
-- If the resulting trimmed input is non-empty, then it is returned, but the function fails if there are no non-whitespace characters:

我们以一个向用户提问的程序为例来说明 {anchorName OptionTdef}`OptionT` 的作用。
函数 {anchorName getSomeInput}`getSomeInput` 要求输入一行内容，并删除两端的空白。
如果修剪后的输入是非空的，就会返回，但如果没有非空格字符，函数就会失败：

```anchor getSomeInput
def getSomeInput : OptionT IO String := do
  let input ← (← IO.getStdin).getLine
  let trimmed := input.trim
  if trimmed == "" then
    failure
  else pure trimmed
```
-- This particular application tracks users with their name and their favorite species of beetle:

这个应用软件可以追踪用户的姓名和他们最喜欢的甲虫种类：

```anchor UserInfo
structure UserInfo where
  name : String
  favoriteBeetle : String
```
-- Asking the user for input is no more verbose than a function that uses only {anchorName m}`IO` would be:

询问用户输入并不比只使用 {anchorName m}`IO` 的函数更冗长：

```anchor getUserInfo
def getUserInfo : OptionT IO UserInfo := do
  IO.println "What is your name?"
  let name ← getSomeInput
  IO.println "What is your favorite species of beetle?"
  let beetle ← getSomeInput
  pure ⟨name, beetle⟩
```
-- However, because the function runs in an {anchorTerm getSomeInput}`OptionT IO` context rather than just in {anchorName m}`IO`, failure in the first call to {anchorName getSomeInput}`getSomeInput` causes the whole {anchorName getUserInfo}`getUserInfo` to fail, with control never reaching the question about beetles.
-- The main function, {anchorName interact}`interact`, invokes {anchorName interact}`getUserInfo` in a purely {anchorName m}`IO` context, which allows it to check whether the call succeeded or failed by matching on the inner {anchorName m}`Option`:

然而，由于函数是在 {anchorTerm getSomeInput}`OptionT IO` 上下文中运行的，而不仅仅是在 {anchorName m}`IO` 中，因此第一次调用 {anchorName getSomeInput}`getSomeInput` 失败会导致整个 {anchorName getUserInfo}`getUserInfo` 失败，控制权永远不会到达关于甲虫的问题。
主函数 {anchorName interact}`interact` 在纯的 {anchorName m}`IO` 上下文中调用 {anchorName interact}`getUserInfo`，这样就可以通过匹配内部的 {anchorName m}`Option` 来检查调用成功还是失败：

```anchor interact
def interact : IO Unit := do
  match ← getUserInfo with
  | none =>
    IO.eprintln "Missing info"
  | some ⟨name, beetle⟩ =>
    IO.println s!"Hello {name}, whose favorite beetle is {beetle}."
```

-- ## The Monad Instance
## 单子实例
%%%
tag := "OptionT-monad-instance"
%%%

-- Writing the monad instance reveals a difficulty.
-- Based on the types, {anchorName MonadExceptT}`pure` should use {anchorName MonadMissingUni}`pure` from the underlying monad {anchorName firstMonadOptionT}`m` together with {anchorName firstMonadOptionT}`some`.
-- Just as {anchorName firstMonadOptionT}`bind` for {anchorName m}`Option` branches on the first argument, propagating {anchorName firstMonadOptionT}`none`, {anchorName firstMonadOptionT}`bind` for {anchorName firstMonadOptionT}`OptionT` should run the monadic action that makes up the first argument, branch on the result, and then propagate {anchorName firstMonadOptionT}`none`.
-- Following this sketch yields the following definition, which Lean does not accept:

在编写单子实例发现了一个难题。
根据类型，{anchorName MonadExceptT}`pure` 应该使用底层单子 {anchorName firstMonadOptionT}`m` 中的 {anchorName MonadMissingUni}`pure` 和 {anchorName firstMonadOptionT}`some`。
正如 {anchorName m}`Option` 的 {anchorName firstMonadOptionT}`bind` 在第一个参数上分支，然后传播 {anchorName firstMonadOptionT}`none`，{anchorName firstMonadOptionT}`OptionT` 的 {anchorName firstMonadOptionT}`bind` 应该运行构成第一个参数的单子操作，在结果上分支，然后传播 {anchorName firstMonadOptionT}`none`。
按照这个框架可以得到 Lean 不接受的如下定义：

```anchor firstMonadOptionT
instance [Monad m] : Monad (OptionT m) where
  pure x := pure (some x)
  bind action next := do
    match (← action) with
    | none => pure none
    | some v => next v
```
-- The error message shows a cryptic type mismatch:

错误信息显示了一个隐含的类型不匹配：

```anchorError firstMonadOptionT
Application type mismatch: The argument
  some x
has type
  Option α✝
but is expected to have type
  α✝
in the application
  pure (some x)
```
-- The problem here is that Lean is selecting the wrong {anchorName firstMonadOptionT}`Monad` instance for the surrounding use of {anchorName firstMonadOptionT}`pure`.
-- Similar errors occur for the definition of {anchorName firstMonadOptionT}`bind`.
-- One solution is to use type annotations to guide Lean to the correct {anchorName MonadOptionTAnnots}`Monad` instance:

这里的问题是 Lean 为周围的 {anchorName firstMonadOptionT}`pure` 使用选择了错误的 {anchorName firstMonadOptionT}`Monad` 实例。
类似的错误也发生在 {anchorName firstMonadOptionT}`bind` 的定义中。
一种解决方案是使用类型标注来引导 Lean 选择正确的 {anchorName MonadOptionTAnnots}`Monad` 实例：

```anchor MonadOptionTAnnots
instance [Monad m] : Monad (OptionT m) where
  pure x := (pure (some x) : m (Option _))
  bind action next := (do
    match (← action) with
    | none => pure none
    | some v => next v : m (Option _))
```
-- While this solution works, it is inelegant and the code becomes a bit noisy.

虽然这种解决方案可行，但它不够优雅，代码也变得有点啰嗦。

-- An alternative solution is to define functions whose type signatures guide Lean to the correct instances.
-- In fact, {anchorName OptionTStructure}`OptionT` could have been defined as a structure:

另一种解决方案是定义函数，由函数的类型签名引导 Lean 找到正确的实例。
事实上，{anchorName OptionTStructure}`OptionT` 自身可以定义为一个结构：

```anchor OptionTStructure
structure OptionT (m : Type u → Type v) (α : Type u) : Type v where
  run : m (Option α)
```
-- This would solve the problem, because the constructor {anchorName OptionTStructuredefs}`OptionT.mk` and the field accessor {anchorName OptionTStructuredefs}`OptionT.run` would guide type class inference to the correct instances.
-- The downside to doing this is that the resulting code is more complicated, and these structures can make it more difficult to read proofs.
-- The best of both worlds can be achieved by defining functions that serve the same role as the constructor {anchorName OptionTStructuredefs}`OptionT.mk` and the field {anchorName OptionTStructuredefs}`OptionT.run`, but that work with the direct definition:

这可以解决这个问题，因为构造函数 {anchorName OptionTStructuredefs}`OptionT.mk` 和字段访问函数 {anchorName OptionTStructuredefs}`OptionT.run` 将引导类型类推理到正确的实例。
但这样做的缺点是，生成的代码会更复杂，而且这些结构会使阅读证明更加困难。
我们可以通过定义与构造函数 {anchorName OptionTStructuredefs}`OptionT.mk` 和字段 {anchorName OptionTStructuredefs}`OptionT.run` 具有相同作用的函数来实现两全其美的效果，但这些函数要与直接定义一起使用：

```anchor FakeStructOptionT
def OptionT.mk (x : m (Option α)) : OptionT m α := x

def OptionT.run (x : OptionT m α) : m (Option α) := x
```
-- Both functions return their inputs unchanged, but they indicate the boundary between code that is intended to present the interface of {anchorName FakeStructOptionT}`OptionT` and code that is intended to present the interface of the underlying monad {anchorName FakeStructOptionT}`m`.
-- Using these helpers, the {anchorName MonadOptionTFakeStruct}`Monad` instance becomes more readable:

这两个函数直接返回的其原输入，但它们指明了旨在呈现 {anchorName FakeStructOptionT}`OptionT` 接口的代码与旨在呈现底层单子 {anchorName FakeStructOptionT}`m` 接口的代码之间的边界。
使用这些辅助函数，{anchorName MonadOptionTFakeStruct}`Monad` 实例变得更加可读：

```anchor MonadOptionTFakeStruct
instance [Monad m] : Monad (OptionT m) where
  pure x := OptionT.mk (pure (some x))
  bind action next := OptionT.mk do
    match ← action with
    | none => pure none
    | some v => next v
```
-- Here, the use of {anchorName FakeStructOptionT}`OptionT.mk` indicates that its arguments should be considered as code that uses the interface of {anchorName MonadOptionTFakeStruct}`m`, which allows Lean to select the correct {anchorName MonadOptionTFakeStruct}`Monad` instances.

在这里，使用 {anchorName FakeStructOptionT}`OptionT.mk` 表示其参数应被视为使用 {anchorName MonadOptionTFakeStruct}`m` 接口的代码，它允许 Lean 选择正确的 {anchorName MonadOptionTFakeStruct}`Monad` 实例。

-- After defining the monad instance, it's a good idea to check that the monad contract is satisfied.
-- The first step is to show that {anchorTerm OptionTFirstLaw}`bind (pure v) f` is the same as {anchorTerm OptionTFirstLaw}`f v`.
-- Here's the steps:

定义完单子实例后，最好检查一下单子约定是否满足。
第一步是证明 {anchorTerm OptionTFirstLaw}`bind (pure v) f` 与 {anchorTerm OptionTFirstLaw}`f v` 相同。
步骤如下：

```anchorEqSteps OptionTFirstLaw
bind (pure v) f
={ /-- Unfolding the definitions of `bind` and `pure` -/
   by simp [bind, pure, OptionT.mk]
}=
OptionT.mk do
  match ← pure (some v) with
  | none => pure none
  | some x => f x
={
/-- Desugaring nested action syntax -/
}=
OptionT.mk do
  let y ← pure (some v)
  match y with
  | none => pure none
  | some x => f x
={
/-- Desugaring `do`-notation -/
}=
OptionT.mk
  (pure (some v) >>= fun y =>
    match y with
    | none => pure none
    | some x => f x)
={
  /-- Using the first monad rule for `m` -/
  by simp [LawfulMonad.pure_bind (m := m)]
}=
OptionT.mk
  (match some v with
   | none => pure none
   | some x => f x)
={
/-- Reduce `match` -/
}=
OptionT.mk (f v)
={
/-- Definition of `OptionT.mk` -/
}=
f v
```

-- The second rule states that {anchorTerm OptionTSecondLaw}`bind w pure` is the same as {anchorName OptionTSecondLaw}`w`.
-- To demonstrate this, unfold the definitions of {anchorName OptionTSecondLaw}`bind` and {anchorName OptionTSecondLaw}`pure`, yielding:

第二条规则指出，{anchorTerm OptionTSecondLaw}`bind w pure` 与 {anchorName OptionTSecondLaw}`w` 相同。
为了证明这一点，展开 {anchorName OptionTSecondLaw}`bind` 和 {anchorName OptionTSecondLaw}`pure` 的定义，得出：

```anchorTerm OptionTSecondLaw
OptionT.mk do
    match ← w with
    | none => pure none
    | some v => pure (some v)
```
-- In this pattern match, the result of both cases is the same as the pattern being matched, just with {anchorName OptionTSecondLaw}`pure` around it.
-- In other words, it is equivalent to {anchorTerm OptionTSecondLaw}`w >>= fun y => pure y`, which is an instance of {anchorName OptionTFirstLaw}`m`'s second monad rule.

在这个模式匹配中，两种情况的结果都与被匹配的模式相同，只是在其周围加上了 {anchorName OptionTSecondLaw}`pure`。
换句话说，它等同于 {anchorTerm OptionTSecondLaw}`w >>= fun y => pure y`，这是 {anchorName OptionTFirstLaw}`m` 的第二个单子规则的一个实例。

-- The final rule states that {anchorTerm OptionTThirdLaw}`bind (bind v f) g`  is the same as {anchorTerm OptionTThirdLaw}`bind v (fun x => bind (f x) g)`.
-- It can be checked in the same way, by expanding the definitions of {anchorName OptionTThirdLaw}`bind` and {anchorName OptionTSecondLaw}`pure` and then delegating to the underlying monad {anchorName OptionTFirstLaw}`m`.

最后一条规则指出 {anchorTerm OptionTThirdLaw}`bind (bind v f) g` 与 {anchorTerm OptionTThirdLaw}`bind v (fun x => bind (f x) g)` 相同。
通过扩展 {anchorName OptionTThirdLaw}`bind` 和 {anchorName OptionTSecondLaw}`pure` 的定义，然后将其委托给底层单子 {anchorName OptionTFirstLaw}`m`，可以用同样的方法对其进行检查。

-- ## An {lit}`Alternative` Instance
## 一个 {lit}`Alternative` 实例
%%%
tag := "OptionT-Alternative-instance"
%%%

-- One convenient way to use {anchorName OptionTdef}`OptionT` is through the {anchorName AlternativeOptionT}`Alternative` type class.
-- Successful return is already indicated by {anchorName AlternativeOptionT}`pure`, and the {anchorName AlternativeOptionT}`failure` and {anchorName AlternativeOptionT}`orElse` methods of {anchorName AlternativeOptionT}`Alternative` provide a way to write a program that returns the first successful result from a number of subprograms:

一种使用 {anchorName OptionTdef}`OptionT` 的便捷方法是通过 {anchorName AlternativeOptionT}`Alternative` 类型类。
成功返回已经由 {anchorName AlternativeOptionT}`pure` 表示，而 {anchorName AlternativeOptionT}`Alternative` 的 {anchorName AlternativeOptionT}`failure` 和 {anchorName AlternativeOptionT}`orElse` 方法提供了一种编写程序的方式，可以从多个子程序中返回第一个成功的结果：

```anchor AlternativeOptionT
instance [Monad m] : Alternative (OptionT m) where
  failure := OptionT.mk (pure none)
  orElse x y := OptionT.mk do
    match ← x with
    | some result => pure (some result)
    | none => y ()
```

-- ## Lifting
## 提升
%%%
tag := "OptionT-lifting"
%%%

-- Lifting an action from {anchorName LiftOptionT}`m` to {anchorTerm LiftOptionT}`OptionT m` only requires wrapping {anchorName LiftOptionT}`some` around the result of the computation:

将一个操作从 {anchorName LiftOptionT}`m` 移植到 {anchorTerm LiftOptionT}`OptionT m` 只需要用 {anchorName LiftOptionT}`some` 包装计算结果：

```anchor LiftOptionT
instance [Monad m] : MonadLift m (OptionT m) where
  monadLift action := OptionT.mk do
    pure (some (← action))
```

-- # Exceptions
# 异常
%%%
tag := "exceptions"
%%%

-- The monad transformer version of {anchorName ExceptT}`Except` is very similar to the monad transformer version of {anchorName m}`Option`.
-- Adding exceptions of type {anchorName ExceptT}`ε` to some monadic action of type {anchorTerm ExceptT}`m`{lit}` `{anchorTerm ExceptT}`α` can be accomplished by adding exceptions to {anchorName MonadExcept}`α`, yielding type {anchorTerm ExceptT}`m (Except ε α)`:

单子转换器版本的 {anchorName ExceptT}`Except` 与单子转换器版本的 {anchorName m}`Option` 非常相似。
向 {anchorTerm ExceptT}`m`{lit}` `{anchorTerm ExceptT}`α` 类型的单子动作添加 {anchorName ExceptT}`ε` 类型的异常，可以通过向 {anchorName MonadExcept}`α` 添加异常来实现，从而产生 {anchorTerm ExceptT}`m (Except ε α)`：

```anchor ExceptT
def ExceptT (ε : Type u) (m : Type u → Type v) (α : Type u) : Type v :=
  m (Except ε α)
```
-- {anchorName OptionTdef}`OptionT` provides {anchorName FakeStructOptionT}`OptionT.mk` and {anchorName FakeStructOptionT}`OptionT.run` functions to guide the type checker towards the correct {anchorName MonadOptionTFakeStruct}`Monad` instances.
-- This trick is also useful for {anchorName ExceptTFakeStruct}`ExceptT`:

{anchorName OptionTdef}`OptionT` 提供了 {anchorName FakeStructOptionT}`OptionT.mk` 和 {anchorName FakeStructOptionT}`OptionT.run` 函数来引导类型检查器找到正确的 {anchorName MonadOptionTFakeStruct}`Monad` 实例。
这个技巧对 {anchorName ExceptTFakeStruct}`ExceptT` 也很有用：

```anchor ExceptTFakeStruct
  def ExceptT.mk {ε α : Type u} (x : m (Except ε α)) : ExceptT ε m α := x

  def ExceptT.run {ε α : Type u} (x : ExceptT ε m α) : m (Except ε α) := x
```
-- The {anchorName MonadExceptT}`Monad` instance for {anchorName MonadExceptT}`ExceptT` is also very similar to the instance for {anchorName MonadOptionTFakeStruct}`OptionT`.
-- The only difference is that it propagates a specific error value, rather than {anchorName MonadOptionTFakeStruct}`none`:

用于 {anchorName MonadExceptT}`ExceptT` 的 {anchorName MonadExceptT}`Monad` 实例与用于 {anchorName MonadOptionTFakeStruct}`OptionT` 的实例也非常相似。
唯一不同的是，它传播的是一个特定的错误值，而不是 {anchorName MonadOptionTFakeStruct}`none`：

```anchor MonadExceptT
instance {ε : Type u} {m : Type u → Type v} [Monad m] :
    Monad (ExceptT ε m) where
  pure x := ExceptT.mk (pure (Except.ok x))
  bind result next := ExceptT.mk do
    match ← result with
    | .error e => pure (.error e)
    | .ok x => next x
```

-- The type signatures of {anchorName ExceptTFakeStruct}`ExceptT.mk` and {anchorName ExceptTFakeStruct}`ExceptT.run` contain a subtle detail: they annotate the universe levels of {anchorName ExceptTFakeStruct}`α` and {anchorName ExceptTFakeStruct}`ε` explicitly.
-- If they are not explicitly annotated, then Lean generates a more general type signature in which they have distinct polymorphic universe variables.
-- However, the definition of {anchorName ExceptTFakeStruct}`ExceptT` expects them to be in the same universe, because they can both be provided as arguments to {anchorName ExceptTFakeStruct}`m`.
-- This can lead to a problem in the {anchorName MonadStateT}`Monad` instance where the universe level solver fails to find a working solution:

{anchorName ExceptTFakeStruct}`ExceptT.mk` 和 {anchorName ExceptTFakeStruct}`ExceptT.run` 的类型签名包含一个微妙的细节：它们明确地注释了 {anchorName ExceptTFakeStruct}`α` 和 {anchorName ExceptTFakeStruct}`ε` 的宇宙层级。
如果它们没有被明确注释，那么 Lean 会生成一个更通用的类型签名，其中它们拥有不同的多态宇宙变量。
然而， {anchorName ExceptTFakeStruct}`ExceptT` 的定义希望它们在同一个宇宙中，因为它们都可以作为参数提供给 {anchorName ExceptTFakeStruct}`m`。
这会导致 {anchorName MonadStateT}`Monad` 实例出现问题，即宇宙层级求解器无法找到有效的解决方案：

```anchor ExceptTNoUnis
def ExceptT.mk (x : m (Except ε α)) : ExceptT ε m α := x
```
```anchor MonadMissingUni
instance {ε : Type u} {m : Type u → Type v} [Monad m] :
    Monad (ExceptT ε m) where
  pure x := ExceptT.mk (pure (Except.ok x))
  bind result next := ExceptT.mk do
    match (← result) with
    | .error e => pure (.error e)
    | .ok x => next x
```
```anchorError MonadMissingUni
stuck at solving universe constraint
  max ?u.10439 ?u.10440 =?= u
while trying to unify
  ExceptT ε m β✝ : Type v
with
  ExceptT.{max ?u.10440 ?u.10439, v} ε m β✝ : Type v
```
-- This kind of error message is typically caused by underconstrained universe variables.
-- Diagnosing it can be tricky, but a good first step is to look for reused universe variables in some definitions that are not reused in others.

这种错误信息通常是由欠约束的宇宙变量引起的。
诊断起来可能很棘手，但第一步可以查找某些定义中重复使用的宇宙变量，而其他定义中没有重复使用的宇宙变量。

-- Unlike {anchorName m}`Option`, the {anchorName m}`Except` datatype is typically not used as a data structure.
-- It is always used as a control structure with its {anchorName MonadExceptT}`Monad` instance.
-- This means that it is reasonable to lift {anchorTerm ExceptTLiftExcept}`Except ε` actions into {anchorTerm ExceptTLiftExcept}`ExceptT ε m`, as well as actions from the underlying monad {anchorName ExceptTLiftExcept}`m`.
-- Lifting {anchorName ExceptTLiftExcept}`Except` actions into {anchorName ExceptTLiftExcept}`ExceptT` actions is done by wrapping them in {anchorName ExceptTLiftExcept}`m`'s {anchorName ExceptTLiftExcept}`pure`, because an action that only has exception effects cannot have any effects from the monad {anchorName ExceptTLiftExcept}`m`:

与 {anchorName m}`Option` 不同，{anchorName m}`Except` 数据类型通常不作为数据结构使用。
它总是作为控制结构与其 {anchorName MonadExceptT}`Monad` 实例一起使用。
这意味着将 {anchorTerm ExceptTLiftExcept}`Except ε` 操作提升到 {anchorTerm ExceptTLiftExcept}`ExceptT ε m` 以及对底层单子 {anchorName ExceptTLiftExcept}`m` 的操作都是合理的。
通过用 {anchorName ExceptTLiftExcept}`m` 的 {anchorName ExceptTLiftExcept}`pure` 对 {anchorName ExceptTLiftExcept}`Except` 操作进行包装，可以将其提升为 {anchorName ExceptTLiftExcept}`ExceptT` 操作，因为一个只有异常作用的动作不可能有来自单子 {anchorName ExceptTLiftExcept}`m` 的任何作用：

```anchor ExceptTLiftExcept
instance [Monad m] : MonadLift (Except ε) (ExceptT ε m) where
  monadLift action := ExceptT.mk (pure action)
```
-- Because actions from {anchorName ExceptTLiftExcept}`m` do not have any exceptions in them, their value should be wrapped in {anchorName MonadExceptT}`Except.ok`.
-- This can be accomplished using the fact that {anchorName various}`Functor` is a superclass of {anchorName various}`Monad`, so applying a function to the result of any monadic computation can be accomplished using {anchorName various}`Functor.map`:

由于 {anchorName ExceptTLiftExcept}`m` 中的操作不包含任何异常，因此它们的值应该用 {anchorName MonadExceptT}`Except.ok` 封装。
这可以利用 {anchorName various}`Functor` 是 {anchorName various}`Monad` 的超类这一事实来实现，因此可以使用 {anchorName various}`Functor.map`，将函数应用于任何单子计算的结果：

```anchor ExceptTLiftM
instance [Monad m] : MonadLift m (ExceptT ε m) where
  monadLift action := ExceptT.mk (.ok <$> action)
```

-- ## Type Classes for Exceptions
## 异常的类型类
%%%
tag := "exceptions-type-classes"
%%%

-- Exception handling fundamentally consists of two operations: the ability to throw exceptions, and the ability to recover from them.
-- Thus far, this has been accomplished using the constructors of {anchorName m}`Except` and pattern matching, respectively.
-- However, this ties a program that uses exceptions to one specific encoding of the exception handling effect.
-- Using a type class to capture these operations allows a program that uses exceptions to be used in _any_ monad that supports throwing and catching.

异常处理从根本上说包括两种操作：抛出异常的能力和恢复异常的能力。
到目前为止，我们分别使用 {anchorName m}`Except` 的构造函数和模式匹配来实现这一点。
然而，这将使用异常的程序与异常处理作用的特定编码联系在一起。
使用类型类来捕获这些操作，可以让使用异常的程序在 _任何_ 支持抛出和捕获的单子中使用。

-- Throwing an exception should take an exception as an argument, and it should be allowed in any context where a monadic action is requested.
-- The “any context” part of the specification can be written as a type by writing {anchorTerm MonadExcept}`m α`—because there's no way to produce a value of any arbitrary type, the {anchorName MonadExcept}`throw` operation must be doing something that causes control to leave that part of the program.
-- Catching an exception should accept any monadic action together with a handler, and the handler should explain how to get back to the action's type from an exception:

抛出异常应该以异常作为参数，而且应该允许在任何要求执行单子动作的上下文中抛出异常。
规范中 “任何上下文” 的部分可以写成一种类型，即 {anchorTerm MonadExcept}`m α` ——— 因为没有办法产生任意类型的值，所以 {anchorName MonadExcept}`throw` 操作必须能使控制权离开程序的这一部分。
捕获异常应该接受任何单子操作和处理程序，处理程序应该解释如何从异常返回到操作的类型：

```anchor MonadExcept
class MonadExcept (ε : outParam (Type u)) (m : Type v → Type w) where
  throw : ε → m α
  tryCatch : m α → (ε → m α) → m α
```

-- The universe levels on {anchorName MonadExcept}`MonadExcept` differ from those of {anchorName ExceptT}`ExceptT`.
-- In {anchorName ExceptT}`ExceptT`, both {anchorName ExceptT}`ε` and {anchorName ExceptT}`α` have the same level, while {anchorName MonadExcept}`MonadExcept` imposes no such limitation.
-- This is because {anchorName MonadExcept}`MonadExcept` never places an exception value inside of {anchorName MonadExcept}`m`.
-- The most general universe signature recognizes the fact that {anchorName MonadExcept}`ε` and {anchorName MonadExcept}`α` are completely independent in this definition.
-- Being more general means that the type class can be instantiated for a wider variety of types.

{anchorName MonadExcept}`MonadExcept` 的宇宙层级与 {anchorName ExceptT}`ExceptT` 不同。
在 {anchorName ExceptT}`ExceptT` 中，{anchorName ExceptT}`ε` 和 {anchorName ExceptT}`α` 具有相同的层级，而 {anchorName MonadExcept}`MonadExcept` 则没有这种限制。
这是因为 {anchorName MonadExcept}`MonadExcept` 从不将异常值置于 {anchorName MonadExcept}`m` 内。
在这个定义中，最通用的宇宙签名承认 {anchorName MonadExcept}`ε` 和 {anchorName MonadExcept}`α` 是完全独立的。
更通用意味着类型类可以为更多类型实例化。

-- An example program that uses {anchorName MonadExcept}`MonadExcept` is a simple division service.
-- The program is divided into two parts: a frontend that supplies a user interface based on strings that handles errors, and a backend that actually does the division.
-- Both the frontend and the backend can throw exceptions, the former for ill-formed input and the latter for division by zero errors.
-- The exceptions are an inductive type:

下面是一个简单的除法服务，作为使用 {anchorName MonadExcept}`MonadExcept` 的一个示例程序。
程序分为两部分：前端提供基于字符串的用户界面，用于处理错误；后端实际执行除法操作。
前后端都可以抛出异常，前者用于处理格式错误的输入，后者用于处理除数为零的错误。
定义异常为一种归纳类型：

```anchor ErrEx
inductive Err where
  | divByZero
  | notANumber : String → Err
```
-- The backend checks for zero, and divides if it can:

后端检查是否为零，如果为零，则进行除法：

```anchor divBackend
def divBackend [Monad m] [MonadExcept Err m] (n k : Int) : m Int :=
  if k == 0 then
    throw .divByZero
  else pure (n / k)
```
-- The frontend's helper {anchorName asNumber}`asNumber` throws an exception if the string it is passed is not a number.
-- The overall frontend converts its inputs to {anchorName asNumber}`Int`s and calls the backend, handling exceptions by returning a friendly string error:

如果传入的字符串不是数字，前端的辅助函数 {anchorName asNumber}`asNumber` 会抛出异常。
整个前端会将输入转换为 {anchorName asNumber}`Int` 并调用后端，通过返回友好的错误字符串来处理异常：

```anchor asNumber
def asNumber [Monad m] [MonadExcept Err m] (s : String) : m Int :=
  match s.toInt? with
  | none => throw (.notANumber s)
  | some i => pure i
```

```anchor divFrontend
def divFrontend [Monad m] [MonadExcept Err m] (n k : String) : m String :=
  tryCatch (do pure (toString (← divBackend (← asNumber n) (← asNumber k))))
    fun
      | .divByZero => pure "Division by zero!"
      | .notANumber s => pure s!"Not a number: \"{s}\""
```
-- Throwing and catching exceptions is common enough that Lean provides a special syntax for using {anchorName divFrontendSugary}`MonadExcept`.
-- Just as {lit}`+` is short for {anchorName various}`HAdd.hAdd`, {kw}`try` and {kw}`catch` can be used as shorthand for the {anchorName MonadExcept}`tryCatch` method:

抛出和捕获异常非常常见，因此 Lean 提供了使用 {anchorName divFrontendSugary}`MonadExcept` 的特殊语法。
正如 {lit}`+` 是 {anchorName various}`HAdd.hAdd` 的缩写，{kw}`try` 和 {kw}`catch` 可以作为 {anchorName MonadExcept}`tryCatch` 方法的缩写：

```anchor divFrontendSugary
def divFrontend [Monad m] [MonadExcept Err m] (n k : String) : m String :=
  try
    pure (toString (← divBackend (← asNumber n) (← asNumber k)))
  catch
    | .divByZero => pure "Division by zero!"
    | .notANumber s => pure s!"Not a number: \"{s}\""
```

-- In addition to {anchorName m}`Except` and {anchorName ExceptT}`ExceptT`, there are useful {anchorName MonadExcept}`MonadExcept` instances for other types that may not seem like exceptions at first glance.
-- For example, failure due to {anchorName m}`Option` can be seen as throwing an exception that contains no data whatsoever, so there is an instance of {anchorTerm OptionExcept}`MonadExcept Unit Option` that allows {kw}`try`{lit}` ...`{kw}`catch`{lit}` ...` syntax to be used with {anchorName m}`Option`.

除了 {anchorName m}`Except` 和 {anchorName ExceptT}`ExceptT` 之外，还有一些有用的 {anchorName MonadExcept}`MonadExcept` 实例，用于处理其他类型的异常，这些异常乍看起来可能不像是异常。
例如，{anchorName m}`Option` 导致的失败可以被看作是抛出了一个不包含任何数据的异常，因此有一个实例 {anchorTerm OptionExcept}`MonadExcept Unit Option` 允许将 {kw}`try`{lit}` ...`{kw}`catch`{lit}` ...` 语法与 {anchorName m}`Option` 一起使用。

-- # State
# 状态
%%%
tag := "state-monad"
%%%

-- A simulation of mutable state is added to a monad by having monadic actions accept a starting state as an argument and return a final state together with their result.
-- The bind operator for a state monad provides the final state of one action as an argument to the next action, threading the state through the program.
-- This pattern can also be expressed as a monad transformer:

通过让单子动作接受一个起始状态作为参数，并返回一个最终状态及其结果，就可以在单子中加入对可变状态的模拟。
状态单子的绑定操作符将一个动作的最终状态作为下一个动作的参数，从而将状态贯穿整个程序。
这种模式也可以用单子转换器来表示：

```anchor DefStateT
def StateT (σ : Type u)
    (m : Type u → Type v) (α : Type u) : Type (max u v) :=
  σ → m (α × σ)
```


-- Once again, the monad instance is very similar to that for {anchorName State (module := Examples.Monads)}`State`.
-- The only difference is that the input and output states are passed around and returned in the underlying monad, rather than with pure code:

同样，该单子实例与 {anchorName State (module := Examples.Monads)}`State` 非常相似。
唯一不同的是，输入和输出状态是在底层单子中传递和返回的，而不是纯代码：

```anchor MonadStateT
instance [Monad m] : Monad (StateT σ m) where
  pure x := fun s => pure (x, s)
  bind result next := fun s => do
    let (v, s') ← result s
    next v s'
```

-- The corresponding type class has {anchorName MonadState}`get` and {anchorName MonadState}`set` methods.
-- One downside of {anchorName MonadState}`get` and {anchorName MonadState}`set` is that it becomes too easy to {anchorName MonadState}`set` the wrong state when updating it.
-- This is because retrieving the state, updating it, and saving the updated state is a natural way to write some programs.
-- For example, the following program counts the number of diacritic-free English vowels and consonants in a string of letters:

相应的类型类有 {anchorName MonadState}`get` 和 {anchorName MonadState}`set` 方法。
{anchorName MonadState}`get` 和 {anchorName MonadState}`set` 的一个缺点是，在更新状态时很容易 {anchorName MonadState}`set` 错误的状态。
这是因为检索状态、更新状态并保存更新后的状态是编写某些程序的一种很自然的方式。
例如，下面的程序会计算一串字母中不含音素的英语元音和辅音的数量：

```anchor countLetters
structure LetterCounts where
  vowels : Nat
  consonants : Nat
deriving Repr

inductive Err where
  | notALetter : Char → Err
deriving Repr

def vowels :=
  let lowerVowels := "aeiuoy"
  lowerVowels ++ lowerVowels.map (·.toUpper)

def consonants :=
  let lowerConsonants := "bcdfghjklmnpqrstvwxz"
  lowerConsonants ++ lowerConsonants.map (·.toUpper )

def countLetters (str : String) : StateT LetterCounts (Except Err) Unit :=
  let rec loop (chars : List Char) := do
    match chars with
    | [] => pure ()
    | c :: cs =>
      let st ← get
      let st' ←
        if c.isAlpha then
          if vowels.contains c then
            pure {st with vowels := st.vowels + 1}
          else if consonants.contains c then
            pure {st with consonants := st.consonants + 1}
          else -- modified or non-English letter
            pure st
        else throw (.notALetter c)
      set st'
      loop cs
  loop str.toList
```
-- It would be very easy to write {lit}`set st` instead of {anchorTerm countLetters}`set st'`.
-- In a large program, this kind of mistake can lead to difficult-to-diagnose bugs.

非常容易将 {lit}`set st` 误写成 {anchorTerm countLetters}`set st'` 。
在大型程序中，这种错误会导致难以诊断的 bug。

-- While using a nested action for the call to {anchorName countLetters}`get` would solve this problem, it can't solve all such problems.
-- For example, a function might update a field on a structure based on the values of two other fields.
-- This would require two separate nested-action calls to {anchorName countLetters}`get`.
-- Because the Lean compiler contains optimizations that are only effective when there is a single reference to a value, duplicating the references to the state might lead to code that is significantly slower.
-- Both the potential performance problem and the potential bug can be worked around by using {anchorName countLettersModify}`modify`, which transforms the state using a function:

虽然使用嵌套操作来调用 {anchorName countLetters}`get` 可以解决这个问题，但它不能解决所有此类问题。
例如，一个函数可能会根据另外两个字段的值来更新结构体上的一个字段。
这就需要对 {anchorName countLetters}`get` 进行两次单独的嵌套操作调用。
由于 Lean 编译器包含的优化功能只有在对值进行单个引用时才有效，因此重复引用状态可能会导致代码速度大大降低。
使用 {anchorName countLettersModify}`modify`（即使用函数转换状态）可以解决潜在的性能问题和 bug：

```anchor countLettersModify
def countLetters (str : String) : StateT LetterCounts (Except Err) Unit :=
  let rec loop (chars : List Char) := do
    match chars with
    | [] => pure ()
    | c :: cs =>
      if c.isAlpha then
        if vowels.contains c then
          modify fun st => {st with vowels := st.vowels + 1}
        else if consonants.contains c then
          modify fun st => {st with consonants := st.consonants + 1}
        else -- modified or non-English letter
          pure ()
      else throw (.notALetter c)
      loop cs
  loop str.toList
```
-- The type class contains a function akin to {anchorName modify}`modify` called {anchorName modify}`modifyGet`, which allows the function to both compute a return value and transform an old state in a single step.
-- The function returns a pair in which the first element is the return value, and the second element is the new state; {anchorName modify}`modify` just adds the constructor of {anchorName modify}`Unit` to the pair used in {anchorName modify}`modifyGet`:

类型类包含一个类似于 {anchorName modify}`modify` 的函数，称为 {anchorName modify}`modifyGet`，它允许函数在一个步骤中同时计算返回值和转换旧状态。
该函数返回一个二元组，其中第一个元素是返回值，第二个元素是新状态；{anchorName modify}`modify` 只是将 {anchorName modify}`Unit` 的构造函数添加到 {anchorName modify}`modifyGet` 中使用的二元组中：

```anchor modify
def modify [MonadState σ m] (f : σ → σ) : m Unit :=
  modifyGet fun s => ((), f s)
```

-- The definition of {anchorName MonadState}`MonadState` is as follows:

{anchorName MonadState}`MonadState` 的定义如下：

```anchor MonadState
class MonadState (σ : outParam (Type u)) (m : Type u → Type v) :
    Type (max (u+1) v) where
  get : m σ
  set : σ → m PUnit
  modifyGet : (σ → α × σ) → m α
```
-- {anchorName MonadState}`PUnit` is a version of the {anchorName modify}`Unit` type that is universe-polymorphic to allow it to be in {anchorTerm MonadState}`Type u` instead of {anchorTerm MonadState}`Type`.
-- While it would be possible to provide a default implementation of {anchorName MonadState}`modifyGet` in terms of {anchorName MonadState}`get` and {anchorName MonadState}`set`, it would not admit the optimizations that make {anchorName MonadState}`modifyGet` useful in the first place, rendering the method useless.

{anchorName MonadState}`PUnit` 是 {anchorName modify}`Unit` 类型的一个版本，它具有宇宙多态性，允许以 {anchorTerm MonadState}`Type u` 代替 {anchorTerm MonadState}`Type`。
虽然可以用 {anchorName MonadState}`get` 和 {anchorName MonadState}`set` 来提供 {anchorName MonadState}`modifyGet` 的默认实现，但这样就无法进行使 {anchorName MonadState}`modifyGet` 有用的优化，从而使该方法变得无用。

-- # {lit}`Of` Classes and {lit}`The` Functions
# {lit}`Of` 类和 {lit}`The` 函数
%%%
tag := "of-and-the"
%%%

-- Thus far, each monad type class that takes extra information, like the type of exceptions for {anchorName MonadExcept}`MonadExcept` or the type of the state for {anchorName MonadState}`MonadState`, has this type of extra information as an output parameter.
-- For simple programs, this is generally convenient, because a monad that combines one use each of {anchorName MonadStateT}`StateT`, {anchorName m}`ReaderT`, and {anchorName ExceptT}`ExceptT` has only a single state type, environment type, and exception type.
-- As monads grow in complexity, however, they may involve multiple states or errors types.
-- In this case, the use of an output parameter makes it impossible to target both states in the same {kw}`do`-block.

到目前为止，每个需要额外信息的单子类型类，如 {anchorName MonadExcept}`MonadExcept` 的异常类型或 {anchorName MonadState}`MonadState` 的状态类型，都有这类额外信息作为输出参数。
对于简单的程序来说，这通常很方便，因为结合使用了 {anchorName MonadStateT}`StateT`、{anchorName m}`ReaderT` 和 {anchorName ExceptT}`ExceptT` 的单子只有单一的状态类型、环境类型和异常类型。
然而，随着单子的复杂性增加，它们可能会涉及多个状态或错误类型。
在这种情况下，输出参数的使用使得无法在同一个 {kw}`do` 块中同时针对两种状态。

-- For these cases, there are additional type classes in which the extra information is not an output parameter.
-- These versions of the type classes use the word {lit}`Of` in the name.
-- For example, {anchorName getTheType}`MonadStateOf` is like {anchorName MonadState}`MonadState`, but without an {anchorName MonadState}`outParam` modifier.

应对这些情况，还有一些额外的类型类，其中的额外信息不是输出参数。
这些版本的类型类在名称中使用了 {lit}`Of` 字样。
例如，{anchorName getTheType}`MonadStateOf` 与 {anchorName MonadState}`MonadState` 类似，但没有 {anchorName MonadState}`outParam` 修饰符。

-- Instead of an {anchorName MonadState}`outParam`, these classes use a {anchorName various}`semiOutParam` for their respective state, environment, or exception types.
-- Like an {anchorName MonadState}`outParam`, a {anchorName various}`semiOutParam` is not required be known before Lean begins the process of searching for an instance.
-- However, there is an important difference: {anchorName MonadState}`outParam`s are ignored during the search for an instance, and as a result they are truly outputs.
-- If an {anchorName MonadState}`outParam` is known prior to the search, then Lean merely checks that the result of the search is the same as what was known.
-- On the other hand, a {anchorName various}`semiOutParam` that is known prior to the start of the search can be used to narrow down candidates, just like an input parameter.

这些类使用 {anchorName various}`semiOutParam` 来表示各自的状态、环境或异常类型，而不是 {anchorName MonadState}`outParam`。
与 {anchorName MonadState}`outParam` 一样，{anchorName various}`semiOutParam` 也不需要在 Lean 开始搜索实例之前就知道。
但是，有一个重要的区别：{anchorName MonadState}`outParam` 在搜索实例时会被忽略，因此它们是真正的输出。
如果在搜索之前就知道了一个 {anchorName MonadState}`outParam`，那么 Lean 只会检查搜索结果是否与已知结果相同。
另一方面，如果在搜索开始前就知道了一个 {anchorName various}`semiOutParam`，那么它就可以像输入参数一样用来缩小候选范围。

-- When a state monad's state type is an {anchorName MonadState}`outParam`, then each monad can have at most one type of state.
-- This is convenient, because it improves type inference: the state type can be inferred in more circumstances.
-- This is also inconvenient, because a monad built from multiple uses of {anchorName countLetters}`StateT` cannot provide a useful {anchorName modify}`MonadState` instance.
-- Using {anchorName modifyTheType}`MonadStateOf`, however, causes Lean to take the state type into account when it is available to select which instance to use, so one monad may provide multiple types of state.
-- The downside of this is that the resulting instance may not be the one that was intended when the state type has not been specified explicitly enough, which can lead to confusing error messages.

当状态单子的状态类型是 {anchorName MonadState}`outParam` 时，每个单子最多只能有一种状态类型。
这很方便，因为它改进了类型推断：可以在更多情况下推断出状态类型。
但这也很不方便，因为由多次使用 {anchorName countLetters}`StateT` 构建的单子无法提供有用的 {anchorName modify}`MonadState` 实例。
然而，使用 {anchorName modifyTheType}`MonadStateOf` 会让 Lean 在选择使用哪个实例时考虑状态类型，因此一个单子可以提供多种类型的状态。
这样做的缺点是，如果状态类型没有被明确指定，得到的实例可能不是预期的实例，从而导致令人困惑的错误信息。

-- Similarly, there are versions of the type class methods that accept the type of the extra information as an _explicit_, rather than implicit, argument.
-- For {anchorName modifyTheType}`MonadStateOf`, there are {anchorTerm getTheType}`getThe` with type

同样，也有一些版本的类型类方法接受额外信息的类型作为 _显式_ 参数，而不是隐式参数。
对于 {anchorName modifyTheType}`MonadStateOf`，有 {anchorTerm getTheType}`getThe`，类型为

```anchorTerm getTheType
(σ : Type u) → {m : Type u → Type v} → [MonadStateOf σ m] → m σ
```
-- and {anchorTerm modifyTheType}`modifyThe` with type

以及 {anchorTerm modifyTheType}`modifyThe`，类型为

```anchorTerm modifyTheType
(σ : Type u) → {m : Type u → Type v} → [MonadStateOf σ m] → (σ → σ) → m PUnit
```
-- There is no {lit}`setThe` because the type of the new state is enough to decide which surrounding state monad transformer to use.

没有 {lit}`setThe` 函数，因为新状态的类型足以决定使用哪个状态单子转换器。

-- In the Lean standard library, there are instances of the non-{lit}`Of` versions of the classes defined in terms of the instances of the versions with {lit}`Of`.
-- In other words, implementing the {lit}`Of` version yields implementations of both.
-- It's generally a good idea to implement the {lit}`Of` version, and then start writing programs using the non-{lit}`Of` versions of the class, transitioning to the {lit}`Of` version if the output parameter becomes inconvenient.

在 Lean 标准库中，有非 {lit}`Of` 版本的类型类实例是根据带 {lit}`Of` 版本的类型类实例定义的。
换句话说，实现 {lit}`Of` 版本可以同时实现这两个版本。
一般来说，实现 {lit}`Of` 版本是个好主意，然后开始使用类的非 {lit}`Of` 版本编写程序，如果输出参数变得不方便，就过渡到 {lit}`Of` 版本。

-- # Transformers and {lit}`Id`
# 转换器和 {lit}`Id`
%%%
tag := "transformers-and-Id"
%%%

-- The identity monad {anchorName various}`Id` is the monad that has no effects whatsoever, to be used in contexts that expect a monad for some reason but where none is actually necessary.
-- Another use of {anchorName various}`Id` is to serve as the bottom of a stack of monad transformers.
-- For instance, {anchorTerm StateTDoubleB}`StateT σ Id` works just like {anchorTerm set (module:=Examples.Monads)}`State σ`.

恒等单子 {anchorName various}`Id` 是没有任何作用的单子，可用于上下文因某种原因需要单子，但实际上不需要的情况。
{anchorName various}`Id` 的另一个用途是作为单子转换器栈的底层。
例如，{anchorTerm StateTDoubleB}`StateT σ Id` 的作用与 {anchorTerm set (module:=Examples.Monads)}`State σ` 相同。

-- # Exercises
# 练习
%%%
tag := "monad-transformer-exercises"
%%%

-- ## Monad Contract
## 单子约定
%%%
tag := "monad-contract-exercise"
%%%

-- Using pencil and paper, check that the rules of the monad transformer contract are satisfied for each monad transformer in this section.

用纸笔检查本节中每个单子转换器是否符合单子转换器的规则。

-- ## Logging Transformer
## 日志转换器
%%%
tag := "logging-transformer-exercise"
%%%

-- Define a monad transformer version of {anchorName WithLog (module:=Examples.Monads)}`WithLog`.
-- Also define the corresponding type class {lit}`MonadWithLog`, and write a program that combines logging and exceptions.

定义 {anchorName WithLog (module:=Examples.Monads)}`WithLog` 的单子转换器版本。
同时定义相应的类型类 {lit}`MonadWithLog`，并编写一个结合日志和异常的程序。

-- ## Counting Files
## 文件计数
%%%
tag := "counting-files-exercise"
%%%

-- Modify {lit}`doug`'s monad with {anchorName MonadStateT}`StateT` such that it counts the number of directories and files seen.
-- At the end of execution, it should display a report like:
-- ```
--   Viewed 38 files in 5 directories.
-- ```

用 {anchorName MonadStateT}`StateT` 来修改 {lit}`doug` 的单子，使它能统计所看到的目录和文件的数量。
在执行结束时，它应该显示如下报告：
```
  Viewed 38 files in 5 directories.
```
