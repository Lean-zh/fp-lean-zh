<!-- # Summary -->
# 总结

<!-- ## Dependent Types -->
## 依值类型

<!-- Dependent types, where types contain non-type code such as function calls and ordinary data constructors, lead to a massive increase in the expressive power of a type system.
The ability to _compute_ a type from the _value_ of an argument means that the return type of a function can vary based on which argument is provided.
This can be used, for example, to have the result type of a database query depend on the database's schema and the specific query issued, without needing any potentially-failing cast operations on the result of the query.
When the query changes, so does the type that results from running it, enabling immediate compile-time feedback. -->
依值类型，其中类型包含非类型代码，如函数调用和普通数据构造函数，使类型系统的表达能力大大增强。
从参数的值中_计算_类型的能力意味着函数的返回类型可以根据提供的参数而变化。
例如，可以使数据库查询的结果类型取决于数据库的模式和发出的具体查询，而无需对查询结果进行任何可能失败的强制转换操作。
当查询发生变化时，运行它的结果类型也会发生变化，从而实现即时的编译时反馈。

<!-- When a function's return type depends on a value, analyzing the value with pattern matching can result in the type being _refined_, as a variable that stands for a value is replaced by the constructors in the pattern.
The type signature of a function documents the way that the return type depends on the argument value, and pattern matching then explains how the return type can be fulfilled for each potential argument. -->
当函数的返回类型取决于一个值时，使用模式匹配分析值可能导致类型被_细化_，因为代表值的变量被模式中的构造函数替换。
函数的类型签名记录了返回类型如何取决于参数值，然后模式匹配解释了如何为每个潜在参数实现返回类型。

<!-- Ordinary code that occurs in types is run during type checking, though `partial` functions that might loop infinitely are not called.
Mostly, this computation follows the rules of ordinary evaluation that were introduced in [the very beginning of this book](../getting-to-know/evaluating.md), with expressions being progressively replaced by their values until a final value is found.
Computation during type checking has an important difference from run-time computation: some values in types may be _variables_ whose values are not yet known.
In these cases, pattern-matching gets "stuck" and does not proceed until or unless a particular constructor is selected, e.g. by pattern matching.
Type-level computation can be seen as a kind of partial evaluation, where only the parts of the program that are sufficiently known need to be evaluated and other parts are left alone. -->

通常出现在类型中的普通代码在类型检查期间运行，尽管可能无限循环的`partial`函数不会被调用。
大多数情况下，这种计算遵循了[本书开头](../getting-to-know/evaluating.md)介绍的普通评估规则，表达式逐渐被其值替换，直到找到最终值。
类型检查期间的计算与运行时计算有一个重要的区别：类型中的一些值可能是_变量_，其值尚未知道。
在这些情况下，模式匹配会“卡住”，直到或除非选择了特定的构造函数，例如通过模式匹配。
类型级别的计算可以看作是一种部分评估，只有足够已知的程序部分需要被评估，其他部分则保持不变。

<!-- ## The Universe Pattern -->
# 宇宙模式

<!-- A common pattern when working with dependent types is to section off some subset of the type system.
For example, a database query library might be able to return varying-length strings, fixed-length strings, or numbers in certain ranges, but it will never return a function, a user-defined datatype, or an `IO` action.
A domain-specific subset of the type system can be defined by first defining a datatype with constructors that match the structure of the desired types, and then defining a function that interprets values from this datatype into honest-to-goodness types.
The constructors are referred to as _codes_ for the types in question, and the entire pattern is sometimes referred to as a _universe à la Tarski_, or just as a _universe_ when context makes it clear that universes such as `Type 3` or `Prop` are not what's meant. -->
一个在使用依值类型时常见的模式是将类型系统的某个子集分开。
例如，数据库查询库可能能够返回可变长度的字符串、固定长度的字符串或某些范围内的数字，但它永远不会返回函数、用户定义的数据类型或`IO`操作。
可以通过首先定义一个具有与所需类型结构匹配的构造函数的数据类型，然后定义一个函数，将这个数据类型的值解释为真实的类型，来定义类型系统的特定领域子集。
这些构造函数被称为所讨论类型的_codes_，整个模式有时被称为_Tarski风格的宇宙_，或者当上下文清楚地表明不是指`Type 3`或`Prop`等宇宙时，简称为_宇宙_。


<!-- Custom universes are an alternative to defining a type class with instances for each type of interest.
Type classes are extensible, but extensibility is not always desired.
Defining a custom universe has a number of advantages over using the types directly:
 * Generic operations that work for _any_ type in the universe, such as equality testing and serialization, can be implemented by recursion on codes.
 * The types accepted by external systems can be represented precisely, and the definition of the code datatype serves to document what can be expected.
 * Lean's pattern matching completeness checker ensures that no codes are forgotten, while solutions based on type classes defer missing instance errors to client code. -->
自定义宇宙是定义一个类型类，其中包含每种感兴趣类型的实例的替代方法。
类型类是可扩展的，但并非总是需要可扩展性。
定义自定义宇宙相对于直接使用类型具有许多优点：
 * 可以通过对codes进行递归来实现对_任何_宇宙中的类型的通用操作，例如相等性测试和序列化。
 * 可以精确地表示外部系统接受的类型，并且代码数据类型的定义用于记录可以预期的内容。
 * Lean的模式匹配完整性检查器确保没有遗漏codes，而基于类型类的解决方案将缺少实例错误推迟到客户端代码。

<!-- ## Indexed Families -->
## 索引族

<!-- Datatypes can take two separate kinds of arguments: _parameters_ are identical in each constructor of the datatype, while _indices_ may vary between constructors.
For a given choice of index, only some constructors of the datatype are available.
As an example, `Vect.nil` is available only when the length index is `0`, and `Vect.cons` is available only when the length index is `n+1` for some `n`.
While parameters are typically written as named arguments before the colon in a datatype declaration, and indices as arguments in a function type after the colon, Lean can infer when an argument after the colon is used as a parameter. -->
数据类型可以接受两种不同类型的参数：_参数_在数据类型的每个构造函数中都是相同的，而_索引_可能在构造函数之间有所不同。
对于给定的索引选择，数据类型的只有一些构造函数是可用的。
例如，`Vect.nil`仅在长度索引为`0`时可用，而`Vect.cons`仅在长度索引为`n+1`（其中`n`是某个值）时可用。
虽然参数通常在数据类型声明中的冒号前作为命名参数写入，索引作为冒号后函数类型的参数，但 Lean 可以推断冒号后的参数何时被用作参数。

<!-- Indexed families allow the expression of complicated relationships between data, all checked by the compiler.
The datatype's invariants can be encoded directly, and there is no way to violate them, not even temporarily.
Informing the compiler about the datatype's invariants brings a major benefit: the compiler can now inform the programmer about what must be done to satisfy them.
The strategic use of compile-time errors, especially those resulting from underscores, can make it possible to offload some of the programming thought process to Lean, freeing up the programmer's mind to worry about other things. -->
索引族允许表达数据之间的复杂关系，所有这些关系都由编译器检查。
数据类型的不变性可以直接编码，甚至没有临时违反它们的方法。
向编译器提供关于数据类型不变性的信息带来了一个重大好处：编译器现在可以告诉程序员必须做什么才能满足这些不变性。
编译时错误的战略使用，特别是由下划线导致的错误，可以使一些编程思维过程转移到 Lean，从而使程序员的思维空间可以用于担心其他事情。

<!-- Encoding invariants using indexed families can lead to difficulties.
First off, each invariant requires its own datatype, which then requires its own support libraries.
`List.append` and `Vect.append` are not interchangeable, after all.
This can lead to code duplication.
Secondly, convenient use of indexed families requires that the recursive structure of functions used in types match the recursive structure of the programs being type checked.
Programming with indexed families is the art of arranging for the right coincidences to occur.
While it's possible to work around missing coincidences with appeals to equality proofs, it is difficult, and it leads to programs littered with cryptic justifications.
Thirdly, running complicated code on large values during type checking can lead to compile-time slowdowns.
Avoiding these slowdowns for complicated programs can require specialized techniques. -->
使用索引族编码不变性可能会导致困难。
首先，每个不变性都需要自己的数据类型，然后需要自己的支持库。
毕竟，`List.append` 和 `Vect.append` 是不能互换的。
这可能导致代码重复。
其次，方便使用索引族需要在类型检查的程序的递归结构与递归结构匹配。
使用索引族编程是安排正确的巧合发生的艺术。
虽然可以通过引用相等性证明来解决缺少的巧合，但这很困难，并且会导致程序中充斥着晦涩的理由。
第三，类型检查期间在大值上运行复杂代码可能导致编译时减速。
避免这些复杂程序的减速可能需要专门的技术。


<!-- ## Definitional and Propositional Equality -->
## 定义相等和命题相等

<!-- Lean's type checker must, from time to time, check whether two types should be considered interchangeable.
Because types can contain arbitrary programs, it must therefore be able to check arbitrary programs for equality.
However, there is no efficient algorithm to check arbitrary programs for fully-general mathematical equality.
To work around this, Lean contains two notions of equality: -->

Lean的类型检查器必须不时检查两个类型是否应该被视为可互换的。
因为类型可以包含任意程序，所以它必须能够检查任意程序的相等性。
然而，没有有效的算法可以检查任意程序的完全一般的数学相等性。
为了解决这个问题，Lean 包含了两种相等性概念：

 <!-- * _Definitional equality_ is an underapproximation of equality that essentially checks for equality of syntactic representation modulo computation and renaming of bound variables. Lean automatically checks for definitional equality in situations where it is required. -->
 * 定义相等 是一个对相等的低估，本质上检查语法表示的相等性，忽略计算和绑定变量的重命名。Lean 在需要时会自动检查定义相等。

 <!-- * _Propositional equality_ must be explicitly proved and explicitly invoked by the programmer. In return, Lean automatically checks that the proofs are valid and that the invocations accomplish the right goal. -->
 * 命题相等 必须由程序员显式证明和显式调用。作为回报，Lean 自动检查证明是否有效，并检查调用是否实现了正确的目标。

<!-- The two notions of equality represent a division of labor between programmers and Lean itself.
Definitional equality is simple, but automatic, while propositional equality is manual, but expressive.
Propositional equality can be used to unstick otherwise-stuck programs in types. -->
这两种相等性概念代表了程序员和 Lean 之间的分工。
定义相等简单但自动，而命题相等是手动的但表达力强。
命题相等可以用于解决类型中的其他卡住的程序。

<!-- However, the frequent use of propositional equality to unstick type-level computation is typically a code smell.
It typically means that coincidences were not well-engineered, and it's usually a better idea to either redesign the types and indices or to use a different technique to enforce the needed invariants.
When propositional equality is instead used to prove that a program meets a specification, or as part of a subtype, there is less reason to be suspicious. -->
然和人们经常使用命题相等来解决类型级别的计算通常是一种代码异味。
这通常意味着巧合没有很好地设计，通常最好的想法是重新设计类型和索引，或者使用不同的技术来强制执行所需的不变性。
当命题相等被用来证明程序满足规范，或作为子类型的一部分时，就没有理由怀疑了。
