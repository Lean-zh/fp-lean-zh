import VersoManual
import FPLeanZh.Examples

open Verso.Genre Manual
open Verso Code External

open FPLeanZh

set_option verso.exampleProject "../examples"
set_option verso.exampleModule "Examples.Classes"

set_option pp.rawOnError true

-- Arrays and Indexing
#doc (Manual) "数组和索引" =>
%%%
file := "Indexing"
tag := "indexing"
%%%

-- The {ref "props-proofs-indexing"}[Interlude] describes how to use indexing notation in order to look up entries in a list by their position.
-- This syntax is also governed by a type class, and it can be used for a variety of different types.

{ref "props-proofs-indexing"}[插曲] 描述了如何使用索引表示法按位置查找列表中的条目。
此语法也由类型类控制，并且可以用于各种不同的类型。

-- # Arrays
# 数组
%%%
tag := "array-indexing"
%%%

-- For instance, Lean arrays are much more efficient than linked lists for most purposes.
-- In Lean, the type {anchorTerm arrVsList}`Array α` is a dynamically-sized array holding values of type {anchorName arrVsList}`α`, much like a Java {java}`ArrayList`, a C++ {cpp}`std::vector`, or a Rust {rust}`Vec`.
-- Unlike {anchorTerm arrVsList}`List`, which has a pointer indirection on each use of the {anchorName arrVsList}`cons` constructor, arrays occupy a contiguous region of memory, which is much better for processor caches.
-- Also, looking up a value in an array takes constant time, while lookup in a linked list takes time proportional to the index being accessed.


例如，对于大多数用途，Lean 数组比链表效率高得多。
在 Lean 中，类型 {anchorTerm arrVsList}`Array α` 是一个动态大小的数组，用于保存类型为 {anchorName arrVsList}`α` 的值，非常类似于 Java {java}`ArrayList`、C++ {cpp}`std::vector` 或 Rust {rust}`Vec`。
与在每次使用 {anchorName arrVsList}`cons` 构造函数时都有指针间接的 {anchorTerm arrVsList}`List` 不同，数组占用连续的内存区域，这对于处理器缓存要好得多。
此外，在数组中查找值需要常量时间，而在链表中查找则需要与所访问索引成比例的时间。

-- In pure functional languages like Lean, it is not possible to mutate a given position in a data structure.
-- Instead, a copy is made that has the desired modifications.
-- However, copying is not always necessary: the Lean compiler and runtime contain an optimization that can allow modifications to be implemented as mutations behind the scenes when there is only a single unique reference to an array.

在像 Lean 这样的纯函数式语言中，不可能改变数据结构中给定位置的值。
取而代之的是，会创建一个具有所需修改的副本。
然而，复制并非总是必要的：Lean 编译器和运行时包含一个优化，当只有一个对数组的唯一引用时，可以允许将修改作为幕后突变来实现。

-- Arrays are written similarly to lists, but with a leading {lit}`#`:

数组的写法与列表类似，但以 {lit}`#` 开头：

```anchor northernTrees
def northernTrees : Array String :=
  #["sloe", "birch", "elm", "oak"]
```

-- The number of values in an array can be found using {anchorName arrVsList}`Array.size`.
-- For instance, {anchorTerm northernTreesSize}`northernTrees.size` evaluates to {anchorTerm northernTreesSize}`4`.
-- For indices that are smaller than an array's size, indexing notation can be used to find the corresponding value, just as with lists.
-- That is, {anchorTerm northernTreesTwo}`northernTrees[2]` evaluates to {anchorTerm northernTreesTwo}`"elm"`.
-- Similarly, the compiler requires a proof that an index is in bounds, and attempting to look up a value outside the bounds of the array results in a compile-time error, just as with lists.
-- For instance, {anchorTerm northernTreesEight}`northernTrees[8]` results in:

可以使用 {anchorName arrVsList}`Array.size` 找到数组中的值的数量。
例如，{anchorTerm northernTreesSize}`northernTrees.size` 的计算结果为 {anchorTerm northernTreesSize}`4`。
对于小于数组大小的索引，可以使用索引表示法来查找相应的值，就像列表一样。
也就是说，{anchorTerm northernTreesTwo}`northernTrees[2]` 的计算结果为 {anchorTerm northernTreesTwo}`"elm"`。
同样，编译器需要一个证明索引在边界内的证据，并且尝试查找数组边界外的值会导致编译时错误，就像列表一样。
例如，{anchorTerm northernTreesEight}`northernTrees[8]` 会导致：

```anchorError northernTreesEight
failed to prove index is valid, possible solutions:
  - Use `have`-expressions to prove the index is valid
  - Use `a[i]!` notation instead, runtime check is performed, and 'Panic' error message is produced if index is not valid
  - Use `a[i]?` notation instead, result is an `Option` type
  - Use `a[i]'h` notation instead, where `h` is a proof that index is valid
⊢ 8 < northernTrees.size
```

-- # Non-Empty Lists
# 非空列表
%%%
tag := "non-empty-list-indexing"
%%%

-- A datatype that represents non-empty lists can be defined as a structure with a field for the head of the list and a field for the tail, which is an ordinary, potentially empty list:

表示非空列表的数据类型可以定义为一个结构，其中一个字段用于列表的头部，另一个字段用于尾部，尾部是一个普通的、可能为空的列表：

```anchor NonEmptyList
structure NonEmptyList (α : Type) : Type where
  head : α
  tail : List α
```

-- For example, the non-empty list {moduleName}`idahoSpiders` (which contains some spider species native to the US state of Idaho) consists of {anchorTerm firstSpider}`"Banded Garden Spider"` followed by four other spiders, for a total of five spiders:

例如，非空列表 {moduleName}`idahoSpiders`（其中包含一些原产于美国爱达荷州的蜘蛛物种）由 {anchorTerm firstSpider}`"Banded Garden Spider"` 和其他四种蜘蛛组成，总共五种蜘蛛：

```anchor idahoSpiders
def idahoSpiders : NonEmptyList String := {
  head := "Banded Garden Spider",
  tail := [
    "Long-legged Sac Spider",
    "Wolf Spider",
    "Hobo Spider",
    "Cat-faced Spider"
  ]
}
```

-- Looking up the value at a specific index in this list with a recursive function should consider three possibilities:
--  1. The index is {anchorTerm NEListGetHuh}`0`, in which case the head of the list should be returned.
--  2. The index is {anchorTerm NEListGetHuh}`n + 1` and the tail is empty, in which case the index is out of bounds.
--  3. The index is {anchorTerm NEListGetHuh}`n + 1` and the tail is non-empty, in which case the function can be called recursively on the tail and {anchorTerm NEListGetHuh}`n`.

使用递归函数在此列表中查找特定索引处的值应考虑三种可能性：
 1. 索引为 {anchorTerm NEListGetHuh}`0`，在这种情况下应返回列表的头部。
 2. 索引为 {anchorTerm NEListGetHuh}`n + 1` 且尾部为空，在这种情况下索引越界。
 3. 索引为 {anchorTerm NEListGetHuh}`n + 1` 且尾部不为空，在这种情况下可以对尾部和 {anchorTerm NEListGetHuh}`n` 递归调用该函数。

-- For example, a lookup function that returns an {moduleName}`Option` can be written as follows:

例如，一个返回 {moduleName}`Option` 的查找函数可以写成如下：

```anchor NEListGetHuh
def NonEmptyList.get? : NonEmptyList α → Nat → Option α
  | xs, 0 => some xs.head
  | {head := _, tail := []}, _ + 1 => none
  | {head := _, tail := h :: t}, n + 1 => get? {head := h, tail := t} n
```

-- Each case in the pattern match corresponds to one of the possibilities above.
-- The recursive call to {anchorName NEListGetHuh}`get?` does not require a {moduleName}`NonEmptyList` namespace qualifier because the body of the definition is implicitly in the definition's namespace.
-- Another way to write this function uses a list lookup {anchorTerm NEListGetHuhList}`xs.tail[n]?` when the index is greater than zero:

模式匹配中的每种情况都对应于上述可能性之一。
对 {anchorName NEListGetHuh}`get?` 的递归调用不需要 {moduleName}`NonEmptyList` 命名空间限定符，因为定义的正文隐式地位于定义的命名空间。
编写此函数的另一种方法是在索引大于零时使用列表查找 {anchorTerm NEListGetHuhList}`xs.tail[n]?`：

```anchor NEListGetHuhList
def NonEmptyList.get? : NonEmptyList α → Nat → Option α
  | xs, 0 => some xs.head
  | xs, n + 1 => xs.tail[n]?
```

-- If the list contains one entry, then only {anchorTerm nats}`0` is a valid index.
-- If it contains two entries, then both {anchorTerm nats}`0` and {anchorTerm nats}`1` are valid indices.
-- If it contains three entries, then {anchorTerm nats}`0`, {anchorTerm nats}`1`, and {anchorTerm nats}`2` are valid indices.
-- In other words, the valid indices into a non-empty list are natural numbers that are strictly less than the length of the list, which are less than or equal to the length of the tail.

如果列表包含一个条目，则只有 {anchorTerm nats}`0` 是有效索引。
如果它包含两个条目，则 {anchorTerm nats}`0` 和 {anchorTerm nats}`1` 都是有效索引。
如果它包含三个条目，则 {anchorTerm nats}`0`、{anchorTerm nats}`1` 和 {anchorTerm nats}`2` 都是有效索引。
换句话说，非空列表的有效索引是严格小于列表长度的自然数，即小于或等于尾部长度。

-- The definition of what it means for an index to be in bounds should be written as an {kw}`abbrev` because the tactics used to find evidence that indices are acceptable are able to solve inequalities of numbers, but they don't know anything about the name {moduleName}`NonEmptyList.inBounds`:

索引在边界内的含义的定义应写为 {kw}`abbrev`，因为用于查找索引可接受证据的策略能够解决数字不等式，但它们对名称 {moduleName}`NonEmptyList.inBounds` 一无所知：

```anchor inBoundsNEList
abbrev NonEmptyList.inBounds (xs : NonEmptyList α) (i : Nat) : Prop :=
  i ≤ xs.tail.length
```

-- This function returns a proposition that might be true or false.
-- For instance, {anchorTerm spiderBoundsChecks}`2` is in bounds for {moduleName}`idahoSpiders`, while {anchorTerm spiderBoundsChecks}`5` is not:

此函数返回一个可能为真或为假的命题。
例如，{anchorTerm spiderBoundsChecks}`2` 在 {moduleName}`idahoSpiders` 的边界内，而 {anchorTerm spiderBoundsChecks}`5` 不在：

```anchor spiderBoundsChecks
theorem atLeastThreeSpiders : idahoSpiders.inBounds 2 := by decide

theorem notSixSpiders : ¬idahoSpiders.inBounds 5 := by decide
```

-- The logical negation operator has a very low precedence, which means that {anchorTerm spiderBoundsChecks}`¬idahoSpiders.inBounds 5` is equivalent to {anchorTerm spiderBoundsChecks'}`¬(idahoSpiders.inBounds 5)`.

逻辑非运算符的优先级非常低，这意味着 {anchorTerm spiderBoundsChecks}`¬idahoSpiders.inBounds 5` 等价于 {anchorTerm spiderBoundsChecks'}`¬(idahoSpiders.inBounds 5)`。

-- This fact can be used to write a lookup function that requires evidence that the index is valid, and thus need not return {moduleName}`Option`, by delegating to the version for lists that checks the evidence at compile time:

这个事实可以用来编写一个查找函数，该函数需要索引有效的证据，因此不必返回 {moduleName}`Option`，方法是委托给在编译时检查证据的列表版本：

```anchor NEListGet
def NonEmptyList.get (xs : NonEmptyList α)
    (i : Nat) (ok : xs.inBounds i) : α :=
  match i with
  | 0 => xs.head
  | n + 1 => xs.tail[n]
```

-- It is, of course, possible to write this function to use the evidence directly, rather than delegating to a standard library function that happens to be able to use the same evidence.
-- This requires techniques for working with proofs and propositions that are described later in this book.

当然，也可以编写此函数以直接使用证据，而不是委托给恰好能够使用相同证据的标准库函数。
这需要本书后面描述的用于处理证明和命题的技术。

-- # Overloading Indexing
# 重载索引
%%%
tag := "overloading-indexing"
%%%

-- Indexing notation for a collection type can be overloaded by defining an instance of the {anchorName GetElem}`GetElem` type class.
-- For the sake of flexibility, {anchorName GetElem}`GetElem` has four parameters:
--  * The type of the collection
--  * The type of the index
--  * The type of elements that are extracted from the collection
--  * A function that determines what counts as evidence that the index is in bounds

集合类型的索引表示法可以通过定义 {anchorName GetElem}`GetElem` 类型类的实例来重载。
为了灵活性，{anchorName GetElem}`GetElem` 有四个参数：
 * 集合的类型
 * 索引的类型
 * 从集合中提取的元素的类型
 * 一个函数，用于确定什么算作索引在边界内的证据

-- The element type and the evidence function are both output parameters.
-- {anchorName GetElem}`GetElem` has a single method, {anchorName GetElem}`getElem`, which takes a collection value, an index value, and evidence that the index is in bounds as arguments, and returns an element:

元素类型和证据函数都是输出参数。
{anchorName GetElem}`GetElem` 有一个方法，{anchorName GetElem}`getElem`，它接受一个集合值、一个索引值和索引在边界内的证据作为参数，并返回一个元素：

```anchor GetElem
class GetElem
    (coll : Type)
    (idx : Type)
    (item : outParam Type)
    (inBounds : outParam (coll → idx → Prop)) where
  getElem : (c : coll) → (i : idx) → inBounds c i → item
```

-- In the case of {anchorTerm GetElemNEList}`NonEmptyList α`, these parameters are:
--  * The collection is {anchorTerm GetElemNEList}`NonEmptyList α`
--  * Indices have type {anchorName GetElemNEList}`Nat`
--  * The type of elements is {anchorName GetElemNEList}`α`
--  * An index is in bounds if it is less than or equal to the length of the tail

在 {anchorTerm GetElemNEList}`NonEmptyList α` 的情况下，这些参数是：
 * 集合是 {anchorTerm GetElemNEList}`NonEmptyList α`
 * 索引的类型为 {anchorName GetElemNEList}`Nat`
 * 元素的类型为 {anchorName GetElemNEList}`α`
 * 如果索引小于或等于尾部的长度，则索引在边界内

-- In fact, the {anchorTerm GetElemNEList}`GetElem` instance can delegate directly to {anchorTerm GetElemNEList}`NonEmptyList.get`:

实际上，{anchorTerm GetElemNEList}`GetElem` 实例可以直接委托给 {anchorTerm GetElemNEList}`NonEmptyList.get`：

```anchor GetElemNEList
instance : GetElem (NonEmptyList α) Nat α NonEmptyList.inBounds where
  getElem := NonEmptyList.get
```

-- With this instance, {anchorTerm GetElemNEList}`NonEmptyList` becomes just as convenient to use as {moduleName}`List`.
-- Evaluating {anchorTerm firstSpider}`idahoSpiders.head` yields {anchorTerm firstSpider}`"Banded Garden Spider"`, while {anchorTerm tenthSpider}`idahoSpiders[9]` leads to the compile-time error:

有了这个实例，{anchorTerm GetElemNEList}`NonEmptyList` 的使用就和 {moduleName}`List` 一样方便了。
计算 {anchorTerm firstSpider}`idahoSpiders.head` 会得到 {anchorTerm firstSpider}`"Banded Garden Spider"`，而 {anchorTerm tenthSpider}`idahoSpiders[9]` 会导致编译时错误：

```anchorError tenthSpider
failed to prove index is valid, possible solutions:
  - Use `have`-expressions to prove the index is valid
  - Use `a[i]!` notation instead, runtime check is performed, and 'Panic' error message is produced if index is not valid
  - Use `a[i]?` notation instead, result is an `Option` type
  - Use `a[i]'h` notation instead, where `h` is a proof that index is valid
⊢ idahoSpiders.inBounds 9
```

-- Because both the collection type and the index type are input parameters to the {anchorTerm ListPosElem}`GetElem` type class, new types can be used to index into existing collections.
-- The positive number type {anchorTerm ListPosElem}`Pos` is a perfectly reasonable index into a {anchorTerm ListPosElem}`List`, with the caveat that it cannot point at the first entry.
-- The following instance of {anchorTerm ListPosElem}`GetElem` allows {anchorTerm ListPosElem}`Pos` to be used just as conveniently as {moduleName}`Nat` to find a list entry:

因为集合类型和索引类型都是 {anchorTerm ListPosElem}`GetElem` 类型类的输入参数，所以新类型可以用于索引到现有集合中。
正数类型 {anchorTerm ListPosElem}`Pos` 是一个完全合理的 {anchorTerm ListPosElem}`List` 索引，但需要注意的是它不能指向第一个条目。
{anchorTerm ListPosElem}`GetElem` 的以下实例允许像使用 {moduleName}`Nat` 一样方便地使用 {anchorTerm ListPosElem}`Pos` 来查找列表条目：

```anchor ListPosElem
instance : GetElem (List α) Pos α
    (fun list n => list.length > n.toNat) where
  getElem (xs : List α) (i : Pos) ok := xs[i.toNat]
```

-- Indexing can also make sense for non-numeric indices.
-- For example, {moduleName}`Bool` can be used to select between the fields in a point, with {moduleName}`false` corresponding to {anchorTerm PPointBoolGetElem}`x` and {moduleName}`true` corresponding to {anchorTerm PPointBoolGetElem}`y`:

索引对于非数字索引也可能很有意义。
例如，{moduleName}`Bool` 可用于在点的字段之间进行选择，其中 {moduleName}`false` 对应于 {anchorTerm PPointBoolGetElem}`x`，{moduleName}`true` 对应于 {anchorTerm PPointBoolGetElem}`y`：

```anchor PPointBoolGetElem
instance : GetElem (PPoint α) Bool α (fun _ _ => True) where
  getElem (p : PPoint α) (i : Bool) _ :=
    if not i then p.x else p.y
```

-- In this case, both Booleans are valid indices.
-- Because every possible {moduleName}`Bool` is in bounds, the evidence is simply the true proposition {moduleName}`True`.

在这种情况下，两个布尔值都是有效索引。
因为每个可能的 {moduleName}`Bool` 都在边界内，所以证据就是真命题 {moduleName}`True`。
