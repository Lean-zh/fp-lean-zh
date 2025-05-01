<!--
# Summary
-->

# 总结 { #summary }

<!--
## Type Classes and Overloading
-->

## 类型类和重载 { #type-classes-and-overloading }

<!--
Type classes are Lean's mechanism for overloading functions and operators.
A polymorphic function can be used with multiple types, but it behaves in the same manner no matter which type it is used with.
For example, a polymorphic function that appends two lists can be used no matter the type of the entries in the list, but it is unable to have different behavior depending on which particular type is found.
An operation that is overloaded with type classes, on the other hand, can also be used with multiple types.
However, each type requires its own implementation of the overloaded operation.
This means that the behavior can vary based on which type is provided.
-->

类型类是 Lean 重载函数和运算符的机制。
一个多态函数可以用于多种类型，但是不管是什么类型，它的行为都是一致的。
例如，一个连接两个列表的多态函数在使用时不关心列表中元素的类型，但它也不可能根据具体的元素类型有不一样的行为。
另一方面，一个用类型类重载的运算符，也可以用在多种类型上。
然而，每个类型都需要自己的重载运算实现。
这意味着可以根据不同的类型有不同的行为。

<!--
A _type class_ has a name, parameters, and a body that consists of a number of names with types.
The name is a way to refer to the overloaded operations, the parameters determine which aspects of the definitions can be overloaded, and the body provides the names and type signatures of the overloadable operations.
Each overloadable operation is called a _method_ of the type class.
Type classes may provide default implementations of some methods in terms of the others, freeing implementors from defining each overload by hand when it is not needed.
-->

一个 **类型类** 有名称，参数，和一个包含了名称和类型的类体。
名字是一种代指重载运算符的方式，参数决定了哪些方面的定义可以被重载，类体提供了可重载运算的名称和类型签名。
每一个可重载运算都被称为类型类的一个方法。
类型类可能会提供一些方法的默认实现，使得程序员从手动实现每个重载（只要实现可以被自动完成）中解放出来。

<!--
An _instance_ of a type class provides implementations of the methods for given parameters.
Instances may be polymorphic, in which case they can work for a variety of parameters, and they may optionally provide more specific implementations of default methods in cases where a more efficient version exists for some particular type.
-->

一个类型类的 **实例** 为给定参数提供了方法的实现。
实例可能是多态的，这种情况下它能接受多种参数，同时也可能在对于一些类型存在更高效的实现时提供更具体实现。

<!--
Type class parameters are either _input parameters_ (the default), or _output parameters_ (indicated by an `outParam` modifier).
Lean will not begin searching for an instance until all input parameters are no longer metavariables, while output parameters may be solved while searching for instances.
Parameters to a type class need not be types—they may also be ordinary values.
The `OfNat` type class, used to overload natural number literals, takes the overloaded `Nat` itself as a parameter, which allows instances to restrict the allowed numbers.
-->

类型类参数要么是一个 **输入参数（input parameters）** （默认情况下），或者是一个 **输出参数** （通过 `outParam` 修饰）。
在所有输出参数变为已知前，Lean 不会开始实例搜索。输出参数会在实例搜索过程中给出。
类型类的参数不一定要是一个类型，它也可以是一个常规值。
`OfNat` 类型类被用于重载自然数字面量，接受要被重载的 `Nat` 本身作为参数，这可以使实例限制允许的数字。

<!--
Instances may be marked with a `@[default_instance]` attribute.
When an instance is a default instance, then it will be chosen as a fallback when Lean would otherwise fail to find an instance due to the presence of metavariables in the type.
-->

实例可能会被标注为 `@[default_instance]` 属性。
当一个实例是默认实例时，那么就会作为 Lean 因存在元变量而无法找到实例的回退。

<!--
## Type Classes for Common Syntax
-->

## 常见语法的类型类 { #type-classes-for-common-syntax }

<!--
Most infix operators in Lean are overridden with a type class.
For instance, the addition operator corresponds to a type class called `Add`.
Most of these operators have a corresponding heterogeneous version, in which the two arguments need not have the same type.
These heterogenous operators are overloaded using a version of the class whose name starts with `H`, such as `HAdd`.
-->

Lean 中多数中缀运算符都是用类型类来重载的。
例如，加法对应于 `Add` 类型类。
多数运算符都有与之对应的异质运算，该运算的两个参数不需要是同一种类型。
这些异质运算符使用前面加个 `H` 的类型类来重载，比如 `HAdd`。

<!--
Indexing syntax is overloaded using a type class called `GetElem`, which involves proofs.
`GetElem` has two output parameters, which are the type of elements to be extracted from the collection and a function that can be used to determine what counts as evidence that the index value is in bounds for the collection.
This evidence is described by a proposition, and Lean attempts to prove this proposition when array indexing is used.
When Lean is unable to check that list or array access operations are in bounds at compile time, the check can be deferred to run time by appending a `?` to the indexing operation.
-->

索引语法使用 `GetElem` 类型类来重载，该类型类包含证明。
`GetElem` 有两个输出参数，一个是要被从中提取出的元素的类型，另一个是用来证明索引值未越界的函数。
这个证明是用命题来描述的，Lean 会在索引时尝试证明这个命题。
当 Lean 在编译时不能检查列表或元组索引是否越界时，可以通过为索引操作添加 `?` 来让检查发生在运行时。

<!--
## Functors
-->

## 函子 { #functors }

<!--
A functor is a polymorphic type that supports a mapping operation.
This mapping operation transforms all elements "in place", changing no other structure.
For instance, lists are functors and the mapping operation may neither drop, duplicate, nor mix up entries in the list.
-->

一个函子是一个支持映射运算的泛型。
这个映射运算“在原地”映射所有的元素，不会改变其他结构。
例如，列表是函子，所以列表上的映射不会删除，复制或混合列表中的元素。

<!--
While functors are defined by having `map`, the `Functor` type class in Lean contains an additional default method that is responsible for mapping the constant function over a value, replacing all values whose type are given by polymorphic type variable with the same new value.
For some functors, this can be done more efficiently than traversing the entire structure.
-->

如果定义了 `map`，那么这个类型就是一个函子。
Lean 中的 `Functor` 类型类还包含了额外的默认方法，这些方法可以将映射常数函数到值，替换所有类型是由多态变量给出的值为一个相同的新值。
对于一些函子，这比转换整个结构更高效。

<!--
## Deriving Instances
-->

## 派生实例 { #deriving-instances }

<!--
Many type classes have very standard implementations.
For instance, the Boolean equality class `BEq` is usually implemented by first checking whether both arguments are built with the same constructor, and then checking whether all their arguments are equal.
Instances for these classes can be created _automatically_.
-->

许多类型类都有非常标准的实现。
例如，布尔等价类型类 `BEq` 经常被实现为先检查参数是否有一样的构造子，然后检查他们的值是否相等。
这些类型类的实例可以 **自动** 创建。

<!--
When defining an inductive type or a structure, a `deriving` clause at the end of the declaration will cause instances to be created automatically.
Additionally, the `deriving instance ... for ...` command can be used outside of the definition of a datatype to cause an instance to be generated.
Because each class for which instances can be derived requires special handling, not all classes are derivable.
-->

当定义一个归纳类型或者结构体时，出现在声明末尾的 `deriving` 会让实例自动创建。
此外，`deriving instance ... for ...` 指令可以在数据类型定义外使用来生成一个实例。
因为每个可以派生实例的类都需要特殊处理，所以并不是所有的类都是可派生的。

<!--
## Coercions
-->

## 强制转换 { #coercions }
<!--
Coercions allow Lean to recover from what would normally be a compile-time error by inserting a call to a function that transforms data from one type to another.
For example, the coercion from any type `α` to the type `Option α` allows values to be written directly, rather than with the `some` constructor, making `Option` work more like nullable types from object-oriented languages.
-->

强制转换允许 Lean 向一个正常来说应该出现编译错误的地方插入一个函数调用，该调用将转换数据的类型，从而从错误中恢复。
例如，一个从任意类型 `α` 到 `Option α` 的强制转换使得值可以直接写出，而不是被包裹在 `some` 构造子中。
这样 `Option` 就像是有空值类型的语言中的空值那样。

<!--
There are multiple kinds of coercion.
They can recover from different kinds of errors, and they are represented by their own type classes.
The `Coe` class is used to recover from type errors.
When Lean has an expression of type `α` in a context that expects something with type `β`, Lean first attempts to string together a chain of coercions that can transform `α`s into `β`s, and only displays the error when this cannot be done.
The `CoeDep` class takes the specific value being coerced as an extra parameter, allowing either further type class search to be done on the value or allowing constructors to be used in the instance to limit the scope of the conversion.
The `CoeFun` class intercepts what would otherwise be a "not a function" error when compiling a function application, and allows the value in the function position to be transformed into an actual function if possible.
-->

有许多不同的强制转换。
他们可以从不同的错误类型中恢复，他们都是用自己的类型类来描述的。
`Coe` 类型类用于从类型错误中恢复。
当 Lean 有一个 `α` 类型的表达式，但却希望这里是一个 `β` 类型时，Lean 会首先尝试串起一个能将 `α` 强制转换为 `β` 的链，仅当它无法这么做的时候才会宝座。
`CoeDep` 类将被强制转换的具体值作为额外参数，这样可以对该值进行进一步的类型类搜索，或者在实例中使用构造函数来限制转换的范围。
`CoeFun` 类在编译函数应用时会拦截“不是函数”的错误，并允许将函数位置的值转换为实际函数（如果可能的话）。