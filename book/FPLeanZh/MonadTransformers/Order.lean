import VersoManual
import FPLeanZh.Examples

open Verso.Genre Manual
open Verso.Code.External

open FPLeanZh

set_option verso.exampleProject "../examples"
set_option verso.exampleModule "Examples.MonadTransformers.Defs"

#doc (Manual) "对单子转换器排序" =>
%%%
tag := "monad-transformer-order"
file := "Order"
%%%
-- Ordering Monad Transformers

-- When composing a monad from a stack of monad transformers, it's important to be aware that the order in which the monad transformers are layered matters.
-- Different orderings of the same set of transformers result in different monads.

在使用单子转换器栈组成单子时，必须注意单子转换器的分层顺序。
同一组转换器的不同排列顺序会产生不同的单子。

-- This version of {anchorName countLettersClassy}`countLetters` is just like the previous version, except it uses type classes to describe the set of available effects instead of providing a concrete monad:

这个版本的 {anchorName countLettersClassy}`countLetters` 和之前的版本一样，只是它使用类型类来描述可用的作用集，而不是提供一个具体的单子：

```anchor countLettersClassy
def countLetters [Monad m] [MonadState LetterCounts m] [MonadExcept Err m]
    (str : String) : m Unit :=
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
-- The state and exception monad transformers can be combined in two different orders, each resulting in a monad that has instances of both type classes:

状态和异常单子转换器可以两种不同的顺序组合，每种组合都会产生一个同时拥有这两种类型实例的单子：

```anchor SomeMonads
abbrev M1 := StateT LetterCounts (ExceptT Err Id)
abbrev M2 := ExceptT Err (StateT LetterCounts Id)
```

-- When run on input for which the program does not throw an exception, both monads yield similar results:

当程序运行接受没有抛出异常的输入时，这两个单子都会产生类似的结果：
```anchor countLettersM1Ok
#eval countLetters (m := M1) "hello" ⟨0, 0⟩
```
```anchorInfo countLettersM1Ok
Except.ok ((), { vowels := 2, consonants := 3 })
```
```anchor countLettersM2Ok
#eval countLetters (m := M2) "hello" ⟨0, 0⟩
```
```anchorInfo countLettersM2Ok
(Except.ok (), { vowels := 2, consonants := 3 })
```
-- However, there is a subtle difference between these return values.
-- In the case of {anchorName M1eval}`M1`, the outermost constructor is {anchorName MonadExceptT}`Except.ok`, and it contains a pair of the unit constructor with the final state.
-- In the case of {anchorName M2eval}`M2`, the outermost constructor is the pair, which contains {anchorName MonadExceptT}`Except.ok` applied only to the unit constructor.
-- The final state is outside of {anchorName MonadExceptT}`Except.ok`.
-- In both cases, the program returns the counts of vowels and consonants.

然而，这些返回值之间有一个微妙的区别。
对于 {anchorName M1eval}`M1`，最外层的构造函数是 {anchorName MonadExceptT}`Except.ok`，它包含单元构造函数与最终状态的元组。
对于 {anchorName M2eval}`M2`，最外层的构造函数是一个元组，其中包含只应用于单元构造函数的 {anchorName MonadExceptT}`Except.ok`。
最终状态在 {anchorName MonadExceptT}`Except.ok` 之外。
在这两种情况下，程序都会返回元音和辅音的数目。

-- On the other hand, only one monad yields a count of vowels and consonants when the string causes an exception to be thrown.
-- Using {anchorName M1eval}`M1`, only an exception value is returned:

另一方面，当字符串导致抛出异常时，只有一个单子会产生元音和辅音的计数。
使用 {anchorName M1eval}`M1`，只会返回一个异常值：
```anchor countLettersM1Error
#eval countLetters (m := M1) "hello!" ⟨0, 0⟩
```
```anchorInfo countLettersM1Error
Except.error (StEx.Err.notALetter '!')
```
-- Using {anchorName SomeMonads}`M2`, the exception value is paired with the state as it was at the time that the exception was thrown:

使用 {anchorName SomeMonads}`M2` 时，异常值与抛出异常时的状态配对：
```anchor countLettersM2Error
#eval countLetters (m := M2) "hello!" ⟨0, 0⟩
```
```anchorInfo countLettersM2Error
(Except.error (StEx.Err.notALetter '!'), { vowels := 2, consonants := 3 })
```

-- It might be tempting to think that {anchorName SomeMonads}`M2` is superior to {anchorName SomeMonads}`M1` because it provides more information that might be useful when debugging.
-- The same program might compute _different_ answers in {anchorName SomeMonads}`M1` than it does in {anchorName SomeMonads}`M2`, and there's no principled reason to say that one of these answers is necessarily better than the other.
-- This can be seen by adding a step to the program that handles exceptions:

我们可能会认为 {anchorName SomeMonads}`M2` 比 {anchorName SomeMonads}`M1` 更优越，因为它提供了更多在调试时可能有用的信息。
同样的程序在 {anchorName SomeMonads}`M1` 中计算出的答案可能与在 {anchorName SomeMonads}`M2` 中计算出的答案 _不同_ ，没有原则性的理由说其中一个答案一定比另一个好。
在程序中增加一个处理异常的步骤，就可以看到这一点：

```anchor countWithFallback
def countWithFallback
    [Monad m] [MonadState LetterCounts m] [MonadExcept Err m]
    (str : String) : m Unit :=
  try
    countLetters str
  catch _ =>
    countLetters "Fallback"
```
-- This program always succeeds, but it might succeed with different results.
-- If no exception is thrown, then the results are the same as {anchorName countWithFallback}`countLetters`:

该程序总会成功，但成功的结果可能不同。
如果没有抛出异常，则结果与 {anchorName countWithFallback}`countLetters` 相同：
```anchor countWithFallbackM1Ok
#eval countWithFallback (m := M1) "hello" ⟨0, 0⟩
```
```anchorInfo countWithFallbackM1Ok
Except.ok ((), { vowels := 2, consonants := 3 })
```
```anchor countWithFallbackM2Ok
#eval countWithFallback (m := M2) "hello" ⟨0, 0⟩
```
```anchorInfo countWithFallbackM2Ok
(Except.ok (), { vowels := 2, consonants := 3 })
```
-- However, if the exception is thrown and caught, then the final states are very different.
-- With {anchorName countWithFallbackM1Error}`M1`, the final state contains only the letter counts from {anchorTerm countWithFallback}`"Fallback"`:

但是，如果异常被抛出并捕获，那么最终状态就会截然不同。
对于 {anchorName countWithFallbackM1Error}`M1`，最终状态只包含来自 {anchorTerm countWithFallback}`"Fallback"` 的字母计数：
```anchor countWithFallbackM1Error
#eval countWithFallback (m := M1) "hello!" ⟨0, 0⟩
```
```anchorInfo countWithFallbackM1Error
Except.ok ((), { vowels := 2, consonants := 6 })
```
-- With {anchorName countWithFallbackM2Error}`M2`, the final state contains letter counts from both {anchorTerm countWithFallbackM2Error}`"hello!"` and from {anchorTerm countWithFallback}`"Fallback"`, as one would expect in an imperative language:

对于 {anchorName countWithFallbackM2Error}`M2`，最终状态包含来自 {anchorTerm countWithFallbackM2Error}`"hello!"` 和 {anchorTerm countWithFallback}`"Fallback"` 二者的字母计数，这与是命令式语言的结果相似：
```anchor countWithFallbackM2Error
#eval countWithFallback (m := M2) "hello!" ⟨0, 0⟩
```
```anchorInfo countWithFallbackM2Error
(Except.ok (), { vowels := 4, consonants := 9 })
```

-- In {anchorName countWithFallbackM1Error}`M1`, throwing an exception “rolls back” the state to where the exception was caught.
-- In {anchorName countLettersM2Error}`M2`, modifications to the state persist across the throwing and catching of exceptions.
-- This difference can be seen by unfolding the definitions of {anchorName SomeMonads}`M1` and {anchorName SomeMonads}`M2`.
-- {anchorTerm M1eval}`M1 α` unfolds to {anchorTerm M1eval}`LetterCounts → Except Err (α × LetterCounts)`, and {anchorTerm M2eval}`M2 α` unfolds to {anchorTerm M2eval}`LetterCounts → Except Err α × LetterCounts`.
-- That is to say, {anchorTerm M1eval}`M1 α` describes functions that take an initial letter count, returning either an error or an {anchorName M1eval}`α` paired with updated counts.
-- When an exception is thrown in {anchorName M1eval}`M1`, there is no final state.
-- {anchorTerm M2eval}`M2 α` describes functions that take an initial letter count and return a new letter count paired with either an error or an {anchorName M2eval}`α`.
-- When an exception is thrown in {anchorName M2eval}`M2`, it is accompanied by a state.

在 {anchorName countWithFallbackM1Error}`M1` 中，抛出异常会将状态 “回滚” 到捕获异常的位置。
而在 {anchorName countLettersM2Error}`M2` 中，对状态的修改会在抛出和捕获异常时持续存在。
通过展开 {anchorName SomeMonads}`M1` 和 {anchorName SomeMonads}`M2` 的定义，我们可以看到这种区别。
{anchorTerm M1eval}`M1 α` 展开为 {anchorTerm M1eval}`LetterCounts → Except Err (α × LetterCounts)`，而 {anchorTerm M2eval}`M2 α` 展开为 {anchorTerm M2eval}`LetterCounts → Except Err α × LetterCounts`。
也就是说，{anchorTerm M1eval}`M1 α` 描述的函数获取初始字母计数，返回错误或与更新计数配对的 {anchorName M1eval}`α`。
当 {anchorName M1eval}`M1` 中抛出异常时，没有最终状态。
{anchorTerm M2eval}`M2 α` 描述的是获取初始字母计数并返回新字母计数的函数，同时返回错误或 {anchorName M2eval}`α`。
当 {anchorName M2eval}`M2` 中抛出异常时，会伴随一个状态。

-- # Commuting Monads
# 交换单子
%%%
tag := "commuting-monads"
%%%

-- In the jargon of functional programming, two monad transformers are said to _commute_ if they can be re-ordered without the meaning of the program changing.
-- The fact that the result of the program can differ when {anchorName SomeMonads}`StateT` and {anchorName SomeMonads}`ExceptT` are reordered means that state and exceptions do not commute.
-- In general, monad transformers should not be expected to commute.

在函数式编程的行话中，如果两个单子转换器可以重新排序而不改变程序的意义，那么这两个单子转换器就被称为 _可交换_。
当 {anchorName SomeMonads}`StateT` 和 {anchorName SomeMonads}`ExceptT` 被重新排序时，程序的结果可能会不同，这意味着状态和异常并不可交换。
一般来说，单子转换器不应该可交换。

-- Even though not all monad transformers commute, some do.
-- For example, two uses of {anchorName SomeMonads}`StateT` can be re-ordered.
-- Expanding the definitions in {anchorTerm StateTDoubleA}`StateT σ (StateT σ' Id) α` yields the type {anchorTerm StateTDoubleA}`σ → σ' → ((α × σ) × σ')`, and {anchorTerm StateTDoubleB}`StateT σ' (StateT σ Id) α` yields {anchorTerm StateTDoubleB}`σ' → σ → ((α × σ') × σ)`.
-- In other words, the differences between them are that they nest the {anchorName StateTDoubleA}`σ` and {anchorName StateTDoubleA}`σ'` types in different places in the return type, and they accept their arguments in a different order.
-- Any client code will still need to provide the same inputs, and it will still receive the same outputs.

尽管并非所有的单子转换器都可交换，但有些单子转换器还是可交换的的。
例如，{anchorName SomeMonads}`StateT` 的两种用法可以重新排序。
对 {anchorTerm StateTDoubleA}`StateT σ (StateT σ' Id) α` 中的定义进行扩展，可以得到 {anchorTerm StateTDoubleA}`σ → σ' → ((α × σ) × σ')` 类型。 而 {anchorTerm StateTDoubleB}`StateT σ' (StateT σ Id) α` 则生成 {anchorTerm StateTDoubleB}`σ' → σ → ((α × σ') × σ)` 类型。
换句话说，它们的区别在于将 {anchorName StateTDoubleA}`σ` 和 {anchorName StateTDoubleA}`σ'` 类型嵌套到了返回类型的不同位置，而且接受参数的顺序也不同。
客户端代码仍需提供相同的输入，并接收相同的输出。

-- Most programming languages that have both mutable state and exceptions work like {anchorName SomeMonads}`M2`.
-- In those languages, state that _should_ be rolled back when an exception is thrown is difficult to express, and it usually needs to be simulated in a manner that looks much like the passing of explicit state values in {anchorName SomeMonads}`M1`.
-- Monad transformers grant the freedom to choose an interpretation of effect ordering that works for the problem at hand, with both choices being equally easy to program with.
-- However, they also require care to be taken in the choice of ordering of transformers.
-- With great expressive power comes the responsibility to check that what's being expressed is what is intended, and the type signature of {anchorName countWithFallback}`countWithFallback` is probably more polymorphic than it should be.

大多数既有可变状态又有异常的编程语言的工作方式类似于 {anchorName SomeMonads}`M2`。
在这些语言中，当异常抛出时应该回滚的状态是很难表达的，通常需要用像 {anchorName SomeMonads}`M1` 中那样传递显式状态值的方式来模拟。
单子转换器允许自由选择适合当前问题的作用序的解释，两种选择都同样易于编程。
然而，在选择转换器的序时也需要小心谨慎。
有强大的表达能力，我们也有责任检查所表达的是否是我们想要的，而 {anchorName countWithFallback}`countWithFallback` 的类型签名可能比它应有的多态性更强。


-- # Exercises
# 练习
%%%
tag := "monad-transformer-order-exercises"
%%%

-- * Check that {anchorName m}`ReaderT` and {anchorName SomeMonads}`StateT` commute by expanding their definitions and reasoning about the resulting types.
-- * Do {anchorName m}`ReaderT` and {anchorName SomeMonads}`ExceptT` commute? Check your answer by expanding their definitions and reasoning about the resulting types.
-- * Construct a monad transformer {lit}`ManyT` based on the definition of {anchorName Many (module:=Examples.Monads.Many)}`Many`, with a suitable {anchorName AlternativeOptionT}`Alternative` instance. Check that it satisfies the {anchorName AlternativeOptionT}`Monad` contract.
-- * Does {lit}`ManyT` commute with {anchorName SomeMonads}`StateT`? If so, check your answer by expanding definitions and reasoning about the resulting types. If not, write a program in {lit}`ManyT (StateT σ Id)` and a program in {lit}`StateT σ (ManyT Id)`. Each program should be one that makes more sense for the given ordering of monad transformers.

* 通过扩展 {anchorName m}`ReaderT` 和 {anchorName SomeMonads}`StateT` 的定义并推理得到的类型，检查 {anchorName m}`ReaderT` 和 {anchorName SomeMonads}`StateT` 是否可交换。
* {anchorName m}`ReaderT` 和 {anchorName SomeMonads}`ExceptT` 是否可交换？通过扩展它们的定义和推理得到的类型来检验你的答案。
* 根据 {anchorName Many (module:=Examples.Monads.Many)}`Many` 的定义，用一个合适的 {anchorName AlternativeOptionT}`Alternative` 实例构造一个单子转换器 {lit}`ManyT`。检查它是否满足 {anchorName AlternativeOptionT}`Monad` 约定。
* {lit}`ManyT` 是否与 {anchorName SomeMonads}`StateT` 交换？如果是，通过扩展定义和推理得到的类型来检查答案。如果不是，请写一个 {lit}`ManyT (StateT σ Id)` 的程序和一个 {lit}`StateT σ (ManyT Id)` 的程序。每个程序都应该是比给定的单子转换器排序更合理的程序。
