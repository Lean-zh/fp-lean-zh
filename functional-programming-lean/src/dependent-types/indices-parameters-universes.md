<!-- # Indices, Parameters, and Universe Levels -->
# 索引、参数（Parameter）和宇宙层级

<!-- The distinction between indices and parameters of an inductive type is more than just a way to describe arguments to the type that either vary or do not between the constructors.
Whether an argument to an inductive type is a parameter or an index also matters when it comes time to determine the relationships between their universe levels.
In particular, an inductive type may have the same universe level as a parameter, but it must be in a larger universe than its indices.
This restriction is necessary to ensure that Lean can be used as a theorem prover as well as a programming language—without it, Lean's logic would be inconsistent.
Experimenting with error messages is a good way to illustrate these rules, as well as the precise rules that determine whether an argument to a type is a parameter or an index. -->

对归纳类型的索引和参数的区别不仅仅是描述类型的参数在构造函数之间是变化的还是不变的的一种方式。
当确定宇宙层级之间的关系时，归纳类型的参数和索引是参数还是索引也很重要。
特别是，归纳类型的宇宙层级可能与参数相同，但必须比其索引更大。
这种限制是为了确保 Lean 可以作为定理证明器以及编程语言使用——否则，Lean 的逻辑将是不一致的。
通过实验错误消息是说明这些规则的好方法，以及确定类型的参数或索引的参数的精确规则。

<!-- Generally speaking, the definition of an inductive type takes its parameters before a colon and its indices after the colon.
Parameters are given names like function arguments, whereas indices only have their types described.
This can be seen in the definition of `Vect`: -->
简单来说，归纳类型的定义在冒号之前取其参数，冒号之后取其索引。
参数像函数参数一样被命名，而索引只有其类型被描述。
这可以在 `Vect` 的定义中看到：

```lean
{{#example_decl Examples/DependentTypes.lean Vect}}
```

<!-- In this definition, `α` is a parameter and the `Nat` is an index.
Parameters may be referred to throughout the definition (for example, `Vect.cons` uses `α` for the type of its first argument), but they must always be used consistently.
Because indices are expected to change, they are assigned individual values at each constructor, rather than being provided as arguments at the top of the datatype definition. -->
在这个定义中，`α` 是一个参数，`Nat` 是一个索引。
参数可以在整个定义中引用（例如，`Vect.cons` 使用 `α` 作为其第一个参数的类型），但它们必须始终一致。
因为索引预计会改变，所以它们在每个构造函数中被分配单独的值，而不是作为参数提供在数据类型定义的顶部。


<!-- A very simple datatype with a parameter is `WithParameter`: -->
一个非常简单的带有参数的数据类型是 `WithParameter`：

```lean
{{#example_decl Examples/DependentTypes/IndicesParameters.lean WithParameter}}
```

<!-- The universe level `u` can be used for both the parameter and for the inductive type itself, illustrating that parameters do not increase the universe level of a datatype.
Similarly, when there are multiple parameters, the inductive type receives whichever universe level is greater: -->
宇宙层级 `u` 可以用于参数和归纳类型本身，说明参数不会增加数据类型的宇宙层级。
同样，当有多个参数时，归纳类型将获得更大的宇宙层级：

```lean
{{#example_decl Examples/DependentTypes/IndicesParameters.lean WithTwoParameters}}
```
<!-- Because parameters do not increase the universe level of a datatype, they can be more convenient to work with.
Lean attempts to identify arguments that are described like indices (after the colon), but used like parameters, and turn them into parameters:
Both of the following inductive datatypes have their parameter written after the colon: -->
由于参数不会增加数据类型的宇宙层级，它们可以更方便地使用。
Lean 试图识别像索引一样描述（在冒号之后），但像参数一样使用的参数，并将它们转换为参数：
以下两个归纳数据类型都在冒号之后写入其参数：

```lean
{{#example_decl Examples/DependentTypes/IndicesParameters.lean WithParameterAfterColon}}

{{#example_decl Examples/DependentTypes/IndicesParameters.lean WithParameterAfterColon2}}
```

<!-- When a parameter is not named in the initial datatype declaration, different names may be used for it in each constructor, so long as they are used consistently.
The following declaration is accepted: -->
当一个参数在初始数据类型声明中没有命名时，可以在每个构造函数中使用不同的名称，只要它们一致使用。
以下声明被接受：

```lean
{{#example_decl Examples/DependentTypes/IndicesParameters.lean WithParameterAfterColonDifferentNames}}
```
<!-- However, this flexibility does not extend to datatypes that explicitly declare the names of their parameters: -->
然而，这种灵活性不适用于显式声明其参数名称的数据类型：
```lean
{{#example_in Examples/DependentTypes/IndicesParameters.lean WithParameterBeforeColonDifferentNames}}
```
```output error
{{#example_out Examples/DependentTypes/IndicesParameters.lean WithParameterBeforeColonDifferentNames}}
```
<!-- Similarly, attempting to name an index results in an error: -->
类似的，尝试命名一个索引会导致错误：
```lean
{{#example_in Examples/DependentTypes/IndicesParameters.lean WithNamedIndex}}
```
```output error
{{#example_out Examples/DependentTypes/IndicesParameters.lean WithNamedIndex}}
```

<!-- Using an appropriate universe level and placing the index after the colon results in a declaration that is acceptable: -->
使用适当的宇宙层级并将索引放在冒号之后会导致一个可接受的声明：

```lean
{{#example_decl Examples/DependentTypes/IndicesParameters.lean WithIndex}}
```


<!-- Even though Lean can sometimes determine that an argument after the colon in an inductive type declaration is a parameter when it is used consistently in all constructors, all parameters are still required to come before all indices.
Attempting to place a parameter after an index results in the argument being considered an index itself, which would require the universe level of the datatype to increase: -->
虽然 Lean 有时可以确定归纳类型声明中冒号后的参数在所有构造函数中一致使用时是一个参数，但所有参数仍然需要在所有索引之前。
尝试在索引之后放置一个参数会导致该参数被视为一个索引，这将需要数据类型的宇宙层级增加：

```lean
{{#example_in Examples/DependentTypes/IndicesParameters.lean ParamAfterIndex}}
```
```output error
{{#example_out Examples/DependentTypes/IndicesParameters.lean ParamAfterIndex}}
```

<!-- Parameters need not be types.
This example shows that ordinary datatypes such as `Nat` may be used as parameters: -->
参数不必是类型。
这个例子显示了普通数据类型，如 `Nat` 可以用作参数：

```lean
{{#example_in Examples/DependentTypes/IndicesParameters.lean NatParamFour}}
```
```output error
{{#example_out Examples/DependentTypes/IndicesParameters.lean NatParamFour}}
```
<!-- Using the `n` as suggested causes the declaration to be accepted: -->
使用建议的 `n` 会导致声明被接受：

```lean
{{#example_decl Examples/DependentTypes/IndicesParameters.lean NatParam}}
```

<!-- What can be concluded from these experiments?
The rules of parameters and indices are as follows:
 1. Parameters must be used identically in each constructor's type.
 2. All parameters must come before all indices.
 3. The universe level of the datatype being defined must be at least as large as the largest parameter, and strictly larger than the largest index.
 4. Named arguments written before the colon are always parameters, while arguments after the colon are typically indices. Lean may determine that the usage of arguments after the colon makes them into parameters if they are used consistently in all constructors and don't come after any indices. -->
从以上结果中可以总结出什么？
参数和索引的规则如下：
 1. 参数在每个构造函数的类型中必须使用相同。
 2. 所有参数必须在所有索引之前。
 3. 正在定义的数据类型的宇宙层级必须至少与最大参数一样大，并严格大于最大索引。
 4. 冒号前写的命名参数始终是参数，而冒号后的参数通常是索引。如果 Lean 发现冒号后的参数在所有构造函数中一致使用且不在任何索引之后，则可能确定参数的使用使其成为参数。

<!-- When in doubt, the Lean command `#print` can be used to check how many of a datatype's arguments are parameters.
For example, for `Vect`, it points out that the number of parameters is 1: -->
当不确定时，可以使用 Lean 命令 `#print` 来检查数据类型的参数有多少。
例如，对于 `Vect`，它指出参数的数量是 1：

```lean
{{#example_in Examples/DependentTypes/IndicesParameters.lean printVect}}
```
```output info
{{#example_out Examples/DependentTypes/IndicesParameters.lean printVect}}
```

<!-- It is worth thinking about which arguments should be parameters and which should be indices when choosing the order of arguments to a datatype.
Having as many arguments as possible be parameters helps keep universe levels under control, which can make a complicated program easier to type check.
One way to make this possible is to ensure that all parameters come before all indices in the argument list. -->
在选择数据类型的参数顺序时，值得考虑哪些参数应该是参数，哪些应该是索引。
尽可能多地将参数作为参数有助于保持宇宙层级受控，这可以使复杂的程序更容易进行类型检查。
使这成为可能的一种方法是确保所有参数在参数列表中在所有索引之前。

<!-- Additionally, even though Lean is capable of determining that arguments after the colon are nonetheless parameters by their usage, it's a good idea to write parameters with explicit names.
This makes the intention clear to readers, and it causes Lean to report an error if the argument is mistakenly used inconsistently across the constructors. -->
同时，尽管 Lean 能够通过使用确定冒号后的参数仍然是参数，但最好使用显式名称编写参数。
这使读者的意图清晰，并且如果参数在构造函数之间被错误地不一致使用，Lean 会报告错误。