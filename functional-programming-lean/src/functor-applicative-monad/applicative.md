<!--
# Applicative Functors
-->

# 应用函子

<!--
An _applicative functor_ is a functor that has two additional operations available: `pure` and `seq`.
`pure` is the same operator used in `Monad`, because `Monad` in fact inherits from `Applicative`.
`seq` is much like `map`: it allows a function to be used in order to transform the contents of a datatype.
However, with `seq`, the function is itself contained in the datatype: `{{#example_out Examples/FunctorApplicativeMonad.lean seqType}}`.
Having the function under the type `f` allows the `Applicative` instance to control how the function is applied, while `Functor.map` unconditionally applies a function.
The second argument has a type that begins with `Unit →` to allow the definition of `seq` to short-circuit in cases where the function will never be applied.
-->

**应用函子 (Applicative Functor)** 是一种具有两个附加操作的函子：`pure` 和 `seq`。
`pure` 是 `Monad` 中使用的相同的运算符，因为 `Monad` 实际上继承自 `Applicative`。
`seq` 非常类似于 `map`：它允许使用一个函数来转换数据类型的内容。
然而，在使用 `seq` 时，函数本身也被包含在数据类型中：`{{#example_out Examples/FunctorApplicativeMonad.lean seqType}}`。
将函数置于类型 `f` 之下会允许 `Applicative` 的实例去控制函数被应用的方式，而 `Functor.map` 则无条件地应用函数。
第二个参数的类型以 `Unit →` 开头，以允许在函数永远不会被应用的情况下，定义 `seq` 时短路。

<!--
The value of this short-circuiting behavior can be seen in the instance of `Applicative Option`:
-->

这种短路行为的价值可以在 `Applicative Option` 的实例中看到：

```lean
{{#example_decl Examples/FunctorApplicativeMonad.lean ApplicativeOption}}
```

<!--
In this case, if there is no function for `seq` to apply, then there is no need to compute its argument, so `x` is never called.
The same consideration informs the instance of `Applicative` for `Except`:
-->

在这种情况下，如果没有函数供 `seq` 应用，那么就不需要计算其参数，因此 `x` 永远不会被调用。
同样的考虑也适用于 `Except` 的 `Applicative` 实例。

```lean
{{#example_decl Examples/FunctorApplicativeMonad.lean ApplicativeExcept}}
```

<!--
This short-circuiting behavior depends only on the `Option` or `Except` structures that _surround_ the function, rather than on the function itself.
-->

这种短路行为仅依赖于 **包围** 着函数的 `Option` 或 `Except` 结构体，而不是函数本身。

<!--
Monads can be seen as a way of capturing the notion of sequentially executing statements into a pure functional language.
The result of one statement can affect which further statements run.
This can be seen in the type of `bind`: `{{#example_out Examples/FunctorApplicativeMonad.lean bindType}}`.
The first statement's resulting value is an input into a function that computes the next statement to execute.
Successive uses of `bind` are like a sequence of statements in an imperative programming language, and `bind` is powerful enough to implement control structures like conditionals and loops.
-->

**单子 (Monad)** 可以被看作是一种将按顺序执行语句的概念引入纯函数式语言的方法。
一个语句的结果会影响接下来要执行的语句。
这可以从 `bind` 的类型中看出：`{{#example_out Examples/FunctorApplicativeMonad.lean bindType}}`。
第一个语句的结果值是作为一个函数的输入，该函数会计算下一个要执行的语句。
连续使用 `bind` 类似于命令式编程语言中的语句序列，而且 `bind` 足够强大，可以实现诸如条件语句和循环等控制结构。

<!--
Following this analogy, `Applicative` captures function application in a language that has side effects.
The arguments to a function in languages like Kotlin or C# are evaluated from left to right.
Side effects performed by earlier arguments occur before those performed by later arguments.
A function is not powerful enough to implement custom short-circuiting operators that depend on the specific _value_ of an argument, however.
-->

按照这个类比，`Applicative` 捕获了在具有副作用的语言中函数的应用。
在像 Kotlin 或 C# 这样的语言中，函数的参数是从左到右进行求值的。
较早的参数所执行的副作用在较晚的参数执行的副作用之前发生。
然而，函数不足以实现依赖于参数特定 **值** 的自定义短路运算符。

<!--
Typically, `seq` is not invoked directly.
Instead, the operator `<*>` is used.
This operator wraps its second argument in `fun () => ...`, simplifying the call site.
In other words, `{{#example_in Examples/FunctorApplicativeMonad.lean seqSugar}}` is syntactic sugar for `{{#example_out Examples/FunctorApplicativeMonad.lean seqSugar}}`.
-->

通常情况下，不会直接调用 `seq`。
而是使用运算符 `<*>`。
这个运算符将其第二个参数包装在 `fun () => ...` 中，从而简化了调用位置。
换句话说，`{{#example_in Examples/FunctorApplicativeMonad.lean seqSugar}}` 是 `{{#example_out Examples/FunctorApplicativeMonad.lean seqSugar}}` 的语法糖。

<!--
The key feature that allows `seq` to be used with multiple arguments is that a multiple-argument Lean function is really a single-argument function that returns another function that's waiting for the rest of the arguments.
In other words, if the first argument to `seq` is awaiting multiple arguments, then the result of the `seq` will be awaiting the rest.
For example, `{{#example_in Examples/FunctorApplicativeMonad.lean somePlus}}` can have the type `{{#example_out Examples/FunctorApplicativeMonad.lean somePlus}}`.
Providing one argument, `{{#example_in Examples/FunctorApplicativeMonad.lean somePlusFour}}`, results in the type `{{#example_out Examples/FunctorApplicativeMonad.lean somePlusFour}}`.
This can itself be used with `seq`, so `{{#example_in Examples/FunctorApplicativeMonad.lean somePlusFourSeven}}` has the type `{{#example_out Examples/FunctorApplicativeMonad.lean somePlusFourSeven}}`.
-->

允许 `seq` 与多个参数一起使用的关键特性在于，在 Lean 中的多参数函数实际上是一个单参数函数，该函数会返回另一个正在等待其余参数的函数。
换句话说，如果 `seq` 的第一个参数正在等待多个参数，那么 `seq` 的输出结果将等待其余的参数。
例如，`{{#example_in Examples/FunctorApplicativeMonad.lean somePlus}}` 可以具有类型 `{{#example_out Examples/FunctorApplicativeMonad.lean somePlus}}`。
提供一个参数后，`{{#example_in Examples/FunctorApplicativeMonad.lean somePlusFour}}` 的类型将转变为 `{{#example_out Examples/FunctorApplicativeMonad.lean somePlusFour}}`。
这本身也可以与 `seq` 一起使用，因此 `{{#example_in Examples/FunctorApplicativeMonad.lean somePlusFourSeven}}` 的类型为 `{{#example_out Examples/FunctorApplicativeMonad.lean somePlusFourSeven}}`。

<!--
Not every functor is applicative.
`Pair` is like the built-in product type `Prod`:
```lean
{{#example_decl Examples/FunctorApplicativeMonad.lean Pair}}
```
Like `Except`, `{{#example_in Examples/FunctorApplicativeMonad.lean PairType}}` has type `{{#example_out Examples/FunctorApplicativeMonad.lean PairType}}`.
This means that `Pair α` has type `Type → Type`, and a `Functor` instance is possible:
```lean
{{#example_decl Examples/FunctorApplicativeMonad.lean FunctorPair}}
```
This instance obeys the `Functor` contract.
-->

不是每个函子都是应用函子。
`Pair` 类似于内置的乘积类型 `Prod`：
```lean
{{#example_decl Examples/FunctorApplicativeMonad.lean Pair}}
```
如同 `Except`，`{{#example_in Examples/FunctorApplicativeMonad.lean PairType}}` 的类型是 `{{#example_out Examples/FunctorApplicativeMonad.lean PairType}}`。
这意味着 `Pair α` 的类型是 `Type → Type`，因此可以有一个 `Functor` 实例：
```lean
{{#example_decl Examples/FunctorApplicativeMonad.lean FunctorPair}}
```
此实例遵循 `Functor` 契约。

<!--
The two properties to check are that `{{#example_eval Examples/FunctorApplicativeMonad.lean checkPairMapId 0}} = {{#example_eval Examples/FunctorApplicativeMonad.lean checkPairMapId 2}}` and that `{{#example_eval Examples/FunctorApplicativeMonad.lean checkPairMapComp1 0}} = {{#example_eval Examples/FunctorApplicativeMonad.lean checkPairMapComp2 0}}`.
The first property can be checked by just stepping through the evaluation of the left side, and noticing that it evaluates to the right side:
```lean
{{#example_eval Examples/FunctorApplicativeMonad.lean checkPairMapId}}
```
The second can be checked by stepping through both sides, and noting that they yield the same result:
```lean
{{#example_eval Examples/FunctorApplicativeMonad.lean checkPairMapComp1}}

{{#example_eval Examples/FunctorApplicativeMonad.lean checkPairMapComp2}}
```
-->

要检查的两个属性是 `{{#example_eval Examples/FunctorApplicativeMonad.lean checkPairMapId 0}} = {{#example_eval Examples/FunctorApplicativeMonad.lean checkPairMapId 2}}` 和 `{{#example_eval Examples/FunctorApplicativeMonad.lean checkPairMapComp1 0}} = {{#example_eval Examples/FunctorApplicativeMonad.lean checkPairMapComp2 0}}`。
第一个属性可以通过从左侧的逐步求值直到右侧来检查：
```lean
{{#example_eval Examples/FunctorApplicativeMonad.lean checkPairMapId}}
```
第二个属性可以通过逐步检查两侧来验证，并注意它们产生了相同的结果：
```lean
{{#example_eval Examples/FunctorApplicativeMonad.lean checkPairMapComp1}}

{{#example_eval Examples/FunctorApplicativeMonad.lean checkPairMapComp2}}
```

<!--
Attempting to define an `Applicative` instance, however, does not work so well.
It will require a definition of `pure`:
```lean
{{#example_in Examples/FunctorApplicativeMonad.lean Pairpure}}
```
```output error
{{#example_out Examples/FunctorApplicativeMonad.lean Pairpure}}
```
There is a value with type `β` in scope (namely `x`), and the error message from the underscore suggests that the next step is to use the constructor `Pair.mk`:
```lean
{{#example_in Examples/FunctorApplicativeMonad.lean Pairpure2}}
```
```output error
{{#example_out Examples/FunctorApplicativeMonad.lean Pairpure2}}
```
Unfortunately, there is no `α` available.
Because `pure` would need to work for _all possible types_ α to define an instance of `Applicative (Pair α)`, this is impossible.
After all, a caller could choose `α` to be `Empty`, which has no values at all.
-->

但是，尝试定义一个 `Applicative` 实例的效果并不理想。
它需要 `pure` 的定义：
```lean
{{#example_in Examples/FunctorApplicativeMonad.lean Pairpure}}
```
```output error
{{#example_out Examples/FunctorApplicativeMonad.lean Pairpure}}
```
在当前作用域内有一个类型为 `β` 的值（即 `x`），下划线处的错误信息表明了下一步是使用构造子 `Pair.mk`：
```lean
{{#example_in Examples/FunctorApplicativeMonad.lean Pairpure2}}
```
```output error
{{#example_out Examples/FunctorApplicativeMonad.lean Pairpure2}}
```
不幸的是，没有可用的 `α`。
因为 `pure` 需要适用于 **所有可能的类型** `α` ，才能定义 `Applicative (Pair α)` 的实例，所以这是不可能的。
毕竟，调用者可以选择 `α` 为 `Empty`，而 `Empty` 根本没有任何值。


<!--
## A Non-Monadic Applicative
-->

## 一个非单子的应用函子

<!--
When validating user input to a form, it's generally considered to be best to provide many errors at once, rather than one error at a time.
This allows the user to have an overview of what is needed to please the computer, rather than feeling badgered as they correct the errors field by field.
-->

在验证表单中的用户输入时，通常认为最好一次性提供多个错误，而不是一次提供一个错误。
这样，用户可以大致了解需要做什么才可以满足计算机的要求，而不是逐个对属性地纠正错误时感到烦恼。

<!--
Ideally, validating user input will be visible in the type of the function that's doing the validating.
It should return a datatype that is specific—checking that a text box contains a number should return an actual numeric type, for instance.
A validation routine could throw an exception when the input does not pass validation.
Exceptions have a major drawback, however: they terminate the program at the first error, making it impossible to accumulate a list of errors.
-->

理想情况下，验证用户输入将在执行验证的函数类型中可见。
它应该返回一个特定的数据类型——例如，检验包含数字的文本框是否返回一个实际的数字类型。
验证例程可能会在输入未通过验证时抛出 **异常 (Exception)**。
然而，异常有一个主要缺点：它们在第一个错误出现时终止程序，从而无法累积错误列表。

<!--
On the other hand, the common design pattern of accumulating a list of errors and then failing when it is non-empty is also problematic.
A long nested sequences of `if` statements that validate each sub-section of the input data is hard to maintain, and it's easy to lose track of an error message or two.
Ideally, validation can be performed using an API that enables a new value to be returned yet automatically tracks and accumulates error messages.
-->

另一方面，累积错误列表并在列表非空时失效的常见设计模式也是有问题的。
一个用于验证输入数据的每个子部分的长嵌套 `if` 语句序列难以维护，而且很容易遗漏一两条错误信息。
理想情况下，可以使用一个 API 来执行验证，该 API 不仅可以返回一个新的值，还能自动跟踪和累积错误信息。

<!--
An applicative functor called `Validate` provides one way to implement this style of API.
Like the `Except` monad, `Validate` allows a new value to be constructed that characterizes the validated data accurately.
Unlike `Except`, it allows multiple errors to be accumulated, without a risk of forgetting to check whether the list is empty.
-->

一个名为 `Validate` 的应用函子提供了一种实现这种风格的 API 的方法。
像 `Except` 单子一样，`Validate` 允许构造一个准确描述验证数据的新的值
与 `Except` 不同，它允许累积多个错误，而不必担心忘记检查列表是否为空。


<!--
### User Input
-->

### 用户输入

<!--
As an example of user input, take the following structure:
```lean
{{#example_decl Examples/FunctorApplicativeMonad.lean RawInput}}
```
The business logic to be implemented is the following:
 1. The name may not be empty
 2. The birth year must be numeric and non-negative
 3. The birth year must be greater than 1900, and less than or equal to the year in which the form is validated
-->

作为用户输入的示例，请考虑以下结构体：
```lean
{{#example_decl Examples/FunctorApplicativeMonad.lean RawInput}}
```
要实现的业务逻辑如下：
 1. 姓名不能为空
 2. 出生年份必须是数字且非负
 3. The birth year must be greater than 1900, and less than or equal to the year in which the form is validated 出生年份必须大于1900，并且小于或等于表单被验证的年份
 
<!--
Representing these as a datatype will require a new feature, called _subtypes_.
With this tool in hand, a validation framework can be written that uses an applicative functor to track errors, and these rules can be implemented in the framework.
-->

将这些表示为数据类型将会需要一个新功能，称为 **子类型 (Subtype)**。
有了这个工具，可以编写一个使用应用函子来跟踪错误的验证框架，并且可以在框架中实现这些规则。


<!--
### Subtypes
-->

### 子类型

<!--
Representing these conditions is easiest with one additional Lean type, called `Subtype`:
```lean
{{#example_decl Examples/FunctorApplicativeMonad.lean Subtype}}
```
This structure has two type parameters: an implicit parameter that is the type of data `α`, and an explicit parameter `p` that is a predicate over `α`.
A _predicate_ is a logical statement with a variable in it that can be replaced with a value to yield an actual statement, like the [parameter to `GetElem`](../type-classes/indexing.md#overloading-indexing) that describes what it means for an index to be in bounds for a lookup.
In the case of `Subtype`, the predicate slices out some subset of the values of `α` for which the predicate holds.
The structure's two fields are, respectively, a value from `α` and evidence that the value satisfies the predicate `p`.
Lean has special syntax for `Subtype`.
If `p` has type `α → Prop`, then the type `Subtype p` can also be written `{{#example_out Examples/FunctorApplicativeMonad.lean subtypeSugar}}`, or even `{{#example_out Examples/FunctorApplicativeMonad.lean subtypeSugar2}}` when the type can be inferred automatically.
-->

表示这些条件最简单的方法就是使用 Lean 内一种额外的类型，称为 `Subtype`：
```lean
{{#example_decl Examples/FunctorApplicativeMonad.lean Subtype}}
```
该结构体有两个类型参数：一个隐式参数是数据 `α` 的类型，另一个显式参数 `p` 是 `α` 上的谓词。
**谓词 (Predicate)** 是一个逻辑语句，其中包含一个变量，可以用值替换改变量以生成一个实际的语句，就像 [`GetElem` 的参数](../type-classes/indexing.md#overloading-indexing) 那样，它描述了索引在查找范围内的意义。
在 `Subtype` 的情况下，谓词划分出 `α` 的一些值的子集，且这些值满足谓词的条件。
该结构体的两个属性分别是一个来自 `α` 的值，以及该值满足谓词 `p` 的证据。
Lean 对 `Subtype` 有特殊的语法。
如果 `p` 的类型是 `α → Prop`，那么类型 `Subtype p` 也可以写作 `{{#example_out Examples/FunctorApplicativeMonad.lean subtypeSugar}}`，或者在类型可以被自动推断时，甚至可以写作 `{{#example_out Examples/FunctorApplicativeMonad.lean subtypeSugar2}}`。

<!--
[Representing positive numbers as inductive types](../type-classes/pos.md) is clear and easy to program with.
However, it has a key disadvantage.
While `Nat` and `Int` have the structure of ordinary inductive types from the perspective of Lean programs, the compiler treats them specially and uses fast arbitrary-precision number libraries to implement them.
This is not the case for additional user-defined types.
However, a subtype of `Nat` that restricts it to non-zero numbers allows the new type to use the efficient representation while still ruling out zero at compile time:
```lean
{{#example_decl Examples/FunctorApplicativeMonad.lean FastPos}}
```
-->

[将正数表示为归纳类型](../type-classes/pos.md) 是清晰且易于编程的。
但是，它有一个主要的缺点。
虽然从 Lean 程序的角度来看，`Nat` 和 `Int` 具有普通归纳类型的结构，但编译器会特殊对待它们，并使用快速的任意精度数字库来实现它们。
对于其他用户定义的类型则不是这样的情况。
然而，一个将 `Nat` 限制为非零数的子类型允许新类型使用高效的表示方式，同时在编译时仍然排除零：
```lean
{{#example_decl Examples/FunctorApplicativeMonad.lean FastPos}}
```

<!--
The smallest fast positive number is still one.
Now, instead of being a constructor of an inductive type, it's an instance of a structure that's constructed with angle brackets.
The first argument is the underlying `Nat`, and the second argument is the evidence that said `Nat` is greater than zero:
```leantac
{{#example_decl Examples/FunctorApplicativeMonad.lean one}}
```
The `OfNat` instance is very much like that for `Pos`, except it uses a short tactic proof to provide evidence that `n + 1 > 0`:
```leantac
{{#example_decl Examples/FunctorApplicativeMonad.lean OfNatFastPos}}
```
The `simp_arith` tactic is a version of `simp` that takes additional arithmetic identities into account.
-->

最小的快速正数仍然是 1。
现在，它不再是归纳类型的构造子，而是由尖括号构造的结构实例。
第一个参数是底层的 `Nat`，第二个参数是描述着 `Nat` 大于零的证据：
```leantac
{{#example_decl Examples/FunctorApplicativeMonad.lean one}}
```
`OfNat` 实例十分类似于 `Pos` 实例，只不过它使用了一个简短的策略证明来提供 `n + 1 > 0` 的证据：
```leantac
{{#example_decl Examples/FunctorApplicativeMonad.lean OfNatFastPos}}
```
`simp_arith` 策略是 `simp` 的一个版本，它考虑了额外的算术恒等式。

<!--
Subtypes are a two-edged sword.
They allow efficient representation of validation rules, but they transfer the burden of maintaining these rules to the users of the library, who have to _prove_ that they are not violating important invariants.
Generally, it's a good idea to use them internally to a library, providing an API to users that automatically ensures that all invariants are satisfied, with any necessary proofs being internal to the library.
-->

子类型是一把双刃剑。
它们允许高效地表示验证规则，但它们将维护这些规则的负担转移到了库的使用者身上，使用者必须 **证明** 他们没有违反重要的不变量。
通常，最好在库的内部使用子类型，这为使用者提供了一个自动确保满足所有不变量的API，并且将任何必要的证明放在库的内部去进行处理。

<!--
Checking whether a value of type `α` is in the subtype `{x : α // p x}` usually requires that the proposition `p x` be decidable.
The [section on equality and ordering classes](../type-classes/standard-classes.md#equality-and-ordering) describes how decidable propositions can be used with `if`.
When `if` is used with a decidable proposition, a name can be provided.
In the `then` branch, the name is bound to evidence that the proposition is true, and in the `else` branch, it is bound to evidence that the proposition is false.
This comes in handy when checking whether a given `Nat` is positive:
```lean
{{#example_decl Examples/FunctorApplicativeMonad.lean NatFastPos}}
```
In the `then` branch, `h` is bound to evidence that `n > 0`, and this evidence can be used as the second argument to `Subtype`'s constructor.
-->

检查类型为 `α` 的值是否属于子类型 `{x : α // p x}`，通常需要命题 `p x` 是 **可判定的 (Decidable)**。
[关于相等性和排序类的章节](../type-classes/standard-classes.md#equality-and-ordering) 描述了如何将可判定命题与 `if` 一起使用。
当 `if` 与一个可判定命题一起使用时，可以提供一个名称。
在 `then` 分支中，该名称会与命题为真的证据绑定，在 `else` 分支中，该名称会与命题为假的证据绑定。
这在检查给定的 `Nat` 是否为正数时非常有用：
```lean
{{#example_decl Examples/FunctorApplicativeMonad.lean NatFastPos}}
```
在 `then` 分支中，`h` 会与 `n > 0` 的证据绑定，且这个证据可以用作 `Subtype` 构造子的第二个参数。

<!--
### Validated Input
-->

### 经验证输入

<!--
The validated user input is a structure that expresses the business logic using multiple techniques:
 * The structure type itself encodes the year in which it was checked for validity, so that `CheckedInput 2019` is not the same type as `CheckedInput 2020`
 * The birth year is represented as a `Nat` rather than a `String`
 * Subtypes are used to constrain the allowed values in the name and birth year fields
```lean
{{#example_decl Examples/FunctorApplicativeMonad.lean CheckedInput}}
```
-->

经过验证后的用户输入是一种使用多种技术表达业务逻辑的结构：
 * 结构类型本身编码了被检验了有效性的年份，因此 `CheckedInput 2019` 与 `CheckedInput 2020` 不是相同的类型
 * 出生年份表示为 `Nat` 而不是 `String`
 * 子类型被用来约束名称属性和出生年份属性中的允许值
```lean
{{#example_decl Examples/FunctorApplicativeMonad.lean CheckedInput}}
```

<!--
An input validator should take the current year and a `RawInput` as arguments, returning either a checked input or at least one validation failure.
This is represented by the `Validate` type:
```lean
{{#example_decl Examples/FunctorApplicativeMonad.lean Validate}}
```
It looks very much like `Except`.
The only difference is that the `error` constructor may contain more than one failure.
-->

一个输入验证器应接受当前年份和一个 `RawInput` 作为参数，然后返回一个经检验的输入或者至少一个验证失败。
这由 `Validate` 类型来表示：
```lean
{{#example_decl Examples/FunctorApplicativeMonad.lean Validate}}
```
它看起来很像 `Except`。
唯一的区别是 `error` 构造子可能包含多个失败。

<!--
Validate is a functor.
Mapping a function over it transforms any successful value that might be present, just as in the `Functor` instance for `Except`:
```lean
{{#example_decl Examples/FunctorApplicativeMonad.lean FunctorValidate}}
```
-->

Validate 是一个函子。
将一个函数映射到其上会转换任何可能存在的成功值，就像在 `Except` 的 `Functor` 实例中一样：
```lean
{{#example_decl Examples/FunctorApplicativeMonad.lean FunctorValidate}}
```

<!--
The `Applicative` instance for `Validate` has an important difference from the instance for `Except`: while the instance for `Except` terminates at the first error encountered, the instance for `Validate` is careful to accumulate all errors from _both_ the function and the argument branches:
```lean
{{#example_decl Examples/FunctorApplicativeMonad.lean ApplicativeValidate}}
```
-->

`Validate` 的 `Applicative` 实例与 `Except` 的实例有一个重要的区别：`Except` 的实例会在遇到第一个错误时终止，而 `Validate` 的实例则会小心地累积 **同时** 来自函数和参数分支中的所有错误：
```lean
{{#example_decl Examples/FunctorApplicativeMonad.lean ApplicativeValidate}}
```

<!--
Using `.errors` together with the constructor for `NonEmptyList` is a bit verbose.
Helpers like `reportError` make code more readable.
In this application, error reports will consist of field names paired with messages:
```lean
{{#example_decl Examples/FunctorApplicativeMonad.lean Field}}

{{#example_decl Examples/FunctorApplicativeMonad.lean reportError}}
```
-->

将 `.errors` 与 `NonEmptyList` 的构造子一起使用会有点繁琐。
像 `reportError` 这样的辅助函数可以使代码更易读。
在这个应用中，错误报告将由属性名称和消息一起组成：
```lean
{{#example_decl Examples/FunctorApplicativeMonad.lean Field}}

{{#example_decl Examples/FunctorApplicativeMonad.lean reportError}}
```

<!--
The `Applicative` instance for `Validate` allows the checking procedures for each field to be written independently and then composed.
Checking a name consists of ensuring that a string is non-empty, then returning evidence of this fact in the form of a `Subtype`.
This uses the evidence-binding version of `if`:
```lean
{{#example_decl Examples/FunctorApplicativeMonad.lean checkName}}
```
In the `then` branch, `h` is bound to evidence that `name = ""`, while it is bound to evidence that `¬name = ""` in the `else` branch.
-->

`Validate` 的 `Applicative` 实例允许每个属性的检查过程被独立编写，然后进行组合。
检查一个名称包括着确保字符串非空，然后以 `Subtype` 的形式返回这一事实证据。
这使用了 `if` 的证据绑定的版本：
```lean
{{#example_decl Examples/FunctorApplicativeMonad.lean checkName}}
```
在 `then` 分支中，`h` 绑定着 `name = ""` 的证据，而在 `else` 分支中，它绑定着 `¬name = ""` 的证据。

<!--
It's certainly the case that some validation errors make other checks impossible.
For example, it makes no sense to check whether the birth year field is greater than 1900 if a confused user wrote the word `"syzygy"` instead of a number.
Checking the allowed range of the number is only meaningful after ensuring that the field in fact contains a number.
This can be expressed using the function `andThen`:
```lean
{{#example_decl Examples/FunctorApplicativeMonad.lean ValidateAndThen}}
```
While this function's type signature makes it suitable to be used as `bind` in a `Monad` instance, there are good reasons not to do so.
They are described [in the section that describes the `Applicative` contract](applicative-contract.md#additional-stipulations).
-->

某些验证错误确实会导致其他检查无法进行。
例如，若一个困惑的用户在出生年份的属性处输入了 `"syzygy"` 这个词而不是一个数字，那么检查该属性是否大于 1900 就没有意义。
只有在确保该属性实际上包含一个数字之后，检查数字的允许范围才有意义。
这可以使用函数 `andThen` 来表示：
```lean
{{#example_decl Examples/FunctorApplicativeMonad.lean ValidateAndThen}}
```
虽然这此数的类型签名使其适合作为一个 `Monad` 实例中的 `bind` 去使用，但也有充分的理由不这样做。
这些理由在[描述 `Applicative` 契约的章节](applicative-contract.md#additional-stipulations)中进行了说明。

<!--
To check that the birth year is a number, a built-in function called `String.toNat? : String → Option Nat` is useful.
It's most user-friendly to eliminate leading and trailing whitespace first using `String.trim`:
```lean
{{#example_decl Examples/FunctorApplicativeMonad.lean checkYearIsNat}}
```
To check that the provided year is in the expected range, nested uses of the evidence-providing form of `if` are in order:
```leantac
{{#example_decl Examples/FunctorApplicativeMonad.lean checkBirthYear}}
```
-->

要检查出生年份是否为数字，一个名为 `String.toNat? : String → Option Nat` 的内置函数非常有用。
最方便用户的做法是先使用 `String.trim` 消除前导和尾随的空格：
```lean
{{#example_decl Examples/FunctorApplicativeMonad.lean checkYearIsNat}}
```
为了检验提供的年份是否在预期范围内，需要嵌套使用提供证据形式的 `if` 语句：
```leantac
{{#example_decl Examples/FunctorApplicativeMonad.lean checkBirthYear}}
```

<!--
Finally, these three components can be combined using `seq`:
```lean
{{#example_decl Examples/FunctorApplicativeMonad.lean checkInput}}
```
-->

最后，这三个组件可以使用 `seq` 进行组合：
```lean
{{#example_decl Examples/FunctorApplicativeMonad.lean checkInput}}
```

<!--
Testing `checkInput` shows that it can indeed return multiple pieces of feedback:
```lean
{{#example_in Examples/FunctorApplicativeMonad.lean checkDavid1984}}
```
```output info
{{#example_out Examples/FunctorApplicativeMonad.lean checkDavid1984}}
```
```lean
{{#example_in Examples/FunctorApplicativeMonad.lean checkBlank2045}}
```
```output info
{{#example_out Examples/FunctorApplicativeMonad.lean checkBlank2045}}
```
```lean
{{#example_in Examples/FunctorApplicativeMonad.lean checkDavidSyzygy}}
```
```output info
{{#example_out Examples/FunctorApplicativeMonad.lean checkDavidSyzygy}}
```
-->

测试 `checkInput` 体现了它确实可以返回多条反馈信息：
```lean
{{#example_in Examples/FunctorApplicativeMonad.lean checkDavid1984}}
```
```output info
{{#example_out Examples/FunctorApplicativeMonad.lean checkDavid1984}}
```
```lean
{{#example_in Examples/FunctorApplicativeMonad.lean checkBlank2045}}
```
```output info
{{#example_out Examples/FunctorApplicativeMonad.lean checkBlank2045}}
```
```lean
{{#example_in Examples/FunctorApplicativeMonad.lean checkDavidSyzygy}}
```
```output info
{{#example_out Examples/FunctorApplicativeMonad.lean checkDavidSyzygy}}
```

<!--
Form validation with `checkInput` illustrates a key advantage of `Applicative` over `Monad`.
Because `>>=` provides enough power to modify the rest of the program's execution based on the value from the first step, it _must_ receive a value from the first step to pass on.
If no value is received (e.g. because an error has occurred), then `>>=` cannot execute the rest of the program.
`Validate` demonstrates why it can be useful to run the rest of the program anyway: in cases where the earlier data isn't needed, running the rest of the program can yield useful information (in this case, more validation errors).
`Applicative`'s `<*>` may run both of its arguments before recombining the results.
Similarly, `>>=` forces sequential execution.
Each step must complete before the next may run.
This is generally useful, but it makes it impossible to have parallel execution of different threads that naturally emerges from the program's actual data dependencies.
A more powerful abstraction like `Monad` increases the flexibility that's available to the API consumer, but it decreases the flexibility that is available to the API implementor.
-->

使用 `checkInput` 进行表单验证展示了 `Applicative` 相对于 `Monad` 的一个关键优势。
由于 `>>=` 提供了足够的能力来根据第一步的值修改程序其余部分的执行，所以它 **必须** 接收到第一步的值才能继续。
如果没有接收到值（例如由于一个错误发生了），那么 `>>=` 就无法执行程序的其余部分。
`Validate` 演示了为什么继续运行程序的其余部分可能是有用的：在不需要前面数据的情况下，运行程序的其余部分可以提供有用的信息（在这种情况下，是更多的验证错误）。
`Applicative` 的 `<*>` 可以在重新组合结果之前运行它的两个参数。
类似地，`>>=` 会强制按照顺序执行。
每一步都必须完成后才能运行下一步。
这通常是有用的，但这导致了不可能并行执行那些自然地从程序实际数据依赖中所产生的不同线程。
像 `Monad` 这样更强大的抽象增加了 API 使用者可用的灵活性，但减少了 API 实现者可用的灵活性。