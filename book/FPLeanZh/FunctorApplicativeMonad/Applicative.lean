import VersoManual
import FPLeanZh.Examples

open Verso.Genre Manual
open Verso Code External

open FPLeanZh

set_option verso.exampleProject "../examples"
set_option verso.exampleModule "Examples.FunctorApplicativeMonad"

#doc (Manual) "应用函子" =>
%%%
file := "Applicative"
tag := "applicative"
%%%

-- An _applicative functor_ is a functor that has two additional operations available: {anchorName ApplicativeOption}`pure` and {anchorName ApplicativeOption}`seq`.
-- {anchorName ApplicativeOption}`pure` is the same operator used in {anchorName ApplicativeLaws}`Monad`, because {anchorName ApplicativeLaws}`Monad` in fact inherits from {anchorName ApplicativeOption}`Applicative`.
-- {anchorName ApplicativeOption}`seq` is much like {anchorName FunctorNames}`map`: it allows a function to be used in order to transform the contents of a datatype.
-- However, with {anchorName ApplicativeOption}`seq`, the function is itself contained in the datatype: {anchorTerm seqType}`f (α → β) → (Unit → f α) → f β`.
-- Having the function under the type {anchorName seqType}`f` allows the {anchorName ApplicativeOption}`Applicative` instance to control how the function is applied, while {anchorName FunctorNames}`Functor.map` unconditionally applies a function.
-- The second argument has a type that begins with {anchorTerm seqType}`Unit →` to allow the definition of {anchorName ApplicativeOption}`seq` to short-circuit in cases where the function will never be applied.

_应用函子 (Applicative Functor)_ 是一种具有两个附加操作的函子：{anchorName ApplicativeOption}`pure` 和 {anchorName ApplicativeOption}`seq`。
{anchorName ApplicativeOption}`pure` 是 {anchorName ApplicativeLaws}`Monad` 中使用的相同的运算符，因为 {anchorName ApplicativeLaws}`Monad` 实际上继承自 {anchorName ApplicativeOption}`Applicative`。
{anchorName ApplicativeOption}`seq` 非常类似于 {anchorName FunctorNames}`map`：它允许使用一个函数来转换数据类型的内容。
然而，在使用 {anchorName ApplicativeOption}`seq` 时，函数本身也被包含在数据类型中：{anchorTerm seqType}`f (α → β) → (Unit → f α) → f β`。
将函数置于类型 {anchorName seqType}`f` 之下会允许 {anchorName ApplicativeOption}`Applicative` 的实例去控制函数被应用的方式，而 {anchorName FunctorNames}`Functor.map` 则无条件地应用函数。
第二个参数的类型以 {anchorTerm seqType}`Unit →` 开头，以允许在函数永远不会被应用的情况下，定义 {anchorName ApplicativeOption}`seq` 时短路。

-- The value of this short-circuiting behavior can be seen in the instance of {anchorTerm ApplicativeOption}`Applicative Option`:

这种短路行为的价值可以在 {anchorTerm ApplicativeOption}`Applicative Option` 的实例中看到：

```anchor ApplicativeOption
instance : Applicative Option where
  pure x := .some x
  seq f x :=
    match f with
    | none => none
    | some g => g <$> x ()
```
-- In this case, if there is no function for {anchorName ApplicativeOption}`seq` to apply, then there is no need to compute its argument, so {anchorName ApplicativeOption}`x` is never called.
-- The same consideration informs the instance of {anchorName ApplicativeExcept}`Applicative` for {anchorName ApplicativeExcept}`Except`:

在这种情况下，如果没有函数供 {anchorName ApplicativeOption}`seq` 应用，那么就不需要计算其参数，因此 {anchorName ApplicativeOption}`x` 永远不会被调用。
同样的考虑也适用于 {anchorName ApplicativeExcept}`Except` 的 {anchorName ApplicativeExcept}`Applicative` 实例：

```anchor ApplicativeExcept
instance : Applicative (Except ε) where
  pure x := .ok x
  seq f x :=
    match f with
    | .error e => .error e
    | .ok g => g <$> x ()
```
-- This short-circuiting behavior depends only on the {anchorName AlternativeOption}`Option` or {anchorName ApplicativeExcept}`Except` structures that _surround_ the function, rather than on the function itself.

这种短路行为仅依赖于包围着函数的 {anchorName AlternativeOption}`Option` 或 {anchorName ApplicativeExcept}`Except` 结构，而不是函数本身。

-- Monads can be seen as a way of capturing the notion of sequentially executing statements into a pure functional language.
-- The result of one statement can affect which further statements run.
-- This can be seen in the type of {anchorName bindType}`bind`: {anchorTerm bindType}`m α → (α → m β) → m β`.
-- The first statement's resulting value is an input into a function that computes the next statement to execute.
-- Successive uses of {anchorName bindType}`bind` are like a sequence of statements in an imperative programming language, and {anchorName bindType}`bind` is powerful enough to implement control structures like conditionals and loops.

_单子 (Monad)_ 可以被看作是一种将按顺序执行语句的概念引入纯函数式语言的方法。
一个语句的结果会影响接下来要执行的语句。
这可以从 {anchorName bindType}`bind` 的类型中看出：{anchorTerm bindType}`m α → (α → m β) → m β`。
第一个语句的结果值是作为一个函数的输入，该函数会计算下一个要执行的语句。
连续使用 {anchorName bindType}`bind` 类似于命令式编程语言中的语句序列，而且 {anchorName bindType}`bind` 足够强大，可以实现诸如条件语句和循环等控制结构。

-- Following this analogy, {anchorName ApplicativeId}`Applicative` captures function application in a language that has side effects.
-- The arguments to a function in languages like Kotlin or C# are evaluated from left to right.
-- Side effects performed by earlier arguments occur before those performed by later arguments.
-- A function is not powerful enough to implement custom short-circuiting operators that depend on the specific _value_ of an argument, however.

按照这个类比，{anchorName ApplicativeId}`Applicative` 捕获了在具有副作用的语言中函数的应用。
在像 Kotlin 或 C# 这样的语言中，函数的参数是从左到右进行求值的。
较早的参数所执行的副作用在较晚的参数执行的副作用之前发生。
然而，函数不足以实现依赖于参数特定 _值_ 的自定义短路运算符。

-- Typically, {anchorName ApplicativeExtendsFunctorOne}`seq` is not invoked directly.
-- Instead, the operator {lit}`<*>` is used.
-- This operator wraps its second argument in {lit}`fun () => ...`, simplifying the call site.
-- In other words, {anchorTerm seqSugar}`E1 <*> E2` is syntactic sugar for {anchorTerm seqSugar}`Seq.seq E1 (fun () => E2)`.

通常情况下，不会直接调用 {anchorName ApplicativeExtendsFunctorOne}`seq`。
而是使用运算符 {lit}`<*>`。
这个运算符将其第二个参数包装在 {lit}`fun () => ...` 中，从而简化了调用位置。
换句话说，{anchorTerm seqSugar}`E1 <*> E2` 是 {anchorTerm seqSugar}`Seq.seq E1 (fun () => E2)` 的语法糖。


-- The key feature that allows {anchorName ApplicativeExtendsFunctorOne}`seq` to be used with multiple arguments is that a multiple-argument Lean function is really a single-argument function that returns another function that's waiting for the rest of the arguments.
-- In other words, if the first argument to {anchorName ApplicativeExtendsFunctorOne}`seq` is awaiting multiple arguments, then the result of the {anchorName ApplicativeExtendsFunctorOne}`seq` will be awaiting the rest.
-- For example, {anchorTerm somePlus}`some Plus.plus` can have the type {anchorTerm somePlus}`Option (Nat → Nat → Nat)`.
-- Providing one argument, {anchorTerm somePlusFour}`some Plus.plus <*> some 4`, results in the type {anchorTerm somePlusFour}`Option (Nat → Nat)`.
-- This can itself be used with {anchorName ApplicativeExtendsFunctorOne}`seq`, so {anchorTerm somePlusFourSeven}`some Plus.plus <*> some 4 <*> some 7` has the type {anchorTerm somePlusFourSeven}`Option Nat`.

允许 {anchorName ApplicativeExtendsFunctorOne}`seq` 与多个参数一起使用的关键特性在于，在 Lean 中的多参数函数实际上是一个单参数函数，该函数会返回另一个正在等待其余参数的函数。
换句话说，如果 {anchorName ApplicativeExtendsFunctorOne}`seq` 的第一个参数正在等待多个参数，那么 {anchorName ApplicativeExtendsFunctorOne}`seq` 的输出结果将等待其余的参数。
例如，{anchorTerm somePlus}`some Plus.plus` 可以具有类型 {anchorTerm somePlus}`Option (Nat → Nat → Nat)`。
提供一个参数后，{anchorTerm somePlusFour}`some Plus.plus <*> some 4` 的类型将转变为 {anchorTerm somePlusFour}`Option (Nat → Nat)`。
这本身也可以与 {anchorName ApplicativeExtendsFunctorOne}`seq` 一起使用，因此 {anchorTerm somePlusFourSeven}`some Plus.plus <*> some 4 <*> some 7` 的类型为 {anchorTerm somePlusFourSeven}`Option Nat`。

-- Not every functor is applicative.
-- {anchorName Pair}`Pair` is like the built-in product type {anchorName names}`Prod`:

不是每个函子都是应用函子。
{anchorName Pair}`Pair` 类似于内置的乘积类型 {anchorName names}`Prod`：

```anchor Pair
structure Pair (α β : Type) : Type where
  first : α
  second : β
```
-- Like {anchorName ApplicativeExcept}`Except`, {anchorTerm PairType}`Pair` has type {anchorTerm PairType}`Type → Type → Type`.
-- This means that {anchorTerm FunctorPair}`Pair α` has type {anchorTerm PairType}`Type → Type`, and a {anchorName FunctorPair}`Functor` instance is possible:

如同 {anchorName ApplicativeExcept}`Except`，{anchorTerm PairType}`Pair` 的类型是 {anchorTerm PairType}`Type → Type → Type`。
这意味着 {anchorTerm FunctorPair}`Pair α` 的类型是 {anchorTerm PairType}`Type → Type`，因此可以有一个 {anchorName FunctorPair}`Functor` 实例：

```anchor FunctorPair
instance : Functor (Pair α) where
  map f x := ⟨x.first, f x.second⟩
```
-- This instance obeys the {anchorName FunctorPair}`Functor` contract.

此实例遵循 {anchorName FunctorPair}`Functor` 契约。

-- The two properties to check are that {anchorEvalStep checkPairMapId 0}`id <$> Pair.mk x y`{lit}` = `{anchorEvalStep checkPairMapId 2}`Pair.mk x y` and that {anchorEvalStep checkPairMapComp1 0}`f <$> g <$> Pair.mk x y`{lit}` = `{anchorEvalStep checkPairMapComp2 0}`(f ∘ g) <$> Pair.mk x y`.
-- The first property can be checked by just stepping through the evaluation of the left side, and noticing that it evaluates to the right side:

要检查的两个属性是 {anchorEvalStep checkPairMapId 0}`id <$> Pair.mk x y`{lit}` = `{anchorEvalStep checkPairMapId 2}`Pair.mk x y` 和 {anchorEvalStep checkPairMapComp1 0}`f <$> g <$> Pair.mk x y`{lit}` = `{anchorEvalStep checkPairMapComp2 0}`(f ∘ g) <$> Pair.mk x y`。
第一个属性可以通过从左侧的逐步求值直到右侧来检查：

```anchorEvalSteps checkPairMapId
id <$> Pair.mk x y
===>
Pair.mk x (id y)
===>
Pair.mk x y
```
-- The second can be checked by stepping through both sides, and noting that they yield the same result:

第二个属性可以通过逐步检查两侧来验证，并注意它们产生了相同的结果：

```anchorEvalSteps checkPairMapComp1
f <$> g <$> Pair.mk x y
===>
f <$> Pair.mk x (g y)
===>
Pair.mk x (f (g y))
```
```anchorEvalSteps checkPairMapComp2
(f ∘ g) <$> Pair.mk x y
===>
Pair.mk x ((f ∘ g) y)
===>
Pair.mk x (f (g y))
```

-- Attempting to define an {anchorName ApplicativeExcept}`Applicative` instance, however, does not work so well.
-- It will require a definition of {anchorName Pairpure (show := pure)}`Pair.pure`:

但是，尝试定义一个 {anchorName ApplicativeExcept}`Applicative` 实例的效果并不理想。
它需要 {anchorName Pairpure (show := pure)}`Pair.pure` 的定义：

```anchor Pairpure
def Pair.pure (x : β) : Pair α β := _
```
```anchorError Pairpure
don't know how to synthesize placeholder
context:
β α : Type
x : β
⊢ Pair α β
```
-- There is a value with type {anchorName Pairpure2}`β` in scope (namely {anchorName Pairpure2}`x`), and the error message from the underscore suggests that the next step is to use the constructor {anchorName Pairpure2}`Pair.mk`:

在当前作用域内有一个类型为 {anchorName Pairpure2}`β` 的值（即 {anchorName Pairpure2}`x`），下划线处的错误信息表明了下一步是使用构造子 {anchorName Pairpure2}`Pair.mk`：

```anchor Pairpure2
def Pair.pure (x : β) : Pair α β := Pair.mk _ x
```
```anchorError Pairpure2
don't know how to synthesize placeholder for argument 'first'
context:
β α : Type
x : β
⊢ α
```
-- Unfortunately, there is no {anchorName Pairpure2}`α` available.
-- Because {anchorName Pairpure2 (show := pure)}`Pair.pure` would need to work for _all possible types_ {anchorName Pairpure2}`α` to define an instance of {anchorTerm ApplicativePair}`Applicative (Pair α)`, this is impossible.
-- After all, a caller could choose {anchorName Pairpure2}`α` to be {anchorName ApplicativePair}`Empty`, which has no values at all.

不幸的是，没有可用的 {anchorName Pairpure2}`α`。
因为 {anchorName Pairpure2 (show := pure)}`Pair.pure` 需要适用于 _所有可能的类型_ {anchorName Pairpure2}`α` ，才能定义 {anchorTerm ApplicativePair}`Applicative (Pair α)` 的实例，所以这是不可能的。
毕竟，调用者可以选择 {anchorName Pairpure2}`α` 为 {anchorName ApplicativePair}`Empty`，而 {anchorName ApplicativePair}`Empty` 根本没有任何值。

-- # A Non-Monadic Applicative
# 一个非单子的应用函子
%%%
tag := "validate"
%%%

-- When validating user input to a form, it's generally considered to be best to provide many errors at once, rather than one error at a time.
-- This allows the user to have an overview of what is needed to please the computer, rather than feeling badgered as they correct the errors field by field.

在验证表单中的用户输入时，通常认为最好一次性提供多个错误，而不是一次提供一个错误。
这样，用户可以大致了解需要做什么才可以满足计算机的要求，而不是逐个对属性地纠正错误时感到烦恼。

-- Ideally, validating user input will be visible in the type of the function that's doing the validating.
-- It should return a datatype that is specific—checking that a text box contains a number should return an actual numeric type, for instance.
-- A validation routine could throw an exception when the input does not pass validation.
-- Exceptions have a major drawback, however: they terminate the program at the first error, making it impossible to accumulate a list of errors.

理想情况下，验证用户输入将在执行验证的函数类型中可见。
它应该返回一个特定的数据类型——例如，检验包含数字的文本框是否返回一个实际的数字类型。
验证例程可能会在输入未通过验证时抛出 _异常 (Exception)_。
然而，异常有一个主要缺点：它们在第一个错误出现时终止程序，从而无法累积错误列表。

-- On the other hand, the common design pattern of accumulating a list of errors and then failing when it is non-empty is also problematic.
-- A long nested sequences of {kw}`if` statements that validate each sub-section of the input data is hard to maintain, and it's easy to lose track of an error message or two.
-- Ideally, validation can be performed using an API that enables a new value to be returned yet automatically tracks and accumulates error messages.

另一方面，累积错误列表并在列表非空时失效的常见设计模式也是有问题的。
一个用于验证输入数据的每个子部分的长嵌套 {kw}`if` 语句序列难以维护，而且很容易遗漏一两条错误信息。
理想情况下，可以使用一个 API 来执行验证，该 API 不仅可以返回一个新的值，还能自动跟踪和累积错误信息。

-- An applicative functor called {anchorName Validate}`Validate` provides one way to implement this style of API.
-- Like the {anchorName ApplicativeExcept}`Except` monad, {anchorName Validate}`Validate` allows a new value to be constructed that characterizes the validated data accurately.
-- Unlike {anchorName ApplicativeExcept}`Except`, it allows multiple errors to be accumulated, without a risk of forgetting to check whether the list is empty.

一个名为 {anchorName Validate}`Validate` 的应用函子提供了一种实现这种风格的 API 的方法。
像 {anchorName ApplicativeExcept}`Except` 单子一样，{anchorName Validate}`Validate` 允许构造一个准确描述验证数据的新的值
与 {anchorName ApplicativeExcept}`Except` 不同，它允许累积多个错误，而不必担心忘记检查列表是否为空。

-- ## User Input
## 用户输入
%%%
tag := "user-input"
%%%
-- As an example of user input, take the following structure:

作为用户输入的示例，请考虑以下结构体：

```anchor RawInput
structure RawInput where
  name : String
  birthYear : String
```
-- The business logic to be implemented is the following:
--  1. The name may not be empty
--  2. The birth year must be numeric and non-negative
--  3. The birth year must be greater than 1900, and less than or equal to the year in which the form is validated

要实现的业务逻辑如下：
 1. 姓名不能为空
 2. 出生年份必须是数字且非负
 3. 出生年份必须大于1900，并且小于或等于表单被验证的年份

-- Representing these as a datatype will require a new feature, called _subtypes_.
-- With this tool in hand, a validation framework can be written that uses an applicative functor to track errors, and these rules can be implemented in the framework.

将这些表示为数据类型将会需要一个新功能，称为 _子类型 (Subtype)_。
有了这个工具，可以编写一个使用应用函子来跟踪错误的验证框架，并且可以在框架中实现这些规则。

-- ## Subtypes
## 子类型
%%%
tag := "subtypes"
%%%

-- Representing these conditions is easiest with one additional Lean type, called {anchorName Subtype}`Subtype`:

表示这些条件最简单的方法就是使用 Lean 内一种额外的类型，称为 {anchorName Subtype}`Subtype`：

```anchor Subtype
structure Subtype {α : Type} (p : α → Prop) where
  val : α
  property : p val
```
-- This structure has two type parameters: an implicit parameter that is the type of data {anchorName Subtype}`α`, and an explicit parameter {anchorName Subtype}`p` that is a predicate over {anchorName Subtype}`α`.
-- A _predicate_ is a logical statement with a variable in it that can be replaced with a value to yield an actual statement, like the {ref "overloading-indexing"}[parameter to {moduleName}`GetElem`] that describes what it means for an index to be in bounds for a lookup.
-- In the case of {anchorName Subtype}`Subtype`, the predicate slices out some subset of the values of {anchorName Subtype}`α` for which the predicate holds.
-- The structure's two fields are, respectively, a value from {anchorName Subtype}`α` and evidence that the value satisfies the predicate {anchorName Subtype}`p`.
-- Lean has special syntax for {anchorName Subtype}`Subtype`.
-- If {anchorName Subtype}`p` has type {anchorTerm Subtype}`α → Prop`, then the type {anchorTerm subtypeSugarIn}`Subtype p` can also be written {anchorTerm subtypeSugar}`{x : α // p x}`, or even {anchorTerm subtypeSugar2}`{x // p x}` when the type {anchorName Subtype}`α` can be inferred automatically.

这个结构体有两个类型参数：一个是隐式参数，即数据类型 {anchorName Subtype}`α`，另一个是显式参数 {anchorName Subtype}`p`，它是关于 {anchorName Subtype}`α` 的谓词。
_谓词 (Predicate)_ 是一个包含变量的逻辑语句，可以用值替换该变量以产生实际的语句，就像 {ref "overloading-indexing"}[{moduleName}`GetElem` 的参数] 描述了索引在查找范围内意味着什么一样。
在 {anchorName Subtype}`Subtype` 的情况下，谓词切分出 {anchorName Subtype}`α` 中满足谓词的值的子集。
该结构体的两个字段分别是来自 {anchorName Subtype}`α` 的值和该值满足谓词 {anchorName Subtype}`p` 的证据。
Lean 对 {anchorName Subtype}`Subtype` 有特殊的语法。
如果 {anchorName Subtype}`p` 的类型是 {anchorTerm Subtype}`α → Prop`，那么类型 {anchorTerm subtypeSugarIn}`Subtype p` 也可以写成 {anchorTerm subtypeSugar}`{x : α // p x}`，或者当类型 {anchorName Subtype}`α` 可以自动推断时写成 {anchorTerm subtypeSugar2}`{x // p x}`。

-- {ref "positive-numbers"}[Representing positive numbers as inductive types] is clear and easy to program with.
-- However, it has a key disadvantage.
-- While {anchorName names}`Nat` and {anchorName names}`Int` have the structure of ordinary inductive types from the perspective of Lean programs, the compiler treats them specially and uses fast arbitrary-precision number libraries to implement them.
-- This is not the case for additional user-defined types.
-- However, a subtype of {anchorName names}`Nat` that restricts it to non-zero numbers allows the new type to use the efficient representation while still ruling out zero at compile time:

{ref "positive-numbers"}[将正数表示为归纳类型] 清晰且易于编程。
然而，它有一个关键的缺点。
虽然从 Lean 程序的角度来看，{anchorName names}`Nat` 和 {anchorName names}`Int` 具有普通归纳类型的结构，但编译器会对它们进行特殊处理，并使用快速的任意精度数字库来实现它们。
对于其他用户定义的类型，情况并非如此。
但是，将 {anchorName names}`Nat` 限制为非零数字的子类型允许新类型使用有效的表示形式，同时仍在编译时排除零：

```anchor FastPos
def FastPos : Type := {x : Nat // x > 0}
```

-- The smallest fast positive number is still one.
-- Now, instead of being a constructor of an inductive type, it's an instance of a structure that's constructed with angle brackets.
-- The first argument is the underlying {anchorName FastPos}`Nat`, and the second argument is the evidence that said {anchorName FastPos}`Nat` is greater than zero:

最小的快速正数仍然是一。
现在，它不再是归纳类型的构造函数，而是用尖括号构造的结构体的实例。
第一个参数是底层的 {anchorName FastPos}`Nat`，第二个参数是证明该 {anchorName FastPos}`Nat` 大于零的证据：

```anchor one
def one : FastPos := ⟨1, by decide⟩
```
-- The proposition {anchorTerm onep}`1 > 0` is decidable, so the {tactic}`decide` tactic produces the necessary evidence.
-- The {anchorName OfNatFastPos}`OfNat` instance is very much like that for {anchorName Pos (module:=Examples.Classes)}`Pos`, except it uses a short tactic proof to provide evidence that {lit}`n + 1 > 0`:

命题 {anchorTerm onep}`1 > 0` 是可判定的，因此 {tactic}`decide` 策略会产生必要的证据。
{anchorName OfNatFastPos}`OfNat` 实例非常类似于 {anchorName Pos (module:=Examples.Classes)}`Pos` 的实例，除了它使用简短的策略证明来提供 {lit}`n + 1 > 0` 的证据：

```anchor OfNatFastPos
instance : OfNat FastPos (n + 1) where
  ofNat := ⟨n + 1, by simp⟩
```
-- Here, {tactic}`simp` is needed because {tactic}`decide` requires concrete values, but the proposition in question is {anchorTerm OfNatFastPosp}`n + 1 > 0`.

这里需要 {tactic}`simp`，因为 {tactic}`decide` 需要具体的值，但讨论中的命题是 {anchorTerm OfNatFastPosp}`n + 1 > 0`。

-- Subtypes are a two-edged sword.
-- They allow efficient representation of validation rules, but they transfer the burden of maintaining these rules to the users of the library, who have to _prove_ that they are not violating important invariants.
-- Generally, it's a good idea to use them internally to a library, providing an API to users that automatically ensures that all invariants are satisfied, with any necessary proofs being internal to the library.

子类型是一把双刃剑。
它们允许有效地表示验证规则，但它们将维护这些规则的负担转移给了库的用户，用户必须 _证明_ 他们没有违反重要的不变量。
通常，最好在库内部使用它们，向用户提供一个自动确保满足所有不变量的 API，任何必要的证明都在库内部进行。

-- Checking whether a value of type {anchorName NatFastPosRemarks}`α` is in the subtype {anchorTerm NatFastPosRemarks}`{x : α // p x}` usually requires that the proposition {anchorTerm NatFastPosRemarks}`p x` be decidable.
-- The {ref "equality-and-ordering"}[section on equality and ordering classes] describes how decidable propositions can be used with {kw}`if`.
-- When {kw}`if` is used with a decidable proposition, a name can be provided.
-- In the {kw}`then` branch, the name is bound to evidence that the proposition is true, and in the {kw}`else` branch, it is bound to evidence that the proposition is false.
-- This comes in handy when checking whether a given {anchorName NatFastPos}`Nat` is positive:

检查类型 {anchorName NatFastPosRemarks}`α` 的值是否在子类型 {anchorTerm NatFastPosRemarks}`{x : α // p x}` 中通常需要命题 {anchorTerm NatFastPosRemarks}`p x` 是可判定的。
{ref "equality-and-ordering"}[关于相等和排序类的部分] 描述了如何将可判定命题与 {kw}`if` 一起使用。
当 {kw}`if` 与可判定命题一起使用时，可以提供一个名称。
在 {kw}`then` 分支中，该名称绑定到命题为真的证据，而在 {kw}`else` 分支中，它绑定到命题为假的证据。
这在检查给定的 {anchorName NatFastPos}`Nat` 是否为正数时派上用场：

```anchor NatFastPos
def Nat.asFastPos? (n : Nat) : Option FastPos :=
  if h : n > 0 then
    some ⟨n, h⟩
  else none
```
-- In the {kw}`then` branch, {anchorName NatFastPos}`h` is bound to evidence that {anchorTerm NatFastPos}`n > 0`, and this evidence can be used as the second argument to {anchorName Subtype}`Subtype`'s constructor.

在 {kw}`then` 分支中，{anchorName NatFastPos}`h` 绑定到 {anchorTerm NatFastPos}`n > 0` 的证据，该证据可以用作 {anchorName Subtype}`Subtype` 构造函数的第二个参数。


## Validated Input
## 验证后的输入
%%%
tag := "validated-input"
%%%

-- The validated user input is a structure that expresses the business logic using multiple techniques:
--  * The structure type itself encodes the year in which it was checked for validity, so that {anchorTerm CheckedInputEx}`CheckedInput 2019` is not the same type as {anchorTerm CheckedInputEx}`CheckedInput 2020`
--  * The birth year is represented as a {anchorName CheckedInput}`Nat` rather than a {anchorName CheckedInput}`String`
--  * Subtypes are used to constrain the allowed values in the name and birth year fields

验证后的用户输入是一个使用多种技术表达业务逻辑的结构体：
 * 结构体类型本身编码了检查有效性的年份，因此 {anchorTerm CheckedInputEx}`CheckedInput 2019` 与 {anchorTerm CheckedInputEx}`CheckedInput 2020` 不是同一类型
 * 出生年份表示为 {anchorName CheckedInput}`Nat` 而不是 {anchorName CheckedInput}`String`
 * 子类型用于约束姓名和出生年份字段中的允许值

```anchor CheckedInput
structure CheckedInput (thisYear : Nat) : Type where
  name : {n : String // n ≠ ""}
  birthYear : {y : Nat // y > 1900 ∧ y ≤ thisYear}
```

-- An input validator should take the current year and a {anchorName RawInput}`RawInput` as arguments, returning either a checked input or at least one validation failure.
-- This is represented by the {anchorName Validate}`Validate` type:

输入验证器应将当前年份和 {anchorName RawInput}`RawInput` 作为参数，返回已检查的输入或至少一个验证失败。
这由 {anchorName Validate}`Validate` 类型表示：

```anchor Validate
inductive Validate (ε α : Type) : Type where
  | ok : α → Validate ε α
  | errors : NonEmptyList ε → Validate ε α
```
-- It looks very much like {anchorName ApplicativeExcept}`Except`.
-- The only difference is that the {anchorName Validate}`errors` constructor may contain more than one failure.

它看起来非常像 {anchorName ApplicativeExcept}`Except`。
唯一的区别是 {anchorName Validate}`errors` 构造函数可能包含多个失败。

-- {anchorName Validate}`Validate` is a functor.
-- Mapping a function over it transforms any successful value that might be present, just as in the {anchorName FunctorValidate}`Functor` instance for {anchorName ApplicativeExcept}`Except`:

{anchorName Validate}`Validate` 是一个函子。
在其上映射函数会转换可能存在的任何成功值，就像 {anchorName ApplicativeExcept}`Except` 的 {anchorName FunctorValidate}`Functor` 实例一样：

```anchor FunctorValidate
instance : Functor (Validate ε) where
  map f
   | .ok x => .ok (f x)
   | .errors errs => .errors errs
```

-- The {anchorName ApplicativeValidate}`Applicative` instance for {anchorName ApplicativeValidate}`Validate` has an important difference from the instance for {anchorName ApplicativeExcept}`Except`: while the instance for {anchorName ApplicativeExcept}`Except` terminates at the first error encountered, the instance for {anchorName ApplicativeValidate}`Validate` is careful to accumulate all errors from _both_ the function and the argument branches:

{anchorName ApplicativeValidate}`Validate` 的 {anchorName ApplicativeValidate}`Applicative` 实例与 {anchorName ApplicativeExcept}`Except` 的实例有一个重要的区别：虽然 {anchorName ApplicativeExcept}`Except` 的实例在遇到第一个错误时终止，但 {anchorName ApplicativeValidate}`Validate` 的实例会小心地累积来自 _函数_ 和 _参数_ 分支的所有错误：

```anchor ApplicativeValidate
instance : Applicative (Validate ε) where
  pure := .ok
  seq f x :=
    match f with
    | .ok g => g <$> (x ())
    | .errors errs =>
      match x () with
      | .ok _ => .errors errs
      | .errors errs' => .errors (errs ++ errs')
```

-- Using {anchorName ApplicativeValidate}`.errors` together with the constructor for {anchorName Validate}`NonEmptyList` is a bit verbose.
-- Helpers like {anchorName reportError}`reportError` make code more readable.
-- In this application, error reports will consist of field names paired with messages:

将 {anchorName ApplicativeValidate}`.errors` 与 {anchorName Validate}`NonEmptyList` 的构造函数一起使用有点冗长。
像 {anchorName reportError}`reportError` 这样的辅助函数使代码更具可读性。
在此应用程序中，错误报告将由字段名称与消息配对组成：

```anchor Field
def Field := String
```

```anchor reportError
def reportError (f : Field) (msg : String) : Validate (Field × String) α :=
  .errors { head := (f, msg), tail := [] }
```

-- The {anchorName ApplicativeValidate}`Applicative` instance for {anchorName ApplicativeValidate}`Validate` allows the checking procedures for each field to be written independently and then composed.
-- Checking a name consists of ensuring that a string is non-empty, then returning evidence of this fact in the form of a {anchorName Subtype}`Subtype`.
-- This uses the evidence-binding version of {kw}`if`:

{anchorName ApplicativeValidate}`Validate` 的 {anchorName ApplicativeValidate}`Applicative` 实例允许独立编写每个字段的检查过程，然后进行组合。
检查姓名包括确保字符串非空，然后以 {anchorName Subtype}`Subtype` 的形式返回此事实的证据。
这使用了 {kw}`if` 的证据绑定版本：

```anchor checkName
def checkName (name : String) :
    Validate (Field × String) {n : String // n ≠ ""} :=
  if h : name = "" then
    reportError "name" "Required"
  else pure ⟨name, h⟩
```
-- In the {kw}`then` branch, {anchorName checkName}`h` is bound to evidence that {anchorTerm checkName}`name = ""`, while it is bound to evidence that {lit}`¬name = ""` in the {kw}`else` branch.

在 {kw}`then` 分支中，{anchorName checkName}`h` 绑定到 {anchorTerm checkName}`name = ""` 的证据，而在 {kw}`else` 分支中，它绑定到 {lit}`¬name = ""` 的证据。

-- It's certainly the case that some validation errors make other checks impossible.
-- For example, it makes no sense to check whether the birth year field is greater than 1900 if a confused user wrote the word {anchorTerm checkDavidSyzygy}`"syzygy"` instead of a number.
-- Checking the allowed range of the number is only meaningful after ensuring that the field in fact contains a number.
-- This can be expressed using the function {anchorName ValidateAndThen (show := andThen)}`Validate.andThen`:

确实，某些验证错误使其他检查变得不可能。
例如，如果一个困惑的用户写了单词 {anchorTerm checkDavidSyzygy}`"syzygy"` 而不是数字，那么检查出生年份字段是否大于 1900 就没有意义了。
只有在确保字段实际上包含数字之后，检查数字的允许范围才有意义。
这可以使用函数 {anchorName ValidateAndThen (show := andThen)}`Validate.andThen` 来表达：

```anchor ValidateAndThen
def Validate.andThen (val : Validate ε α)
    (next : α → Validate ε β) : Validate ε β :=
  match val with
  | .errors errs => .errors errs
  | .ok x => next x
```
-- While this function's type signature makes it suitable to be used as {anchorName bindType}`bind` in a {anchorTerm bindType}`Monad` instance, there are good reasons not to do so.
-- They are described {ref "additional-stipulations"}[in the section that describes the {anchorName ApplicativeExcept}`Applicative` contract].

虽然此函数的类型签名使其适合用作 {anchorTerm bindType}`Monad` 实例中的 {anchorName bindType}`bind`，但有充分的理由不这样做。
它们在 {ref "additional-stipulations"}[描述 {anchorName ApplicativeExcept}`Applicative` 契约的部分] 中进行了描述。

-- To check that the birth year is a number, a built-in function called {anchorTerm CheckedInputEx}`String.toNat? : String → Option Nat` is useful.
-- It's most user-friendly to eliminate leading and trailing whitespace first using {anchorName CheckedInputEx}`String.trim`:

为了检查出生年份是否为数字，内置函数 {anchorTerm CheckedInputEx}`String.toNat? : String → Option Nat` 很有用。
最用户友好的做法是首先使用 {anchorName CheckedInputEx}`String.trim` 消除前导和尾随空格：

```anchor checkYearIsNat
def checkYearIsNat (year : String) : Validate (Field × String) Nat :=
  match year.trim.toNat? with
  | none => reportError "birth year" "Must be digits"
  | some n => pure n
```

-- To check that the provided year is in the expected range, nested uses of the evidence-providing form of {kw}`if` are in order:

为了检查提供的年份是否在预期范围内，需要嵌套使用提供证据的 {kw}`if` 形式：

```anchor checkBirthYear
def checkBirthYear (thisYear year : Nat) :
    Validate (Field × String) {y : Nat // y > 1900 ∧ y ≤ thisYear} :=
  if h : year > 1900 then
    if h' : year ≤ thisYear then
      pure ⟨year, by simp [*]⟩
    else reportError "birth year" s!"Must be no later than {thisYear}"
  else reportError "birth year" "Must be after 1900"
```

-- Finally, these three components can be combined using {anchorTerm checkInput}`<*>`:

最后，这三个组件可以使用 {anchorTerm checkInput}`<*>` 组合起来：

```anchor checkInput
def checkInput (year : Nat) (input : RawInput) :
    Validate (Field × String) (CheckedInput year) :=
  pure CheckedInput.mk <*>
    checkName input.name <*>
    (checkYearIsNat input.birthYear).andThen fun birthYearAsNat =>
      checkBirthYear year birthYearAsNat
```

-- Testing {anchorName checkDavid1984}`checkInput` shows that it can indeed return multiple pieces of feedback:

测试 {anchorName checkDavid1984}`checkInput` 表明它确实可以返回多条反馈：

```anchor checkDavid1984
#eval checkInput 2023 {name := "David", birthYear := "1984"}
```
```anchorInfo checkDavid1984
Validate.ok { name := "David", birthYear := 1984 }
```
```anchor checkBlank2045
#eval checkInput 2023 {name := "", birthYear := "2045"}
```
```anchorInfo checkBlank2045
Validate.errors { head := ("name", "Required"), tail := [("birth year", "Must be no later than 2023")] }
```
```anchor checkDavidSyzygy
#eval checkInput 2023 {name := "David", birthYear := "syzygy"}
```
```anchorInfo checkDavidSyzygy
Validate.errors { head := ("birth year", "Must be digits"), tail := [] }
```

-- Form validation with {anchorName checkInput}`checkInput` illustrates a key advantage of {anchorName ApplicativeNames}`Applicative` over {anchorName MonadExtends}`Monad`.
-- Because {lit}`>>=` provides enough power to modify the rest of the program's execution based on the value from the first step, it _must_ receive a value from the first step to pass on.

使用 {anchorName checkInput}`checkInput` 进行表单验证说明了 {anchorName ApplicativeNames}`Applicative` 相比 {anchorName MonadExtends}`Monad` 的一个关键优势。
因为 {lit}`>>=` 提供了足够的能力，可以根据第一步的值来修改程序其余部分的执行，所以它 _必须_ 接收第一步的值才能继续传递。
-- If no value is received (e.g. because an error has occurred), then {lit}`>>=` cannot execute the rest of the program.
-- {anchorName Validate}`Validate` demonstrates why it can be useful to run the rest of the program anyway: in cases where the earlier data isn't needed, running the rest of the program can yield useful information (in this case, more validation errors).
-- {anchorName ApplicativeNames}`Applicative`'s {lit}`<*>` may run both of its arguments before recombining the results.
-- Similarly, {lit}`>>=` forces sequential execution.
-- Each step must complete before the next may run.
-- This is generally useful, but it makes it impossible to have parallel execution of different threads that naturally emerges from the program's actual data dependencies.
-- A more powerful abstraction like {anchorName MonadExtends}`Monad` increases the flexibility that's available to the API consumer, but it decreases the flexibility that is available to the API implementor.

如果没有接收到值（例如，因为发生了错误），那么 {lit}`>>=` 就无法执行程序的其余部分。
{anchorName Validate}`Validate` 证明了为什么无论如何运行程序的其余部分是有用的：在不需要早期数据的情况下，运行程序的其余部分可以产生有用的信息（在这种情况下，是更多的验证错误）。
{anchorName ApplicativeNames}`Applicative` 的 {lit}`<*>` 可以在重新组合结果之前运行其两个参数。
同样，{lit}`>>=` 强制顺序执行。
每个步骤必须在下一个步骤运行之前完成。
这通常很有用，但它使得无法进行不同线程的并行执行，而这种并行执行是从程序的实际数据依赖关系中自然产生的。
像 {anchorName MonadExtends}`Monad` 这样更强大的抽象增加了 API 消费者可用的灵活性，但它减少了 API 实现者可用的灵活性。
