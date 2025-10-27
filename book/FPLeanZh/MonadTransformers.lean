import VersoManual

import FPLeanZh.Examples

import FPLeanZh.MonadTransformers.ReaderIO
import FPLeanZh.MonadTransformers.Transformers
import FPLeanZh.MonadTransformers.Order
import FPLeanZh.MonadTransformers.Do
import FPLeanZh.MonadTransformers.Conveniences
import FPLeanZh.MonadTransformers.Summary

open Verso.Genre Manual
open Verso Code External

open FPLeanZh


set_option verso.exampleProject "../examples"
set_option verso.exampleModule "Examples.Monads"

-- Monad Transformers
#doc (Manual) "单子转换器" =>

-- A monad is a way to encode some collection of side effects in a pure language.
-- Different monads provide different effects, such as state and error handling.
-- Many monads even provide useful effects that aren't available in most languages, such as nondeterministic searches, readers, and even continuations.

-- A typical application has a core set of easily testable functions written without monads paired with an outer wrapper that uses a monad to encode the necessary application logic.
-- These monads are constructed from well-known components.

单子是一种在纯语言中编码某些副作用的方式。不同的单子可以编码不同的副作用，例如状态和错误处理。很多单子甚至会提供在大多数语言中不可用的有用作用，例如非确定性搜索、读取器，甚至续体。

一个典型的应用程序有一组易于测试的不包含单子的核心函数，并配对了一个使用单子来编码必要应用逻辑的外部封装。这些单子是由常见的组件构建的。

-- For example:
--  * Mutable state is encoded with a function parameter and a return value that have the same type
--  * Error handling is encoded by having a return type that is similar to {moduleName}`Except`, with constructors for success and failure
--  * Logging is encoded by pairing the return value with the log

比如：

* 可变状态通过具有相同类型的函数参数和返回值来编码
* 错误处理通过具有类似于 {moduleName}`Except` 的返回类型来编码，该类型具有用于表示成功和失败的构造函数
* 通过将返回值与日志配对，对日志进行编码

-- Writing each monad by hand is tedious, however, involving boilerplate definitions of the various type classes.
-- Each of these components can also be extracted to a definition that modifies some other monad to add an additional effect.
-- Such a definition is called a _monad transformer_.
-- A concrete monad can be build from a collection of monad transformers, which enables much more code re-use.

然而，手动编写每个单子是繁琐的，需要定义各种类型类的样板代码。每个组件也都可以提取到一个定义中，该定义修改某个其他单子以添加额外的作用。这种定义称为*单子转换器*（Monad Transformer）。一个具体的单子可以从一组单子转换器构建，从而实现更多代码的重用。
