<!--
# Types
-->

# 类型

<!--
Types classify programs based on the values that they can
compute. Types serve a number of roles in a program:

 1. They allow the compiler to make decisions about the in-memory
    representation of a value.

 2. They help programmers to communicate their intent to others,
    serving as a lightweight specification for the inputs and outputs
    of a function that the compiler can ensure the program adheres to.

 3. They prevent various potential mistakes, such as adding a number
    to a string, and thus reduce the number of tests that are
    necessary for a program.

 4. They help the Lean compiler automate the production of auxiliary code that can save boilerplate.
-->

类型根据程序可以计算的值对程序进行分类。类型在程序中扮演着多种角色：

 1. 可以让编译器对值在内存中的表示做出决策。

 2. 帮助程序员向他人传达他们的意图，作为函数输入和输出的轻量级规范，
    编译器可以确保程序遵守该规范。

 3. 防止各种潜在错误，例如将数字加到字符串上，从而减少程序所需的测试数量。

 4. 帮助 Lean 编译器自动生成辅助代码，可以节省样板代码。

<!--
Lean's type system is unusually expressive.
Types can encode strong specifications like "this sorting function returns a permutation of its input" and flexible specifications like "this function has different return types, depending on the value of its argument".
The type system can even be used as a full-blown logic for proving mathematical theorems.
This cutting-edge expressive power doesn't obviate the need for simpler types, however, and understanding these simpler types is a prerequisite for using the more advanced features.
-->

Lean 的类型系统具有非同寻常的表现力。类型可以编码强规范，
如「此排序函数返回其输入的排列」，以及灵活的规范，
如「此函数具有不同的返回类型，具体取决于其参数的值」。
类型系统甚至可以用作证明数学定理的完整逻辑系统。
然而，这种尖端的表现力并不能消除对更简单类型的需求，
理解这些更简单的类型是使用更高级功能的先决条件。

<!--
Every program in Lean must have a type. In particular, every
expression must have a type before it can be evaluated. In the
examples so far, Lean has been able to discover a type on its own, but
it is sometimes necessary to provide one. This is done using the colon
operator:
-->

Lean 中的每个程序都必须有一个类型。特别是，每个表达式在求值之前都必须具有类型。
在迄今为止的示例中，Lean 已经能够自行发现类型，但有时也需要提供一个类型。
这是使用冒号运算符完成的：

```lean
#eval {{#example_in Examples/Intro.lean onePlusTwoType}}
```

<!--
Here, `Nat` is the type of _natural numbers_, which are arbitrary-precision unsigned integers.
In Lean, `Nat` is the default type for non-negative integer literals.
This default type is not always the best choice.
In C, unsigned integers underflow to the largest representable numbers when subtraction would otherwise yield a result less than zero.
`Nat`, however, can represent arbitrarily-large unsigned numbers, so there is no largest number to underflow to.
Thus, subtraction on `Nat` returns `0` when the answer would have otherwise been negative.
For instance,
-->

在这里，`Nat` 是  **自然数** 的类型，它们是任意精度的无符号整数。在 Lean 中，`Nat`
是非负整数字面量的默认类型。此默认类型并不总是最佳选择。
在 C 中，当减法运算结果小于零时，无符号整数会下溢到最大的可表示数字。然而，`Nat`
可以表示任意大的无符号数字，因此没有最大的数字可以下溢到。
因此，当答案原本为负数时，`Nat` 上的减法运算返回 `0`。例如，

```lean
#eval {{#example_in Examples/Intro.lean oneMinusTwo}}
```

<!--
evaluates to `{{#example_out Examples/Intro.lean oneMinusTwo}}` rather
than `-1`. To use a type that can represent the negative integers,
provide it directly:
-->

求值为 `{{#example_out Examples/Intro.lean oneMinusTwo}}` 而非 `-1`。
若要使用可以表示负整数的类型，请直接提供它：

```lean
#eval {{#example_in Examples/Intro.lean oneMinusTwoInt}}
```

<!--
With this type, the result is `{{#example_out Examples/Intro.lean oneMinusTwoInt}}`, as expected.
-->

使用此类型，结果为 `{{#example_out Examples/Intro.lean oneMinusTwoInt}}`，符合预期。

<!--
To check the type of an expression without evaluating it, use `#check`
instead of `#eval`. For instance:
-->

若要检查表达式的类型而不求值，请使用 `#check` 而不是 `#eval`。例如：

```lean
{{#example_in Examples/Intro.lean oneMinusTwoIntType}}
```

<!--
reports `{{#example_out Examples/Intro.lean oneMinusTwoIntType}}` without actually performing the subtraction.
-->

会报告 `{{#example_out Examples/Intro.lean oneMinusTwoIntType}}` 而不会实际执行减法运算。

<!--
When a program can't be given a type, an error is returned from both
`#check` and `#eval`. For instance:
-->

当无法为程序指定类型时，`#check` 和 `#eval` 都会返回错误。例如：

```lean
{{#example_in Examples/Intro.lean stringAppendList}}
```

<!--
outputs
-->

会输出

```output error
{{#example_out Examples/Intro.lean stringAppendList}}
```

```output error
应用程序类型不匹配"
  String.append "hello" [" ", "world"]
参数
  [" ", "world"]
类型为
  List String : Type
但预期类型为
  String : Type
```

<!--
because the second argument to ``String.append`` is expected to be a
string, but a list of strings was provided instead.
-->

因为 ``String.append`` 的第二个参数应为字符串，但提供的是字符串列表。
