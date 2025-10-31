import VersoManual
import FPLeanZh.Examples


open Verso.Genre Manual
open Verso Code External

open FPLeanZh

set_option verso.exampleProject "../examples/second-lake/greeting"
set_option verso.exampleModule "Main"

-- Starting a Project
#doc (Manual) "创建项目" =>
%%%
file := "StartingAProject"
tag := "starting-a-project"
%%%

-- As a program written in Lean becomes more serious, an ahead-of-time compiler-based workflow that results in an executable becomes more attractive.
-- Like other languages, Lean has tools for building multiple-file packages and managing dependencies.
-- The standard Lean build tool is called Lake (short for “Lean Make”).
-- Lake is typically configured using a TOML file that declaratively specifies dependencies and describes what is to be built.
-- For advanced use cases, Lake can also be configured in Lean itself.

随着 Lean 中编写的程序变得越来越复杂，基于提前编译器（Ahead-of-Time，AoT）的工作流变得更具吸引力，
因为它可以生成可执行文件。与其他语言类似，Lean 具有构建多文件包和管理依赖项的工具。
标准的 Lean 构建工具称为 Lake（「Lean Make」的缩写）。
Lake 通常使用 TOML 文件进行配置，该文件声明性地指定依赖项并描述要构建的内容。
对于高级用例，Lake 也可以在 Lean 本身中进行配置。

-- # First steps
# 入门
%%%
tag := "lake-new"
%%%

-- To get started with a project that uses Lake, use the command {command lake "first-lake"}`lake new greeting` in a directory that does not already contain a file or directory called {lit}`greeting`.
-- This creates a directory called {lit}`greeting` that contains the following files:

要创建一个使用 Lake 的项目，请在一个不包含名为 {lit}`greeting` 的文件或目录的目录下执行命令 {command lake "first-lake"}`lake new greeting`。
这将创建一个名为 {lit}`greeting` 的目录，其中包含以下文件：

-- * {lit}`Main.lean` is the file in which the Lean compiler will look for the {lit}`main` action.
-- * {lit}`Greeting.lean` and {lit}`Greeting/Basic.lean` are the scaffolding of a support library for the program.
-- * {lit}`lakefile.toml` contains the configuration that {lit}`lake` needs to build the application.
-- * {lit}`lean-toolchain` contains an identifier for the specific version of Lean that is used for the project.

 * {lit}`Main.lean` 是 Lean 编译器将查找 {lit}`main` 活动的文件。
 * {lit}`Greeting.lean` 和 {lit}`Greeting/Basic.lean` 是程序支持库的脚手架。
 * {lit}`lakefile.toml` 包含 {lit}`lake` 构建应用程序所需的配置。
 * {lit}`lean-toolchain` 包含项目使用的特定版本 Lean 的标识符。

-- Additionally, {lit}`lake new` initializes the project as a Git repository and configures its {lit}`.gitignore` file to ignore intermediate build products.
-- Typically, the majority of the application logic will be in a collection of libraries for the program, while {lit}`Main.lean` will contain a small wrapper around these pieces that does things like parsing command lines and executing the central application logic.
-- To create a project in an already-existing directory, run {lit}`lake init` instead of {lit}`lake new`.

此外，{lit}`lake new` 将项目初始化为 Git 存储库，并配置其 {lit}`.gitignore` 文件以忽略中间构建产物。
通常，应用程序逻辑的大部分将位于程序的库集合中，而 {lit}`Main.lean` 将包含围绕这些部分的小包装器，
执行诸如解析命令行和执行核心应用程序逻辑之类的操作。
要在已存在的目录中创建项目，请运行 {lit}`lake init` 而不是 {lit}`lake new`。

-- By default, the library file {lit}`Greeting/Basic.lean` contains a single definition:
默认情况下，库文件 {lit}`Greeting/Basic.lean` 包含一个单独的定义：
```file lake "first-lake/greeting/Greeting/Basic.lean" "Greeting/Basic.lean"
def hello := "world"
```

-- The library file {lit}`Greeting.lean` imports {lit}`Greeting/Basic.lean`:
库文件 {lit}`Greeting.lean` 导入 {lit}`Greeting/Basic.lean`：
```file lake "first-lake/greeting/Greeting.lean" "Greeting.lean"
-- This module serves as the root of the `Greeting` library.
-- Import modules here that should be built as part of the library.
import Greeting.Basic
```

-- This means that everything defined in {lit}`Greeting/Basic.lean` is also available to files that import {lit}`Greeting.lean`.
-- In {kw}`import` statements, dots are interpreted as directories on disk.

这意味着在 {lit}`Greeting/Basic.lean` 中定义的所有内容也可用于导入 {lit}`Greeting.lean` 的文件。
在 {kw}`import` 语句中，点号被解释为磁盘上的目录。

-- The executable source {lit}`Main.lean` contains:
可执行源文件 {lit}`Main.lean` 包含：
```file lake "first-lake/greeting/Main.lean" "Main.lean"
import Greeting

def main : IO Unit :=
  IO.println s!"Hello, {hello}!"
```

-- Because {lit}`Main.lean` imports {lit}`Greeting.lean` and {lit}`Greeting.lean` imports {lit}`Greeting/Basic.lean`, the definition of {lit}`hello` is available in {lit}`main`.

因为 {lit}`Main.lean` 导入 {lit}`Greeting.lean` 而 {lit}`Greeting.lean` 导入 {lit}`Greeting/Basic.lean`，
所以 {lit}`hello` 的定义在 {lit}`main` 中可用。

-- To build the package, run the command {command lake "first-lake/greeting"}`lake build`.
要构建包，请运行命令 {command lake "first-lake/greeting"}`lake build`。

-- After a number of build commands scroll by, the resulting binary has been placed in {lit}`.lake/build/bin`.
-- Running {command lake "first-lake/greeting"}`./.lake/build/bin/greeting` results in {commandOut lake}`./.lake/build/bin/greeting`.
-- Instead of running the binary directly, the command {lit}`lake exe` can be used to build the binary if necessary and then run it.
-- Running {command lake "first-lake/greeting"}`lake exe greeting` also results in {commandOut lake}`lake exe greeting`.

经过大量构建命令后，生成的二进制文件已放置在 {lit}`.lake/build/bin` 中。
运行 {command lake "first-lake/greeting"}`./.lake/build/bin/greeting` 会得到 {commandOut lake}`./.lake/build/bin/greeting`。
除了直接运行二进制文件外，可以使用命令 {lit}`lake exe` 在必要时构建二进制文件然后运行它。
运行 {command lake "first-lake/greeting"}`lake exe greeting` 也会得到 {commandOut lake}`lake exe greeting`。

-- # Lakefiles
# Lakefile
%%%
tag := "lakefiles"
%%%

-- A {lit}`lakefile.toml` describes a _package_, which is a coherent collection of Lean code for distribution, analogous to an {lit}`npm` or {lit}`nuget` package or a Rust crate.
-- A package may contain any number of libraries or executables.
-- The [documentation for Lake](https://lean-lang.org/doc/reference/latest/find/?domain=Verso.Genre.Manual.section&name=lake-config-toml) describes the available options in a Lake configuration.
-- The generated {lit}`lakefile.toml` contains the following:

{lit}`lakefile.toml` 描述了一个*包*，它是用于分发的 Lean 代码的有条理集合，类似于 {lit}`npm` 或 {lit}`nuget` 包或 Rust crate。
包可以包含任意数量的库或可执行文件。
[Lake 的文档](https://lean-lang.org/doc/reference/latest/find/?domain=Verso.Genre.Manual.section&name=lake-config-toml)描述了 Lake 配置中的可用选项。
生成的 {lit}`lakefile.toml` 包含以下内容：
```file lake "first-lake/greeting/lakefile.toml" "lakefile.toml"
name = "greeting"
version = "0.1.0"
defaultTargets = ["greeting"]

[[lean_lib]]
name = "Greeting"

[[lean_exe]]
name = "greeting"
root = "Main"
```

-- This initial Lake configuration consists of three items:
-- * _package_ settings, at the top of the file,
-- * a _library_ declaration, named {lit}`Greeting`, and
-- * an _executable_, named {lit}`greeting`.

此初始的 Lake 配置包含三个项：
 * *包*配置，位于文件顶部，
 * 一个 *库* 声明，名为 {lit}`Greeting`，
 * 一个 *可执行文件*，名为 {lit}`greeting`。

-- Each Lake configuration file will contain exactly one package, but any number of dependencies, libraries, or executables.
-- By convention, package and executable names begin with a lowercase letter, while libraries begin with an uppercase letter.
-- Dependencies are declarations of other Lean packages (either locally or from remote Git repositories)
-- The items in the Lake configuration file allow things like source file locations, module hierarchies, and compiler flags to be configured.
-- Generally speaking, however, the defaults are reasonable.
-- Lake configuration files written in the Lean format may additionally contain _external libraries_, which are libraries not written in Lean to be statically linked with the resulting executable, _custom targets_, which are build targets that don't fit naturally into the library/executable taxonomy, and _scripts_, which are essentially {moduleName}`IO` actions (similar to {moduleName}`main`), but that additionally have access to metadata about the package configuration.

每个 Lake 配置文件都将包含一个包，但可以有任意数量的依赖项、库或可执行文件。
按照惯例，包和可执行文件名以小写字母开头，而库名以大写字母开头。
依赖项是其他 Lean 包的声明（无论是本地的还是来自远程 Git 存储库的）
Lake 配置文件中的项目允许配置诸如源文件位置、模块层次结构和编译器标志等内容。
不过一般来说，默认值就够用了。
用 Lean 格式编写的 Lake 配置文件还可以包含*外部库*，这些是非 Lean 编写的库，要与生成的可执行文件静态链接；
*自定义目标*，这些是不适合库/可执行文件分类的构建目标；
以及*脚本*，它们本质上是 {moduleName}`IO` 动作（类似于 {moduleName}`main`），但另外还可以访问有关包配置的元数据。

-- Libraries, executables, and custom targets are all called _targets_.
-- By default, {lit}`lake build` builds those targets that are specified in the {lit}`defaultTargets` list.
-- To build a target that is not a default target, specify the target's name as an argument after {lit}`lake build`.

库、可执行文件和自定义目标都称为 *目标（Target）*。
默认情况下，{lit}`lake build` 构建在 {lit}`defaultTargets` 列表中指定的目标。
要构建非默认目标，请在 {lit}`lake build` 后将目标名称指定为参数。

-- # Libraries and Imports
# 库和导入
%%%
tag := "libraries-and-imports"
%%%

-- A Lean library consists of a hierarchically organized collection of source files from which names can be imported, called _modules_.
-- By default, a library has a single root file that matches its name.
-- In this case, the root file for the library {lit}`Greeting` is {lit}`Greeting.lean`.
-- The first line of {lit}`Main.lean`, which is {moduleTerm}`import Greeting`, makes the contents of {lit}`Greeting.lean` available in {lit}`Main.lean`.

Lean 库由分层组织的源文件集合组成，可以从中导入名称，称为*模块*。
默认情况下，库有一个与其名称匹配的单个根文件。
在这种情况下，库 {lit}`Greeting` 的根文件是 {lit}`Greeting.lean`。
{lit}`Main.lean` 的第一行 {moduleTerm}`import Greeting` 使 {lit}`Greeting.lean` 的内容在 {lit}`Main.lean` 中可用。

-- Additional module files may be added to the library by creating a directory called {lit}`Greeting` and placing them inside.
-- These names can be imported by replacing the directory separator with a dot.
-- For instance, creating the file {lit}`Greeting/Smile.lean` with the contents:

可以通过创建名为 {lit}`Greeting` 的目录并将其放在其中来向库添加其他模块文件。
可以通过将目录分隔符替换为点来导入这些名称。
例如，创建文件 {lit}`Greeting/Smile.lean` 并包含以下内容：
```file lake "second-lake/greeting/Greeting/Smile.lean" "Greeting/Smile.lean"
def Expression.happy : String := "a big smile"
```

-- means that {lit}`Main.lean` can use the definition as follows:
这意味着 {lit}`Main.lean` 可以按如下方式使用定义：
```file lake "second-lake/greeting/Main.lean" "Main.lean"
import Greeting
import Greeting.Smile

open Expression

def main : IO Unit :=
  IO.println s!"Hello, {hello}, with {happy}!"
```

-- The module name hierarchy is decoupled from the namespace hierarchy.
-- In Lean, modules are units of code distribution, while namespaces are units of code organization.
-- That is, names defined in the module {lit}`Greeting.Smile` are not automatically in a corresponding namespace {lit}`Greeting.Smile`.
-- In particular, {moduleName (module:=Greeting.Smile) (show:=happy)}`Expression.happy` is in the {lit}`Expression` namespace.
-- Modules may place names into any namespace they like, and the code that imports them may {kw}`open` the namespace or not.
-- {kw}`import` is used to make the contents of a source file available, while {kw}`open` makes names from a namespace available in the current context without prefixes.

模块名称层次结构与命名空间层次结构分离。
在 Lean 中，模块是代码的分发单元，而命名空间是代码的组织单元。
也就是说，在模块 {lit}`Greeting.Smile` 中定义的名称不会自动位于相应的命名空间 {lit}`Greeting.Smile` 中。
特别是，{moduleName (module:=Greeting.Smile) (show:=happy)}`Expression.happy` 位于 {lit}`Expression` 命名空间中。
模块可以将名称放入任何它们喜欢的命名空间中，导入它们的代码可以 {kw}`open` 命名空间，也可以不这样做。
{kw}`import` 用于使源文件的内容可用，而 {kw}`open` 使命名空间中的名称在当前上下文中无需前缀即可使用。

-- The line {moduleTerm}`open Expression` makes the name {moduleName (module:=Greeting.Smile)}`Expression.happy` accessible as {moduleName}`happy` in {moduleName}`main`.
-- Namespaces may also be opened _selectively_, making only some of their names available without explicit prefixes.
-- This is done by writing the desired names in parentheses.
-- For example, {moduleTerm (module:=Aux)}`Nat.toFloat` converts a natural number to a {moduleTerm (module:=Aux)}`Float`.
-- It can be made available as {moduleName (module:=Aux)}`toFloat` using {moduleTerm (module:=Aux)}`open Nat (toFloat)`.

{moduleTerm}`open Expression` 行使名称 {moduleName (module:=Greeting.Smile)}`Expression.happy` 在 {moduleName}`main` 中可以作为 {moduleName}`happy` 访问。
命名空间也可以*选择性地*打开，只让其中一些名称无需显式前缀即可使用。
这是通过将所需的名称写在括号中来完成的。
例如，{moduleTerm (module:=Aux)}`Nat.toFloat` 将自然数转换为 {moduleTerm (module:=Aux)}`Float`。
可以使用 {moduleTerm (module:=Aux)}`open Nat (toFloat)` 使其作为 {moduleName (module:=Aux)}`toFloat` 可用。
