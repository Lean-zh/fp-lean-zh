import VersoManual
import FPLeanZh.Examples

open Verso.Genre Manual
open Verso.Code.External

open FPLeanZh

set_option verso.exampleProject "../examples"
set_option verso.exampleModule "Examples.DependentTypes.Pitfalls"

#doc (Manual) "依赖类型编程的陷阱" =>

-- The flexibility of dependent types allows more useful programs to be accepted by a type checker, because the language of types is expressive enough to describe variations that less-expressive type systems cannot.
-- At the same time, the ability of dependent types to express very fine-grained specifications allows more buggy programs to be rejected by a type checker.
-- This power comes at a cost.

依赖类型的灵活性允许类型检查器接受更有用的程序，因为类型语言的表达能力足以描述表达能力较弱的类型系统无法描述的变体。
同时，依赖类型表达非常细粒度规范的能力允许类型检查器拒绝更多有缺陷的程序。
这种能力是有代价的。

-- The close coupling between the internals of type-returning functions such as {anchorName Row (module:=Examples.DependentTypes.DB)}`Row` and the types that they produce is an instance of a bigger difficulty: the distinction between the interface and the implementation of functions begins to break down when functions are used in types.
-- Normally, all refactorings are valid as long as they don't change the type signature or input-output behavior of a function.
-- Functions can be rewritten to use more efficient algorithms and data structures, bugs can be fixed, and code clarity can be improved without breaking client code.
-- When the function is used in a type, however, the internals of the function's implementation become part of the type, and thus part of the _interface_ to another program.

像 {anchorName Row (module:=Examples.DependentTypes.DB)}`Row` 这样的返回类型函数的内部与它们产生的类型之间的紧密耦合是一个更大的困难的实例：当函数在类型中使用时，函数接口和实现之间的区别开始瓦解。
通常，只要不改变函数的类型签名或输入-输出行为，所有重构都是有效的。
可以重写函数以使用更高效的算法和数据结构，可以修复错误，并且可以提高代码清晰度，而不会破坏客户端代码。
然而，当函数在类型中使用时，函数实现的内部成为类型的一部分，从而成为另一个程序的__接口__的一部分。

-- As an example, take the following two implementations of addition on {anchorName plusL}`Nat`.
-- {anchorName plusL}`Nat.plusL` is recursive on its first argument:

例如，以下是 {anchorName plusL}`Nat` 上的两种加法实现。
{anchorName plusL}`Nat.plusL` 在其第一个参数上是递归的：

```anchor plusL
def Nat.plusL : Nat → Nat → Nat
  | 0, k => k
  | n + 1, k => plusL n k + 1
```

-- {anchorName plusR}`Nat.plusR`, on the other hand, is recursive on its second argument:

另一方面，{anchorName plusR}`Nat.plusR` 在其第二个参数上是递归的：

```anchor plusR
def Nat.plusR : Nat → Nat → Nat
  | n, 0 => n
  | n, k + 1 => plusR n k + 1
```

-- Both implementations of addition are faithful to the underlying mathematical concept, and they thus return the same result when given the same arguments.

这两种加法实现都忠实于底层的数学概念，因此在给定相同参数时它们返回相同的结果。

-- However, these two implementations present quite different interfaces when they are used in types.
-- As an example, take a function that appends two {anchorName appendL}`Vect`s.
-- This function should return a {anchorName appendL}`Vect` whose length is the sum of the length of the arguments.
-- Because {anchorName appendL}`Vect` is essentially a {anchorName moreNames}`List` with a more informative type, it makes sense to write the function just as one would for {anchorName moreNames}`List.append`, with pattern matching and recursion on the first argument.
-- Starting with a type signature and initial pattern match pointing at placeholders yields two messages:

然而，当这两种实现用于类型时，它们呈现出截然不同的接口。
例如，一个连接两个 {anchorName appendL}`Vect` 的函数。
该函数应返回一个长度为参数长度之和的 {anchorName appendL}`Vect`。
因为 {anchorName appendL}`Vect` 本质上是一个具有更具信息性类型的 {anchorName moreNames}`List`，所以像编写 {anchorName moreNames}`List.append` 一样编写该函数是有意义的，即对第一个参数进行模式匹配和递归。
从类型签名和指向占位符的初始模式匹配开始会产生两条消息：

```anchor appendL1
def appendL : Vect α n → Vect α k → Vect α (n.plusL k)
  | .nil, ys => _
  | .cons x xs, ys => _
```

-- The first message, in the {anchorName moreNames}`nil` case, states that the placeholder should be replaced by a {anchorName appendL}`Vect` with length {lit}`plusL 0 k`:

第一个消息，在 {anchorName moreNames}`nil` 情况下，指出占位符应该被一个长度为 {lit}`plusL 0 k` 的 {anchorName appendL}`Vect` 替换：

```anchorError appendL1
don't know how to synthesize placeholder
context:
α : Type u_1
n k : Nat
ys : Vect α k
⊢ Vect α (Nat.plusL 0 k)
```

-- The second message, in the {anchorName moreNames}`cons` case, states that the placeholder should be replaced by a {anchorName appendL}`Vect` with length {lit}`plusL (n✝ + 1) k`:

第二个消息，在 {anchorName moreNames}`cons` 情况下，指出占位符应该被一个长度为 {lit}`plusL (n✝ + 1) k` 的 {anchorName appendL}`Vect` 替换：

```anchorError appendL2
don't know how to synthesize placeholder
context:
α : Type u_1
n k n✝ : Nat
x : α
xs : Vect α n✝
ys : Vect α k
⊢ Vect α ((n✝ + 1).plusL k)
```

-- The symbol after {lit}`n`, called a _dagger_, is used to indicate names that Lean has internally invented.
-- Behind the scenes, pattern matching on the first {anchorName appendL1}`Vect` implicitly caused the value of the first {anchorName plusL}`Nat` to be refined as well, because the index on the constructor {anchorName moreNames}`cons` is {anchorTerm Vect (module:=Examples.DependentTypes)}`n + 1`, with the tail of the {anchorName appendL}`Vect` having length {anchorTerm Vect (module:=Examples.DependentTypes)}`n`.
-- Here, {lit}`n✝` represents the {anchorName moreNames}`Nat` that is one less than the argument {anchorName appendL1}`n`.

{lit}`n` 后面的符号，称为__匕首__，用于指示 Lean 内部发明的名称。
在幕后，对第一个 {anchorName appendL1}`Vect` 的模式匹配隐式地导致第一个 {anchorName plusL}`Nat` 的值也被细化，因为构造函数 {anchorName moreNames}`cons` 上的索引是 {anchorTerm Vect (module:=Examples.DependentTypes)}`n + 1`，而 {anchorName appendL}`Vect` 的尾部长度为 {anchorTerm Vect (module:=Examples.DependentTypes)}`n`。
在这里，{lit}`n✝` 表示比参数 {anchorName appendL1}`n` 小一的 {anchorName moreNames}`Nat`。

-- # Definitional Equality

# 定义等价

-- In the definition of {anchorName appendL3}`plusL`, there is a pattern case {anchorTerm plusL}`0, k => k`.
-- This applies in the length used in the first placeholder, so another way to write the underscore's type {anchorTerm moreNames}`Vect α (Nat.plusL 0 k)` is {anchorTerm moreNames}`Vect α k`.
-- Similarly, {anchorName plusL}`plusL` contains a pattern case {anchorTerm plusL}`n + 1, k => plusL n k + 1`.
-- This means that the type of the second underscore can be equivalently written {lit}`Vect α (plusL n✝ k + 1)`.

在 {anchorName appendL3}`plusL` 的定义中，有一个模式情况 {anchorTerm plusL}`0, k => k`。
这适用于第一个占位符中使用的长度，因此编写下划线类型 {anchorTerm moreNames}`Vect α (Nat.plusL 0 k)` 的另一种方法是 {anchorTerm moreNames}`Vect α k`。
同样，{anchorName plusL}`plusL` 包含一个模式情况 {anchorTerm plusL}`n + 1, k => plusL n k + 1`。
这意味着第二个下划线的类型可以等效地写为 {lit}`Vect α (plusL n✝ k + 1)`。

-- To expose what is going on behind the scenes, the first step is to write the {anchorName plusL}`Nat` arguments explicitly, which also results in daggerless error messages because the names are now written explicitly in the program:

为了揭示幕后发生的事情，第一步是显式编写 {anchorName plusL}`Nat` 参数，这也会导致没有匕首的错误消息，因为名称现在已在程序中显式写入：

```anchor appendL3
def appendL : (n k : Nat) → Vect α n → Vect α k → Vect α (n.plusL k)
  | 0, k, .nil, ys => _
  | n + 1, k, .cons x xs, ys => _
```

```anchorError appendL3
don't know how to synthesize placeholder
context:
α : Type u_1
k : Nat
ys : Vect α k
⊢ Vect α (Nat.plusL 0 k)
```

```anchorError appendL4
don't know how to synthesize placeholder
context:
α : Type u_1
n k : Nat
x : α
xs : Vect α n
ys : Vect α k
⊢ Vect α ((n + 1).plusL k)
```

-- Annotating the underscores with the simplified versions of the types does not introduce a type error, which means that the types as written in the program are equivalent to the ones that Lean found on its own:

用简化版本的类型注释下划线不会引入类型错误，这意味着程序中编写的类型与 Lean 自己找到的类型是等效的：

```anchor appendL5
def appendL : (n k : Nat) → Vect α n → Vect α k → Vect α (n.plusL k)
  | 0, k, .nil, ys => (_ : Vect α k)
  | n + 1, k, .cons x xs, ys => (_ : Vect α (n.plusL k + 1))
```

```anchorError appendL5
don't know how to synthesize placeholder
context:
α : Type u_1
k : Nat
ys : Vect α k
⊢ Vect α k
```

```anchorError appendL6
don't know how to synthesize placeholder
context:
α : Type u_1
n k : Nat
x : α
xs : Vect α n
ys : Vect α k
⊢ Vect α (n.plusL k + 1)
```

-- The first case demands a {anchorTerm appendL5}`Vect α k`, and {anchorName appendL5}`ys` has that type.
-- This is parallel to the way that appending the empty list to any other list returns that other list.
-- Refining the definition with {anchorName appendL7}`ys` instead of the first underscore yields a program with only one remaining underscore to be filled out:

第一个情况需要一个 {anchorTerm appendL5}`Vect α k`，而 {anchorName appendL5}`ys` 具有该类型。
这与将空列表附加到任何其他列表会返回该其他列表的方式并行。
用 {anchorName appendL7}`ys` 细化定义而不是第一个下划线会产生一个只剩下一个下划线需要填充的程序：

```anchor appendL7
def appendL : (n k : Nat) → Vect α n → Vect α k → Vect α (n.plusL k)
  | 0, k, .nil, ys => ys
  | n + 1, k, .cons x xs, ys => (_ : Vect α (n.plusL k + 1))
```

```anchorError appendL7
don't know how to synthesize placeholder
context:
α : Type u_1
n k : Nat
x : α
xs : Vect α n
ys : Vect α k
⊢ Vect α (n.plusL k + 1)
```

-- Something very important has happened here.
-- In a context where Lean expected a {anchorTerm moreNames}`Vect α (Nat.plusL 0 k)`, it received a {anchorTerm moreNames}`Vect α k`.
-- However, {anchorName plusL}`Nat.plusL` is not an {kw}`abbrev`, so it may seem like it shouldn't be running during type checking.
-- Something else is happening.

这里发生了一些非常重要的事情。
在 Lean 期望 {anchorTerm moreNames}`Vect α (Nat.plusL 0 k)` 的上下文中，它收到了一个 {anchorTerm moreNames}`Vect α k`。
然而，{anchorName plusL}`Nat.plusL` 不是一个 {kw}`abbrev`，所以它似乎不应该在类型检查期间运行。
还有其他事情正在发生。

-- The key to understanding what's going on is that Lean doesn't just expand {kw}`abbrev`s while type checking.
-- It can also perform computation while checking whether two types are equivalent to one another, such that any expression of one type can be used in a context that expects the other type.
-- This property is called _definitional equality_, and it is subtle.

理解正在发生的事情的关键是，Lean 在类型检查时不仅仅展开 {kw}`abbrev`。
它还可以在检查两种类型是否等效时执行计算，这样一种类型的任何表达式都可以在期望另一种类型的上下文中使用。
这个属性称为__定义等价__，它很微妙。

-- Certainly, two types that are written identically are considered to be definitionally equal—{anchorName moreNames}`Nat` and {anchorName moreNames}`Nat` or {anchorTerm moreNames}`List String` and {anchorTerm moreNames}`List String` should be considered equal.
-- Any two concrete types built from different datatypes are not equal, so {anchorTerm moreNames}`List Nat` is not equal to {anchorName moreNames}`Int`.
-- Additionally, types that differ only by renaming internal names are equal, so {anchorTerm moreNames}`(n : Nat) → Vect String n` is the same as {anchorTerm moreNames}`(k : Nat) → Vect String k`.
-- Because types can contain ordinary data, definitional equality must also describe when data are equal.
-- Uses of the same constructors are equal, so {anchorTerm moreNames}`0` equals {anchorTerm moreNames}`0` and {anchorTerm moreNames}`[5, 3, 1]` equals {anchorTerm moreNames}`[5, 3, 1]`.

当然，两个书写相同的类型被认为是定义等价的——{anchorName moreNames}`Nat` 和 {anchorName moreNames}`Nat` 或 {anchorTerm moreNames}`List String` 和 {anchorTerm moreNames}`List String` 应该被认为是等价的。
从不同数据类型构建的任何两个具体类型都不相等，因此 {anchorTerm moreNames}`List Nat` 不等于 {anchorName moreNames}`Int`。
此外，仅通过重命名内部名称而不同的类型是等价的，因此 {anchorTerm moreNames}`(n : Nat) → Vect String n` 与 {anchorTerm moreNames}`(k : Nat) → Vect String k` 相同。
因为类型可以包含普通数据，所以定义等价也必须描述数据何时相等。
使用相同构造函数是等价的，因此 {anchorTerm moreNames}`0` 等于 {anchorTerm moreNames}`0`，{anchorTerm moreNames}`[5, 3, 1]` 等于 {anchorTerm moreNames}`[5, 3, 1]`。

-- Types contain more than just function arrows, datatypes, and constructors, however.
-- They also contain _variables_ and _functions_.
-- Definitional equality of variables is relatively simple: each variable is equal only to itself, so {anchorTerm moreNames}`(n k : Nat) → Vect Int n` is not definitionally equal to {anchorTerm moreNames}`(n k : Nat) → Vect Int k`.
-- Functions, on the other hand, are more complicated.
-- While mathematics considers two functions to be equal if they have identical input-output behavior, there is no efficient algorithm to check that, and the whole point of definitional equality is for Lean to check whether two types are interchangeable.
-- Instead, Lean considers functions to be definitionally equal either when they are both {kw}`fun`-expressions with definitionally equal bodies.
-- In other words, two functions must use _the same algorithm_ that calls _the same helpers_ to be considered definitionally equal.
-- This is not typically very helpful, so definitional equality of functions is mostly used when the exact same defined function occurs in two types.

然而，类型不仅仅包含函数箭头、数据类型和构造函数。
它们还包含__变量__和__函数__。
变量的定义等价相对简单：每个变量只等于自身，因此 {anchorTerm moreNames}`(n k : Nat) → Vect Int n` 与 {anchorTerm moreNames}`(n k : Nat) → Vect Int k` 不定义等价。
另一方面，函数更复杂。
虽然数学认为如果两个函数具有相同的输入-输出行为，则它们相等，但没有有效的算法来检查这一点，而定义等价的全部意义在于 Lean 检查两种类型是否可互换。
相反，Lean 认为函数在它们都是具有定义等价主体的 {kw}`fun`-表达式时定义等价。
换句话说，两个函数必须使用__相同的算法__调用__相同的辅助函数__才能被认为是定义等价的。
这通常不是很有用，因此函数的定义等价主要用于当完全相同的已定义函数出现在两种类型中时。

-- When functions are _called_ in a type, checking definitional equality may involve reducing the function call.
-- The type {anchorTerm moreNames}`Vect String (1 + 4)` is definitionally equal to the type {anchorTerm moreNames}`Vect String (3 + 2)` because {anchorTerm moreNames}`1 + 4` is definitionally equal to {anchorTerm moreNames}`3 + 2`.
-- To check their equality, both are reduced to {anchorTerm moreNames}`5`, and then the constructor rule can be used five times.
-- Definitional equality of functions applied to data can be checked first by seeing if they're already the same—there's no need to reduce {anchorTerm moreNames}`["a", "b"] ++ ["c"]` to check that it's equal to {anchorTerm moreNames}`["a", "b"] ++ ["c"]`, after all.
-- If not, the function is called and replaced with its value, and the value can then be checked.

当函数在类型中被__调用__时，检查定义等价可能涉及减少函数调用。
类型 {anchorTerm moreNames}`Vect String (1 + 4)` 与类型 {anchorTerm moreNames}`Vect String (3 + 2)` 定义等价，因为 {anchorTerm moreNames}`1 + 4` 与 {anchorTerm moreNames}`3 + 2` 定义等价。
为了检查它们的等价性，两者都被简化为 {anchorTerm moreNames}`5`，然后可以使用构造函数规则五次。
应用于数据的函数的定义等价可以首先通过查看它们是否已经相同来检查——毕竟，没有必要将 {anchorTerm moreNames}`["a", "b"] ++ ["c"]` 简化以检查它是否等于 {anchorTerm moreNames}`["a", "b"] ++ ["c"]`。
如果不是，则调用函数并将其替换为其值，然后可以检查该值。

-- Not all function arguments are concrete data.
-- For example, types may contain {anchorName moreNames}`Nat`s that are not built from the {anchorName moreNames}`zero` and {anchorName moreNames}`succ` constructors.
-- In the type {anchorTerm moreFun}`(n : Nat) → Vect String n`, the variable {anchorName moreFun}`n` is a {anchorName moreFun}`Nat`, but it is impossible to know _which_ {anchorName moreFun}`Nat` it is before the function is called.
-- Indeed, the function may be called first with {anchorTerm moreNames}`0`, and then later with {anchorTerm moreNames}`17`, and then again with {anchorTerm moreNames}`33`.
-- As seen in the definition of {anchorName appendL}`appendL`, variables with type {anchorName moreFun}`Nat` may also be passed to functions such as {anchorName appendL}`plusL`.
-- Indeed, the type {anchorTerm moreFun}`(n : Nat) → Vect String n` is definitionally equal to the type {anchorTerm moreNames}`(n : Nat) → Vect String (Nat.plusL 0 n)`.

并非所有函数参数都是具体数据。
例如，类型可能包含不是由 {anchorName moreNames}`zero` 和 {anchorName moreNames}`succ` 构造函数构建的 {anchorName moreNames}`Nat`。
在类型 {anchorTerm moreFun}`(n : Nat) → Vect String n` 中，变量 {anchorName moreFun}`n` 是一个 {anchorName moreFun}`Nat`，但在调用函数之前无法知道它是__哪个__ {anchorName moreFun}`Nat`。
实际上，函数可能首先用 {anchorTerm moreNames}`0` 调用，然后用 {anchorTerm moreNames}`17` 调用，然后再次用 {anchorTerm moreNames}`33` 调用。
正如 {anchorName appendL}`appendL` 的定义中所示，类型为 {anchorName moreFun}`Nat` 的变量也可以传递给诸如 {anchorName appendL}`plusL` 之类的函数。
实际上，类型 {anchorTerm moreFun}`(n : Nat) → Vect String n` 与类型 {anchorTerm moreNames}`(n : Nat) → Vect String (Nat.plusL 0 n)` 定义等价。

-- The reason that {anchorName againFun}`n` and {anchorTerm againFun}`Nat.plusL 0 n` are definitionally equal is that {anchorName plusL}`plusL`'s pattern match examines its _first_ argument.
-- This is problematic: {anchorTerm moreFun}`(n : Nat) → Vect String n` is _not_ definitionally equal to {anchorTerm stuckFun}`(n : Nat) → Vect String (Nat.plusL n 0)`, even though zero should be both a left and a right identity of addition.
-- This happens because pattern matching gets stuck when it encounters variables.
-- Until the actual value of {anchorName stuckFun}`n` becomes known, there is no way to know which case of {anchorTerm stuckFun}`Nat.plusL n 0` should be selected.

{anchorName againFun}`n` 和 {anchorTerm againFun}`Nat.plusL 0 n` 定义等价的原因是 {anchorName plusL}`plusL` 的模式匹配检查其__第一个__参数。
这有问题：{anchorTerm moreFun}`(n : Nat) → Vect String n` 与 {anchorTerm stuckFun}`(n : Nat) → Vect String (Nat.plusL n 0)` __不__定义等价，即使零应该是加法的左单位元和右单位元。
发生这种情况是因为模式匹配在遇到变量时会卡住。
在 {anchorName stuckFun}`n` 的实际值已知之前，无法知道应该选择 {anchorTerm stuckFun}`Nat.plusL n 0` 的哪种情况。

-- The same issue appears with the {anchorName Row (module:=Examples.DependentTypes.DB)}`Row` function in the query example.
-- The type {anchorTerm RowStuck (module:=Examples.DependentTypes.DB)}`Row (c :: cs)` does not reduce to any datatype because the definition of {anchorName RowStuck (module:=Examples.DependentTypes.DB)}`Row` has separate cases for singleton lists and lists with at least two entries.
-- In other words, it gets stuck when trying to match the variable {anchorName RowStuck (module:=Examples.DependentTypes.DB)}`cs` against concrete {anchorName moreNames}`List` constructors.
-- This is why almost every function that takes apart or constructs a {anchorName RowStuck (module:=Examples.DependentTypes.DB)}`Row` needs to match the same three cases as {anchorName RowStuck (module:=Examples.DependentTypes.DB)}`Row` itself: getting it unstuck reveals concrete types that can be used for either pattern matching or constructors.

查询示例中的 {anchorName Row (module:=Examples.DependentTypes.DB)}`Row` 函数也出现了同样的问题。
类型 {anchorTerm RowStuck (module:=Examples.DependentTypes.DB)}`Row (c :: cs)` 不会简化为任何数据类型，因为 {anchorName RowStuck (module:=Examples.DependentTypes.DB)}`Row` 的定义对单例列表和至少包含两个条目的列表有单独的情况。
换句话说，当尝试将变量 {anchorName RowStuck (module:=Examples.DependentTypes.DB)}`cs` 与具体的 {anchorName moreNames}`List` 构造函数匹配时，它会卡住。
这就是为什么几乎每个分解或构造 {anchorName RowStuck (module:=Examples.DependentTypes.DB)}`Row` 的函数都需要匹配与 {anchorName RowStuck (module:=Examples.DependentTypes.DB)}`Row` 本身相同的三个情况：解除阻塞会揭示可用于模式匹配或构造函数的具体类型。

-- The missing case in {anchorName appendL8}`appendL` requires a {lit}`Vect α (Nat.plusL n k + 1)`.
-- The {lit}`+ 1` in the index suggests that the next step is to use {anchorName consNotLengthN (module:=Examples.DependentTypes)}`Vect.cons`:

{anchorName appendL8}`appendL` 中缺失的情况需要一个 {lit}`Vect α (Nat.plusL n k + 1)`。
索引中的 {lit}`+ 1` 表明下一步是使用 {anchorName consNotLengthN (module:=Examples.DependentTypes)}`Vect.cons`：

```anchor appendL8
def appendL : (n k : Nat) → Vect α n → Vect α k → Vect α (n.plusL k)
  | 0, k, .nil, ys => ys
  | n + 1, k, .cons x xs, ys => .cons x (_ : Vect α (n.plusL k))
```

```anchorError appendL8
don't know how to synthesize placeholder
context:
α : Type u_1
n k : Nat
x : α
xs : Vect α n
ys : Vect α k
⊢ Vect α (n.plusL k)
```

-- A recursive call to {anchorName appendL9}`appendL` can construct a {anchorName appendL9}`Vect` with the desired length:

对 {anchorName appendL9}`appendL` 的递归调用可以构造一个具有所需长度的 {anchorName appendL9}`Vect`：

```anchor appendL9
def appendL : (n k : Nat) → Vect α n → Vect α k → Vect α (n.plusL k)
  | 0, k, .nil, ys => ys
  | n + 1, k, .cons x xs, ys => .cons x (appendL n k xs ys)
```

-- Now that the program is finished, removing the explicit matching on {anchorName appendL9}`n` and {anchorName appendL9}`k` makes it easier to read and easier to call the function:

现在程序已完成，删除对 {anchorName appendL9}`n` 和 {anchorName appendL9}`k` 的显式匹配使其更易于阅读和调用函数：

```anchor appendL
def appendL : Vect α n → Vect α k → Vect α (n.plusL k)
  | .nil, ys => ys
  | .cons x xs, ys => .cons x (appendL xs ys)
```

-- Comparing types using definitional equality means that everything involved in definitional equality, including the internals of function definitions, becomes part of the _interface_ of programs that use dependent types and indexed families.
-- Exposing the internals of a function in a type means that refactoring the exposed program may cause programs that use it to no longer type check.
-- In particular, the fact that {anchorName appendL}`plusL` is used in the type of {anchorName appendL}`appendL` means that the definition of {anchorName appendL}`plusL` cannot be replaced by the otherwise-equivalent {anchorName plusR}`plusR`.

使用定义等价比较类型意味着定义等价中涉及的一切，包括函数定义的内部，都成为使用依赖类型和索引族的程序的__接口__的一部分。
在类型中暴露函数的内部意味着重构暴露的程序可能会导致使用它的程序不再进行类型检查。
特别是，{anchorName appendL}`plusL` 在 {anchorName appendL}`appendL` 的类型中使用的事实意味着 {anchorName appendL}`plusL` 的定义不能被其他等效的 {anchorName plusR}`plusR` 替换。

-- # Getting Stuck on Addition

# 加法卡住

-- What happens if append is defined with {anchorName appendR}`plusR` instead?
-- Beginning in the same way, with explicit lengths and placeholder underscores in each case, reveals the following useful error messages:

如果用 {anchorName appendR}`plusR` 定义附加会发生什么？
以相同的方式开始，在每种情况下都使用显式长度和占位符下划线，会显示以下有用的错误消息：

```anchor appendR1
def appendR : (n k : Nat) → Vect α n → Vect α k → Vect α (n.plusR k)
  | 0, k, .nil, ys => _
  | n + 1, k, .cons x xs, ys => _
```

```anchorError appendR1
don't know how to synthesize placeholder
context:
α : Type u_1
k : Nat
ys : Vect α k
⊢ Vect α (Nat.plusR 0 k)
```

```anchorError appendR2
don't know how to synthesize placeholder
context:
α : Type u_1
n k : Nat
x : α
xs : Vect α n
ys : Vect α k
⊢ Vect α ((n + 1).plusR k)
```

-- However, attempting to place a {anchorTerm appendR3}`Vect α k` type annotation around the first placeholder results in an type mismatch error:

然而，尝试在第一个占位符周围放置 {anchorTerm appendR3}`Vect α k` 类型注释会导致类型不匹配错误：

```anchor appendR3
def appendR : (n k : Nat) → Vect α n → Vect α k → Vect α (n.plusR k)
  | 0, k, .nil, ys => (_ : Vect α k)
  | n + 1, k, .cons x xs, ys => _
```

```anchorError appendR3
type mismatch
  ?m.7829
has type
  Vect α k : Type ?u.7765
but is expected to have type
  Vect α (Nat.plusR 0 k) : Type ?u.7765
```

-- This error is pointing out that {anchorTerm plusRinfo}`Nat.plusR 0 k` and {anchorName plusRinfo}`k` are _not_ definitionally equal.

此错误指出 {anchorTerm plusRinfo}`Nat.plusR 0 k` 和 {anchorName plusRinfo}`k` __不__定义等价。

:::paragraph
-- This is because {anchorName plusR}`plusR` has the following definition:
这是因为 {anchorName plusR}`plusR` 具有以下定义：

```anchor plusR
def Nat.plusR : Nat → Nat → Nat
  | n, 0 => n
  | n, k + 1 => plusR n k + 1
```

-- Its pattern matching occurs on the _second_ argument, not the first argument, which means that the presence of the variable {anchorName plusRinfo}`k` in that position prevents it from reducing.
-- {anchorName plusRinfo}`Nat.add` in Lean's standard library is equivalent to {anchorName plusRinfo}`plusR`, not {anchorName plusRinfo}`plusL`, so attempting to use it in this definition results in precisely the same difficulties:

它的模式匹配发生在__第二个__参数上，而不是第一个参数上，这意味着该位置中变量 {anchorName plusRinfo}`k` 的存在阻止了它的简化。
Lean 标准库中的 {anchorName plusRinfo}`Nat.add` 等效于 {anchorName plusRinfo}`plusR`，而不是 {anchorName plusRinfo}`plusL`，因此尝试在此定义中使用它会导致完全相同的困难：

```anchor appendR4
def appendR : (n k : Nat) → Vect α n → Vect α k → Vect α (n + k)
  | 0, k, .nil, ys => (_ : Vect α k)
  | n + 1, k, .cons x xs, ys => _
```

```anchorError appendR4
type mismatch
  ?m.8578
has type
  Vect α k : Type ?u.8479
but is expected to have type
  Vect α (0 + k) : Type ?u.8479
```

-- Addition is getting _stuck_ on the variables.
-- Getting it unstuck requires {ref "equality-and-ordering"}[propositional equality].

加法在变量上__卡住__了。
解除卡住需要 {ref "equality-and-ordering"}[命题等价]。
:::

-- # Propositional Equality

# 命题等价

-- Propositional equality is the mathematical statement that two expressions are equal.
-- While definitional equality is a kind of ambient fact that Lean automatically checks when required, statements of propositional equality require explicit proofs.
-- Once an equality proposition has been proved, it can be used in a program to modify a type, replacing one side of the equality with the other, which can unstick the type checker.

命题等价是两个表达式相等的数学陈述。
虽然定义等价是 Lean 在需要时自动检查的一种环境事实，但命题等价的陈述需要显式证明。
一旦等价命题被证明，它就可以在程序中用于修改类型，用等价的一侧替换另一侧，这可以解除类型检查器的阻塞。

-- The reason why definitional equality is so limited is to enable it to be checked by an algorithm.
-- Propositional equality is much richer, but the computer cannot in general check whether two expressions are propositionally equal, though it can verify that a purported proof is in fact a proof.
-- The split between definitional and propositional equality represents a division of labor between humans and machines: the most boring equalities are checked automatically as part of definitional equality, freeing the human mind to work on the interesting problems available in propositional equality.
-- Similarly, definitional equality is invoked automatically by the type checker, while propositional equality must be specifically appealed to.

定义等价如此受限的原因是为了使其能够通过算法进行检查。
命题等价要丰富得多，但计算机通常无法检查两个表达式是否命题等价，尽管它可以验证所谓的证明实际上是证明。
定义等价和命题等价之间的划分代表了人与机器之间的分工：最无聊的等价作为定义等价的一部分自动检查，从而使人类思维能够处理命题等价中存在的有趣问题。
同样，定义等价由类型检查器自动调用，而命题等价必须专门引用。

-- In {ref "props-proofs-indexing"}[Propositions, Proofs, and Indexing], some equality statements are proved using {kw}`decide`.
-- All of these equality statements are ones in which the propositional equality is in fact already a definitional equality.
-- Typically, statements of propositional equality are proved by first getting them into a form where they are either definitional or close enough to existing proved equalities, and then using tools like {kw}`decide` or {kw}`simp` to take care of the simplified cases.
-- The {kw}`simp` tactic is quite powerful: behind the scenes, it uses a number of fast, automated tools to construct a proof.
-- A simpler tactic called {kw}`rfl` specifically uses definitional equality to prove propositional equality.
-- The name {kw}`rfl` is short for _reflexivity_, which is the property of equality that states that everything equals itself.

在 {ref "props-proofs-indexing"}[命题、证明和索引] 中，一些等价语句使用 {kw}`decide` 证明。
所有这些等价语句都是命题等价实际上已经是定义等价的语句。
通常，命题等价的语句通过首先将它们转换为定义形式或足够接近现有已证明等价的形式来证明，然后使用 {kw}`decide` 或 {kw}`simp` 等工具来处理简化的情况。
{kw}`simp` 策略非常强大：在幕后，它使用许多快速、自动化工具来构造证明。
一个更简单的策略 {kw}`rfl` 专门使用定义等价来证明命题等价。
名称 {kw}`rfl` 是__自反性__的缩写，自反性是等价的性质，它表明一切都等于自身。

-- Unsticking {anchorName appendR}`appendR` requires a proof that {anchorTerm plusR_zero_left1}`k = Nat.plusR 0 k`, which is not a definitional equality because {anchorName plusR}`plusR` is stuck on the variable in its second argument.
-- To get it to compute, the {anchorName plusR_zero_left1}`k` must become a concrete constructor.
-- This is a job for pattern matching.

解除 {anchorName appendR}`appendR` 的阻塞需要证明 {anchorTerm plusR_zero_left1}`k = Nat.plusR 0 k`，这不是定义等价，因为 {anchorName plusR}`plusR` 卡在其第二个参数中的变量上。
为了使其计算，{anchorName plusR_zero_left1}`k` 必须成为一个具体的构造函数。
这是模式匹配的工作。

-- :::paragraph
-- In particular, because {anchorName plusR_zero_left1}`k` could be _any_ {anchorName plusR_zero_left1}`Nat`, this task requires a function that can return evidence that {anchorTerm plusR_zero_left1}`k = Nat.plusR 0 k` for _any_ {anchorName plusR_zero_left1}`k` whatsoever.
-- This should be a function that returns a proof of equality, with type {anchorTerm plusR_zero_left1}`(k : Nat) → k = Nat.plusR 0 k`.
-- Getting it started with initial patterns and placeholders yields the following messages:

特别是，因为 {anchorName plusR_zero_left1}`k` 可以是__任何__ {anchorName plusR_zero_left1}`Nat`，所以此任务需要一个函数，该函数可以返回 {anchorTerm plusR_zero_left1}`k = Nat.plusR 0 k` 对__任何__ {anchorName plusR_zero_left1}`k` 都成立的证据。
这应该是一个返回等价证明的函数，类型为 {anchorTerm plusR_zero_left1}`(k : Nat) → k = Nat.plusR 0 k`。
用初始模式和占位符启动它会产生以下消息：

```anchor plusR_zero_left1
def plusR_zero_left : (k : Nat) → k = Nat.plusR 0 k
  | 0 => _
  | k + 1 => _
```

```anchorError plusR_zero_left1
don't know how to synthesize placeholder
context:
⊢ 0 = Nat.plusR 0 0
```

```anchorError plusR_zero_left2
don't know how to synthesize placeholder
context:
k : Nat
⊢ k + 1 = Nat.plusR 0 (k + 1)
```

-- Having refined {anchorName plusR_zero_left1}`k` to {anchorTerm plusR_zero_left1}`0` via pattern matching, the first placeholder stands for evidence of a statement that does hold definitionally.
-- The {kw}`rfl` tactic takes care of it, leaving only the second placeholder:

通过模式匹配将 {anchorName plusR_zero_left1}`k` 细化为 {anchorTerm plusR_zero_left1}`0` 后，第一个占位符代表一个定义上成立的语句的证据。
{kw}`rfl` 策略处理了它，只留下第二个占位符：

```anchor plusR_zero_left3
def plusR_zero_left : (k : Nat) → k = Nat.plusR 0 k
  | 0 => by rfl
  | k + 1 => _
```
:::

-- The second placeholder is a bit trickier.
-- The expression {anchorTerm plusRStep}`Nat.plusR 0 k + 1` is definitionally equal to {anchorTerm plusRStep}`Nat.plusR 0 (k + 1)`.
-- This means that the goal could also be written {anchorTerm plusR_zero_left4}`k + 1 = Nat.plusR 0 k + 1`:

第二个占位符有点棘手。
表达式 {anchorTerm plusRStep}`Nat.plusR 0 k + 1` 与 {anchorTerm plusRStep}`Nat.plusR 0 (k + 1)` 定义等价。
这意味着目标也可以写成 {anchorTerm plusR_zero_left4}`k + 1 = Nat.plusR 0 k + 1`：

```anchor plusR_zero_left4
def plusR_zero_left : (k : Nat) → k = Nat.plusR 0 k
  | 0 => by rfl
  | k + 1 => (_ : k + 1 = Nat.plusR 0 k + 1)
```

```anchorError plusR_zero_left4
don't know how to synthesize placeholder
context:
k : Nat
⊢ k + 1 = Nat.plusR 0 k + 1
```

-- Underneath the {anchorTerm plusR_zero_left4}`+ 1` on each side of the equality statement is another instance of what the function itself returns.
-- In other words, a recursive call on {anchorName plusR_zero_left4}`k` would return evidence that {anchorTerm plusR_zero_left4}`k = Nat.plusR 0 k`.
-- Equality wouldn't be equality if it didn't apply to function arguments.
-- In other words, if {anchorTerm congr}`x = y`, then {anchorTerm congr}`f x = f y`.
-- The standard library contains a function {anchorName congr}`congrArg` that takes a function and an equality proof and returns a new proof where the function has been applied to both sides of the equality.
-- In this case, the function is {anchorTerm plusR_zero_left_done}`(· + 1)`:
:::paragraph
在等式语句两边的 {anchorTerm plusR_zero_left4}`+ 1` 下面是函数本身返回的另一个实例。
换句话说，对 {anchorName plusR_zero_left4}`k` 的递归调用将返回 {anchorTerm plusR_zero_left4}`k = Nat.plusR 0 k` 的证据。
如果等式不适用于函数参数，那么它就不是等式。
换句话说，如果 {anchorTerm congr}`x = y`，那么 {anchorTerm congr}`f x = f y`。
标准库包含一个函数 {anchorName congr}`congrArg`，它接受一个函数和一个等式证明，并返回一个新的证明，其中函数已应用于等式的两边。
在这种情况下，函数是 {anchorTerm plusR_zero_left_done}`(· + 1)`：

```anchor plusR_zero_left_done
def plusR_zero_left : (k : Nat) → k = Nat.plusR 0 k
  | 0 => by rfl
  | k + 1 =>
    congrArg (· + 1) (plusR_zero_left k)
```
:::

:::paragraph
-- Because this is really a proof of a proposition, it should be declared as a {kw}`theorem`:
因为这实际上是一个命题的证明，所以它应该被声明为 {kw}`theorem`：

```anchor plusR_zero_left_thm
theorem plusR_zero_left : (k : Nat) → k = Nat.plusR 0 k
  | 0 => by rfl
  | k + 1 =>
    congrArg (· + 1) (plusR_zero_left k)
```
:::

-- Propositional equalities can be deployed in a program using the rightward triangle operator {anchorTerm appendRsubst}`▸`.
-- Given an equality proof as its first argument and some other expression as its second, this operator replaces instances of one side of the equality with the other side of the equality in the second argument's type.
-- In other words, the following definition contains no type errors:

命题等价可以使用右向三角形运算符 {anchorTerm appendRsubst}`▸` 在程序中部署。
给定一个等价证明作为其第一个参数，以及一些其他表达式作为其第二个参数，该运算符在第二个参数的类型中用等价的另一侧替换等价的一侧的实例。
换句话说，以下定义不包含类型错误：

```anchor appendRsubst
def appendR : (n k : Nat) → Vect α n → Vect α k → Vect α (n.plusR k)
  | 0, k, .nil, ys => plusR_zero_left k ▸ (_ : Vect α k)
  | n + 1, k, .cons x xs, ys => _
```

-- The first placeholder has the expected type:

第一个占位符具有预期类型：

```anchorError appendRsubst
don't know how to synthesize placeholder
context:
α : Type u_1
k : Nat
ys : Vect α k
⊢ Vect α k
```

-- It can now be filled in with {anchorName appendR5}`ys`:

现在可以用 {anchorName appendR5}`ys` 填充它：

```anchor appendR5
def appendR : (n k : Nat) → Vect α n → Vect α k → Vect α (n.plusR k)
  | 0, k, .nil, ys => plusR_zero_left k ▸ ys
  | n + 1, k, .cons x xs, ys => _
```

-- Filling in the remaining placeholder requires unsticking another instance of addition:

填充剩余的占位符需要解除另一个加法实例的阻塞：

```anchorError appendR5
don't know how to synthesize placeholder
context:
α : Type u_1
n k : Nat
x : α
xs : Vect α n
ys : Vect α k
⊢ Vect α ((n + 1).plusR k)
```

-- Here, the statement to be proved is that {anchorTerm plusR_succ_left}`Nat.plusR (n + 1) k = Nat.plusR n k + 1`, which can be used with {anchorTerm appendRsubst}`▸` to draw the {anchorTerm appendRsubst}`+ 1` out to the top of the expression so that it matches the index of {anchorName Vect}`cons`.

在这里，要证明的语句是 {anchorTerm plusR_succ_left}`Nat.plusR (n + 1) k = Nat.plusR n k + 1`，它可以使用 {anchorTerm appendRsubst}`▸` 将 {anchorTerm appendRsubst}`+ 1` 提取到表达式的顶部，使其与 {anchorName Vect}`cons` 的索引匹配。

-- The proof is a recursive function that pattern matches on the second argument to {anchorName appendR}`plusR`, namely {anchorName appendR5}`k`.
-- This is because {anchorName appendR5}`plusR` itself pattern matches on its second argument, so the proof can “unstick” it through pattern matching, exposing the computational behavior.
-- The skeleton of the proof is very similar to that of {anchorName appendR}`plusR_zero_left`:

该证明是一个递归函数，它对 {anchorName appendR}`plusR` 的第二个参数（即 {anchorName appendR5}`k`）进行模式匹配。
这是因为 {anchorName appendR5}`plusR` 本身对其第二个参数进行模式匹配，因此该证明可以通过模式匹配“解除阻塞”，从而暴露计算行为。
证明的骨架与 {anchorName appendR}`plusR_zero_left` 的骨架非常相似：

```anchor plusR_succ_left_0
theorem plusR_succ_left (n : Nat) :
    (k : Nat) → Nat.plusR (n + 1) k = Nat.plusR n k + 1
  | 0 => by rfl
  | k + 1 => _
```

-- The remaining case's type is definitionally equal to {anchorTerm congr}`Nat.plusR (n + 1) k + 1 = Nat.plusR n (k + 1) + 1`, so it can be solved with {anchorName congr}`congrArg`, just as in {anchorName plusR_zero_left_thm}`plusR_zero_left`:

剩余情况的类型与 {anchorTerm congr}`Nat.plusR (n + 1) k + 1 = Nat.plusR n (k + 1) + 1` 定义等价，因此可以使用 {anchorName congr}`congrArg` 解决，就像在 {anchorName plusR_zero_left_thm}`plusR_zero_left` 中一样：


```anchorError plusR_succ_left_2
don't know how to synthesize placeholder
context:
n k : Nat
⊢ (n + 1).plusR (k + 1) = n.plusR (k + 1) + 1
```

-- This results in a finished proof:

这会产生一个完整的证明：

```anchor plusR_succ_left
theorem plusR_succ_left (n : Nat) :
    (k : Nat) → Nat.plusR (n + 1) k = Nat.plusR n k + 1
  | 0 => by rfl
  | k + 1 => congrArg (· + 1) (plusR_succ_left n k)
```

-- The finished proof can be used to unstick the second case in {anchorName appendR}`appendR`:

完成的证明可用于解除 {anchorName appendR}`appendR` 中的第二种情况的阻塞：

```anchor appendR
def appendR : (n k : Nat) → Vect α n → Vect α k → Vect α (n.plusR k)
  | 0, k, .nil, ys =>
    plusR_zero_left k ▸ ys
  | n + 1, k, .cons x xs, ys =>
    plusR_succ_left n k ▸ .cons x (appendR n k xs ys)
```

-- When making the length arguments to {anchorName appendR}`appendR` implicit again, they are no longer explicitly named to be appealed to in the proofs.
-- However, Lean's type checker has enough information to fill them in automatically behind the scenes, because no other values would allow the types to match:

当再次将 {anchorName appendR}`appendR` 的长度参数隐式化时，它们不再显式命名以在证明中引用。
然而，Lean 的类型检查器有足够的信息在幕后自动填充它们，因为没有其他值会允许类型匹配：

```anchor appendRImpl
def appendR : Vect α n → Vect α k → Vect α (n.plusR k)
  | .nil, ys => plusR_zero_left _ ▸ ys
  | .cons x xs, ys => plusR_succ_left _ _ ▸ .cons x (appendR xs ys)
```

-- # Pros and Cons

# 优点和缺点

-- Indexed families have an important property: pattern matching on them affects definitional equality.
-- For example, in the {anchorName Vect}`nil` case in a {kw}`match` expression on a {anchorTerm Vect}`Vect`, the length simply _becomes_ {anchorTerm moreNames}`0`.
-- Definitional equality can be very convenient, because it is always active and does not need to be invoked explicitly.

索引族有一个重要的属性：对它们进行模式匹配会影响定义等价。
例如，在 {anchorTerm Vect}`Vect` 上的 {kw}`match` 表达式中的 {anchorName Vect}`nil` 情况中，长度简单地__变为__ {anchorTerm moreNames}`0`。
定义等价非常方便，因为它始终处于活动状态，无需显式调用。

-- However, the use of definitional equality with dependent types and pattern matching has serious software engineering drawbacks.
-- First off, functions must be written especially to be used in types, and functions that are convenient to use in types may not use the most efficient algorithms.
-- Once a function has been exposed through using it in a type, its implementation has become part of the interface, leading to difficulties in future refactoring.
-- Secondly, definitional equality can be slow.
-- When asked to check whether two expressions are definitionally equal, Lean may need to run large amounts of code if the functions in question are complicated and have many layers of abstraction.
-- Third, error messages that result from failures of definitional equality are not always very easy to understand, because they may be phrased in terms of the internals of functions.
-- It is not always easy to understand the provenance of the expressions in the error messages.
-- Finally, encoding non-trivial invariants in a collection of indexed families and dependently-typed functions can often be brittle.
-- It is often necessary to change early definitions in a system when the exposed reduction behavior of functions proves to not provide convenient definitional equalities.
-- The alternative is to litter the program with appeals to equality proofs, but these can become quite unwieldy.

然而，将定义等价与依赖类型和模式匹配结合使用具有严重的软件工程缺点。
首先，函数必须专门为在类型中使用而编写，而方便在类型中使用的函数可能不会使用最有效的算法。
一旦函数通过在类型中使用而暴露，其实现就成为接口的一部分，导致未来重构的困难。
其次，定义等价可能很慢。
当被要求检查两个表达式是否定义等价时，如果相关函数复杂且具有多层抽象，Lean 可能需要运行大量代码。
第三，定义等价失败导致的错误消息并不总是很容易理解，因为它们可能以函数内部的形式表达。
理解错误消息中表达式的来源并不总是那么容易。
最后，在索引族和依赖类型函数的集合中编码非平凡不变量通常很脆弱。
当函数的暴露简化行为证明不提供方便的定义等价时，通常需要更改系统中的早期定义。
替代方案是用等价证明的引用来污染程序，但这可能会变得相当笨拙。

-- In idiomatic Lean code, indexed datatypes are not used very often.
-- Instead, subtypes and explicit propositions are typically used to enforce important invariants.
-- This approach involves many explicit proofs, and very few appeals to definitional equality.
-- As befits an interactive theorem prover, Lean has been designed to make explicit proofs convenient.
-- Generally speaking, this approach should be preferred in most cases.

在惯用的 Lean 代码中，索引数据类型不常使用。
相反，通常使用子类型和显式命题来强制执行重要不变量。
这种方法涉及许多显式证明，很少引用定义等价。
作为交互式定理证明器，Lean 的设计旨在使显式证明方便。
一般来说，在大多数情况下应首选这种方法。

-- However, understanding indexed families of datatypes is important.
-- Recursive functions such as {anchorName plusR_zero_left_thm}`plusR_zero_left` and {anchorName plusR_succ_left}`plusR_succ_left` are in fact _proofs by mathematical induction_.
-- The base case of the recursion corresponds to the base case in induction, and the recursive call represents an appeal to the induction hypothesis.
-- More generally, new propositions in Lean are often defined as inductive types of evidence, and these inductive types usually have indices.
-- The process of proving theorems is in fact constructing expressions with these types behind the scenes, in a process not unlike the proofs in this section.
-- Also, indexed datatypes are sometimes exactly the right tool for the job.
-- Fluency in their use is an important part of knowing when to use them.

然而，理解数据类型的索引族很重要。
像 {anchorName plusR_zero_left_thm}`plusR_zero_left` 和 {anchorName plusR_succ_left}`plusR_succ_left` 这样的递归函数实际上是__数学归纳法证明__。
递归的基本情况对应于归纳法中的基本情况，递归调用代表对归纳假设的引用。
更一般地，Lean 中的新命题通常被定义为证据的归纳类型，并且这些归纳类型通常具有索引。
证明定理的过程实际上是在幕后构造具有这些类型的表达式，其过程与本节中的证明并无二致。
此外，索引数据类型有时正是完成任务的正确工具。
熟练使用它们是了解何时使用它们的重要组成部分。

-- # Exercises

# 练习

--  * Using a recursive function in the style of {anchorName plusR_succ_left}`plusR_succ_left`, prove that for all {anchorName moreNames}`Nat`s {anchorName exercises}`n` and {anchorName exercises}`k`, {anchorTerm exercises}`n.plusR k = n + k`.
--  * Write a function on {anchorName moreNames}`Vect` for which {anchorName plusR}`plusR` is more natural than {anchorName plusL}`plusL`, where {anchorName plusL}`plusL` would require proofs to be used in the definition.

 * 使用 {anchorName plusR_succ_left}`plusR_succ_left` 风格的递归函数，证明对于所有 {anchorName moreNames}`Nat` {anchorName exercises}`n` 和 {anchorName exercises}`k`，{anchorTerm exercises}`n.plusR k = n + k`。
 * 编写一个 {anchorName moreNames}`Vect` 上的函数，其中 {anchorName plusR}`plusR` 比 {anchorName plusL}`plusL` 更自然，而 {anchorName plusL}`plusL` 需要在定义中使用证明。
