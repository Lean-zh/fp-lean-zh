<!--
# `do`-Notation for Monads
-->

# 单子的 `do`-记法 { #do-notation-for-monads }

<!--
While APIs based on monads are very powerful, the explicit use of `>>=` with anonymous functions is still somewhat noisy.
Just as infix operators are used instead of explicit calls to `HAdd.hAdd`, Lean provides a syntax for monads called _`do`-notation_ that can make programs that use monads easier to read and write.
This is the very same `do`-notation that is used to write programs in `IO`, and `IO` is also a monad.
-->

基于单子的 API 非常强大，但显式使用 `>>=` 和匿名函数仍然有些繁琐。
正如使用中缀运算符代替显式调用 `HAdd.hAdd` 一样，Lean 提供了一种称为
**`do`-记法** 的单子语法，它可以使使用单子的程序更易于阅读和编写。
这与用于编写 `IO` 程序的 `do`-记法完全相同，而 `IO` 也是一个单子。

<!--
In [Hello, World!](../hello-world.md), the `do` syntax is used to combine `IO` actions, but the meaning of these programs is explained directly.
Understanding how to program with monads means that `do` can now be explained in terms of how it translates into uses of the underlying monad operators.
-->

在 [Hello, World!](../hello-world.md) 中，`do` 语法用于组合 `IO` 活动，
但这些程序的含义是直接解释的。理解如何运用单子进行编程意味着现在可以用
`do` 来解释它如何转换为对底层单子运算符的使用。

<!--
The first translation of `do` is used when the only statement in the `do` is a single expression `E`.
In this case, the `do` is removed, so
-->

当 `do` 中的唯一语句是单个表达式 `E` 时，会使用 `do` 的第一种翻译。
在这种情况下，`do` 被删除，因此

```lean
{{#example_in Examples/Monads/Do.lean doSugar1}}
```

会被翻译为

```lean
{{#example_out Examples/Monads/Do.lean doSugar1}}
```

<!--
The second translation is used when the first statement of the `do` is a `let` with an arrow, binding a local variable.
This translates to a use of `>>=` together with a function that binds that very same variable, so
-->

当 `do` 的第一个语句是带有箭头的 `let` 绑定一个局部变量时，则使用第二种翻译。
它会翻译为使用 `>>=` 以及绑定同一变量的函数，因此

```lean
{{#example_in Examples/Monads/Do.lean doSugar2}}
```

<!--
translates to
-->

会被翻译为

```lean
{{#example_out Examples/Monads/Do.lean doSugar2}}
```

<!--
When the first statement of the `do` block is an expression, then it is considered to be a monadic action that returns `Unit`, so the function matches the `Unit` constructor and
-->

当 `do` 块的第一个语句是一个表达式时，它会被认为是一个返回 `Unit` 的单子操作，
因此该函数匹配 `Unit` 构造子，而

```lean
{{#example_in Examples/Monads/Do.lean doSugar3}}
```

<!--
translates to
-->

会被翻译为

```lean
{{#example_out Examples/Monads/Do.lean doSugar3}}
```

<!--
Finally, when the first statement of the `do` block is a `let` that uses `:=`, the translated form is an ordinary let expression, so
-->

最后，当 `do` 块的第一个语句是使用 `:=` 的 `let` 时，翻译后的形式是一个普通的 let 表达式，因此

```lean
{{#example_in Examples/Monads/Do.lean doSugar4}}
```

<!--
translates to
-->

会被翻译为

```lean
{{#example_out Examples/Monads/Do.lean doSugar4}}
```

<!--
The definition of `firstThirdFifthSeventh` that uses the `Monad` class looks like this:
-->

使用 `Monad` 类的 `firstThirdFifthSeventh` 的定义如下：

```lean
{{#example_decl Examples/Monads/Class.lean firstThirdFifthSeventhMonad}}
```

<!--
Using `do`-notation, it becomes significantly more readable:
-->

使用 `do`-记法，它会变得更加易读：

```lean
{{#example_decl Examples/Monads/Do.lean firstThirdFifthSeventhDo}}
```

<!--
Without the `Monad` type class, the function `number` that numbers the nodes of a tree was written:
-->

若没有 `Monad` 类型，则对树的节点进行编号的函数 `number` 写作如下形式：

```lean
{{#example_decl Examples/Monads.lean numberMonadicish}}
```

有了 `Monad` 和 `do`，其定义就简洁多了：

```lean
{{#example_decl Examples/Monads/Do.lean numberDo}}
```

使用 `do` 与 `IO` 的所有便利性在使用其他单子时也可用。
例如，嵌套操作也适用于任何单子。`mapM` 的原始定义为：

```lean
{{#example_decl Examples/Monads/Class.lean mapM}}
```

<!--
With `do`-notation, it can be written:
-->

使用 `do`-记法，可以写成：

```lean
{{#example_decl Examples/Monads/Do.lean mapM}}
```

<!--
Using nested actions makes it almost as short as the original non-monadic `map`:
-->

使用嵌套活动会让它与原始非单子 `map` 一样简洁：

```lean
{{#example_decl Examples/Monads/Do.lean mapMNested}}
```

<!--
Using nested actions, `number` can be made much more concise:
-->

使用嵌套活动，`number` 可以变得更加简洁：

```lean
{{#example_decl Examples/Monads/Do.lean numberDoShort}}
```

<!--
## Exercises
-->

## 练习 { #exercises }

<!--
 * Rewrite `evaluateM`, its helpers, and the different specific use cases using `do`-notation instead of explicit calls to `>>=`.
 * Rewrite `firstThirdFifthSeventh` using nested actions.
-->

 * 使用 `do`-记法而非显式调用 `>>=` 重写 `evaluateM`、辅助函数以及不同的特定用例。
 * 使用嵌套操作重写 `firstThirdFifthSeventh`。