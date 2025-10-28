import VersoManual
import FPLeanZh.Examples

-- import FPLeanZh.DependentTypes.IndexedFamilies
-- import FPLeanZh.DependentTypes.UniversePattern
-- import FPLeanZh.DependentTypes.TypedQueries
-- import FPLeanZh.DependentTypes.IndicesParametersUniverses
-- import FPLeanZh.DependentTypes.Pitfalls
-- import FPLeanZh.DependentTypes.Summary

open Verso.Genre Manual
open Verso.Code.External

open FPLeanZh

set_option verso.exampleProject "../examples"
set_option verso.exampleModule "Examples.DependentTypes"

-- Programming with Dependent Types
%%%
file := "DependentTypes"
%%%
#doc (Manual) "使用依值类型编程" =>
%%%
tag := "programming-with-dependent-types"
%%%

-- In most statically-typed programming languages, there is a hermetic seal between the world of types and the world of programs.
-- Types and programs have different grammars and they are used at different times.
-- Types are typically used at compile time, to check that a program obeys certain invariants.
-- Programs are used at run time, to actually perform computations.
-- When the two interact, it is usually in the form of a type-case operator like an “instance-of” check or a casting operator that provides the type checker with information that was otherwise unavailable, to be verified at run time.
-- In other words, the interaction consists of types being inserted into the world of programs, where they gain some limited run-time meaning.

-- Lean does not impose this strict separation.
-- In Lean, programs may compute types and types may contain programs.
-- Placing programs in types allows their full computational power to be used at compile time, and the ability to return types from functions makes types into first-class participants in the programming process.

-- _Dependent types_ are types that contain non-type expressions.
-- A common source of dependent types is a named argument to a function.
-- For example, the function {anchorName natOrStringThree}`natOrStringThree` returns either a natural number or a string, depending on which {anchorName natOrStringThree}`Bool` it is passed:

在大多数静态类型编程语言中，类型世界和程序世界之间有一个明确的界限。 类型和程序有不同的语法，并且它们在不同阶段起作用。类型通常在编译阶段被使用，以检查程序是否遵守某些不变量。 程序在运行时阶段被使用，以实际执行计算。当两者互动时，通常是以类型案例运算符的形式，例如 “instance-of” 检查或提供类型检查器无法获得的信息的转换运算符，以在运行时验证。 换句话说，这种交互一般是将类型插入程序世界，使得类型具有一些有限的运行时含义。

Lean 并不严格地区分类型和程序。在 Lean 中，程序可以计算类型，类型可以包含程序。允许程序出现在类型中使得编译阶段可以使用编程语言全部的计算能力。允许函数返回类型则使得类型成为编程过程中的一等参与者。

*依值类型*（Dependent types）是包含非类型表达式的类型。一个常见的依值类型来源是函数的一个命名参数。例如，函数 {anchorName natOrStringThree}`natOrStringThree` 根据传递的 {anchorName natOrStringThree}`Bool` 值返回一个自然数或一个字符串：

```anchor natOrStringThree
def natOrStringThree (b : Bool) : if b then Nat else String :=
  match b with
  | true => (3 : Nat)
  | false => "three"
```

-- Further examples of dependent types include:
--  * {ref "polymorphism"}[The introductory section on polymorphism] contains {anchorName posOrNegThree (module:= Examples.Intro)}`posOrNegThree`, in which the function's return type depends on the value of the argument.
--  * {ref "literal-numbers"}[The {anchorName OfNat (module := Examples.Classes)}`OfNat` type class] depends on the specific natural number literal being used.
--  * {ref "validated-input"}[The {anchorName CheckedInput (module := Examples.FunctorApplicativeMonad)}`CheckedInput` structure] used in the example of validators depends on the year in which validation occurred.
--  * {ref "subtypes"}[Subtypes] contain propositions that refer to particular values.
--  * Essentially all interesting propositions, including those that determine the validity of {ref "props-proofs-indexing"}[array indexing notation], are types that contain values and are thus dependent types.

-- 更多依值类型的例子包括：
--  * {ref "polymorphism"}[多态性简介] 包含 {anchorName posOrNegThree (module:= Examples.Intro)}`posOrNegThree`，其返回类型取决于参数的值。
--  * {ref "literal-numbers"}[{anchorName OfNat (module := Examples.Classes)}`OfNat` 类型类] 取决于使用的特定自然数字面量。
--  * {ref "validated-input"}[{anchorName CheckedInput (module := Examples.FunctorApplicativeMonad)}`CheckedInput` 结构] 中依赖于验证发生年份的验证器的例子。
--  * {ref "subtypes"}[子类型] 中包含引用特定值的命题。
--  * 基本上所有有趣的命题都是包含值的类型，因此是依值类型，包括决定 {ref "props-proofs-indexing"}[数组索引表示法] 有效性的命题。

-- Dependent types vastly increase the power of a type system.
-- The flexibility of return types that branch on argument values enables programs to be written that cannot easily be given types in other type systems.
-- At the same time, dependent types allow a type signature to restrict which values may be returned from a function, enabling strong invariants to be enforced at compile time.

-- However, programming with dependent types can be quite complex, and it requires a whole set of skills above and beyond functional programming.
-- Expressive specifications can be complicated to fulfill, and there is a real risk of tying oneself in knots and being unable to complete the program.
-- On the other hand, this process can lead to new understanding, which can be expressed in a refined type that can be fulfilled.
-- While this chapter scratches the surface of dependently typed programming, it is a deep topic that deserves an entire book of its own.

依值类型大大增加了类型系统的能力。根据参数的值的不同返回不同类型的灵活性使得其他类型系统中很难给出类型的程序可以被接受。同时，依值类型使得类型签名可以表达“函数只能返回特定的值”等概念，使得编译阶段可以检查一些更加严格的不变量。

然而，使用依值类型进行编程是一个非常复杂的问题，需要一些一般函数式编程中不会用到的技能。依值类型编程中很可能出现“设计了一个复杂类型以表达一个非常细致的规范，但是无法写出满足这个类型的程序”之类的问题。当然，这些问题也经常会引发对问题的新的理解，从而得到一个更加细化且可以被满足的类型。虽然本章只是简单介绍使用依值类型编程，但它是一个值得花一整本书专门讨论的深刻主题。
