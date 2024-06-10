<!--
# Additional Conveniences
-->

# 其他方便之处

<!--
## Shared Argument Types
-->

## 共享参数类型

<!--
When defining a function that takes multiple arguments that have the same type, both can be written before the same colon.
For example,
-->

定义具有相同类型的多个参数时，可以把它们写在同一个冒号之前。
例如：
```lean
{{#example_decl Examples/Monads/Conveniences.lean equalHuhOld}}
```
<!--
can be written
-->

可以写成
```lean
{{#example_decl Examples/Monads/Conveniences.lean equalHuhNew}}
```
<!--
This is especially useful when the type signature is large.
-->

这在类型签名很长的时候特别有用。

<!--
## Leading Dot Notation
-->

## 开头的点号

<!--
The constructors of an inductive type are in a namespace.
This allows multiple related inductive types to use the same constructor names, but it can lead to programs becoming verbose.
In contexts where the inductive type in question is known, the namespace can be omitted by preceding the constructor's name with a dot, and Lean uses the expected type to resolve the constructor names.
For example, a function that mirrors a binary tree can be written:
-->

一个归纳类型的所有构造子都存在于一个命名空间中。
因此允许不同的归纳类型有同名构造子，但是这也会导致程序变得啰嗦。
当问题中的归纳类型已知时，可以命名空间可以省略，只需要在构造子前保留点号，Lean可以根据该处期望的类型来决定如何选择构造子。
例如将二叉树镜像的函数：
```lean
{{#example_decl Examples/Monads/Conveniences.lean mirrorOld}}
```
<!--
Omitting the namespaces makes it significantly shorter, at the cost of making the program harder to read in contexts like code review tools that don't include the Lean compiler:
-->

省略命名空间使代码显著变短，但代价是在没有Lean编译器，例如code review时，代码会变得难以阅读：
```lean
{{#example_decl Examples/Monads/Conveniences.lean mirrorNew}}
```

<!--
Using the expected type of an expression to disambiguate a namespace is also applicable to names other than constructors.
If `BinTree.empty` is defined as an alternative way of creating `BinTree`s, then it can also be used with dot notation:
-->

通过期望的类型来消除命名空间的歧义，同样可以应用于构造子之外的名称。
例如`BinTree.empty`定义为一种创建`BinTree`的方式，那么它也可以和点号一起使用：
```lean
{{#example_decl Examples/Monads/Conveniences.lean BinTreeEmpty}}

{{#example_in Examples/Monads/Conveniences.lean emptyDot}}
```
```output info
{{#example_out Examples/Monads/Conveniences.lean emptyDot}}
```

<!--
## Or-Patterns
-->

## 或-模式

<!--
In contexts that allow multiple patterns, such as `match`-expressions, multiple patterns may share their result expressions.
The datatype `Weekday` that represents days of the week:
-->

当有多个模式匹配的分支时，例如`match`表达式，那么不同的模式可以共享同一个结果表达式。
表示一周的每一天的类型`Weekday`：
```lean
{{#example_decl Examples/Monads/Conveniences.lean Weekday}}
```

<!--
Pattern matching can be used to check whether a day is a weekend:
-->

可以用模式匹配检查某一天是否是周末：
```lean
{{#example_decl Examples/Monads/Conveniences.lean isWeekendA}}
```
<!--
This can already be simplified by using constructor dot notation:
-->

首先可以用点号来简化：
```lean
{{#example_decl Examples/Monads/Conveniences.lean isWeekendB}}
```
<!--
Because both weekend patterns have the same result expression (`true`), they can be condensed into one:
-->

因为周末的两天都有相同的结果`true`，所以可以精简成：
```lean
{{#example_decl Examples/Monads/Conveniences.lean isWeekendC}}
```
<!--
This can be further simplified into a version in which the argument is not named:
-->

进一步可以简化成没有参数名称的函数：
```lean
{{#example_decl Examples/Monads/Conveniences.lean isWeekendD}}
```

<!--
Behind the scenes, the result expression is simply duplicated across each pattern.
This means that patterns can bind variables, as in this example that removes the `inl` and `inr` constructors from a sum type in which both contain the same type of value:
-->

实际上结果表达式只是简单地被复制。所以模式也可以绑定变量，这个例子在和类型(Sum Type)两边具有相同类型时，将`inl`和`inr`构造子去除：
```lean
{{#example_decl Examples/Monads/Conveniences.lean condense}}
```
<!--
Because the result expression is duplicated, the variables bound by the patterns are not required to have the same types.
Overloaded functions that work for multiple types may be used to write a single result expression that works for patterns that bind variables of different types:
-->

但是因为结果表达式只是被复制，所以模式绑定的变量也可以具有不同类型。
重载的函数可以让同一个结果表达式用于多个绑定不同类型的变量的模式：
```lean
{{#example_decl Examples/Monads/Conveniences.lean stringy}}
```
<!--
In practice, only variables shared in all patterns can be referred to in the result expression, because the result must make sense for each pattern.
In `getTheNat`, only `n` can be accessed, and attempts to use either `x` or `y` lead to errors.
-->

实践中，只有在所有模式都存在的变量才可以在结果表达式中引用，因为这条表达式必须对所有分支都有意义。
`getTheNat`中只有`n`可以被访问，使用`x`或`y`将会导致错误。
```lean
{{#example_decl Examples/Monads/Conveniences.lean getTheNat}}
```
<!--
Attempting to access `x` in a similar definition causes an error because there is no `x` available in the second pattern:
-->

这种类似的情况中访问`x`同样会导致错误，因为`x`在第二个模式中不存在：
```lean
{{#example_in Examples/Monads/Conveniences.lean getTheAlpha}}
```
```output error
{{#example_out Examples/Monads/Conveniences.lean getTheAlpha}}
```

<!--
The fact that the result expression is essentially copy-pasted to each branch of the pattern match can lead to some surprising behavior.
For example, the following definitions are acceptable because the `inr` version of the result expression refers to the global definition of `str`:
-->

简单地对结果表达式进行复制，会导致某些令人惊讶的行为。
例如，下列定义是合法的，因为`inr`分支实际上引用的是全局定义`str`：
```lean
{{#example_decl Examples/Monads/Conveniences.lean getTheString}}
```
<!--
Calling this function on both constructors reveals the confusing behavior.
In the first case, a type annotation is needed to tell Lean which type `β` should be:
-->

在不同分支上调用该函数会让人困惑。
第一种情况中，需要提供类型标记告诉Lean类型`β`是什么：
```lean
{{#example_in Examples/Monads/Conveniences.lean getOne}}
```
```output info
{{#example_out Examples/Monads/Conveniences.lean getOne}}
```
<!--
In the second case, the global definition is used:
-->

第二种情况被使用的是全局定义：
```lean
{{#example_in Examples/Monads/Conveniences.lean getTwo}}
```
```output info
{{#example_out Examples/Monads/Conveniences.lean getTwo}}
```

<!--
Using or-patterns can vastly simplify some definitions and increase their clarity, as in `Weekday.isWeekend`.
Because there is a potential for confusing behavior, it's a good idea to be careful when using them, especially when variables of multiple types or disjoint sets of variables are involved.
-->

使用或-模式可以极大简化某些定义，让它们更加清晰，例如`Weekday.isWeekend`.
但因为存在可能导致困惑的行为，需要十分小心地使用，特别是涉及不同类型的变量，或不相交的变量集合时。

