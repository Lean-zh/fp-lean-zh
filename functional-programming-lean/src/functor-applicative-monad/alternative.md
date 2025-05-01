<!--
# Alternatives
-->

# 选择子 { #alternatives }

<!--
## Recovery from Failure
-->

## 从失败中恢复 { #recovery-from-failure }

<!--
`Validate` can also be used in situations where there is more than one way for input to be acceptable.
For the input form `RawInput`, an alternative set of business rules that implement conventions from a legacy system might be the following:

 1. All human users must provide a birth year that is four digits.
 2. Users born prior to 1970 do not need to provide names, due to incomplete older records.
 3. Users born after 1970 must provide names.
 4. Companies should enter `"FIRM"` as their year of birth and provide a company name.
-->
 
`Validate` 还可以用于当输入有多种可接受方式的情况。
对于输入表单 `RawInput`，实现来自遗留系统的约定的替代业务规则集合可能如下：

 1. 所有人类用户必须提供四位数的出生年份。
 2. 由于旧记录不完整，1970年以前出生的用户不需要提供姓名。
 3. 1970年以后出生的用户必须提供姓名。
 4. 公司应输入 `"FIRM"` 作为其出生年份并提供公司名称。
 
<!--
No particular provision is made for users born in 1970.
It is expected that they will either give up, lie about their year of birth, or call.
The company considers this an acceptable cost of doing business.
-->

对于出生于1970年的用户，没有做出特别的规定。
预计他们要么放弃，要么谎报出生年份，要么打电话咨询。
公司认为这是可以接受的经营成本。
 
<!--
The following inductive type captures the values that can be produced from these stated rules:
```lean
{{#example_decl Examples/FunctorApplicativeMonad.lean LegacyCheckedInput}}
```
-->

以下归纳类型捕获了可以从这些既定规则中生成的值：
```lean
{{#example_decl Examples/FunctorApplicativeMonad.lean LegacyCheckedInput}}
```

<!--
A validator for these rules is more complicated, however, as it must address all three cases.
While it can be written as a series of nested `if` expressions, it's easier to design the three cases independently and then combine them.
This requires a means of recovering from failure while preserving error messages:
```lean
{{#example_decl Examples/FunctorApplicativeMonad.lean ValidateorElse}}
```
-->

然而，一个针对这些规则的验证器会更复杂，因为它必须处理所有三种情况。
虽然可以将其写成一系列嵌套的 `if` 表达式，但更容易的方式是独立设计这三种情况，然后再将它们组合起来。
这需要一种在保留错误信息的同时从失败中恢复的方法：
```lean
{{#example_decl Examples/FunctorApplicativeMonad.lean ValidateorElse}}
```

<!--
This pattern of recovery from failures is common enough that Lean has built-in syntax for it, attached to a type class named `OrElse`:
```lean
{{#example_decl Examples/FunctorApplicativeMonad.lean OrElse}}
```
The expression `{{#example_in Examples/FunctorApplicativeMonad.lean OrElseSugar}}` is short for `{{#example_out Examples/FunctorApplicativeMonad.lean OrElseSugar}}`.
An instance of `OrElse` for `Validate` allows this syntax to be used for error recovery:
```lean
{{#example_decl Examples/FunctorApplicativeMonad.lean OrElseValidate}}
```
-->

这种从失败中恢复的模式非常常见，以至于 Lean 为此内置了一种语法，并将其附加到了一个名为 `OrElse` 的类型类上:
```lean
{{#example_decl Examples/FunctorApplicativeMonad.lean OrElse}}
```
表达式 `{{#example_in Examples/FunctorApplicativeMonad.lean OrElseSugar}}` 是 `{{#example_out Examples/FunctorApplicativeMonad.lean OrElseSugar}}` 的简写形式。
`Validate` 的 `OrElse` 实例允许使用这种语法去进行错误恢复：
```lean
{{#example_decl Examples/FunctorApplicativeMonad.lean OrElseValidate}}
```

<!--
The validator for `LegacyCheckedInput` can be built from a validator for each constructor.
The rules for a company state that the birth year should be the string `"FIRM"` and that the name should be non-empty.
The constructor `LegacyCheckedInput.company`, however, has no representation of the birth year at all, so there's no easy way to carry it out using `<*>`.
The key is to use a function with `<*>` that ignores its argument.
-->

`LegacyCheckedInput` 的验证器可以由每个构造子的验证器构建而成。
对于公司的规则，规定了其出生年份应为字符串 `"FIRM"`，且名称应为非空。
然而，构造子 `LegacyCheckedInput.company` 根本没有出生年份的表示，因此无法通过 `<*>` 去轻松执行此操作。
关键是使用一个忽略其参数的函数与 `<*>` 一起使用。

<!--
Checking that a Boolean condition holds without recording any evidence of this fact in a type can be accomplished with `checkThat`:
```lean
{{#example_decl Examples/FunctorApplicativeMonad.lean checkThat}}
```
This definition of `checkCompany` uses `checkThat`, and then throws away the resulting `Unit` value:
```lean
{{#example_decl Examples/FunctorApplicativeMonad.lean checkCompanyProv}}
```
-->

要检查一个布尔条件是否成立，而无需在类型中记录此事实的任何证据，可以通过 `checkThat` 来完成：
```lean
{{#example_decl Examples/FunctorApplicativeMonad.lean checkThat}}
```
这个 `checkCompany` 的定义使用了 `checkThat`，然后丢弃了生成的 `Unit` 值：
```lean
{{#example_decl Examples/FunctorApplicativeMonad.lean checkCompanyProv}}
```

<!--
However, this definition is quite noisy.
It can be simplified in two ways.
The first is to replace the first use of `<*>` with a specialized version that automatically ignores the value returned by the first argument, called `*>`.
This operator is also controlled by a type class, called `SeqRight`, and `{{#example_in Examples/FunctorApplicativeMonad.lean seqRightSugar}}` is syntactic sugar for `{{#example_out Examples/FunctorApplicativeMonad.lean seqRightSugar}}`:
```lean
{{#example_decl Examples/FunctorApplicativeMonad.lean ClassSeqRight}}
```
There is a default implementation of `seqRight` in terms of `seq`: `seqRight (a : f α) (b : Unit → f β) : f β := pure (fun _ x => x) <*> a <*> b ()`.
-->

但是，这个定义相当繁琐。
可以通过两种方式来简化它。
第一种方法是将第一次使用的 `<*>` 替换为一个专门的版本，称为 `*>`，改版本会自动忽略第一个参数所返回的值。
这个运算符也是由一个类型类控制，称为 `SeqRight`，`{{#example_in Examples/FunctorApplicativeMonad.lean seqRightSugar}}` 是 `{{#example_out Examples/FunctorApplicativeMonad.lean seqRightSugar}}` 的语法糖：
```lean
{{#example_decl Examples/FunctorApplicativeMonad.lean ClassSeqRight}}
```
基于 `seq`，`seqRight` 有一个默认实现：`seqRight (a : f α) (b : Unit → f β) : f β := pure (fun _ x => x) <*> a <*> b ()`。

<!--
Using `seqRight`, `checkCompany` becomes simpler:
```lean
{{#example_decl Examples/FunctorApplicativeMonad.lean checkCompanyProv2}}
```
One more simplification is possible.
For every `Applicative`, `pure F <*> E` is equivalent to `f <$> E`.
In other words, using `seq` to apply a function that was placed into the `Applicative` type using `pure` is overkill, and the function could have just been applied using `Functor.map`.
This simplification yields:
```lean
{{#example_decl Examples/FunctorApplicativeMonad.lean checkCompany}}
```
-->

使用 `seqRight` 后，`checkCompany` 变得更简单了：
```lean
{{#example_decl Examples/FunctorApplicativeMonad.lean checkCompanyProv2}}
```
还可以进行进一步简化。
对于每个 `Applicative`，`pure F <*> E` 等价于 `f <$> E`。
换句话说，使用 `seq` 来应用到使用 `pure` 放入 `Applicative` 类型的函数是多余的，这个函数完全可以使用 `Functor.map` 来应用。
这种简化得到的结果是：
```lean
{{#example_decl Examples/FunctorApplicativeMonad.lean checkCompany}}
```

<!--
The remaining two constructors of `LegacyCheckedInput` use subtypes for their fields.
A general-purpose tool for checking subtypes will make these easier to read:
```lean
{{#example_decl Examples/FunctorApplicativeMonad.lean checkSubtype}}
```
In the function's argument list, it's important that the type class `[Decidable (p v)]` occur after the specification of the arguments `v` and `p`.
Otherwise, it would refer to an additional set of automatic implicit arguments, rather than to the manually-provided values.
The `Decidable` instance is what allows the proposition `p v` to be checked using `if`.
-->

`LegacyCheckedInput` 的其余两个构造子在其属性中使用了子类型。
一个用于检查子类型的通用工具将使这些构造函数更易读：
```lean
{{#example_decl Examples/FunctorApplicativeMonad.lean checkSubtype}}
```
在函数的参数列表中，重要的是类型类 `[Decidable (p v)]` 应出现在参数 `v` 和 `p` 的指定之后。
否则，它将引用一组额外的自动隐式参数，而不是手动提供的值。
`Decidable` 实例允许使用 `if` 来检查命题 `p v`。

<!--
The two human cases do not need any additional tools:
```lean
{{#example_decl Examples/FunctorApplicativeMonad.lean checkHumanBefore1970}}

{{#example_decl Examples/FunctorApplicativeMonad.lean checkHumanAfter1970}}
```
-->

这两种人类情况不需要任何额外的工具：
```lean
{{#example_decl Examples/FunctorApplicativeMonad.lean checkHumanBefore1970}}

{{#example_decl Examples/FunctorApplicativeMonad.lean checkHumanAfter1970}}
```

<!--
The validators for the three cases can be combined using `<|>`:
```lean
{{#example_decl Examples/FunctorApplicativeMonad.lean checkLegacyInput}}
```
-->

可以使用 `<|>` 将这三种情况的验证器组合在一起：
```lean
{{#example_decl Examples/FunctorApplicativeMonad.lean checkLegacyInput}}
```

<!--
The successful cases return constructors of `LegacyCheckedInput`, as expected:
```lean
{{#example_in Examples/FunctorApplicativeMonad.lean trollGroomers}}
```
```output info
{{#example_out Examples/FunctorApplicativeMonad.lean trollGroomers}}
```
```lean
{{#example_in Examples/FunctorApplicativeMonad.lean johnny}}
```
```output info
{{#example_out Examples/FunctorApplicativeMonad.lean johnny}}
```
```lean
{{#example_in Examples/FunctorApplicativeMonad.lean johnnyAnon}}
```
```output info
{{#example_out Examples/FunctorApplicativeMonad.lean johnnyAnon}}
```
-->

成功的情况会返回 `LegacyCheckedInput` 的构造子，正如预期的那样：
```lean
{{#example_in Examples/FunctorApplicativeMonad.lean trollGroomers}}
```
```output info
{{#example_out Examples/FunctorApplicativeMonad.lean trollGroomers}}
```
```lean
{{#example_in Examples/FunctorApplicativeMonad.lean johnny}}
```
```output info
{{#example_out Examples/FunctorApplicativeMonad.lean johnny}}
```
```lean
{{#example_in Examples/FunctorApplicativeMonad.lean johnnyAnon}}
```
```output info
{{#example_out Examples/FunctorApplicativeMonad.lean johnnyAnon}}
```

<!--
The worst possible input returns all the possible failures:
```lean
{{#example_in Examples/FunctorApplicativeMonad.lean allFailures}}
```
```output info
{{#example_out Examples/FunctorApplicativeMonad.lean allFailures}}
```
-->

最糟糕的输入会返回所有可能的失败：
```lean
{{#example_in Examples/FunctorApplicativeMonad.lean allFailures}}
```
```output info
{{#example_out Examples/FunctorApplicativeMonad.lean allFailures}}
```


<!--
## The `Alternative` Class
-->

## `Alternative` 类 { #the-alternative-class }

<!--
Many types support a notion of failure and recovery.
The `Many` monad from the section on [evaluating arithmetic expressions in a variety of monads](../monads/arithmetic.md#nondeterministic-search) is one such type, as is `Option`.
Both support failure without providing a reason (unlike, say, `Except` and `Validate`, which require some indication of what went wrong).
-->

许多类型都支持失败和恢复的概念。
[多种单子中对算术表达式的求值](../monads/arithmetic.md#nondeterministic-search)小节中的 `Many` 单子就是其中的一种，`Option` 也是如此。
这两种类型都支持失败但不提供失败的原因的情况（不同于 `Except` 和 `Validate`，它们需要对出错的原因进行某些指示）。

<!--
The `Alternative` class describes applicative functors that have additional operators for failure and recovery:
```lean
{{#example_decl Examples/FunctorApplicativeMonad.lean FakeAlternative}}
```
Just as implementors of `Add α` get `HAdd α α α` instances for free, implementors of `Alternative` get `OrElse` instances for free:
```lean
{{#example_decl Examples/FunctorApplicativeMonad.lean AltOrElse}}
```
-->

`Alternative` 类描述了具有用于失败和恢复的附加运算符的应用函子：
```lean
{{#example_decl Examples/FunctorApplicativeMonad.lean FakeAlternative}}
```
正如 `Add α` 的实现者可以免费获得 `HAdd α α α` 实例一样，`Alternative` 的实现者也可以免费获得 `OrElse` 实例：
```lean
{{#example_decl Examples/FunctorApplicativeMonad.lean AltOrElse}}
```

<!--
The implementation of `Alternative` for `Option` keeps the first none-`none` argument:
```lean
{{#example_decl Examples/FunctorApplicativeMonad.lean AlternativeOption}}
```
Similarly, the implementation for `Many` follows the general structure of `Many.union`, with minor differences due to the laziness-inducing `Unit` parameters being placed differently:
```lean
{{#example_decl Examples/FunctorApplicativeMonad.lean AlternativeMany}}
```
-->

`Option` 的 `Alternative` 实现保留着第一个非 `none` 的参数：
```lean
{{#example_decl Examples/FunctorApplicativeMonad.lean AlternativeOption}}
```
同样，`Many` 的实现遵循着 `Many.union` 的一般结构，由于惰性诱导的 `Unit` 参数放置位置不同，它们仅在一些细节上有所差异：
```lean
{{#example_decl Examples/FunctorApplicativeMonad.lean AlternativeMany}}
```

<!--
Like other type classes, `Alternative` enables the definition of a variety of operations that work for _any_ applicative functor that implements `Alternative`.
One of the most important is `guard`, which causes `failure` when a decidable proposition is false:
```lean
{{#example_decl Examples/FunctorApplicativeMonad.lean guard}}
```
It is very useful in monadic programs to terminate execution early.
In `Many`, it can be used to filter out a whole branch of a search, as in the following program that computes all even divisors of a natural number:
```lean
{{#example_decl Examples/FunctorApplicativeMonad.lean evenDivisors}}
```
Running it on `20` yields the expected results:
```lean
{{#example_in Examples/FunctorApplicativeMonad.lean evenDivisors20}}
```
```output info
{{#example_out Examples/FunctorApplicativeMonad.lean evenDivisors20}}
```
-->

和其他类型类一样，`Alternative` 允许为实现了 `Alternative` 的 **任意** 应用函子定义各种操作。
其中最重要的是 `guard`，当一个可判定的命题为假时，它会导致 `failure`：
```lean
{{#example_decl Examples/FunctorApplicativeMonad.lean guard}}
```
在单子程序中，提前终止执行是非常有用的。
在 `Many` 中，它可以用来过滤掉搜索中的整个分支，如以下程序所示，该程序计算一个自然数的所有偶因数：
```lean
{{#example_decl Examples/FunctorApplicativeMonad.lean evenDivisors}}
```
在 `20` 上运行它会产生预期的结果：
```lean
{{#example_in Examples/FunctorApplicativeMonad.lean evenDivisors20}}
```
```output info
{{#example_out Examples/FunctorApplicativeMonad.lean evenDivisors20}}
```

<!--
## Exercises
-->

## 练习题 { #exercises }

<!--
### Improve Validation Friendliness
-->

### 提高验证的友好性 { #improve-validation-friendliness }

<!--
The errors returned from `Validate` programs that use `<|>` can be difficult to read, because inclusion in the list of errors simply means that the error can be reached through _some_ code path.
A more structured error report can be used to guide the user through the process more accurately:

 * Replace the `NonEmptyList` in `Validate.error` with a bare type variable, and then update the definitions of the `Applicative (Validate ε)` and `OrElse (Validate ε α)` instances to require only that there be an `Append ε` instance available.
 * Define a function `Validate.mapErrors : Validate ε α → (ε → ε') → Validate ε' α` that transforms all the errors in a validation run.
 * Using the datatype `TreeError` to represent errors, rewrite the legacy validation system to track its path through the three alternatives.
 * Write a function `report : TreeError → String` that outputs a user-friendly view of the `TreeError`'s accumulated warnings and errors.
 
```lean
{{#example_decl Examples/FunctorApplicativeMonad.lean TreeError}}
```
-->

使用 `<|>` 的 `Validate` 程序返回的错误可能难以阅读，因为被包含在错误列表中仅意味着通过 **某些** 代码路径可以到达该错误。
可以使用更结构化的错误报告来更准确地指导用户完成这个过程：

 * 将 `Validate.error` 中的 `NonEmptyList` 替换为裸类型变量，然后更新 `Applicative (Validate ε)` 和 `OrElse (Validate ε α)` 实例的定义，以此来仅要求存在一个 `Append ε` 实例。
 * 定义一个函数 `Validate.mapErrors : Validate ε α → (ε → ε') → Validate ε' α`，该函数会转换验证运行中的所有错误。
 * 使用数据类型 `TreeError` 来表示错误，重写遗留验证系统，以通过三种选择子去追踪其路径。
 * 编写一个函数 `report : TreeError → String`，该函数会输出 `TreeError` 的累计警告和错误的用户友好视图。

```lean
{{#example_decl Examples/FunctorApplicativeMonad.lean TreeError}}
```