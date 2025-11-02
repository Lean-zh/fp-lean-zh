import VersoManual
import FPLeanZh.Examples

open Verso.Genre Manual
open Verso Code External

open FPLeanZh

set_option verso.exampleProject "../examples"
set_option verso.exampleModule "Examples.Monads.IO"

-- The IO Monad
#doc (Manual) "IO 单子" =>
%%%
file := "IO"
tag := "io-monad"
%%%


-- {anchorName names}`IO` as a monad can be understood from two perspectives, which were described in the section on {ref "running-a-program"}[running programs].
-- Each can help to understand the meanings of {anchorName names}`pure` and {anchorName names}`bind` for {anchorName names}`IO`.

{anchorName names}`IO` 作为单子可以从两个角度理解，这在 [运行程序](running-a-program) 一节中进行了描述。
每个角度都可以帮助理解 `IO` 的 `pure` 和 `bind` 的含义。

-- From the first perspective, an {anchorName names}`IO` action is an instruction to Lean's run-time system.
-- For example, the instruction might be "read a string from this file descriptor, then re-invoke the pure Lean code with the string".
-- This perspective is an _exterior_ one, viewing the program from the perspective of the operating system.
-- In this case, {anchorName names}`pure` is an {anchorName names}`IO` action that does not request any effects from the RTS, and {anchorName names}`bind` instructs the RTS to first carry out one potentially-effectful operation and then invoke the rest of the program with the resulting value.

从第一个视角看，`IO` 活动是 Lean 运行时系统的指令。
例如，指令可能是「从该文件描述符读取字符串，然后使用该字符串重新调用纯 Lean 代码」。
这是一种 *外部* 的视角，即从操作系统的视角看待程序。
在这种情况下，`pure` 是一个不请求 RTS 产生任何作用的 `IO` 活动，
而 `bind` 指示 RTS 首先执行一个产生潜在作用的操作，然后使用结果值调用程序的其余部分。

-- From the second perspective, an {anchorName names}`IO` action transforms the whole world.
-- {anchorName names}`IO` actions are actually pure, because they receive a unique world as an argument and then return the changed world.
-- This perspective is an _interior_ one that matches how {anchorName names}`IO` is represented inside of Lean.
-- The world is represented in Lean as a token, and the {anchorName names}`IO` monad is structured to make sure that each token is used exactly once.

从第二个视角看，`IO` 活动会变换整个世界。`IO` 活动实际上是纯（Pure）的，
因为它接受一个唯一的世界作为参数，然后返回改变后的世界。
这是一种 *内部* 的视角，它对应了 `IO` 在 Lean 中的表示方式。
世界在 Lean 中表示为一个标记，而 `IO` 单子的结构化可以确保标记刚好使用一次。

-- To see how this works, it can be helpful to peel back one definition at a time.
-- The {kw}`#print` command reveals the internals of Lean datatypes and definitions.
-- For example,

为了了解其工作原理，逐层解析它的定义会很有帮助。
{kw}`#print` 命令揭示了 Lean 数据类型和定义的内部结构。例如，

```anchor printNat
#print Nat
```
-- results in

的结果为

```anchorInfo printNat
inductive Nat : Type
number of parameters: 0
constructors:
Nat.zero : Nat
Nat.succ : Nat → Nat
```
-- and

而

```anchor printCharIsAlpha
#print Char.isAlpha
```
-- results in

的结果为

```anchorInfo printCharIsAlpha
def Char.isAlpha : Char → Bool :=
fun c => c.isUpper || c.isLower
```

-- Sometimes, the output of {kw}`#print` includes Lean features that have not yet been presented in this book.
-- For example,

有时，`#print` 的输出包含了本书中尚未展示的 Lean 特性。例如，

```anchor printListIsEmpty
#print List.isEmpty
```
-- produces

会产生

```anchorInfo printListIsEmpty
def List.isEmpty.{u} : {α : Type u} → List α → Bool :=
fun {α} x =>
  match x with
  | [] => true
  | head :: tail => false
```
-- which includes a {lit}`.{u}` after the definition's name, and annotates types as {anchorTerm names}`Type u` rather than just {anchorTerm names}`Type`.
-- This can be safely ignored for now.

它在定义名的后面包含了一个 `.{u}`，并将类型标注为 `Type u` 而非只是 `Type`。
目前可以安全地忽略它。

-- Printing the definition of {anchorName names}`IO` shows that it's defined in terms of simpler structures:

打印 `IO` 的定义表明它是根据更简单的结构定义的：

```anchor printIO
#print IO
```
```anchorInfo printIO
@[reducible] def IO : Type → Type :=
EIO IO.Error
```
-- {anchorName printIOError}`IO.Error` represents all the errors that could be thrown by an {anchorName names}`IO` action:

`IO.Error` 表示 `IO` 活动可能抛出的所有错误：

```anchor printIOError
#print IO.Error
```
```anchorInfo printIOError
inductive IO.Error : Type
number of parameters: 0
constructors:
IO.Error.alreadyExists : Option String → UInt32 → String → IO.Error
IO.Error.otherError : UInt32 → String → IO.Error
IO.Error.resourceBusy : UInt32 → String → IO.Error
IO.Error.resourceVanished : UInt32 → String → IO.Error
IO.Error.unsupportedOperation : UInt32 → String → IO.Error
IO.Error.hardwareFault : UInt32 → String → IO.Error
IO.Error.unsatisfiedConstraints : UInt32 → String → IO.Error
IO.Error.illegalOperation : UInt32 → String → IO.Error
IO.Error.protocolError : UInt32 → String → IO.Error
IO.Error.timeExpired : UInt32 → String → IO.Error
IO.Error.interrupted : String → UInt32 → String → IO.Error
IO.Error.noFileOrDirectory : String → UInt32 → String → IO.Error
IO.Error.invalidArgument : Option String → UInt32 → String → IO.Error
IO.Error.permissionDenied : Option String → UInt32 → String → IO.Error
IO.Error.resourceExhausted : Option String → UInt32 → String → IO.Error
IO.Error.inappropriateType : Option String → UInt32 → String → IO.Error
IO.Error.noSuchThing : Option String → UInt32 → String → IO.Error
IO.Error.unexpectedEof : IO.Error
IO.Error.userError : String → IO.Error
```
-- {anchorTerm names}`EIO ε α` represents {anchorName names}`IO` actions that will either terminate with an error of type {anchorName names}`ε` or succeed with a value of type {anchorName names}`α`.
-- This means that, like the {anchorTerm names}`Except ε` monad, the {anchorName names}`IO` monad includes the ability to define error handling and exceptions.

`EIO ε α` 表示一个 `IO` 活动，它将以类型为 `ε` 的错误表示终止，或者以类型为 `α` 的值表示成功。
这意味着，与 `Except ε` 单子一样，`IO` 单子也包括定义错误处理和异常的能力。

-- Peeling back another layer, {anchorName names}`EIO` is itself defined in terms of a simpler structure:

剥离另一层，`EIO` 本身又是根据更简单的结构定义的：

```anchor printEIO
#print EIO
```
```anchorInfo printEIO
def EIO : Type → Type → Type :=
fun ε => EStateM ε IO.RealWorld
```
-- The {anchorName printEStateM}`EStateM` monad includes both errors and state—it's a combination of {anchorName names}`Except` and {anchorName State (module := Examples.Monads)}`State`.
-- It is defined using another type, {anchorName printEStateMResult}`EStateM.Result`:

`EStateM` 单子同时包括错误和状态——它是 `Except` 和 `State` 的组合。
它使用另一个类型 `EStateM.Result` 定义：

```anchor printEStateM
#print EStateM
```
```anchorInfo printEStateM
def EStateM.{u} : Type u → Type u → Type u → Type u :=
fun ε σ α => σ → EStateM.Result ε σ α
```
-- In other words, a program with type {anchorTerm EStateMNames}`EStateM ε σ α` is a function that accepts an initial state of type {anchorName EStateMNames}`σ` and returns an {anchorTerm EStateMNames}`EStateM.Result ε σ α`.

换句话说，类型为 `EStateM ε σ α` 的程序是一个函数，
它接受类型为 `σ` 的初始状态并返回一个 `EStateM.Result ε σ α`。

-- {anchorName EStateMNames}`EStateM.Result` is very much like the definition of {anchorName names}`Except`, with one constructor that indicates a successful termination and one constructor that indicates an error:

`EStateM.Result` 与 `Except` 的定义非常相似，一个构造子表示成功终止，
另一个构造子表示错误：

```anchor printEStateMResult
#print EStateM.Result
```
```anchorInfo printEStateMResult
inductive EStateM.Result.{u} : Type u → Type u → Type u → Type u
number of parameters: 3
constructors:
EStateM.Result.ok : {ε σ α : Type u} → α → σ → EStateM.Result ε σ α
EStateM.Result.error : {ε σ α : Type u} → ε → σ → EStateM.Result ε σ α
```
-- Just like {anchorTerm Except (module:=Examples.Monads)}`Except ε α`, the {anchorName names (show := ok)}`EStateM.Result.ok` constructor includes a result of type {anchorName Except (module:=Examples.Monads)}`α`, and the {anchorName names (show := error)}`EStateM.Result.error` constructor includes an exception of type {anchorName Except (module:=Examples.Monads)}`ε`.
-- Unlike {anchorName names}`Except`, both constructors have an additional state field that includes the final state of the computation.

就像 `Except ε α` 一样，`ok` 构造子包含类型为 `α` 的结果，
`error` 构造子包含类型为 `ε` 的异常。与 `Except` 不同，
这两个构造子都有一个附加的状态字段，其中包含计算的最终状态。

-- The {anchorName names}`Monad` instance for {anchorTerm names}`EStateM ε σ` requires {anchorName names}`pure` and {anchorName names}`bind`.
-- Just as with {anchorName State (module := Examples.Monads)}`State`, the implementation of {anchorName names}`pure` for {anchorName names}`EStateM` accepts an initial state and returns it unchanged, and just as with {anchorName names}`Except`, it returns its argument in the {anchorName names (show := ok)}`EStateM.Result.ok` constructor:

`EStateM ε σ` 的 `Monad` 实例需要 `pure` 和 `bind`。
与 `State` 一样，`EStateM` 的 `pure` 实现接受一个初始状态并将其返回而不改变，
并且与 `Except` 一样，它在 `ok` 构造子中返回其参数：

```anchor printEStateMpure
#print EStateM.pure
```
```anchorInfo printEStateMpure
protected def EStateM.pure.{u} : {ε σ α : Type u} → α → EStateM ε σ α :=
fun {ε σ α} a s => EStateM.Result.ok a s
```
-- {kw}`protected` means that the full name {anchorName printEStateMpure}`EStateM.pure` is needed even if the {anchorName names}`EStateM` namespace has been opened.

`protected` 意味着即使打开了 `EStateM` 命名空间，也需要完整的名称 `EStateM.pure`。

-- Similarly, {anchorName names}`bind` for {anchorName names}`EStateM` takes an initial state as an argument.
-- It passes this initial state to its first action.
-- Like {anchorName names}`bind` for {anchorName names}`Except`, it then checks whether the result is an error.
-- If so, the error is returned unchanged and the second argument to {anchorName names}`bind` remains unused.
-- If the result was a success, then the second argument is applied to both the returned value and to the resulting state.

类似地，`EStateM` 的 `bind` 将初始状态作为参数。它将此初始状态传递给其第一个操作。
与 `Except` 的 `bind` 一样，它然后检查结果是否为错误。如果是，则错误将保持不变，
并且 `bind` 的第二个参数保持未使用。如果结果成功，则将第二个参数应用于返回值和结果状态。

```anchor printEStateMbind
#print EStateM.bind
```
```anchorInfo printEStateMbind
protected def EStateM.bind.{u} : {ε σ α β : Type u} → EStateM ε σ α → (α → EStateM ε σ β) → EStateM ε σ β :=
fun {ε σ α β} x f s =>
  match x s with
  | EStateM.Result.ok a s => f a s
  | EStateM.Result.error e s => EStateM.Result.error e s
```

-- Putting all of this together, {anchorName names}`IO` is a monad that tracks state and errors at the same time.
-- The collection of available errors is that given by the datatype {anchorName printIOError}`IO.Error`, which has constructors that describe many things that can go wrong in a program.
-- The state is a type that represents the real world, called {anchorTerm printRealWorld}`IO.RealWorld`.
-- Each basic {anchorName names}`IO` action receives this real world and returns another one, paired either with an error or a result.
-- In {anchorName names}`IO`, {anchorName names}`pure` returns the world unchanged, while {anchorName names}`bind` passes the modified world from one action into the next action.

综上所述，`IO` 是同时跟踪状态和错误的单子。可用错误的集合由数据类型 `IO.Error` 给出，
该数据类型具有描述程序中可能出错的许多情况的构造子。状态是一种表示现实世界的类型，
称为 `IO.RealWorld`。每个基本的 `IO` 活动都会接收这个现实世界并返回另一个，与错误或结果配对。
在 `IO` 中，`pure` 返回未更改的世界，而 `bind` 将修改后的世界从一个活动传递到下一个活动。

-- Because the entire universe doesn't fit in a computer's memory, the world being passed around is just a representation.
-- So long as world tokens are not re-used, the representation is safe.
-- This means that world tokens do not need to contain any data at all:

由于计算机内存无法容纳整个宇宙，因此传递的世界仅仅是一种表示。
只要不重复使用世界标记，该表示就是安全的。这意味着世界标记根本不需要包含任何数据：

```anchor printRealWorld
#print IO.RealWorld
```
```anchorInfo printRealWorld
def IO.RealWorld : Type :=
Unit
```
