<!--
# Summary
-->

# 总结

<!--
## Evaluating Expressions
-->

## 求值表达式

<!--
In Lean, computation occurs when expressions are evaluated.
This follows the usual rules of mathematical expressions: sub-expressions are replaced by their values following the usual order of operations, until the entire expression has become a value.
When evaluating an `if` or a `match`, the expressions in the branches are not evaluated until the value of the condition or the match subject has been found.
-->

在 Lean 中，计算发生在求值表达式时。这遵循数学表达式的通常规则：
子表达式按照通常的运算顺序替换为其值，直到整个表达式变为一个值。
在求值 `if` 或 `match` 时，分支中的表达式不会被求值，直到找到条件为真或匹配主项的值。

<!--
Once they have been given a value, variables never change.
Similarly to mathematics but unlike most programming languages, Lean variables are simply placeholders for values, rather than addresses to which new values can be written.
Variables' values may come from global definitions with `def`, local definitions with `let`, as named arguments to functions, or from pattern matching.
-->

变量一旦被赋予值，就不会再改变。这与数学类似，但与大多数编程语言不同，
Lean 变量只是值的占位符，而非可以写入新值的位置。变量的值可能来自带有
`def` 的全局定义、带有 `let` 的局部定义、作为函数的命名参数或模式匹配。

<!--
## Functions
-->

## 函数

<!--
Functions in Lean are first-class values, meaning that they can be passed as arguments to other functions, saved in variables, and used like any other value.
Every Lean function takes exactly one argument.
To encode a function that takes more than one argument, Lean uses a technique called currying, where providing the first argument returns a function that expects the remaining arguments.
To encode a function that takes no arguments, Lean uses the `Unit` type, which is the least informative possible argument.
-->

Lean 中的函数是一等的值，这意味着它们可以作为参数传递给其他函数，
保存在变量中，并像任何其他值一样使用。每个 Lean 函数只接受一个参数。
为了对接受多个参数的函数进行编码，Lean 使用了一种称为  **柯里化（Currying）** 的技术，
其中提供第一个参数会返回一个期望剩余参数的函数。为了对不接受任何参数的函数进行编码，
Lean 使用了 `Unit` 类型，这是最没有信息量的可用参数。

<!--
There are three primary ways of creating functions:

1. Anonymous functions are written using `fun`.
   For instance, a function that swaps the fields of a `Point` can be written `{{#example_in Examples/Intro.lean swapLambda}}`
2. Very simple anonymous functions are written by placing one or more centered dots `·` inside of parentheses.
   Each centered dot becomes an argument to the function, and the parentheses delimit its body.
   For instance, a function that subtracts one from its argument can be written as `{{#example_in Examples/Intro.lean subOneDots}}` instead of as `{{#example_out Examples/Intro.lean subOneDots}}`.
3. Functions can be defined using `def` or `let` by adding an argument list or by using pattern-matching notation.
-->

创建函数的主要方法有三种：

1. 匿名函数使用 `fun` 编写。例如，一个交换 `Point` 字段的函数可以写成
   `{{#example_in Examples/Intro.lean swapLambda}}`。
2. 非常简单的匿名函数通过在括号内放置一个或多个间点 `·` 来编写。
   每个间点都是函数的一个参数，括号限定其主体。
   例如，一个从其参数中减去 1 的函数可以写成 `{{#example_in Examples/Intro.lean subOneDots}}`
   而非 `{{#example_out Examples/Intro.lean subOneDots}}`。
3. 函数可以用 `def` 或 `let` 定义，方法是添加参数列表或使用模式匹配记法。

<!--
## Types
-->

## 类型

<!--
Lean checks that every expression has a type.
Types, such as `Int`, `Point`, `{α : Type} → Nat → α → List α`, and `Option (String ⊕ (Nat × String))`, describe the values that may eventually be found for an expression.
Like other languages, types in Lean can express lightweight specifications for programs that are checked by the Lean compiler, obviating the need for certain classes of unit test.
Unlike most languages, Lean's types can also express arbitrary mathematics, unifying the worlds of programming and theorem proving.
While using Lean for proving theorems is mostly out of scope for this book, _[Theorem Proving in Lean 4](https://leanprover.github.io/theorem_proving_in_lean4/)_ contains more information on this topic.
-->

Lean 会检查每个表达式是否具有类型。类型（例如 `Int`、`Point`、`{α : Type} → Nat → α → List α`
和 `Option (String ⊕ (Nat × String))`）描述了表达式最终可能求出的值。
与其他语言一样，Lean 中的类型可以表达由 Lean 编译器所检查的程序的轻量级规范，
从而消除对某些类进行单元测试的需求。与大多数语言不同，Lean 的类型还可以表示任意数学，
统一了编程和定理证明的世界。虽然将 Lean 用于证明定理在很大程度上超出了本书的范围，
但《[Lean 4 定理证明](https://leanprover.github.io/theorem_proving_in_lean4/)》
包含了有关该主题的更多信息。

<!--
Some expressions can be given multiple types.
For instance, `3` can be an `Int` or a `Nat`.
In Lean, this should be understood as two separate expressions, one with type `Nat` and one with type `Int`, that happen to be written in the same way, rather than as two different types for the same thing.
-->

某些表达式可被赋予多种类型。例如，`3` 可以是 `Int` 或 `Nat`。
在 Lean 中，这应该理解为两个独立的表达式，一个类型为 `Nat`，另一个类型为 `Int`，
只是它们碰巧以相同的方式编写，而非同一事物的两种不同类型。

<!--
Lean is sometimes able to determine types automatically, but types must often be provided by the user.
This is because Lean's type system is so expressive.
Even when Lean can find a type, it may not find the desired type—`3` could be intended to be used as an `Int`, but Lean will give it the type `Nat` if there are no further constraints.
In general, it is a good idea to write most types explicitly, only letting Lean fill out the very obvious types.
This improves Lean's error messages and helps make programmer intent more clear.
-->

Lean 有时能够自动确定类型，但类型通常必须由用户提供。
这是因为 Lean 的类型系统非常具有表现力。即使 Lean 可以找到一种类型，
这也可能找不到所需的类型。例如 `3` 可能打算用作 `Int`，但如果没有任何进一步的约束，
Lean 将赋予它 `Nat` 类型。一般来说，最好显式地写出大多数类型，
只让 Lean 填写非常明显的类型。这样能改进 Lean 的错误信息，并有助于使程序员的意图更加清晰。

<!--
Some functions or datatypes take types as arguments.
They are called _polymorphic_.
Polymorphism allows programs such as one that calculates the length of a list without caring what type the entries in the list have.
Because types are first class in Lean, polymorphism does not require any special syntax, so types are passed just like other arguments.
Giving an argument a name in a function type allows later types to mention that argument, and the type of applying that function to an argument is found by replacing the argument's name with the argument's value.
-->

某些函数或数据类型将类型作为参数。它们被称为  **多态（Polymorphic）** 。
多态性能让像计算列表长度这类的程序不必关心列表中条目的类型。
由于类型在 Lean 中是一等公民，因此多态性不需要任何特殊语法，类型就能像其他参数一样传递。
在函数类型中为参数指定名称能让稍后的类型引用该参数，
并且通过将参数的名称替换为参数的值，能够找到该将此函数应用于何种类型的参数。

<!--
## Structures and Inductive Types
-->

## 结构体与归纳类型

<!--
Brand new datatypes can be introduced to Lean using the `structure` or `inductive` features.
These new types are not considered to be equivalent to any other type, even if their definitions are otherwise identical.
Datatypes have _constructors_ that explain the ways in which their values can be constructed, and each constructor takes some number of arguments.
Constructors in Lean are not the same as constructors in object-oriented languages: Lean's constructors are inert holders of data, rather than active code that initializes an allocated object.
-->

可以使用 `structure` 或 `inductive` 特性向 Lean 引入全新的数据类型。
即使它们的定义在其他方面相同，这些新类型也不被认为等同于任何其他类型。
数据类型具有  **构造子（Constructor）** ，解释了可以构造其值的方式，
每个构造子都接受一些参数。Lean 中的构造子与面向对象语言中的构造函数不同：
Lean 的构造子只是数据的单纯持有者，而非初始化已分配对象的活动代码。

<!--
Typically, `structure` is used to introduce a product type (that is, a type with just one constructor that takes any number of arguments), while `inductive` is used to introduce a sum type (that is, a type with many distinct constructors).
Datatypes defined with `structure` are provided with one accessor function for each of the constructor's arguments.
Both structures and inductive datatypes may be consumed with pattern matching, which exposes the values stored inside of constructors using a subset of the syntax used to call said constructors.
Pattern matching means that knowing how to create a value implies knowing how to consume it.
-->

通常，`structure` 用于引入乘积类型（即，只有一个构造子且该构造子可以接受任意数量参数的类型），而 `inductive` "
"用于引入和类型（即，具有多个不同构造子的类型）。使用 `structure` "
"定义的数据类型为构造子的每个参数提供一个访问器函数。结构体和归纳数据类型都可以使用模式匹配来使用，模式匹配使用调用所述构造子的语法的一个子集来公开存储在构造子中的值。模式匹配意味着知道如何创建值就意味着知道如何使用它。

<!--
## Recursion
-->

## 递归

<!--
A definition is recursive when the name being defined is used in the definition itself.
Because Lean is an interactive theorem prover in addition to being a programming language, there are certain restrictions placed on recursive definitions.
In Lean's logical side, circular definitions could lead to logical inconsistency.
-->

当正在定义的名称在定义本身中使用时，定义就是递归的。
由于 Lean 除了是一种编程语言之外，还是一个交互式定理证明器，
因此对递归定义施加了某些限制。在 Lean 的逻辑方面，循环定义可能会导致逻辑不一致。

<!--
In order to ensure that recursive definitions do not undermine the logical side of Lean, Lean must be able to prove that all recursive functions terminate, no matter what arguments they are called with.
In practice, this means either that recursive calls are all performed on a structurally-smaller piece of the input, which ensures that there is always progress towards a base case, or that users must provide some other evidence that the function always terminates.
Similarly, recursive inductive types are not allowed to have a constructor that takes a function _from_ the type as an argument, because this would make it possible to encode non-terminating functions.
-->

为确保递归定义的函数不会破坏 Lean 的逻辑方面，无论使用什么参数调它们，
Lean 都必须能够证明所有函数都会停机。在实践中，这意味着递归调用都会在输入的结构中更小的部分上执行，
这确保了函数始终朝着基本情况推进，或者用户必须提供一些其他证据来证明函数必定会停机。
类似地，递归归纳类型不允许拥有  **从类型中** 接受一个函数作为参数的构造子，
因为这会让 Lean 能够编码不停机的函数。
