<!--
# Overloading and Type Classes
-->

# 重载与类型类

<!--
In many languages, the built-in datatypes get special treatment.
For example, in C and Java, `+` can be used to add `float`s and `int`s, but not arbitrary-precision numbers from a third-party library.
Similarly, numeric literals can be used directly for the built-in types, but not for user-defined number types.
Other languages provide an _overloading_ mechanism for operators, where the same operator can be given a meaning for a new type.
In these languages, such as C++ and C#, a wide variety of built-in operators can be overloaded, and the compiler uses the type checker to select a particular implementation.
-->

在许多语言中，内置数据类型有特殊的优待。
例如，在 C 和 Java 中，`+` 可以被用于 `float` 和 `int`，但不能用于其他第三方库的数字。
类似地，数字字面量可以被直接用于内置类型，但是不能用于用户定义的数字类型。
其他语言为运算符提供 **重载（overloading）** 机制，使得同一个运算符可以在新的类型有意义。
在这些语言中，比如 C++ 和 C#，多种内置运算符都可以被重载，编译器使用类型检查来选择一个特定的实现。

<!--
In addition to numeric literals and operators, many languages allow overloading of functions or methods.
In C++, Java, C# and Kotlin, multiple implementations of a method are allowed, with differing numbers and types of arguments.
The compiler uses the number of arguments and their types to determine which overload was intended.
-->

除了数字字面量和运算符，许多语言还可以重载函数或方法。
在 C++，Java，C# 和 Kotlin 中，对于不同的数字和类型参数，一个方法可以有多种实现。
便是其使用参数的数字和它们的类型来决定使用哪个重载。

<!--
Function and operator overloading has a key limitation: polymorphic functions can't restrict their type arguments to types for which a given overload exists.
For example, an overloaded method might be defined for strings, byte arrays, and file pointers, but there's no way to write a second method that works for any of these.
Instead, this second method must itself be overloaded for each type that has an overload of the original method, resulting in many boilerplate definitions instead of a single polymorphic definition.
Another consequence of this restriction is that some operators (such as equality in Java) end up being defined for _every_ combination of arguments, even when it is not necessarily sensible to do so.
If programmers are not very careful, this can lead to programs that crash at runtime or silently compute an incorrect result.
-->

函数和运算符的重载有一个关键的受限之处：多态函数无法限定它们的类型参数为重载存在的那些类型。
例如，一个重载方法可能在字符串，字节数组和文件指针上有定义，但是没有任何方法能写第二个方法能在任意这些类型上适用。
如果想这样做的话，这第二个方法必须本身也为每一个类型都有一个原始方法的重载，最终产生许多繁琐的定义而不是一个简单的多态定义。
这种限制的另一个后果是一些运算符（例如 Java 中的等号）对 **每一个** 参数组合都要有定义，即使这样做是完全没必要的。
如果程序员没有很谨慎的话，这可能会导致程序在运行时崩溃，或者静静地计算出错误的结果。

<!--
Lean implements overloading using a mechanism called _type classes_, pioneered in Haskell, that allows overloading of operators, functions, and literals in a manner that works well with polymorphism.
A type class describes a collection of overloadable operations.
To overload these operations for a new type, an _instance_ is created that contains an implementation of each operation for the new type.
For example, a type class named `Add` describes types that allow addition, and an instance of `Add` for `Nat` provides an implementation of addition for `Nat`.
-->

Lean 用 **类型类（type classes）** 机制（源于 Haskell）来实现重载。
这使得运算符，函数和字面量重载与多态有一个很好的配合。
一个类型类描述了一族可重载的运算符。
要将这些运算符重载到新的类型上，你需要创建一个包含对新类型的每一个运算的实现方式的 **实例（instance）** 。
例如，`Add` 类型类描述了可加的类型，一个对 `Nat` 类型的 `Add` 实例提供了 `Nat` 上加法的实现。

<!--
The terms _class_ and _instance_ can be confusing for those who are used to object-oriented languages, because they are not closely related to classes and instances in object-oriented languages.
However, they do share common roots: in everyday language, the term "class" refers to a group that shares some common attributes.
While classes in object-oriented programming certainly describe groups of objects with common attributes, the term additionally refers to a specific mechanism in a programming language for describing such a group.
Type classes are also a means of describing types that share common attributes (namely, implementations of certain operations), but they don't really have anything else in common with classes as found in object-oriented programming.
-->

**类** 和 **实例** 这两个词可能会使面向对象程序员感到混淆，因为 Lean 中的它们与面向对象语言中的类和实例关系不大。
然而，它们有相同的基本性质：在日常语言中，“类”这个词指的是具有某些共同属性的组。
虽然面向对象编程中的类确实描述了具有共同属性的对象组，但该术语还指代描述此类对象组的特定编程语言机制。
类型类也是描述共享共同属性的类型（即某些操作的实现）的一种方式，但它们与面向对象编程中的类并没有其他共同点。

<!--
A Lean type class is much more analogous to a Java or C# _interface_.
Both type classes and interfaces describe a conceptually related set of operations that are implemented for a type or collection of types.
Similarly, an instance of a type class is akin to the code in a Java or C# class that is prescribed by the implemented interfaces, rather than an instance of a Java or C# class.
Unlike Java or C#'s interfaces, types can be given instances for type classes that the author of the type does not have access to.
In this way, they are very similar to Rust traits.
-->

Lean 的类型类更像是 Java 或 C# 中的 **接口（interface）**。
类型类和接口都描述了在概念上有联系的运算的集合，这些运算为一个类型或一个类型集合实现。
类似地，类型类的实例也很像 Java 或 C# 中描述实现了的接口的类，而不是 Java 或 C# 中类的实例。
不像 Java 或 C# 的接口，对于一个类型，该类型的作者并不能访问的类型类也可以给这个类型实例。
从这种意义上讲，这和 Rust 的 traits 很像。




