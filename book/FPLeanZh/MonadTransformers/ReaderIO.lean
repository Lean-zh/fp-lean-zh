import VersoManual
import FPLeanZh.Examples

open Verso.Genre Manual
open Verso Code External

open FPLeanZh

set_option verso.exampleProject "../examples"
set_option verso.exampleModule "DirTree"

#doc (Manual) "组合 IO 与 Reader" =>
%%%
file := "ReaderIO"
tag := "io-reader"
%%%

-- Combining IO and Reader

-- One case where a reader monad can be useful is when there is some notion of the “current configuration” of the application that is passed through many recursive calls.
-- An example of such a program is {lit}`tree`, which recursively prints the files in the current directory and its subdirectories, indicating their tree structure using characters.
-- The version of {lit}`tree` in this chapter, called {lit}`doug` after the mighty Douglas Fir tree that adorns the west coast of North America, provides the option of Unicode box-drawing characters or their ASCII equivalents when indicating directory structure.

当应用程序存在类似“当前配置”的数据需要通过多次递归调用传递时，读取器单子（Reader Monad）就会派上用场。
这种程序有一个例子是 {lit}`tree`，它递归地打印当前目录及其子目录中的文件，并用字符表示它们的树形结构。
本章中的 {lit}`tree` 版本名为 {lit}`doug` ，取自北美西海岸的道格拉斯冷杉，在显示目录结构时，它提供了 Unicode 框画字符或其 ASCII 对应字符选项。

-- For example, the following commands create a directory structure and some empty files in a directory called {lit}`doug-demo`:

例如，以下命令将在名为 {lit}`doug-demo` 的目录中创建一个目录结构和一些空文件：

```commands doug "doug-demo"
$$ cd doug-demo
$ mkdir -p a/b/c
$ mkdir -p a/d
$ mkdir -p a/e/f
$ touch a/b/hello
$ touch a/d/another-file
$ touch a/e/still-another-file-again
```
-- Running {lit}`doug` results in the following:

运行 {lit}`doug` 的结果如下：

```commands doug "doug-demo"
$ doug
├── doug-demo/
│   ├── a/
│   │   ├── b/
│   │   │   ├── c/
│   │   │   ├── hello
│   │   ├── d/
│   │   │   ├── another-file
│   │   ├── e/
│   │   │   ├── f/
│   │   │   ├── still-another-file-again
```

-- # Implementation
# 实现
%%%
tag := "reader-io-implementation"
%%%

-- Internally, {lit}`doug` passes a configuration value downwards as it recursively traverses the directory structure.
-- This configuration contains two fields: {anchorName Config}`useASCII` determines whether to use Unicode box-drawing characters or ASCII vertical line and dash characters to indicate structure, and {anchorName Config}`currentPrefix` contains a string to prepend to each line of output.
-- As the current directory deepens, the prefix string accumulates indicators of being in a directory.
-- The configuration is a structure:

在内部，{lit}`doug` 在递归遍历目录结构时会向下传递一个配置值。
该配置包含两个字段： {anchorName Config}`useASCII` 决定是否使用 Unicode 框画字符或 ASCII 垂直线和破折号字符来表示结构，而 {anchorName Config}`currentPrefix` 字段包含了一个字符串，用于在每行输出前添加。
随着当前目录的深入，前缀字符串会不断积累目录中的指标。
配置是一个结构体：

```anchor Config
structure Config where
  useASCII : Bool := false
  currentPrefix : String := ""
```
-- This structure has default definitions for both fields.
-- The default {anchorName Config}`Config` uses Unicode display with no prefix.

该结构体的两个字段都有默认定义。
默认的 {anchorName Config}`Config` 使用 Unicode 显示，不带前缀。

-- Users who invoke {lit}`doug` will need to be able to provide command-line arguments.
-- The usage information is as follows:

调用 {lit}`doug` 的用户需要提供命令行参数。
用法如下：

```anchor usage
def usage : String :=
  "Usage: doug [--ascii]
Options:
\t--ascii\tUse ASCII characters to display the directory structure"
```
-- Accordingly, a configuration can be constructed by examining a list of command-line arguments:

据此，可以通过查看命令行参数列表来构建配置：

```anchor configFromArgs
def configFromArgs : List String → Option Config
  | [] => some {} -- both fields default
  | ["--ascii"] => some {useASCII := true}
  | _ => none
```

-- The {anchorName OldMain}`main` function is a wrapper around an inner worker, called {anchorName OldMain}`dirTree`, that shows the contents of a directory using a configuration.
-- Before calling {anchorName OldMain}`dirTree`, {anchorName OldMain}`main` is responsible for processing command-line arguments.
-- It must also return the appropriate exit code to the operating system:

{anchorName OldMain}`main` 函数是一个名为 {anchorName OldMain}`dirTree` 的内部函数的包装，它根据一个配置来显示目录的内容。
在调用 {anchorName OldMain}`dirTree` 之前，{anchorName OldMain}`main` 需要处理命令行参数。
它还必须向操作系统返回适当的退出状态码：

```anchor OldMain
def main (args : List String) : IO UInt32 := do
  match configFromArgs args with
  | some config =>
    dirTree config (← IO.currentDir)
    pure 0
  | none =>
    IO.eprintln s!"Didn't understand argument(s) {" ".separate args}\n"
    IO.eprintln usage
    pure 1
```
{anchorName OldMain}`IO.eprintln` 是 {anchorName OldShowFile}`IO.println` 的一个版本，它输出到标准错误。

-- Not all paths should be shown in the directory tree.
-- In particular, files named {lit}`.` or {lit}`..` should be skipped, as they are actually features used for navigation rather than files _per se_.
-- Of those files that should be shown, there are two kinds: ordinary files and directories:

并非所有路径都应显示在目录树中。
特别是名为 {lit}`.` 或 {lit}`..` 的文件，因为它们实际上是用于导航的特殊标记，而不是文件本身。
应该显示的文件有两种：普通文件和目录：

```anchor Entry
inductive Entry where
  | file : String → Entry
  | dir : String → Entry
```
-- To determine whether a file should be shown, along with which kind of entry it is, {lit}`doug` uses {anchorName toEntry}`toEntry`:

为了确定是否要显示某个文件以及它是哪种条目，{lit}`doug` 依赖 {anchorName toEntry}`toEntry` 函数 ：

```anchor toEntry
def toEntry (path : System.FilePath) : IO (Option Entry) := do
  match path.components.getLast? with
  | none => pure (some (.dir ""))
  | some "." | some ".." => pure none
  | some name =>
    pure (some (if (← path.isDir) then .dir name else .file name))
```
-- {anchorName names}`System.FilePath.components` converts a path into a list of path components, splitting the name at directory separators.
-- If there is no last component, then the path is the root directory.
-- If the last component is a special navigation file ({lit}`.` or {lit}`..`), then the file should be excluded.
-- Otherwise, directories and files are wrapped in the corresponding constructors.

{anchorName names}`System.FilePath.components` 在目录分隔符处分割路径名，并将路径转换为路径组件的列表。
如果没有最后一个组件，那么该路径就是根目录。
如果最后一个组件是一个特殊的导航文件（{lit}`.` 或 {lit}`..`），则应排除该文件。
否则，目录和文件将被包装在相应的构造函数中。

-- Lean's logic has no way to know that directory trees are finite.
-- Indeed, some systems allow the construction of circular directory structures.
-- Thus, {anchorName OldDirTree}`dirTree` is declared {kw}`partial`:

Lean 的逻辑无法确定目录树是否有限。
事实上，有些系统允许构建循环目录结构。
因此，{anchorName OldDirTree}`dirTree` 函数必须被声明为 {kw}`partial`：

```anchor OldDirTree
partial def dirTree (cfg : Config) (path : System.FilePath) : IO Unit := do
  match ← toEntry path with
  | none => pure ()
  | some (.file name) => showFileName cfg name
  | some (.dir name) =>
    showDirName cfg name
    let contents ← path.readDir
    let newConfig := cfg.inDirectory
    doList (contents.qsort dirLT).toList fun d =>
      dirTree newConfig d.path
```
-- The call to {anchorName OldDirTree}`toEntry` is a {ref "nested-actions"}[nested action]—the parentheses are optional in positions where the arrow couldn't have any other meaning, such as {kw}`match`.
-- When the filename doesn't correspond to an entry in the tree (e.g. because it is {lit}`..`), {anchorName OldDirTree}`dirTree` does nothing.
-- When the filename points to an ordinary file, {anchorName OldDirTree}`dirTree` calls a helper to show it with the current configuration.
-- When the filename points to a directory, it is shown with a helper, and then its contents are recursively shown in a new configuration in which the prefix has been extended to account for being in a new directory.
-- The contents of the directory are sorted in order to make the output deterministic, compared according to {anchorName compareEntries'}`dirLT`.

对 {anchorName OldDirTree}`toEntry` 的调用是一个 {ref "nested-actions"}[嵌套操作] —— 在箭头没有其他含义的位置，如 {kw}`match`，括号是可以省略的。
当文件名与树中的条目不对应时（例如，因为它是 {lit}`..`），{anchorName OldDirTree}`dirTree` 什么也不做。
当文件名指向一个普通文件时，{anchorName OldDirTree}`dirTree` 会调用一个辅助函数，以当前配置来显示该文件。
当文件名指向一个目录时，将通过一个辅助函数来显示该目录，然后其内容将递归地显示在一个新的配置中，其中的前缀已被扩写，以说明它位于一个新的目录中。
目录的内容按顺序排序，以便使输出具有确定性，比较依据是 {anchorName compareEntries'}`dirLT`。

```anchor compareEntries'
def dirLT (e1 : IO.FS.DirEntry) (e2 : IO.FS.DirEntry) : Bool :=
  e1.fileName < e2.fileName
```

-- Showing the names of files and directories is achieved with {anchorName OldShowFile}`showFileName` and {anchorName OldShowFile}`showDirName`:

文件和目录的名称通过 {anchorName OldShowFile}`showFileName` 和 {anchorName OldShowFile}`showDirName` 函数来显示：

```anchor OldShowFile
def showFileName (cfg : Config) (file : String) : IO Unit := do
  IO.println (cfg.fileName file)

def showDirName (cfg : Config) (dir : String) : IO Unit := do
  IO.println (cfg.dirName dir)
```
-- Both of these helpers delegate to functions on {anchorName filenames}`Config` that take the ASCII vs Unicode setting into account:

这两个辅助函数都委托给了将 ASCII 与 Unicode 设置考虑在内的 {anchorName filenames}`Config` 上的函数：

```anchor filenames
def Config.preFile (cfg : Config) :=
  if cfg.useASCII then "|--" else "├──"

def Config.preDir (cfg : Config) :=
  if cfg.useASCII then "|  " else "│  "

def Config.fileName (cfg : Config) (file : String) : String :=
  s!"{cfg.currentPrefix}{cfg.preFile} {file}"

def Config.dirName (cfg : Config) (dir : String) : String :=
  s!"{cfg.currentPrefix}{cfg.preFile} {dir}/"
```
-- Similarly, {anchorName inDirectory}`Config.inDirectory` extends the prefix with a directory marker:

同样，{anchorName inDirectory}`Config.inDirectory` 用目录标记扩写了前缀：

```anchor inDirectory
def Config.inDirectory (cfg : Config) : Config :=
  {cfg with currentPrefix := cfg.preDir ++ " " ++ cfg.currentPrefix}
```

-- Iterating an IO action over a list of directory contents is achieved using {anchorName doList}`doList`.
-- Because {anchorName doList}`doList` carries out all the actions in a list and does not base control-flow decisions on the values returned by any of the actions, the full power of {anchorName ConfigIO}`Monad` is not necessary, and it will work for any {anchorName doList}`Applicative`:

{anchorName doList}`doList` 函数可以在目录内容的列表中迭代 IO 操作。
由于 {anchorName doList}`doList` 只执行列表中的所有操作，并不根据任何操作返回的值来决定控制流，因此不需要使用 {anchorName ConfigIO}`Monad` 的全部功能，它适用于任何 {anchorName doList}`Applicative` 应用程序：

```anchor doList
def doList [Applicative f] : List α → (α → f Unit) → f Unit
  | [], _ => pure ()
  | x :: xs, action =>
    action x *>
    doList xs action
```


-- # Using a Custom Monad
# 使用自定义单子
%%%
tag := "reader-io-custom-monad"
%%%

-- While this implementation of {lit}`doug` works, manually passing the configuration around is verbose and error-prone.
-- The type system will not catch it if the wrong configuration is passed downwards, for instance.
-- A reader effect ensures that the same configuration is passed to all recursive calls, unless it is manually overridden, and it helps make the code less verbose.

虽然这种 {lit}`doug` 实现可以正常工作，但手动传递配置不仅费事还容易出错。
例如，类型系统无法捕获向下传递的错误配置。
读取器作用不仅可以确保在所有递归调用中都传递相同的配置，而且有助于优化冗长的代码。

-- To create a version of {anchorName ConfigIO}`IO` that is also a reader of {anchorName ConfigIO}`Config`, first define the type and its {anchorName ConfigIO}`Monad` instance, following the recipe from {ref "custom-environments"}[the evaluator example]:

要创建一个同时也是 {anchorName ConfigIO}`Config` 读取器的 {anchorName ConfigIO}`IO` ，首先要按照{ref "custom-environments"}[求值器示例]中的方法定义类型及其 {anchorName ConfigIO}`Monad` 实例：

```anchor ConfigIO
def ConfigIO (α : Type) : Type :=
  Config → IO α

instance : Monad ConfigIO where
  pure x := fun _ => pure x
  bind result next := fun cfg => do
    let v ← result cfg
    next v cfg
```
-- The difference between this {anchorName ConfigIO}`Monad` instance and the one for {anchorName Reader (module := Examples.Monads.Class)}`Reader` is that this one uses {kw}`do`-notation in the {anchorName ConfigIO}`IO` monad as the body of the function that {anchorName ConfigIO}`bind` returns, rather than applying {anchorName ConfigIO}`next` directly to the value returned from {anchorName ConfigIO}`result`.
-- Any {anchorName ConfigIO}`IO` effects performed by {anchorName ConfigIO}`result` must occur before {anchorName ConfigIO}`next` is invoked, which is ensured by the {anchorName ConfigIO}`IO` monad's {anchorName ConfigIO}`bind` operator.
-- {anchorName ConfigIO}`ConfigIO` is not universe polymorphic because the underlying {anchorName ConfigIO}`IO` type is also not universe polymorphic.

这个 {anchorName ConfigIO}`Monad` 实例与 {anchorName Reader (module := Examples.Monads.Class)}`Reader` 实例的区别在于，它使用 {anchorName ConfigIO}`IO` 单子中的 {kw}`do` 标记 作为 {anchorName ConfigIO}`bind` 返回函数的主体，而不是直接将 {anchorName ConfigIO}`next` 应用于 {anchorName ConfigIO}`result` 返回的值。
由 {anchorName ConfigIO}`result` 执行的任何 {anchorName ConfigIO}`IO` 作用都必须在调用 {anchorName ConfigIO}`next` 之前发生，这一点由 {anchorName ConfigIO}`IO` 单子的 {anchorName ConfigIO}`bind` 操作符来保证。
{anchorName ConfigIO}`ConfigIO` 不是宇宙多态的，因为底层的 {anchorName ConfigIO}`IO` 类型也不是宇宙多态的。

-- Running a {anchorName ConfigIO}`ConfigIO` action involves transforming it into an {anchorName ConfigIO}`IO` action by providing it with a configuration:

运行 {anchorName ConfigIO}`ConfigIO` 操作需要向其提供一个配置，从而将其转换为 {anchorName ConfigIO}`IO` 操作：

```anchor ConfigIORun
def ConfigIO.run (action : ConfigIO α) (cfg : Config) : IO α :=
  action cfg
```
-- This function is not really necessary, as a caller could simply provide the configuration directly.
-- However, naming the operation can make it easier to see which parts of the code are intended to run in which monad.

这个函数其实并无必要，因为调用者只需直接提供配置即可。
不过，给操作命名可以让我们更容易看出代码的各部分会在哪个单子中运行。

-- The next step is to define a means of accessing the current configuration as part of {anchorName ConfigIO}`ConfigIO`:

下一步是定义访问当前配置的方法，作为 {anchorName ConfigIO}`ConfigIO` 的一部分：

```anchor currentConfig
def currentConfig : ConfigIO Config :=
  fun cfg => pure cfg
```
-- This is just like {anchorName Reader (module := Examples.Monads.Class)}`read` from {ref "custom-environments"}[the evaluator example], except it uses {anchorName ConfigIO}`IO`'s {anchorName ConfigIO}`pure` to return its value rather than doing so directly.
-- Because entering a directory modifies the current configuration for the scope of a recursive call, it will be necessary to have a way to override a configuration:

这与{ref "custom-environments"}[求值器示例]中的 {anchorName Reader (module := Examples.Monads.Class)}`read` 相同，只是它使用了 {anchorName ConfigIO}`IO` 的 {anchorName ConfigIO}`pure` 来返回其值，而不是直接返回。
因为进入一个目录会修改递归调用范围内的当前配置，因此有必要提供一种修改配置的方法：

```anchor locally
def locally (change : Config → Config) (action : ConfigIO α) : ConfigIO α :=
  fun cfg => action (change cfg)
```

-- Much of the code used in {lit}`doug` has no need for configurations, and {lit}`doug` calls ordinary Lean {anchorName ConfigIO}`IO` actions from the standard library that certainly don't need a {anchorName ConfigIO}`Config`.
-- Ordinary {anchorName ConfigIO}`IO` actions can be run using {anchorName runIO}`runIO`, which ignores the configuration argument:

{lit}`doug` 中的大部分代码都不需要配置，因此 {lit}`doug` 会从标准库中调用普通的 Lean {anchorName ConfigIO}`IO` 操作，这些操作当然也不需要 {anchorName ConfigIO}`Config`。
普通的 {anchorName ConfigIO}`IO` 操作可以使用 {anchorName runIO}`runIO` 运行，它会忽略配置参数：

```anchor runIO
def runIO (action : IO α) : ConfigIO α :=
  fun _ => action
```
-- With these components, {anchorName MedShowFileDir}`showFileName` and {anchorName MedShowFileDir}`showDirName` can be updated to take their configuration arguments implicitly through the {anchorName ConfigIO}`ConfigIO` monad.
-- They use {ref "nested-actions"}[nested actions] to retrieve the configuration, and {anchorName runIO}`runIO` to actually execute the call to {anchorName MedShowFileDir}`IO.println`:

有了这些组件，{anchorName MedShowFileDir}`showFileName` 和 {anchorName MedShowFileDir}`showDirName` 可以修改为使用 {anchorName ConfigIO}`ConfigIO` 单子来隐式获取配置参数。
它们使用 {ref "nested-actions"}[嵌套动作] 来获取配置，并使用 {anchorName runIO}`runIO` 来实际执行对 {anchorName MedShowFileDir}`IO.println` 的调用：

```anchor MedShowFileDir
def showFileName (file : String) : ConfigIO Unit := do
  runIO (IO.println ((← currentConfig).fileName file))

def showDirName (dir : String) : ConfigIO Unit := do
  runIO (IO.println ((← currentConfig).dirName dir))
```
-- In the new version of {anchorName MedDirTree}`dirTree`, the calls to {anchorName MedDirTree}`toEntry` and {anchorName MedDirTree}`readDir` are wrapped in {anchorName runIO}`runIO`.
-- Additionally, instead of building a new configuration and then requiring the programmer to keep track of which one to pass to recursive calls, it uses {anchorName MedDirTree}`locally` to naturally delimit the modified configuration to only a small region of the program, in which it is the _only_ valid configuration:

在新版的 {anchorName MedDirTree}`dirTree` 中，对 {anchorName MedDirTree}`toEntry` 和 {anchorName MedDirTree}`readDir` 的调用被封装在 {anchorName runIO}`runIO` 中。
此外，它不再构建一个新的配置，然后要求程序员跟踪将哪个配置传递给递归调用，而是使用 {anchorName MedDirTree}`locally` 自然地将修改后的配置限定在程序的一小块区域内，在该区域内，它是 _唯一_ 有效的配置：

```anchor MedDirTree
partial def dirTree (path : System.FilePath) : ConfigIO Unit := do
  match ← runIO (toEntry path) with
    | none => pure ()
    | some (.file name) => showFileName name
    | some (.dir name) =>
      showDirName name
      let contents ← runIO path.readDir
      locally (·.inDirectory)
        (doList (contents.qsort dirLT).toList fun d =>
          dirTree d.path)
```
-- The new version of {anchorName MedMain}`main` uses {anchorName ConfigIORun}`ConfigIO.run` to invoke {anchorName MedMain}`dirTree` with the initial configuration:

新版本的 {anchorName MedMain}`main` 使用 {anchorName ConfigIORun}`ConfigIO.run` 来调用带有初始配置的 {anchorName MedMain}`dirTree`：

```anchor MedMain
def main (args : List String) : IO UInt32 := do
    match configFromArgs args with
    | some config =>
      (dirTree (← IO.currentDir)).run config
      pure 0
    | none =>
      IO.eprintln s!"Didn't understand argument(s) {" ".separate args}\n"
      IO.eprintln usage
      pure 1
```
-- This custom monad has a number of advantages over passing configurations manually:

--  1. It is easier to ensure that configurations are passed down unchanged, except when changes are desired
--  2. The concern of passing the configuration onwards is more clearly separated from the concern of printing directory contents
--  3. As the program grows, there will be more and more intermediate layers that do nothing with configurations except propagate them, and these layers don't need to be rewritten as the configuration logic changes

-- However, there are also some clear downsides:

--  1. As the program evolves and the monad requires more features, each of the basic operators such as {anchorName locally}`locally` and {anchorName currentConfig}`currentConfig` will need to be updated
--  2. Wrapping ordinary {anchorName ConfigIO}`IO` actions in {anchorName runIO}`runIO` is noisy and distracts from the flow of the program
--  3. Writing monads instances by hand is repetitive, and the technique for adding a reader effect to another monad is a design pattern that requires documentation and communication overhead

-- Using a technique called _monad transformers_, all of these downsides can be addressed.
-- A monad transformer takes a monad as an argument and returns a new monad.
-- Monad transformers consist of:
--  1. A definition of the transformer itself, which is typically a function from types to types
--  2. A {anchorName ConfigIO}`Monad` instance that assumes the inner type is already a monad
--  3. An operator to “lift” an action from the inner monad to the transformed monad, akin to {anchorName runIO}`runIO`

与手动传递配置相比，这种自定义单子有很多优点：

 1. 能更容易确保配置被原封不动地向下传递，除非需要更改
 2. 传递配置与打印目录内容之间的关系更加清晰
 3. 随着程序的增长，除了传播配置外，将有越来越多的中间层无需对配置进行处理，这些层并不需要随着配置逻辑的变化而重写。

不过，也有一些明显的缺点：

 1. 随着程序的发展和单子需要更多功能，比如 {anchorName locally}`locally` 和 {anchorName currentConfig}`currentConfig` 等基本算子都需要更新。
 2. 将普通的 {anchorName ConfigIO}`IO` 操作封装在 {anchorName runIO}`runIO` 中会产生语法噪音，影响程序的流畅性
 3. 手写单子实例是重复性的工作，而且向另一个单子添加读取器作用的技术是一种依赖文档和交流开销的设计模式

使用一种名为 _单子转换器_ 的技术，可以解决所有这些弊端。
单子转换器以一个单子作为参数，并返回一个新的单子。
单子转换器包括：
 1. 转换器本身的定义，通常是一个从类型到类型的函数
 2. 假定内部类型已经是一个单子的 {anchorName ConfigIO}`Monad` 实例
 3. 从内部单子“提升”一个操作到转换后的单元的操作符，类似于 {anchorName runIO}`runIO`.

-- # Adding a Reader to Any Monad
# 将读取器添加到任意单子
%%%
tag := "ReaderT"
%%%

-- Adding a reader effect to {anchorName ConfigIO}`IO` was accomplished in {anchorName ConfigIO}`ConfigIO` by wrapping {anchorTerm ConfigIO}`IO α` in a function type.
-- The Lean standard library contains a function that can do this to _any_ polymorphic type, called {anchorName MyReaderT}`ReaderT`:

在 {anchorName ConfigIO}`ConfigIO`中，通过将 {anchorTerm ConfigIO}`IO α` 包装成一个函数类型，为 {anchorName ConfigIO}`IO` 添加了读取器作用。
Lean 的标准库有一个函数，可以对 _任意_ 多态类型执行此操作，称为 {anchorName MyReaderT}`ReaderT`：

```anchor MyReaderT
def ReaderT (ρ : Type u) (m : Type u → Type v) (α : Type u) :
    Type (max u v) :=
  ρ → m α
```
-- Its arguments are as follows:
--  * {anchorName MyReaderT}`ρ` is the environment that is accessible to the reader
--  * {anchorName MyReaderT}`m` is the monad that is being transformed, such as {anchorName ConfigIO}`IO`
--  * {anchorName MyReaderT}`α` is the type of values being returned by the monadic computation
-- Both {anchorName MyReaderT}`α` and {anchorName MyReaderT}`ρ` are in the same universe because the operator that retrieves the environment in the monad will have type {anchorTerm MyReaderTread}`m ρ`.

它的参数如下:
 * {anchorName MyReaderT}`ρ` 是读取器可以访问的环境
 * {anchorName MyReaderT}`m` 是被转换的单子，例如 {anchorName ConfigIO}`IO`
 * {anchorName MyReaderT}`α` 是单子计算返回值的类型
{anchorName MyReaderT}`α` 和 {anchorName MyReaderT}`ρ` 都在同一个宇宙中，因为在单子中检索环境的算子将具有 {anchorTerm MyReaderTread}`m ρ` 类型。

-- With {anchorName MyReaderT}`ReaderT`, {anchorName ConfigIO}`ConfigIO` becomes:

有了 {anchorName MyReaderT}`ReaderT`，{anchorName ConfigIO}`ConfigIO` 就变成了:

```anchor ReaderTConfigIO
abbrev ConfigIO (α : Type) : Type := ReaderT Config IO α
```
-- It is an {kw}`abbrev` because {anchorName ReaderTConfigIO}`ReaderT` has many useful features defined in the standard library that a non-reducible definition would hide.
-- Rather than taking responsibility for making these work directly for {anchorName ConfigIO}`ConfigIO`, it's easier to simply have {anchorName ReaderTConfigIO}`ConfigIO` behave identically to {anchorTerm ReaderTConfigIO}`ReaderT Config IO`.

它是一个 {kw}`abbrev`，因为在标准库中定义了许多关于 {anchorName ReaderTConfigIO}`ReaderT` 的有用功能，而不可归约的定义会隐藏这些功能。
与其让 {anchorName ConfigIO}`ConfigIO` 直接使用这些功能，不如让 {anchorName ReaderTConfigIO}`ConfigIO` 的行为与 {anchorTerm ReaderTConfigIO}`ReaderT Config IO` 保持一致。

-- The manually-written {anchorName currentConfig}`currentConfig` obtained the environment out of the reader.
-- This effect can be defined in a generic form for all uses of {anchorName MyReaderTread}`ReaderT`, under the name {anchorName MonadReader}`read`:

手动编写的 {anchorName currentConfig}`currentConfig` 从读取器中获取了环境。
这种作用可以以通用形式定义，适用于 {anchorName MyReaderTread}`ReaderT` 的所有用途，名为 {anchorName MonadReader}`read`：

```anchor MyReaderTread
def read [Monad m] : ReaderT ρ m ρ :=
   fun env => pure env
```
-- However, not every monad that provides a reader effect is built with {anchorName MyReaderT}`ReaderT`.
-- The type class {anchorName MonadReader}`MonadReader` allows any monad to provide a {anchorName MonadReader}`read` operator:

然而，并不是每个提供读取器作用的单子都是用 {anchorName MyReaderT}`ReaderT` 构建的。
类型类 {anchorName MonadReader}`MonadReader` 允许任何单子提供 {anchorName MonadReader}`read` 操作符：

```anchor MonadReader
class MonadReader (ρ : outParam (Type u)) (m : Type u → Type v) :
    Type (max (u + 1) v) where
  read : m ρ

instance [Monad m] : MonadReader ρ (ReaderT ρ m) where
  read := fun env => pure env

export MonadReader (read)
```
-- The type {anchorName MonadReader}`ρ` is an output parameter because any given monad typically only provides a single type of environment through a reader, so automatically selecting it when the monad is known makes programs more convenient to write.

类型 {anchorName MonadReader}`ρ` 是一个输出参数，因为任何给定的单子通常只通过读取器提供单一类型的环境，所以在已知单子时自动选择它可以使程序编写更方便。

-- The {anchorName ConfigIO}`Monad` instance for {anchorName MyReaderT}`ReaderT` is essentially the same as the {anchorName ConfigIO}`Monad` instance for {anchorName ConfigIO}`ConfigIO`, except {anchorName ConfigIO}`IO` has been replaced by some arbitrary monad argument {anchorName MonadMyReaderT}`m`:

{anchorName MyReaderT}`ReaderT` 的 {anchorName ConfigIO}`Monad` 实例与 {anchorName ConfigIO}`ConfigIO` 的 {anchorName ConfigIO}`Monad` 实例基本相同，只是 {anchorName ConfigIO}`IO` 被某个表示任意单子的参数 {anchorName MonadMyReaderT}`m` 所取代:

```anchor MonadMyReaderT
instance [Monad m] : Monad (ReaderT ρ m) where
  pure x := fun _ => pure x
  bind result next := fun env => do
    let v ← result env
    next v env
```


-- The next step is to eliminate uses of {anchorName runIO}`runIO`.
-- When Lean encounters a mismatch in monad types, it automatically attempts to use a type class called {anchorName MyMonadLift}`MonadLift` to transform the actual monad into the expected monad.
-- This process is similar to the use of coercions.
-- {anchorName MyMonadLift}`MonadLift` is defined as follows:

下一步是消除对 {anchorName runIO}`runIO` 的使用。
当 Lean 遇到单子类型不匹配时，它会自动尝试使用名为 {anchorName MyMonadLift}`MonadLift` 的类型类，将实际的单子转换为预期单子。
这一过程与使用强制转换相似。
{anchorName MyMonadLift}`MonadLift` 的定义如下：

```anchor MyMonadLift
class MonadLift (m : Type u → Type v) (n : Type u → Type w) where
  monadLift : {α : Type u} → m α → n α
```
-- The method {anchorName MyMonadLift}`monadLift` translates from the monad {anchorName MyMonadLift}`m` to the monad {anchorName MyMonadLift}`n`.
-- The process is called “lifting” because it takes an action in the embedded monad and makes it into an action in the surrounding monad.
-- In this case, it will be used to “lift” from {anchorName ConfigIO}`IO` to {anchorTerm ReaderTConfigIO}`ReaderT Config IO`, though the instance works for _any_ inner monad {anchorName MonadLiftReaderT}`m`:

方法 {anchorName MyMonadLift}`monadLift` 可以将单子 {anchorName MyMonadLift}`m` 转换为单子 {anchorName MyMonadLift}`n`。
这个过程被称为“提升”，因为它将嵌入到单子中的动作转换成周围单子中的动作。
在本例中，它将用于把 {anchorName ConfigIO}`IO` “提升”到 {anchorTerm ReaderTConfigIO}`ReaderT Config IO`，尽管该实例适用于 _任何_ 内部单子 {anchorName MonadLiftReaderT}`m`：

```anchor MonadLiftReaderT
instance : MonadLift m (ReaderT ρ m) where
  monadLift action := fun _ => action
```
-- The implementation of {anchorName MonadLiftReaderT}`monadLift` is very similar to that of {anchorName runIO}`runIO`.
-- Indeed, it is enough to define {anchorName showFileAndDir}`showFileName` and {anchorName showFileAndDir}`showDirName` without using {anchorName runIO}`runIO`:

{anchorName MonadLiftReaderT}`monadLift` 的实现与 {anchorName runIO}`runIO` 非常相似。
事实上，只需定义 {anchorName showFileAndDir}`showFileName` 和 {anchorName showFileAndDir}`showDirName` 即可，无需使用 {anchorName runIO}`runIO`：

```anchor showFileAndDir
def showFileName (file : String) : ConfigIO Unit := do
  IO.println s!"{(← read).currentPrefix} {file}"

def showDirName (dir : String) : ConfigIO Unit := do
  IO.println s!"{(← read).currentPrefix} {dir}/"
```

-- One final operation from the original {anchorName ConfigIO}`ConfigIO` remains to be translated to a use of {anchorName MyReaderT}`ReaderT`: {anchorName locally}`locally`.
-- The definition can be translated directly to {anchorName MyReaderT}`ReaderT`, but the Lean standard library provides a more general version.
-- The standard version is called {anchorName MyMonadWithReader}`withReader`, and it is part of a type class called {anchorName MyMonadWithReader}`MonadWithReader`:

原版 {anchorName ConfigIO}`ConfigIO` 中的最后一个操作还需要翻译成 {anchorName MyReaderT}`ReaderT` 的形式：{anchorName locally}`locally`。
该定义可以直接翻译为 {anchorName MyReaderT}`ReaderT`，但 Lean 标准库提供了一个更通用的版本。
标准版本被称为 {anchorName MyMonadWithReader}`withReader`，它是名为 {anchorName MyMonadWithReader}`MonadWithReader` 的类型类的一部分：

```anchor MyMonadWithReader
class MonadWithReader (ρ : outParam (Type u)) (m : Type u → Type v) where
  withReader {α : Type u} : (ρ → ρ) → m α → m α
```
-- Just as in {anchorName MonadReader}`MonadReader`, the environment {anchorName MyMonadWithReader}`ρ` is an {anchorName MyMonadWithReader}`outParam`.
-- The {anchorName exportWithReader}`withReader` operation is exported, so that it doesn't need to be written with the type class name before it:

正如在 {anchorName MonadReader}`MonadReader` 中一样，环境 {anchorName MyMonadWithReader}`ρ` 是一个 {anchorName MyMonadWithReader}`outParam`。
{anchorName exportWithReader}`withReader` 操作是被导出的，所以在编写时不需要在前面加上类型类名：

```anchor exportWithReader
export MonadWithReader (withReader)
```
-- The instance for {anchorName ReaderTWithReader}`ReaderT` is essentially the same as the definition of {anchorName locally}`locally`:

{anchorName ReaderTWithReader}`ReaderT` 的实例与 {anchorName locally}`locally` 的定义基本相同：

```anchor ReaderTWithReader
instance : MonadWithReader ρ (ReaderT ρ m) where
  withReader change action :=
    fun cfg => action (change cfg)
```

-- With these definitions in place, the new version of {anchorName readerTDirTree}`dirTree` can be written:

有了这些定义,我们便可以定义新版本的 {anchorName readerTDirTree}`dirTree`:

```anchor readerTDirTree
partial def dirTree (path : System.FilePath) : ConfigIO Unit := do
  match ← toEntry path with
    | none => pure ()
    | some (.file name) => showFileName name
    | some (.dir name) =>
      showDirName name
      let contents ← path.readDir
      withReader (·.inDirectory)
        (doList (contents.qsort dirLT).toList fun d =>
          dirTree d.path)
```
-- Aside from replacing {anchorName locally}`locally` with {anchorName readerTDirTree}`withReader`, it is the same as before.

除了用 {anchorName readerTDirTree}`withReader` 替换 {anchorName locally}`locally` 外，其他内容保持不变。


-- Replacing the custom {anchorName ConfigIO}`ConfigIO` type with {anchorName MonadMyReaderT}`ReaderT` did not save a large number of lines of code in this section.
-- However, rewriting the code using components from the standard library does have long-term benefits.
-- First, readers who know about {anchorName MyReaderT}`ReaderT` don't need to take time to understand the {anchorName ConfigIO}`Monad` instance for {anchorName ConfigIO}`ConfigIO`, working backwards to the meaning of monad itself.
-- Instead, they can be confident in their initial understanding.
-- Next, adding further effects to the monad (such as a state effect to count the files in each directory and display a count at the end) requires far fewer changes to the code, because the monad transformers and {anchorName MonadLiftReaderT}`MonadLift` instances provided in the library work well together.
-- Finally, using a set of type classes included in the standard library, polymorphic code can be written in such a way that it can work with a variety of monads without having to care about details like the order in which the monad transformers were applied.
-- Just as some functions work in any monad, others can work in any monad that provides a certain type of state, or a certain type of exceptions, without having to specifically describe the _way_ in which a particular concrete monad provides the state or exceptions.

在本节中，用 {anchorName MonadMyReaderT}`ReaderT` 代替自定义的 {anchorName ConfigIO}`ConfigIO` 类型并没有节省大量代码行数。
不过，使用标准库中的组件重写代码确实有长远的好处。
首先，了解 {anchorName MyReaderT}`ReaderT` 的读者不需要花时间去理解 {anchorName ConfigIO}`ConfigIO` 的 {anchorName ConfigIO}`Monad` 实例，也不需要逆向理解单子本身的含义。
相反，他们可以沿用自己的初步理解。
接下来，给单子添加更多的作用（例如计算每个目录中的文件并在最后显示计数的状态作用）所需的代码改动要少得多，因为库中提供的单子转换器和 {anchorName MonadLiftReaderT}`MonadLift` 实例配合得很好。
最后，使用标准库中包含的一组类型类，多态代码的编写方式可以使其适用于各种单子，而无需关心单子转换器的应用顺序等细节。
正如某些函数可以在任何单子中工作一样，另一些函数也可以在任何提供特定类型状态或特定类型异常的单子中工作，而不必特别描述特定的具体单子提供状态或异常的 _方式_。

-- # Exercises
# 练习
%%%
tag := "reader-io-exercises"
%%%

-- ## Controlling the Display of Dotfiles
## 控制点文件的显示
%%%
tag := "controlling-dotfiles"
%%%

-- Files whose names begin with a dot character ({lit}`'.'`) typically represent files that should usually be hidden, such as source-control metadata and configuration files.
-- Modify {lit}`doug` with an option to show or hide filenames that begin with a dot.
-- This option should be controlled with a {lit}`-a` command-line option.

文件名以点字符 ({lit}`'.'`) 开头的文件通常代表隐藏文件，如源代码管理的元数据和配置文件。
修改 {lit}`doug` 并加入一个选项，以显示或隐藏以点开头的文件名。
应使用命令行选项 {lit}`-a` 来控制该选项。

-- ## Starting Directory as Argument
## 起始目录作为参数
%%%
tag := "starting-directory"
%%%

-- Modify {lit}`doug` so that it takes a starting directory as an additional command-line argument.

修改 {lit}`doug` ，使其可以将起始目录作为额外的命令行参数。
