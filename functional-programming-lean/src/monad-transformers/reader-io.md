<!-- # Combining IO and Reader -->
# 组合 IO 与 Reader

<!-- One case where a reader monad can be useful is when there is some notion of the "current configuration" of the application that is passed through many recursive calls.
An example of such a program is `tree`, which recursively prints the files in the current directory and its subdirectories, indicating their tree structure using characters.
The version of `tree` in this chapter, called `doug` after the mighty Douglas Fir tree that adorns the west coast of North America, provides the option of Unicode box-drawing characters or their ASCII equivalents when indicating directory structure. -->

当应用程序存在类似“当前配置”的数据需要通过多次递归调用传递时，读取器单子（Reader Monad）就会派上用场。
这种程序有一个例子是 `tree`，它递归地打印当前目录及其子目录中的文件，并用字符表示它们的树形结构。
本章中的 `tree` 版本名为 `doug` ，取自北美西海岸的道格拉斯冷杉，在显示目录结构时，它提供了 Unicode 框画字符或其 ASCII 对应字符选项。

<!-- For example, the following commands create a directory structure and some empty files in a directory called `doug-demo`: -->

例如，以下命令将在名为 `doug-demo` 的目录中创建一个目录结构和一些空文件：
```
$ cd doug-demo
$ {{#command {doug-demo} {doug} {mkdir -p a/b/c} }}
$ {{#command {doug-demo} {doug} {mkdir -p a/d} }}
$ {{#command {doug-demo} {doug} {mkdir -p a/e/f} }}
$ {{#command {doug-demo} {doug} {touch a/b/hello} }}
$ {{#command {doug-demo} {doug} {touch a/d/another-file} }}
$ {{#command {doug-demo} {doug} {touch a/e/still-another-file-again} }}
```
<!-- Running `doug` results in the following: -->
运行 `doug` 的结果如下：
```
$ {{#command {doug-demo} {doug} {doug} }}
{{#command_out {doug} {doug} }}
```

<!-- ## Implementation -->
## 实现

<!-- Internally, `doug` passes a configuration value downwards as it recursively traverses the directory structure.
This configuration contains two fields: `useASCII` determines whether to use Unicode box-drawing characters or ASCII vertical line and dash characters to indicate structure, and `currentPrefix` contains a string to prepend to each line of output. -->
在内部，`doug` 在递归遍历目录结构时会向下传递一个配置值。
该配置包含两个字段： `useASCII` 决定是否使用 Unicode 框画字符或 ASCII 垂直线和破折号字符来表示结构，而 `currentPrefix` 字段包含了一个字符串，用于在每行输出前添加。

<!-- As the current directory deepens, the prefix string accumulates indicators of being in a directory.
The configuration is a structure: -->
随着当前目录的深入，前缀字符串会不断积累目录中的指标。
配置是一个结构体：
```lean
{{#example_decl Examples/MonadTransformers.lean Config}}
```
<!-- This structure has default definitions for both fields.
The default `Config` uses Unicode display with no prefix. -->
该结构体的两个字段都有默认定义。
默认的 `Config` 使用 Unicode 显示，不带前缀。

<!-- Users who invoke `doug` will need to be able to provide command-line arguments.
The usage information is as follows: -->
调用 `doug` 的用户需要提供命令行参数。
用法如下：
```lean
{{#example_decl Examples/MonadTransformers.lean usage}}
```
<!-- Accordingly, a configuration can be constructed by examining a list of command-line arguments: -->
据此，可以通过查看命令行参数列表来构建配置：
```lean
{{#example_decl Examples/MonadTransformers.lean configFromArgs}}
```

<!-- The `main` function is a wrapper around an inner worker, called `dirTree`, that shows the contents of a directory using a configuration.
Before calling `dirTree`, `main` is responsible for processing command-line arguments.
It must also return the appropriate exit code to the operating system: -->
`main` 函数是一个名为 `dirTree` 的内部函数的包装，它根据一个配置来显示目录的内容。
在调用 `dirTree` 之前，`main` 需要处理命令行参数。
它还必须向操作系统返回适当的退出状态码：
```lean
{{#example_decl Examples/MonadTransformers.lean OldMain}}
```

<!-- Not all paths should be shown in the directory tree.
In particular, files named `.` or `..` should be skipped, as they are actually features used for navigation rather than files _per se_.
Of those files that should be shown, there are two kinds: ordinary files and directories: -->
并非所有路径都应显示在目录树中。
特别是名为`.` 或 `..` 的文件，因为它们实际上是用于导航的特殊标记，而不是文件本身。
应该显示的文件有两种：普通文件和目录：
```lean
{{#example_decl Examples/MonadTransformers.lean Entry}}
```
<!-- To determine whether a file should be shown, along with which kind of entry it is, `doug` uses `toEntry`: -->
为了确定是否要显示某个文件以及它是哪种条目，`doug` 依赖 `toEntry` 函数 ：
```lean
{{#example_decl Examples/MonadTransformers.lean toEntry}}
```
<!-- `System.FilePath.components` converts a path into a list of path components, splitting the name at directory separators.
If there is no last component, then the path is the root directory.
If the last component is a special navigation file (`.` or `..`), then the file should be excluded.
Otherwise, directories and files are wrapped in the corresponding constructors. -->

`System.FilePath.components` 在目录分隔符处分割路径名，并将路径转换为路径组件的列表。
如果没有最后一个组件，那么该路径就是根目录。
如果最后一个组件是一个特殊的导航文件（`.` 或 `..`），则应排除该文件。
否则，目录和文件将被包装在相应的构造函数中。

<!-- Lean's logic has no way to know that directory trees are finite.
Indeed, some systems allow the construction of circular directory structures.
Thus, `dirTree` is declared `partial`: -->
Lean 的逻辑无法确定目录树是否有限。
事实上，有些系统允许构建循环目录结构。
因此，`dirTree` 函数必须被声明为 `partial`：
```lean
{{#example_decl Examples/MonadTransformers.lean OldDirTree}}
```
<!-- The call to `toEntry` is a [nested action](../hello-world/conveniences.md#nested-actions)—the parentheses are optional in positions where the arrow couldn't have any other meaning, such as `match`.
When the filename doesn't correspond to an entry in the tree (e.g. because it is `..`), `dirTree` does nothing.
When the filename points to an ordinary file, `dirTree` calls a helper to show it with the current configuration.
When the filename points to a directory, it is shown with a helper, and then its contents are recursively shown in a new configuration in which the prefix has been extended to account for being in a new directory. -->

对 `toEntry` 的调用是一个[嵌套操作](../hello-world/conveniences.md#nested-actions) —— 在箭头没有其他含义的位置，如 `match`，括号是可以省略的。
当文件名与树中的条目不对应时（例如，因为它是 `..`），`dirTree` 什么也不做。
当文件名指向一个普通文件时，`dirTree` 会调用一个辅助函数，以当前配置来显示该文件。
当文件名指向一个目录时，将通过一个辅助函数来显示该目录，然后其内容将递归地显示在一个新的配置中，其中的前缀已被扩写，以说明它位于一个新的目录中。

<!-- Showing the names of files and directories is achieved with `showFileName` and `showDirName`: -->
文件和目录的名称通过 `showFileName` 和 `showDirName` 函数来显示：
```lean
{{#example_decl Examples/MonadTransformers.lean OldShowFile}}
```
<!-- Both of these helpers delegate to functions on `Config` that take the ASCII vs Unicode setting into account: -->
这两个辅助函数都委托给了将 ASCII 与 Unicode 设置考虑在内的 `Config` 上的函数：
```lean
{{#example_decl Examples/MonadTransformers.lean filenames}}
```
<!-- Similarly, `Config.inDirectory` extends the prefix with a directory marker: -->
同样，`Config.inDirectory` 用目录标记扩写了前缀：
```lean
{{#example_decl Examples/MonadTransformers.lean inDirectory}}
```

<!-- Iterating an IO action over a list of directory contents is achieved using `doList`.
Because `doList` carries out all the actions in a list and does not base control-flow decisions on the values returned by any of the actions, the full power of `Monad` is not necessary, and it will work for any `Applicative`: -->
`doList` 函数可以在目录内容的列表中迭代 IO 操作。
由于 `doList` 只执行列表中的所有操作，并不根据任何操作返回的值来决定控制流，因此不需要使用 `Monad` 的全部功能，它适用于任何 `Applicative` 应用程序：
```lean
{{#example_decl Examples/MonadTransformers.lean doList}}
```


<!-- ## Using a Custom Monad -->
## 使用自定义单子

<!-- While this implementation of `doug` works, manually passing the configuration around is verbose and error-prone.
The type system will not catch it if the wrong configuration is passed downwards, for instance.
A reader effect ensures that the same configuration is passed to all recursive calls, unless it is manually overridden, and it helps make the code less verbose. -->

虽然这种 `doug` 实现可以正常工作，但手动传递配置不仅费事还容易出错。
例如，类型系统无法捕获向下传递的错误配置。
读取器作用不仅可以确保在所有递归调用中都传递相同的配置，而且有助于优化冗长的代码。

<!-- To create a version of `IO` that is also a reader of `Config`, first define the type and its `Monad` instance, following the recipe from [the evaluator example](../monads/arithmetic.md#custom-environments): -->
要创建一个同时也是 `Config` 读取器的 `IO` ，首先要按照[求值器示例](.../monads/arithmetic.md#custom-environments)中的方法定义类型及其 `Monad` 实例：
```lean
{{#example_decl Examples/MonadTransformers.lean ConfigIO}}
```
<!-- The difference between this `Monad` instance and the one for `Reader` is that this one uses `do`-notation in the `IO` monad as the body of the function that `bind` returns, rather than applying `next` directly to the value returned from `result`.
Any `IO` effects performed by `result` must occur before `next` is invoked, which is ensured by the `IO` monad's `bind` operator.
`ConfigIO` is not universe polymorphic because the underlying `IO` type is also not universe polymorphic. -->

这个 `Monad` 实例与 `Reader` 实例的区别在于，它使用 `IO` 单子中的 `do` 标记 作为 `bind` 返回函数的主体，而不是直接将 `next` 应用于 `result` 返回的值。
由 `result` 执行的任何 `IO` 作用都必须在调用 `next` 之前发生，这一点由 `IO` 单子的 `bind` 操作符来保证。
`ConfigIO` 不是宇宙多态的，因为底层的 `IO` 类型也不是宇宙多态的。

<!-- Running a `ConfigIO` action involves transforming it into an `IO` action by providing it with a configuration: -->
运行 `ConfigIO` 操作需要向其提供一个配置，从而将其转换为 `IO` 操作：
```lean
{{#example_decl Examples/MonadTransformers.lean ConfigIORun}}
```
<!-- This function is not really necessary, as a caller could simply provide the configuration directly.
However, naming the operation can make it easier to see which parts of the code are intended to run in which monad. -->
这个函数其实并无必要，因为调用者只需直接提供配置即可。
不过，给操作命名可以让我们更容易看出代码的各部分会在哪个单子中运行。

<!-- The next step is to define a means of accessing the current configuration as part of `ConfigIO`: -->
下一步是定义访问当前配置的方法，作为 `ConfigIO` 的一部分：
```lean
{{#example_decl Examples/MonadTransformers.lean currentConfig}}
```
<!-- This is just like `read` from [the evaluator example](../monads/arithmetic.md#custom-environments), except it uses `IO`'s `pure` to return its value rather than doing so directly.
Because entering a directory modifies the current configuration for the scope of a recursive call, it will be necessary to have a way to override a configuration: -->
这与[求值器示例](../monads/arithmetic.md#custom-environments)中的 `read` 相同，只是它使用了 `IO` 的 `pure` 来返回其值，而不是直接返回。
因为进入一个目录会修改递归调用范围内的当前配置，因此有必要提供一种修改配置的方法：
```lean
{{#example_decl Examples/MonadTransformers.lean locally}}
```

<!-- Much of the code used in `doug` has no need for configurations, and `doug` calls ordinary Lean `IO` actions from the standard library that certainly don't need a `Config`.
Ordinary `IO` actions can be run using `runIO`, which ignores the configuration argument: -->
`doug` 中的大部分代码都不需要配置，因此 `doug` 会从标准库中调用普通的 Lean `IO` 操作，这些操作当然也不需要 `Config`。
普通的 `IO` 操作可以使用 `runIO` 运行，它会忽略配置参数：

```lean
{{#example_decl Examples/MonadTransformers.lean runIO}}
```

<!-- With these components, `showFileName` and `showDirName` can be updated to take their configuration arguments implicitly through the `ConfigIO` monad.
They use [nested actions](../hello-world/conveniences.md#nested-actions) to retrieve the configuration, and `runIO` to actually execute the call to `IO.println`: -->
有了这些组件，`showFileName` 和 `showDirName` 可以修改为使用 `ConfigIO` 单子来隐式获取配置参数。
它们使用 [嵌套动作](../hello-world/conveniences.md#nested-actions) 来获取配置，并使用 `runIO` 来实际执行对 `IO.println` 的调用：
```lean
{{#example_decl Examples/MonadTransformers.lean MedShowFileDir}}
```

<!-- In the new version of `dirTree`, the calls to `toEntry` and `System.FilePath.readDir` are wrapped in `runIO`.
Additionally, instead of building a new configuration and then requiring the programmer to keep track of which one to pass to recursive calls, it uses `locally` to naturally delimit the modified configuration to only a small region of the program, in which it is the _only_ valid configuration: -->
在新版的 `dirTree` 中，对 `toEntry` 和 `System.FilePath.readDir` 的调用被封装在 `runIO` 中。
此外，它不再构建一个新的配置，然后要求程序员跟踪将哪个配置传递给递归调用，而是使用 `locally` 自然地将修改后的配置限定在程序的一小块区域内，在该区域内，它是 _唯一_ 有效的配置：
```lean
{{#example_decl Examples/MonadTransformers.lean MedDirTree}}
```

<!-- The new version of `main` uses `ConfigIO.run` to invoke `dirTree` with the initial configuration: -->
新版本的 `main` 使用 `ConfigIO.run` 来调用带有初始配置的 `dirTree`：
```lean
{{#example_decl Examples/MonadTransformers.lean MedMain}}
```

<!-- This custom monad has a number of advantages over passing configurations manually: -->
与手动传递配置相比，这种自定义单子有很多优点：

 <!-- 1. It is easier to ensure that configurations are passed down unchanged, except when changes are desired
 1. The concern of passing the configuration onwards is more clearly separated from the concern of printing directory contents
 2. As the program grows, there will be more and more intermediate layers that do nothing with configurations except propagate them, and these layers don't need to be rewritten as the configuration logic changes -->

 3. 能更容易确保配置被原封不动地向下传递，除非需要更改
 4. 传递配置与打印目录内容之间的关系更加清晰
 5. 随着程序的增长，除了传播配置外，将有越来越多的中间层无需对配置进行处理，这些层并不需要随着配置逻辑的变化而重写。

<!-- However, there are also some clear downsides: -->
不过，也有一些明显的缺点：

 <!-- 1. As the program evolves and the monad requires more features, each of the basic operators such as `locally` and `currentConfig` will need to be updated
 2. Wrapping ordinary `IO` actions in `runIO` is noisy and distracts from the flow of the program
 3. Writing monads instances by hand is repetitive, and the technique for adding a reader effect to another monad is a design pattern that requires documentation and communication overhead -->
 1. 随着程序的发展和单子需要更多功能，比如 `locally` 和 `currentConfig` 等基本算子都需要更新。
 2. 将普通的 `IO` 操作封装在 `runIO` 中会产生语法噪音，影响程序的流畅性
 3. 手写单子实例是重复性的工作，而且向另一个单子添加读取器作用的技术是一种依赖文档和交流开销的设计模式

<!-- Using a technique called _monad transformers_, all of these downsides can be addressed.
A monad transformer takes a monad as an argument and returns a new monad.
Monad transformers consist of: -->
使用一种名为 _单子转换器_ 的技术，可以解决所有这些弊端。
单子转换器以一个单子作为参数，并返回一个新的单子。
单子转换器包括：
 <!-- 1. A definition of the transformer itself, which is typically a function from types to types
 2. A `Monad` instance that assumes the inner type is already a monad
 3. An operator to "lift" an action from the inner monad to the transformed monad, akin to `runIO` -->
 1. 转换器本身的定义，通常是一个从类型到类型的函数
 2. 假定内部类型已经是一个单子的 `Monad` 实例
 3. 从内部单子“提升”一个操作到转换后的单元的操作符，类似于 `runIO`.

<!-- ## Adding a Reader to Any Monad -->
## 将读取器添加到任意单子

<!-- Adding a reader effect to `IO` was accomplished in `ConfigIO` by wrapping `IO α` in a function type.
The Lean standard library contains a function that can do this to _any_ polymorphic type, called `ReaderT`: -->
在 `ConfigIO`中，通过将 `IO α` 包装成一个函数类型，为 `IO` 添加了读取器作用。
Lean 的标准库有一个函数，可以对 _任意_ 多态类型执行此操作，称为 `ReaderT`：
```lean
{{#example_decl Examples/MonadTransformers.lean MyReaderT}}
```
<!-- Its arguments are as follows: -->
它的参数如下:
 <!-- * `ρ` is the environment that is accessible to the reader
 * `m` is the monad that is being transformed, such as `IO`
 * `α` is the type of values being returned by the monadic computation -->
 * `ρ` 是读取器可以访问的环境
 * `m` 是被转换的单子，例如 `IO`
 * `α` 是单子计算返回值的类型
<!-- Both `α` and `ρ` are in the same universe because the operator that retrieves the environment in the monad will have type `m ρ`. -->
`α` 和 `ρ` 都在同一个宇宙中，因为在单子中检索环境的算子将具有 `m ρ` 类型。

<!-- With `ReaderT`, `ConfigIO` becomes: -->
有了 “ReaderT”，“ConfigIO” 就变成了:
```lean
{{#example_decl Examples/MonadTransformers.lean ReaderTConfigIO}}
```
<!-- It is an `abbrev` because `ReaderT` has many useful features defined in the standard library that a non-reducible definition would hide.
Rather than taking responsibility for making these work directly for `ConfigIO`, it's easier to simply have `ConfigIO` behave identically to `ReaderT Config IO`. -->
它是一个 `abbrev `，因为在标准库中定义了许多关于 `ReaderT ` 的有用功能，而不可归约的定义会隐藏这些功能。
与其让 `ConfigIO` 直接使用这些功能，不如让 `ConfigIO` 的行为与 `ReaderT Config IO` 保持一致。

<!-- The manually-written `currentConfig` obtained the environment out of the reader.
This effect can be defined in a generic form for all uses of `ReaderT`, under the name `read`: -->
手动编写的 `currentConfig` 从读取器中获取了环境。
这种作用可以以通用形式定义，适用于 `ReaderT` 的所有用途，名为 `read`：
```lean
{{#example_decl Examples/MonadTransformers.lean MyReaderTread}}
```
<!-- However, not every monad that provides a reader effect is built with `ReaderT`.
The type class `MonadReader` allows any monad to provide a `read` operator: -->
然而，并不是每个提供读取器作用的单子都是用 `ReaderT` 构建的。
类型类 `MonadReader` 允许任何单子提供 `read` 操作符：
```lean
{{#example_decl Examples/MonadTransformers.lean MonadReader}}
```
<!-- The type `ρ` is an output parameter because any given monad typically only provides a single type of environment through a reader, so automatically selecting it when the monad is known makes programs more convenient to write. -->
类型 `ρ` 是一个输出参数，因为任何给定的单子通常只通过读取器提供单一类型的环境，所以在已知单子时自动选择它可以使程序编写更方便。

<!-- The `Monad` instance for `ReaderT` is essentially the same as the `Monad` instance for `ConfigIO`, except `IO` has been replaced by some arbitrary monad argument `m`: -->
`ReaderT` 的 `Monad` 实例与 `ConfigIO` 的 `Monad` 实例基本相同，只是 `IO ` 被某个表示任意单子的参数 `m` 所取代:
```lean
{{#example_decl Examples/MonadTransformers.lean MonadMyReaderT}}
```


<!-- The next step is to eliminate uses of `runIO`.
When Lean encounters a mismatch in monad types, it automatically attempts to use a type class called `MonadLift` to transform the actual monad into the expected monad.
This process is similar to the use of coercions.
`MonadLift` is defined as follows: -->
下一步是消除对 `runIO` 的使用。
当 Lean 遇到单子类型不匹配时，它会自动尝试使用名为 `MonadLift` 的类型类，将实际的单子转换为预期单子。
这一过程与使用强制转换相似。
`MonadLift` 的定义如下：
```lean
{{#example_decl Examples/MonadTransformers.lean MyMonadLift}}
```
<!-- The method `monadLift` translates from the monad `m` to the monad `n`.
The process is called "lifting" because it takes an action in the embedded monad and makes it into an action in the surrounding monad.
In this case, it will be used to "lift" from `IO` to `ReaderT Config IO`, though the instance works for _any_ inner monad `m`: -->
方法 `monadLift` 可以将单子 `m` 转换为单子 `n`。
这个过程被称为“提升”，因为它将嵌入到单子中的动作转换成周围单子中的动作。
在本例中，它将用于把 `IO` “提升”到 `ReaderT Config IO`，尽管该实例适用于 _任何_ 内部单子 `m`：
```lean
{{#example_decl Examples/MonadTransformers.lean MonadLiftReaderT}}
```
<!-- The implementation of `monadLift` is very similar to that of `runIO`.
Indeed, it is enough to define `showFileName` and `showDirName` without using `runIO`: -->
`monadLift` 的实现与 `runIO` 非常相似。
事实上，只需定义 `showFileName` 和 `showDirName` 即可，无需使用 `runIO`：
```lean
{{#example_decl Examples/MonadTransformers.lean showFileAndDir}}
```

<!-- One final operation from the original `ConfigIO` remains to be translated to a use of `ReaderT`: `locally`.
The definition can be translated directly to `ReaderT`, but the Lean standard library provides a more general version.
The standard version is called `withReader`, and it is part of a type class called `MonadWithReader`: -->
原版 `ConfigIO` 中的最后一个操作还需要翻译成 `ReaderT` 的形式：`locally`。
该定义可以直接翻译为 `ReaderT`，但 Lean 标准库提供了一个更通用的版本。
标准版本被称为 `withReader`，它是名为 `MonadWithReader` 的类型类的一部分：
```lean
{{#example_decl Examples/MonadTransformers.lean MyMonadWithReader}}
```
<!-- Just as in `MonadReader`, the environment `ρ` is an `outParam`.
The `withReader` operation is exported, so that it doesn't need to be written with the type class name before it: -->
正如在 `MonadReader` 中一样，环境 `ρ` 是一个 `outParam`。
`withReader` 操作是被导出的，所以在编写时不需要在前面加上类型类名：
```lean
{{#example_decl Examples/MonadTransformers.lean exportWithReader}}
```
<!-- The instance for `ReaderT` is essentially the same as the definition of `locally`: -->
`ReaderT` 的实例与 `locally` 的定义基本相同：
```lean
{{#example_decl Examples/MonadTransformers.lean ReaderTWithReader}}
```

<!-- With these definitions in place, the new version of `dirTree` can be written: -->
有了这些定义,我们便可以定义新版本的 `dirTree`:
```lean
{{#example_decl Examples/MonadTransformers.lean readerTDirTree}}
```
<!-- Aside from replacing `locally` with `withReader`, it is the same as before. -->
除了用 `withReader` 替换 `locally` 外，其他内容保持不变。

<!-- Replacing the custom `ConfigIO` type with `ReaderT` did not save a large number of lines of code in this section.
However, rewriting the code using components from the standard library does have long-term benefits.
First, readers who know about `ReaderT` don't need to take time to understand the `Monad` instance for `ConfigIO`, working backwards to the meaning of monad itself.
Instead, they can be confident in their initial understanding.
Next, adding further effects to the monad (such as a state effect to count the files in each directory and display a count at the end) requires far fewer changes to the code, because the monad transformers and `MonadLift` instances provided in the library work well together.
Finally, using a set of type classes included in the standard library, polymorphic code can be written in such a way that it can work with a variety of monads without having to care about details like the order in which the monad transformers were applied.
Just as some functions work in any monad, others can work in any monad that provides a certain type of state, or a certain type of exceptions, without having to specifically describe the _way_ in which a particular concrete monad provides the state or exceptions. -->
在本节中，用 `ReaderT` 代替自定义的 `ConfigIO` 类型并没有节省大量代码行数。
不过，使用标准库中的组件重写代码确实有长远的好处。
首先，了解 `ReaderT` 的读者不需要花时间去理解 `ConfigIO` 的 `Monad` 实例，也不需要逆向理解单子本身的含义。
相反，他们可以沿用自己的初步理解。
接下来，给单子添加更多的作用（例如计算每个目录中的文件并在最后显示计数的状态作用）所需的代码改动要少得多，因为库中提供的单子转换器和 `MonadLift` 实例配合得很好。
最后，使用标准库中包含的一组类型类，多态代码的编写方式可以使其适用于各种单子，而无需关心单子转换器的应用顺序等细节。
正如某些函数可以在任何单子中工作一样，另一些函数也可以在任何提供特定类型状态或特定类型异常的单子中工作，而不必特别描述特定的具体单子提供状态或异常的 _方式_。

<!-- ## Exercises -->
## 练习

<!-- ### Controlling the Display of Dotfiles -->
### 控制点文件的显示

<!-- Files whose names begin with a dot character (`'.'`) typically represent files that should usually be hidden, such as source-control metadata and configuration files.
Modify `doug` with an option to show or hide filenames that begin with a dot.
This option should be controlled with a `-a` command-line option. -->
文件名以点字符 (`'.'`) 开头的文件通常代表隐藏文件，如源代码管理的元数据和配置文件。
修改 `doug` 并加入一个选项，以显示或隐藏以点开头的文件名。
应使用命令行选项 `-a` 来控制该选项。

<!-- ### Starting Directory as Argument -->
### 起始目录作为参数

<!-- Modify `doug` so that it takes a starting directory as an additional command-line argument. -->
修改 `doug` ，使其可以将起始目录作为额外的命令行参数。
