<!-- # A Monad Construction Kit -->
# 单子构建工具包

<!-- `ReaderT` is far from the only useful monad transformer.
This section describes a number of additional transformers.
Each monad transformer consists of the following: -->
`ReaderT` 并不是唯一有用的单子转换器。
本节将介绍一些额外的转换器。
每个单子转换器都由以下部分组成：
 <!-- 1. A definition or datatype `T` that takes a monad as an argument.
    It should have a type like `(Type u → Type v) → Type u → Type v`, though it may accept additional arguments prior to the monad.
 2. A `Monad` instance for `T m` that relies on an instance of `Monad m`. This enables the transformed monad to be used as a monad.
 3. A `MonadLift` instance that translates actions of type `m α` into actions of type `T m α`, for arbitrary monads `m`. This enables actions from the underlying monad to be used in the transformed monad. -->
 1. 一个以单子为参数定义或数据类型 `T`。
    它的类型应类似于 `(Type u → Type v) → Type u → Type v`，尽管它可以接受单子之前的其他参数。
 2. `T m` 的 `Monad` 实例依赖于 `Monad m` 实例。这使得转换后的单子也可以作为单子使用。
 3. 一个 `MonadLift` 实例，可将任意单子 `m` 的 `m α` 类型的操作转换为 `T m α` 类型的操作。这使得底层单子中的操作可以在转换后的单子中使用。

<!-- Furthermore, the `Monad` instance for the transformer should obey the contract for `Monad`, at least if the underlying `Monad` instance does.
In addition, `monadLift (pure x)` should be equivalent to `pure x` in the transformed monad, and `monadLift` should distribute over `bind` so that `monadLift (x >>= f)` is the same as `monadLift x >>= fun y => monadLift (f y)`. -->

此外，转换器的 `Monad` 实例也应该遵守 `Monad` 的约定，至少在底层的 `Monad` 实例遵守的情况下。
另外，`monadLift (pure x)` 应该等价于转换后的单子中的 `pure x` ，而且 `monadLift` 应对于 `bind` 可分配，这样 `monadLift (x >>= f)` 就等同于 `monadLift x >>= fun y => monadLift (f y)` 。

<!-- Many monad transformers additionally define type classes in the style of `MonadReader` that describe the actual effects available in the monad.
This can provide more flexibility: it allows programs to be written that rely only on an interface, and don't constrain the underlying monad to be implemented by a given transformer.
The type classes are a way for programs to express their requirements, and monad transformers are a convenient way to meet these requirements. -->

许多单子转换器还定义了 `MonadReader` 风格的类型类，用于描述单子中可用的实际效果。
这可以提供更大的灵活性：它允许编写只依赖接口的程序，而不限制底层单子必须由给定的转换器实现。
类型类是程序表达其需求的一种方式，而单子转换器则是满足这些需求的一种便捷方式。

<!-- ## Failure with `OptionT` -->
## 使用 `OptionT` 失败

<!-- Failure, represented by the `Option` monad, and exceptions, represented by the `Except` monad, both have corresponding transformers.
In the case of `Option`, failure can be added to a monad by having it contain values of type `Option α` where it would otherwise contain values of type `α`.
For example, `IO (Option α)` represents `IO` actions that don't always return a value of type `α`.
This suggests the definition of the monad transformer `OptionT`: -->

由 `Option` 单子表示的失败和由 `Except` 单子表示的异常都有相应的转换器。
对于 `Option` 单子，可以通过让单子包含 `Option α` 类型的值来为单子添加失败，否则单子将包含 `α` 类型的值。
例如，`IO (Option α)` 表示并不总是返回 `α` 类型值的 `IO` 操作。
这就需要定义单子转换器 `OptionT`：

```lean
{{#example_decl Examples/MonadTransformers/Defs.lean OptionTdef}}
```

<!-- As an example of `OptionT` in action, consider a program that asks the user questions.
The function `getSomeInput` asks for a line of input and removes whitespace from both ends.
If the resulting trimmed input is non-empty, then it is returned, but the function fails if there are no non-whitespace characters: -->

我们以一个向用户提问的程序为例来说明 `OptionT` 的作用。
函数 `getSomeInput` 要求输入一行内容，并删除两端的空白。
如果修剪后的输入是非空的，就会返回，但如果没有非空格字符，函数就会失败：

```lean
{{#example_decl Examples/MonadTransformers/Defs.lean getSomeInput}}
```
<!-- This particular application tracks users with their name and their favorite species of beetle: -->

这个应用软件可以追踪用户的姓名和他们最喜欢的甲虫种类：
```lean
{{#example_decl Examples/MonadTransformers/Defs.lean UserInfo}}
```
<!-- Asking the user for input is no more verbose than a function that uses only `IO` would be: -->
询问用户输入并不比只使用 `IO` 的函数更冗长：
```lean
{{#example_decl Examples/MonadTransformers/Defs.lean getUserInfo}}
```
<!-- However, because the function runs in an `OptionT IO` context rather than just in `IO`, failure in the first call to `getSomeInput` causes the whole `getUserInfo` to fail, with control never reaching the question about beetles.
The main function, `interact`, invokes `getUserInfo` in a purely `IO` context, which allows it to check whether the call succeeded or failed by matching on the inner `Option`: -->
然而，由于函数是在 `OptionT IO` 上下文中运行的，而不仅仅是在 `IO` 中，因此第一次调用 `getSomeInput` 失败会导致整个 `getUserInfo` 失败，控制权永远不会到达关于甲虫的问题。
主函数 `interact` 在纯的 `IO` 上下文中调用 `getUserInfo`，这样就可以通过匹配内部的 `Option` 来检查调用成功还是失败：
```lean
{{#example_decl Examples/MonadTransformers/Defs.lean interact}}
```

<!-- ### The Monad Instance -->
### 单子实例

<!-- Writing the monad instance reveals a difficulty.
Based on the types, `pure` should use `pure` from the underlying monad `m` together with `some`.
Just as `bind` for `Option` branches on the first argument, propagating `none`, `bind` for `OptionT` should run the monadic action that makes up the first argument, branch on the result, and then propagate `none`.
Following this sketch yields the following definition, which Lean does not accept: -->

在编写单子实例发现了一个难题。
根据类型，`pure` 应该使用底层单子 `m` 中的 `pure` 和 `some`。
正如 `Option` 的 `bind` 在第一个参数上分支，然后传播 `none`，`OptionT` 的 `bind` 应该运行构成第一个参数的单子操作，在结果上分支，然后传播 `none`。
按照这个框架可以得到 Lean 不接受的如下定义：

```lean
{{#example_in Examples/MonadTransformers/Defs.lean firstMonadOptionT}}
```
<!-- The error message shows a cryptic type mismatch: -->
错误信息显示了一个隐含的类型不匹配：

```output error
{{#example_out Examples/MonadTransformers/Defs.lean firstMonadOptionT}}
```
<!-- The problem here is that Lean is selecting the wrong `Monad` instance for the surrounding use of `pure`.
Similar errors occur for the definition of `bind`.
One solution is to use type annotations to guide Lean to the correct `Monad` instance: -->
这里的问题是 Lean 为周围的 `pure` 使用选择了错误的 `Monad` 实例。
类似的错误也发生在 `bind` 的定义中。
一种解决方案是使用类型标注来引导 Lean 选择正确的 `Monad` 实例：
```lean
{{#example_decl Examples/MonadTransformers/Defs.lean MonadOptionTAnnots}}
```
<!-- While this solution works, it is inelegant and the code becomes a bit noisy. -->
虽然这种解决方案可行，但它不够优雅，代码也变得有点啰嗦。

<!-- An alternative solution is to define functions whose type signatures guide Lean to the correct instances.
In fact, `OptionT` could have been defined as a structure: -->
另一种解决方案是定义函数，由函数的类型签名引导 Lean 找到正确的实例。
事实上，`OptionT` 自身可以定义为一个结构：

```lean
{{#example_decl Examples/MonadTransformers/Defs.lean OptionTStructure}}
```
<!-- This would solve the problem, because the constructor `OptionT.mk` and the field accessor `OptionT.run` would guide type class inference to the correct instances.
The downside to doing this is that structure values would need to be allocated and deallocated repeatedly when running code that uses it, while the direct definition is a compile-time-only feature.
The best of both worlds can be achieved by defining functions that serve the same role as `OptionT.mk` and `OptionT.run`, but that work with the direct definition: -->

这可以解决这个问题，因为构造函数 `OptionT.mk` 和字段访问函数 `OptionT.run` 将引导类型类推理到正确的实例。
但这样做的缺点是，在运行使用结构体的代码时，结构体值需要反复分配和释放，而直接定义是编译期专用的功能。
我们可以通过定义与 `OptionT.mk` 和 `OptionT.run` 具有相同作用的函数来实现两全其美的效果，但这些函数要与直接定义一起使用：

```lean
{{#example_decl Examples/MonadTransformers/Defs.lean FakeStructOptionT}}
```
<!-- Both functions return their inputs unchanged, but they indicate the boundary between code that is intended to present the interface of `OptionT` and code that is intended to present the interface of the underlying monad `m`.
Using these helpers, the `Monad` instance becomes more readable: -->

这两个函数直接返回的其原输入，但它们指明了旨在呈现 `OptionT` 接口的代码与旨在呈现底层单子 `m` 接口的代码之间的边界。
使用这些辅助函数，`Monad` 实例变得更加可读：
```lean
{{#example_decl Examples/MonadTransformers/Defs.lean MonadOptionTFakeStruct}}
```
<!-- Here, the use of `OptionT.mk` indicates that its arguments should be considered as code that uses the interface of `m`, which allows Lean to select the correct `Monad` instances. -->
在这里，使用 `OptionT.mk` 表示其参数应被视为使用 `m` 接口的代码，它允许 Lean 选择正确的 `Monad` 实例。

<!-- After defining the monad instance, it's a good idea to check that the monad contract is satisfied.
The first step is to show that `bind (pure v) f` is the same as `f v`.
Here's the steps: -->
定义完单子实例后，最好检查一下单子约定是否满足。
第一步是证明 `bind (pure v) f` 与 `f v` 相同。
步骤如下：
{{#equations Examples/MonadTransformers/Defs.lean OptionTFirstLaw}}

<!-- The second rule states that `bind w pure` is the same as `w`.
To demonstrate this, unfold the definitions of `bind` and `pure`, yielding: -->
第二条规则指出，`bind w pure` 与 `w` 相同。
为了证明这一点，展开 `bind` 和 `pure` 的定义，得出：
```lean
OptionT.mk do
    match ← w with
    | none => pure none
    | some v => pure (some v)
```
<!-- In this pattern match, the result of both cases is the same as the pattern being matched, just with `pure` around it.
In other words, it is equivalent to `w >>= fun y => pure y`, which is an instance of `m`'s second monad rule. -->
在这个模式匹配中，两种情况的结果都与被匹配的模式相同，只是在其周围加上了 `pure`。
换句话说，它等同于 `w >>= fun y => pure y`，这是 `m` 的第二个单子规则的一个实例。

<!-- The final rule states that `bind (bind v f) g`  is the same as `bind v (fun x => bind (f x) g)`.
It can be checked in the same way, by expanding the definitions of `bind` and `pure` and then delegating to the underlying monad `m`. -->

最后一条规则指出 `bind (bind v f) g` 与 `bind v (fun x => bind (f x) g)`相同。
通过扩展 `bind` 和 `pure` 的定义，然后将其委托给底层单子 `m`，可以用同样的方法对其进行检查。

<!-- ### An `Alternative` Instance -->
### 一个 `Alternative` 实例

<!-- One convenient way to use `OptionT` is through the `Alternative` type class.
Successful return is already indicated by `pure`, and the `failure` and `orElse` methods of `Alternative` provide a way to write a program that returns the first successful result from a number of subprograms: -->
一种使用 `OptionT` 的便捷方法是通过 `Alternative` 类型类。
成功返回已经由 `pure` 表示，而 `Alternative` 的 `failure` 和 `orElse` 方法提供了一种编写程序的方式，可以从多个子程序中返回第一个成功的结果：

```lean
{{#example_decl Examples/MonadTransformers/Defs.lean AlternativeOptionT}}
```


<!-- ### Lifting -->
### 提升

<!-- Lifting an action from `m` to `OptionT m` only requires wrapping `some` around the result of the computation: -->
将一个操作从 `m` 移植到 `OptionT m` 只需要用 `some` 包装计算结果：
```lean
{{#example_decl Examples/MonadTransformers/Defs.lean LiftOptionT}}
```


<!-- ## Exceptions -->
## 异常

<!-- The monad transformer version of `Except` is very similar to the monad transformer version of `Option`.
Adding exceptions of type `ε` to some monadic action of type `m α` can be accomplished by adding exceptions to `α`, yielding type `m (Except ε α)`: -->

单子转换器版本的 `Except` 与单子转换器版本的 `Option` 非常相似。
向 `m α` 类型的单子动作添加 `ε` 类型的异常，可以通过向 `α` 添加异常来实现，从而产生 `m (Except ε α)`：

```lean
{{#example_decl Examples/MonadTransformers/Defs.lean ExceptT}}
```
<!-- `OptionT` provides `mk` and `run` functions to guide the type checker towards the correct `Monad` instances.
This trick is also useful for `ExceptT`: -->
`OptionT` 提供了 `mk` 和 `run` 函数来引导类型检查器找到正确的 `Monad` 实例。
这个技巧对 `ExceptT` 也很有用：
```lean
{{#example_decl Examples/MonadTransformers/Defs.lean ExceptTFakeStruct}}
```
<!-- The `Monad` instance for `ExceptT` is also very similar to the instance for `OptionT`.
The only difference is that it propagates a specific error value, rather than `none`: -->
用于 `ExceptT` 的 `Monad` 实例与用于 `OptionT` 的 `Monad` 实例也非常相似。
唯一不同的是，它传播的是一个特定的错误值，而不是 `none`：
```lean
{{#example_decl Examples/MonadTransformers/Defs.lean MonadExceptT}}
```

<!-- The type signatures of `ExceptT.mk` and `ExceptT.run` contain a subtle detail: they annotate the universe levels of `α` and `ε` explicitly.
If they are not explicitly annotated, then Lean generates a more general type signature in which they have distinct polymorphic universe variables.
However, the definition of `ExceptT` expects them to be in the same universe, because they can both be provided as arguments to `m`.
This can lead to a problem in the `Monad` instance where the universe level solver fails to find a working solution: -->
`ExceptT.mk` 和 `ExceptT.run` 的类型签名包含一个微妙的细节：它们明确地注释了 `α` 和 `ε` 的宇宙层级。
如果它们没有被明确注释，那么 Lean 会生成一个更通用的类型签名，其中它们拥有不同的多态宇宙变量。
然而， `ExceptT` 的定义希望它们在同一个宇宙中，因为它们都可以作为参数提供给 `m`。
这会导致 `Monad` 实例出现问题，即宇宙层级求解器无法找到有效的解决方案：
```lean
{{#example_decl Examples/MonadTransformers/Defs.lean ExceptTNoUnis}}

{{#example_in Examples/MonadTransformers/Defs.lean MonadMissingUni}}
```
```output error
{{#example_out Examples/MonadTransformers/Defs.lean MonadMissingUni}}
```
<!-- This kind of error message is typically caused by underconstrained universe variables.
Diagnosing it can be tricky, but a good first step is to look for reused universe variables in some definitions that are not reused in others. -->
这种错误信息通常是由欠约束的宇宙变量引起的。
诊断起来可能很棘手，但第一步可以查找某些定义中重复使用的宇宙变量，而其他定义中没有重复使用的宇宙变量。

<!-- Unlike `Option`, the `Except` datatype is typically not used as a data structure.
It is always used as a control structure with its `Monad` instance.
This means that it is reasonable to lift `Except ε` actions into `ExceptT ε m`, as well as actions from the underlying monad `m`.
Lifting `Except` actions into `ExceptT` actions is done by wrapping them in `m`'s `pure`, because an action that only has exception effects cannot have any effects from the monad `m`: -->
与 `Option` 不同，`Except` 数据类型通常不作为数据结构使用。
它总是作为控制结构与其 `Monad` 实例一起使用。
这意味着将 `Except ε` 操作提升到 `ExceptT ε m` 以及对底层单子 `m` 的操作都是合理的。
通过用 `m` 的 `pure` 对 `Except` 操作进行包装，可以将其提升为 `ExceptT` 操作，因为一个只有异常效果的动作不可能有来自单子 `m` 的任何效果：
```lean
{{#example_decl Examples/MonadTransformers/Defs.lean ExceptTLiftExcept}}
```
<!-- Because actions from `m` do not have any exceptions in them, their value should be wrapped in `Except.ok`.
This can be accomplished using the fact that `Functor` is a superclass of `Monad`, so applying a function to the result of any monadic computation can be accomplished using `Functor.map`: -->
由于 `m` 中的操作不包含任何异常，因此它们的值应该用 `Except.ok` 封装。
这可以利用 `Functor` 是 `Monad` 的超类这一事实来实现，因此可以使用 `Functor.map`，将函数应用于任何单子计算的结果：
```lean
{{#example_decl Examples/MonadTransformers/Defs.lean ExceptTLiftM}}
```

<!-- ### Type Classes for Exceptions -->
### 异常的类型类

<!-- Exception handling fundamentally consists of two operations: the ability to throw exceptions, and the ability to recover from them.
Thus far, this has been accomplished using the constructors of `Except` and pattern matching, respectively.
However, this ties a program that uses exceptions to one specific encoding of the exception handling effect.
Using a type class to capture these operations allows a program that uses exceptions to be used in _any_ monad that supports throwing and catching. -->
异常处理从根本上说包括两种操作：抛出异常的能力和恢复异常的能力。
到目前为止，我们分别使用 `Except` 的构造函数和模式匹配来实现这一点。
然而，这将使用异常的程序与异常处理效果的特定编码联系在一起。
使用类型类来捕获这些操作，可以让使用异常的程序在 _任何_ 支持抛出和捕获的单子中使用。

<!-- Throwing an exception should take an exception as an argument, and it should be allowed in any context where a monadic action is requested.
The "any context" part of the specification can be written as a type by writing `m α`—because there's no way to produce a value of any arbitrary type, the `throw` operation must be doing something that causes control to leave that part of the program.
Catching an exception should accept any monadic action together with a handler, and the handler should explain how to get back to the action's type from an exception: -->
抛出异常应该以异常作为参数，而且应该允许在任何要求执行单子动作的上下文中抛出异常。
规范中 "任何上下文" 的部分可以写成一种类型，即 `m α` ——— 因为没有办法产生任意类型的值，所以 `throw` 操作必须能使控制权离开程序的这一部分。
捕获异常应该接受任何单子操作和处理程序，处理程序应该解释如何从异常返回到操作的类型：
```lean
{{#example_decl Examples/MonadTransformers/Defs.lean MonadExcept}}
```

<!-- The universe levels on `MonadExcept` differ from those of `ExceptT`.
In `ExceptT`, both `ε` and `α` have the same level, while `MonadExcept` imposes no such limitation.
This is because `MonadExcept` never places an exception value inside of `m`.
The most general universe signature recognizes the fact that `ε` and `α` are completely independent in this definition.
Being more general means that the type class can be instantiated for a wider variety of types. -->
`MonadExcept` 的宇宙层级与 `ExceptT` 不同。
在 `ExceptT` 中，`ε` 和 `α` 具有相同的层级，而 `MonadExcept` 则没有这种限制。
这是因为 `MonadExcept`从不将异常值置于 `m` 内。
在这个定义中，最通用的宇宙签名承认 `ε` 和 `α` 是完全独立的。
更通用意味着类型类可以为更多类型实例化。

<!-- An example program that uses `MonadExcept` is a simple division service.
The program is divided into two parts: a frontend that supplies a user interface based on strings that handles errors, and a backend that actually does the division.
Both the frontend and the backend can throw exceptions, the former for ill-formed input and the latter for division by zero errors.
The exceptions are an inductive type: -->
下面是一个简单的除法服务，作为使用 `MonadExcept` 的一个示例程序。
程序分为两部分：前端提供基于字符串的用户界面，用于处理错误；后端实际执行除法操作。
前后端都可以抛出异常，前者用于处理格式错误的输入，后者用于处理除数为零的错误。
定义异常为一种归纳类型：
```lean
{{#example_decl Examples/MonadTransformers/Defs.lean ErrEx}}
```
<!-- The backend checks for zero, and divides if it can: -->
后端检查是否为零，如果为零，则进行除法：
```lean
{{#example_decl Examples/MonadTransformers/Defs.lean divBackend}}
```
<!-- The frontend's helper `asNumber` throws an exception if the string it is passed is not a number.
The overall frontend converts its inputs to `Int`s and calls the backend, handling exceptions by returning a friendly string error: -->
如果传入的字符串不是数字，前端的辅助函数 `asNumber` 会抛出异常。
整个前端会将输入转换为 `Int` 并调用后端，通过返回友好的错误字符串来处理异常：
```lean
{{#example_decl Examples/MonadTransformers/Defs.lean asNumber}}

{{#example_decl Examples/MonadTransformers/Defs.lean divFrontend}}
```
<!-- Throwing and catching exceptions is common enough that Lean provides a special syntax for using `MonadExcept`.
Just as `+` is short for `HAdd.hAdd`, `try` and `catch` can be used as shorthand for the `tryCatch` method: -->
抛出和捕获异常非常常见，因此 Lean 提供了使用 `MonadExcept` 的特殊语法。
正如 `+` 是 `HAdd.hAdd` 的缩写，`try` 和 `catch` 可以作为 `tryCatch` 方法的缩写：
```lean
{{#example_decl Examples/MonadTransformers/Defs.lean divFrontendSugary}}
```

<!-- In addition to `Except` and `ExceptT`, there are useful `MonadExcept` instances for other types that may not seem like exceptions at first glance.
For example, failure due to `Option` can be seen as throwing an exception that contains no data whatsoever, so there is an instance of `{{#example_out Examples/MonadTransformers/Defs.lean OptionExcept}}` that allows `try ... catch ...` syntax to be used with `Option`. -->
除了 `Except` 和 `ExceptT` 之外，还有一些有用的 `MonadExcept` 实例，用于处理其他类型的异常，这些异常乍看起来可能不像是异常。
例如，`Option` 导致的失败可以被看作是抛出了一个不包含任何数据的异常，因此有一个实例 `{{#example_out Examples/MonadTransformers/Defs.lean OptionExcept}}` 允许将 `try ... catch ...` 语法与 `Option` 一起使用。

<!-- ## State -->
## 状态

<!-- A simulation of mutable state is added to a monad by having monadic actions accept a starting state as an argument and return a final state together with their result.
The bind operator for a state monad provides the final state of one action as an argument to the next action, threading the state through the program.
This pattern can also be expressed as a monad transformer: -->
通过让单子动作接受一个起始状态作为参数，并返回一个最终状态及其结果，就可以在单子中加入对可变状态的模拟。
状态单子的绑定操作符将一个动作的最终状态作为下一个动作的参数，从而将状态贯穿整个程序。
这种模式也可以用单子转换器来表示：
```lean
{{#example_decl Examples/MonadTransformers/Defs.lean DefStateT}}
```


<!-- Once again, the monad instance is very similar to that for `State`.
The only difference is that the input and output states are passed around and returned in the underlying monad, rather than with pure code: -->
同样，该单子实例与 `State` 非常相似。
唯一不同的是，输入和输出状态是在底层单子中传递和返回的，而不是纯代码：
```lean
{{#example_decl Examples/MonadTransformers/Defs.lean MonadStateT}}
```

<!-- The corresponding type class has `get` and `set` methods.
One downside of `get` and `set` is that it becomes too easy to `set` the wrong state when updating it.
This is because retrieving the state, updating it, and saving the updated state is a natural way to write some programs.
For example, the following program counts the number of diacritic-free English vowels and consonants in a string of letters: -->
相应的类型类有 `get` 和 `set` 方法。
`get` 和 `set` 的一个缺点是，在更新状态时很容易 `set` 错误的状态。
这是因为检索状态、更新状态并保存更新后的状态是编写某些程序的一种很自然的方式。
例如，下面的程序会计算一串字母中不含音素的英语元音和辅音的数量：
```lean
{{#example_decl Examples/MonadTransformers/Defs.lean countLetters}}
```
<!-- It would be very easy to write `set st` instead of `set st'`.
In a large program, this kind of mistake can lead to difficult-to-diagnose bugs. -->
将 `set st` 误写成 `set st'` 非常容易。
在大型程序中，这种错误会导致难以诊断的错误。

<!-- While using a nested action for the call to `get` would solve this problem, it can't solve all such problems.
For example, a function might update a field on a structure based on the values of two other fields.
This would require two separate nested-action calls to `get`.
Because the Lean compiler contains optimizations that are only effective when there is a single reference to a value, duplicating the references to the state might lead to code that is significantly slower.
Both the potential performance problem and the potential bug can be worked around by using `modify`, which transforms the state using a function: -->
虽然使用嵌套操作来调用 `get` 可以解决这个问题，但它不能解决所有此类问题。
例如，一个函数可能会根据另外两个字段的值来更新结构体上的一个字段。
这就需要对 `get` 进行两次单独的嵌套操作调用。
由于 Lean 编译器包含的优化功能只有在对值进行单个引用时才有效，因此重复引用状态可能会导致代码速度大大降低。
使用 `modify`（即使用函数转换状态）可以解决潜在的性能问题和 bug：
```lean
{{#example_decl Examples/MonadTransformers/Defs.lean countLettersModify}}
```
<!-- The type class contains a function akin to `modify` called `modifyGet`, which allows the function to both compute a return value and transform an old state in a single step.
The function returns a pair in which the first element is the return value, and the second element is the new state; `modify` just adds the constructor of `Unit` to the pair used in `modifyGet`: -->
类型类包含一个类似于 `modify` 的函数，称为 `modifyGet`，它允许函数在一个步骤中同时计算返回值和转换旧状态。
该函数返回一个二元组，其中第一个元素是返回值，第二个元素是新状态；`modify` 只是将 `Unit` 的构造函数添加到 `modifyGet` 中使用的二元组中：
```lean
{{#example_decl Examples/MonadTransformers/Defs.lean modify}}
```

<!-- The definition of `MonadState` is as follows: -->
`MonadState` 的定义如下：
```lean
{{#example_decl Examples/MonadTransformers/Defs.lean MonadState}}
```
<!-- `PUnit` is a version of the `Unit` type that is universe-polymorphic to allow it to be in `Type u` instead of `Type`.
While it would be possible to provide a default implementation of `modifyGet` in terms of `get` and `set`, it would not admit the optimizations that make `modifyGet` useful in the first place, rendering the method useless. -->
`PUnit` 是 `Unit` 类型的一个版本，它具有宇宙多态性，允许以 `Type u` 代替 `Type`。
虽然可以用 `get` 和 `set` 来提供 `modifyGet` 的默认实现，但这样就无法进行使 `modifyGet` 有用的优化，从而使该方法变得无用。

<!-- ## `Of` Classes and `The` Functions -->
## `Of` 类和 `The` 函数

<!-- Thus far, each monad type class that takes extra information, like the type of exceptions for `MonadExcept` or the type of the state for `MonadState`, has this type of extra information as an output parameter.
For simple programs, this is generally convenient, because a monad that combines one use each of `StateT`, `ReaderT`, and `ExceptT` has only a single state type, environment type, and exception type.
As monads grow in complexity, however, they may involve multiple states or errors types.
In this case, the use of an output parameter makes it impossible to target both states in the same `do`-block. -->
到目前为止，每个需要额外信息的单子类型类，如 `MonadExcept` 的异常类型或 `MonadState` 的状态类型，都有这类额外信息作为输出参数。
对于简单的程序来说，这通常很方便，因为结合使用了 `StateT`、`ReaderT` 和 `ExceptT` 的单子只有单一的状态类型、环境类型和异常类型。
然而，随着单子的复杂性增加，它们可能会涉及多个状态或错误类型。
在这种情况下，输出参数的使用使得无法在同一个 `do` 块中同时针对两种状态。

<!-- For these cases, there are additional type classes in which the extra information is not an output parameter.
These versions of the type classes use the word `Of` in the name.
For example, `MonadStateOf` is like `MonadState`, but without an `outParam` modifier. -->
应对这些情况，还有一些额外的类型类，其中的额外信息不是输出参数。
这些版本的类型类在名称中使用了 `Of` 字样。
例如，`MonadStateOf` 与 `MonadState` 类似，但没有 `outParam` 修饰符。

<!-- Similarly, there are versions of the type class methods that accept the type of the extra information as an _explicit_, rather than implicit, argument.
For `MonadStateOf`, there are `{{#example_in Examples/MonadTransformers/Defs.lean getTheType}}` with type -->
同样，也有一些版本的类型类方法接受额外信息的类型作为 _显式_ 参数，而不是隐式参数。
对于 `MonadStateOf`，有 `{{#example_in Examples/MonadTransformers/Defs.lean getTheType}}`，类型为
```lean
{{#example_out Examples/MonadTransformers/Defs.lean getTheType}}
```
<!-- and `{{#example_in Examples/MonadTransformers/Defs.lean modifyTheType}}` with type -->
以及 `{{#example_in Examples/MonadTransformers/Defs.lean modifyTheType}}`，类型为
```lean
{{#example_out Examples/MonadTransformers/Defs.lean modifyTheType}}
```
<!-- There is no `setThe` because the type of the new state is enough to decide which surrounding state monad transformer to use. -->
没有 `setThe` 函数，因为新状态的类型足以决定使用哪个状态单子转换器。

<!-- In the Lean standard library, there are instances of the non-`Of` versions of the classes defined in terms of the instances of the versions with `Of`.
In other words, implementing the `Of` version yields implementations of both.
It's generally a good idea to implement the `Of` version, and then start writing programs using the non-`Of` versions of the class, transitioning to the `Of` version if the output parameter becomes inconvenient. -->
在 Lean 标准库中，有非 `Of` 版本的类型类实例是根据带 `Of` 版本的类型类实例定义的。
换句话说，实现 `Of` 版本可以同时实现这两个版本。
一般来说，实现 `Of` 版本是个好主意，然后开始使用类的非 `Of` 版本编写程序，如果输出参数变得不方便，就过渡到 `Of` 版本。

<!-- ## Transformers and `Id` -->
## 转换器和 `Id`

<!-- The identity monad `Id` is the monad that has no effects whatsoever, to be used in contexts that expect a monad for some reason but where none is actually necessary.
Another use of `Id` is to serve as the bottom of a stack of monad transformers.
For instance, `StateT σ Id` works just like `State σ`. -->
恒等单子 `Id` 是没有任何效果的单子，可用于上下文因某种原因需要单子，但实际上不需要的情况。
`Id` 的另一个用途是作为单子转换器栈的底层。
例如，`StateT σ Id` 的作用与 `State σ` 相同。

<!-- ## Exercises -->
## 练习

<!-- ### Monad Contract -->
### 单子约定
<!-- Using pencil and paper, check that the rules of the monad transformer contract are satisfied for each monad transformer in this section. -->
用纸笔检查本节中每个单子转换器是否符合单子转换器的规则。
<!-- ### Logging Transformer -->
### 日志转换器
<!-- Define a monad transformer version of `WithLog`.
Also define the corresponding type class `MonadWithLog`, and write a program that combines logging and exceptions. -->
定义 `WithLog` 的单子转换器版本。
同时定义相应的类型类 `MonadWithLog`，并编写一个结合日志和异常的程序。

<!-- ### Counting Files -->
### 文件计数

<!-- Modify `doug`'s monad with `StateT` such that it counts the number of directories and files seen.
At the end of execution, it should display a report like: -->
用 `StateT` 来修改 `doug` 的单子，使它能统计所看到的目录和文件的数量。
在执行结束时，它应该显示如下报告：
```
  Viewed 38 files in 5 directories.
```
