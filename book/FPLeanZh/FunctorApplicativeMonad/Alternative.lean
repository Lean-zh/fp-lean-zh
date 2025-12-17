import VersoManual
import FPLeanZh.Examples

open Verso.Genre Manual
open Verso Code External

open FPLeanZh

set_option verso.exampleProject "../examples"
set_option verso.exampleModule "Examples.FunctorApplicativeMonad"

#doc (Manual) "选择子" =>
%%%
file := "Alternative"
tag := "alternative"
%%%
-- Alternatives

-- # Recovery from Failure
# 从失败中恢复
%%%
tag := "alternative-recovery"
%%%

-- {anchorName Validate}`Validate` can also be used in situations where there is more than one way for input to be acceptable.
-- For the input form {anchorName RawInput}`RawInput`, an alternative set of business rules that implement conventions from a legacy system might be the following:
--
--  1. All human users must provide a birth year that is four digits.
--  2. Users born prior to 1970 do not need to provide names, due to incomplete older records.
--  3. Users born after 1970 must provide names.
--  4. Companies should enter {anchorTerm checkCompany}`"FIRM"` as their year of birth and provide a company name.

{anchorName Validate}`Validate` 还可以用于当输入有多种可接受方式的情况。
对于输入表单 {anchorName RawInput}`RawInput`，实现来自遗留系统的约定的替代业务规则集合可能如下：

 1. 所有人类用户必须提供四位数的出生年份。
 2. 由于旧记录不完整，1970年以前出生的用户不需要提供姓名。
 3. 1970年以后出生的用户必须提供姓名。
 4. 公司应输入 {anchorTerm checkCompany}`"FIRM"` 作为其出生年份并提供公司名称。

-- No particular provision is made for users born in 1970.
-- It is expected that they will either give up, lie about their year of birth, or call.
-- The company considers this an acceptable cost of doing business.

对于出生于1970年的用户，没有做出特别的规定。
预计他们要么放弃，要么谎报出生年份，要么打电话咨询。
公司认为这是可以接受的经营成本。

-- The following inductive type captures the values that can be produced from these stated rules:

以下归纳类型捕获了可以从这些既定规则中生成的值：

```anchor LegacyCheckedInput
abbrev NonEmptyString := {s : String // s ≠ ""}

inductive LegacyCheckedInput where
  | humanBefore1970 :
    (birthYear : {y : Nat // y > 999 ∧ y < 1970}) →
    String →
    LegacyCheckedInput
  | humanAfter1970 :
    (birthYear : {y : Nat // y > 1970}) →
    NonEmptyString →
    LegacyCheckedInput
  | company :
    NonEmptyString →
    LegacyCheckedInput
deriving Repr
```

-- A validator for these rules is more complicated, however, as it must address all three cases.
-- While it can be written as a series of nested {kw}`if` expressions, it's easier to design the three cases independently and then combine them.
-- This requires a means of recovering from failure while preserving error messages:

然而，一个针对这些规则的验证器会更复杂，因为它必须处理所有三种情况。
虽然可以将其写成一系列嵌套的 {kw}`if` 表达式，但更容易的方式是独立设计这三种情况，然后再将它们组合起来。
这需要一种在保留错误信息的同时从失败中恢复的方法：

```anchor ValidateorElse
def Validate.orElse
    (a : Validate ε α)
    (b : Unit → Validate ε α) :
    Validate ε α :=
  match a with
  | .ok x => .ok x
  | .errors errs1 =>
    match b () with
    | .ok x => .ok x
    | .errors errs2 => .errors (errs1 ++ errs2)
```

-- This pattern of recovery from failures is common enough that Lean has built-in syntax for it, attached to a type class named {anchorName OrElse}`OrElse`:

这种从失败中恢复的模式非常常见，以至于 Lean 为此内置了一种语法，并将其附加到了一个名为 {anchorName OrElse}`OrElse` 的类型类上：

```anchor OrElse
class OrElse (α : Type) where
  orElse : α → (Unit → α) → α
```
-- The expression {anchorTerm OrElseSugar}`E1 <|> E2` is short for {anchorTerm OrElseSugar}`OrElse.orElse E1 (fun () => E2)`.
-- An instance of {anchorName OrElse}`OrElse` for {anchorName Validate}`Validate` allows this syntax to be used for error recovery:

表达式 {anchorTerm OrElseSugar}`E1 <|> E2` 是 {anchorTerm OrElseSugar}`OrElse.orElse E1 (fun () => E2)` 的简写形式。
{anchorName Validate}`Validate` 的 {anchorName OrElse}`OrElse` 实例允许使用这种语法去进行错误恢复：

```anchor OrElseValidate
instance : OrElse (Validate ε α) where
  orElse := Validate.orElse
```

-- The validator for {anchorName LegacyCheckedInput}`LegacyCheckedInput` can be built from a validator for each constructor.
-- The rules for a company state that the birth year should be the string {anchorTerm checkCompany}`"FIRM"` and that the name should be non-empty.
-- The constructor {anchorName names1}`LegacyCheckedInput.company`, however, has no representation of the birth year at all, so there's no easy way to carry it out using {anchorTerm checkCompanyProv}`<*>`.
-- The key is to use a function with {anchorTerm checkCompanyProv}`<*>` that ignores its argument.

{anchorName LegacyCheckedInput}`LegacyCheckedInput` 的验证器可以由每个构造子的验证器构建而成。
对于公司的规则，规定了其出生年份应为字符串 {anchorTerm checkCompany}`"FIRM"`，且名称应为非空。
然而，构造子 {anchorName names1}`LegacyCheckedInput.company` 根本没有出生年份的表示，因此无法通过 {anchorTerm checkCompanyProv}`<*>` 去轻松执行此操作。
关键是使用一个带有 {anchorTerm checkCompanyProv}`<*>` 的函数，该函数忽略其参数。

-- Checking that a Boolean condition holds without recording any evidence of this fact in a type can be accomplished with {anchorName checkThat}`checkThat`:

检查布尔条件成立而不将此事实的任何证据记录在类型中，可以通过 {anchorName checkThat}`checkThat` 来完成：

```anchor checkThat
def checkThat (condition : Bool)
    (field : Field) (msg : String) :
    Validate (Field × String) Unit :=
  if condition then pure () else reportError field msg
```
-- This definition of {anchorName checkCompanyProv}`checkCompany` uses {anchorName checkCompanyProv}`checkThat`, and then throws away the resulting {anchorName checkThat}`Unit` value:

{anchorName checkCompanyProv}`checkCompany` 的这个定义使用了 {anchorName checkCompanyProv}`checkThat`，然后丢弃了结果中的 {anchorName checkThat}`Unit` 值：

```anchor checkCompanyProv
def checkCompany (input : RawInput) :
    Validate (Field × String) LegacyCheckedInput :=
  pure (fun () name => .company name) <*>
    checkThat (input.birthYear == "FIRM")
      "birth year" "FIRM if a company" <*>
    checkName input.name
```

-- However, this definition is quite noisy.
-- It can be simplified in two ways.
-- The first is to replace the first use of {anchorTerm checkCompanyProv}`<*>` with a specialized version that automatically ignores the value returned by the first argument, called {anchorTerm checkCompany}`*>`.
-- This operator is also controlled by a type class, called {anchorName ClassSeqRight}`SeqRight`, and {anchorTerm seqRightSugar}`E1 *> E2` is syntactic sugar for {anchorTerm seqRightSugar}`SeqRight.seqRight E1 (fun () => E2)`:

然而，这个定义相当嘈杂。
它可以通过两种方式简化。
第一种是将第一次使用的 {anchorTerm checkCompanyProv}`<*>` 替换为一个专门的版本，该版本会自动忽略第一个参数返回的值，称为 {anchorTerm checkCompany}`*>`。
这个运算符也由一个名为 {anchorName ClassSeqRight}`SeqRight` 的类型类控制，{anchorTerm seqRightSugar}`E1 *> E2` 是 {anchorTerm seqRightSugar}`SeqRight.seqRight E1 (fun () => E2)` 的语法糖：

```anchor ClassSeqRight
class SeqRight (f : Type → Type) where
  seqRight : f α → (Unit → f β) → f β
```
-- There is a default implementation of {anchorName ClassSeqRight}`seqRight` in terms of {anchorName fakeSeq}`seq`: {lit}`seqRight (a : f α) (b : Unit → f β) : f β := pure (fun _ x => x) <*> a <*> b ()`.

{anchorName ClassSeqRight}`seqRight` 有一个基于 {anchorName fakeSeq}`seq` 的默认实现：{lit}`seqRight (a : f α) (b : Unit → f β) : f β := pure (fun _ x => x) <*> a <*> b ()`。

-- Using {anchorName ClassSeqRight}`seqRight`, {anchorName checkCompanyProv2}`checkCompany` becomes simpler:

使用 {anchorName ClassSeqRight}`seqRight`，{anchorName checkCompanyProv2}`checkCompany` 变得更简单：

```anchor checkCompanyProv2
def checkCompany (input : RawInput) :
    Validate (Field × String) LegacyCheckedInput :=
  checkThat (input.birthYear == "FIRM")
    "birth year" "FIRM if a company" *>
  pure .company <*> checkName input.name
```
-- One more simplification is possible.
-- For every {anchorName ApplicativeExcept}`Applicative`, {anchorTerm ApplicativeLaws}`pure f <*> E` is equivalent to {anchorTerm ApplicativeLaws}`f <$> E`.
-- In other words, using {anchorName fakeSeq}`seq` to apply a function that was placed into the {anchorName ApplicativeExtendsFunctorOne}`Applicative` type using {anchorName ApplicativeExtendsFunctorOne}`pure` is overkill, and the function could have just been applied using {anchorName ApplicativeLaws}`Functor.map`.
-- This simplification yields:

还有一种简化是可能的。
对于每个 {anchorName ApplicativeExcept}`Applicative`，{anchorTerm ApplicativeLaws}`pure f <*> E` 等价于 {anchorTerm ApplicativeLaws}`f <$> E`。
换句话说，使用 {anchorName fakeSeq}`seq` 来应用一个通过 {anchorName ApplicativeExtendsFunctorOne}`pure` 放入 {anchorName ApplicativeExtendsFunctorOne}`Applicative` 类型的函数是大材小用，该函数本可以直接使用 {anchorName ApplicativeLaws}`Functor.map` 来应用。
这种简化产生：

```anchor checkCompany
def checkCompany (input : RawInput) :
    Validate (Field × String) LegacyCheckedInput :=
  checkThat (input.birthYear == "FIRM")
    "birth year" "FIRM if a company" *>
  .company <$> checkName input.name
```

-- The remaining two constructors of {anchorName LegacyCheckedInput}`LegacyCheckedInput` use subtypes for their fields.
-- A general-purpose tool for checking subtypes will make these easier to read:

{anchorName LegacyCheckedInput}`LegacyCheckedInput` 的其余两个构造子对其字段使用子类型。
一个用于检查子类型的通用工具将使这些更容易阅读：

```anchor checkSubtype
def checkSubtype {α : Type} (v : α) (p : α → Prop) [Decidable (p v)]
    (err : ε) : Validate ε {x : α // p x} :=
  if h : p v then
    pure ⟨v, h⟩
  else
    .errors { head := err, tail := [] }
```
-- In the function's argument list, it's important that the type class {anchorTerm checkSubtype}`[Decidable (p v)]` occur after the specification of the arguments {anchorName checkSubtype}`v` and {anchorName checkSubtype}`p`.
-- Otherwise, it would refer to an additional set of automatic implicit arguments, rather than to the manually-provided values.
-- The {anchorName checkSubtype}`Decidable` instance is what allows the proposition {anchorTerm checkSubtype}`p v` to be checked using {kw}`if`.

在函数的参数列表中，类型类 {anchorTerm checkSubtype}`[Decidable (p v)]` 出现在参数 {anchorName checkSubtype}`v` 和 {anchorName checkSubtype}`p` 的规范之后是很重要的。
否则，它将引用一组额外的自动隐式参数，而不是手动提供的值。
{anchorName checkSubtype}`Decidable` 实例允许使用 {kw}`if` 检查命题 {anchorTerm checkSubtype}`p v`。

-- The two human cases do not need any additional tools:

两种人类情况不需要任何额外的工具：

```anchor checkHumanBefore1970
def checkHumanBefore1970 (input : RawInput) :
    Validate (Field × String) LegacyCheckedInput :=
  (checkYearIsNat input.birthYear).andThen fun y =>
    .humanBefore1970 <$>
      checkSubtype y (fun x => x > 999 ∧ x < 1970)
        ("birth year", "less than 1970") <*>
      pure input.name
```

```anchor checkHumanAfter1970
def checkHumanAfter1970 (input : RawInput) :
    Validate (Field × String) LegacyCheckedInput :=
  (checkYearIsNat input.birthYear).andThen fun y =>
    .humanAfter1970 <$>
      checkSubtype y (· > 1970)
        ("birth year", "greater than 1970") <*>
      checkName input.name
```

-- The validators for the three cases can be combined using {anchorTerm OrElseSugar}`<|>`:

三种情况的验证器可以使用 {anchorTerm OrElseSugar}`<|>` 组合：

```anchor checkLegacyInput
def checkLegacyInput (input : RawInput) :
    Validate (Field × String) LegacyCheckedInput :=
  checkCompany input <|>
  checkHumanBefore1970 input <|>
  checkHumanAfter1970 input
```

-- The successful cases return constructors of {anchorName LegacyCheckedInput}`LegacyCheckedInput`, as expected:

成功的情况返回 {anchorName LegacyCheckedInput}`LegacyCheckedInput` 的构造子，正如预期的那样：

```anchor trollGroomers
#eval checkLegacyInput ⟨"Johnny's Troll Groomers", "FIRM"⟩
```
```anchorInfo trollGroomers
Validate.ok (LegacyCheckedInput.company "Johnny's Troll Groomers")
```
```anchor johnny
#eval checkLegacyInput ⟨"Johnny", "1963"⟩
```
```anchorInfo johnny
Validate.ok (LegacyCheckedInput.humanBefore1970 1963 "Johnny")
```
```anchor johnnyAnon
#eval checkLegacyInput ⟨"", "1963"⟩
```
```anchorInfo johnnyAnon
Validate.ok (LegacyCheckedInput.humanBefore1970 1963 "")
```

-- The worst possible input returns all the possible failures:

最糟糕的输入返回所有可能的失败：

```anchor allFailures
#eval checkLegacyInput ⟨"", "1970"⟩
```
```anchorInfo allFailures
Validate.errors
  { head := ("birth year", "FIRM if a company"),
    tail := [("name", "Required"),
             ("birth year", "less than 1970"),
             ("birth year", "greater than 1970"),
             ("name", "Required")] }
```

-- # The {lit}`Alternative` Class
# Alternative 类
%%%
tag := "Alternative"
%%%


-- Many types support a notion of failure and recovery.
-- The {anchorName AlternativeMany}`Many` monad from the section on {ref "nondeterministic-search"}[evaluating arithmetic expressions in a variety of monads] is one such type, as is {anchorName AlternativeOption}`Option`.
-- Both support failure without providing a reason (unlike, say, {anchorName ApplicativeExcept}`Except` and {anchorName Validate}`Validate`, which require some indication of what went wrong).

许多类型支持失败和恢复的概念。
来自 {ref "nondeterministic-search"}[在各种单子中求值算术表达式] 一节中的 {anchorName AlternativeMany}`Many` 单子就是这样一种类型，{anchorName AlternativeOption}`Option` 也是。
两者都支持失败而不提供原因（不像 {anchorName ApplicativeExcept}`Except` 和 {anchorName Validate}`Validate`，它们需要一些关于出了什么问题的指示）。

-- The {anchorName FakeAlternative}`Alternative` class describes applicative functors that have additional operators for failure and recovery:

{anchorName FakeAlternative}`Alternative` 类描述了具有用于失败和恢复的额外运算符的应用函子：

```anchor FakeAlternative
class Alternative (f : Type → Type) extends Applicative f where
  failure : f α
  orElse : f α → (Unit → f α) → f α
```
-- Just as implementors of {anchorTerm misc}`Add α` get {anchorTerm misc}`HAdd α α α` instances for free, implementors of {anchorName FakeAlternative}`Alternative` get {anchorName OrElse}`OrElse` instances for free:

就像 {anchorTerm misc}`Add α` 的实现者免费获得 {anchorTerm misc}`HAdd α α α` 实例一样，{anchorName FakeAlternative}`Alternative` 的实现者免费获得 {anchorName OrElse}`OrElse` 实例：

```anchor AltOrElse
instance [Alternative f] : OrElse (f α) where
  orElse := Alternative.orElse
```

-- The implementation of {anchorName FakeAlternative}`Alternative` for {anchorName ApplicativeOption}`Option` keeps the first non-{anchorName ApplicativeOption}`none` argument:

{anchorName ApplicativeOption}`Option` 的 {anchorName FakeAlternative}`Alternative` 实现保留第一个非 {anchorName ApplicativeOption}`none` 参数：

```anchor AlternativeOption
instance : Alternative Option where
  failure := none
  orElse
    | some x, _ => some x
    | none, y => y ()
```
-- Similarly, the implementation for {anchorName AlternativeMany}`Many` follows the general structure of {moduleName (module := Examples.Monads.Many)}`Many.union`, with minor differences due to the laziness-inducing {anchorName guard}`Unit` parameters being placed differently:

同样，{anchorName AlternativeMany}`Many` 的实现遵循 {moduleName (module := Examples.Monads.Many)}`Many.union` 的一般结构，由于导致惰性的 {anchorName guard}`Unit` 参数放置位置不同而略有差异：

```anchor AlternativeMany
def Many.orElse : Many α → (Unit → Many α) → Many α
  | .none, ys => ys ()
  | .more x xs, ys => .more x (fun () => orElse (xs ()) ys)

instance : Alternative Many where
  failure := .none
  orElse := Many.orElse
```

-- Like other type classes, {anchorName FakeAlternative}`Alternative` enables the definition of a variety of operations that work for _any_ applicative functor that implements {anchorName FakeAlternative}`Alternative`.
-- One of the most important is {anchorName guard}`guard`, which causes {anchorName guard}`failure` when a decidable proposition is false:

像其他类型类一样，{anchorName FakeAlternative}`Alternative` 能够定义适用于实现 {anchorName FakeAlternative}`Alternative` 的 _任何_ 应用函子的各种操作。
其中最重要的是 {anchorName guard}`guard`，当可判定命题为假时，它会导致 {anchorName guard}`failure`：

```anchor guard
def guard [Alternative f] (p : Prop) [Decidable p] : f Unit :=
  if p then
    pure ()
  else failure
```
-- It is very useful in monadic programs to terminate execution early.
-- In {anchorName evenDivisors}`Many`, it can be used to filter out a whole branch of a search, as in the following program that computes all even divisors of a natural number:

在单子程序中提前终止执行非常有用。
在 {anchorName evenDivisors}`Many` 中，它可以用来过滤掉搜索的整个分支，如下面的程序计算自然数的所有偶数除数：

```anchor evenDivisors
def Many.countdown : Nat → Many Nat
  | 0 => .none
  | n + 1 => .more n (fun () => countdown n)

def evenDivisors (n : Nat) : Many Nat := do
  let k ← Many.countdown (n + 1)
  guard (k % 2 = 0)
  guard (n % k = 0)
  pure k
```
-- Running it on {anchorTerm evenDivisors20}`20` yields the expected results:

在 {anchorTerm evenDivisors20}`20` 上运行它会产生预期的结果：

```anchor evenDivisors20
#eval (evenDivisors 20).takeAll
```
```anchorInfo evenDivisors20
[20, 10, 4, 2]
```

-- # Exercises
# 练习
%%%
tag := "Alternative-exercises"
%%%

-- ## Improve Validation Friendliness
## 提高验证友好性
%%%
tag := "improve-validation-friendliness"
%%%

-- The errors returned from {anchorName Validate}`Validate` programs that use {anchorTerm OrElseSugar}`<|>` can be difficult to read, because inclusion in the list of errors simply means that the error can be reached through _some_ code path.
-- A more structured error report can be used to guide the user through the process more accurately:

使用 {anchorTerm OrElseSugar}`<|>` 的 {anchorName Validate}`Validate` 程序返回的错误可能难以阅读，因为包含在错误列表中仅仅意味着可以通过 _某些_ 代码路径到达该错误。
可以使用更结构化的错误报告来更准确地指导用户完成该过程：

--  * Replace the {anchorName Validate}`NonEmptyList` in {anchorName misc}`Validate.errors` with a bare type variable, and then update the definitions of the {anchorTerm ApplicativeValidate}`Applicative (Validate ε)` and {anchorTerm OrElseValidate}`OrElse (Validate ε α)` instances to require only that there be an {anchorTerm misc}`Append ε` instance available.
--  * Define a function {anchorTerm misc}`Validate.mapErrors : Validate ε α → (ε → ε') → Validate ε' α` that transforms all the errors in a validation run.
--  * Using the datatype {anchorName TreeError}`TreeError` to represent errors, rewrite the legacy validation system to track its path through the three alternatives.
--  * Write a function {anchorTerm misc}`report : TreeError → String` that outputs a user-friendly view of the {anchorName TreeError}`TreeError`'s accumulated warnings and errors.

 * 将 {anchorName misc}`Validate.errors` 中的 {anchorName Validate}`NonEmptyList` 替换为裸类型变量，然后更新 {anchorTerm ApplicativeValidate}`Applicative (Validate ε)` 和 {anchorTerm OrElseValidate}`OrElse (Validate ε α)` 实例的定义，仅要求有一个可用的 {anchorTerm misc}`Append ε` 实例。
 * 定义一个函数 {anchorTerm misc}`Validate.mapErrors : Validate ε α → (ε → ε') → Validate ε' α`，它转换验证运行中的所有错误。
 * 使用数据类型 {anchorName TreeError}`TreeError` 来表示错误，重写遗留验证系统以跟踪其通过三个备选方案的路径。
 * 编写一个函数 {anchorTerm misc}`report : TreeError → String`，输出 {anchorName TreeError}`TreeError` 累积的警告和错误的对用户友好的视图。

```anchor TreeError
inductive TreeError where
  | field : Field → String → TreeError
  | path : String → TreeError → TreeError
  | both : TreeError → TreeError → TreeError

instance : Append TreeError where
  append := .both
```
