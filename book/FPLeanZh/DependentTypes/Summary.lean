import VersoManual
import FPLeanZh.Examples

open Verso.Genre Manual
open Verso.Code.External

open FPLeanZh

set_option verso.exampleProject "../examples"
set_option verso.exampleModule "Examples.DependentTypes"

#doc (Manual) "总结" =>

-- # Dependent Types

# 依赖类型

-- Dependent types, where types contain non-type code such as function calls and ordinary data constructors, lead to a massive increase in the expressive power of a type system.
-- The ability to _compute_ a type from the _value_ of an argument means that the return type of a function can vary based on which argument is provided.
-- This can be used, for example, to have the result type of a database query depend on the database's schema and the specific query issued, without needing any potentially-failing cast operations on the result of the query.
-- When the query changes, so does the type that results from running it, enabling immediate compile-time feedback.

依赖类型，其中类型包含非类型代码，例如函数调用和普通数据构造函数，导致类型系统的表达能力大幅提升。
从参数的__值__来__计算__类型的能力意味着函数的返回类型可以根据提供的参数而变化。
例如，这可以用于使数据库查询的结果类型取决于数据库的模式和发出的特定查询，而无需对查询结果进行任何可能失败的强制转换操作。
当查询更改时，运行它所产生的类型也会随之更改，从而实现即时编译时反馈。

-- When a function's return type depends on a value, analyzing the value with pattern matching can result in the type being _refined_, as a variable that stands for a value is replaced by the constructors in the pattern.
-- The type signature of a function documents the way that the return type depends on the argument value, and pattern matching then explains how the return type can be fulfilled for each potential argument.

当函数的返回类型依赖于一个值时，使用模式匹配分析该值可以导致类型被__细化__，因为代表一个值的变量被模式中的构造函数替换。
函数的类型签名记录了返回类型依赖于参数值的方式，然后模式匹配解释了如何为每个潜在参数实现返回类型。

-- Ordinary code that occurs in types is run during type checking, though {kw}`partial` functions that might loop infinitely are not called.
-- Mostly, this computation follows the rules of ordinary evaluation that were introduced in {ref "evaluating"}[the very beginning of this book], with expressions being progressively replaced by their values until a final value is found.
-- Computation during type checking has an important difference from run-time computation: some values in types may be _variables_ whose values are not yet known.
-- In these cases, pattern-matching gets “stuck” and does not proceed until or unless a particular constructor is selected, e.g. by pattern matching.
-- Type-level computation can be seen as a kind of partial evaluation, where only the parts of the program that are sufficiently known need to be evaluated and other parts are left alone.

类型中出现的普通代码在类型检查期间运行，尽管不会调用可能无限循环的 {kw}`partial` 函数。
大多数情况下，此计算遵循 {ref "evaluating"}[本书开头] 介绍的普通求值规则，表达式逐渐被其值替换，直到找到最终值。
类型检查期间的计算与运行时计算有一个重要区别：类型中的某些值可能是__变量__，其值尚不清楚。
在这些情况下，模式匹配会“卡住”，并且在选择特定构造函数之前（例如，通过模式匹配）不会继续进行。
类型级计算可以看作是一种部分求值，其中只有足够已知的程序部分需要求值，而其他部分则保持不变。

-- # The Universe Pattern

# 宇宙模式

-- A common pattern when working with dependent types is to section off some subset of the type system.
-- For example, a database query library might be able to return varying-length strings, fixed-length strings, or numbers in certain ranges, but it will never return a function, a user-defined datatype, or an {anchorName otherEx}`IO` action.
-- A domain-specific subset of the type system can be defined by first defining a datatype with constructors that match the structure of the desired types, and then defining a function that interprets values from this datatype into honest-to-goodness types.
-- The constructors are referred to as _codes_ for the types in question, and the entire pattern is sometimes referred to as a _universe à la Tarski_, or just as a _universe_ when context makes it clear that universes such as {anchorTerm otherEx}`Type 3` or {anchorTerm otherEx}`Prop` are not what's meant.

使用依赖类型时的一个常见模式是将类型系统的某个子集划分出来。
例如，数据库查询库可能能够返回变长字符串、定长字符串或特定范围内的数字，但它永远不会返回函数、用户定义的数据类型或 {anchorName otherEx}`IO` 操作。
可以通过首先定义一个具有与所需类型结构匹配的构造函数的数据类型，然后定义一个将此数据类型中的值解释为真实类型的函数来定义类型系统的特定领域子集。
这些构造函数被称为相关类型的__代码__，整个模式有时被称为__塔斯基式宇宙__，或者在上下文中明确表示不是指 {anchorTerm otherEx}`Type 3` 或 {anchorTerm otherEx}`Prop` 等宇宙时，简称为__宇宙__。

-- Custom universes are an alternative to defining a type class with instances for each type of interest.
-- Type classes are extensible, but extensibility is not always desired.
-- Defining a custom universe has a number of advantages over using the types directly:
--  * Generic operations that work for _any_ type in the universe, such as equality testing and serialization, can be implemented by recursion on codes.
--  * The types accepted by external systems can be represented precisely, and the definition of the code datatype serves to document what can be expected.
--  * Lean's pattern matching completeness checker ensures that no codes are forgotten, while solutions based on type classes defer missing instance errors to client code.

自定义宇宙是为每个感兴趣的类型定义带有实例的类型类的替代方案。
类型类是可扩展的，但并不总是需要可扩展性。
定义自定义宇宙比直接使用类型具有许多优点：
 * 适用于宇宙中__任何__类型的通用操作，例如相等性测试和序列化，可以通过对代码进行递归来实现。
 * 外部系统接受的类型可以精确表示，并且代码数据类型的定义有助于记录可以预期什么。
 * Lean 的模式匹配完整性检查器确保没有遗漏任何代码，而基于类型类的解决方案将缺少实例错误推迟到客户端代码。

-- # Indexed Families

# 索引族

-- Datatypes can take two separate kinds of arguments: _parameters_ are identical in each constructor of the datatype, while _indices_ may vary between constructors.
-- For a given choice of index, only some constructors of the datatype are available.
-- As an example, {anchorName otherEx}`Vect.nil` is available only when the length index is {anchorTerm Vect}`0`, and {anchorName consNotLengthN}`Vect.cons` is available only when the length index is {anchorTerm Vect}`n+1` for some {anchorName Vect}`n`.
-- While parameters are typically written as named arguments before the colon in a datatype declaration, and indices as arguments in a function type after the colon, Lean can infer when an argument after the colon is used as a parameter.

数据类型可以接受两种不同类型的参数：__参数__在数据类型的每个构造函数中都相同，而__索引__在构造函数之间可能不同。
对于给定的索引选择，数据类型只有一些构造函数可用。
例如，{anchorName otherEx}`Vect.nil` 仅在长度索引为 {anchorTerm Vect}`0` 时可用，而 {anchorName consNotLengthN}`Vect.cons` 仅在长度索引为某个 {anchorName Vect}`n` 的 {anchorTerm Vect}`n+1` 时可用。
虽然参数通常在数据类型声明中冒号之前作为命名参数编写，而索引在冒号之后作为函数类型中的参数编写，但 Lean 可以推断出冒号后的参数何时用作参数。

-- Indexed families allow the expression of complicated relationships between data, all checked by the compiler.
-- The datatype's invariants can be encoded directly, and there is no way to violate them, not even temporarily.
-- Informing the compiler about the datatype's invariants brings a major benefit: the compiler can now inform the programmer about what must be done to satisfy them.
-- The strategic use of compile-time errors, especially those resulting from underscores, can make it possible to offload some of the programming thought process to Lean, freeing up the programmer's mind to worry about other things.

索引族允许表达数据之间复杂的关系，所有这些都由编译器检查。
数据类型的不变量可以直接编码，并且无法违反它们，即使是暂时性的也不行。
将数据类型的不变量告知编译器会带来一个主要好处：编译器现在可以告知程序员必须做什么才能满足它们。
战略性地使用编译时错误，特别是那些由下划线引起的错误，可以使部分编程思维过程转移到 Lean，从而解放程序员的思维去担心其他事情。

-- Encoding invariants using indexed families can lead to difficulties.
-- First off, each invariant requires its own datatype, which then requires its own support libraries.
-- {anchorName otherEx}`List.zip` and {anchorName VectZip}`Vect.zip` are not interchangeable, after all.
-- This can lead to code duplication.
-- Secondly, convenient use of indexed families requires that the recursive structure of functions used in types match the recursive structure of the programs being type checked.
-- Programming with indexed families is the art of arranging for the right coincidences to occur.
-- While it's possible to work around missing coincidences with appeals to equality proofs, it is difficult, and it leads to programs littered with cryptic justifications.
-- Thirdly, running complicated code on large values during type checking can lead to compile-time slowdowns.
-- Avoiding these slowdowns for complicated programs can require specialized techniques.

使用索引族编码不变量可能会导致困难。
首先，每个不变量都需要自己的数据类型，然后需要自己的支持库。
毕竟，{anchorName otherEx}`List.zip` 和 {anchorName VectZip}`Vect.zip` 是不可互换的。
这可能导致代码重复。
其次，方便地使用索引族要求类型中使用的函数的递归结构与正在进行类型检查的程序的递归结构匹配。
使用索引族编程是安排正确巧合发生的艺术。
虽然可以通过诉诸相等性证明来解决缺失的巧合，但这很困难，并且会导致程序中充斥着神秘的理由。
第三，在类型检查期间对大值运行复杂代码可能导致编译时减速。
对于复杂程序，避免这些减速可能需要专门的技术。

-- # Definitional and Propositional Equality

# 定义等价和命题等价

-- Lean's type checker must, from time to time, check whether two types should be considered interchangeable.
-- Because types can contain arbitrary programs, it must therefore be able to check arbitrary programs for equality.
-- However, there is no efficient algorithm to check arbitrary programs for fully-general mathematical equality.
-- To work around this, Lean contains two notions of equality:

Lean 的类型检查器必须不时检查两种类型是否应被视为可互换。
因为类型可以包含任意程序，所以它必须能够检查任意程序的相等性。
然而，没有有效的算法可以检查任意程序的完全通用数学相等性。
为了解决这个问题，Lean 包含两种相等概念：

--  * _Definitional equality_ is an underapproximation of equality that essentially checks for equality of syntactic representation modulo computation and renaming of bound variables. Lean automatically checks for definitional equality in situations where it is required.

 * __定义等价__ 是对等价的一种低估，它本质上检查语法表示的等价性，模计算和绑定变量的重命名。Lean 在需要时自动检查定义等价。

--  * _Propositional equality_ must be explicitly proved and explicitly invoked by the programmer. In return, Lean automatically checks that the proofs are valid and that the invocations accomplish the right goal.

 * __命题等价__ 必须由程序员显式证明和显式调用。作为回报，Lean 自动检查证明是否有效以及调用是否达到正确目标。

-- The two notions of equality represent a division of labor between programmers and Lean itself.
-- Definitional equality is simple, but automatic, while propositional equality is manual, but expressive.
-- Propositional equality can be used to unstick otherwise-stuck programs in types.

这两种相等概念代表了程序员和 Lean 本身之间的分工。
定义等价简单但自动，而命题等价手动但富有表现力。
命题等价可用于解除类型中其他卡住的程序的阻塞。

-- However, the frequent use of propositional equality to unstick type-level computation is typically a code smell.
-- It typically means that coincidences were not well-engineered, and it's usually a better idea to either redesign the types and indices or to use a different technique to enforce the needed invariants.
-- When propositional equality is instead used to prove that a program meets a specification, or as part of a subtype, there is less reason to be suspicious.

然而，频繁使用命题等价来解除类型级计算的阻塞通常是一种代码异味。
它通常意味着巧合没有得到很好的设计，通常更好的做法是重新设计类型和索引，或者使用不同的技术来强制执行所需的不变量。
当命题等价被用于证明程序符合规范，或者作为子类型的一部分时，就没有太多理由怀疑了。
