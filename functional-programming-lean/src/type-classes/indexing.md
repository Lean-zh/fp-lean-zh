<!--
# Arrays and Indexing
-->

# 数组与索引

<!--
The [Interlude](../props-proofs-indexing.md) describes how to use indexing notation in order to look up entries in a list by their position.
This syntax is also governed by a type class, and it can be used for a variety of different types.
-->

在[插入章节](../props-proofs-indexing.md)中描述了如何使用索引符号来通过位置查找列表中的条目。
此语法也由类型类管理，并且可以用于各种不同的类型。

<!--
## Arrays
-->

## 数组
<!--
For instance, Lean arrays are much more efficient than linked lists for most purposes.
In Lean, the type `Array α` is a dynamically-sized array holding values of type `α`, much like a Java `ArrayList`, a C++ `std::vector`, or a Rust `Vec`.
Unlike `List`, which has a pointer indirection on each use of the `cons` constructor, arrays occupy a contiguous region of memory, which is much better for processor caches.
Also, looking up a value in an array takes constant time, while lookup in a linked list takes time proportional to the index being accessed.
-->

比如说，Lean 中的数组在多数情况下就比链表更为高效。在 Lean 中，`Array α` 类型是一个动态大小的数组，可以用来装类型为 `α` 的值。
这很像是 Java 中的 `ArrayList`，C++ 中的 `std::vector`，或者 Rust 中的 `Vec`。
不像是 `List` 在每一次用到 `cons` 构造子的地方都会有一个指针指向每个节点，数组会占用内存中一段连续的空间。这会带来更好的处理器缓存效果。
并且，在数组中查找值的时间复杂度为常数，但在链表中查找值所需要的时间则与遍历的节点数量成正比。

<!--
In pure functional languages like Lean, it is not possible to mutate a given position in a data structure.
Instead, a copy is made that has the desired modifications.
When using an array, the Lean compiler and runtime contain an optimization that can allow modifications to be implemented as mutations behind the scenes when there is only a single unique reference to an array.
-->

在像 Lean 这样的纯函数式语言中，在数据结构中改变某位置上的数据的值是不可能的。
相反，Lean 会制作一个副本，该副本具有所需的修改。
当使用一个数组时，Lean 编译器和运行时包含了一个优化：当该数组只被引用了一次时，会在幕后将制作副本优化为原地操作。

<!--
Arrays are written similarly to lists, but with a leading `#`:
-->

数组写起来很像列表，只是在开头多了一个 `#`：
```lean
{{#example_decl Examples/Classes.lean northernTrees}}
```
<!--
The number of values in an array can be found using `Array.size`.
For instance, `{{#example_in Examples/Classes.lean northernTreesSize}}` evaluates to `{{#example_out Examples/Classes.lean northernTreesSize}}`.
For indices that are smaller than an array's size, indexing notation can be used to find the corresponding value, just as with lists.
That is, `{{#example_in Examples/Classes.lean northernTreesTwo}}` evaluates to `{{#example_out Examples/Classes.lean northernTreesTwo}}`.
Similarly, the compiler requires a proof that an index is in bounds, and attempting to look up a value outside the bounds of the array results in a compile-time error, just as with lists.
For instance, `{{#example_in Examples/Classes.lean northernTreesEight}}` results in:
-->

数组中值的数量可以通过 `Array.size` 找到。
例如：`{{#example_in Examples/Classes.lean northernTreesSize}}` 结果是 `{{#example_out Examples/Classes.lean northernTreesSize}}`。
对于小于数组大小的索引值，索引符号可以被用来找到对应的值，就像列表一样。
就是说，`{{#example_in Examples/Classes.lean northernTreesTwo}}` 会被计算为 `{{#example_out Examples/Classes.lean northernTreesTwo}}`。
类似地，编译器需要一个索引值未越界的证明。尝试去查找越界的值会导致编译时错误，就和列表一样。
例如：`{{#example_in Examples/Classes.lean northernTreesEight}}` 的结果为：
```output error
{{#example_out Examples/Classes.lean northernTreesEight}}
```

<!--
## Non-Empty Lists
-->

## 非空列表

<!--
A datatype that represents non-empty lists can be defined as a structure with a field for the head of the list and a field for the tail, which is an ordinary, potentially empty list:
-->

一个表示非空列表的数据类型可以被定义为一个结构，这个结构有一个列表头字段，和一个尾字段。尾字段是一个常规的，可能为空的列表。
```lean
{{#example_decl Examples/Classes.lean NonEmptyList}}
```
<!--
For example, the non-empty list `idahoSpiders` (which contains some spider species native to the US state of Idaho) consists of `{{#example_out Examples/Classes.lean firstSpider}}` followed by four other spiders, for a total of five spiders:
-->

例如：非空列表 `idahoSpiders`（包含了一些美国爱达荷州的本土蜘蛛品种）由 `{{#example_out Examples/Classes.lean firstSpider}}` 和四种其它蜘蛛构成，一共有五种蜘蛛：
```lean
{{#example_decl Examples/Classes.lean idahoSpiders}}
```

<!--
Looking up the value at a specific index in this list with a recursive function should consider three possibilities:
 1. The index is `0`, in which case the head of the list should be returned.
 2. The index is `n + 1` and the tail is empty, in which case the index is out of bounds.
 3. The index is `n + 1` and the tail is non-empty, in which case the function can be called recursively on the tail and `n`.
-->

通过递归函数在列表中查找特定索引的值需要考虑到三种情况：
 1. 索引是 `0`，此时应返回列表头。
 2. 索引是 `n + 1` 并且列表尾是空的，这意味着索引越界了。
 3. 索引是 `n + 1` 并且列表尾非空，此时应该在列表尾上递归调用函数并传入 `n`。

<!--
For example, a lookup function that returns an `Option` can be written as follows:
-->

例如，一个返回 `Option` 的查找函数可以写成如下形式：
```lean
{{#example_decl Examples/Classes.lean NEListGetHuh}}
```
<!--
Each case in the pattern match corresponds to one of the possibilities above.
The recursive call to `get?` does not require a `NonEmptyList` namespace qualifier because the body of the definition is implicitly in the definition's namespace.
Another way to write this function uses `get?` for lists when the index is greater than zero:
-->

每种模式匹配的情况都对应于上面的一种可能性。
`get?` 的递归调用不需要 `NonEmptyList` 命名空间标识符，因为定义内部隐式地在定义的命名空间中。
另一种方式来编写这个函数是：当索引大于零时就将 `get?` 应用在列表上。
```lean
{{#example_decl Examples/Classes.lean NEListGetHuhList}}
```

<!--
If the list contains one entry, then only `0` is a valid index.
If it contains two entries, then both `0` and `1` are valid indices.
If it contains three entries, then `0`, `1`, and `2` are valid indices.
In other words, the valid indices into a non-empty list are natural numbers that are strictly less than the length of the list, which are less than or equal to the length of the tail.
-->

如果列表包含一个条目，那么只有 `0` 是合法的索引。
如果它包含两个条目，那么 `0` 和 `1` 是合法的索引。
如果它包含三个条目，那么 `0`, `1`, 和 `2` 都是合法的索引。
换句话说，非空列表的合法索引是严格小于列表长度的自然数。同时它也是小于等于列表尾的长度的。

<!--
The definition of what it means for an index to be in bounds should be written as an `abbrev` because the tactics used to find evidence that indices are acceptable are able to solve inequalities of numbers, but they don't know anything about the name `NonEmptyList.inBounds`:
-->

“索引值没有出界”意味着什么的这个定义，应该被写成一个 `abbrev`。
因为这个可以用来证明索引值未越界的策略（tactics）要在不知道 `NonEmptyList.inBounds` 这个方法的情况下解决数字之间的不等关系。
(此处原文表意不明，按原文字面意思译出。原文大致意思应为 `abbrev` 比 `def` 对tactic的适应性更好)
```lean
{{#example_decl Examples/Classes.lean inBoundsNEList}}
```
<!--
This function returns a proposition that might be true or false.
For instance, `2` is in bounds for `idahoSpiders`, while `5` is not:
-->

<!--
This function returns a proposition that might be true or false.
For instance, `2` is in bounds for `idahoSpiders`, while `5` is not:
-->

这个函数返回一个可能为真也可能为假的命题。
例如，`2` 对于 `idahoSpiders`未越界，而 `5` 就越界了。
```leantac
{{#example_decl Examples/Classes.lean spiderBoundsChecks}}
```
<!--
The logical negation operator has a very low precedence, which means that `¬idahoSpiders.inBounds 5` is equivalent to `¬(idahoSpiders.inBounds 5)`.
-->

逻辑非运算符有很低的结合度，这意味着 `¬idahoSpiders.inBounds 5` 等价于 `¬(idahoSpiders.inBounds 5)`。


<!--
This fact can be used to write a lookup function that requires evidence that the index is valid, and thus need not return `Option`, by delegating to the version for lists that checks the evidence at compile time:
-->

这个事实可被用于编写能证明索引值合法的查找函数，并且无需返回一个 `Option`。
该证据会在编译时检查。下面给出代码：
```lean
{{#example_decl Examples/Classes.lean NEListGet}}
```
<!--
It is, of course, possible to write this function to use the evidence directly, rather than delegating to a standard library function that happens to be able to use the same evidence.
This requires techniques for working with proofs and propositions that are described later in this book.
-->

当然，将这个函数写成直接用证据的形式也是可能的。
但这需要会玩证明和命题的一些技术，这些内容会在本书后续内容中提到。


<!--
## Overloading Indexing
-->

## 重载索引

<!--
Indexing notation for a collection type can be overloaded by defining an instance of the `GetElem` type class.
For the sake of flexiblity, `GetElem` has four parameters:
 * The type of the collection
 * The type of the index
 * The type of elements that are extracted from the collection
 * A function that determines what counts as evidence that the index is in bounds
-->

对于集合类型的索引符号，可通过定义 `GetElem` 类型类的实例来重载。
出于灵活性考虑，`GetElem` 有四个参数：
 * 集合的类型
 * 索引的类型
 * 集合中元素的类型
 * 一个函数，用于确定什么是索引在边界内的证据

<!--
The element type and the evidence function are both output parameters.
`GetElem` has a single method, `getElem`, which takes a collection value, an index value, and evidence that the index is in bounds as arguments, and returns an element:
-->

元素类型和证明函数都是输出参数。
`GetElem` 有一个方法 —— `getElem` —— 接受一个集合值，一个索引值，和一个索引未越界的证明，并且返回一个元素：
```lean
{{#example_decl Examples/Classes.lean GetElem}}
```

<!--
In the case of `NonEmptyList α`, these parameters are:
 * The collection is `NonEmptyList α`
 * Indices have type `Nat`
 * The type of elements is `α`
 * An index is in bounds if it is less than or equal to the length of the tail
-->

在 `NonEmptyList α` 中，这些参数是：
 * 集合是 `NonEmptyList α`
 * 索引的类型是 `Nat`
 * 元素的类型是 `α`
 * 索引如果小于等于列表尾那么就没有越界

<!--
In fact, the `GetElem` instance can delegate directly to `NonEmptyList.get`:
-->

事实上，`GetElem` 实例可以直接使用 `NonEmptyList.get`：
```lean
{{#example_decl Examples/Classes.lean GetElemNEList}}
```
<!--
With this instance, `NonEmptyList` becomes just as convenient to use as `List`.
Evaluating `{{#example_in Examples/Classes.lean firstSpider}}` yields `{{#example_out Examples/Classes.lean firstSpider}}`, while `{{#example_in Examples/Classes.lean tenthSpider}}` leads to the compile-time error:
-->

有了这个实例，`NonEmptyList` 就和 `List` 一样方便了。
计算 `{{#example_in Examples/Classes.lean firstSpider}}` 结果为 `{{#example_out Examples/Classes.lean firstSpider}}`，而 `{{#example_in Examples/Classes.lean tenthSpider}}` 会导致编译时错误：
```output error
{{#example_out Examples/Classes.lean tenthSpider}}
```

<!--
Because both the collection type and the index type are input parameters to the `GetElem` type class, new types can be used to index into existing collections.
The positive number type `Pos` is a perfectly reasonable index into a `List`, with the caveat that it cannot point at the first entry.
The follow instance of `GetElem` allows `Pos` to be used just as conveniently as `Nat` to find a list entry:
-->

因为集合的类型和索引的类型都是 `GetElem` 类型类的参数，所以可以使用新类型来索引现有的集合。
之前的 `Pos` 是一个完全合理的可以用来索引 `List` 的类型，但注意它不能指向第一个条目。
下面 `GetElem` 的实例使 `Pos` 在查找列表条目方面和 `Nat` 一样方便。
```lean
{{#example_decl Examples/Classes.lean ListPosElem}}
```

<!--
Indexing can also make sense for non-numeric indices.
For example, `Bool` can be used to select between the fields in a point, with `false` corresponding to `x` and `true` corresponding to `y`:
-->

使用非数字索引值来进行索引也可以是合理的。
例如：`Bool` 也可以被用于选择点中的字段，比如我们可以让 `false` 对应于 `x`，`true` 对应于 `y`：
```lean
{{#example_decl Examples/Classes.lean PPointBoolGetElem}}
```
<!--
In this case, both Booleans are valid indices.
Because every possible `Bool` is in bounds, the evidence is simply the true proposition `True`.
-->

在这个例子中，布尔值都是合法的索引。
因为每个可能的 `Bool` 值都是未越界的，证据我们只需简单地给出 `True` 命题。
