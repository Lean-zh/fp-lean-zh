<!--
# Additional Conveniences
-->

# 其他便利功能

<!--
Lean contains a number of convenience features that make programs much more concise.
-->

Lean 包含许多便利功能，能够让程序更加简洁。

<!--
## Automatic Implicit Arguments
-->

## Automatic Implicit Arguments

<!--
When writing polymorphic functions in Lean, it is typically not necessary to list all the implicit arguments.
Instead, they can simply be mentioned.
If Lean can determine their type, then they are automatically inserted as implicit arguments.
In other words, the previous definition of `length`:
-->

在 Lean 中编写多态函数时，通常不必列出所有隐式参数。相反，它们可以简单地被提及。
如果 Lean 可以确定它们的类型，那么它们将自动插入为隐式参数。换句话说，`length` 的先前定义：

```lean
{{#example_decl Examples/Intro.lean lengthImp}}
```

<!--
can be written without `{α : Type}`:
-->

可以不写 `{α : Type}`:

```lean
{{#example_decl Examples/Intro.lean lengthImpAuto}}
```

<!--
This can greatly simplify highly polymorphic definitions that take many implicit arguments.
-->

这能极大简化需要很多隐式参数的高级多态定义。

<!--
## Pattern-Matching Definitions
-->

## 模式匹配定义

<!--
When defining functions with `def`, it is quite common to name an argument and then immediately use it with pattern matching.
For instance, in `length`, the argument `xs` is used only in `match`.
In these situations, the cases of the `match` expression can be written directly, without naming the argument at all.
-->

用 `def` 定义函数时，通常会给参数命名，然后立即用模式匹配使用它。
例如，在 `length` 中，参数 `xs` 仅在 `match` 中使用。在这些情况下，`match`
表达式的 `case` 可以直接编写，而无需给参数命名。

<!--
The first step is to move the arguments' types to the right of the colon, so the return type is a function type.
For instance, the type of `length` is `List α → Nat`.
Then, replace the `:=` with each case of the pattern match:
-->

第一步是将参数类型移到冒号的右侧，因此返回类型是函数类型。例如，`length` 的类型是
`List α → Nat`。然后，用模式匹配的每个 case 替换 `:=`：

```lean
{{#example_decl Examples/Intro.lean lengthMatchDef}}
```

<!--
This syntax can also be used to define functions that take more than one argument.
In this case, their patterns are separated by commas.
For instance, `drop` takes a number \\( n \\) and a list, and returns the list after removing the first \\( n \\) entries.
-->

此语法还可用于定义接受多个参数的函数。在这种情况下，它们的模式用逗号分隔。
例如，`drop` 接受一个数字 \\( n \\) 和一个列表，并返回删除前 \\( n \\) 个条目的列表。

```lean
{{#example_decl Examples/Intro.lean drop}}
```

<!--
Named arguments and patterns can also be used in the same definition.
For instance, a function that takes a default value and an optional value, and returns the default when the optional value is `none`, can be written:
-->

已命名的参数和模式也可以在同一定义中使用。例如，一个函数接受一个默认值和一个可选值，
当可选值为 `none` 时返回默认值，可以写成：

```lean
{{#example_decl Examples/Intro.lean fromOption}}
```

<!--
This function is called `Option.getD` in the standard library, and can be called with dot notation:
-->

此函数在标准库中称为 `Option.getD`，可以用点表示法调用：

```lean
{{#example_in Examples/Intro.lean getD}}
```

```output info
{{#example_out Examples/Intro.lean getD}}
```

```lean
{{#example_in Examples/Intro.lean getDNone}}
```

```output info
{{#example_out Examples/Intro.lean getDNone}}
```

<!--
## Local Definitions
-->

## 局部定义

<!--
It is often useful to name intermediate steps in a computation.
In many cases, intermediate values represent useful concepts all on their own, and naming them explicitly can make the program easier to read.
In other cases, the intermediate value is used more than once.
As in most other languages, writing down the same code twice in Lean causes it to be computed twice, while saving the result in a variable leads to the result of the computation being saved and re-used.
-->

在计算中对中间步骤命名通常很有用。在许多情况下，中间值本身就代表有用的概念，
明确地命名它们可以使程序更易于阅读。在其他情况下，中间值被使用多次。与大多数其他语言一样，
在 Lean 中两次写下相同的代码会导致计算两次，而将结果保存在变量中会导致计算的结果被保存并重新使用。

<!--
For instance, `unzip` is a function that transforms a list of pairs into a pair of lists.
When the list of pairs is empty, then the result of `unzip` is a pair of empty lists.
When the list of pairs has a pair at its head, then the two fields of the pair are added to the result of unzipping the rest of the list.
This definition of `unzip` follows that description exactly:
-->

例如，`unzip` 是一个将偶对列表转换为一对列表的函数。当偶对列表为空时，
`unzip` 的结果是一对空列表。当偶对列表的头部有一个偶对时，
则该偶对的两个字段将添加到列表的其余部分 `unzip` 后的结果中。`unzip` 的此定义完全遵循该描述：

```lean
{{#example_decl Examples/Intro.lean unzipBad}}
```

<!--
Unfortunately, there is a problem: this code is slower than it needs to be.
Each entry in the list of pairs leads to two recursive calls, which makes this function take exponential time.
However, both recursive calls will have the same result, so there is no reason to make the recursive call twice.
-->

不幸的是，这里存在一个问题：此代码比预期的速度要慢。
对列表中的每个条目都会导致两个递归调用，这使得此函数需要指数时间。
然而，两个递归调用都会有相同的结果，因此没有理由进行两次递归调用。

<!--
In Lean, the result of the recursive call can be named, and thus saved, using `let`.
Local definitions with `let` resemble top-level definitions with `def`: it takes a name to be locally defined, arguments if desired, a type signature, and then a body following `:=`.
After the local definition, the expression in which the local definition is available (called the _body_ of the `let`-expression) must be on a new line, starting at a column in the file that is less than or equal to that of the `let` keyword.
For instance, `let` can be used in `unzip` like this:
-->

在 Lean 中，可以使用 `let` 命名递归调用的结果，从而保存它。
使用 `let` 的局部定义类似于使用 `def` 的顶层定义：它需要一个局部定义的名称，
如果需要的话，还有参数、类型签名，然后是 `:=` 后面的主体。在局部定义之后，
局部定义可用的表达式（称为 `let` 表达式的 _body_）必须在新行上，从文件中的列开始，该列小于或等于 `let` 关键字的列。例如，`let` 可以像这样用于 "
"`unzip`：

```lean
{{#example_decl Examples/Intro.lean unzip}}
```

<!--
To use `let` on a single line, separate the local definition from the body with a semicolon.
-->

要在单行中使用 `let`，请使用分号将局部定义与主体分隔开。

<!--
Local definitions with `let` may also use pattern matching when one pattern is enough to match all cases of a datatype.
In the case of `unzip`, the result of the recursive call is a pair.
Because pairs have only a single constructor, the name `unzipped` can be replaced with a pair pattern:
-->

当一个模式足以匹配数据类型的全部情况时，使用 `let` 的局部定义也可以使用模式匹配。
在 `unzip` 的情况下，递归调用的结果是个偶对。因为偶对只有一个构造子，所以名称
`unzipped` 可以替换为偶对模式：

```lean
{{#example_decl Examples/Intro.lean unzipPat}}
```

<!--
Judicious use of patterns with `let` can make code easier to read, compared to writing the accessor calls by hand.
-->

巧妙地使用带有 `let` 的模式可以使代码更易读，而无需手动编写访问器调用。

<!--
The biggest difference between `let` and `def` is that recursive `let` definitions must be explicitly indicated by writing `let rec`.
For instance, one way to reverse a list involves a recursive helper function, as in this definition:
-->

`let` 和 `def` 之间最大的区别在于，递归 `let` 定义必须通过编写 `let rec` 明确表示。
例如，反转列表的一种方法涉及递归辅助函数，如下所示：

```lean
{{#example_decl Examples/Intro.lean reverse}}
```

<!--
The helper function walks down the input list, moving one entry at a time over to `soFar`.
When it reaches the end of the input list, `soFar` contains a reversed version of the input.
-->

辅助函数遍历输入列表，一次将一个条目移动到 `soFar`。
当它到达输入列表的末尾时，`soFar` 包含输入的反转版本。

<!--
## Type Inference
-->

## 类型推断

<!--
In many situations, Lean can automatically determine an expression's type.
In these cases, explicit types may be omitted from both top-level definitions (with `def`) and local definitions (with `let`).
For instance, the recursive call to `unzip` does not need an annotation:
-->

在许多情况下，Lean 可以自动确定表达式的类型。在这些情况下，
可以从顶层定义（使用 `def`）和局部定义（使用 `let`）中省略显式类型。
例如，对 `unzip` 的递归调用不需要标注：

```lean
{{#example_decl Examples/Intro.lean unzipNT}}
```

<!--
As a rule of thumb, omitting the types of literal values (like strings and numbers) usually works, although Lean may pick a type for literal numbers that is more specific than the intended type.
Lean can usually determine a type for a function application, because it already knows the argument types and the return type.
Omitting return types for function definitions will often work, but function arguments typically require annotations.
Definitions that are not functions, like `unzipped` in the example, do not need type annotations if their bodies do not need type annotations, and the body of this definition is a function application.
-->

根据经验，省略字面量（如字符串和数字）的类型通常有效，
尽管 Lean 可能会为字面量数字选择比预期类型更具体的类型。
Lean 通常可以确定函数应用的类型，因为它已经知道参数类型和返回类型。
省略函数定义的返回类型通常有效，但函数参数通常需要标注。
对于非函数的定义（如示例中的 `unzipped`），若其主体不需要类型标注，
且该定义的主体是一个函数应用，则该定义不需要类型标注

<!--
Omitting the return type for `unzip` is possible when using an explicit `match` expression:
-->

在使用显式 `match` 表达式时，可省略 `unzip` 的返回类型：

```lean
{{#example_decl Examples/Intro.lean unzipNRT}}
```

<!--
Generally speaking, it is a good idea to err on the side of too many, rather than too few, type annotations.
First off, explicit types communicate assumptions about the code to readers.
Even if Lean can determine the type on its own, it can still be easier to read code without having to repeatedly query Lean for type information.
Secondly, explicit types help localize errors.
The more explicit a program is about its types, the more informative the error messages can be.
This is especially important in a language like Lean that has a very expressive type system.
Thirdly, explicit types make it easier to write the program in the first place.
The type is a specification, and the compiler's feedback can be a helpful tool in writing a program that meets the specification.
Finally, Lean's type inference is a best-effort system.
Because Lean's type system is so expressive, there is no "best" or most general type to find for all expressions.
This means that even if you get a type, there's no guarantee that it's the _right_ type for a given application.
For instance, `14` can be a `Nat` or an `Int`:
-->

一般来说，宁可多加类型标注，也不要太少。首先，显式类型向读者传达了对代码的假设。
即使 Lean 可以自行确定类型，但无需反复查询 Lean 以获取类型信息，代码仍然更容易阅读。
其次，显式类型有助于定位错误。程序对其类型越明确，错误消息就越有信息量。
这在 Lean 这样的具有非常丰富的类型系统的语言中尤为重要。第三，显式类型使编写程序变得更容易。
类型是一种规范，编译器的反馈可以成为编写符合规范的程序的有用工具。
最后，Lean 的类型推断是一种尽力而为的系统。由于 Lean 的类型系统非常丰富，
因此无法为所有表达式找到「最佳」或最通用的类型。这意味着即使你得到了一个类型，
也不能保证它是给定应用的「正确」类型。例如，`14` 可以是 `Nat` 或 `Int`：

```lean
{{#example_in Examples/Intro.lean fourteenNat}}
```

```output info
{{#example_out Examples/Intro.lean fourteenNat}}
```

```lean
{{#example_in Examples/Intro.lean fourteenInt}}
```

```output info
{{#example_out Examples/Intro.lean fourteenInt}}
```

<!--
Missing type annotations can give confusing error messages.
Omitting all types from the definition of `unzip`:
-->

缺少类型标注可能会导致令人困惑的错误信息。从 `unzip` 的定义中省略所有类型：

```lean
{{#example_in Examples/Intro.lean unzipNoTypesAtAll}}
```

会导致有关 `match` 表达式的信息：

```output error
{{#example_out Examples/Intro.lean unzipNoTypesAtAll}}
```

<!--
This is because `match` needs to know the type of the value being inspected, but that type was not available.
A "metavariable" is an unknown part of a program, written `?m.XYZ` in error messages—they are described in the [section on Polymorphism](polymorphism.md).
In this program, the type annotation on the argument is required.
-->

这是因为 `match` 需要知道正在检查的值的类型，但该类型不可用。
「元变量」是程序中未知的部分，在错误消息中写为 `?m.XYZ`，
它们在[多态性](polymorphism.md)一节中进行了描述。
在此程序中，参数上的类型标注是必需的。

<!--
Even some very simple programs require type annotations.
For instance, the identity function just returns whatever argument it is passed.
With argument and type annotations, it looks like this:
-->

即使一些非常简单的程序也需要类型标注。例如，恒等函数只返回传递给它的任何参数。
使用参数和类型标注，它看起来像这样：

```lean
{{#example_decl Examples/Intro.lean idA}}
```

<!--
Lean is capable of determining the return type on its own:
-->

Lean 能够自行确定返回类型：

```lean
{{#example_decl Examples/Intro.lean idB}}
```

<!--
Omitting the argument type, however, causes an error:
-->

然而，省略参数类型会导致错误：

```lean
{{#example_in Examples/Intro.lean identNoTypes}}
```

```output error
{{#example_out Examples/Intro.lean identNoTypes}}
```

<!--
In general, messages that say something like "failed to infer" or that mention metavariables are often a sign that more type annotations are necessary.
Especially while still learning Lean, it is useful to provide most types explicitly.
-->

一般来说，类似于「无法推断」或提及元变量的消息通常表示需要更多类型标注。
特别是在学习 Lean 时，显式提供大多数类型是很有用的。

<!--
## Simultaneous Matching
-->

## 同时匹配

<!--
Pattern-matching expressions, just like pattern-matching definitions, can match on multiple values at once.
Both the expressions to be inspected and the patterns that they match against are written with commas between them, similarly to the syntax used for definitions.
Here is a version of `drop` that uses simultaneous matching:
-->

模式匹配表达式，和模式匹配定义一样，可以一次匹配多个值。
要检查的表达式和它们匹配的模式都用逗号分隔，类似于用于定义的语法。
以下是使用同时匹配的 `drop` 版本：

```lean
{{#example_decl Examples/Intro.lean dropMatch}}
```

<!--
## Natural Number Patterns
-->

## 自然数模式

<!--
In the section on [datatypes and patterns](datatypes-and-patterns.md), `even` was defined like this:
-->

在[数据类型与模式](datatypes-and-patterns.md)一节中，`even` 被定义为：

```lean
{{#example_decl Examples/Intro.lean even}}
```

<!--
Just as there is special syntax to make list patterns more readable than using `List.cons` and `List.nil` directly, natural numbers can be matched using literal numbers and `+`.
For instance, `even` can also be defined like this:
-->

就像列表模式的特殊语法比直接使用 `List.cons` 和 `List.nil` 更具可读性一样，
自然数可以使用字面数字和 `+` 进行匹配。例如，`even` 也可以这样定义：

```lean
{{#example_decl Examples/Intro.lean evenFancy}}
```

<!--
In this notation, the arguments to the `+` pattern serve different roles.
Behind the scenes, the left argument (`n` above) becomes an argument to some number of `Nat.succ` patterns, and the right argument (`1` above) determines how many `Nat.succ`s to wrap around the pattern.
The explicit patterns in `halve`, which divides a `Nat` by two and drops the remainder:
-->

在此记法中，`+` 模式的参数扮演着不同的角色。在幕后，左参数（上面的 `n`）成为一些
`Nat.succ` 模式的参数，右参数（上面的 `1`）确定包裹该模式的 `Nat.succ` 数量有多少。
`halve` 中的显式模式将 `Nat` 除以二并丢弃余数：

```lean
{{#example_decl Examples/Intro.lean explicitHalve}}
```

<!--
can be replaced by numeric literals and `+`:
-->

可用数值字面量和 `+` 代替：

```lean
{{#example_decl Examples/Intro.lean halve}}
```

<!--
Behind the scenes, both definitions are completely equivalent.
Remember: `halve n + 1` is equivalent to `(halve n) + 1`, not `halve (n + 1)`.
-->

在幕后，这两个定义完全等价。记住：`halve n + 1` 等价于 `(halve n) + 1`，而非 `halve (n + 1)`。

<!--
When using this syntax, the second argument to `+` should always be a literal `Nat`.
Even though addition is commutative, flipping the arguments in a pattern can result in errors like the following:
-->

在使用这个语法时，`+`的第二个参数应始终是一个字面量 `Nat`。
尽管加法是可交换的，但是在模式中交换参数可能会产生以下错误：

```lean
{{#example_in Examples/Intro.lean halveFlippedPat}}
```

```output error
{{#example_out Examples/Intro.lean halveFlippedPat}}
```

<!--
This restriction enables Lean to transform all uses of the `+` notation in a pattern into uses of the underlying `Nat.succ`, keeping the language simpler behind the scenes.
-->

此限制使 Lean 能够将模式中所有 `+` 号的用法转换为底层 `Nat.succ` 的用法，
从而在幕后使语言更简单。

<!--
## Anonymous Functions
-->

## 匿名函数

<!--
Functions in Lean need not be defined at the top level.
As expressions, functions are produced with the `fun` syntax.
Function expressions begin with the keyword `fun`, followed by one or more arguments, which are separated from the return expression using `=>`.
For instance, a function that adds one to a number can be written:
-->

Lean 中的函数不必在顶层定义。作为表达式，函数使用 `fun` 语法定义。
函数表达式以关键字 `fun` 开头，后跟一个或多个参数，这些参数使用 `=>` 与返回表达式分隔。
例如，可以编写一个将数字加 1 的函数：

```lean
{{#example_in Examples/Intro.lean incr}}
```

```output info
{{#example_out Examples/Intro.lean incr}}
```

<!--
Type annotations are written the same way as on `def`, using parentheses and colons:
-->

类型标注的写法与 `def` 相同，使用括号和冒号：

```lean
{{#example_in Examples/Intro.lean incrInt}}
```

```output info
{{#example_out Examples/Intro.lean incrInt}}
```

<!--
Similarly, implicit arguments may be written with curly braces:
-->

同样，隐式参数可以用大括号编写：

```lean
{{#example_in Examples/Intro.lean identLambda}}
```

```output info
{{#example_out Examples/Intro.lean identLambda}}
```

<!--
This style of anonymous function expression is often referred to as a _lambda expression_, because the typical notation used in mathematical descriptions of programming languages uses the Greek letter λ (lambda) where Lean has the keyword `fun`.
Even though Lean does permit `λ` to be used instead of `fun`, it is most common to write `fun`.
-->

这种匿名函数表达式风格通常称为  **λ-表达式（Lambda Expression）** ，
因为编程语言在数学描述中使用的典型符号，将 Lean 中使用关键字 `fun`
的地方换成了希腊字母 λ（Lambda）。即使 Lean 允许使用 `λ` 代替 `fun`，
但最常见的仍然是写作 `fun`。

<!--
Anonymous functions also support the multiple-pattern style used in `def`.
For instance, a function that returns the predecessor of a natural number if it exists can be written:
-->

匿名函数还支持 `def` 中使用的多模式风格。例如，可以编写一个返回自然数的前驱（如果存在）的函数：

```lean
{{#example_in Examples/Intro.lean predHuh}}
```

```output info
{{#example_out Examples/Intro.lean predHuh}}
```

<!--
Note that Lean's own description of the function has a named argument and a `match` expression.
Many of Lean's convenient syntactic shorthands are expanded to simpler syntax behind the scenes, and the abstraction sometimes leaks.
-->

注意，Lean 函数的描述本身有一个命名参数和一个 `match` 表达式。
Lean 的许多便捷语法缩写都会在幕后扩展为更简单的语法，但有时会泄漏抽象。

<!--
Definitions using `def` that take arguments may be rewritten as function expressions.
For instance, a function that doubles its argument can be written as follows:
-->

使用 `def` 定义带有参数的函数可以重写为函数表达式。 例如，一个将其参数加倍的函数可以写成以下形式：

```lean
{{#example_decl Examples/Intro.lean doubleLambda}}
```

<!--
When an anonymous function is very simple, like `{{#example_eval Examples/Intro.lean incrSteps 0}}`, the syntax for creating the function can be fairly verbose.
In that particular example, six non-whitespace characters are used to introduce the function, and its body consists of only three non-whitespace characters.
For these simple cases, Lean provides a shorthand.
In an expression surrounded by parentheses, a centered dot character `·` can stand for an argument, and the expression inside the parentheses becomes the function's body.
That particular function can also be written `{{#example_eval Examples/Intro.lean incrSteps 1}}`.
-->

当匿名函数非常简单时，例如 `{{#example_eval Examples/Intro.lean incrSteps 0}}`，
创建函数的语法可能相当冗长。在此例中，有六个非空白字符用于引入函数，
其函数体仅包含三个非空白字符。对于这些简单的情况，Lean 提供了一个简写。
在括号包围的表达式中，间点符号 `·` 可以表示一个参数，括号内的表达式为函数体，
因此该函数也可以写成 `{{#example_eval Examples/Intro.lean incrSteps 1}}`。

<!--
The centered dot always creates a function out of the _closest_ surrounding set of parentheses.
For instance, `{{#example_eval Examples/Intro.lean funPair 0}}` is a function that returns a pair of numbers, while `{{#example_eval Examples/Intro.lean pairFun 0}}` is a pair of a function and a number.
If multiple dots are used, then they become arguments from left to right:
-->

间点号总是将  **最靠近** 的一对括号创建为函数。
例如，`{{#example_eval Examples/Intro.lean funPair 0}}` 是返回一对数字的函数，
而 `{{#example_eval Examples/Intro.lean pairFun 0}}` 是一个函数和一个数字的偶对。
如果使用多个点，则它们按从左到右的顺序成为参数：

```lean
{{#example_eval Examples/Intro.lean twoDots}}
```

<!--
Anonymous functions can be applied in precisely the same way as functions defined using `def` or `let`.
The command `{{#example_in Examples/Intro.lean applyLambda}}` results in:
-->

匿名函数的应用方式与 `def` 或 `let` 定义的函数完全相同。
命令 `{{#example_in Examples/Intro.lean applyLambda}}` 的结果是：

```output info
{{#example_out Examples/Intro.lean applyLambda}}
```

<!--
while `{{#example_in Examples/Intro.lean applyCdot}}` results in:
-->

而 `{{#example_in Examples/Intro.lean applyCdot}}` 的结果是：

```output info
{{#example_out Examples/Intro.lean applyCdot}}
```

<!--
## Namespaces
-->

## 命名空间

<!--
Each name in Lean occurs in a _namespace_, which is a collection of names.
Names are placed in namespaces using `.`, so `List.map` is the name `map` in the `List` namespace.
Names in different namespaces do not conflict with each other, even if they are otherwise identical.
This means that `List.map` and `Array.map` are different names.
Namespaces may be nested, so `Project.Frontend.User.loginTime` is the name `loginTime` in the nested namespace `Project.Frontend.User`.
-->

Lean 中的每个名称都出现在一个  **命名空间（Namespace）** 中，这是一个名称集合。
名称使用 `.` 放在命名空间中，因此 `List.map` 是 `List` 命名空间中的名称 `map`。
不同命名空间中的名称不会相互冲突，即使它们在其他方面是相同的。
这意味着 `List.map` 和 `Array.map` 是不同的名称。
命名空间可以嵌套，因此 `Project.Frontend.User.loginTime` 是嵌套命名空间
`Project.Frontend.User` 中的名称 `loginTime`。

<!--
Names can be directly defined within a namespace.
For instance, the name `double` can be defined in the `Nat` namespace:
-->

名空间中可以直接定义名称。例如，名称 `double` 可以定义在 `Nat` 命名空间中：

```lean
{{#example_decl Examples/Intro.lean NatDouble}}
```

<!--
Because `Nat` is also the name of a type, dot notation is available to call `Nat.double` on expressions with type `Nat`:
-->

由于 `Nat` 也是一个类型的名称，因此可以使用点表示法对类型为 `Nat` 的表达式调用 `Nat.double`：

```lean
{{#example_in Examples/Intro.lean NatDoubleFour}}
```

```output info
{{#example_out Examples/Intro.lean NatDoubleFour}}
```

<!--
In addition to defining names directly in a namespace, a sequence of declarations can be placed in a namespace using the `namespace` and `end` commands.
For instance, this defines `triple` and `quadruple` in the namespace `NewNamespace`:
-->

除了直接在命名空间中定义名称外，还可以使用 `namespace` 和 `end`
命令将一系列声明放在命名空间中。例如，这在 `NewNamespace` 命名空间中定义了
`triple` 和 `quadruple`：

```lean
{{#example_decl Examples/Intro.lean NewNamespace}}
```

<!--
To refer to them, prefix their names with `NewNamespace.`:
-->

要引用它们，请在其名称前加上 `NewNamespace.`：

```lean
{{#example_in Examples/Intro.lean tripleNamespace}}
```

```output info
{{#example_out Examples/Intro.lean tripleNamespace}}
```

```lean
{{#example_in Examples/Intro.lean quadrupleNamespace}}
```

```output info
{{#example_out Examples/Intro.lean quadrupleNamespace}}
```

<!--
Namespaces may be _opened_, which allows the names in them to be used without explicit qualification.
Writing `open MyNamespace in` before an expression causes the contents of `MyNamespace` to be available in the expression.
For example, `timesTwelve` uses both `quadruple` and `triple` after opening `NewNamespace`:
-->

命名空间可以  **打开** ，这允许在不显式限定的情况下使用其中的名称。
在表达式之前编写 `open MyNamespace in` 会导致 `MyNamespace`
的内容在表达式中可用。例如，`timesTwelve` 在打开 `NewNamespace` 后同时使用了
`quadruple` 和 `triple`：

```lean
{{#example_decl Examples/Intro.lean quadrupleOpenDef}}
```

<!--
Namespaces can also be opened prior to a command.
This allows all parts of the command to refer to the contents of the namespace, rather than just a single expression.
To do this, place the `open ... in` prior to the command.
-->

命名空间也可以在命令之前打开。这能让命令中的所有部分引用命名空间的内容，
而不仅仅是在一个表达式。为此，请在命令之前写上 `open ... in`。

```lean
{{#example_in Examples/Intro.lean quadrupleNamespaceOpen}}
```

```output info
{{#example_out Examples/Intro.lean quadrupleNamespaceOpen}}
```

<!--
Function signatures show the name's full namespace.
Namespaces may additionally be opened for _all_ following commands for the rest of the file.
To do this, simply omit the `in` from a top-level usage of `open`.
-->

函数签名会显示名称的完整命名空间，还可以为文件其余部分的所有后续命令打开命名空间。
为此，只需从 `open` 的顶级用法中省略 `in`。

<!--
## if let
-->

## if let

<!--
When consuming values that have a sum type, it is often the case that only a single constructor is of interest.
For instance, given this type that represents a subset of Markdown inline elements:
-->

在使用具有和类型的值时，通常只对一个构造子感兴趣。
例如，给定一个表示 Markdown 内联元素子集的类型：

```lean
{{#example_decl Examples/Intro.lean Inline}}
```

<!--
a function that recognizes string elements and extracts their contents can be written:
-->

可以编写一个识别字符串元素并提取其内容的函数：

```lean
{{#example_decl Examples/Intro.lean inlineStringHuhMatch}}
```

<!--
An alternative way of writing this function's body uses `if` together with `let`:
-->

另一种编写此函数体的方法是将 `if` 与 `let` 联用：

```lean
{{#example_decl Examples/Intro.lean inlineStringHuh}}
```

<!--
This is very much like the pattern-matching `let` syntax.
The difference is that it can be used with sum types, because a fallback is provided in the `else` case.
In some contexts, using `if let` instead of `match` can make code easier to read.
-->

这与模式匹配 `let` 的语法非常相似，不同之处在于它可以与和类型一起使用，
因为在 `else` 的情况中提供了备选项。在某些情况下，使用 `if let` 代替
`match` 可以让代码更易读。

<!--
## Positional Structure Arguments
-->

## 带位置的结构体参数

<!--
The [section on structures](structures.md) presents two ways of constructing structures:

 1. The constructor can be called directly, as in `{{#example_in Examples/Intro.lean pointCtor}}`.
 2. Brace notation can be used, as in `{{#example_in Examples/Intro.lean pointBraces}}`.
-->

[结构体](structures.md)一节中介绍了构造结构体的两种方法：

 1. 构造子可以直接调用，如  `{{#example_in Examples/Intro.lean pointCtor}}`.
 2. 可以使用大括号表示法，如 `{{#example_in Examples/Intro.lean pointBraces}}`.

<!--
In some contexts, it can be convenient to pass arguments positionally, rather than by name, but without naming the constructor directly.
For instance, defining a variety of similar structure types can help keep domain concepts separate, but the natural way to read the code may treat each of them as being essentially a tuple.
In these contexts, the arguments can be enclosed in angle brackets `⟨` and `⟩`.
A `Point` can be written `{{#example_in Examples/Intro.lean pointPos}}`.
Be careful!
Even though they look like the less-than sign `<` and greater-than sign `>`, these brackets are different.
They can be input using `\<` and `\>`, respectively.
-->

在某些情况下，按位置传递参数要比按名称传递参数更方便，因为无需直接命名构造子。
例如，定义各种相似的结构体类型有助于保持领域概念的隔离，
但阅读代码的自然方式可能是将它们都视为本质上是一个元组。
在这些情况下，参数可以用尖括号 `⟨` 和 `⟩` 括起来，如 `Point` 可以写成 `⟨1, 2⟩`。
注意！即使它们看起来像小于号 `<` 和大于号 `>`，这些括号也不同。
它们可以分别使用 `\\<` 和 `\\>` 来输入。

<!--
Just as with the brace notation for named constructor arguments, this positional syntax can only be used in a context where Lean can determine the structure's type, either from a type annotation or from other type information in the program.
For instance, `{{#example_in Examples/Intro.lean pointPosEvalNoType}}` yields the following error:
-->

与命名构造子参数的大括号记法一样，此位置语法只能在 Lean
可以根据类型标注或程序中的其他类型信息，来确定结构体类型的语境中使用。
例如，`{{#example_in Examples/Intro.lean pointPosEvalNoType}}` 会产生以下错误：

```output error
{{#example_out Examples/Intro.lean pointPosEvalNoType}}
```

<!--
The metavariable in the error is because there is no type information available.
Adding an annotation, such as in `{{#example_in Examples/Intro.lean pointPosWithType}}`, solves the problem:
-->

错误中出现元变量是因为没有可用的类型信息。添加注释，例如
`{{#example_in Examples/Intro.lean pointPosWithType}}`，可以解决此问题：

```output info
{{#example_out Examples/Intro.lean pointPosWithType}}
```

<!--
## String Interpolation
-->

## 字符串内插

<!--
In Lean, prefixing a string with `s!` triggers _interpolation_, where expressions contained in curly braces inside the string are replaced with their values.
This is similar to `f`-strings in Python and `$`-prefixed strings in C#.
For instance,
-->

In Lean, prefixing a string with `s!` triggers _interpolation_, where expressions contained in curly braces inside the string are replaced with their values.
This is similar to `f`-strings in Python and `$`-prefixed strings in C#.
For instance,
在 Lean 中，在字符串前加上 `s!` 会触发  **内插（Interpolation）** ，
其中字符串中大括号内的表达式会被其值替换。这类似于 Python 中的 `f` 字符串和
C# 中以 `$` 为前缀的字符串。例如，

```lean
{{#example_in Examples/Intro.lean interpolation}}
```

<!--
yields the output
-->

会产生输出

```output info
{{#example_out Examples/Intro.lean interpolation}}
```

<!--
Not all expressions can be interpolated into a string.
For instance, attempting to interpolate a function results in an error.
-->

并非所有的表达式都可以内插到字符串中。例如，尝试内插一个函数会导致错误。

```lean
{{#example_in Examples/Intro.lean interpolationOops}}
```

<!--
yields the output
-->

会产生输出

```output info
{{#example_out Examples/Intro.lean interpolationOops}}
```

<!--
This is because there is no standard way to convert functions into strings.
The Lean compiler maintains a table that describes how to convert values of various types into strings, and the message `failed to synthesize instance` means that the Lean compiler didn't find an entry in this table for the given type.
This uses the same language feature as the `deriving Repr` syntax that was described in the [section on structures](structures.md).
-->

这是因为没有将函数转换为字符串的标准方法。Lean 编译器维护了一个表，
描述如何将各种类型的值转换为字符串，而消息 `failed to synthesize instance`
意味着 Lean 编译器未在此表中找到给定类型的条目。
这使用了与[结构体](structures.md)一节中描述的 `deriving Repr` 语法相同的语言特性。
