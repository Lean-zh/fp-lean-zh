<!-- 
# Indexed Families
-->

# 索引族

<!--
Polymorphic inductive types take type arguments.
For instance, `List` takes an argument that determines the type of the entries in the list, and `Except` takes arguments that determine the types of the exceptions or values.
These type arguments, which are the same in every constructor of the datatype, are referred to as _parameters_.
-->

多态归纳类型接受类型参数。
例如，`List` 接受一个类型参数以决定列表中条目的类型，而 `Except` 接受两个类型参数以决定异常或值的类型。
这些在数据类型的每个构造子中都一致的类型参数，被称为 **参量（parameters)**。

<!--
Arguments to inductive types need not be the same in every constructor, however.
Inductive types in which the arguments to the type vary based on the choice of constructor are called _indexed families_, and the arguments that vary are referred to as _indices_.
The "hello world" of indexed families is a type of lists that contains the length of the list in addition to the type of entries, conventionally referred to as "vectors":
-->

然而，归纳类型中每个构造子的接受的类型参数并不一定要相同。这种不同构造子可以接受不同类型作为参数的归纳类型被称为 **索引族（indexed families)**，而这些不同的参数被称为 **索引（indices)**。
索引族最为人熟知的例子是**向量（vectors)**类型：这个类型类似列表类型，但它除了包含列表中元素的类型，还包含列表的长度。这种类型在 Lean 中的定义如下：

```lean
{{#example_decl Examples/DependentTypes.lean Vect}}
```

<!--
Function declarations may take some arguments before the colon, indicating that they are available in the entire definition, and some arguments after, indicating a desire to pattern-match on them and define the function case by case.
Inductive datatypes have a similar principle: the argument `α` is named at the top of the datatype declaration, prior to the colon, which indicates that it is a parameter that must be provided as the first argument in all occurrences of `Vect` in the definition, while the `Nat` argument occurs after the colon, indicating that it is an index that may vary.
Indeed, the three occurrences of `Vect` in the `nil` and `cons` constructor declarations consistently provide `α` as the first argument, while the second argument is different in each case.
-->

函数声明可以在冒号之前接受一些参数，表示这些参数在整个定义中都是可用的，也可以在冒号之后接受一些参数，函数会对它们进行模式匹配，并根据不同情形定义不同的函数体。
归纳数据类型也有类似的原则：以 `Vect` 为例，在其顶部的数据类型声明中，参数 `α` 出现在冒号之前，表示它是一个必须提供的参量，而在冒号之后出现的 `Nat` 参数表示它是一个索引，（在不同的构造子中）可以变化。
事实上，在 `nil` 和 `cons` 构造子的声明中，三个出现 `Vect` 的地方都将 `α` 作为第一个参数提供，而第二个参数在每种情形下都不同。

<!-- 
The declaration of `nil` states that it is a constructor of type `Vect α 0`.
This means that using `Vect.nil` in a context expecting a `Vect String 3` is a type error, just as `[1, 2, 3]` is a type error in a context that expects a `List String`: 
-->

`nil` 构造子的声明表明它的类型是 `Vect α 0`。
这意味着在期望 `Vect String 3` 的上下文中使用 `Vect.nil` 会导致类型错误，就像在期望 `List String` 的上下文中使用 `[1, 2, 3]` 一样：


```lean
{{#example_in Examples/DependentTypes.lean nilNotLengthThree}}
```
```output error
{{#example_out Examples/DependentTypes.lean nilNotLengthThree}}
```

<!--
The mismatch between `0` and `3` in this example plays exactly the same role as any other type mismatch, even though `0` and `3` are not themselves types. 
-->

在这个例子中，`0` 和 `3` 之间的不匹配和其他例子中类型的不匹配是一模一样的情况，尽管 `0` 和 `3` 本身并不是类型。

<!-- 
Indexed families are called _families_ of types because different index values can make different constructors available for use.
In some sense, an indexed family is not a type; rather, it is a collection of related types, and the choice of index values also chooses a type from the collection.
Choosing the index `5` for `Vect` means that only the constructor `cons` is available, and choosing the index `0` means that only `nil` is available. 
-->

类型族被称为 **族（families)**，因为不同的索引值意味着可以使用的构造子不同。
在某种意义上，一个索引族并不是一个类型；它更像是一组相关的类型的集合，不同索引的值对应了这个集合中的一个类型。
选择索引 `5` 作为 `Vect` 的索引意味着只有 `cons` 构造子可用，而选择索引 `0` 意味着只有 `nil` 构造子可用。

<!-- 
If the index is not yet known (e.g. because it is a variable), then no constructor can be used until it becomes known.
Using `n` for the length allows neither `Vect.nil` nor `Vect.cons`, because there's no way to know whether the variable `n` should stand for a `Nat` that matches `0` or `n + 1`: 
-->

如果索引是一个未知的量（例如，一个变量），那么在它变得已知之前，任何构造子都不能被使用。
如果一个 `Vect` 的长度为 `n`，那么 `Vect.nil` 和 `Vect.cons` 都无法被用来构造这个类型，因为无法知道变量 `n` 作为一个 `Nat` 应该匹配 `0` 或 `n + 1`：

```lean
{{#example_in Examples/DependentTypes.lean nilNotLengthN}}
```
```output error
{{#example_out Examples/DependentTypes.lean nilNotLengthN}}
```
```lean
{{#example_in Examples/DependentTypes.lean consNotLengthN}}
```
```output error
{{#example_out Examples/DependentTypes.lean consNotLengthN}}
```

<!-- 
Having the length of the list as part of its type means that the type becomes more informative.
For example, `Vect.replicate` is a function that creates a `Vect` with a number of copies of a given value.
The type that says this precisely is: 
-->

让列表的长度作为类型的一部分意味着类型具有更多的信息。
例如 `Vect.replicate` 是一个创建包含某个值（`x`）的特定份数 (`n`) 副本的 `Vect` 的函数。
可以精确地表示这一点的类型是：
```lean
{{#example_in Examples/DependentTypes.lean replicateStart}}
```

<!--
The argument `n` appears as the length of the result.
The message associated with the underscore placeholder describes the task at hand:
-->

参数 `n` 出现在结果的类型的长度中。
以下消息描述了下划线占位符对应的任务：
```output error
{{#example_out Examples/DependentTypes.lean replicateStart}}
```

<!--
When working with indexed families, constructors can only be applied when Lean can see that the constructor's index matches the index in the expected type.
However, neither constructor has an index that matches `n`—`nil` matches `Nat.zero`, and `cons` matches `Nat.succ`.
Just as in the example type errors, the variable `n` could stand for either, depending on which `Nat` is provided to the function as an argument.
The solution is to use pattern matching to consider both of the possible cases:
-->

当编写使用索引族的程序时时，只有当 Lean 能够确定构造子的索引与期望类型中的索引匹配时，才能使用该构造子。
然而，两个构造子的索引与 `n` 均不匹配——`nil` 匹配 `Nat.zero`，而 `cons` 匹配 `Nat.succ`。
就像在上面的类型错误示例中的情况一样，变量 `n` 可能代表其中一个，取决于具体调用函数时 `Nat` 参数的值。
解决这一问题的方案是利用模式匹配来同时考虑两种情形：

```lean
{{#example_in Examples/DependentTypes.lean replicateMatchOne}}
```

<!--
Because `n` occurs in the expected type, pattern matching on `n` _refines_ the expected type in the two cases of the match.
In the first underscore, the expected type has become `Vect α 0`:
-->

因为 `n` 出现在期望的类型中，对 `n` 进行模式匹配会在匹配的两种情形下 **细化（refine)** 期望的类型。
在第一个下划线中，期望的类型变成了 `Vect α 0`：
```output error
{{#example_out Examples/DependentTypes.lean replicateMatchOne}}
```

<!--
In the second underscore, it has become `Vect α (k + 1)`:
-->

在第二个下划线中，它变成了 `Vect α (k + 1)`：

```output error
{{#example_out Examples/DependentTypes.lean replicateMatchTwo}}
```

<!--
When pattern matching refines the type of a program in addition to discovering the structure of a value, it is called _dependent pattern matching_.
-->

当模式匹配不仅发现值的结构，还细化程序的类型时，这种模式匹配被称为 **依值模式匹配（dependent pattern matching)**。

<!--
The refined type makes it possible to apply the constructors.
The first underscore matches `Vect.nil`, and the second matches `Vect.cons`: 
-->

细化后的类型允许我们使用对应的构造子。
第一个下划线匹配 `Vect.nil`，而第二个下划线匹配 `Vect.cons`：

```lean
{{#example_in Examples/DependentTypes.lean replicateMatchFour}}
```
<!--
The first underscore under the `.cons` should have type `α`.
There is an `α` available, namely `x`:
-->

`.cons` 下的第一个下划线应该是一个具有类型 `α` 的值。
恰好我们有这么一个值：`x`。

```output error
{{#example_out Examples/DependentTypes.lean replicateMatchFour}}
```

<!--
The second underscore should be a `Vect α k`, which can be produced by a recursive call to `replicate`:
-->

第二个下划线应该是一个具有类型 `Vect α k` 的值。这个值可以通过对 `replicate` 的递归调用产生：

```output error
{{#example_out Examples/DependentTypes.lean replicateMatchFive}}
```

<!--
Here is the final definition of `replicate`:
-->

下面是 `replicate` 的最终定义：
```lean
{{#example_decl Examples/DependentTypes.lean replicate}}
```

<!--
In addition to providing assistance while writing the function, the informative type of `Vect.replicate` also allows client code to rule out a number of unexpected functions without having to read the source code.
A version of `replicate` for lists could produce a list of the wrong length: 
-->

除了在编写函数时提供帮助之外，`Vect.replicate` 的类型信息还允许调用方不必阅读源代码就明白它一定不是某些错误的实现。
一个可能会产生错误长度的列表的 `replicate` 实现如下：

```lean
{{#example_decl Examples/DependentTypes.lean listReplicate}}
```

<!--
However, making this mistake with `Vect.replicate` is a type error: 
-->

然而，在实现 `Vect.replicate` 时犯下同样的错误会引发一个类型错误：

```lean
{{#example_in Examples/DependentTypes.lean replicateOops}}
```
```output error
{{#example_out Examples/DependentTypes.lean replicateOops}}
```

<!--
The function `List.zip` combines two lists by pairing the first entry in the first list with the first entry in the second list, the second entry in the first list with the second entry in the second list, and so forth.
`List.zip` can be used to pair the three highest peaks in the US state of Oregon with the three highest peaks in Denmark: 
-->

`List.zip` 函数通过将两个列表中对应的项配对（第一个列表中的第一项和第二个列表的第一项，第一个列表中的第二项和第二个列表的第二项, ……）来合并两个列表。
这个函数可以用来将一个包含美国俄勒冈州前三座最高峰的列表和一个包含丹麦前三座最高峰的列表合并：

```lean
{{#example_in Examples/DependentTypes.lean zip1}}
```
The result is a list of three pairs:
```lean
{{#example_out Examples/DependentTypes.lean zip1}}
```

<!--
It's somewhat unclear what should happen when the lists have different lengths.
Like many languages, Lean chooses to ignore the extra entries in one of the lists.
For instance, combining the heights of the five highest peaks in Oregon with those of the three highest peaks in Denmark yields three pairs.
In particular, 
-->

当列表的长度不同时，结果应该如何呢？
与许多其他语言一样，Lean 选择忽略长的列表中的额外条目。
例如，将一个具有俄勒冈州前五座最高峰的高度的列表与一个具有丹麦前三座最高峰的高度的列表合并会产生一个含有三个有序对的列表。
```lean
{{#example_in Examples/DependentTypes.lean zip2}}
```

<!--
evaluates to
-->

求值结果为
```lean
{{#example_out Examples/DependentTypes.lean zip2}}
```

<!--
While this approach is convenient because it always returns an answer, it runs the risk of throwing away data when the lists unintentionally have different lengths.
F# takes a different approach: its version of `List.zip` throws an exception when the lengths don't match, as can be seen in this `fsi` session:
-->

这个函数总是返回一个结果，所以它非常易用。但当输入的两个列表意外地具有不同的长度时，一些数据会被悄悄地丢弃。
F# 采用了不同的方法：它的 `List.zip` 函数在两个列表长度不匹配时抛出异常，如下面 `fsi` 会话中展示的那样：
```fsharp
> List.zip [3428.8; 3201.0; 3158.5; 3075.0; 3064.0] [170.86; 170.77; 170.35];;
```
```output error
System.ArgumentException: The lists had different lengths.
list2 is 2 elements shorter than list1 (Parameter 'list2')
   at Microsoft.FSharp.Core.DetailedExceptions.invalidArgDifferentListLength[?](String arg1, String arg2, Int32 diff) in /builddir/build/BUILD/dotnet-v3.1.424-SDK/src/fsharp.3ef6f0b514198c0bfa6c2c09fefe41a740b024d5/src/fsharp/FSharp.Core/local.fs:line 24
   at Microsoft.FSharp.Primitives.Basics.List.zipToFreshConsTail[a,b](FSharpList`1 cons, FSharpList`1 xs1, FSharpList`1 xs2) in /builddir/build/BUILD/dotnet-v3.1.424-SDK/src/fsharp.3ef6f0b514198c0bfa6c2c09fefe41a740b024d5/src/fsharp/FSharp.Core/local.fs:line 918
   at Microsoft.FSharp.Primitives.Basics.List.zip[T1,T2](FSharpList`1 xs1, FSharpList`1 xs2) in /builddir/build/BUILD/dotnet-v3.1.424-SDK/src/fsharp.3ef6f0b514198c0bfa6c2c09fefe41a740b024d5/src/fsharp/FSharp.Core/local.fs:line 929
   at Microsoft.FSharp.Collections.ListModule.Zip[T1,T2](FSharpList`1 list1, FSharpList`1 list2) in /builddir/build/BUILD/dotnet-v3.1.424-SDK/src/fsharp.3ef6f0b514198c0bfa6c2c09fefe41a740b024d5/src/fsharp/FSharp.Core/list.fs:line 466
   at <StartupCode$FSI_0006>.$FSI_0006.main@()
Stopped due to error
```

<!--
This avoids accidentally discarding information, but crashing a program comes with its own difficulties.
The Lean equivalent, which would use the `Option` or `Except` monads, would introduce a burden that may not be worth the safety.
-->

这种方法避免了数据的意外丢失，但一个输入不正确时直接崩溃的程序并不容易使用。
在 Lean 中相似的实现可以在返回值中使用 `Option` 或 `Except` 单子，但是为了避免（可能不大的）数据丢失的风险而引入额外的（操作单子的）编程负担又并不太值得。

<!--
Using `Vect`, however, it is possible to write a version of `zip` with a type that requires that both arguments have the same length:
-->

然而，如果使用 `Vect`，可以一个 `zip` 函数，其类型要求两个输入的列表一定具有相同的长度，如下所示：
```lean
{{#example_decl Examples/DependentTypes.lean VectZip}}
```
<!--
This definition only has patterns for the cases where either both arguments are `Vect.nil` or both arguments are `Vect.cons`, and Lean accepts the definition without a "missing cases" error like the one that results from a similar definition for `List`:
-->

这个定义只需要考虑两个参数都是 `Vect.nil` 或都是 `Vect.cons` 的情形。Lean 接受这个定义，而不会像 `List` 的类似定义那样产生一个“存在缺失情形”的错误：
```lean
{{#example_in Examples/DependentTypes.lean zipMissing}}
```
```output error
{{#example_out Examples/DependentTypes.lean zipMissing}}
```

<!--
This is because the constructor used in the first pattern, `nil` or `cons`, _refines_ the type checker's knowledge about the length `n`.
When the first pattern is `nil`, the type checker can additionally determine that the length was `0`, so the only possible choice for the second pattern is `nil`.
Similarly, when the first pattern is `cons`, the type checker can determine that the length was `k+1` for some `Nat` `k`, so the only possible choice for the second pattern is `cons`.
Indeed, adding a case that uses `nil` and `cons` together is a type error, because the lengths don't match:
-->

这是因为第一个模式匹配中得到的两个构造子，`nil` 和 `cons`，**细化** 了类型检查器对长度 `n` 的知识。
当它是 `nil` 时，类型检查器还可以确定长度是 `0`，因此第二个模式的唯一可能选择是 `nil`。
当它是 `cons` 时，类型检查器可以确定长度是 `k+1`，因此第二个模式的唯一可能选择是 `cons`。
事实上，添加一个同时使用 `nil` 和 `cons` 的情形会导致类型错误，因为长度不匹配：

```lean
{{#example_in Examples/DependentTypes.lean zipExtraCons}}
```
```output error
{{#example_out Examples/DependentTypes.lean zipExtraCons}}
```

<!--
The refinement of the length can be observed by making `n` into an explicit argument:
-->

长度的细化可以通过将 `n` 变成一个显式参数来观察：
```lean
{{#example_decl Examples/DependentTypes.lean VectZipLen}}
```

<!-- 
## Exercises
-->

## 练习

<!--
Getting a feel for programming with dependent types requires experience, and the exercises in this section are very important.
For each exercise, try to see which mistakes the type checker can catch, and which ones it can't, by experimenting with the code as you go.
This is also a good way to develop a feel for the error messages.
-->

熟悉使用依值类型编程需要经验，本节的练习非常重要。
对于每个练习，尝试看看类型检查器可以捕捉到哪些错误，哪些错误它无法捕捉。
请通过实验代码来进行尝试。 这也是培养理解错误信息能力的好方法。

 <!-- 
 * Double-check that `Vect.zip` gives the right answer when combining the three highest peaks in Oregon with the three highest peaks in Denmark.
   Because `Vect` doesn't have the syntactic sugar that `List` has, it can be helpful to begin by defining `oregonianPeaks : Vect String 3` and `danishPeaks : Vect String 3`.
 -->

 * 仔细检查 `Vect.zip` 在将俄勒冈州的三座最高峰与丹麦的三座最高峰组合时是否给出了正确的答案。
   由于 `Vect` 没有 `List` 那样的语法糖，因此最好从定义 `oregonianPeaks : Vect String 3` 和 `danishPeaks : Vect String 3` 开始。

 <!-- 
 * Define a function `Vect.map` with type `(α → β) → Vect α n → Vect β n`.
 -->

 * 定义一个函数 `Vect.map`。它的类型为 `(α → β) → Vect α n → Vect β n`。

 <!-- 
 * Define a function `Vect.zipWith` that combines the entries in a `Vect` one at a time with a function.
   It should have the type `(α → β → γ) → Vect α n → Vect β n → Vect γ n`.
 -->

 * 定义一个函数 `Vect.zipWith`，它将一个接受两个参数的函数依次作用在两个 `Vect` 中的每一项上。
   它的类型应该是 `(α → β → γ) → Vect α n → Vect β n → Vect γ n`。

 <!-- 
 * Define a function `Vect.unzip` that splits a `Vect` of pairs into a pair of `Vect`s. It should have the type `Vect (α × β) n → Vect α n × Vect β n`.
 -->

 * 定义一个函数 `Vect.unzip`，它将一个包含有序对的 `Vect` 分割成两个 `Vect`。它的类型应该是 `Vect (α × β) n → Vect α n × Vect β n`。

 <!-- * 
 Define a function `Vect.snoc` that adds an entry to the _end_ of a `Vect`. Its type should be `Vect α n → α → Vect α (n + 1)` and `{{#example_in Examples/DependentTypes.lean snocSnowy}}` should yield `{{#example_out Examples/DependentTypes.lean snocSnowy}}`. The name `snoc` is a traditional functional programming pun: it is `cons` backwards.
 -->
 
 * 定义一个函数 `Vect.snoc`，它将一个条目添加到 `Vect` 的 **末尾**。它的类型应该是 `Vect α n → α → Vect α (n + 1)`，`{{#example_in Examples/DependentTypes.lean snocSnowy}}` 应该输出 `{{#example_out Examples/   DependentTypes.lean snocSnowy}}`。`snoc` 这个名字是函数式编程常见的习语：将 `cons` 倒过来写。
 
 <!-- 
 * Define a function `Vect.reverse` that reverses the order of a `Vect`.
 -->

 * 定义一个函数 `Vect.reverse`，它反转一个 `Vect` 的顺序。
 
 <!-- 
 * Define a function `Vect.drop` with the following type: `(n : Nat) → Vect α (k + n) → Vect α k`.
   Verify that it works by checking that `{{#example_in Examples/DependentTypes.lean ejerBavnehoej}}` yields `{{#example_out Examples/DependentTypes.lean ejerBavnehoej}}`.
 -->

 * 定义一个函数 `Vect.drop`。 它的类型 `(n : Nat) → Vect α (k + n) → Vect α k`。
   通过检查 `{{#example_in Examples/DependentTypes.lean ejerBavnehoej}}` 输出 `{{#example_out Examples/DependentTypes.lean ejerBavnehoej}}` 来验证它是否正确。

 <!-- 
 * Define a function `Vect.take` with type `(n : Nat) → Vect α (k + n) → Vect α n` that returns the first `n` entries in the `Vect`. Check that it works on an example.
 -->

 * 定义一个函数 `Vect.take`。它的类型为 `(n : Nat) → Vect α (k + n) → Vect α n`。它返回 `Vect` 中的前 `n` 个条目。检查它在一个例子上的结果。 
