import VersoManual
import FPLeanZh.Examples

open Verso.Genre Manual
open Verso.Code.External

open FPLeanZh

set_option verso.exampleProject "../examples"
set_option verso.exampleModule "Examples.SpecialTypes"

#doc (Manual) "特殊类型" =>
%%%
tag := "runtime-special-types"
file := "SpecialTypes"
%%%
-- Special Types

-- Understanding the representation of data in memory is very important.
-- Usually, the representation can be understood from the definition of a datatype.
-- Each constructor corresponds to an object in memory that has a header that includes a tag and a reference count.
-- The constructor's arguments are each represented by a pointer to some other object.
-- In other words, {anchorName all}`List` really is a linked list and extracting a field from a {kw}`structure` really does just chase a pointer.

理解数据在内存中的表示非常重要。通常，可以从数据类型的定义中理解它的表示。
每个构造子对应于内存中的一个对象，该对象有一个包含标记和引用计数的头。
构造子的参数分别由指向其他对象的指针表示。换句话说，{anchorName all}`List` 实际上是一个链表，
从 {kw}`structure` 中提取一个字段实际上只是跟随一个指针。

-- There are, however, some important exceptions to this rule.
-- A number of types are treated specially by the compiler.
-- For example, the type {anchorName all}`UInt32` is defined as {anchorTerm all}`Fin (2 ^ 32)`, but it is replaced at run-time with an actual native implementation based on machine words.
-- Similarly, even though the definition of {anchorName all}`Nat` suggests an implementation similar to {anchorTerm all}`List Unit`, the actual run-time representation uses immediate machine words for sufficiently-small numbers and an efficient arbitrary-precision arithmetic library for larger numbers.
-- The Lean compiler translates from definitions that use pattern matching into the appropriate operations for this representation, and calls to operations like addition and subtraction are mapped to fast operations from the underlying arithmetic library.
-- After all, addition should not take time linear in the size of the addends.

然而，这个规则有一些重要的例外。编译器对许多类型进行了特殊处理。
例如，类型 {anchorName all}`UInt32` 被定义为 {anchorTerm all}`Fin (2 ^ 32)`，但在运行时它会被替换为基于机器字的实际原生实现。
类似地，尽管 {anchorName all}`Nat` 的定义暗示了一个类似于 {anchorTerm all}`List Unit` 的实现，
但实际的运行时表示会对足够小的数字使用立即（immediate）机器字，
对较大的数字则使用高效的任意精度算术库。Lean 编译器会将使用模式匹配的定义转换为与其表示对应的适当操作，
并且对加法和减法等操作的调用会被映射到底层算术库中的快速操作。
毕竟，加法不应该花费与加数大小成线性的时间。

-- The fact that some types have special representations also means that care is needed when working with them.
-- Most of these types consist of a {kw}`structure` that is treated specially by the compiler.
-- With these structures, using the constructor or the field accessors directly can trigger an expensive conversion from an efficient representation to a slow one that is convenient for proofs.
-- For example, {anchorName all}`String` is defined as a structure that contains a list of characters, but the run-time representation of strings uses UTF-8, not linked lists of pointers to characters.
-- Applying the constructor to a list of characters creates a byte array that encodes them in UTF-8, and accessing the field of the structure takes time linear in the length of the string to decode the UTF-8 representation and allocate a linked list.
-- Arrays are represented similarly.
-- From the logical perspective, arrays are structures that contain a list of array elements, but the run-time representation is a dynamically-sized array.
-- At run time, the constructor translates the list into an array, and the field accessor allocates a linked list from the array.
-- The various array operations are replaced with efficient versions by the compiler that mutate the array when possible instead of allocating a new one.

由于某些类型具有特殊表示，因此在使用它们时需要小心。
这些类型中的大多数由编译器特殊处理的 {kw}`structure` 组成。对于这些结构体，
直接使用构造子或字段访问器可能会触发从高效表示到方便证明的低效表示的昂贵转换。
例如，{anchorName all}`String` 被定义为包含字符列表的结构体，但字符串的运行时表示使用了 UTF-8，
而非指向字符的指针链表。将构造子应用于字符列表会创建一个以 UTF-8 编码它们的字节数组，
而访问结构体的字段需要线性时间来解码 UTF-8 的表示并分配一个链表。数组的表示方式类似。
从逻辑角度来看，数组是包含数组元素列表的结构体，但运行时表示则是一个动态大小的数组。
在运行时，构造子会将列表转换为数组，而字段访问器则会在数组中分配一个链表。
编译器用高效的版本替换了各种数组操作，这些版本在可能的情况下会改变数组，而非分配一个新的数组。

-- Both types themselves and proofs of propositions are completely erased from compiled code.
-- In other words, they take up no space, and any computations that might have been performed as part of a proof are similarly erased.
-- This means that proofs can take advantage of the convenient interface to strings and arrays as inductively-defined lists, including using induction to prove things about them, without imposing slow conversion steps while the program is running.
-- For these built-in types, a convenient logical representation of the data does not imply that the program must be slow.

类型本身和命题的证明都会从编译后的代码中完全擦除。换句话说，它们不会占用任何空间，
证明过程中可能执行的任何计算也同样会被擦除，
这意味着证明可以利用字符串和数组作为归纳定义列表的简便接口，包括使用归纳法来证明它们，
而不会在程序运行时施加缓慢的转换步骤。对于这些内置类型，数据的简便逻辑表示并不意味着程序一定会很慢。

-- If a structure type has only a single non-type non-proof field, then the constructor itself disappears at run time, being replaced with its single argument.
-- In other words, a subtype is represented identically to its underlying type, rather than with an extra layer of indirection.
-- Similarly, {anchorName all}`Fin` is just {anchorName all}`Nat` in memory, and single-field structures can be created to keep track of different uses of {anchorName all}`Nat`s or {anchorName all}`String`s without paying a performance penalty.
-- If a constructor has no non-type non-proof arguments, then the constructor also disappears and is replaced with a constant value where the pointer would otherwise be used.
-- This means that {anchorName all}`true`, {anchorName all}`false`, and {anchorName all}`none` are constant values, rather than pointers to heap-allocated objects.

如果一个结构体类型只有一个非类型，非证明的字段，那么构造子自身会在运行时消失，
并被替换为其单个参数。换句话说，其子类型与其底层类型完全相同，不会带有额外的间接层。
同样，{anchorName all}`Fin` 在内存中只是 {anchorName all}`Nat`，并且可以创建单字段结构体来跟踪 {anchorName all}`Nat` 或 {anchorName all}`String` 的不同用法，
而无需支付性能损失。如果一个构造子没有非类型，非证明的参数，那么该构造子也会消失，
并被一个常量值替换，否则指针将用于该常量值。这意味着 {anchorName all}`true`、{anchorName all}`false` 和 {anchorName all}`none` 是常量值，
而非指向堆分配对象的指针。


-- The following types have special representations:

以下类型拥有特殊的表示：

-- :::table +header
-- *
--   * Type
--   * Logical representation
--   * Run-time Representation

-- *
--   * {anchorName all}`Nat`
--   * Unary, with one pointer from each {anchorTerm all}`Nat.succ`
--   * Efficient arbitrary-precision integers

-- *
--   * {anchorName all}`Int`
--   * A sum type with constructors for positive or negative values, each containing a {anchorName all}`Nat`
--   * Efficient arbitrary-precision integers

-- *
--   * {anchorTerm all}`BitVec w`
--   * A {anchorName all}`Fin` with an appropriate bound $`2^w`
--   * Efficient arbitrary-precision integers

-- *
--   * {anchorName all}`UInt8`, {anchorName all}`UInt16`, {anchorName all}`UInt32`, {anchorName all}`UInt64`, {anchorName all}`USize`
--   * A bitvector of the correct width
--   * Fixed-precision machine integers

-- *
--   * {anchorName all}`Int8`, {anchorName all}`Int16`, {anchorName all}`Int32`, {anchorName all}`Int64`, {anchorName all}`ISize`
--   * A wrapped unsigned integer of the same width
--   * Fixed-precision machine integers

-- *
--   * {anchorName all}`Char`
--   * A {anchorName all}`UInt32` paired with a proof that it's a valid code point
--   * Ordinary characters

-- *
--   * {anchorName all}`String`
--   * A structure that contains a {anchorTerm all}`List Char` in a field called {anchorTerm StringDetail}`data`
--   * UTF-8-encoded string

-- *
--   * {anchorTerm sequences}`Array α`
--   * A structure that contains a {anchorTerm sequences}`List α` in a field called {anchorName sequences}`toList`
--   * Packed arrays of pointers to {anchorName sequences}`α` values

-- *
--   * {anchorTerm all}`Sort u`
--   * A type
--   * Erased completely

-- *
--   * Proofs of propositions
--   * Whatever data is suggested by the proposition when considered as a type of evidence
--   * Erased completely
-- :::

:::table +header
*
  * 类型
  * 逻辑表示
  * 运行时表示

*
  * {anchorName all}`Nat`
  * 一元（Unary），每个 {anchorTerm all}`Nat.succ` 都有一个指针
  * 高效的任意精度整数

*
  * {anchorName all}`Int`
  * 一个和类型（Sum Type），具有正值或负值的构造子，每个都包含一个 {anchorName all}`Nat`
  * 高效的任意精度整数

*
  * {anchorTerm all}`BitVec w`
  * 一个具有适当界限 $`2^w` 的 {anchorName all}`Fin`
  * 高效的任意精度整数

*
  * {anchorName all}`UInt8`, {anchorName all}`UInt16`, {anchorName all}`UInt32`, {anchorName all}`UInt64`, {anchorName all}`USize`
  * 正确宽度的位向量
  * 固定精度机器整数

*
  * {anchorName all}`Int8`, {anchorName all}`Int16`, {anchorName all}`Int32`, {anchorName all}`Int64`, {anchorName all}`ISize`
  * 相同宽度的包装无符号整数
  * 固定精度机器整数

*
  * {anchorName all}`Char`
  * 一个 {anchorName all}`UInt32` 配对一个它是有效代码点的证明
  * 普通字符

*
  * {anchorName all}`String`
  * 一个结构体，包含一个 {anchorTerm all}`List Char` 在名为 {anchorTerm StringDetail}`data` 的字段中
  * UTF-8 编码的字符串

*
  * {anchorTerm sequences}`Array α`
  * 一个结构体，包含一个 {anchorTerm sequences}`List α` 在名为 {anchorName sequences}`toList` 的字段中
  * 指向 {anchorName sequences}`α` 值的指针的打包数组

*
  * {anchorTerm all}`Sort u`
  * 一个类型
  * 完全擦除

*
  * 命题的证明
  * 当被视为证据类型时，命题所暗示的任何数据
  * 完全擦除
:::

-- # Exercise
# 练习
%%%
tag := "runtime-special-types-exercise"
%%%

-- The {ref "positive-numbers"}[definition of {anchorName Pos (module := Examples.Classes)}`Pos`] does not take advantage of Lean's compilation of {anchorName all}`Nat` to an efficient type.
-- At run time, it is essentially a linked list.
-- Alternatively, a subtype can be defined that allows Lean's fast {anchorName all}`Nat` type to be used internally, as described {ref "subtypes"}[in the initial section on subtypes].
-- At run time, the proof will be erased.
-- Because the resulting structure has only a single data field, it is represented as that field, which means that this new representation of {anchorName Pos (module := Examples.Classes)}`Pos` is identical to that of {anchorName all}`Nat`.
--
-- After proving the theorem {anchorTerm all}`∀ {n k : Nat}, n ≠ 0 → k ≠ 0 → n + k ≠ 0`, define instances of {anchorName all}`ToString`, and {anchorName all}`Add` for this new representation of {anchorName Pos (module := Examples.Classes)}`Pos`. Then, define an instance of {anchorName all}`Mul`, proving any necessary theorems along the way.

{ref "positive-numbers"}[{anchorName Pos (module := Examples.Classes)}`Pos` 的定义] 没有利用 Lean 将 {anchorName all}`Nat` 编译为高效类型的优势。
在运行时，它本质上是一个链表。
或者，可以定义一个子类型，允许在内部使用 Lean 的快速 {anchorName all}`Nat` 类型，如 {ref "subtypes"}[子类型的初始部分] 所述。
在运行时，证明将被擦除。
因为生成的结构体只有一个数据字段，所以它被表示为该字段，这意味着 {anchorName Pos (module := Examples.Classes)}`Pos` 的这种新表示与 {anchorName all}`Nat` 的表示相同。

在证明了定理 {anchorTerm all}`∀ {n k : Nat}, n ≠ 0 → k ≠ 0 → n + k ≠ 0` 之后，为 {anchorName Pos (module := Examples.Classes)}`Pos` 的这种新表示定义 {anchorName all}`ToString` 和 {anchorName all}`Add` 的实例。然后，定义 {anchorName all}`Mul` 的实例，并在此过程中证明任何必要的定理。
