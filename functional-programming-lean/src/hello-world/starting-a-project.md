<!--
# Starting a Project
-->

# 创建项目

<!--
As a program written in Lean becomes more serious, an ahead-of-time compiler-based workflow that results in an executable becomes more attractive.
Like other languages, Lean has tools for building multiple-file packages and managing dependencies.
The standard Lean build tool is called Lake (short for "Lean Make"), and it is configured in Lean.
Just as Lean contains a special-purpose language for writing programs with effects (the `do` language), Lake contains a special-purpose language for configuring builds.
These languages are referred to as _embedded domain-specific languages_ (or sometimes _domain-specific embedded languages_, abbreviated EDSL or DSEL).
They are _domain-specific_ in the sense that they are used for a particular purpose, with concepts from some sub-domain, and they are typically not suitable for general-purpose programming.
They are _embedded_ because they occur inside another language's syntax.
While Lean contains rich facilities for creating EDSLs, they are beyond the scope of this book.
-->

随着 Lean 中编写的程序变得越来越复杂，基于提前编译器（Ahead-of-Time，AoT）的工作流变得更具吸引力，
因为它可以生成可执行文件。与其他语言类似，Lean 具有构建多文件包和管理依赖项的工具。
标准的 Lean 构建工具称为 Lake（「Lean Make」的缩写），它在 Lean 中进行配置。
正如 Lean 包含一门用于编写带副作用程序的特殊语言（`do` 语言）一样，
Lake 也包含一门用于配置构建的特殊语言。
这些语言被称为 **嵌入式领域专用语言（Embedded Domain-Specific Languages）**
（或有时称为 **领域专用嵌入式语言（Domain-Specific Embedded Languages）** ，缩写为 EDSL 或 DSEL）。
它们是 **领域专用（Domain-Specific）** 的，因为它们用于专用的目的，包含来自某个子领域的术语，
并且通常不适用于通用编程。它们是 **嵌入式（Embedded）** 的，因为它们出现在另一种语言的语法中。
虽然 Lean 包含丰富的用于创建 EDSL 的工具，但它们超出了本书的范围。

<!--
## First steps
-->

## 入门

<!--
To get started with a project that uses Lake, use the command `{{#command {first-lake} {lake} {lake new greeting} }}` in a directory that does not already contain a file or directory called `greeting`.
This creates a directory called `greeting` that contains the following files:
-->

要创建一个使用 Lake 的项目，请在一个不包含名为 `greeting` 的文件或目录的目录下执行命令
`lake new greeting`，这将创建一个名为 `greeting` 的目录，其中包含以下文件：

<!--
 * `Main.lean` is the file in which the Lean compiler will look for the `main` action.
 * `Greeting.lean` and `Greeting/Basic.lean` are the scaffolding of a support library for the program.
 * `lakefile.lean` contains the configuration that `lake` needs to build the application.
 * `lean-toolchain` contains an identifier for the specific version of Lean that is used for the project.
-->

 * `Main.lean` 是 Lean 编译器将查找 `main` 活动的文件。
 * `Greeting.lean` 和 `Greeting/Basic.lean` 是程序支持库的脚手架。
 * `lakefile.lean` 包含 `lake` 构建应用程序所需的配置。
 * `lean-toolchain` 包含用于项目的特定 Lean 版本的标识符。

<!--
Additionally, `lake new` initializes the project as a Git repository and configures its `.gitignore` file to ignore intermediate build products.
Typically, the majority of the application logic will be in a collection of libraries for the program, while `Main.lean` will contain a small wrapper around these pieces that does things like parsing command lines and executing the central application logic.
To create a project in an already-existing directory, run `lake init` instead of `lake new`.
-->

此外，`lake new` 会将项目初始化为 Git 代码库，并配置其 `.gitignore` 文件以忽略构建过程的中间产物。
通常，应用程序逻辑的主要部分将位于程序的库集合中，而 `Main.lean` 则包含这些部分的一个小的包装，
它执行诸如解析命令行以及执行核心应用程序逻辑之类的活动。要在已存在的目录中创建项目，
请运行 `lake init` 而非 `lake new`。

<!--
By default, the library file `Greeting/Basic.lean` contains a single definition:
-->

默认情况下，库文件 `Greeting/Basic.lean` 包含一个定义：

```lean
{{#file_contents {lake} {first-lake/greeting/Greeting/Basic.lean} {first-lake/expected/Greeting/Basic.lean}}}
```

<!--
The library file `Greeting.lean` imports `Greeting/Basic.lean`:
-->

库文件 `Greeting.lean` 导入了 `Greeting/Basic.lean`：

```lean
{{#file_contents {lake} {first-lake/greeting/Greeting.lean} {first-lake/expected/Greeting.lean}}}
```

<!--
This means that everything defined in `Greetings/Basic.lean` is also available to files that import `Greetings.lean`.
In `import` statements, dots are interpreted as directories on disk.
Placing guillemets around a name, as in `«Greeting»`, allow it to contain spaces or other characters that are normally not allowed in Lean names, and it allows reserved keywords such as `if` or `def` to be used as ordinary names by writing `«if»` or `«def»`.
This prevents issues when the package name provided to `lake new` contains such characters.
-->

这意味着在 `Greetings/Basic.lean` 中定义的所有内容也对导入 `Greetings.lean` 的文件可用。
在 `import` 语句中，点号被解释为磁盘上的目录。在名称周围放置引号，如 `«Greeting»`，
能够让名称包含空格或其他通常不允许在 Lean 名称中出现的字符，并且它允许通过编写
`«if»` 或 `«def»` 将保留关键字（如 `if` 或 `def`）用作普通名称。
当提供给 `lake new` 的包名包含此类字符时，这可以防止出现问题。

<!--
The executable source `Main.lean` contains:
-->

可执行源文件 `Main.lean` 包含：

```lean
{{#file_contents {lake} {first-lake/greeting/Main.lean} {first-lake/expected/Main.lean}}}
```

<!--
Because `Main.lean` imports `Greetings.lean` and `Greetings.lean` imports `Greetings/Basic.lean`, the definition of `hello` is available in `main`.
-->

由于 `Main.lean` 导入了 `Greetings.lean`，而 `Greetings.lean` 导入了 `Greetings/Basic.lean`，
因此 `hello` 的定义可以在 `main` 中使用。

<!--
To build the package, run the command `{{#command {first-lake/greeting} {lake} {lake build} }}`.
After a number of build commands scroll by, the resulting binary has been placed in `build/bin`.
Running `{{#command {first-lake/greeting} {lake} {./build/bin/greeting} }}` results in `{{#command_out {lake} {./build/bin/greeting} }}`.
-->

要构建包，请运行命令 `{{#command {first-lake/greeting} {lake} {lake build} }}`。
在滚动显示一些构建命令后，产生的二进制文件会被放置在 `build/bin` 中。
运行 `./build/bin/greeting` 会输出 `Hello, world!`。

<!--
## Lakefiles
-->

## Lakefile 构建文件

<!--
A `lakefile.lean` describes a _package_, which is a coherent collection of Lean code for distribution, analogous to an `npm` or `nuget` package or a Rust crate.
A package may contain any number of libraries or executables.
While the [documentation for Lake](https://github.com/leanprover/lean4/blob/master/src/lake/README.md) describes the available options in a lakefile, it makes use of a number of Lean features that have not yet been described here.
The generated `lakefile.lean` contains the following:
-->

`lakefile.lean` 描述了一个 **包（Package）** ，它是一个连贯的 Lean 代码集合，用于分发，
类似于 `npm` 或 `nuget` 包或 Rust 的 crate。一个包可以包含任意数量的库或可执行文件。
虽然 [Lake 文档](https://github.com/leanprover/lean4/blob/master/src/lake/README.md)中描述了
lakefile 中的可用选项，但它使用了此处尚未描述的许多 Lean 特性。生成的 `lakefile.lean` 包含以下内容：

```lean
{{#file_contents {lake} {first-lake/greeting/lakefile.lean} {first-lake/expected/lakefile.lean}}}
```

<!--
This initial Lakefile consists of three items:

 * a _package_ declaration, named `greeting`,
 * a _library_ declaration, named `Greeting`, and
 * an _executable_, also named `greeting`.
-->

此初始 Lakefile 由三项组成：

 * 一个 **包** 声明，名为 `greeting`，
 * 一个 **库** 声明，名为 `Greeting`，以及
 * 一个 **可执行文件** ，同样名为 `greeting`。

<!--
Each of these names is enclosed in guillemets to allow users more freedom in picking package names.
-->

这些名称中的每一个都用引号括起来，以允许用户在选择包名称时有更大的自由度。

<!--
Each Lakefile will contain exactly one package, but any number of libraries or executables.
Additionally, Lakefiles may contain _external libraries_, which are libraries not written in Lean to be statically linked with the resulting executable, _custom targets_, which are build targets that don't fit naturally into the library/executable taxonomy, _dependencies_, which are declarations of other Lean packages (either locally or from remote Git repositories), and _scripts_, which are essentially `IO` actions (similar to `main`), but that additionally have access to metadata about the package configuration.
The items in the Lakefile allow things like source file locations, module hierarchies, and compiler flags to be configured.
Generally speaking, however, the defaults are reasonable.
-->

每个 Lakefile 只会包含一个包，但可以包含任意数量的库或可执行文件。
此外，Lakefile 可能包含 **外部库（External Library）**
（即并非用 Lean 编写的库，将与结果可执行文件静态链接）、
 **自定义目标（Custom Target）** （即特定于具体执行平台的库/可执行文件的构建目标）、
 **依赖项（Dependency）** （即其他 Lean 包的声明，可能来自本地或远程 Git 代码库）、
以及 **脚本（Script）** （本质上是类似于 `main` 的 `IO` 活动，但还可以访问有关包配置的元数据）。
Lakefile 中的项允许配置源文件位置、模块层次结构和编译器参数。不过一般来说，默认值就够用了。

<!--
Libraries, executables, and custom targets are all called _targets_.
By default, `lake build` builds those targets that are annotated with `@[default_target]`.
This annotation is an _attribute_, which is metadata that can be associated with a Lean declaration.
Attributes are similar to Java annotations or C# and Rust attributes.
They are used pervasively throughout Lean.
To build a target that is not annotated with `@[default_target]`, specify the target's name as an argument after `lake build`.
-->

库、可执行文件和自定义目标统称为 **目标（Target）** 。默认情况下，`lake build` 会构建那些标注了
`@[default_target]` 的目标。此标注是一个 **属性（Attribute）** ，
它是一种可以与 Lean 声明关联的元数据。属性类似于 Java 中的注解或 C# 和 Rust 的特性。
它们在 Lean 中被广泛使用。要构建未标注 `@[default_target]` 的目标，
请在 `lake build` 后指定目标名称作为参数。

<!--
## Libraries and Imports
-->

## 库与导入

<!--
A Lean library consists of a hierarchically organized collection of source files from which names can be imported, called _modules_.
By default, a library has a single root file that matches its name.
In this case, the root file for the library `Greeting` is `Greeting.lean`.
The first line of `Main.lean`, which is `import Greeting`, makes the contents of `Greeting.lean` available in `Main.lean`.
-->

一个 Lean 库由一个分层组织的源文件集合组成，可以从中导入名称，称为 **模块（Module）** 。
默认情况下，一个库有一个与它名称相同的单一根文件。在本例中，
库 `Greeting` 的根文件是 `Greeting.lean`。`Main.lean` 的第一行是 `import Greeting`，
它使 `Greeting.lean` 的内容在 `Main.lean` 中可用。

<!--
Additional module files may be added to the library by creating a directory called `Greeting` and placing them inside.
These names can be imported by replacing the directory separator with a dot.
For instance, creating the file `Greeting/Smile.lean` with the contents:
-->

可以通过创建一个名为 `Greeting` 的目录，并将文件放在里面来向库中添加额外的模块文件。
用点替换目录分隔符可以导入这些名称。例如，创建文件 `Greeting/Smile.lean`，其内容为：

```lean
{{#file_contents {lake} {second-lake/greeting/Greeting/Smile.lean}}}
```

<!--
means that `Main.lean` can use the definition as follows:
-->

这意味着 `Main.lean` 可以使用如下定义：

```lean
{{#file_contents {lake} {second-lake/greeting/Main.lean}}}
```

<!--
The module name hierarchy is decoupled from the namespace hierarchy.
In Lean, modules are units of code distribution, while namespaces are units of code organization.
That is, names defined in the module `Greeting.Smile` are not automatically in a corresponding namespace `Greeting.Smile`.
Modules may place names into any namespace they like, and the code that imports them may `open` the namespace or not.
`import` is used to make the contents of a source file available, while `open` makes names from a namespace available in the current context without prefixes.
In the Lakefile, the line `import Lake` makes the contents of the `Lake` module available, while the line `open Lake DSL` makes the contents of the `Lake` and `Lake.DSL` namespaces available without any prefixes.
`Lake.DSL` is opened because opening `Lake` makes `Lake.DSL` available as just `DSL`, just like all other names in the `Lake` namespace.
The `Lake` module places names into both the `Lake` and `Lake.DSL` namespaces.
-->

模块名的层次结构与命名空间层次结构是分离的。在 Lean 中，模块是代码的分发单元，
而命名空间是代码的组织单元。也就是说，在模块 `Greeting.Smile`
中定义的名称不会自动出现在相应的命名空间 `Greeting.Smile` 中。
模块可以将某个名称放入任何它们想要的命名空间中，而导入它们的代码可以选择是否用 `open`
打开命名空间。`import` 用于使源文件的内容可用，而 `open` 可以让命名空间中的名称在当前上下文中可用，
而无需前缀。在 Lakefile 中，`import Lake` 会使 `Lake` 模块的内容可用，
而 `open Lake DSL` 使 `Lake` 和 `Lake.DSL` 命名空间的内容可用，而无需任何前缀。
此时 `Lake.DSL` 已被打开，因为打开 `Lake` 会让 `Lake.DSL` 可以只使用名字 `DSL` 访问，
就像 `Lake` 命名空间中的其他名称一样。`Lake` 模块将名称放入到了 `Lake` 和 `Lake.DSL` 命名空间中。

<!--
Namespaces may also be opened _selectively_, making only some of their names available without explicit prefixes.
This is done by writing the desired names in parentheses.
For example, `Nat.toFloat` converts a natural number to a `Float`.
It can be made available as `toFloat` using `open Nat (toFloat)`.
-->

命名空间也可以 **选择性** 打开，只公开部分名称而无需显式前缀。
这可以通过在括号中写出所需名称来完成。例如，`Nat.toFloat` 将自然数转换为 `Float`。
可以使用 `open Nat (toFloat)` 将其公开为 `toFloat`。
