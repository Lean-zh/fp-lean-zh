<!--
# Additional Conveniences
-->

# 其他便利功能

<!--
## Constructor Syntax for Instances
-->

## 实例的构造子语法

<!--
Behind the scenes, type classes are structure types and instances are values of these types.
The only differences are that Lean stores additional information about type classes, such as which parameters are output parameters, and that instances are registered for searching.
While values that have structure types are typically defined using either `⟨...⟩` syntax or with braces and fields, and instances are typically defined using `where`, both syntaxes work for both kinds of definition.
-->

在幕后，类型类都是一些结构体类型，实例都是那些类型的值。
唯一的区别是 Lean 存储关于类型类的额外信息，例如哪些参数是输出参数，和记录要被搜索的实例。
虽然结构体类型的值通常要么是用 `⟨...⟩` 定义的，要么是用大括号和字段定义的，而实例通常使用where定义，但这两种语法都适用于这两种定义方式。

<!--
For example, a forestry application might represent trees as follows:
-->

例如，一个林业应用程序可能会这样表示树木：
```lean
{{#example_decl Examples/Classes.lean trees}}
```
<!--
All three syntaxes are equivalent.
-->

这些语法都是等价的

<!--
Similarly, type class instances can be defined using all three syntaxes:
-->

类似地，这三种语法也可以用于定义类型类的实例。
```lean
{{#example_decl Examples/Classes.lean Display}}
```

<!--
Generally speaking, the `where` syntax should be used for instances, and the curly-brace syntax should be used for structures.
The `⟨...⟩` syntax can be useful when emphasizing that a structure type is very much like a tuple in which the fields happen to be named, but the names are not important at the moment.
However, there are situations where it can make sense to use other alternatives.
In particular, a library might provide a function that constructs an instance value.
Placing a call to this function after `:=` in an instance declaration is the easiest way to use such a function.
-->

一般来说，`where` 语法应该用于实例，单书名号应该用于结构体。
当强调一个结构类型非常类似于一个字段被命名的元组，但名字此刻并不重要时，`⟨...⟩` 语法会很有用。
然而，有些情况用其他方式可能才是合理的。
具体而言，一个库可能提供一个构建实例值的函数。
在实例声明中的 `:=` 之后调用这个函数是使用此类函数的最简单方法。

<!--
## Examples
-->

## 例子

<!--
When experimenting with Lean code, definitions can be more convenient to use than `#eval` or `#check` commands.
First off, definitions don't produce any output, which can help keep the reader's focus on the most interesting output.
Secondly, it's easiest to write most Lean programs by starting with a type signature, allowing Lean to provide more assistance and better error messages while writing the program itself.
On the other hand, `#eval` and `#check` are easiest to use in contexts where Lean is able to determine the type from the provided expression.
Thirdly, `#eval` cannot be used with expressions whose types don't have `ToString` or `Repr` instances, such as functions.
Finally, multi-step `do` blocks, `let`-expressions, and other syntactic forms that take multiple lines are particularly difficult to write with a type annotation in `#eval` or `#check`, simply because the required parenthesization can be difficult to predict.
-->

当用 Lean 代码做实验时，定义可能比 `#eval` 或 `#check` 指令更方便。
首先，定义不会产生任何输出，这可以让读者的注意力集中在最有趣的输出上。
第二，从一个类型签名开始一个 Lean 程序是最简单的方式，这也会使 Lean 能够提供更多的协助和更好的错误信息。
另一方面，`#eval` 和 `#check` 在 Lean 可以通过表达式给出类型时用起来最简单。
第三，`#eval` 并不能用于没有 `ToString` 或 `Repr` 实例的类型，例如函数。
最后，多步的 `do` 语法块，`let` 表达式，和其他多行语法形式在 `#eval` 或 `#check` 中有时候是一个需要多层括号区分优先级的长表达式，在这里面插入类型标注会很难读。

<!--
To work around these issues, Lean supports the explicit indication of examples in a source file.
An example is like a definition without a name.
For instance, a non-empty list of birds commonly found in Copenhagen's green spaces can be written:
-->

为了绕开这些问题，Lean 支持源码中例子的显式类型推断。
一个例子就是一个无名的定义。
例如，一个在 Copenhagen's green spaces 中常见鸟类的非空列表可以写成这样：
```lean
{{#example_decl Examples/Classes.lean birdExample}}
```

<!--
Examples may define functions by accepting arguments:
-->

接受参数的例子可以用来定义函数：
```lean
{{#example_decl Examples/Classes.lean commAdd}}
```
<!--
While this creates a function behind the scenes, this function has no name and cannot be called.
Nonetheless, this is useful for demonstrating how a library can be used with arbitrary or unknown values of some given type.
In source files, `example` declarations are best paired with comments that explain how the example illustrates the concepts of the library.
-->

这会在幕后创建一个函数，这个函数没有名字，也不能被调用。
此外，这可以用来检查某库中的函数是否可以在任意的或一些类型的未知值上正常工作。
在源码中，`example` 声明很适合与解释概念的注释搭配使用。

