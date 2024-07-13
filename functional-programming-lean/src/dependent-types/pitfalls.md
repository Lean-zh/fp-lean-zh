<!-- # Pitfalls of Programming with Dependent Types -->
# 使用依值类型编程的陷阱

<!-- The flexibility of dependent types allows more useful programs to be accepted by a type checker, because the language of types is expressive enough to describe variations that less-expressive type systems cannot.
At the same time, the ability of dependent types to express very fine-grained specifications allows more buggy programs to be rejected by a type checker.
This power comes at a cost. -->
依值类型的灵活性允许类型检查器接受更多有用的程序，因为类型的语言足够表达那些不够表达的变化。
同时，依值类型表达非常精细的规范的能力允许类型检查器拒绝更多有错误的程序。
这种能力是有代价的。

<!-- The close coupling between the internals of type-returning functions such as `Row` and the types that they produce is an instance of a bigger difficulty: the distinction between the interface and the implementation of functions begins to break down when functions are used in types.
Normally, all refactorings are valid as long as they don't change the type signature or input-output behavior of a function.
Functions can be rewritten to use more efficient algorithms and data structures, bugs can be fixed, and code clarity can be improved without breaking client code.
When the function is used in a type, however, the internals of the function's implementation become part of the type, and thus part of the _interface_ to another program. -->
返回类型的函数（如`Row`）的内部与它们生成的类型之间的紧密耦合是一个更大困难的例子：当函数用于类型时，接口和实现之间的区别开始瓦解。
通常，只要不改变函数的类型签名或输入输出行为，所有重构都是有效的。
函数可以重写以使用更高效的算法和数据结构，可以修复错误，可以提高代码的清晰度，而不会破坏客户端代码。
然而，当函数用于类型时，函数实现的内部部分成为类型的一部分，因此成为另一个程序的_接口_的一部分。

<!-- As an example, take the following two implementations of addition on `Nat`.
`Nat.plusL` is recursive on its first argument: -->
以`Nat`上的加法的两个实现为例。
`Nat.plusL`对第一个参数进行递归：
```lean
{{#example_decl Examples/DependentTypes/Pitfalls.lean plusL}}
```
<!-- `Nat.plusR`, on the other hand, is recursive on its second argument: -->
`Nat.plusR`则对第二个参数进行递归：
```lean
{{#example_decl Examples/DependentTypes/Pitfalls.lean plusR}}
```
<!-- Both implementations of addition are faithful to the underlying mathematical concept, and they thus return the same result when given the same arguments. -->
两种加法的实现都忠实于基础数学概念，因此在给定相同参数时返回相同的结果。

<!-- However, these two implementations present quite different interfaces when they are used in types.
As an example, take a function that appends two `Vect`s.
This function should return a `Vect` whose length is the sum of the length of the arguments.
Because `Vect` is essentially a `List` with a more informative type, it makes sense to write the function just as one would for `List.append`, with pattern matching and recursion on the first argument.
Starting with a type signature and initial pattern match pointing at placeholders yields two messages: -->
然而，当这两种实现用于类型时，它们呈现出非常不同的接口。
以一个将两个`Vect`连接起来的函数为例。
这个函数应该返回一个长度为参数长度之和的`Vect`。
因为`Vect`本质上是一个带有更多信息的`List`，所以写这个函数就像为`List.append`写一个一样，使用第一个参数的模式匹配和递归。
从一个类型签名和初始模式匹配指向占位符开始，得到两个消息：

```lean
{{#example_in Examples/DependentTypes/Pitfalls.lean appendL1}}
```
<!-- The first message, in the `nil` case, states that the placeholder should be replaced by a `Vect` with length `plusL 0 k`: -->
第一个消息，在`nil`情况下，指出占位符应该被替换为长度为`plusL 0 k`的`Vect`：
```output error
{{#example_out Examples/DependentTypes/Pitfalls.lean appendL1}}
```
<!-- The second message, in the `cons` case, states that the placeholder should be replaced by a `Vect` with length `plusL (n✝ + 1) k`: -->
第二个消息，在`cons`情况下，指出占位符应该被替换为长度为`plusL (n✝ + 1) k`的`Vect`：
```output error
{{#example_out Examples/DependentTypes/Pitfalls.lean appendL2}}
```
<!-- The symbol after `n`, called a _dagger_, is used to indicate names that Lean has internally invented.
Behind the scenes, pattern matching on the first `Vect` implicitly caused the value of the first `Nat` to be refined as well, because the index on the constructor `cons` is `n + 1`, with the tail of the `Vect` having length `n`.
Here, `n✝` represents the `Nat` that is one less than the argument `n`. -->
`n`后面的符号，称为_剪头符_，用于表示 Lean 内部发明的名称。
在幕后，对第一个`Vect`的模式匹配隐式导致第一个`Nat`的值也被细化，因为构造函数`cons`的索引是`n + 1`，`Vect`的尾部长度为`n`。
在这里，`n✝`表示比参数`n`少一个的`Nat`。


<!-- ## Definitional Equality -->
## 定义相等

<!-- In the definition of `plusL`, there is a pattern case `0, k => k`.
This applies in the length used in the first placeholder, so another way to write the underscore's type `Vect α (Nat.plusL 0 k)` is `Vect α k`.
Similarly, `plusL` contains a pattern case `n + 1, k => plusN n k + 1`.
This means that the type of the second underscore can be equivalently written `Vect α (plusL n✝ k + 1)`. -->
在`plusL`的定义中，有一个模式`0, k => k`。
这适用于第一个占位符中使用的长度，因此另一种写下划线的类型`Vect α (Nat.plusL 0 k)`的方式是`Vect α k`。
类似地，`plusL`包含一个模式`n + 1, k => plusN n k + 1`。
这意味着第二个下划线的类型可以等价地写为`Vect α (plusL n✝ k + 1)`。


<!-- To expose what is going on behind the scenes, the first step is to write the `Nat` arguments explicitly, which also results in daggerless error messages because the names are now written explicitly in the program: -->
为了暴露幕后发生的事情，第一步是显式地写出`Nat`参数，这也导致了没有剪头的错误消息，因为现在在程序中显式地写出了名称：

```lean
{{#example_in Examples/DependentTypes/Pitfalls.lean appendL3}}
```
```output error
{{#example_out Examples/DependentTypes/Pitfalls.lean appendL3}}
```
```output error
{{#example_out Examples/DependentTypes/Pitfalls.lean appendL4}}
```
<!-- Annotating the underscores with the simplified versions of the types does not introduce a type error, which means that the types as written in the program are equivalent to the ones that Lean found on its own: -->
用简化版本的类型注释下划线不会引入类型错误，这意味着程序中写的类型与 Lean 自己找到的类型是等价的：

```lean
{{#example_in Examples/DependentTypes/Pitfalls.lean appendL5}}
```
```output error
{{#example_out Examples/DependentTypes/Pitfalls.lean appendL5}}
```
```output error
{{#example_out Examples/DependentTypes/Pitfalls.lean appendL6}}
```

<!-- The first case demands a `Vect α k`, and `ys` has that type.
This is parallel to the way that appending the empty list to any other list returns that other list.
Refining the definition with `ys` instead of the first underscore yields a program with only one remaining underscore to be filled out: -->
第一个情况要求一个`Vect α k`，而`ys`有这种类型。
这类似于将空列表附加到任何其他列表返回另一个列表的方式。
用`ys`而不是第一个下划线细化定义，得到一个只剩下一个下划线需要填充的程序：

```lean
{{#example_in Examples/DependentTypes/Pitfalls.lean appendL7}}
```
```output error
{{#example_out Examples/DependentTypes/Pitfalls.lean appendL7}}
```

<!-- Something very important has happened here.
In a context where Lean expected a `Vect α (Nat.plusL 0 k)`, it received a `Vect α k`.
However, `Nat.plusL` is not an `abbrev`, so it may seem like it shouldn't be running during type checking.
Something else is happening. -->

这里发生了非常重要的事情。
在 Lean 期望一个`Vect α (Nat.plusL 0 k)`的上下文中，它收到了一个`Vect α k`。
然而，`Nat.plusL`不是一个`abbrev`，所以在类型检查期间似乎不应该运行。
还有其他事情发生了。


<!-- The key to understanding what's going on is that Lean doesn't just expand `abbrev`s while type checking.
It can also perform computation while checking whether two types are equivalent to one another, such that any expression of one type can be used in a context that expects the other type.
This property is called _definitional equality_, and it is subtle. -->
理解发生了什么的关键在于 Lean 不仅在类型检查期间展开`abbrev`。
它还可以在检查两个类型是否等价时执行计算，以便任何一个类型的表达式都可以在期望另一个类型的上下文中使用。
这种属性称为_定义相等_，它是微妙的。

<!-- Certainly, two types that are written identically are considered to be definitionally equal—`Nat` and `Nat` or `List String` and `List String` should be considered equal.
Any two concrete types built from different datatypes are not equal, so `List Nat` is not equal to `Int`.
Additionally, types that differ only by renaming internal names are equal, so `(n : Nat) → Vect String n` is the same as `(k : Nat) → Vect String k`.
Because types can contain ordinary data, definitional equality must also describe when data are equal.
Uses of the same constructors are equal, so `0` equals `0` and `[5, 3, 1]` equals `[5, 3, 1]`. -->
当然，写成相同的两个类型被认为是定义相等的——`Nat`和`Nat`或`List String`和`List String`应该被认为是相等的。
任何两个由不同数据类型构建的具体类型都不相等，因此`List Nat`不等于`Int`。
此外，只有内部名称重命名的类型是相等的，因此`(n : Nat) → Vect String n`与`(k : Nat) → Vect String k`是相同的。
因为类型可以包含普通数据，定义相等还必须描述何时数据是相等的。
使用相同构造函数是相等的，因此`0`等于`0`，`[5, 3, 1]`等于`[5, 3, 1]`。


<!-- Types contain more than just function arrows, datatypes, and constructors, however.
They also contain _variables_ and _functions_.
Definitional equality of variables is relatively simple: each variable is equal only to itself, so `(n k : Nat) → Vect Int n` is not definitionally equal to `(n k : Nat) → Vect Int k`.
Functions, on the other hand, are more complicated.
While mathematics considers two functions to be equal if they have identical input-output behavior, there is no efficient algorithm to check that, and the whole point of definitional equality is for Lean to check whether two types are interchangeable.
Instead, Lean considers functions to be definitionally equal either when they are both `fun`-expressions with definitionally equal bodies.
In other words, two functions must use _the same algorithm_ that calls _the same helpers_ to be considered definitionally equal.
This is not typically very helpful, so definitional equality of functions is mostly used when the exact same defined function occurs in two types. -->
然而，类型不仅包含函数箭头、数据类型和构造函数。
它们还包含_变量_和_函数_。
变量的定义相等相对简单：每个变量只等于自己，因此`(n k : Nat) → Vect Int n`不等于`(n k : Nat) → Vect Int k`。
另一方面，函数更复杂。
虽然数学认为如果两个函数具有相同的输入输出行为，则它们是相等的，但没有有效的算法来检查这一点，定义相等的整个目的是让 Lean 检查两个类型是否可互换。
相反，Lean 认为函数在它们的主体定义相等时是定义相等的。
换句话说，两个函数必须使用_相同的算法_调用_相同的辅助函数_才能被认为是定义相等的。
这通常不是很有用，因此函数的定义相等主要用于当两个类型中出现完全相同的定义函数时。


<!-- When functions are _called_ in a type, checking definitional equality may involve reducing the function call.
The type `Vect String (1 + 4)` is definitionally equal to the type `Vect String (3 + 2)` because `1 + 4` is definitionally equal to `3 + 2`.
To check their equality, both are reduced to `5`, and then the constructor rule can be used five times.
Definitional equality of functions applied to data can be checked first by seeing if they're already the same—there's no need to reduce `["a", "b"] ++ ["c"]` to check that it's equal to `["a", "b"] ++ ["c"]`, after all.
If not, the function is called and replaced with its value, and the value can then be checked. -->
当函数在类型中_调用_时，检查定义相等可能涉及减少函数调用。
类型`Vect String (1 + 4)`与类型`Vect String (3 + 2)`是定义相等的，因为`1 + 4`与`3 + 2`是定义相等的。
为了检查它们的相等性，两者都被减少为`5`，然后构造函数规则可以使用五次。
函数应用于数据的定义相等性首先可以通过查看它们是否已经相同来检查——毕竟，没有必要将`["a", "b"] ++ ["c"]`减少到检查它是否等于`["a", "b"] ++ ["c"]`。
如果不是，函数被调用并替换为它的值，然后可以检查该值。

<!-- Not all function arguments are concrete data.
For example, types may contain `Nat`s that are not built from the `zero` and `succ` constructors.
In the type `(n : Nat) → Vect String n`, the variable `n` is a `Nat`, but it is impossible to know _which_ `Nat` it is before the function is called.
Indeed, the function may be called first with `0`, and then later with `17`, and then again with `33`.
As seen in the definition of `appendL`, variables with type `Nat` may also be passed to functions such as `plusL`.
Indeed, the type `(n : Nat) → Vect String n` is definitionally equal to the type `(n : Nat) → Vect String (Nat.plusL 0 n)`. -->
并非所有函数参数都是具体数据。
例如，类型可能包含不是由`zero`和`succ`构造函数构建的`Nat`。
在类型`(n : Nat) → Vect String n`中，变量`n`是一个`Nat`，但在调用函数之前不可能知道它是_哪个_`Nat`。
实际上，函数可能首先用`0`调用，然后用`17`调用，然后再用`33`调用。
如`appendL`的定义中所见，类型为`Nat`的变量也可以传递给`plusL`等函数。
实际上，类型`(n : Nat) → Vect String n`是类型`(n : Nat) → Vect String (Nat.plusL 0 n)`的定义相等。

<!-- The reason that `n` and `Nat.plusL 0 n` are definitionally equal is that `plusL`'s pattern match examines its _first_ argument.
This is problematic: `(n : Nat) → Vect String n` is _not_ definitionally equal to `(n : Nat) → Vect String (Nat.plusL n 0)`, even though zero should be both a left and a right identity of addition.
This happens because pattern matching gets stuck when it encounters variables.
Until the actual value of `n` becomes known, there is no way to know which case of `Nat.plusL n 0` should be selected. -->
`n` 和 `Nat.plusL 0 n` 是定义相等的原因是 `plusL` 的模式匹配检查它的_第一个_参数。
这是有问题的：`(n : Nat) → Vect String n` _不_等于`(n : Nat) → Vect String (Nat.plusL n 0)`，尽管零应该是加法的左和右单位元。
这是因为模式匹配在遇到变量时会卡住。
在实际值`n`变得已知之前，没有办法知道应该选择`Nat.plusL n 0`的哪种情况。


<!-- The same issue appears with the `Row` function in the query example.
The type `Row (c :: cs)` does not reduce to any datatype because the definition of `Row` has separate cases for singleton lists and lists with at least two entries.
In other words, it gets stuck when trying to match the variable `cs` against concrete `List` constructors.
This is why almost every function that takes apart or constructs a `Row` needs to match the same three cases as `Row` itself: getting it unstuck reveals concrete types that can be used for either pattern matching or constructors. -->
同样的问题出现在查询示例中的`Row`函数中。
类型`Row (c :: cs)`不会减少到任何数据类型，因为`Row`的定义对单例列表和至少有两个条目的列表有单独的情况。
换句话说，当尝试将变量`cs`与具体的`List`构造函数匹配时，它会卡住。
这就是为什么几乎每个拆分或构造`Row`的函数都需要与`Row`本身相同的三种情况：将其解开会显示可以用于模式匹配或构造函数的具体类型。


<!-- The missing case in `appendL` requires a `Vect α (Nat.plusL n k + 1)`.
The `+ 1` in the index suggests that the next step is to use `Vect.cons`: -->
`appendL`中缺失的情况需要一个`Vect α (Nat.plusL n k + 1)`。
索引中的`+ 1`表明下一步是使用`Vect.cons`：

```lean
{{#example_in Examples/DependentTypes/Pitfalls.lean appendL8}}
```
```output error
{{#example_out Examples/DependentTypes/Pitfalls.lean appendL8}}
```
<!-- A recursive call to `appendL` can construct a `Vect` with the desired length: -->
一个对`appendL`的递归调用可以构造一个具有所需长度的`Vect`：

```lean
{{#example_decl Examples/DependentTypes/Pitfalls.lean appendL9}}
```
<!-- Now that the program is finished, removing the explicit matching on `n` and `k` makes it easier to read and easier to call the function: -->
既然程序完成了，删除对`n`和`k`的显式匹配使得它更容易阅读和更容易调用函数：

```lean
{{#example_decl Examples/DependentTypes/Pitfalls.lean appendL}}
```

<!-- Comparing types using definitional equality means that everything involved in definitional equality, including the internals of function definitions, becomes part of the _interface_ of programs that use dependent types and indexed families.
Exposing the internals of a function in a type means that refactoring the exposed program may cause programs that use it to no longer type check.
In particular, the fact that `plusL` is used in the type of `appendL` means that the definition of `plusL` cannot be replaced by the otherwise-equivalent `plusR`. -->
比较类型使用定义相等意味着定义相等中涉及的所有内容，包括函数定义的内部，都成为使用依值类型和索引族的程序的_接口_的一部分。
在类型中暴露函数的内部意味着重构暴露的程序可能导致使用它的程序不再能够进行类型检查。
特别是，`plusL`在`appendL`的类型中使用的事实意味着`plusL`的定义不能被否则等价的`plusR`替换。

<!-- ## Getting Stuck on Addition -->
## 在加法上卡住

<!-- What happens if append is defined with `plusR` instead?
Beginning in the same way, with explicit lengths and placeholder underscores in each case, reveals the following useful error messages: -->
如果使用`plusR`定义`append`会发生什么？
以相同的方式开始，使用显式长度和每种情况中的占位符下划线，会显示以下有用的错误消息：

```lean
{{#example_in Examples/DependentTypes/Pitfalls.lean appendR1}}
```
```output error
{{#example_out Examples/DependentTypes/Pitfalls.lean appendR1}}
```
```output error
{{#example_out Examples/DependentTypes/Pitfalls.lean appendR2}}
```
<!-- However, attempting to place a `Vect α k` type annotation around the first placeholder results in an type mismatch error: -->
然而，尝试在第一个占位符周围放置一个`Vect α k`类型注释会导致类型不匹配错误：

```lean
{{#example_in Examples/DependentTypes/Pitfalls.lean appendR3}}
```
```output error
{{#example_out Examples/DependentTypes/Pitfalls.lean appendR3}}
```
<!-- This error is pointing out that `plusR 0 k` and `k` are _not_ definitionally equal. -->
这个错误指出`plusR 0 k`和`k`_不_是定义相等的。

<!-- This is because `plusR` has the following definition: -->
这是因为`plusR`有以下定义：
```lean
{{#example_decl Examples/DependentTypes/Pitfalls.lean plusR}}
```
<!-- Its pattern matching occurs on the _second_ argument, not the first argument, which means that the presence of the variable `k` in that position prevents it from reducing.
`Nat.add` in Lean's standard library is equivalent to `plusR`, not `plusL`, so attempting to use it in this definition results in precisely the same difficulties: -->
它的模式匹配发生在_第二_个参数上，而不是第一个参数，这意味着该位置的变量`k`的存在阻止了它的减少。
Lean 标准库中的`Nat.add`等价于`plusR`，而不是`plusL`，因此尝试在这个定义中使用它会导致完全相同的困难：
```lean
{{#example_in Examples/DependentTypes/Pitfalls.lean appendR4}}
```
```output error
{{#example_out Examples/DependentTypes/Pitfalls.lean appendR4}}
```

<!-- Addition is getting _stuck_ on the variables.
Getting it unstuck requires [propositional equality](../type-classes/standard-classes.md#equality-and-ordering). -->
加法在变量上_卡住_。
解决它需要[命题相等](../type-classes/standard-classes.md#equality-and-ordering)。

<!-- ## Propositional Equality -->
## 命题相等

<!-- Propositional equality is the mathematical statement that two expressions are equal.
While definitional equality is a kind of ambient fact that Lean automatically checks when required, statements of propositional equality require explicit proofs.
Once an equality proposition has been proved, it can be used in a program to modify a type, replacing one side of the equality with the other, which can unstick the type checker. -->
命题相等是两个表达式相等的数学陈述。
虽然定义相等是 Lean 在需要时自动检查的一种环境事实，但命题相等的陈述需要显式证明。
一旦一个相等命题被证明，它就可以在程序中使用，以修改一个类型，用另一个类型替换相等的一侧，这可以解决类型检查器的卡住问题。

<!-- The reason why definitional equality is so limited is to enable it to be checked by an algorithm.
Propositional equality is much richer, but the computer cannot in general check whether two expressions are propositionally equal, though it can verify that a purported proof is in fact a proof.
The split between definitional and propositional equality represents a division of labor between humans and machines: the most boring equalities are checked automatically as part of definitional equality, freeing the human mind to work on the interesting problems available in propositional equality.
Similarly, definitional equality is invoked automatically by the type checker, while propositional equality must be specifically appealed to. -->
定义相等之所以如此有限，是为了使它能够被算法检查。
命题相等要丰富得多，但计算机通常无法检查两个表达式是否命题相等，尽管它可以验证所谓的证明是否实际上是一个证明。
定义相等和命题相等之间的分裂代表了人类和机器之间的分工：最无聊的相等性作为定义相等的一部分被自动检查，从而使人类思维可以处理命题相等中可用的有趣问题。
同样，定义相等由类型检查器自动调用，而命题相等必须明确地被呼吁。

<!-- In [Propositions, Proofs, and Indexing](../props-proofs-indexing.md), some equality statements are proved using `simp`.
All of these equality statements are ones in which the propositional equality is in fact already a definitional equality.
Typically, statements of propositional equality are proved by first getting them into a form where they are either definitional or close enough to existing proved equalities, and then using tools like `simp` to take care of the simplified cases.
The `simp` tactic is quite powerful: behind the scenes, it uses a number of fast, automated tools to construct a proof.
A simpler tactic called `rfl` specifically uses definitional equality to prove propositional equality.
The name `rfl` is short for _reflexivity_, which is the property of equality that states that everything equals itself. -->
在[命题、证明和索引](../props-proofs-indexing.md)中，一些相等性陈述使用`simp`证明。
所有这些相等性陈述实际上已经是定义相等。
通常，命题相等性的陈述是通过首先将它们变成定义相等或接近现有证明的相等性的形式，然后使用像`simp`这样的工具来处理简化的情况。
`simp`策略非常强大：在幕后，它使用许多快速的自动化工具来构造证明。
一个更简单的策略叫做`rfl`，它专门使用定义相等来证明命题相等。
`rfl`的名称缩写为_反射性_，它是相等性的一个属性，它声明一切都等于自己。


<!-- Unsticking `appendR` requires a proof that `k = Nat.plusR 0 k`, which is not a definitional equality because `plusR` is stuck on the variable in its second argument.
To get it to compute, the `k` must become a concrete constructor.
This is a job for pattern matching. -->
解决`appendR`需要一个证明，即`k = Nat.plusR 0 k`，这不是一个定义相等，因为`plusR`在第二个参数的变量上卡住了。
为了让它计算，`k`必须成为一个具体的构造函数。
这是模式匹配的工作。

<!-- In particular, because `k` could be _any_ `Nat`, this task requires a function that can return evidence that `k = Nat.plusR 0 k` for _any_ `k` whatsoever.
This should be a function that returns a proof of equality, with type `(k : Nat) → k = Nat.plusR 0 k`.
Getting it started with initial patterns and placeholders yields the following messages: -->
特别是，因为`k`可以是_任何_`Nat`，这个任务需要一个函数，它可以返回证据，即`k = Nat.plusR 0 k`对于_任何_`k`都成立。
这应该是一个返回相等性证明的函数，类型为`(k : Nat) → k = Nat.plusR 0 k`。
用初始模式和占位符开始得到以下消息：

```lean
{{#example_in Examples/DependentTypes/Pitfalls.lean plusR_zero_left1}}
```
```output error
{{#example_out Examples/DependentTypes/Pitfalls.lean plusR_zero_left1}}
```
```output error
{{#example_out Examples/DependentTypes/Pitfalls.lean plusR_zero_left2}}
```
<!-- Having refined `k` to `0` via pattern matching, the first placeholder stands for evidence of a statement that does hold definitionally.
The `rfl` tactic takes care of it, leaving only the second placeholder: -->
将`k`通过模式匹配细化为`0`后，第一个占位符代表一个确实是定义相等的陈述的证据。
`rfl`策略处理它，只留下第二个占位符：

```lean
{{#example_in Examples/DependentTypes/Pitfalls.lean plusR_zero_left3}}
```

<!-- The second placeholder is a bit trickier.
The expression `{{#example_in Examples/DependentTypes/Pitfalls.lean plusRStep}}` is definitionally equal to `{{#example_out Examples/DependentTypes/Pitfalls.lean plusRStep}}`.
This means that the goal could also be written `k + 1 = Nat.plusR 0 k + 1`: -->
第二个占位符有点棘手。
表达式`{{#example_in Examples/DependentTypes/Pitfalls.lean plusRStep}}`是定义相等于`{{#example_out Examples/DependentTypes/Pitfalls.lean plusRStep}}`。
这意味着目标也可以写成`k + 1 = Nat.plusR 0 k + 1`：

```lean
{{#example_in Examples/DependentTypes/Pitfalls.lean plusR_zero_left4}}
```
```output error
{{#example_out Examples/DependentTypes/Pitfalls.lean plusR_zero_left4}}
```

<!-- Underneath the `+ 1` on each side of the equality statement is another instance of what the function itself returns.
In other words, a recursive call on `k` would return evidence that `k = Nat.plusR 0 k`.
Equality wouldn't be equality if it didn't apply to function arguments. 
In other words, if `x = y`, then `f x = f y`.
The standard library contains a function `congrArg` that takes a function and an equality proof and returns a new proof where the function has been applied to both sides of the equality.
In this case, the function is `(· + 1)`: -->
在等式陈述的每一侧的`+ 1`下面是函数本身返回的另一个实例。
换句话说，对`k`的递归调用将返回`k = Nat.plusR 0 k`的证据。
如果它不适用于函数参数，那么相等就不是相等。
换句话说，如果`x = y`，那么`f x = f y`。
标准库包含一个函数`congrArg`，它接受一个函数和一个相等性证明，并返回一个新的证明，其中函数已经应用于等式的两侧。
在这种情况下，函数是`(· + 1)`：

```lean
{{#example_decl Examples/DependentTypes/Pitfalls.lean plusR_zero_left_done}}
```

<!-- Propositional equalities can be deployed in a program using the rightward triangle operator `▸`.
Given an equality proof as its first argument and some other expression as its second, this operator replaces instances of the left side of the equality with the right side of the equality in the second argument's type.
In other words, the following definition contains no type errors: -->
命题相等性可以使用右三角运算符`▸`在程序中部署。
给定一个相等性证明作为第一个参数，另一个表达式作为第二个参数，这个运算符将等式的左侧实例替换为等式的右侧实例在第二个参数的类型中。
换句话说，以下定义不包含类型错误：

```lean
{{#example_in Examples/DependentTypes/Pitfalls.lean appendRsubst}}
```
<!-- The first placeholder has the expected type: -->
第一个占位符有预期的类型：

```output error
{{#example_out Examples/DependentTypes/Pitfalls.lean appendRsubst}}
```
<!-- It can now be filled in with `ys`: -->
现在可以用`ys`填充它：

```lean
{{#example_in Examples/DependentTypes/Pitfalls.lean appendR5}}
```

<!-- Filling in the remaining placeholder requires unsticking another instance of addition: -->
填充剩下的占位符需要解决另一个加法的卡住：

```output error
{{#example_out Examples/DependentTypes/Pitfalls.lean appendR5}}
```
<!-- Here, the statement to be proved is that `Nat.plusR (n + 1) k = Nat.plusR n k + 1`, which can be used with `▸` to draw the `+ 1` out to the top of the expression so that it matches the index of `cons`. -->
这里，要证明的陈述是`Nat.plusR (n + 1) k = Nat.plusR n k + 1`，可以使用`▸`将`+ 1`拉到表达式的顶部，使其与`cons`的索引匹配。


<!-- The proof is a recursive function that pattern matches on the second argument to `plusR`, namely `k`.
This is because `plusR` itself pattern matches on its second argument, so the proof can "unstick" it through pattern matching, exposing the computational behavior.
The skeleton of the proof is very similar to that of `plusR_zero_left`:-->

证明是一个递归函数，它在`plusR`的第二个参数上模式匹配，即`k`。
这是因为`plusR`本身在第二个参数上模式匹配，所以证明可以通过模式匹配“解决”它，暴露计算行为。
证明的骨架与`plusR_zero_left`非常相似：

```lean
{{#example_in Examples/DependentTypes/Pitfalls.lean plusR_succ_left_0}}
```

<!-- The remaining case's type is definitionally equal to `Nat.plusR (n + 1) k + 1 = Nat.plusR n (k + 1) + 1`, so it can be solved with `congrArg`, just as in `plusR_zero_left`: -->
剩下的情况的类型在定义上等于`Nat.plusR (n + 1) k + 1 = Nat.plusR n (k + 1) + 1`，因此可以像`plusR_zero_left`一样用`congrArg`解决：

```output error
{{#example_out Examples/DependentTypes/Pitfalls.lean plusR_succ_left_2}}
```
<!-- This results in a finished proof: -->
这导致了一个完成的证明：
```lean
{{#example_decl Examples/DependentTypes/Pitfalls.lean plusR_succ_left}}
```

<!-- The finished proof can be used to unstick the second case in `appendR`: -->
完成的证明可以用来解决`appendR`中的第二种情况：

```lean
{{#example_decl Examples/DependentTypes/Pitfalls.lean appendR}}
```
<!-- When making the length arguments to `appendR` implicit again, they are no longer explicitly named to be appealed to in the proofs.
However, Lean's type checker has enough information to fill them in automatically behind the scenes, because no other values would allow the types to match: -->
当再次使`appendR`的长度参数隐式时，它们不再显式命名以在证明中使用。
然而，Lean 的类型检查器有足够的信息在幕后自动填充它们，因为没有其他值可以使类型匹配：

```lean
{{#example_decl Examples/DependentTypes/Pitfalls.lean appendRImpl}}
```

<!-- ## Pros and Cons -->
## 优势和劣势

<!-- Indexed families have an important property: pattern matching on them affects definitional equality.
For example, in the `nil` case in a `match` expression on a `Vect`, the length simply _becomes_ `0`.
Definitional equality can be very convenient, because it is always active and does not need to be invoked explicitly. -->

索引族有一个重要的属性：对它们进行模式匹配会影响定义相等。
例如，在`Vect`上的`match`表达式中的`nil`情况中，长度简单地_变成_`0`。
定义相等非常方便，因为它总是活动的，不需要显式调用。

<!-- However, the use of definitional equality with dependent types and pattern matching has serious software engineering drawbacks.
First off, functions must be written especially to be used in types, and functions that are convenient to use in types may not use the most efficient algorithms.
Once a function has been exposed through using it in a type, its implementation has become part of the interface, leading to difficulties in future refactoring.
Secondly, definitional equality can be slow.
When asked to check whether two expressions are definitionally equal, Lean may need to run large amounts of code if the functions in question are complicated and have many layers of abstraction.
Third, error messages that result from failures of definitional equality are not always very easy to understand, because they may be phrased in terms of the internals of functions.
It is not always easy to understand the provenance of the expressions in the error messages.
Finally, encoding non-trivial invariants in a collection of indexed families and dependently-typed functions can often be brittle.
It is often necessary to change early definitions in a system when the exposed reduction behavior of functions proves to not provide convenient definitional equalities.
The alternative is to litter the program with appeals to equality proofs, but these can become quite unwieldy. -->
然而，使用依赖类型和模式匹配的定义相等在软件工程上有严重的缺点。
首先，函数必须特别编写以在类型中使用，而在类型中使用方便的函数可能不使用最有效的算法。
一旦一个函数通过在类型中使用它而暴露出来，它的实现就成为接口的一部分，导致未来重构困难。
其次，定义相等可能会很慢。
当要求检查两个表达式是否定义相等时，如果相关函数复杂并且有许多抽象层，Lean 可能需要运行大量代码。
第三，由于错误消息可能以函数的内部为基础，因此由于定义相等的失败而导致的错误消息并不总是很容易理解。
并不总是容易理解错误消息中表达式的来源。
最后，在一组索引族和依赖类型函数中编码非平凡的不变性通常是脆弱的。
当函数的暴露的减少行为证明不能提供方便的定义相等时，通常需要更改系统中的早期定义。
另一种方法是在程序中散布对相等性证明的呼吁，但这可能变得非常笨拙。


<!-- In idiomatic Lean code, indexed datatypes are not used very often.
Instead, subtypes and explicit propositions are typically used to enforce important invariants.
This approach involves many explicit proofs, and very few appeals to definitional equality.
As befits an interactive theorem prover, Lean has been designed to make explicit proofs convenient.
Generally speaking, this approach should be preferred in most cases. -->
在惯用的 Lean 代码中，索引数据类型并不经常使用。
相反，子类型和显式命题通常用于强制重要的不变性。
这种方法涉及许多显式证明，很少涉及定义相等。
与交互式定理证明器相符，Lean 被设计为使显式证明方便。
一般来说，在大多数情况下，应该优先考虑这种方法。

<!-- However, understanding indexed families of datatypes is important.
Recursive functions such as `plusR_zero_left` and `plusR_succ_left` are in fact _proofs by mathematical induction_.
The base case of the recursion corresponds to the base case in induction, and the recursive call represents an appeal to the induction hypothesis.
More generally, new propositions in Lean are often defined as inductive types of evidence, and these inductive types usually have indices.
The process of proving theorems is in fact constructing expressions with these types behind the scenes, in a process not unlike the proofs in this section.
Also, indexed datatypes are sometimes exactly the right tool for the job.
Fluency in their use is an important part of knowing when to use them. -->
然而，理解索引数据类型是重要的。
诸如`plusR_zero_left`和`plusR_succ_left`的递归函数实际上是_数学归纳法的证明_。
递归的基本情况对应于归纳的基本情况，递归调用表示对归纳假设的呼吁。
更一般地说，Lean 中的新命题通常被定义为证据的归纳类型，这些归纳类型通常具有索引。
证明定理的过程实际上是在幕后构造具有这些类型的表达式，这个过程与本节中的证明非常相似。
此外，索引数据类型有时确实是工作的最佳工具。
熟练掌握它们的使用是知道何时使用它们的重要部分。

<!-- ## Exercises -->
## 练习

 <!-- * Using a recursive function in the style of `plusR_succ_left`, prove that for all `Nat`s `n` and `k`, `n.plusR k = n + k`. -->
 * 使用类似于`plusR_succ_left`的递归函数，证明对于所有的`Nat` `n` 和 `k`，`n.plusR k = n + k`。
 <!-- * Write a function on `Vect` for which `plusR` is more natural than `plusL`, where `plusL` would require proofs to be used in the definition. -->
 * 写一个在`Vect`上的函数，其中`plusR`比`plusL`更自然，其中`plusL`需要在定义中使用证明。

