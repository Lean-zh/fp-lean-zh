<!--
# The Monad Type Class
-->

# Monad类型类

<!--
Rather than having to import an operator like `ok` or `andThen` for each type that is a monad, the Lean standard library contains a type class that allow them to be overloaded, so that the same operators can be used for _any_ monad.
Monads have two operations, which are the equivalent of `ok` and `andThen`:
-->

无需为每个单子都实现`ok`或`andThen`这样的运算符，Lean标准库包含一个类型类，允许它们被重载，以便相同的运算符可用于 **任何** 单子。
单子有两个操作，分别相当于`ok`和`andThen`：
```lean
{{#example_decl Examples/Monads/Class.lean FakeMonad}}
```
<!--
This definition is slightly simplified.
The actual definition in the Lean library is somewhat more involved, and will be presented later.
-->

这个定义略微简化了。
Lean标准库中的实际定义更复杂一些，稍后会介绍。

<!--
The `Monad` instances for `Option` and `Except` can be created by adapting the definitions of their respective `andThen` operations:
-->

`Option`和`Except`的`Monad`实例，可以通过调整它们各自的`andThen`操作的定义来创建：
```lean
{{#example_decl Examples/Monads/Class.lean MonadOptionExcept}}
```

<!--
As an example, `firstThirdFifthSeventh` was defined separately for `Option α` and `Except String α` return types.
Now, it can be defined polymorphically for _any_ monad.
It does, however, require a lookup function as an argument, because different monads might fail to find a result in different ways.
The infix version of `bind` is `>>=`, which plays the same role as `~~>` in the examples.
-->

例如`firstThirdFifthSeventh`原本对`Option α`和`Except String α`类型分别定义。
现在，它可以被定义为对 **任何** 单子都有效的多态函数。
但是，它需要接受一个参数作为查找函数，因为不同的单子可能以不同的方式找不到结果。
`bind`的中缀运算符是`>>=`, 它扮演与示例中`~~>`相同的角色。
```lean
{{#example_decl Examples/Monads/Class.lean firstThirdFifthSeventhMonad}}
```

<!--
Given example lists of slow mammals and fast birds, this implementation of `firstThirdFifthSeventh` can be used with `Option`:
-->

给定作为示例的slowMammals和fastBirds列表，该`firstThirdFifthSeventh`实现可与`Option`一起使用：
```lean
{{#example_decl Examples/Monads/Class.lean animals}}

{{#example_in Examples/Monads/Class.lean noneSlow}}
```
```output info
{{#example_out Examples/Monads/Class.lean noneSlow}}
```
```lean
{{#example_in Examples/Monads/Class.lean someFast}}
```
```output info
{{#example_out Examples/Monads/Class.lean someFast}}
```

<!--
After renaming `Except`'s lookup function `get` to something more specific, the very same  implementation of `firstThirdFifthSeventh` can be used with `Except` as well:
-->

在将`Except`的查找函数`get`重命名为更具体的形式后，完全相同的`firstThirdFifthSeventh`实现也可以与`Except`一起使用：
```lean
{{#example_decl Examples/Monads/Class.lean getOrExcept}}

{{#example_in Examples/Monads/Class.lean errorSlow}}
```
```output info
{{#example_out Examples/Monads/Class.lean errorSlow}}
```
```lean
{{#example_in Examples/Monads/Class.lean okFast}}
```
```output info
{{#example_out Examples/Monads/Class.lean okFast}}
```
<!--
The fact that `m` must have a `Monad` instance means that the `>>=` and `pure` operations are available.
-->

`m`必须有`Monad`实例，这一事实这意味着可以使用`>>=`和`pure`运算符。


<!--
## General Monad Operations
-->

## 通用的单子运算符

<!--
Because many different types are monads, functions that are polymorphic over _any_ monad are very powerful.
For example, the function `mapM` is a version of `map` that uses a `Monad` to sequence and combine the results of applying a function:
-->

由于许多不同类型都是单子，因此对 **任何** 单子多态的函数非常强大。
例如，函数`mapM`是`map`的另一个版本，它使用`Monad`将函数调用的结果按顺序连接起来：
```lean
{{#example_decl Examples/Monads/Class.lean mapM}}
```
<!--
The return type of the function argument `f` determines which `Monad` instance will be used.
In other words, `mapM` can be used for functions that produce logs, for functions that can fail, or for functions that use mutable state.
Because `f`'s type determines the available effects, they can be tightly controlled by API designers.
-->

函数参数`f`的返回类型决定了将使用哪个`Monad`实例。
换句话说，`mapM`可用于生成日志的函数、可能失败的函数、或使用可变状态的函数。
由于`f`的类型直接决定了可用的效应(Effects)，因此API设计人员可以对其进行严格控制。
*译者注：效应(Effects)是函数式编程中与Monad密切相关的主题，实际上对效应的控制比此处原文所述更复杂一些，但超出了本文的内容。另外副作用(Side Effects)也是一种效应。*

<!--
As described in [this chapter's introduction](../monads.md#numbering-tree-nodes), `State σ α` represents programs that make use of a mutable variable of type `σ` and return a value of type `α`.
These programs are actually functions from a starting state to a pair of a value and a final state.
The `Monad` class requires that its parameter expect a single type argument—that is, it should be a `Type → Type`.
This means that the instance for `State` should mention the state type `σ`, which becomes a parameter to the instance:
-->

如[本章简介](../monads.md#对树节点编号)所介绍的，`State σ α`表示使用类型为`σ`的可变变量，并返回类型为`α`的值的程序。
这些程序实际上是从起始状态到值和最终状态构成的对(pair)的函数。
`Monad`类型类要求：类型参数期望另一个类型参数，即它应该是`Type → Type`。
这意味着`State`的实例应提及状态类型`σ`，使它成为实例的参数：
```lean
{{#example_decl Examples/Monads/Class.lean StateMonad}}
```
<!--
This means that the type of the state cannot change between calls to `get` and `set` that are sequenced using `bind`, which is a reasonable rule for stateful computations.
The operator `increment` increases a saved state by a given amount, returning the old value:
-->

这意味着在使用`bind`对`get`和`set`排序时，状态的类型不能更改，这是具有状态的计算的合理规则。运算符`increment`将保存的状态加上一定量，并返回原值：
```lean
{{#example_decl Examples/Monads/Class.lean increment}}
```

<!--
Using `mapM` with `increment` results in a program that computes the sum of the entries in a list.
More specifically, the mutable variable contains the sum so far, while the resulting list contains a running sum.
In other words, `{{#example_in Examples/Monads/Class.lean mapMincrement}}` has type `{{#example_out Examples/Monads/Class.lean mapMincrement}}`, and expanding the definition of `State` yields `{{#example_out Examples/Monads/Class.lean mapMincrement2}}`.
It takes an initial sum as an argument, which should be `0`:
-->

将`mapM`和`increment`一起使用会得到一个：计算列表元素加和的程序。
更具体地说，可变变量包含到目前为止的和，而作为结果的列表包含各个步骤前状态变量的值。
换句话说，`mapM increment`的类型为`List Int → State Int (List Int)`，展开 `State` 的定义得到`List Int → Int → (Int× List Int)`。
它将初始值作为参数，应为`0`：
```lean
{{#example_in Examples/Monads/Class.lean mapMincrementOut}}
```
```output info
{{#example_out Examples/Monads/Class.lean mapMincrementOut}}
```

<!--
A [logging effect](../monads.md#logging) can be represented using `WithLog`.
Just like `State`, its `Monad` instance is polymorphic with respect to the type of the logged data:
-->

可以使用`WithLog`表示[日志记录效应](../monads.md#日志记录)。
就和`State`一样，它的`Monad`实例对于被记录数据的类型也是多态的：
```lean
{{#example_decl Examples/Monads/Class.lean MonadWriter}}
```
<!--
`saveIfEven` is a function that logs even numbers but returns its argument unchanged:
-->

`saveIfEven`函数记录偶数，但将参数原封不动返回：
```lean
{{#example_decl Examples/Monads/Class.lean saveIfEven}}
```
<!--
Using this function with `mapM` results in a log containing even numbers paired with an unchanged input list:
-->

将`mapM`和该函数一起使用，会生成一个记录偶数的日志、和未更改的输入列表：
```lean
{{#example_in Examples/Monads/Class.lean mapMsaveIfEven}}
```
```output info
{{#example_out Examples/Monads/Class.lean mapMsaveIfEven}}
```



<!--
## The Identity Monad
-->

## 恒等单子

<!--
Monads encode programs with effects, such as failure, exceptions, or logging, into explicit representations as data and functions.
Sometimes, however, an API will be written to use a monad for flexibility, but the API's client may not require any encoded effects.
The _identity monad_ is a monad that has no effects, and allows pure code to be used with monadic APIs:
-->

单子将具有效应(Effects)的程序（例如失败、异常或日志记录）编码为数据和函数的显式表示。
有时API会使用单子来提高灵活性，但API的使用方可能不需要任何效应。
 **恒等单子** (Identity Monad)是一个没有任何效应的单子，允许将纯(pure)代码与monadic API一起使用：
```lean
{{#example_decl Examples/Monads/Class.lean IdMonad}}
```
<!--
The type of `pure` should be `α → Id α`, but `Id α` reduces to just `α`.
Similarly, the type of `bind` should be `α → (α → Id β) → Id β`.
Because this reduces to `α → (α → β) → β`, the second argument can be applied to the first to find the result.
-->

`pure`的类型应为`α → Id α`，但`Id α` **简化** 为 `α`。类似地，`bind`的类型应为`α → (α → Id β) → Id β`。
由于这 **简化** 为 `α → (α → β) → β`，因此可以将第二个参数应用于第一个参数得到结果。
*译者注：此处 **简化** 一词原文为reduces to，实际含义为beta-reduction，请见类型论相关资料。*

<!--
With the identity monad, `mapM` becomes equivalent to `map`.
To call it this way, however, Lean requires a hint that the intended monad is `Id`:
-->

"使用恒等单子时，`mapM`等同于`map`。但是要以这种方式调用它，Lean需要额外的提示来表明目标单子是`Id`：
```lean
{{#example_in Examples/Monads/Class.lean mapMId}}
```
```output info
{{#example_out Examples/Monads/Class.lean mapMId}}
```
<!--
Omitting the hint results in an error:
-->

省略提示则会导致错误：
```lean
{{#example_in Examples/Monads/Class.lean mapMIdNoHint}}
```
```output error
{{#example_out Examples/Monads/Class.lean mapMIdNoHint}}
```
<!--
In this error, the application of one metavariable to another indicates that Lean doesn't run the type-level computation backwards.
The return type of the function is expected to be the monad applied to some other type.
Similarly, using `mapM` with a function whose type doesn't provide any specific hints about which monad is to be used results in an "instance problem stuck" message:
-->

导致错误的原因是：一个元变量应用于另一个元变量，使得Lean不会反向运行类型计算。
函数的返回类型应该是应用于其他类型参数的单子。
类似地，将`mapM`和未提供任何特定单子类型信息的函数一起使用，会导致"instance problem stuck"错误：
```lean
{{#example_in Examples/Monads/Class.lean mapMIdId}}
```
```output error
{{#example_out Examples/Monads/Class.lean mapMIdId}}
```


<!--
## The Monad Contract
-->

## 单子约定
<!--
Just as every pair of instances of `BEq` and `Hashable` should ensure that any two equal values have the same hash, there is a contract that each instance of `Monad` should obey.
First, `pure` should be a left identity of `bind`.
That is, `bind (pure v) f` should be the same as `f v`.
Secondly, `pure` should be a right identity of `bind`, so `bind v pure` is the same as `v`.
Finally, `bind` should be associative, so `bind (bind v f) g` is the same as `bind v (fun x => bind (f x) g)`.
-->

正如`BEq`和`Hashable`的每一对实例都应该确保任何两个相等的值具有相同的哈希值，有一些是固有的约定是每个`Monad`的实例都应遵守的。
首先，`pure`应为`bind`的左单位元，即`bind (pure v) f`应与`f v`等价。
其次，`pure`应为 `bind` 的右单位元，即`bind v pure`应与`v`等价。
最后，`bind`应满足结合律，即`bind (bind v f) g`应与`bind v (fun x => bind (f x) g)`等价。

<!--
This contract specifies the expected properties of programs with effects more generally.
Because `pure` has no effects, sequencing its effects with `bind` shouldn't change the result.
The associative property of `bind` basically says that the sequencing bookkeeping itself doesn't matter, so long as the order in which things are happening is preserved.
-->

这些约定保证了具有效应的程序的预期属性。
由于`pure`不导致效应，因此用`bind`将其与其他效应接连执行不应改变结果。
`bind`满足的结合律则意味着先计算哪一部分无关紧要，只要保证效应的顺序不变即可。

<!--
## Exercises
-->

## 练习

<!--
### Mapping on a Tree
-->

### 映射一棵树

<!--
Define a function `BinTree.mapM`.
By analogy to `mapM` for lists, this function should apply a monadic function to each data entry in a tree, as a preorder traversal.
The type signature should be:
-->

定义函数`BinTree.mapM`。
通过类比列表的`mapM`，此函数应将单子函数应用于树中的每个节点，作为前序遍历。
类型签名应为：
```
def BinTree.mapM [Monad m] (f : α → m β) : BinTree α → m (BinTree β)
```


<!--
### The Option Monad Contract
-->

### Option单子的约定

<!--
First, write a convincing argument that the `Monad` instance for `Option` satisfies the monad contract.
Then, consider the following instance:
-->

首先充分论证`Option`的`Monad`实例满足单子约定。
然后，考虑以下实例：
```lean
{{#example_decl Examples/Monads/Class.lean badOptionMonad}}
```
<!--
Both methods have the correct type.
Why does this instance violate the monad contract?
-->

这两个方法都有正确的类型。
但这个实例却违反了单子约定，为什么？



