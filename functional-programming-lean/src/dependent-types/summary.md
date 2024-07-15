<!-- # Summary -->
# 总结

<!-- ## Dependent Types -->
## 依值类型

<!-- Dependent types, where types contain non-type code such as function calls and ordinary data constructors, lead to a massive increase in the expressive power of a type system.
The ability to _compute_ a type from the _value_ of an argument means that the return type of a function can vary based on which argument is provided.
This can be used, for example, to have the result type of a database query depend on the database's schema and the specific query issued, without needing any potentially-failing cast operations on the result of the query.
When the query changes, so does the type that results from running it, enabling immediate compile-time feedback. -->
依值类型允许类型包含非类型代码，如函数调用和数据构造子，使类型系统的表达能力大大增强。
从参数的**值**中**计算**类型的能力意味着函数的返回类型可以根据提供的参数而变化。
例如，可以使数据库查询的结果的类型依赖于数据库模式和具体的查询，而无需对查询结果进行任何可能失败的强制类型转换操作。
当查询发生变化时，运行它得到的结果的类型也会发生变化，从而获得即时的编译时反馈。

<!-- When a function's return type depends on a value, analyzing the value with pattern matching can result in the type being _refined_, as a variable that stands for a value is replaced by the constructors in the pattern.
The type signature of a function documents the way that the return type depends on the argument value, and pattern matching then explains how the return type can be fulfilled for each potential argument. -->
当函数的返回类型取决于一个值时，使用模式匹配分析值可能导致类型被_细化_，因为代表值的变量被模式中的构造子替换。
函数的类型签名记录了返回类型如何取依赖于参数的值，
所以模式匹配解释了返回类型如何根据不同的潜在参数变成一个更具体的类型。
<!-- TODO -->

<!-- Ordinary code that occurs in types is run during type checking, though `partial` functions that might loop infinitely are not called.
Mostly, this computation follows the rules of ordinary evaluation that were introduced in [the very beginning of this book](../getting-to-know/evaluating.md), with expressions being progressively replaced by their values until a final value is found.
Computation during type checking has an important difference from run-time computation: some values in types may be _variables_ whose values are not yet known.
In these cases, pattern-matching gets "stuck" and does not proceed until or unless a particular constructor is selected, e.g. by pattern matching.
Type-level computation can be seen as a kind of partial evaluation, where only the parts of the program that are sufficiently known need to be evaluated and other parts are left alone. -->

出现在类型中的普通代码在类型检查期间运行，其中可能导致无限循环的 `partial` 函数不会被调用。
大多数情况下，这种计算遵循了[本书开头](../getting-to-know/evaluating.md)介绍的普通求值规则：
子表达式逐渐被其值替换，直到整个表达式变成了一个值。
类型检查期间的计算与运行时计算有一个重要的区别：类型中的一些值可能是**变量**，意味着这些值还未知。
在这些情况下，模式匹配会“卡住”，直到确定这个变量对应特定的构造子（例如通过对其进行模式匹配）。
类型级别的计算可以看作是一种部分求值：只求值完全已知的程序部分，剩下的部分则保持不变。

<!-- ## The Universe Pattern -->
# 宇宙设计模式

<!-- A common pattern when working with dependent types is to section off some subset of the type system.
For example, a database query library might be able to return varying-length strings, fixed-length strings, or numbers in certain ranges, but it will never return a function, a user-defined datatype, or an `IO` action.
A domain-specific subset of the type system can be defined by first defining a datatype with constructors that match the structure of the desired types, and then defining a function that interprets values from this datatype into honest-to-goodness types.
The constructors are referred to as _codes_ for the types in question, and the entire pattern is sometimes referred to as a _universe à la Tarski_, or just as a _universe_ when context makes it clear that universes such as `Type 3` or `Prop` are not what's meant. -->
一个在使用依值类型时常见的设计模式是将类型系统的某个子集显示地划分出来。
例如，数据库查询库可能能够返回可变长度的字符串、固定长度的字符串或某些范围内的数字，但它永远不会返回函数、用户定义的数据类型或`IO`操作。
一个领域特定的类型子集的定义方式如下：首先定义一个具有与所需类型结构匹配的构造子的数据类型，然后定义将这个数据类型的值解释为真实的类型一个函数。
这些构造子被称为所讨论类型的**编码（codes)**，整个设计模式有时被称为 **Tarski风格的宇宙**设计模式。当上下文清楚地表明此时宇宙不指代`Type 3`或`Prop`等时，可以简称为**宇宙**设计模式。


<!-- Custom universes are an alternative to defining a type class with instances for each type of interest.
Type classes are extensible, but extensibility is not always desired.
Defining a custom universe has a number of advantages over using the types directly:
 * Generic operations that work for _any_ type in the universe, such as equality testing and serialization, can be implemented by recursion on codes.
 * The types accepted by external systems can be represented precisely, and the definition of the code datatype serves to document what can be expected.
 * Lean's pattern matching completeness checker ensures that no codes are forgotten, while solutions based on type classes defer missing instance errors to client code. -->
自定义宇宙，相比于类型类，是另一种划定一组感兴趣的类型的方式。
类型类是可扩展的，这种扩展性并非总是好的。
定义自定义宇宙相对于直接使用类型具有许多优点：
 * 可以通过对**编码**进行递归来实现对宇宙中包含的**任意**类型的通用操作，例如相等性测试和序列化。
 * 可以精确地表示外部系统接受的类型，并且编码的数据类型的定义相当于一个预期类型的文档。
 * Lean 的模式匹配完整性检查器确保没有遗漏对编码的处理，
   而基于类型类的解决方案则在客户端代码的实际调用才能检查某些类型的类型类实例是否遗漏。

<!-- ## Indexed Families -->
## 索引族

<!-- Datatypes can take two separate kinds of arguments: _parameters_ are identical in each constructor of the datatype, while _indices_ may vary between constructors.
For a given choice of index, only some constructors of the datatype are available.
As an example, `Vect.nil` is available only when the length index is `0`, and `Vect.cons` is available only when the length index is `n+1` for some `n`.
While parameters are typically written as named arguments before the colon in a datatype declaration, and indices as arguments in a function type after the colon, Lean can infer when an argument after the colon is used as a parameter. -->
数据类型可以接受两种不同类型的参数：**参量（parameter）** 在每个构造子都是相同的，而 **索引（index）** 则允许在不同构造子间不同。
特定的索引意味着只有特定的构造子可用。
例如，`Vect.nil` 仅在长度索引为 `0` 时可用，而 `Vect.cons` 仅在长度索引为 `n+1` 时可用。
虽然参量通常以命名参数写在数据类型声明中的冒号前，索引写在冒号后（作为某个函数类型的参数），但 Lean 可以推断冒号后的参数何时被用作参量。

<!-- Indexed families allow the expression of complicated relationships between data, all checked by the compiler.
The datatype's invariants can be encoded directly, and there is no way to violate them, not even temporarily.
Informing the compiler about the datatype's invariants brings a major benefit: the compiler can now inform the programmer about what must be done to satisfy them.
The strategic use of compile-time errors, especially those resulting from underscores, can make it possible to offload some of the programming thought process to Lean, freeing up the programmer's mind to worry about other things. -->
索引族允许表达数据之间的复杂关系，所有这些关系都由编译器检查。
数据类型的不变性可以直接通过索引族编码，从而保证这些不变性不会被（哪怕是暂时地）违反。
向编译器提供关于数据类型不变性的信息带来了一个重大好处：编译器现在可以告诉程序员必须做什么才能满足这些不变性。
通过刻意地触发编译期错误（特别是通过下划线占位符触发），可以将 “此时需要注意什么不变性” 的任务交给 Lean 思考 ，从而使程序员可以花更多心思担心其他事情。

<!-- Encoding invariants using indexed families can lead to difficulties.
First off, each invariant requires its own datatype, which then requires its own support libraries.
`List.append` and `Vect.append` are not interchangeable, after all.
This can lead to code duplication.
Secondly, convenient use of indexed families requires that the recursive structure of functions used in types match the recursive structure of the programs being type checked.
Programming with indexed families is the art of arranging for the right coincidences to occur.
While it's possible to work around missing coincidences with appeals to equality proofs, it is difficult, and it leads to programs littered with cryptic justifications.
Thirdly, running complicated code on large values during type checking can lead to compile-time slowdowns.
Avoiding these slowdowns for complicated programs can require specialized techniques. -->
使用索引族编码不变性有时会导致困难。
首先，每个不变性都需要自己的数据类型，然后需要自己的支持库。
毕竟，`List.append` 和 `Vect.append` 是不能互换的。这都会导致代码重复。
其次，方便使用索引族需要类型中使用的函数的递归结构与被类型检查的程序的递归结构相匹配。
使用索引族编程正是“正确安排这些匹配发生”的艺术。
虽然可以通过手动引入相等性证明解决不匹配的巧合，但这件事并不容易，而且会导致程序中充斥着难懂的代码。
第三，类型检查期间运行过于复杂的代码可能导致很长的编译时间。避免这些复杂程序带来的编译减速可能需要专门的技术。


<!-- ## Definitional and Propositional Equality -->
## 定义相等性和命题相等性

<!-- Lean's type checker must, from time to time, check whether two types should be considered interchangeable.
Because types can contain arbitrary programs, it must therefore be able to check arbitrary programs for equality.
However, there is no efficient algorithm to check arbitrary programs for fully-general mathematical equality.
To work around this, Lean contains two notions of equality: -->

Lean的类型检查器必须不时检查两个类型是否应该被视为可互换的。
因为类型可以包含任意程序，所以它必须能够检查任意程序的相等性。
然而，没有有效的算法可以检查任意两个程序在数学意义上的相等性。
为了解决这个问题，Lean 引入了两种相等性的概念：

 <!-- * _Definitional equality_ is an underapproximation of equality that essentially checks for equality of syntactic representation modulo computation and renaming of bound variables. Lean automatically checks for definitional equality in situations where it is required. -->
 * **定义相等性（Definitional equality）** 是一个对程序相等性的近似：定义相等的程序一定相等，但反之不然。它基本只上检查（在允许计算和绑定变量重命名的意义下）语法表示的相等性。Lean 在需要时会自动检查定义相等。

 <!-- * _Propositional equality_ must be explicitly proved and explicitly invoked by the programmer. In return, Lean automatically checks that the proofs are valid and that the invocations accomplish the right goal. -->
 * **命题相等性（Propositional equality）** 必须由程序员显式证明和显式调用。Lean 会自动检查证明是否正确，并检查对这种相等性的调用是否使得证明目标被完成。

<!-- The two notions of equality represent a division of labor between programmers and Lean itself.
Definitional equality is simple, but automatic, while propositional equality is manual, but expressive.
Propositional equality can be used to unstick otherwise-stuck programs in types. -->
这两种相等性概念代表了程序员和 Lean 之间的分工。
定义相等性简单但自动，命题相等性手动但表达力强。
命题相等性可以用于解套类型中的一些卡住的程序
（比如因为无法对变量求值）。

<!-- However, the frequent use of propositional equality to unstick type-level computation is typically a code smell.
It typically means that coincidences were not well-engineered, and it's usually a better idea to either redesign the types and indices or to use a different technique to enforce the needed invariants.
When propositional equality is instead used to prove that a program meets a specification, or as part of a subtype, there is less reason to be suspicious. -->
然而过于频繁地使用命题相等性来解套类型层面的卡住的计算
通常意味着代码是一段臭代码：这意味着没有很好地设计匹配。<!-- TODO: coincidence -->
这时较好的方案是重新设计类型和索引，
或者使用其他的技术来保证程序不变性。<!-- TODO: enforce -->
当命题相等被用来证明程序满足规范，
或作为子类型的一部分时，
则是一种常见的模式。
