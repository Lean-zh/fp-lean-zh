import VersoManual
import FPLeanZh.Examples

open Verso.Genre Manual
open Verso Code External

open FPLeanZh

set_option verso.exampleProject "../examples"
set_option verso.exampleModule "Examples.Monads.Do"

-- {kw}`do`-Notation for Monads
#doc (Manual) "单子的 {kw}`do`-记法" =>
%%%
file := "Do"
tag := "monad-do-notation"
%%%

-- While APIs based on monads are very powerful, the explicit use of {lit}`>>=` with anonymous functions is still somewhat noisy.
-- Just as infix operators are used instead of explicit calls to {anchorName names}`HAdd.hAdd`, Lean provides a syntax for monads called _{kw}`do`-notation_ that can make programs that use monads easier to read and write.
-- This is the very same {kw}`do`-notation that is used to write programs in {anchorName names}`IO`, and {anchorName names}`IO` is also a monad.

基于单子的 API 非常强大，但显式使用 {lit}`>>=` 和匿名函数仍然有些繁琐。
正如使用中缀运算符代替显式调用 {anchorName names}`HAdd.hAdd` 一样，Lean 提供了一种称为 *{kw}`do`-记法* 的单子语法，它可以使使用单子的程序更易于阅读和编写。
这与用于编写 {anchorName names}`IO` 程序的 {kw}`do`-记法完全相同，而 {anchorName names}`IO` 也是一个单子。

-- In {ref "hello-world"}[Hello, World!], the {kw}`do` syntax is used to combine {anchorName names}`IO` actions, but the meaning of these programs is explained directly.
-- Understanding how to program with monads means that {kw}`do` can now be explained in terms of how it translates into uses of the underlying monad operators.

在 {ref "hello-world"}[Hello, World!] 中，{kw}`do` 语法用于组合 {anchorName names}`IO` 活动，但这些程序的含义是直接解释的。理解如何运用单子进行编程意味着现在可以用 {kw}`do` 来解释它如何转换为对底层单子运算符的使用。

-- The first translation of {kw}`do` is used when the only statement in the {kw}`do` is a single expression {anchorName doSugar1a}`E`.
-- In this case, the {kw}`do` is removed, so

当 {kw}`do` 中的唯一语句是单个表达式 {anchorName doSugar1a}`E` 时，会使用 {kw}`do` 的第一种翻译。
在这种情况下，{kw}`do` 被删除，因此

```anchor doSugar1a
do E
```
-- translates to
会被翻译为

```anchor doSugar1b
E
```

-- The second translation is used when the first statement of the {kw}`do` is a {kw}`let` with an arrow, binding a local variable.
-- This translates to a use of {lit}`>>=` together with a function that binds that very same variable, so

当 {kw}`do` 的第一个语句是带有箭头的 {kw}`let` 绑定一个局部变量时，则使用第二种翻译。
它会翻译为使用 {lit}`>>=` 以及绑定同一变量的函数，因此

```anchor doSugar2a
 do let x ← E₁
    Stmt
    …
    Eₙ
```
-- translates to
会被翻译为

```anchor doSugar2b
E₁ >>= fun x =>
  do Stmt
     …
     Eₙ
```

-- When the first statement of the {kw}`do` block is an expression, then it is considered to be a monadic action that returns {anchorName names}`Unit`, so the function matches the {anchorName names}`Unit` constructor and

当 {kw}`do` 块的第一个语句是一个表达式时，它会被认为是一个返回 {anchorName names}`Unit` 的单子操作，因此该函数匹配 {anchorName names}`Unit` 构造子，而

```anchor doSugar3a
  do E₁
     Stmt
     …
     Eₙ
```
-- translates to
会被翻译为

```anchor doSugar3b
E₁ >>= fun () =>
  do Stmt
     …
     Eₙ
```

-- Finally, when the first statement of the {kw}`do` block is a {kw}`let` that uses {lit}`:=`, the translated form is an ordinary let expression, so

最后，当 {kw}`do` 块的第一个语句是使用 {lit}`:=` 的 {kw}`let` 时，翻译后的形式是一个普通的 let 表达式，因此

```anchor doSugar4a
do let x := E₁
   Stmt
   …
   Eₙ
```
-- translates to
会被翻译为

```anchor doSugar4b
let x := E₁
do Stmt
   …
   Eₙ
```

-- The definition of {anchorName firstThirdFifthSeventhMonad (module := Examples.Monads.Class)}`firstThirdFifthSeventh` that uses the {anchorName firstThirdFifthSeventhMonad (module := Examples.Monads.Class)}`Monad` class looks like this:

使用 {anchorName firstThirdFifthSeventhMonad (module := Examples.Monads.Class)}`Monad` 类的 {anchorName firstThirdFifthSeventhMonad (module := Examples.Monads.Class)}`firstThirdFifthSeventh` 的定义如下：

```anchor firstThirdFifthSeventhMonad (module := Examples.Monads.Class)
def firstThirdFifthSeventh [Monad m] (lookup : List α → Nat → m α)
    (xs : List α) : m (α × α × α × α) :=
  lookup xs 0 >>= fun first =>
  lookup xs 2 >>= fun third =>
  lookup xs 4 >>= fun fifth =>
  lookup xs 6 >>= fun seventh =>
  pure (first, third, fifth, seventh)
```

-- Using {kw}`do`-notation, it becomes significantly more readable:

使用 {kw}`do`-记法，它会变得更加易读：

```anchor firstThirdFifthSeventhDo
def firstThirdFifthSeventh [Monad m] (lookup : List α → Nat → m α)
    (xs : List α) : m (α × α × α × α) := do
  let first ← lookup xs 0
  let third ← lookup xs 2
  let fifth ← lookup xs 4
  let seventh ← lookup xs 6
  pure (first, third, fifth, seventh)
```

-- Without the {anchorName mapM}`Monad` type class, the function {anchorName numberMonadicish (module := Examples.Monads)}`number` that numbers the nodes of a tree was written:

若没有 {anchorName mapM}`Monad` 类型类，则对树的节点进行编号的函数 {anchorName numberMonadicish (module := Examples.Monads)}`number` 写作如下形式：

```anchor numberMonadicish (module := Examples.Monads)
def number (t : BinTree α) : BinTree (Nat × α) :=
  let rec helper : BinTree α → State Nat (BinTree (Nat × α))
    | BinTree.leaf => ok BinTree.leaf
    | BinTree.branch left x right =>
      helper left ~~> fun numberedLeft =>
      get ~~> fun n =>
      set (n + 1) ~~> fun () =>
      helper right ~~> fun numberedRight =>
      ok (BinTree.branch numberedLeft (n, x) numberedRight)
  (helper t 0).snd
```

-- With {anchorName mapM}`Monad` and {kw}`do`, its definition is much less noisy:

有了 {anchorName mapM}`Monad` 和 {kw}`do`，其定义就简洁多了：

```anchor numberDo
def number (t : BinTree α) : BinTree (Nat × α) :=
  let rec helper : BinTree α → State Nat (BinTree (Nat × α))
    | BinTree.leaf => pure BinTree.leaf
    | BinTree.branch left x right => do
      let numberedLeft ← helper left
      let n ← get
      set (n + 1)
      let numberedRight ← helper right
      ok (BinTree.branch numberedLeft (n, x) numberedRight)
  (helper t 0).snd
```

-- All of the conveniences from {kw}`do` with {anchorName names}`IO` are also available when using it with other monads.
-- For example, nested actions also work in any monad.
-- The original definition of {anchorName mapM (module:=Examples.Monads.Class)}`mapM` was:

使用 {kw}`do` 与 {anchorName names}`IO` 的所有便利性在使用其他单子时也可用。
例如，嵌套操作也适用于任何单子。{anchorName mapM (module:=Examples.Monads.Class)}`mapM` 的原始定义为：

```anchor mapM (module := Examples.Monads.Class)
def mapM [Monad m] (f : α → m β) : List α → m (List β)
  | [] => pure []
  | x :: xs =>
    f x >>= fun hd =>
    mapM f xs >>= fun tl =>
    pure (hd :: tl)
```

-- With {kw}`do`-notation, it can be written:

使用 {kw}`do`-记法，可以写成：

```anchor mapM
def mapM [Monad m] (f : α → m β) : List α → m (List β)
  | [] => pure []
  | x :: xs => do
    let hd ← f x
    let tl ← mapM f xs
    pure (hd :: tl)
```

-- Using nested actions makes it almost as short as the original non-monadic {anchorName names}`map`:

使用嵌套操作会让它与原始非单子 {anchorName names}`map` 一样简洁：

```anchor mapMNested
def mapM [Monad m] (f : α → m β) : List α → m (List β)
  | [] => pure []
  | x :: xs => do
    pure ((← f x) :: (← mapM f xs))
```

-- Using nested actions, {anchorName numberDoShort}`number` can be made much more concise:

使用嵌套操作，{anchorName numberDoShort}`number` 可以变得更加简洁：

```anchor numberDoShort
def increment : State Nat Nat := do
  let n ← get
  set (n + 1)
  pure n

def number (t : BinTree α) : BinTree (Nat × α) :=
  let rec helper : BinTree α → State Nat (BinTree (Nat × α))
    | BinTree.leaf => pure BinTree.leaf
    | BinTree.branch left x right => do
      pure
        (BinTree.branch
          (← helper left)
          ((← increment), x)
          (← helper right))
  (helper t 0).snd
```



-- # Exercises
# 练习
%%%
tag := "monad-do-notation-exercises"
%%%

--  * Rewrite {anchorName evaluateM (module:=Examples.Monads.Class)}`evaluateM`, its helpers, and the different specific use cases using {kw}`do`-notation instead of explicit calls to {lit}`>>=`.
--  * Rewrite {anchorName firstThirdFifthSeventhDo}`firstThirdFifthSeventh` using nested actions.

 * 使用 {kw}`do`-记法而非显式调用 {lit}`>>=` 重写 {anchorName evaluateM (module:=Examples.Monads.Class)}`evaluateM`、辅助函数以及不同的特定用例。
 * 使用嵌套操作重写 {anchorName firstThirdFifthSeventhDo}`firstThirdFifthSeventh`。
