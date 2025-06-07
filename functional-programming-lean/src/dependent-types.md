<!-- 
# Programming with Dependent Types
-->

# 使用依值类型编程 { #programming-with-dependent-types }

<!-- 
In most statically-typed programming languages, there is a hermetic seal between the world of types and the world of programs.
Types and programs have different grammars and they are used at different times.
Types are typically used at compile time, to check that a program obeys certain invariants.
Programs are used at run time, to actually perform computations.
When the two interact, it is usually in the form of a type-case operator like an "instance-of" check or a casting operator that provides the type checker with information that was otherwise unavailable, to be verified at run time.
In other words, the interaction consists of types being inserted into the world of programs, gaining some limited run-time meaning.
-->

在大多数静态类型编程语言中，类型世界和程序世界之间有一个明确的界限。 类型和程序有不同的语法，并且它们在不同阶段起作用。
 类型通常在编译阶段被使用，以检查程序是否遵守某些不变量。 程序在运行时阶段被使用，以实际执行计算。
  当两者互动时，通常是以类型案例运算符的形式，例如`instance-of`检查或提供类型检查器无法获得的信息的转换运算符，以在运行时验证。 
  换句话说，这种交互一般是将类型插入程序世界，使得类型具有一些有限的运行时含义。

<!-- 
Lean does not impose this strict separation.
In Lean, programs may compute types and types may contain programs.
Placing programs in types allows their full computation power to be used at compile time, and the ability to return types from functions makes types into first-class participants in the programming process.
-->

Lean 并不严格地区分类型和程序。
在 Lean 中，程序可以计算类型，类型可以包含程序。
允许程序出现在类型中使得编译阶段可以使用编程语言全部的计算能力。
允许函数返回类型则使得类型成为编程过程中的一等参与者。

<!-- _Dependent types_ are types that contain non-type expressions.
A common source of dependent types is a named argument to a function.
For example, the function `natOrStringThree` returns either a natural number or a string, depending on which `Bool` it is passed:
-->

**依值类型（Dependent types）** 是包含非类型表达式的类型。

```lean
{{#example_decl Examples/DependentTypes.lean natOrStringThree}}
```

<!-- 
Further examples of dependent types include:
 * [The introductory section on polymorphism](getting-to-know/polymorphism.md) contains `posOrNegThree`, in which the function's return type depends on the value of the argument.
 * [The `OfNat` type class](type-classes/pos.md#literal-numbers) depends on the specific natural number literal being used.
 * [The `CheckedInput` structure](functor-applicative-monad/applicative.md#validated-input) used in the example of validators depends on the year in which validation occurred.
 * [Subtypes](functor-applicative-monad/applicative.md#subtypes) contain propositions that refer to particular values.
 * Essentially all interesting propositions, including those that determine the validity of [array indexing notation](props-proofs-indexing.md), are types that contain values and are thus dependent types.
-->

更多依值类型的例子包括：
  * [多态的介绍性段落](getting-to-know/polymorphism.md) 中的 `posOrNegThree`，其中函数的返回类型取决于参数的值。
  * [`OfNat` 类型类](type-classes/pos.md#literal-numbers) 中取决于具体的自然数字面量。
  * [`CheckedInput` 结构](functor-applicative-monad/applicative.md#validated-input) 中依赖于验证发生年份的验证器的例子。
  * [子类型](functor-applicative-monad/applicative.md#subtypes) 中包含引用特定值的命题。
  * 几乎所有有趣的命题都是包含值的类型，因此是依值类型，包括判断 [数组索引表示](props-proofs-indexing.md) 的有效性的命题，。

<!-- 
Dependent types vastly increase the power of a type system.
The flexibility of return types that branch on argument values enables programs to be written that cannot easily be given types in other type systems.
At the same time, dependent types allow a type signature to restrict which values may be returned from a function, enabling strong invariants to be enforced at compile time.
-->

依值类型大大增加了类型系统的能力。
根据参数的值的不同返回不同类型的灵活性使得其他类型系统中很难给出类型的程序可以被接受。
同时，依值类型使得类型签名可以表达“函数只能返回特定的值”等概念，使得编译阶段可以检查一些更加严格的不变量。

<!-- 
However, programming with dependent types can be quite complex, and it requires a whole set of skills above and beyond functional programming.
Expressive specifications can be complicated to fulfill, and there is a real risk of tying oneself in knots and being unable to complete the program.
On the other hand, this process can lead to new understanding, which can be expressed in a refined type that can be fulfilled.
While this chapter scratches the surface of dependently typed programming, it is a deep topic that deserves an entire book of its own.
-->

然而，使用依值类型进行编程是一个非常复杂的问题，需要一些一般函数式编程中不会用到的技能。
依值类型编程中很可能出现“设计了一个复杂类型以表达一个非常细致的规范，但是无法写出满足这个类型的程序”之类的问题。
当然，这些问题也经常会引发对问题的新的理解，从而得到一个更加细化且可以被满足的类型。
虽然本章只是简单介绍使用依值类型编程，但它是一个值得花一整本书专门讨论的深刻主题。