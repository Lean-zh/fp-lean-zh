<!--
# Standard Classes
-->

# 标准类 { #standard-classes }

<!--
This section presents a variety of operators and functions that can be overloaded using type classes in Lean.
Each operator or function corresponds to a method of a type class.
Unlike C++, infix operators in Lean are defined as abbreviations for named functions; this means that overloading them for new types is not done using the operator itself, but rather using the underlying name (such as `HAdd.hAdd`).
-->

本节中展示了各种可重载的运算符和函数。在 Lean 中，它们都通过类型类来重载。
每个运算符或函数都对应于一个类型类中的方法。
不像 C++，Lean 中的中缀操作符定义为命名函数的缩写；这意味着为新类型重载它们不是使用操作符本身，而是使用其底层名称（例如 `HAdd.hAdd`）。

<!--
## Arithmetic
-->

## 算术符号 { #arithmetic }

<!--
Most arithmetic operators are available in a heterogeneous form, where the arguments may have different type and an output parameter decides the type of the resulting expression.
For each heterogeneous operator, there is a corresponding homogeneous version that can found by removing the letter `h`, so that `HAdd.hAdd` becomes `Add.add`.
The following arithmetic operators are overloaded:
-->

多数算术运算符都是可以进行异质运算的。
这意味着参数可能有不同的类型，并且输出参数决定了结果表达式的类型。
对于每个异质运算符，都有一个同质运算符与其对应。
只要把字母 `h` 去掉就能找到那个同质运算符了，`HAdd.hAdd` 对应 `Add.add`。
下面的算术运算符都可以被重载：

| Expression | Desugaring | Class Name |
|------------|------------|------------|
| `{{#example_in Examples/Classes.lean plusDesugar}}` | `{{#example_out Examples/Classes.lean plusDesugar}}` | `HAdd` |
| `{{#example_in Examples/Classes.lean minusDesugar}}` | `{{#example_out Examples/Classes.lean minusDesugar}}` | `HSub` |
| `{{#example_in Examples/Classes.lean timesDesugar}}` | `{{#example_out Examples/Classes.lean timesDesugar}}` | `HMul` |
| `{{#example_in Examples/Classes.lean divDesugar}}` | `{{#example_out Examples/Classes.lean divDesugar}}` | `HDiv` |
| `{{#example_in Examples/Classes.lean modDesugar}}` | `{{#example_out Examples/Classes.lean modDesugar}}` | `HMod` |
| `{{#example_in Examples/Classes.lean powDesugar}}` | `{{#example_out Examples/Classes.lean powDesugar}}` | `HPow` |
| `{{#example_in Examples/Classes.lean negDesugar}}` | `{{#example_out Examples/Classes.lean negDesugar}}` | `Neg` |


<!--
## Bitwise Operators
-->

## 位运算符 { #bitwise-operators }

<!--
Lean contains a number of standard bitwise operators that are overloaded using type classes.
There are instances for fixed-width types such as `{{#example_in Examples/Classes.lean UInt8}}`, `{{#example_in Examples/Classes.lean UInt16}}`, `{{#example_in Examples/Classes.lean UInt32}}`, `{{#example_in Examples/Classes.lean UInt64}}`, and `{{#example_in Examples/Classes.lean USize}}`.
The latter is the size of words on the current platform, typically 32 or 64 bits.
The following bitwise operators are overloaded:
-->

Lean 包含了许多标准位运算符，他们也可以用类型类来重载。
Lean 中有对于定长类型的实例，例如 `{{#example_in Examples/Classes.lean UInt8}}`，`{{#example_in Examples/Classes.lean UInt16}}`，`{{#example_in Examples/Classes.lean UInt32}}`，`{{#example_in Examples/Classes.lean UInt64}}`，和 `{{#example_in Examples/Classes.lean USize}}`。

| Expression | Desugaring | Class Name |
|------------|------------|------------|
| `{{#example_in Examples/Classes.lean bAndDesugar}}` | `{{#example_out Examples/Classes.lean bAndDesugar}}` | `HAnd` |
| <code class="hljs">x &#x7c;&#x7c;&#x7c; y </code> | `{{#example_out Examples/Classes.lean bOrDesugar}}` | `HOr` |
| `{{#example_in Examples/Classes.lean bXorDesugar}}` | `{{#example_out Examples/Classes.lean bXorDesugar}}` | `HXor` |
| `{{#example_in Examples/Classes.lean complementDesugar}}` | `{{#example_out Examples/Classes.lean complementDesugar}}` | `Complement` |
| `{{#example_in Examples/Classes.lean shrDesugar}}` | `{{#example_out Examples/Classes.lean shrDesugar}}` | `HShiftRight` |
| `{{#example_in Examples/Classes.lean shlDesugar}}` | `{{#example_out Examples/Classes.lean shlDesugar}}` | `HShiftLeft` |

<!--
Because the names `And` and `Or` are already taken as the names of logical connectives, the homogeneous versions of `HAnd` and `HOr` are called `AndOp` and `OrOp` rather than `And` and `Or`.
-->

由于 `And` 和 `Or` 已经是逻辑连接词了，所以 `HAnd` 和 `HOr` 的同质对应叫做 `AndOp` 和 `OrOp` 而不是 `And` 和 `Or`。

<!--
## Equality and Ordering
-->

## 相等性与有序性 { #equality-and-ordering }

<!--
Testing equality of two values typically uses the `BEq` class, which is short for "Boolean equality".
Due to Lean's use as a theorem prover, there are really two kinds of equality operators in Lean:
 * _Boolean equality_ is the same kind of equality that is found in other programming languages. It is a function that takes two values and returns a `Bool`. Boolean equality is written with two equals signs, just as in Python and C#. Because Lean is a pure functional language, there's no separate notions of reference vs value equality—pointers cannot be observed directly.
 * _Propositional equality_ is the mathematical statement that two things are equal. Propositional equality is not a function; rather, it is a mathematical statement that admits proof. It is written with a single equals sign. A statement of propositional equality is like a type that classifies evidence of this equality.
-->

测试两个值之间的相等性通常会用 `BEq` 类，该类名是 Boolean equality（布尔等价）的缩写。
由于 Lean 是一个定理证明器，所以在 Lean 中其实有两种类型的相等运算符：
 * **布尔等价（Boolean equality）** 和你能在其他编程语言中看到的等价是一样的。
 这是一个接受两个值并且返回一个 `Bool` 的函数。
 布尔等价使用两个等号表示，就像在 Python 和 C# 中那样。
 因为 Lean 是一个纯函数式语言，指针并不能被直接看到，所以引用和值等价并没有符号上的区别。
 * **命题等价（Propositional equality）** 是一个 **数学陈述（mathematical statement）** ，指两个东西是等价的。
 命题等价并不是一个函数，而是一个可以证明的数学陈述。
 可以用一个单等号表示。
 一个命题等价的陈述就像一个能检查等价性证据的类型。

<!--
Both notions of equality are important, and used for different purposes.
Boolean equality is useful in programs, when a decision needs to be made about whether two values are equal.
For example, `{{#example_in Examples/Classes.lean boolEqTrue}}` evaluates to `{{#example_out Examples/Classes.lean boolEqTrue}}`, and `{{#example_in Examples/Classes.lean boolEqFalse}}` evaluates to `{{#example_out Examples/Classes.lean boolEqFalse}}`.
Some values, such as functions, cannot be checked for equality.
For example, `{{#example_in Examples/Classes.lean functionEq}}` yields the error:
-->

这两种等价都很重要，它们有不同的用处。
布尔等价在程序中很有用，有时我们需要考察两个值是否是相等的。
例如：`{{#example_in Examples/Classes.lean boolEqTrue}}` 结果为 `{{#example_out Examples/Classes.lean boolEqTrue}}`，以及 `{{#example_in Examples/Classes.lean boolEqFalse}}` 结果为 `{{#example_out Examples/Classes.lean boolEqFalse}}`。
有一些值，比如函数，无法检查等价性。
例如，`{{#example_in Examples/Classes.lean functionEq}}` 会报错：
```output error
{{#example_out Examples/Classes.lean functionEq}}
```
<!--
As this message indicates, `==` is overloaded using a type class.
The expression `{{#example_in Examples/Classes.lean beqDesugar}}` is actually shorthand for `{{#example_out Examples/Classes.lean beqDesugar}}`.
-->

就像这条信息说的，`==` 是使用了类型类重载的。
表达式 `{{#example_in Examples/Classes.lean beqDesugar}}` 事实上是 `{{#example_out Examples/Classes.lean beqDesugar}}` 的缩写。

<!--
Propositional equality is a mathematical statement rather than an invocation of a program.
Because propositions are like types that describe evidence for some statement, propositional equality has more in common with types like `String` and `Nat → List Int` than it does with Boolean equality.
This means that it can't automatically be checked.
However, the equality of any two expressions can be stated in Lean, so long as they have the same type.
The statement `{{#example_in Examples/Classes.lean functionEqProp}}` is a perfectly reasonable statement.
From the perspective of mathematics, two functions are equal if they map equal inputs to equal outputs, so this statement is even true, though it requires a two-line proof to convince Lean of this fact.
-->

命题等价是一个数学陈述，而不是程序调用。
因为命题就像描述一些数学陈述的证据的类型，命题等价和像是 `String` 和 `Nat → List Int` 这样的类型有更多的相同之处，而不是布尔等价。
这意味着它并不能被自动检查。
然而，在 Lean 中，只要两个表达式具有相同的类型，就可以陈述它们的相等性。
`{{#example_in Examples/Classes.lean functionEqProp}}` 是一个十分合理的陈述。
从数学角度来讲，如果两个函数把相等的输入映射到相等的输出，那么这两个函数就是相等的。所以那个陈述是真的，尽管它需要一个两行的证明来让 Lean 相信这个事实。

<!--
Generally speaking, when using Lean as a programming language, it's easiest to stick to Boolean functions rather than propositions.
However, as the names `true` and `false` for `Bool`'s constructors suggest, this difference is sometimes blurred.
Some propositions are _decidable_, which means that they can be checked just like a Boolean function.
The function that checks whether the proposition is true or false is called a _decision procedure_, and it returns _evidence_ of the truth or falsity of the proposition.
Some examples of decidable propositions include equality and inequality of natural numbers, equality of strings, and "ands" and "ors" of propositions that are themselves decidable.
-->

通常来说，当把 Lean 作为一个编程语言来用时，用布尔值函数会比用命题要更简单。

<!--
In Lean, `if` works with decidable propositions.
For example, `2 < 4` is a proposition:
-->

在 Lean 中，`if` 语句适用于可判定命题。
例如：`2 < 4` 是一个命题。
```lean
{{#example_in Examples/Classes.lean twoLessFour}}
```
```output info
{{#example_out Examples/Classes.lean twoLessFour}}
```
<!--
Nonetheless, it is perfectly acceptable to write it as the condition in an `if`.
For example, `{{#example_in Examples/Classes.lean ifProp}}` has type `Nat` and evaluates to `{{#example_out Examples/Classes.lean ifProp}}`.
-->

尽管如此，将其写作 if 语句中的条件是完全可以接受的。
例如，`{{#example_in Examples/Classes.lean ifProp}}` 的类型是 `Nat`，并且计算结果为 `{{#example_out Examples/Classes.lean ifProp}}`。


<!--
Not all propositions are decidable.
If they were, then computers would be able to prove any true proposition just by running the decision procedure, and mathematicians would be out of a job.
More specifically, decidable propositions have an instance of the `Decidable` type class which has a method that is the decision procedure.
Trying to use a proposition that isn't decidable as if it were a `Bool` results in a failure to find the `Decidable` instance.
For example, `{{#example_in Examples/Classes.lean funEqDec}}` results in:
-->

并不是所有的命题都是可判定的。
如果所有的命题都是可判定的，那么计算机通过运行判定程序就可以证明任何的真命题，数学家们就此失业了。
更具体来说，可判定的命题都会有一个 `Decidable` 类型的实例，实例中的方法是判定程序。
因为认为会返回一个 `Bool` 而尝试去用一个不可判定的命题，最终会报错，因为 Lean 无法找到 `Decidable` 实例。
例如，`{{#example_in Examples/Classes.lean funEqDec}}` 会导致：
```output error
{{#example_out Examples/Classes.lean funEqDec}}
```

<!--
The following propositions, that are usually decidable, are overloaded with type classes:
-->

下面的命题，通常都是重载了可判定类型类的：

| Expression | Desugaring | Class Name |
|------------|------------|------------|
| `{{#example_in Examples/Classes.lean ltDesugar}}` | `{{#example_out Examples/Classes.lean ltDesugar}}` | `LT` |
| `{{#example_in Examples/Classes.lean leDesugar}}` | `{{#example_out Examples/Classes.lean leDesugar}}` | `LE` |
| `{{#example_in Examples/Classes.lean gtDesugar}}` | `{{#example_out Examples/Classes.lean gtDesugar}}` | `LT` |
| `{{#example_in Examples/Classes.lean geDesugar}}` | `{{#example_out Examples/Classes.lean geDesugar}}` | `LE` |

<!--
Because defining new propositions hasn't yet been demonstrated, it may be difficult to define new instances of `LT` and `LE`.
-->

因为还没有演示如何定义新命题，所以定义新的 `LT` 和 `LE` 实例可能会比较困难。

<!--
Additionally, comparing values using `<`, `==`, and `>` can be inefficient.
Checking first whether one value is less than another, and then whether they are equal, can require two traversals over large data structures.
To solve this problem, Java and C# have standard `compareTo` and `CompareTo` methods (respectively) that can be overridden by a class in order to implement all three operations at the same time.
These methods return a negative integer if the receiver is less than the argument, zero if they are equal, and a positive integer if the receiver is greater than the argument.
Rather than overload the meaning of integers, Lean has a built-in inductive type that describes these three possibilities:
-->

另外，使用 `<`, `==`, 和 `>` 来比较值可能效率不高。
首先检查一个值是否小于另一个值，然后再检查它们是否相等，这可能需要对大型数据结构进行两次遍历。
为了解决这个问题，Java 和 C# 分别有标准的 `compareTo` 和 `CompareTo` 方法，可以通过类来重写以同时实现这三种操作。
这些方法在接收者小于参数时返回负整数，等于时返回零，大于时返回正整数。
Lean 与其重载整数，不如有一个内置的归纳类型来描述这三种可能性：
```lean
{{#example_decl Examples/Classes.lean Ordering}}
```
<!--
The `Ord` type class can be overloaded to produce these comparisons.
For `Pos`, an implementation can be:
-->

`Ord` 类型类可以被重载，这样就可以用于比较。
对于 `Pos` 一个实现可以是：
```lean
{{#example_decl Examples/Classes.lean OrdPos}}
```
<!--
In situations where `compareTo` would be the right approach in Java, use `Ord.compare` in Lean.
-->

对于 Java 中应该使用 `compareTo` 的情形，在 Lean 中用 `Ord.compare` 就对了。

<!--
## Hashing
-->

## 哈希 { #hashing }

<!--
Java and C# have `hashCode` and `GetHashCode` methods, respectively, that compute a hash of a value for use in data structures such as hash tables.
The Lean equivalent is a type class called `Hashable`:
-->

Java 和 C# 有 `hashCode` 和 `GetHashCode` 方法，用于计算值的哈希值，以便在哈希表等数据结构中使用。
Lean 中的等效类型类称为 `Hashable`：
```lean
{{#example_decl Examples/Classes.lean Hashable}}
```
<!--
If two values are considered equal according to a `BEq` instance for their type, then they should have the same hashes.
In other words, if `x == y` then `hash x == hash y`.
If `x ≠ y`, then `hash x` won't necessarily differ from `hash y` (after all, there are infinitely more `Nat` values than there are `UInt64` values), but data structures built on hashing will have better performance if unequal values are likely to have unequal hashes.
This is the same expectation as in Java and C#.
-->

对于两个值而言，如果它们根据各自类型的 `BEq` 实例是相等的，那么它们也应该有相同的哈希值。
换句话说，如果 `x == y`，那么有 `hash x == hash y`。
如果 `x ≠ y`，那么 `hash x` 不一定就和 `hash y` 不一样（毕竟 `Nat` 有无穷多个，而 `UInt64` 最多只能有有限种组合方式。），
但是如果不一样的值有不一样的哈希值的话，那么建立在其上的数据结构会有更好的表现。
这与 Java 和 C# 中对哈希的要求是一致的。

<!--
The standard library contains a function `{{#example_in Examples/Classes.lean mixHash}}` with type `{{#example_out Examples/Classes.lean mixHash}}` that can be used to combine hashes for different fields for a constructor.
A reasonable hash function for an inductive datatype can be written by assigning a unique number to each constructor, and then mixing that number with the hashes of each field.
For example, a `Hashable` instance for `Pos` can be written:
-->

在标准库中包含了一个函数 `{{#example_in Examples/Classes.lean mixHash}}`，它的类型是 `{{#example_out Examples/Classes.lean mixHash}}`。
它可以用来组合构造子不同字段的哈希值。
一个合理的归纳数据类型的哈希函数可以通过给每个构造函数分配一个唯一的数字，然后将该数字与每个字段的哈希值混合来编写。
例如，可以这样编写 `Pos` 的 `Hashable` 实例：
```lean
{{#example_decl Examples/Classes.lean HashablePos}}
```
<!--
`Hashable` instances for polymorphic types can use recursive instance search.
Hashing a `NonEmptyList α` is only possible when `α` can be hashed:
-->

`Hashable` 实例对于多态可以使用递归类型搜索。
哈希化一个 `NonEmptyList α` 需要 `α` 是可以被哈希化的。
```lean
{{#example_decl Examples/Classes.lean HashableNonEmptyList}}
```
<!--
Binary trees use both recursion and recursive instance search in the implementations of `BEq` and `Hashable`:
-->

在二叉树的 `BEq` 和 `Hashable` 的实现中，递归和递归实例搜索这二者都被用到了。
```lean
{{#example_decl Examples/Classes.lean TreeHash}}
```


<!--
## Deriving Standard Classes
-->

## 派生标准类 { #deriving-standard-classes }

<!--
Instance of classes like `BEq` and `Hashable` are often quite tedious to implement by hand.
Lean includes a feature called _instance deriving_ that allows the compiler to automatically construct well-behaved instances of many type classes.
In fact, the `deriving Repr` phrase in the definition of `Point` in the [section on structures](../getting-to-know/structures.md) is an example of instance deriving.
-->

像 `BEq` 和 `Hashable` 这样的类的实例，手动实现起来通常相当繁琐。Lean 包含一个称为 **实例派生（instance deriving）** 的特性，它使得编译器可以自动构造许多类型类的良好实例。事实上，[结构那一节](../getting-to-know/structures.md)中 `Point` 定义中的 `deriving Repr` 短语就是实例派生的一个例子。

<!--
Instances can be derived in two ways.
The first can be used when defining a structure or inductive type.
In this case, add `deriving` to the end of the type declaration followed by the names of the classes for which instances should be derived.
For a type that is already defined, a standalone `deriving` command can be used.
Write `deriving instance C1, C2, ... for T` to derive instances of `C1, C2, ...` for the type `T` after the fact.
-->

派生实例的方法有两种。
第一种在定义一个结构体或归纳类型时使用。
在这种情况下，添加 `deriving` 到类型声明的末尾，后面再跟实例应该派生自的类。
对于已经定义好的类型，单独的 `deriving` 也是可用的。
写 `deriving instance C1, C2, ... for T` 来为类型 `T` 派生 `C1, C2, ...` 实例。

<!--
`BEq` and `Hashable` instances can be derived for `Pos` and `NonEmptyList` using a very small amount of code:
-->

`Pos` 和 `NonEmptyList` 上的 `BEq` 和 `Hashable` 实例可以用很少量的代码派生出来：
```lean
{{#example_decl Examples/Classes.lean BEqHashableDerive}}
```

<!--
Instances can be derived for at least the following classes:
 * `Inhabited`
 * `BEq`
 * `Repr`
 * `Hashable`
 * `Ord`
-->

至少以下几种类型类的实例都是可以派生的：
 * `Inhabited`
 * `BEq`
 * `Repr`
 * `Hashable`
 * `Ord`

<!--
In some cases, however, the derived `Ord` instance may not produce precisely the ordering desired in an application.
When this is the case, it's fine to write an `Ord` instance by hand.
The collection of classes for which instances can be derived can be extended by advanced users of Lean.
-->

然而，有些时候 `Ord` 的派生实例可能不是你想要的。
当发生这种事情的时候，就手写一个 `Ord` 实例把。
你如果对自己的 Lean 水平足够有自信的话，你也可以自己添加可以派生实例的类型类。

<!--
Aside from the clear advantages in programmer productivity and code readability, deriving instances also makes code easier to maintain, because the instances are updated as the definitions of types evolve.
Changesets involving updates to datatypes are easier to read without line after line of formulaic modifications to equality tests and hash computation.
-->

实例派生除了在开发效率和代码可读性上有很大的优势外，它也使得代码更易于维护，因为实例会随着类型定义的变化而更新。
对数据类型的一系列更新更易于阅读，因为不需要一行又一行地对相等性测试和哈希计算进行公式化的修改。

## Appending { #appending }

<!--
Many datatypes have some sort of append operator.
In Lean, appending two values is overloaded with the type class `HAppend`, which is a heterogeneous operation like that used for arithmetic operations:
-->

许多数据类型都有某种形式的连接操作符。
在 Lean 中，连接两个值的操作被重载为类型类 `HAppend`，这是一个异质操作，与用于算术运算的操作类似：
```lean
{{#example_decl Examples/Classes.lean HAppend}}
```
<!--
The syntax `{{#example_in Examples/Classes.lean desugarHAppend}}` desugars to `{{#example_out Examples/Classes.lean desugarHAppend}}`.
For homogeneous cases, it's enough to implement an instance of `Append`, which follows the usual pattern:
-->

语法 `{{#example_in Examples/Classes.lean desugarHAppend}}` 会被脱糖为 `{{#example_out Examples/Classes.lean desugarHAppend}}`.
对于同质的情形，按照常规模式实现一个 `Append` 即可：
```lean
{{#example_decl Examples/Classes.lean AppendNEList}}
```

<!--
After defining the above instance,
-->

在定义了上面的实例后，
```lean
{{#example_in Examples/Classes.lean appendSpiders}}
```
<!--
has the following output:
-->

就有了下面的结果：
```output info
{{#example_out Examples/Classes.lean appendSpiders}}
```

<!--
Similarly, a definition of `HAppend` allows non-empty lists to be appended to ordinary lists:
-->

类似地：定义一个 `HAppend` 来使常规列表可以和一个非空列表连接。
```lean
{{#example_decl Examples/Classes.lean AppendNEListList}}
```
<!--
With this instance available,
-->

有了这个实例后，
```lean
{{#example_in Examples/Classes.lean appendSpidersList}}
```
<!--
results in
-->

结果为
```output info
{{#example_out Examples/Classes.lean appendSpidersList}}
```

<!--
## Functors
-->

## 函子 { #functors }

<!--
A polymorphic type is a _functor_ if it has an overload for a function named `map` that transforms every element contained in it by a function.
While most languages use this terminology, C#'s equivalent to `map` is called `System.Linq.Enumerable.Select`.
For example, mapping a function over a list constructs a new list in which each entry from the starting list has been replaced by the result of the function on that entry.
Mapping a function `f` over an `Option` leaves `none` untouched, and replaces `some x` with `some (f x)`.
-->

如果一个多态类型重载了一个函数 `map`，这个函数将位于上下文中的每个元素都用一个函数来映射，那么这个类型就是一个 **函子（functor）** 。
虽然大多数语言都使用这个术语，但C#中等价于 `map` 的是 `System.Linq.Enumerable.Select`。
例如，用一个函数对一个列表进行映射会产生一个新的列表，列表中的每个元素都是函数应用在原列表中元素的结果。
用函数 `f` 对一个 `Option` 进行映射，如果 `Option` 的值为 `none`，那么结果仍为 `none`；
如果为 `some x`，那么结果为 `some (f x)`。

<!--
Here are some examples of functors and how their `Functor` instances overload `map`:
 * `{{#example_in Examples/Classes.lean mapList}}` evaluates to `{{#example_out Examples/Classes.lean mapList}}`
 * `{{#example_in Examples/Classes.lean mapOption}}` evaluates to `{{#example_out Examples/Classes.lean mapOption}}`
 * `{{#example_in Examples/Classes.lean mapListList}}` evaluates to `{{#example_out Examples/Classes.lean mapListList}}`
-->

下面是一些函子，这些函子是如何重载 `map` 的例子：
 * `{{#example_in Examples/Classes.lean mapList}}` 结果为 `{{#example_out Examples/Classes.lean mapList}}`
 * `{{#example_in Examples/Classes.lean mapOption}}` 结果为 `{{#example_out Examples/Classes.lean mapOption}}`
 * `{{#example_in Examples/Classes.lean mapListList}}` 结果为 `{{#example_out Examples/Classes.lean mapListList}}`

<!--
Because `Functor.map` is a bit of a long name for this common operation, Lean also provides an infix operator for mapping a function, namely `<$>`.
The prior examples can be rewritten as follows:
 * `{{#example_in Examples/Classes.lean mapInfixList}}` evaluates to `{{#example_out Examples/Classes.lean mapInfixList}}`
 * `{{#example_in Examples/Classes.lean mapInfixOption}}` evaluates to `{{#example_out Examples/Classes.lean mapInfixOption}}`
 * `{{#example_in Examples/Classes.lean mapInfixListList}}` evaluates to `{{#example_out Examples/Classes.lean mapInfixListList}}`
-->

因为 `Functor.map` 这个操作很常用，但它的名字又有些长了，所以 Lean 也提供了一个中缀运算符来映射函数，叫做 `<$>`。
下面是一些简单的例子：
 * `{{#example_in Examples/Classes.lean mapInfixList}}` 结果为 `{{#example_out Examples/Classes.lean mapInfixList}}`
 * `{{#example_in Examples/Classes.lean mapInfixOption}}` 结果为 `{{#example_out Examples/Classes.lean mapInfixOption}}`
 * `{{#example_in Examples/Classes.lean mapInfixListList}}` 结果为 `{{#example_out Examples/Classes.lean mapInfixListList}}`

<!--
An instance of `Functor` for `NonEmptyList` requires specifying the `map` function.
-->

`Functor` 对于 `NonEmptyList` 的实例需要我们提供 `map` 函数。
```lean
{{#example_decl Examples/Classes.lean FunctorNonEmptyList}}
```
<!--
Here, `map` uses the `Functor` instance for `List` to map the function over the tail.
This instance is defined for `NonEmptyList` rather than for `NonEmptyList α` because the argument type `α` plays no role in resolving the type class.
A `NonEmptyList` can have a function mapped over it _no matter what the type of entries is_.
If `α` were a parameter to the class, then it would be possible to make versions of `Functor` that only worked for `NonEmptyList Nat`, but part of being a functor is that `map` works for any entry type.
-->

在这里，`map` 使用 `List` 上的 `Functor` 实例来将函数映射到列表尾。
这个实例是在 `NonEmptyList` 下定义的，而不是 `NonEmptyList α`。
因为类型参数 `α` 在当前类型类中用不上。
**无论条目的类型是什么** ，我们都可以用一个函数来映射 `NonEmptyList`。
如果 `α` 是类型类的一个参数，那么我们就可以做出只工作在某个 `α` 类型上的 `Functor`，比如 `NonEmptyList Nat`。
但成为一个函子类型的必要条件就是 `map` 对任意条目类型都是有效的。

<!--
Here is an instance of `Functor` for `PPoint`:
-->

这里有一个将 `PPoint` 实现为一个函子的实例：
```lean
{{#example_decl Examples/Classes.lean FunctorPPoint}}
```
<!--
In this case, `f` has been applied to both `x` and `y`.
-->

在这里，`f` 被应用到 `x` 和 `y` 上。

<!--
Even when the type contained in a functor is itself a functor, mapping a function only goes down one layer.
That is, when using `map` on a `NonEmptyList (PPoint Nat)`, the function being mapped should take `PPoint Nat` as its argument rather than `Nat`.
-->

即使包含在一个函子类型中的类型本身也是一个函子，映射一个函数也只会向下一层。
也就是说，当在 `NonEmptyList (PPoint Nat)` 上 `map` 时，被映射的函数会接受 `PPoint Nat` 作为参数，而不是 `Nat`。

<!--
The definition of the `Functor` class uses one more language feature that has not yet been discussed: default method definitions.
Normally, a class will specify some minimal set of overloadable operations that make sense together, and then use polymorphic functions with instance implicit arguments that build on the overloaded operations to provide a larger library of features.
For example, the function `concat` can concatenate any non-empty list whose entries are appendable:
-->

`Functor` 类型类的定义中用到了一个还没介绍的语言特性：默认方法定义。
正常来说，一个类型类会指定一些有意义的最小的可重载操作集合，然后使用具有隐式实例参数的多态函数，这些函数建立在重载操作的基础上，以提供更大的功能库。
例如，函数 `concat` 可以连接任何非空列表的条目，只要条目是可连接的：
```lean
{{#example_decl Examples/Classes.lean concat}}
```
<!--
However, for some classes, there are operations that can be more efficiently implemented with knowledge of the internals of a datatype.
-->

然而，对于一些类型类，如果你对数据类型的内部又更深的理解的话，那么就会有一些更高效的运算实现。

<!--
In these cases, a default method definition can be provided.
A default method definition provides a default implementation of a method in terms of the other methods.
However, instance implementors may choose to override this default with something more efficient.
Default method definitions contain `:=` in a `class` definition.
-->

在这些情况下，可以提供一个默认方法定义。
默认方法定义提供了一个基于其他方法的默认实现。
然而，实例实现者可以选择用更高效的方法来重写这个默认实现。
默认方法定义在 `class` 定义中，包含 `:=`。

<!--
In the case of `Functor`, some types have a more efficient way of implementing `map` when the function being mapped ignores its argument.
Functions that ignore their arguments are called _constant functions_ because they always return the same value.
Here is the definition of `Functor`, in which `mapConst` has a default implementation:
-->

对于 `Functor` 而言，当被映射的函数并不需要参数时，许多类型有更高效的 `map` 实现方式。
```lean
{{#example_decl Examples/Classes.lean FunctorDef}}
```

<!--
Just as a `Hashable` instance that doesn't respect `BEq` is buggy, a `Functor` instance that moves around the data as it maps the function is also buggy.
For example, a buggy `Functor` instance for `List` might throw away its argument and always return the empty list, or it might reverse the list.
A bad instance for `PPoint` might place `f x` in both the `x` and the `y` fields.
Specifically, `Functor` instances should follow two rules:
 1. Mapping the identity function should result in the original argument.
 2. Mapping two composed functions should have the same effect as composing their mapping.
-->

就像不符合 `BEq` 的 `Hashable` 实例是有问题的一样，一个在映射函数时移动数据的 `Functor` 实例也是有问题的。
例如，一个有问题的 `List` 的 `Functor` 实例可能会丢弃其参数并总是返回空列表，或者它可能会反转列表。
一个有问题的 `PPoint` 实例可能会将 `f x` 放在 `x` 和 `y` 字段中。
具体来说，`Functor` 实例应遵循两条规则：
 1. 映射恒等函数应返回原始参数。
 2. 映射两个复合函数应具有与它们的映射组合相同的效果。

<!--
More formally, the first rule says that `id <$> x` equals `x`.
The second rule says that `map (fun y => f (g y)) x` equals `map f (map g x)`.
The composition `{{#example_out Examples/Classes.lean compDef}}` can also be written `{{#example_in Examples/Classes.lean compDef}}`.
These rules prevent implementations of `map` that move the data around or delete some of it.
-->

更形式化的讲，第一个规则说 `id <$> x` 等于 `x`。
第二个规则说 `map (fun y => f (g y)) x` 等于 `map f (map g x)`。
`{{#example_out Examples/Classes.lean compDef}}` 也可以写成 `{{#example_in Examples/Classes.lean compDef}}`。
这些规则能防止 `map` 的实现移动数据或删除一些数据。

<!--
## Messages You May Meet
-->

## 你也许会遇到的问题 { #messages-you-may-meet }

<!--
Lean is not able to derive instances for all classes.
For example, the code
-->

Lean 不能为所有类派生实例。
例如代码
```lean
{{#example_in Examples/Classes.lean derivingNotFound}}
```
<!--
results in the following error:
-->

会导致如下错误：
```output error
{{#example_out Examples/Classes.lean derivingNotFound}}
```
<!--
Invoking `deriving instance` causes Lean to consult an internal table of code generators for type class instances.
If the code generator is found, then it is invoked on the provided type to create the instance.
This message, however, means that no code generator was found for `ToString`.
-->

调用 `deriving instance` 会使 Lean 查找一个类型类实例的内部代码生成器的表。
如果找到了代码生成器，那么就会调用它来创建实例。
然而这个报错就意味着没有发现对 `ToString` 的代码生成器。

<!--
## Exercises
-->

## 练习 { #exercises }

<!--
 * Write an instance of `HAppend (List α) (NonEmptyList α) (NonEmptyList α)` and test it.
 * Implement a `Functor` instance for the binary tree datatype.
-->

 * 写一个 `HAppend (List α) (NonEmptyList α) (NonEmptyList α)` 的实例并测试它
 * 为二叉树实现一个 `Functor` 的实例。