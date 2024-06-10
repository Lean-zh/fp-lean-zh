<!--
# Datatypes and Patterns
-->

# 数据类型与模式匹配

<!--
Structures enable multiple independent pieces of data to be combined into a coherent whole that is represented by a brand new type.
Types such as structures that group together a collection of values are called _product types_.
Many domain concepts, however, can't be naturally represented as structures.
For instance, an application might need to track user permissions, where some users are document owners, some may edit documents, and others may only read them.
A calculator has a number of binary operators, such as addition, subtraction, and multiplication.
Structures do not provide an easy way to encode multiple choices.
-->

结构体使多个独立的数据块可以组合成一个连贯的整体，该整体由一个全新的类型表示。
将一组值组合在一起的类型（如结构体）称为   **积类型（Product Type）** 。
然而，许多领域概念不能自然地表示为结构体。例如，应用程序可能需要跟踪用户权限，
其中一些用户是文档所有者，一些用户可以编辑文档，而另一些用户只能阅读文档。
计算器具有许多二元运算符，例如加法、减法和乘法。结构体无法提供一种简单的方法来编码多项选择。

<!--
Similarly, while a structure is an excellent way to keep track of a fixed set of fields, many applications require data that may contain an arbitrary number of elements.
Most classic data structures, such as trees and lists, have a recursive structure, where the tail of a list is itself a list, or where the left and right branches of a binary tree are themselves binary trees.
In the aforementioned calculator, the structure of expressions themselves is recursive.
The summands in an addition expression may themselves be multiplication expressions, for instance.
-->

同样，尽管结构体是跟踪固定字段集的绝佳方式，但许多应用程序需要可能包含任意数量元素的数据。
大多数经典数据结构体（例如树和列表）具有递归结构体，其中列表的尾部本身是一个列表，
或者二叉树的左右分支本身是二叉树。在上述计算器中，表达式本身的结构体是递归的。
例如，加法表达式中的加数本身可能是乘法表达式。

<!--
Datatypes that allow choices are called _sum types_ and datatypes that can include instances of themselves are called _recursive datatypes_.
Recursive sum types are called _inductive datatypes_, because mathematical induction may be used to prove statements about them.
When programming, inductive datatypes are consumed through pattern matching and recursive functions.
-->

允许选择的类型称为  **和类型（Sum Type）** ，而可以包含自身实例的类型称为
  **递归类型（Recursive Datatype）** 。递归和类型称  **归纳类型（Inductive Datatype）** ，
因为可以用数学归纳法来证明有关它们的陈述。在编程时，归纳类型通过模式匹配和递归函数来消耗。

<!--
Many of the built-in types are actually inductive datatypes in the standard library.
For instance, `Bool` is an inductive datatype:
-->

许多内置类型实际上是标准库中的归纳类型。例如，`Bool` 就是一个归纳类型：

```lean
{{#example_decl Examples/Intro.lean Bool}}
```

<!--
This definition has two main parts.
The first line provides the name of the new type (`Bool`), while the remaining lines each describe a constructor.
As with constructors of structures, constructors of inductive datatypes are mere inert receivers of and containers for other data, rather than places to insert arbitrary initialization and validation code.
Unlike structures, inductive datatypes may have multiple constructors.
Here, there are two constructors, `true` and `false`, and neither takes any arguments.
Just as a structure declaration places its names in a namespace named after the declared type, an inductive datatype places the names of its constructors in a namespace.
In the Lean standard library, `true` and `false` are re-exported from this namespace so that they can be written alone, rather than as `Bool.true` and `Bool.false`, respectively.
-->

此定义有两个主要部分。第一行提供了新类型（`Bool`）的名称，而其余各行分别描述了一个构造函数。
与结构体的构造函数一样，归纳类型的构造函数只是其他数据的接收器和容器，
而不是插入任意初始化代码和验证代码的地方。与结构体不同，归纳类型可以有多个构造函数。
这里有两个构造函数，`true` 和 `false`，并且都不接受任何参数。
就像结构体声明将其名称放在以声明类型命名的命名空间中一样，归纳类型将构造函数的名称放在命名空间中。
在 Lean 标准库中，`true` 和 `false` 从此命名空间重新导出，以便可以单独编写它们，
而不是分别作为 `Bool.true` 和 `Bool.false`。

<!--
From a data modeling perspective, inductive datatypes are used in many of the same contexts where a sealed abstract class might be used in other languages.
In languages like C# or Java, one might write a similar definition of `Bool`:
-->

从数据建模的角度来看，归纳数据类型在许多与其他语言中可能使用密封抽象类相同的上下文中使用。
在 C# 或 Java 等语言中，人们可能会编写类似的 `Bool` 定义：

```C#
abstract class Bool {}
class True : Bool {}
class False : Bool {}
```

<!--
However, the specifics of these representations are fairly different. In particular, each non-abstract class creates both a new type and new ways of allocating data. In the object-oriented example, `True` and `False` are both types that are more specific than `Bool`, while the Lean definition introduces only the new type `Bool`.
-->

然而，这些表示的具体内容有很大不同。特别是，每个非抽象类都会创建一种新类型和分配数据的新方式。
在面向对象示例中，`True` 和 `False` 都是比 `Bool` 更具体的类型，而 Lean 定义仅引入了新类型 `Bool`。

<!--
The type `Nat` of non-negative integers is an inductive datatype:
-->

非负整数的类型 `Nat` 是一个归纳数据类型：

```lean
{{#example_decl Examples/Intro.lean Nat}}
```

<!--
Here, `zero` represents 0, while `succ` represents the successor of some other number.
The `Nat` mentioned in `succ`'s declaration is the very type `Nat` that is in the process of being defined.
_Successor_ means "one greater than", so the successor of five is six and the successor of 32,185 is 32,186.
Using this definition, `{{#example_eval Examples/Intro.lean four 1}}` is represented as `{{#example_eval Examples/Intro.lean four 0}}`.
This definition is almost like the definition of `Bool` with slightly different names.
The only real difference is that `succ` is followed by `(n : Nat)`, which specifies that the constructor `succ` takes an argument of type `Nat` which happens to be named `n`.
The names `zero` and `succ` are in a namespace named after their type, so they must be referred to as `Nat.zero` and `Nat.succ`, respectively.
-->

在这里，`zero` 表示 0，而 `succ` 表示errt数字的后继。`succ` 声明中提到的 `Nat`
正是我们正在定义的类型 `Nat`。  **后继（Successor）** 表示「比...大一」，因此 5 的后继是 6，
32,185 的后继是 32,186。使用此定义，`4` 表示为 `Nat.succ (Nat.succ (Nat.succ (Nat.succ Nat.zero)))`。
这个定义与 `Bool` 的定义非常类似，只是名称略有不同。唯一真正的区别是 `succ` 后面跟着
`(n : Nat)`，它指定构造函数 `succ` 接受类型为 `Nat` 的参数，该参数恰好命名为 `n`。
名称 `zero` 和 `succ` 位于以其类型命名的命名空间中，因此它们分别必须称为 `Nat.zero` 和 `Nat.succ`。

<!--
Argument names, such as `n`, may occur in Lean's error messages and in feedback provided when writing mathematical proofs.
Lean also has an optional syntax for providing arguments by name.
Generally, however, the choice of argument name is less important than the choice of a structure field name, as it does not form as large a part of the API.
-->

参数名称（如 `n`）可能出现在 Lean 的错误消息以及编写数学证明时提供的反馈中。
Lean 还具有按名称提供参数的可选语法。然而，通常情况下，
参数名的选择不如结构体字段名的选择重要，因为它不构成 API 的主要部分。

<!--
In C# or Java, `Nat` could be defined as follows:
-->

在 C# 或 Java 中，`Nat` 的定义如下：

```C#
abstract class Nat {}
class Zero : Nat {}
class Succ : Nat {
  public Nat n;
  public Succ(Nat pred) {
    n = pred;
  }
}
```

<!--
Just as in the `Bool` example above, this defines more types than the Lean equivalent.
Additionally, this example highlights how Lean datatype constructors are much more like subclasses of an abstract class than they are like constructors in C# or Java, as the constructor shown here contains initialization code to be executed.
-->

与上面 `Bool` 的示例类似，这样会定义比 Lean 中等价的项更多的类型。
此外，该示例突出显示了 Lean 数据类型构造子更像是抽象类的子类，而不是像
C# 或 Java 中的构造子，因为此处显示的构造子包含要执行的初始化代码。

<!--
Sum types are also similar to using a string tag to encode discriminated unions in TypeScript.
In TypeScript, `Nat` could be defined as follows:
-->

和类型也类似于使用字符串标签来对 TypeScript 中的不交并进行编码。
在 TypeScript 中，`Nat` 可以定义如下：

```typescript
interface Zero {
    tag: "zero";
}

interface Succ {
    tag: "succ";
    predecessor: Nat;
}

type Nat = Zero | Succ;
```

<!--
Just like C# and Java, this encoding ends up with more types than in Lean, because `Zero` and `Succ` are each a type on their own.
It also illustrates that Lean constructors correspond to objects in JavaScript or TypeScript that include a tag that identifies the contents.
-->

与 C# 和 Java 一样，这种编码最终会产生比 Lean 中更多的类型，因为 `Zero` 和 `Succ`
都是它们自己的类型。它还说明了 Lean 构造函数对应于 JavaScript 或 TypeScript 中的对象，
这些对象包含一个标识内容的标记。

<!--
## Pattern Matching
-->

## 模式匹配

<!--
In many languages, these kinds of data are consumed by first using an instance-of operator to check which subclass has been received and then reading the values of the fields that are available in the given subclass.
The instance-of check determines which code to run, ensuring that the data needed by this code is available, while the fields themselves provide the data.
In Lean, both of these purposes are simultaneously served by _pattern matching_.
-->

在很多语言中，这类数据首先使用 instance-of 运算符来检查接收了哪个子类，
然后读取给定子类中可用的字段值。instance-of 会检查确定要运行哪个代码，
以确保此代码所需的数据可用，而数据由字段本身提供。
在 Lean 中，这两个目的均由  **模式匹配（Pattern Matching）** 实现。

<!--
An example of a function that uses pattern matching is `isZero`, which is a function that returns `true` when its argument is `Nat.zero`, or false otherwise.
-->

使用模式匹配的函数示例是 `isZero`，这是一个当其参数为 `Nat.zero`
时返回 `true` 的函数，否则返回 `false`。

```lean
{{#example_decl Examples/Intro.lean isZero}}
```

<!--
The `match` expression is provided the function's argument `n` for destructuring.
If `n` was constructed by `Nat.zero`, then the first branch of the pattern match is taken, and the result is `true`.
If `n` was constructed by `Nat.succ`, then the second branch is taken, and the result is `false`.
-->

`match` 表达式为函数参数 `n` 提供了解构。若 `n` 由 `Nat.zero` 构建，
则采用模式匹配的第一分支，结果为 `true`。若 `n` 由 `Nat.succ` 构建，
则采用第二分支，结果为 `false`。

<!--
Step-by-step, evaluation of `{{#example_eval Examples/Intro.lean isZeroZeroSteps 0}}` proceeds as follows:
-->

`{{#example_eval Examples/Intro.lean isZeroZeroSteps 0}}` 的逐步求值过程如下：

```lean
{{#example_eval Examples/Intro.lean isZeroZeroSteps}}
```

<!--
Evaluation of `{{#example_eval Examples/Intro.lean isZeroFiveSteps 0}}` proceeds similarly:
-->

`{{#example_eval Examples/Intro.lean isZeroFiveSteps 0}}` 的求值过程类似：

```lean
{{#example_eval Examples/Intro.lean isZeroFiveSteps}}
```

<!--
The `k` in the second branch of the pattern in `isZero` is not decorative.
It makes the `Nat` that is the argument to `succ` visible, with the provided name.
That smaller number can then be used to compute the final result of the expression.
-->

`isZero` 中模式的第二分支中的 `k` 并非装饰性符号。它使 `succ` 的参数 `Nat`
可见，并提供了名称。然后可以使用该较小的数字计算表达式的最终结果。

<!--
Just as the successor of some number \\( n \\) is one greater than \\( n \\) (that is, \\( n + 1\\)), the predecessor of a number is one less than it.
If `pred` is a function that finds the predecessor of a `Nat`, then it should be the case that the following examples find the expected result:
-->

正如某个数字 \\( n \\) 的后继比 \\( n \\) 大 1（即 \\( n + 1\\)），
某个数字的前驱比它小 1。如果 `pred` 是一个查找 `Nat` 前驱的函数，
那么以下示例应该找到预期的结果：

```lean
{{#example_in Examples/Intro.lean predFive}}
```

```output info
{{#example_out Examples/Intro.lean predFive}}
```

```lean
{{#example_in Examples/Intro.lean predBig}}
```

```output info
{{#example_out Examples/Intro.lean predBig}}
```

<!--
Because `Nat` cannot represent negative numbers, `0` is a bit of a conundrum.
Usually, when working with `Nat`, operators that would ordinarily produce a negative number are redefined to produce `0` itself:
-->

由于 `Nat` 无法表示负数，因此 `0` 有点令人费解。在使用 `Nat` 时，
会产生负数的运算符通常会被重新定义为产生 `0` 本身：

```lean
{{#example_in Examples/Intro.lean predZero}}
```

```output info
{{#example_out Examples/Intro.lean predZero}}
```

<!--
To find the predecessor of a `Nat`, the first step is to check which constructor was used to create it.
If it was `Nat.zero`, then the result is `Nat.zero`.
If it was `Nat.succ`, then the name `k` is used to refer to the `Nat` underneath it.
And this `Nat` is the desired predecessor, so the result of the `Nat.succ` branch is `k`.
-->

要查找 `Nat` 的前驱，第一步是检查使用哪个构造子创建它。如果是 `Nat.zero`，则结果为 `Nat.zero`。
如果是 `Nat.succ`，则使用名称 `k` 引用其下的 `Nat`。而这个 `Nat` 是所需的前驱，因此
`Nat.succ` 分支的结果是 `k`。

```lean
{{#example_decl Examples/Intro.lean pred}}
```

<!--
Applying this function to `5` yields the following steps:
-->

将此函数应用于 `5` 会产生以下步骤：

```lean
{{#example_eval Examples/Intro.lean predFiveSteps}}
```

<!--
Pattern matching can be used with structures as well as with sum types.
For instance, a function that extracts the third dimension from a `Point3D` can be written as follows:
-->

模式匹配不仅可用于和类型，还可用于结构体。
例如，一个从 `Point3D` 中提取第三维度的函数可以写成如下：

```lean
{{#example_decl Examples/Intro.lean depth}}
```

<!--
In this case, it would have been much simpler to just use the `z` accessor, but structure patterns are occasionally the simplest way to write a function.
-->

在这种情况下，直接使用 `z` 访问器会简单得多，但结构体模式有时是编写函数的最简单方法。

<!--
## Recursive Functions
-->

## 递归函数

<!--
Definitions that refer to the name being defined are called _recursive definitions_.
Inductive datatypes are allowed to be recursive; indeed, `Nat` is an example of such a datatype because `succ` demands another `Nat`.
Recursive datatypes can represent arbitrarily large data, limited only by technical factors like available memory.
Just as it would be impossible to write down one constructor for each natural number in the datatype definition, it is also impossible to write down a pattern match case for each possibility.
-->

引用正在定义的名称的定义称为  **递归定义（Recursive Definition）** 。
归纳数据类型允许是递归的；事实上，`Nat` 就是这样的数据类型的一个例子，
因为 `succ` 需要另一个 `Nat`。递归数据类型可以表示任意大的数据，仅受可用内存等技术因素限制。
就像不可能在数据类型定义中为每个自然数编写一个构造器一样，也不可能为每个可能性编写一个模式匹配用例。

<!--
Recursive datatypes are nicely complemented by recursive functions.
A simple recursive function over `Nat` checks whether its argument is even.
In this case, `zero` is even.
Non-recursive branches of the code like this one are called _base cases_.
The successor of an odd number is even, and the successor of an even number is odd.
This means that a number built with `succ` is even if and only if its argument is not even.
-->

递归数据类型与递归函数很好地互补。一个简单的 `Nat` 递归函数检查其参数是否是偶数。
在这种情况下，`zero` 是偶数。像这样的代码的非递归分支称为  **基本情况（Base Case）** 。
奇数的后继是偶数，偶数的后继是奇数。这意味着使用 `succ` 构建的数字当且仅当其参数不是偶数时才是偶数。

```lean
{{#example_decl Examples/Intro.lean even}}
```

<!--
This pattern of thought is typical for writing recursive functions on `Nat`.
First, identify what to do for `zero`.
Then, determine how to transform a result for an arbitrary `Nat` into a result for its successor, and apply this transformation to the result of the recursive call.
This pattern is called _structural recursion_.
-->

这种思维模式对于在 `Nat` 上编写递归函数是典型的。首先，确定对 `zero` 做什么。
然后，确定如何将任意 `Nat` 的结果转换为其后继的结果，并将此转换应用于递归调用的结果。
此模式称为  **结构化递归（Structural Recursion）** 。

<!--
Unlike many languages, Lean ensures by default that every recursive function will eventually reach a base case.
From a programming perspective, this rules out accidental infinite loops.
But this feature is especially important when proving theorems, where infinite loops cause major difficulties.
A consequence of this is that Lean will not accept a version of `even` that attempts to invoke itself recursively on the original number:
-->

不同于许多语言，Lean 默认确保每个递归函数最终都会到达基本情况。
从编程角度来看，这排除了意外的无限循环。但此特性在证明定理时尤为重要，
而无限循环会产生主要困难。由此产生的一个后果是，
Lean 不会接受尝试对原始数字递归调用自身的 `even` 版本：

```lean
{{#example_in Examples/Intro.lean evenLoops}}
```

<!--
The important part of the error message is that Lean could not determine that the recursive function always reaches a base case (because it doesn't).
-->

错误消息的主要部分是 Lean 无法确定递归函数是否最终会到达基本情况（因为它不会）。

```output error
{{#example_out Examples/Intro.lean evenLoops}}
```

<!--
Even though addition takes two arguments, only one of them needs to be inspected.
To add zero to a number \\( n \\), just return \\( n \\).
To add the successor of \\( k \\) to \\( n \\), take the successor of the result of adding \\( k \\) to \\( n \\).
-->

尽管加法需要两个参数，但只需要检查其中一个参数。要将零加到数字 \\( n \\) 上，
只需返回 \\( n \\)。要将 \\( k \\) 的后继加到 \\( n \\) 上，则需要得到将 \\( k \\)
加到 \\( n \\) 的结果的后继。

```lean
{{#example_decl Examples/Intro.lean plus}}
```

<!--
In the definition of `plus`, the name `k'` is chosen to indicate that it is connected to, but not identical with, the argument `k`.
For instance, walking through the evaluation of `{{#example_eval Examples/Intro.lean plusThreeTwo 0}}` yields the following steps:
-->

在 `plus` 的定义中，选择名称 `k'` 表示它与参数 `k` 相关联，但并不相同。
例如，展开 `{{#example_eval Examples/Intro.lean plusThreeTwo 0}}` 的求值过程会产生以下步骤：

```lean
{{#example_eval Examples/Intro.lean plusThreeTwo}}
```

<!--
One way to think about addition is that \\( n + k \\) applies `Nat.succ` \\( k \\) times to \\( n \\).
Similarly, multiplication \\( n × k \\) adds \\( n \\) to itself \\( k \\) times and subtraction \\( n - k \\) takes \\( n \\)'s predecessor \\( k \\) times.
-->

考虑加法的一种方法是 \\( n + k \\) 将 `Nat.succ` 应用于 \\( n \\) \\( k \\) 次。
类似地，乘法 \\( n × k \\) 将 \\( n \\) 加到自身 \\( k \\) 次，而减法
\\( n - k \\) 将 \\( n \\) 的前驱减去 \\( k \\) 次。

```lean
{{#example_decl Examples/Intro.lean times}}

{{#example_decl Examples/Intro.lean minus}}
```

<!--
Not every function can be easily written using structural recursion.
The understanding of addition as iterated `Nat.succ`, multiplication as iterated addition, and subtraction as iterated predecessor suggests an implementation of division as iterated subtraction.
In this case, if the numerator is less than the divisor, the result is zero.
Otherwise, the result is the successor of dividing the numerator minus the divisor by the divisor.
-->

并非每个函数都可以轻松地使用结构体递归来编写。将加法理解为迭代的 `Nat.succ`，
将乘法理解为迭代的加法，将减法理解为迭代的前驱，这表明除法可以实现为迭代的减法。
在这种情况下，如果分子小于分母，则结果为零。否则，结果是将分子减去分母除以分母的后继。

```lean
{{#example_in Examples/Intro.lean div}}
```

<!--
As long as the second argument is not `0`, this program terminates, as it always makes progress towards the base case.
However, it is not structurally recursive, because it doesn't follow the pattern of finding a result for zero and transforming a result for a smaller `Nat` into a result for its successor.
In particular, the recursive invocation of the function is applied to the result of another function call, rather than to an input constructor's argument.
Thus, Lean rejects it with the following message:
-->

只要第二个参数不为 `0`，这个程序就会终止，因为它始终朝着基本情况前进。然而，它不是结构化递归，
因为它不遵循「为零找到一个结果，然后将较小的 `Nat` 的结果转换为其后继的结果」的模式。
特别是，该函数的递归调用，应用于另一个函数调用的结果，而非输入构造子的参数。
因此，Lean 会拒绝它，并显示以下消息：

```output error
{{#example_out Examples/Intro.lean div}}
```

<!--
This message means that `div` requires a manual proof of termination.
This topic is explored in [the final chapter](../programs-proofs/inequalities.md#division-as-iterated-subtraction).
-->

此消息表示 `div` 需要手动证明停机。这个主题在
[最后一章](../programs-proofs/inequalities.md#division-as-iterated-subtraction)
中进行了探讨。
