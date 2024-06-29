<!--
# Special Types
-->

# 特殊类型

<!--
Understanding the representation of data in memory is very important.
Usually, the representation can be understood from the definition of a datatype.
Each constructor corresponds to an object in memory that has a header that includes a tag and a reference count.
The constructor's arguments are each represented by a pointer to some other object.
In other words, `List` really is a linked list and extracting a field from a `structure` really does just chase a pointer.
-->

理解数据在内存中的表示非常重要。通常，可以从数据类型的定义中理解它的表示。
每个构造子对应于内存中的一个对象，该对象有一个包含标记和引用计数的头。
构造子的参数分别由指向其他对象的指针表示。换句话说，`List` 实际上是一个链表，
从 `structure` 中提取一个字段实际上只是跟随一个指针。

<!--
There are, however, some important exceptions to this rule.
A number of types are treated specially by the compiler.
For example, the type `UInt32` is defined as `Fin (2 ^ 32)`, but it is replaced at run-time with an actual native implementation based on machine words.
Similarly, even though the definition of `Nat` suggests an implementation similar to `List Unit`, the actual run-time representation uses immediate machine words for sufficiently-small numbers and an efficient arbitrary-precision arithmetic library for larger numbers.
The Lean compiler translates from definitions that use pattern matching into the appropriate operations for this representation, and calls to operations like addition and subtraction are mapped to fast operations from the underlying arithmetic library.
After all, addition should not take time linear in the size of the addends.
-->

然而，这个规则有一些重要的例外。编译器对许多类型进行了特殊处理。
例如，类型 `UInt32` 被定义为 `Fin (2 ^ 32)`，但在运行时它会被替换为基于机器字的实际原生实现。
类似地，尽管 `Nat` 的定义暗示了一个类似于 `List Unit` 的实现，
但实际的运行时表示会对足够小的数字使用立即（immediate）机器字，
对较大的数字则使用高效的任意精度算术库。Lean 编译器会将使用模式匹配的定义转换为与其表示对应的适当操作，
并且对加法和减法等操作的调用会被映射到底层算术库中的快速操作。
毕竟，加法不应该花费与加数大小成线性的时间。

<!--
The fact that some types have special representations also means that care is needed when working with them.
Most of these types consist of a `structure` that is treated specially by the compiler.
With these structures, using the constructor or the field accessors directly can trigger an expensive conversion from an efficient representation to a slow one that is convenient for proofs.
For example, `String` is defined as a structure that contains a list of characters, but the run-time representation of strings uses UTF-8, not linked lists of pointers to characters.
Applying the constructor to a list of characters creates a byte array that encodes them in UTF-8, and accessing the field of the structure takes time linear in the length of the string to decode the UTF-8 representation and allocate a linked list.
Arrays are represented similarly.
From the logical perspective, arrays are structures that contain a list of array elements, but the run-time representation is a dynamically-sized array.
At run time, the constructor translates the list into an array, and the field accessor allocates a linked list from the array.
The various array operations are replaced with efficient versions by the compiler that mutate the array when possible instead of allocating a new one.
-->

由于某些类型具有特殊表示，因此在使用它们时需要小心。
这些类型中的大多数由编译器特殊处理的 `structure` 组成。对于这些结构体，
直接使用构造子或字段访问器可能会触发从高效表示到方便证明的低效表示的昂贵转换。
例如，`String` 被定义为包含字符列表的结构体，但字符串的运行时表示使用了 UTF-8，
而非指向字符的指针链表。将构造子应用于字符列表会创建一个以 UTF-8 编码它们的字节数组，
而访问结构体的字段需要线性时间来解码 UTF-8 的表示并分配一个链表。数组的表示方式类似。
从逻辑角度来看，数组是包含数组元素列表的结构体，但运行时表示则是一个动态大小的数组。
在运行时，构造子会将列表转换为数组，而字段访问器则会在数组中分配一个链表。
编译器用高效的版本替换了各种数组操作，这些版本在可能的情况下会改变数组，而非分配一个新的数组。

<!--
Both types themselves and proofs of propositions are completely erased from compiled code.
In other words, they take up no space, and any computations that might have been performed as part of a proof are similarly erased.
This means that proofs can take advantage of the convenient interface to strings and arrays as inductively-defined lists, including using induction to prove things about them, without imposing slow conversion steps while the program is running.
For these built-in types, a convenient logical representation of the data does not imply that the program must be slow.
-->

类型本身和命题的证明都会从编译后的代码中完全擦除。换句话说，它们不会占用任何空间，
证明过程中可能执行的任何计算也同样会被擦除，
这意味着证明可以利用字符串和数组作为归纳定义列表的简便接口，包括使用归纳法来证明它们，
而不会在程序运行时施加缓慢的转换步骤。对于这些内置类型，数据的简便逻辑表示并不意味着程序一定会很慢。

<!--
If a structure type has only a single non-type non-proof field, then the constructor itself disappears at run time, being replaced with its single argument.
In other words, a subtype is represented identically to its underlying type, rather than with an extra layer of indirection.
Similarly, `Fin` is just `Nat` in memory, and single-field structures can be created to keep track of different uses of `Nat`s or `String`s without paying a performance penalty.
If a constructor has no non-type non-proof arguments, then the constructor also disappears and is replaced with a constant value where the pointer would otherwise be used.
This means that `true`, `false`, and `none` are constant values, rather than pointers to heap-allocated objects.
-->

如果一个结构体类型只有一个非类型，非证明的字段，那么构造子自身会在运行时消失，
并被替换为其单个参数。换句话说，其子类型与其底层类型完全相同，不会带有额外的间接层。
同样，`Fin` 在内存中只是 `Nat`，并且可以创建单字段结构体来跟踪 `Nat` 或 `String` 的不同用法，
而无需支付性能损失。如果一个构造子没有非类型，非证明的参数，那么该构造子也会消失，
并被一个常量值替换，否则指针将用于该常量值。这意味着 `true`、`false` 和 `none` 是常量值，
而非指向堆分配对象的指针。

<!--
The following types have special representations:
-->

以下类型拥有特殊的表示：

<!--
| Type                                  | Logical representation                                                                | Run-time Representation                 |
|---------------------------------------|---------------------------------------------------------------------------------------|-----------------------------------------|
| `Nat`                                 | Unary, with one pointer from each `Nat.succ`                                          | Efficient arbitrary-precision integers  |
| `Int`                                 | A sum type with constructors for positive or negative values, each containing a `Nat` | Efficient arbitrary-precision integers  |
| `UInt8`, `UInt16`, `UInt32`, `UInt64` | A `Fin` with an appropriate bound                                                     | Fixed-precision machine integers        |
| `Char`                                | A `UInt32` paired with a proof that it's a valid code point                           | Ordinary characters                     |
| `String`                              | A structure that contains a `List Char` in a field called `data`                      | UTF-8-encoded string                    |
| `Array α`                             | A structure that contains a `List α` in a field called `data`                         | Packed arrays of pointers to `α` values |
| `Sort u`                              | A type                                                                                | Erased completely                       |
| Proofs of propositions                | Whatever data is suggested by the proposition when considered as a type of evidence   | Erased completely                       |
-->

| 类型 | 逻辑表示 | 运行时表示 |
|------|----------|------------|
| `Nat` | 一元类型，每个 `Nat.succ` 都有一个指针 | 高效的任意精度整数  |
| `Int` | 和类型，带有表示正负值的构造子，每个包含一个 `Nat` | 高效的任意精度整数 |
| `UInt8`、`UInt16`、`UInt32`、`UInt64` | 带有合适边界的 `Fin` | 固定精度的机器整数 |
| `Char` | `UInt32` 以及与之配对的它是有效码位的证明 | 一般字符 |
| `String` | 在名为 `data` 的字段中包含 `List Char` 的结构体 | UTF-8 编码的字符串 |
| `Array α` | 在名为 `data` 的字段中包含 `List α` 的结构体 | 指向 `α` 值的指针打包的数组 |
| `Sort u` | 一个类型 | 完全擦除 |
| 命题的证明 | 当命题被视为证据类型时，命题所暗示的任何数据 | 完全擦除 |

<!--
## Exercise
-->

## 练习

<!--
The [definition of `Pos`](../type-classes/pos.html) does not take advantage of Lean's compilation of `Nat` to an efficient type.
At run time, it is essentially a linked list.
Alternatively, a subtype can be defined that allows Lean's fast `Nat` type to be used internally, as described [in the initial section on subtypes](../functor-applicative-monad/applicative.md#subtypes).
At run time, the proof will be erased.
Because the resulting structure has only a single data field, it is represented as that field, which means that this new representation of `Pos` is identical to that of `Nat`.
-->

[`Pos` 的 定义](../type-classes/pos.html) 并没有利用 Lean 将 `Nat` 编译成高效类型的优势。
在运行时，它本质上是一个链表。或者，可以定义一个子类型，允许在内部使用 Lean 的快速 `Nat` 类型，
如 [子类型的开头部分](../functor-applicative-monad/applicative.md#subtypes) 中所述。
在运行时，证明将被擦除。由于结果结构体只有一个数据字段，因此它会表示为该字段，
这意味着 `Pos` 的这种新表示与 `Nat` 的表示相同。

<!--
After proving the theorem `∀ {n k : Nat}, n ≠ 0 → k ≠ 0 → n + k ≠ 0`, define instances of `ToString`, and `Add` for this new representation of `Pos`. Then, define an instance of `Mul`, proving any necessary theorems along the way.
-->

在证明定理 `∀ {n k : Nat}, n ≠ 0 → k ≠ 0 → n + k ≠ 0` 之后，为 `Pos` 这种新的表示定义
`ToString` 和 `Add` 的实例。然后，定义 `Mul` 的实例，在此过程中证明任何必要的定理。
