import VersoManual
import FPLeanZh.Examples

open Verso.Genre Manual
open Verso Code External
open FPLeanZh

set_option verso.exampleProject "../examples"
set_option verso.exampleModule "Examples.Classes"

set_option pp.rawOnError true

-- Coercions
#doc (Manual) "强制类型转换" =>
%%%
file := "Coercions"
tag := "coercions"
%%%

-- In mathematics, it is common to use the same symbol to stand for different aspects of some object in different contexts.
-- For example, if a ring is referred to in a context where a set is expected, then it is understood that the ring's underlying set is what's intended.
-- In programming languages, it is common to have rules to automatically translate values of one type into values of another type.
-- Java allows a {java}`byte` to be automatically promoted to an {java}`int`, and Kotlin allows a non-nullable type to be used in a context that expects a nullable version of the type.

在数学中，用同一个符号来在不同的语境中代表数学对象的不同方面是很常见的。例如，如果在一个需要集合的语境中给出了一个环，那么理解为该环对应的集合也是很有道理的。在编程语言中，有一些规则自动地将一种类型转换为另一种类型也是很常见的。
Java 允许将 {java}`byte` 自动提升为 {java}`int`，Kotlin 也允许非空类型在可为空的语境中使用。

-- In Lean, both purposes are served by a mechanism called {deftech}_coercions_.
-- When Lean encounters an expression of one type in a context that expects a different type, it will attempt to coerce the expression before reporting a type error.
-- Unlike Java, C, and Kotlin, the coercions are extensible by defining instances of type classes.

在 Lean 中，这两个目的都由一种称为 {deftech}*强制类型转换* 的机制来服务。
当 Lean 遇到了在某语境中某表达式的类型与期望类型不一致时，Lean 在报错前会尝试进行强制转换。不像 Java，C，和 Kotlin，强制转换是通过定义类型类实例实现的，并且是可扩展的。

-- # Strings and Paths
# 字符串和路径
%%%
tag := "string-path-coercion"
%%%

-- In the {ref "handling-input"}[source code to {lit}`feline`], a {moduleName}`String` is converted to a {moduleName}`FilePath` using the anonymous constructor syntax.
-- In fact, this was not necessary: Lean defines a coercion from {moduleName}`String` to {moduleName}`FilePath`, so a string can be used in an position where a path is expected.
-- Even though the function {anchorTerm readFile}`IO.FS.readFile` has type {anchorTerm readFile}`System.FilePath → IO String`, the following code is accepted by Lean:

在 {ref "handling-input"}[{lit}`feline` 的源代码] 中，使用匿名构造器语法将 {moduleName}`String` 转换为 {moduleName}`FilePath`。
实际上，这没有必要：Lean 定义了从 {moduleName}`String` 到 {moduleName}`FilePath` 的强制类型转换，因此字符串可以用在需要路径的位置。
尽管函数 {anchorTerm readFile}`IO.FS.readFile` 的类型为 {anchorTerm readFile}`System.FilePath → IO String`，但 Lean 接受以下代码：

```anchor fileDumper
def fileDumper : IO Unit := do
  let stdin ← IO.getStdin
  let stdout ← IO.getStdout
  stdout.putStr "Which file? "
  stdout.flush
  let f := (← stdin.getLine).trim
  stdout.putStrLn s!"'The file {f}' contains:"
  stdout.putStrLn (← IO.FS.readFile f)
```

-- {moduleName}`String.trim` removes leading and trailing whitespace from a string.
-- On the last line of {anchorName fileDumper}`fileDumper`, the coercion from {moduleName}`String` to {moduleName}`FilePath` automatically converts {anchorName fileDumper}`f`, so it is not necessary to write {lit}`IO.FS.readFile ⟨f⟩`.

{moduleName}`String.trim` 从字符串中删除前导和尾随空格。
在 {anchorName fileDumper}`fileDumper` 的最后一行，从 {moduleName}`String` 到 {moduleName}`FilePath` 的强制类型转换会自动转换 {anchorName fileDumper}`f`，因此不必编写 {lit}`IO.FS.readFile ⟨f⟩`。

-- # Positive Numbers
# 正数
%%%
tag := "positive-number-coercion"
%%%

-- Every positive number corresponds to a natural number.
-- The function {anchorName posToNat}`Pos.toNat` that was defined earlier converts a {moduleName}`Pos` to the corresponding {moduleName}`Nat`:

每个正数都对应一个自然数。
前面定义的函数 {anchorName posToNat}`Pos.toNat` 将 {moduleName}`Pos` 转换为相应的 {moduleName}`Nat`：

```anchor posToNat
def Pos.toNat : Pos → Nat
  | Pos.one => 1
  | Pos.succ n => n.toNat + 1
```

-- The function {anchorName drop}`List.drop`, with type {anchorTerm drop}`{α : Type} → Nat → List α → List α`, removes a prefix of a list.
-- Applying {anchorName drop}`List.drop` to a {moduleName}`Pos`, however, leads to a type error:

函数 {anchorName drop}`List.drop` 的类型为 {anchorTerm drop}`{α : Type} → Nat → List α → List α`，它会删除列表的前缀。
然而，将 {anchorName drop}`List.drop` 应用于 {moduleName}`Pos` 会导致类型错误：

```anchorTerm dropPos
[1, 2, 3, 4].drop (2 : Pos)
```
```anchorError dropPos
Application type mismatch: The argument
  2
has type
  Pos
but is expected to have type
  Nat
in the application
  List.drop 2
```

-- Because the author of {anchorName drop}`List.drop` did not make it a method of a type class, it can't be overridden by defining a new instance.

因为 {anchorName drop}`List.drop` 的作者没有将其设为类型类的方法，所以无法通过定义新实例来覆盖它。

-- The type class {moduleName}`Coe` describes overloaded ways of coercing from one type to another:

类型类 {moduleName}`Coe` 描述了从一种类型强制转换为另一种类型的重载方式：

```anchor Coe
class Coe (α : Type) (β : Type) where
  coe : α → β
```

-- An instance of {anchorTerm CoePosNat}`Coe Pos Nat` is enough to allow the prior code to work:

{anchorTerm CoePosNat}`Coe Pos Nat` 的实例足以让前面的代码工作：

```anchor CoePosNat
instance : Coe Pos Nat where
  coe x := x.toNat
```

```anchor dropPosCoe
#eval [1, 2, 3, 4].drop (2 : Pos)
```
```anchorInfo dropPosCoe
[3, 4]
```

-- Using {kw}`#check` shows the result of the instance search that was used behind the scenes:

使用 {kw}`#check` 显示了幕后使用的实例搜索的结果：

```anchor checkDropPosCoe
#check [1, 2, 3, 4].drop (2 : Pos)
```
```anchorInfo checkDropPosCoe
List.drop (Pos.toNat 2) [1, 2, 3, 4] : List Nat
```

-- # Chaining Coercions
# 链接强制类型转换
%%%
tag := "chaining-coercions"
%%%

-- When searching for coercions, Lean will attempt to assemble a coercion out of a chain of smaller coercions.
-- For example, there is already a coercion from {anchorName chapterIntro}`Nat` to {anchorName chapterIntro}`Int`.
-- Because of that instance, combined with the {anchorTerm CoePosNat}`Coe Pos Nat` instance, the following code is accepted:

在搜索强制类型转换时，Lean 会尝试从一系列较小的强制类型转换中组合出一个强制类型转换。
例如，已经存在从 {anchorName chapterIntro}`Nat` 到 {anchorName chapterIntro}`Int` 的强制类型转换。
由于该实例，再加上 {anchorTerm CoePosNat}`Coe Pos Nat` 实例，我们就可以写出下面的代码：

```anchor posInt
def oneInt : Int := Pos.one
```

-- This definition uses two coercions: from {anchorTerm CoePosNat}`Pos` to {anchorTerm CoePosNat}`Nat`, and then from {anchorTerm CoePosNat}`Nat` to {anchorTerm chapterIntro}`Int`.

此定义使用了两次强制类型转换：从 {anchorTerm CoePosNat}`Pos` 到 {anchorTerm CoePosNat}`Nat`，然后从 {anchorTerm CoePosNat}`Nat` 到 {anchorTerm chapterIntro}`Int`。

-- The Lean compiler does not get stuck in the presence of circular coercions.
-- For example, even if two types {anchorName CoercionCycle}`A` and {anchorName CoercionCycle}`B` can be coerced to one another, their mutual coercions can be used to find a path:

Lean 编译器在存在循环强制类型转换时不会卡住。
例如，即使两种类型 {anchorName CoercionCycle}`A` 和 {anchorName CoercionCycle}`B` 可以相互强制转换，它们的相互强制类型转换也可以用来寻找路径：

```anchor CoercionCycle
inductive A where
  | a

inductive B where
  | b

instance : Coe A B where
  coe _ := B.b

instance : Coe B A where
  coe _ := A.a

instance : Coe Unit A where
  coe _ := A.a

def coercedToB : B := ()
```

-- Remember: the double parentheses {anchorTerm CoercionCycle}`()` is short for the constructor {anchorName chapterIntro}`Unit.unit`.
-- After deriving a {anchorTerm ReprBTm}`Repr B` instance with {anchorTerm ReprB}`deriving instance Repr for B`,

记住：双括号 {anchorTerm CoercionCycle}`()` 是构造器 {anchorName chapterIntro}`Unit.unit` 的缩写。
在使用 {anchorTerm ReprB}`deriving instance Repr for B` 派生 {anchorTerm ReprBTm}`Repr B` 实例后，

```anchor coercedToBEval
#eval coercedToB
```
-- results in:

结果为：

```anchorInfo coercedToBEval
B.b
```

-- The {anchorName CoeOption}`Option` type can be used similarly to nullable types in C# and Kotlin: the {anchorName NEListGetHuh}`none` constructor represents the absence of a value.
-- The Lean standard library defines a coercion from any type {anchorName CoeOption}`α` to {anchorTerm CoeOption}`Option α` that wraps the value in {anchorName CoeOption}`some`.
-- This allows option types to be used in a manner even more similar to nullable types, because {anchorName CoeOption}`some` can be omitted.
-- For instance, the function {anchorName lastHuh}`List.last?` that finds the last entry in a list can be written without a {anchorName CoeOption}`some` around the return value {anchorName lastHuh}`x`:

{anchorName CoeOption}`Option` 类型的使用方式与 C# 和 Kotlin 中的可空类型类似：{anchorName NEListGetHuh}`none` 构造器就代表了一个不存在的值。
Lean 标准库定义了从任何类型 {anchorName CoeOption}`α` 到 {anchorTerm CoeOption}`Option α` 的强制类型转换，它将值包装在 {anchorName CoeOption}`some` 中。
这使得选项类型的使用方式与可空类型更加相似，因为可以省略 {anchorName CoeOption}`some`。
例如，查找列表中最后一个条目的函数 {anchorName lastHuh}`List.last?` 可以返回值 {anchorName lastHuh}`x` 而无需加上 {anchorName CoeOption}`some` ：

```anchor lastHuh
def List.last? : List α → Option α
  | [] => none
  | [x] => x
  | _ :: x :: xs => last? (x :: xs)
```

-- Instance search finds the coercion, and inserts a call to {anchorName Coe}`coe`, which wraps the argument in {anchorName CoeOption}`some`.
-- These coercions can be chained, so that nested uses of {anchorName CoeOption}`Option` don't require nested {anchorName CoeOption}`some` constructors:

实例搜索找到强制类型转换，并插入对 {anchorName Coe}`coe` 的调用，该调用将参数包装在 {anchorName CoeOption}`some` 中。
这些强制类型转换可以是链式的，因此 {anchorName CoeOption}`Option` 的嵌套使用不需要嵌套的 {anchorName CoeOption}`some` 构造器：

```anchor perhapsPerhapsPerhaps
def perhapsPerhapsPerhaps : Option (Option (Option String)) :=
  "Please don't tell me"
```
-- Coercions are only activated automatically when Lean encounters a mismatch between an inferred type and a type that is imposed from the rest of the program.
-- In cases with other errors, coercions are not activated.
-- For example, if the error is that an instance is missing, coercions will not be used:

只有当 Lean 遇到推断类型与程序其余部分强加的类型不匹配时，才会自动激活强制类型转换。
在出现其他错误的情况下，不会激活强制类型转换。
例如，如果错误是缺少实例，则不会使用强制类型转换：

```anchor ofNatBeforeCoe
def perhapsPerhapsPerhapsNat : Option (Option (Option Nat)) :=
  392
```
```anchorError ofNatBeforeCoe
failed to synthesize
  OfNat (Option (Option (Option Nat))) 392
numerals are polymorphic in Lean, but the numeral `392` cannot be used in a context where the expected type is
  Option (Option (Option Nat))
due to the absence of the instance above

Hint: Additional diagnostic information may be available using the `set_option diagnostics true` command.
```

-- This can be worked around by manually indicating the desired type to be used for {moduleName}`OfNat`:

这可以通过手动指示要用于 {moduleName}`OfNat` 的所需类型来解决：

```anchor perhapsPerhapsPerhapsNat
def perhapsPerhapsPerhapsNat : Option (Option (Option Nat)) :=
  (392 : Nat)
```

-- Additionally, coercions can be manually inserted using an up arrow:

此外，可以使用向上箭头手动插入强制类型转换：

```anchor perhapsPerhapsPerhapsNatUp
def perhapsPerhapsPerhapsNat : Option (Option (Option Nat)) :=
  ↑(392 : Nat)
```

-- In some cases, this can be used to ensure that Lean finds the right instances.
-- It can also make the programmer's intentions more clear.
在某些情况下，这可以用来确保 Lean 找到正确的实例。
它还可以使程序员的意图更清晰。

-- # Non-Empty Lists and Dependent Coercions
# 非空列表和依赖强制类型转换
%%%
tag := "CoeDep"
%%%
-- An instance of {anchorTerm chapterIntro}`Coe α β` makes sense when the type {anchorName chapterIntro}`β` has a value that can represent each value from the type {anchorName chapterIntro}`α`.
-- Coercing from {moduleName}`Nat` to {moduleName}`Int` makes sense, because the type {moduleName}`Int` contains all the natural numbers, but a coercion from {moduleName}`Int` to {moduleName}`Nat` is a poor idea because {moduleName}`Nat` does not contain the negative numbers.
-- Similarly, a coercion from non-empty lists to ordinary lists makes sense because the {moduleName}`List` type can represent every non-empty list:

当类型 {anchorName chapterIntro}`β` 的值可以表示类型 {anchorName chapterIntro}`α` 的每个值时，{anchorTerm chapterIntro}`Coe α β` 的实例才有意义。
从 {moduleName}`Nat` 强制转换为 {moduleName}`Int` 是有意义的，因为 {moduleName}`Int` 类型包含所有自然数，但从 {moduleName}`Int` 强制转换为 {moduleName}`Nat` 是一个坏主意，因为 {moduleName}`Nat` 不包含负数。
同样，从非空列表到普通列表的强制类型转换也是有意义的，因为 {moduleName}`List` 类型可以表示每个非空列表：

```anchor CoeNEList
instance : Coe (NonEmptyList α) (List α) where
  coe
    | { head := x, tail := xs } => x :: xs
```

-- This allows non-empty lists to be used with the entire {moduleName}`List` API.

这允许将非空列表与整个 {moduleName}`List` API 一起使用。

-- On the other hand, it is impossible to write an instance of {anchorTerm coeNope}`Coe (List α) (NonEmptyList α)`, because there's no non-empty list that can represent the empty list.
-- This limitation can be worked around by using another version of coercions, which are called _dependent coercions_.
-- Dependent coercions can be used when the ability to coerce from one type to another depends on which particular value is being coerced.
-- Just as the {anchorName OfNat}`OfNat` type class takes the particular {moduleName}`Nat` being overloaded as a parameter, dependent coercion takes the value being coerced as a parameter:

另一方面，不可能编写 {anchorTerm coeNope}`Coe (List α) (NonEmptyList α)` 的实例，因为没有非空列表可以表示空列表。
这个限制可以通过使用另一种版本的强制类型转换来解决，即*依赖强制类型转换*。
当从一种类型强制转换为另一种类型的能力取决于正在强制转换的特定值时，可以使用依赖强制类型转换。
就像 {anchorName OfNat}`OfNat` 类型类将正在重载的特定 {moduleName}`Nat` 作为参数一样，依赖强制类型转换将正在强制转换的值作为参数：


```anchor CoeDep
class CoeDep (α : Type) (x : α) (β : Type) where
  coe : β
```

-- This is a chance to select only certain values, either by imposing further type class constraints on the value or by writing certain constructors directly.
-- For example, any {moduleName}`List` that is not actually empty can be coerced to a {moduleName}`NonEmptyList`:

这是一个只选择某些值的机会，可以通过对值施加进一步的类型类约束或直接编写某些构造器来实现。
例如，任何实际上不为空的 {moduleName}`List` 都可以强制转换为 {moduleName}`NonEmptyList`：

```anchor CoeDepListNEList
instance : CoeDep (List α) (x :: xs) (NonEmptyList α) where
  coe := { head := x, tail := xs }
```

-- # Coercing to Types
# 强制转换为类型
%%%
tag := "CoeSort"
%%%
-- In mathematics, it is common to have a concept that consists of a set equipped with additional structure.
-- For example, a monoid is some set $`S`, an element $`s` of $`S`, and an associative binary operator on $`S`, such that $`s` is neutral on the left and right of the operator.
-- $`S` is referred to as the “carrier set” of the monoid.
-- The natural numbers with zero and addition form a monoid, because addition is associative and adding zero to any number is the identity.
-- Similarly, the natural numbers with one and multiplication also form a monoid.
-- Monoids are also widely used in functional programming: lists, the empty list, and the append operator form a monoid, as do strings, the empty string, and string append:

在数学中，有一些概念由一个集合配备一些附加结构得来。
例如，一个幺半群是某个集合 $`S`、$`S` 的元素 $`s` 以及 $`S` 上的结合二元运算，使得 $`s` 在运算符的左边和右边都是中性的。
$`S` 被称为幺半群的“载体集”。
自然数集上的零和加法构成一个幺半群，因为加法是满足结合律的，并且为任何一个数字加零都是恒等的。
类似地，自然数上的一和乘法也构成一个幺半群。幺半群在函数式编程中的应用也很广泛：列表，空列表，和连接运算符构成一个幺半群。字符串，空字符串，和连接运算符也构成一个幺半群：

```anchor Monoid
structure Monoid where
  Carrier : Type
  neutral : Carrier
  op : Carrier → Carrier → Carrier

def natMulMonoid : Monoid :=
  { Carrier := Nat, neutral := 1, op := (· * ·) }

def natAddMonoid : Monoid :=
  { Carrier := Nat, neutral := 0, op := (· + ·) }

def stringMonoid : Monoid :=
  { Carrier := String, neutral := "", op := String.append }

def listMonoid (α : Type) : Monoid :=
  { Carrier := List α, neutral := [], op := List.append }
```

-- Given a monoid, it is possible to write the {anchorName firstFoldMap}`foldMap` function that, in a single pass, transforms the entries in a list into a monoid's carrier set and then combines them using the monoid's operator.
-- Because monoids have a neutral element, there is a natural result to return when the list is empty, and because the operator is associative, clients of the function don't have to care whether the recursive function combines elements from left to right or from right to left.

给定一个幺半群，可以编写 {anchorName firstFoldMap}`foldMap` 函数，该函数在一次遍历中将整个列表中的元素映射到载体集中，然后使用幺半群的运算符将它们组合起来。
由于幺半群有单位元，所以当列表为空时我们就可以返回这个值。又因为运算符是满足结合律的，这个函数的用户不需要关心函数结合元素的顺序到底是从左到右的还是从右到左的。

```anchor firstFoldMap
def foldMap (M : Monoid) (f : α → M.Carrier) (xs : List α) : M.Carrier :=
  let rec go (soFar : M.Carrier) : List α → M.Carrier
    | [] => soFar
    | y :: ys => go (M.op soFar (f y)) ys
  go M.neutral xs
```

-- Even though a monoid consists of three separate pieces of information, it is common to just refer to the monoid's name in order to refer to its set.
-- Instead of saying “Let A be a monoid and let _x_ and _y_ be elements of its carrier set”, it is common to say “Let _A_ be a monoid and let _x_ and _y_ be elements of _A_”.
-- This practice can be encoded in Lean by defining a new kind of coercion, from the monoid to its carrier set.

尽管一个幺半群是由三部分信息组成的，但在提及它的载体集时使用幺半群的名字也是很常见的。
我们通常不说“设 A 是一个幺半群，设 _x_ 和 _y_ 是其载体集的元素”，而是说“设 _A_ 是一个幺半群，设 _x_ 和 _y_ 是 _A_ 的元素”。
这种做法可以通过定义一种新的强制类型转换（从幺半群到其载体集）在 Lean 中进行编码。

-- The {anchorName CoeMonoid}`CoeSort` class is just like the {anchorName CoePosNat}`Coe` class, with the exception that the target of the coercion must be a _sort_, namely {anchorTerm chapterIntro}`Type` or {anchorTerm chapterIntro}`Prop`.
-- The term _sort_ in Lean refers to these types that classify other types—{anchorTerm Coe}`Type` classifies types that themselves classify data, and {anchorTerm chapterIntro}`Prop` classifies propositions that themselves classify evidence of their truth.
-- Just as {anchorName CoePosNat}`Coe` is checked when a type mismatch occurs, {anchorName CoeMonoid}`CoeSort` is used when something other than a sort is provided in a context where a sort would be expected.

{anchorName CoeMonoid}`CoeSort` 类就像 {anchorName CoePosNat}`Coe` 类一样，只是强制类型转换的目标必须是 sort ，即 {anchorTerm chapterIntro}`Type` 或 {anchorTerm chapterIntro}`Prop`。
在 Lean 中， sort 一词指的是对其他类型进行分类的这些类型——{anchorTerm Coe}`Type` 对本身对数据进行分类的类型进行分类，而 {anchorTerm chapterIntro}`Prop` 对本身对其真实性证据进行分类的命题进行分类。
就像在发生类型不匹配时检查 {anchorName CoePosNat}`Coe` 一样，当在需要 sort 的上下文中提供了 sort 以外的东西时，就会使用 {anchorName CoeMonoid}`CoeSort`。
> 译者注： sort 尚无标准译法。

-- The coercion from a monoid into its carrier set extracts the carrier:

从一个幺半群到它的载体集的强制转换会返回该载体集：

```anchor CoeMonoid
instance : CoeSort Monoid Type where
  coe m := m.Carrier
```

-- With this coercion, the type signatures become less bureaucratic:

有了这个强制转换，类型签名变得不那么繁琐了：

```anchor foldMap
def foldMap (M : Monoid) (f : α → M) (xs : List α) : M :=
  let rec go (soFar : M) : List α → M
    | [] => soFar
    | y :: ys => go (M.op soFar (f y)) ys
  go M.neutral xs
```

-- Another useful example of {anchorName CoeMonoid}`CoeSort` is used to bridge the gap between {anchorName types}`Bool` and {anchorTerm chapterIntro}`Prop`.
-- As discussed in {ref "equality-and-ordering"}[the section on ordering and equality], Lean's {kw}`if` expression expects the condition to be a decidable proposition rather than a {anchorName types}`Bool`.
-- Programs typically need to be able to branch based on Boolean values, however.
-- Rather than have two kinds of {kw}`if` expression, the Lean standard library defines a coercion from {anchorName types}`Bool` to the proposition that the {anchorName types}`Bool` in question is equal to {anchorName types}`true`:

另一个有用的 {anchorName CoeMonoid}`CoeSort` 的使用场景是它可以让{anchorName types}`Bool` 和 {anchorTerm chapterIntro}`Prop` 建立联系。
如 {ref "equality-and-ordering"}[有序性和等价性那一节] 所述，Lean 的 {kw}`if` 表达式期望条件是可判定的命题，而不是 {anchorName types}`Bool`。
然而，程序通常需要能够根据布尔值进行分支。
Lean 标准库没有两种 {kw}`if` 表达式，而是定义了从 {anchorName types}`Bool` 到所讨论的 {anchorName types}`Bool` 等于 {anchorName types}`true` 的命题的强制类型转换，即该 {anchorName types}`Bool` 值等于 {anchorName types}`true`：

```anchor CoeBoolProp
instance : CoeSort Bool Prop where
  coe b := b = true
```

-- In this case, the sort in question is {anchorTerm chapterIntro}`Prop` rather than {anchorTerm chapterIntro}`Type`.

在这种情况下，所讨论的 sort 是 {anchorTerm chapterIntro}`Prop` 而不是 {anchorTerm chapterIntro}`Type`。

-- # Coercing to Functions
# 强制转换为函数
%%%
tag := "CoeFun"
%%%

-- Many datatypes that occur regularly in programming consist of a function along with some extra information about it.
-- For example, a function might be accompanied by a name to show in logs or by some configuration data.
-- Additionally, putting a type in a field of a structure, similarly to the {anchorName Monoid}`Monoid` example, can make sense in contexts where there is more than one way to implement an operation and more manual control is needed than type classes would allow.
-- For example, the specific details of values emitted by a JSON serializer may be important because another application expects a particular format.
-- Sometimes, the function itself may be derivable from just the configuration data.

许多在编程中常见的数据类型都会有一个函数和一些额外的信息组成。例如，一个函数可能附带一个名称以在日志中显示，或附带一些配置数据。
此外，将类型放在结构体的字段中，类似于 {anchorName Monoid}`Monoid` 示例，在有多种方法可以实现操作并且需要比类型类允许的更多手动控制的情况下可能很有意义。
例如，JSON 序列化器生成的值的具体细节可能很重要，因为另一个应用程序期望特定的格式。有时，仅从配置数据就可以推导出函数本身。

-- A type class called {anchorName CoeFun}`CoeFun` can transform values from non-function types to function types.
-- {anchorName CoeFun}`CoeFun` has two parameters: the first is the type whose values should be transformed into functions, and the second is an output parameter that determines exactly which function type is being targeted.

名为 {anchorName CoeFun}`CoeFun` 的类型类可以将非函数类型的值转换为函数类型。
{anchorName CoeFun}`CoeFun` 有两个参数：第一个是需要被转变为函数的值的类型，第二个是一个输出参数，决定了到底应该转换为哪个函数类型。

```anchor CoeFun
class CoeFun (α : Type) (makeFunctionType : outParam (α → Type)) where
  coe : (x : α) → makeFunctionType x
```

-- The second parameter is itself a function that computes a type.
-- In Lean, types are first-class and can be passed to functions or returned from them, just like anything else.

第二个参数本身是一个可以计算类型的函数。在 Lean 中，类型是一等公民，可以作为函数参数被传递，也可以作为返回值，就像其他东西一样。

-- For example, a function that adds a constant amount to its argument can be represented as a wrapper around the amount to add, rather than by defining an actual function:

例如，一个将其参数加上一个常量值的函数可以表示为要加上的数量的包装器，而不是通过定义一个实际的函数：

```anchor Adder
structure Adder where
  howMuch : Nat
```

-- A function that adds five to its argument has a {anchorTerm add5}`5` in the {anchorName Adder}`howMuch` field:

一个将其参数加 5 的函数在 {anchorName Adder}`howMuch` 字段中有一个 {anchorTerm add5}`5`：

```anchor add5
def add5 : Adder := ⟨5⟩
```

-- This {anchorName Adder}`Adder` type is not a function, and applying it to an argument results in an error:

这个 {anchorName Adder}`Adder` 类型不是一个函数，将其应用于参数会导致错误：


```anchor add5notfun
#eval add5 3
```
```anchorError add5notfun
Function expected at
  add5
but this term has type
  Adder

Note: Expected a function because this term is being applied to the argument
  3
```

-- Defining a {anchorName CoeFunAdder}`CoeFun` instance causes Lean to transform the adder into a function with type {anchorTerm CoeFunAdder}`Nat → Nat`:

定义一个 {anchorName CoeFunAdder}`CoeFun` 实例会使 Lean 将加法器转换为类型为 {anchorTerm CoeFunAdder}`Nat → Nat` 的函数：

```anchor CoeFunAdder
instance : CoeFun Adder (fun _ => Nat → Nat) where
  coe a := (· + a.howMuch)
```

```anchor add53
#eval add5 3
```
```anchorInfo add53
8
```

-- Because all {anchorName CoeFunAdder}`Adder`s should be transformed into {anchorTerm CoeFunAdder}`Nat → Nat` functions, the argument to {anchorName CoeFunAdder}`CoeFun`'s second parameter was ignored.

因为所有 {anchorName CoeFunAdder}`Adder` 都应转换为 {anchorTerm CoeFunAdder}`Nat → Nat` 函数，所以忽略了 {anchorName CoeFunAdder}`CoeFun` 的第二个参数的参数。

-- When the value itself is needed to determine the right function type, then {anchorName CoeFunAdder}`CoeFun`'s second parameter is no longer ignored.
-- For example, given the following representation of JSON values:

当需要值本身来确定正确的函数类型时，就不再忽略 {anchorName CoeFunAdder}`CoeFun` 的第二个参数。
例如，给定以下 JSON 值的表示：

```anchor JSON
inductive JSON where
  | true : JSON
  | false : JSON
  | null : JSON
  | string : String → JSON
  | number : Float → JSON
  | object : List (String × JSON) → JSON
  | array : List JSON → JSON
```

-- a JSON serializer is a structure that tracks the type it knows how to serialize along with the serialization code itself:

JSON 序列化器是一个结构，它跟踪它知道如何序列化的类型以及序列化代码本身：

```anchor Serializer
structure Serializer where
  Contents : Type
  serialize : Contents → JSON
```

-- A serializer for strings need only wrap the provided string in the {anchorName StrSer}`JSON.string` constructor:
字符串的序列化器只需将提供的字符串包装在 {anchorName StrSer}`JSON.string` 构造器中：

```anchor StrSer
def Str : Serializer :=
  { Contents := String,
    serialize := JSON.string
  }
```

-- Viewing JSON serializers as functions that serialize their argument requires extracting the inner type of serializable data:

将 JSON 序列化器视为序列化其参数的函数需要提取可序列化数据的内部类型：

```anchor CoeFunSer
instance : CoeFun Serializer (fun s => s.Contents → JSON) where
  coe s := s.serialize
```

-- Given this instance, a serializer can be applied directly to an argument:

有了这个实例，序列化器就可以直接应用于参数：

```anchor buildResponse
def buildResponse (title : String) (R : Serializer)
    (record : R.Contents) : JSON :=
  JSON.object [
    ("title", JSON.string title),
    ("status", JSON.number 200),
    ("record", R record)
  ]
```

-- The serializer can be passed directly to {anchorName buildResponseOut}`buildResponse`:

序列化器可以直接传递给 {anchorName buildResponseOut}`buildResponse`：

```anchor buildResponseOut
#eval buildResponse "Functional Programming in Lean" Str "Programming is fun!"
```
```anchorInfo buildResponseOut
JSON.object
  [("title", JSON.string "Functional Programming in Lean"),
   ("status", JSON.number 200.000000),
   ("record", JSON.string "Programming is fun!")]
```

-- ## Aside: JSON as a String
## 附注：作为字符串的 JSON
%%%
tag := "json-string"
%%%

-- It can be a bit difficult to understand JSON when encoded as Lean objects.
-- To help make sure that the serialized response was what was expected, it can be convenient to write a simple converter from {anchorName JSON}`JSON` to {anchorName dropDecimals}`String`.
-- The first step is to simplify the display of numbers.
-- {anchorName JSON}`JSON` doesn't distinguish between integers and floating point numbers, and the type {anchorName JSON}`Float` is used to represent both.
-- In Lean, {anchorName chapterIntro}`Float.toString` includes a number of trailing zeros:

当编码为 Lean 对象时，理解 JSON 可能有点困难。
为了帮助确保序列化的响应符合预期，编写一个从 {anchorName JSON}`JSON` 到 {anchorName dropDecimals}`String` 的简单转换器可能很方便。第一步是简化数字的显示。
{anchorName JSON}`JSON` 不区分整数和浮点数，类型 {anchorName JSON}`Float` 用于表示两者。
在 Lean 中，{anchorName chapterIntro}`Float.toString` 包含许多尾随零：

```anchor fiveZeros
#eval (5 : Float).toString
```
```anchorInfo fiveZeros
"5.000000"
```

-- The solution is to write a little function that cleans up the presentation by dropping all trailing zeros, followed by a trailing decimal point:

解决方案是编写一个小函数，通过删除所有尾随零，然后是尾随小数点来清理表示：

```anchor dropDecimals
def dropDecimals (numString : String) : String :=
  if numString.contains '.' then
    let noTrailingZeros := numString.dropRightWhile (· == '0')
    noTrailingZeros.dropRightWhile (· == '.')
  else numString
```

-- With this definition, {anchorTerm dropDecimalExample}`dropDecimals (5 : Float).toString` yields {anchorTerm dropDecimalExample}`5`, and {anchorTerm dropDecimalExample2}`dropDecimals (5.2 : Float).toString` yields {anchorTerm dropDecimalExample2}`5.2`.

通过这个定义，{anchorTerm dropDecimalExample}`dropDecimals (5 : Float).toString` 产生 {anchorTerm dropDecimalExample}`5`，而 {anchorTerm dropDecimalExample2}`dropDecimals (5.2 : Float).toString` 产生 {anchorTerm dropDecimalExample2}`5.2`。

-- The next step is to define a helper function to append a list of strings with a separator in between them:

下一步是定义一个辅助函数，用分隔符将字符串列表附加在一起：

```anchor Stringseparate
def String.separate (sep : String) (strings : List String) : String :=
  match strings with
  | [] => ""
  | x :: xs => String.join (x :: xs.map (sep ++ ·))
```

-- This function is useful to account for comma-separated elements in JSON arrays and objects.
-- {anchorTerm sep2ex}`", ".separate ["1", "2"]` yields {anchorInfo sep2ex}`"1, 2"`, {anchorTerm sep1ex}`", ".separate ["1"]` yields {anchorInfo sep1ex}`"1"`, and {anchorTerm sep0ex}`", ".separate []` yields {anchorInfo sep0ex}`""`.
-- In the Lean standard library, this function is called {anchorName chapterIntro}`String.intercalate`.

此函数对于处理 JSON 数组和对象中以逗号分隔的元素很有用。
{anchorTerm sep2ex}`", ".separate ["1", "2"]` 产生 {anchorInfo sep2ex}`"1, 2"`，{anchorTerm sep1ex}`", ".separate ["1"]` 产生 {anchorInfo sep1ex}`"1"`，而 {anchorTerm sep0ex}`", ".separate []` 产生 {anchorInfo sep0ex}`""`。
在 Lean 标准库中，此函数称为 {anchorName chapterIntro}`String.intercalate`。

-- Finally, a string escaping procedure is needed for JSON strings, so that the Lean string containing {anchorTerm chapterIntro}`"Hello!"` can be output as {anchorTerm escapeQuotes}`"\"Hello!\""`.
-- Fortunately, the Lean compiler contains an internal function for escaping JSON strings already, called {anchorName escapeQuotes}`Lean.Json.escape`.
-- To access this function, add {lit}`import Lean` to the beginning of your file.

最后，需要一个用于 JSON 字符串的字符串转义过程，以便包含 {anchorTerm chapterIntro}`"Hello!"` 的 Lean 字符串可以输出为 {anchorTerm escapeQuotes}`"\"Hello!\""`。
幸运的是，Lean 编译器已经包含一个用于转义 JSON 字符串的内部函数，称为 {anchorName escapeQuotes}`Lean.Json.escape`。
要访问此函数，请在文件开头添加 {lit}`import Lean`。

-- The function that emits a string from a {anchorName JSONasString}`JSON` value is declared {kw}`partial` because Lean cannot see that it terminates.
-- This is because recursive calls to {anchorName JSONasString}`asString` occur in functions that are being applied by {anchorName chapterIntro}`List.map`, and this pattern of recursion is complicated enough that Lean cannot see that the recursive calls are actually being performed on smaller values.
-- In an application that just needs to produce JSON strings and doesn't need to mathematically reason about the process, having the function be {kw}`partial` is not likely to cause problems.

从 {anchorName JSONasString}`JSON` 值发出字符串的函数被声明为 {kw}`partial`，因为 Lean 看不到它会终止。
这是因为对 {anchorName JSONasString}`asString` 的递归调用发生在由 {anchorName chapterIntro}`List.map` 应用的函数中，并且这种递归模式足够复杂，以至于 Lean 看不到递归调用实际上是在较小的值上执行的。
在一个只需要生成 JSON 字符串而不需要对过程进行数学推理的应用程序中，将函数设为 {kw}`partial` 不太可能导致问题。

```anchor JSONasString
partial def JSON.asString (val : JSON) : String :=
  match val with
  | true => "true"
  | false => "false"
  | null => "null"
  | string s => "\"" ++ Lean.Json.escape s ++ "\""
  | number n => dropDecimals n.toString
  | object members =>
    let memberToString mem :=
      "\"" ++ Lean.Json.escape mem.fst ++ "\": " ++ asString mem.snd
    "{" ++ ", ".separate (members.map memberToString) ++ "}"
  | array elements =>
    "[" ++ ", ".separate (elements.map asString) ++ "]"
```

-- With this definition, the output of serialization is easier to read:

通过这个定义，序列化的输出更容易阅读：

```anchor buildResponseStr
#eval (buildResponse "Functional Programming in Lean" Str "Programming is fun!").asString
```
```anchorInfo buildResponseStr
"{\"title\": \"Functional Programming in Lean\", \"status\": 200, \"record\": \"Programming is fun!\"}"
```

-- # Messages You May Meet
# 您可能会遇到的消息
%%%
tag := "coercion-messages"
%%%
-- Natural number literals are overloaded with the {anchorName OfNat}`OfNat` type class.
-- Because coercions fire in cases where types don't match, rather than in cases of missing instances, a missing {anchorName OfNat}`OfNat` instance for a type does not cause a coercion from {moduleName}`Nat` to be applied:

自然数字面量使用 {anchorName OfNat}`OfNat` 类型类进行重载。
因为强制类型转换在类型不匹配的情况下触发，而不是在缺少实例的情况下触发，所以缺少类型的 {anchorName OfNat}`OfNat` 实例不会导致应用从 {moduleName}`Nat` 的强制类型转换：

```anchor ofNatBeforeCoe
def perhapsPerhapsPerhapsNat : Option (Option (Option Nat)) :=
  392
```
```anchorError ofNatBeforeCoe
failed to synthesize
  OfNat (Option (Option (Option Nat))) 392
numerals are polymorphic in Lean, but the numeral `392` cannot be used in a context where the expected type is
  Option (Option (Option Nat))
due to the absence of the instance above

Hint: Additional diagnostic information may be available using the `set_option diagnostics true` command.
```

-- # Design Considerations
# 设计原则
%%%
tag := "coercion-design-considerations"
%%%

-- Coercions are a powerful tool that should be used responsibly.
-- On the one hand, they can allow an API to naturally follow the everyday rules of the domain being modeled.
-- This can be the difference between a bureaucratic mess of manual conversion functions and a clear program.
-- As Abelson and Sussman wrote in the preface to _Structure and Interpretation of Computer Programs_ (MIT Press, 1996),

强制转换是一个强大的工具，请负责任地使用它。一方面，它可以使 API 设计得更贴近领域内使用习惯。这是繁琐的手动转换函数和一个清晰的程序间的差别。
正如 Abelson 和 Sussman 在《计算机程序的构造和解释》 (_Structure and Interpretation of Computer Programs_, MIT Press, 1996) 的前言中所写：

-- > Programs must be written for people to read, and only incidentally for machines to execute.

> 写程序须以让人读明白为主，让计算机执行为辅。

-- Coercions, used wisely, are a valuable means of achieving readable code that can serve as the basis for communication with domain experts.
-- APIs that rely heavily on coercions have a number of important limitations, however.
-- Think carefully about these limitations before using coercions in your own libraries.

明智地使用强制转换，可以使得代码更加易读——这是与领域内专家的交流的基础。然而，严重依赖强制转换的 API 会有许多限制。在你自己的代码中使用强制转换前，认真思考这些限制。

-- First off, coercions are only applied in contexts where enough type information is available for Lean to know all of the types involved, because there are no output parameters in the coercion type classes. This means that a return type annotation on a function can be the difference between a type error and a successfully applied coercion.
-- For example, the coercion from non-empty lists to lists makes the following program work:
首先，强制转换只应该出现在类型信息充足，Lean 能够知道所有参与的类型的语境中。因为强制转换类型类中并没有输出参数这么一说。这意味着在函数上添加返回类型注释可以决定是类型错误还是成功应用强制转换。例如，从非空列表到列表的强制转换使以下程序得以运行：

```anchor lastSpiderA
def lastSpider : Option String :=
  List.getLast? idahoSpiders
```

-- On the other hand, if the type annotation is omitted, then the result type is unknown, so Lean is unable to find the coercion:
另一方面，如果类型注释被省略了，那么结果的类型就是未知的，那么 Lean 就无法找到对应的强制转换。

```anchor lastSpiderB
def lastSpider :=
  List.getLast? idahoSpiders
```
```anchorError lastSpiderB
Application type mismatch: The argument
  idahoSpiders
has type
  NonEmptyList String
but is expected to have type
  List ?m.3
in the application
  List.getLast? idahoSpiders
```

-- More generally, when a coercion is not applied for some reason, the user receives the original type error, which can make it difficult to debug chains of coercions.

通常来讲，如果一个强制转换因为一些原因失败了，用户会收到原始的类型错误，这会使在强制转换链上定位错误变得十分困难。

-- Finally, coercions are not applied in the context of field accessor notation.
-- This means that there is still an important difference between expressions that need to be coerced and those that don't, and this difference is visible to users of your API.

最后，强制转换不会在字段访问符号的上下文中应用。这意味着需要强制转换的表达式与不需要强制转换的表达式之间仍然存在重要区别，而这个区别对用户来说是肉眼可见的。
