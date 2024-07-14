<!-- # Worked Example: Typed Queries -->
# 实际案例：类型化查询

<!-- Indexed families are very useful when building an API that is supposed to resemble some other language.
They can be used to write a library of HTML constructors that don't permit generating invalid HTML, to encode the specific rules of a configuration file format, or to model complicated business constraints.
This section describes an encoding of a subset of relational algebra in Lean using indexed families, as a simpler demonstration of techniques that can be used to build a more powerful database query language. -->
类型族在构建一个模仿其他语言的 API 时非常有用。
它们可以用来编写一个保证生成合法页面的 HTML 生成器，或者编码某种文件格式的配置，或是用来建模复杂的业务约束。
本节描述了如何在 Lean 中使用索引族对关系代数的一个子集进行编码，然而本节的展示的技术完全可以被用来构建一个更加强大的数据库查询语言。

<!-- This subset uses the type system to enforce requirements such as disjointness of field names, and it uses type-level computation to reflect the schema into the types of values that are returned from a query.
It is not a realistic system, however—databases are represented as linked lists of linked lists, the type system is much simpler than that of SQL, and the operators of relational algebra don't really match those of SQL.
However, it is large enough to demonstrate useful principles and techniques. -->
这个子集使用类型系统来保证某些要求，比如字段名称的不相交性，并使用类型上的计算将数据库模式（Schema）反映到从查询返回的值的类型中。
它并不是一个实际的数据库系统——数据库用链表的链表表示；类型系统比 SQL 的简单得多；关系代数的运算符与 SQL 的运算符并不完全匹配。
然而，它足够用来展示使用索引族的一些有用的原则和技术。

<!-- ## A Universe of Data -->
## 一个数据的宇宙

<!-- In this relational algebra, the base data that can be held in columns can have types `Int`, `String`, and `Bool` and are described by the universe `DBType`: -->
在这个关系代数中，保存在列中的基本数据的类型包括 `Int`、`String` 和 `Bool`，并由宇宙 `DBType` 描述：

```lean
{{#example_decl Examples/DependentTypes/DB.lean DBType}}
```

<!-- Using `asType` allows these codes to be used for types.
For example: -->
`asType` 将这些编码转化为类型：

```lean
{{#example_in Examples/DependentTypes/DB.lean mountHoodEval}}
```
```output info
{{#example_out Examples/DependentTypes/DB.lean mountHoodEval}}
```

<!-- It is possible to compare the values described by any of the three database types for equality.
Explaining this to Lean, however, requires a bit of work.
Simply using `BEq` directly fails: -->
可以对三种类型的任何两个值都判断是否相等。
然而，向 Lean 解释这一点需要一些工作。
直接使用 `BEq` 会失败：

```lean
{{#example_in Examples/DependentTypes/DB.lean dbEqNoSplit}}
```
```output info
{{#example_out Examples/DependentTypes/DB.lean dbEqNoSplit}}
```
<!-- Just as in the nested pairs universe, type class search doesn't automatically check each possibility for `t`'s value
The solution is to use pattern matching to refine the types of `x` and `y`: -->
就像在嵌套对的宇宙中一样，类型类搜索不会自动检查 `t` 的值的每种可能性。
解决方案是使用模式匹配来细化 `x` 和 `y` 的类型：

```lean
{{#example_decl Examples/DependentTypes/DB.lean dbEq}}
```
<!-- In this version of the function, `x` and `y` have types `Int`, `String`, and `Bool` in the three respective cases, and these types all have `BEq` instances.
The definition of `dbEq` can be used to define a `BEq` instance for the types that are coded for by `DBType`: -->
在这个版本的函数中，`x` 和 `y` 在三种情况下的类型分别为 `Int`、`String` 和 `Bool`，这些类型都有 `BEq` 实例。
`dbEq` 的定义可以用来为 `DBType` 编码的类型定义一个 `BEq` 实例：

```lean
{{#example_decl Examples/DependentTypes/DB.lean BEqDBType}}
```
<!-- This is not the same as an instance for the codes themselves: -->
这个实例与编码本身的实例不同：
```lean
{{#example_decl Examples/DependentTypes/DB.lean BEqDBTypeCodes}}
```
<!-- The former instance allows comparison of values drawn from the types described by the codes, while the latter allows comparison of the codes themselves. -->
前一个实例允许比较编码描述的类型中的值，而后一个实例允许比较编码本身。
 
<!-- A `Repr` instance can be written using the same technique.
The method of the `Repr` class is called `reprPrec` because it is designed to take things like operator precedence into account when displaying values.
Refining the type through dependent pattern matching allows the `reprPrec` methods from the `Repr` instances for `Int`, `String`, and `Bool` to be used: -->
一个 `Repr` 实例可以使用相同的技术编写。
`Repr` 类的方法被称为 `reprPrec`，因为它在显示值时考虑了操作符优先级等因素。
通过依值模式匹配细化类型，可以使用 `Int`、`String` 和 `Bool` 的 `Repr` 实例的 `reprPrec` 方法：

```lean
{{#example_decl Examples/DependentTypes/DB.lean ReprAsType}}
```

<!-- ## Schemas and Tables -->
## 数据库模式和表

<!-- A schema describes the name and type of each column in a database: -->
一个数据库模式描述了数据库中每一列的名称和类型：

```lean
{{#example_decl Examples/DependentTypes/DB.lean Schema}}
```
<!-- In fact, a schema can be seen as a universe that describes rows in a table.
The empty schema describes the unit type, a schema with a single column describes that value on its own, and a schema with at least two columns is represented by a tuple: -->
事实上，数据库模式可以看作是描述表中行的宇宙。
空数据库模式描述了 `Unit` 类型，具有单个列的数据库模式描述了那个值本身，具有至少两个列的数据库模式可以有由元组表示：

```lean
{{#example_decl Examples/DependentTypes/DB.lean Row}}
```

<!-- As described in [the initial section on product types](../getting-to-know/polymorphism.md#prod), Lean's product type and tuples are right-associative.
This means that nested pairs are equivalent to ordinary flat tuples. -->

正如在[积类型的起始节](../getting-to-know/polymorphism.md#prod)中描述的那样，Lean 的积类型和元组是右结合的。
这意味着嵌套对等同于普通的展平元组。


<!-- A table is a list of rows that share a schema: -->
表是一个共享数据库模式的行的列表：

```lean
{{#example_decl Examples/DependentTypes/DB.lean Table}}
```
<!-- For example, a diary of visits to mountain peaks can be represented with the schema `peak`: -->
例如，可以用数据库模式 `peak` 表示对山峰的拜访日记：

```lean
{{#example_decl Examples/DependentTypes/DB.lean peak}}
```
<!-- A selection of peaks visited by the author of this book appears as an ordinary list of tuples: -->
本书作者拜访过的部分山峰以元组的列表呈现：

```lean
{{#example_decl Examples/DependentTypes/DB.lean mountainDiary}}
```
<!-- Another example consists of waterfalls and a diary of visits to them: -->
另一个例子包括瀑布和对它们的拜访日记：

```lean
{{#example_decl Examples/DependentTypes/DB.lean waterfall}}

{{#example_decl Examples/DependentTypes/DB.lean waterfallDiary}}
```

<!-- ### Recursion and Universes, Revisited -->
### 回顾递归和宇宙

<!-- The convenient structuring of rows as tuples comes at a cost: the fact that `Row` treats its two base cases separately means that functions that use `Row` in their types and are defined recursively over the codes (that, is the schema) need to make the same distinctions.
One example of a case where this matters is an equality check that uses recursion over the schema to define a function that checks rows for equality.
This example does not pass Lean's type checker: -->
将行结构化为元组的方便性是有代价的：`Row` 将其两个基情形的分开处理意味着在类型中使用 `Row` 和在编码（即数据库模式）上递归定义的函数需要做出相同的区分。
一个具体的例子是一个通过对数据库模式递归检查行是否相等的函数。
下面的实现无法通过 Lean 的类型检查：

```lean
{{#example_in Examples/DependentTypes/DB.lean RowBEqRecursion}}
```
```output error
{{#example_out Examples/DependentTypes/DB.lean RowBEqRecursion}}
```
<!-- The problem is that the pattern `col :: cols` does not sufficiently refine the type of the rows.
This is because Lean cannot yet tell whether the singleton pattern `[col]` or the `col1 :: col2 :: cols` pattern in the definition of `Row` was matched, so the call to `Row` does not compute down to a pair type.
The solution is to mirror the structure of `Row` in the definition of `Row.bEq`: -->
问题在于模式 `col :: cols` 并没有足够细化行的类型。
这是因为 Lean 无法确定到底是 `Row` 定义中的哪种模式被匹配上：单例模式 `[col]` 或是 `col1 :: col2 :: cols` 模式。因此对 `Row` 的调用不会计算到一个有序对类型。
解决方案是在 `Row.bEq` 的定义中反映 `Row` 的结构：

```lean
{{#example_decl Examples/DependentTypes/DB.lean RowBEq}}
```

<!-- Unlike in other contexts, functions that occur in types cannot be considered only in terms of their input/output behavior.
Programs that use these types will find themselves forced to mirror the algorithm used in the type-level function so that their structure matches the pattern-matching and recursive behavior of the type.
A big part of the skill of programming with dependent types is the selection of appropriate type-level functions with the right computational behavior. -->
不同于其他上下文，出现在类型中的函数不能仅仅考虑其输入/输出行为。
使用这些类型的程序将发现自己被迫镜像那些类型中使用到的函数所使用的算法，以便它们的结构与类型的模式匹配和递归行为相匹配。
使用依赖类型编程的技巧的一个重要部分是在类型的计算中选择具有正确计算行为函数。


<!-- ### Column Pointers -->
### 列指针

<!-- Some queries only make sense if a schema contains a particular column.
For example, a query that returns mountains with an elevation greater than 1000 meters only makes sense in the context of a schema with a `"elevation"` column that contains integers.
One way to indicate that a column is contained in a schema is to provide a pointer directly to it, and defining the pointer as an indexed family makes it possible to rule out invalid pointers. -->
如果数据库模式包含特定列，那么某些查询才有意义。
例如，一个返回海拔高于 1000 米的山的查询只在包含整数的 `"elevation"` 列的数据库模式中才有意义。
一种表示数据库模式包含某个列的方法是直接提供指向这个列的指针。将指针定义为一个索引族使得可以排除无效指针。

<!-- There are two ways that a column can be present in a schema: either it is at the beginning of the schema, or it is somewhere later in the schema.
Eventually, if a column is later in a schema, then it will be the beginning of some tail of the schema. -->
列可以出现在数据库模式的两个地方：要么在它的开头，要么在它的后面的某个地方。
如果列出现在模式的后面的某个地方，那么它也必然是某一个尾数据库模式的开头。

<!-- The indexed family `HasCol` is a translation of the specification into Lean code: -->
索引族 `HasCol` 将这种规范表达为 Lean 的代码：

```lean
{{#example_decl Examples/DependentTypes/DB.lean HasCol}}
```
<!-- The family's three arguments are the schema, the column name, and its type.
All three are indices, but re-ordering the arguments to place the schema after the column name and type would allow the name and type to be parameters.
The constructor `here` can be used when the schema begins with the column `⟨name, t⟩`; it is thus a pointer to the first column in the schema that can only be used when the first column has the desired name and type.
The constructor `there` transforms a pointer into a smaller schema into a pointer into a schema with one more column on it. -->
这个族的三个实参是数据库模式、列名和它的类型。
所有三个参数都是索引，但重新排列实参，将数据库模式放在列名和类型之后，可以使列名和类型成为形参。
当数据库模式以列 `⟨name, t⟩` 开头时，可以使用构造子 `here`：它是一个指向当前数据库模式的第一列的指针，只有当第一列具有所需的名称和类型时才能使用。
构造函数 `there` 将一个指向较小数据库模式的指针转换为一个指向在头部包含在一个额外列的数据库模式的指针。

<!-- Because `"elevation"` is the third column in `peak`, it can be found by looking past the first two columns with `there`, after which it is the first column.
In other words, to satisfy the type `{{#example_out Examples/DependentTypes/DB.lean peakElevationInt}}`, use the expression `{{#example_in Examples/DependentTypes/DB.lean peakElevationInt}}`.
One way to think about `HasCol` is as a kind of decorated `Nat`—`zero` corresponds to `here`, and `succ` corresponds to `there`.
The extra type information makes it impossible to have off-by-one errors. -->
因为 `"elevation"` 是 `peak` 中的第三列，所以可以通过 `there` 跳过前两列然后使用 `here` 找到它。
换句话说，要满足类型 `{{#example_out Examples/DependentTypes/DB.lean peakElevationInt}}`，使用表达式 `{{#example_in Examples/DependentTypes/DB.lean peakElevationInt}}`。
`HasCol` 也可以理解为是一种带有修饰的 `Nat`——`zero` 对应于 `here`，`succ` 对应于 `there`。
额外的类型信息使得不可能出现列序号偏差了一位之类的错误。

<!-- A pointer to a particular column in a schema can be used to extract that column's value from a row: -->
指向数据库模式中的列的指针可以用来从行中提取该列的值：

```lean
{{#example_decl Examples/DependentTypes/DB.lean Rowget}}
```
<!-- The first step is to pattern match on the schema, because this determines whether the row is a tuple or a single value.
No case is needed for the empty schema because there is a `HasCol` available, and both constructors of `HasCol` specify non-empty schemas.
If the schema has just a single column, then the pointer must point to it, so only the `here` constructor of `HasCol` need be matched.
If the schema has two or more columns, then there must be a case for `here`, in which case the value is the first one in the row, and one for `there`, in which case a recursive call is used.
Because the `HasCol` type guarantees that the column exists in the row, `Row.get` does not need to return an `Option`. -->
第一步是对数据库模式进行模式匹配，因为这决定了行是元组还是单个值。
空模式的情形不需要考虑，因为 `HasCol`的两个构造函数都对应着非空的数据库模式。
如果数据库模式只有一个列，那么指针必须指向它，因此只需要匹配 `HasCol` 的 `here` 构造函数。
如果数据库模式有两个或更多列，那么必须有一个 `here` 情况，此时值是行中的第一个值，以及一个 `there` 情况，此时需要进行递归调用。
`HasCol` 类型保证了列存在于行中，所以 `Row.get` 不需要返回一个 `Option`。

<!-- `HasCol` plays two roles: -->
`HasCol` 扮演了两个角色：
 <!-- 1. It serves as _evidence_ that a column with a particular name and type exists in a schema. -->
 1. 它作为**证据**，证明模式中存在具有特定名称和类型的列。

 <!-- 2. It serves as _data_ that can be used to find the value associated with the column in a row. -->
 2. 它作为**数据**，可以用来在行中找到与列关联的值。

<!-- The first role, that of evidence, is similar to way that propositions are used.
The definition of the indexed family `HasCol` can be read as a specification of what counts as evidence that a given column exists.
Unlike propositions, however, it matters which constructor of `HasCol` was used.
In the second role, the constructors are used like `Nat`s to find data in a collection.
Programming with indexed families often requires the ability to switch fluently between both perspectives. -->
第一个角色，即证据的角色，类似于命题的使用方式。
索引族 `HasCol` 的定义可以被视为一个规范，说明什么样的证据可以证明给定的列存在。
然而，与命题不同，使用 `HasCol` 的哪个构造子很重要。
在第二个角色中，构造子起到类似 `Nat`的作用，用于在集合中查找数据。
使用索引族编程通常需要能够流畅地使用它的这两个角色。

<!-- ### Subschemas -->
### 子数据库模式

<!-- One important operation in relational algebra is to _project_ a table or row into a smaller schema.
Every column not present in the smaller schema is forgotten.
In order for projection to make sense, the smaller schema must be a subschema of the larger schema, which means that every column in the smaller schema must be present in the larger schema.
Just as `HasCol` makes it possible to write a single-column lookup in a row that cannot fail, a representation of the subschema relationship as an indexed family makes it possible to write a projection function that cannot fail. -->
关系代数中的一个重要操作是将表或行**投影**到一个较小的数据库模式中。
不在这一数据库模式中的每一列都会被舍弃。
为了使投影有意义，小数据库模式必须是大数据库模式的子数据库模式：小数据库模式中的每一列都必须存在于大数据库模式中。
正如 `HasCol` 允许我们编写一个从行中提取某个列函数且这个函数一定不会失败一样，
将子模式关系表示为索引族允许我们编写一个不会失败的投影函数。

<!-- The ways in which one schema can be a subschema of another can be defined as an indexed family.
The basic idea is that a smaller schema is a subschema of a bigger schema if every column in the smaller schema occurs in the bigger schema.
If the smaller schema is empty, then it's certainly a subschema of the bigger schema, represented by the constructor `nil`.
If the smaller schema has a column, then that column must be in the bigger schema, and all the rest of the columns in the subschema must also be a subschema of the bigger schema.
This is represented by the constructor `cons`. -->
可以将“一个数据库模式是另一个数据库模式的子数据库模式”定义为一个索引族。
基本思想是，如果小数据库模式中的每一列都出现在大数据库模式中，那么小数据库模式就是大数据库模式的子数据库模式。
如果小数据库模式为空，则它肯定是大数据库模式的子数据库模式，由构造子 `nil` 表示。
如果小数据库模式有一列，那么该列必须在大数据库模式中且子数据库模式中的其余列也必须是大数据库模式的子数据库模式。
这由构造函数 `cons` 表示。

```lean
{{#example_decl Examples/DependentTypes/DB.lean Subschema}}
```
<!-- In other words, `Subschema` assigns each column of the smaller schema a `HasCol` that points to its location in the larger schema. -->
换句话说，`Subschema` 为小数据库模式的每一列分配一个 `HasCol`，该 `HasCol` 指向大数据库模式中的位置。

<!-- The schema `travelDiary` represents the fields that are common to both `peak` and `waterfall`: -->
模式 `travelDiary` 表示 `peak` 和 `waterfall` 共有的字段：

```lean
{{#example_decl Examples/DependentTypes/DB.lean travelDiary}}
```
<!-- It is certainly a subschema of `peak`, as shown by this example: -->
正如这个例子所示，它肯定是 `peak` 的子数据库模式：

```lean
{{#example_decl Examples/DependentTypes/DB.lean peakDiarySub}}
```
<!-- However, code like this is difficult to read and difficult to maintain.
One way to improve it is to instruct Lean to write the `Subschema` and `HasCol` constructors automatically.
This can be done using the tactic feature that was introduced in [the Interlude on propositions and proofs](../props-proofs-indexing.md).
That interlude uses `by simp` to provide evidence of various propositions. -->
然而，这样的代码很难阅读和维护。
改进的一种方法是指导 Lean 自动编写 `Subschema` 和 `HasCol` 构造子。
这可以通过使用[关于命题和证明的插曲](../props-proofs-indexing.md)中介绍的策术特性来完成。
该插曲使用 `by simp` 提供了各种命题的证据。

<!-- In this context, two tactics are useful:
 * The `constructor` tactic instructs Lean to solve the problem using the constructor of a datatype.
 * The `repeat` tactic instructs Lean to repeat a tactic over and over until it either fails or the proof is finished. -->
在这种情况下，两种策术是有用的：
 * `constructor` 策术指示 Lean 使用数据类型的构造子解决问题。
 * `repeat` 策术指示 Lean 重复一个策术，直到它失败或证明完成。
 
<!-- In the next example, `by constructor` has the same effect as just writing `.nil` would have: -->
下一个例子中，`by constructor` 的效果与直接写 `.nil` 是一样的：

```leantac
{{#example_decl Examples/DependentTypes/DB.lean emptySub}}
```
<!-- However, attempting that same tactic with a slightly more complicated type fails: -->
然而，在一个稍微复杂的类型下尝试相同的策术会失败：

```leantac
{{#example_in Examples/DependentTypes/DB.lean notDone}}
```
```output error
{{#example_out Examples/DependentTypes/DB.lean notDone}}
```
<!-- Errors that begin with `unsolved goals` describe tactics that failed to completely build the expressions that they were supposed to.
In Lean's tactic language, a _goal_ is a type that a tactic is to fulfill by constructing an appropriate expression behind the scenes.
In this case, `constructor` caused `Subschema.cons` to be applied, and the two goals represent the two arguments expected by `cons`.
Adding another instance of `constructor` causes the first goal (`HasCol peak \"location\" DBType.string`) to be addressed with `HasCol.there`, because `peak`'s first column is not `"location"`: -->
以 `unsolved goals` 开头的错误描述了策术未能完全构建它们应该构建的表达式。
在 Lean 的策略语言中，**证明目标（goal）** 是策术需要通过构造适当的表达式来实现的类型。
在这种情况下，`constructor` 导致应用 `Subschema.cons`，两个目标表示 `cons` 期望的两个参数。
添加另一个 `constructor` 实例导致第一个目标（`HasCol peak \"location\" DBType.string`）被 `HasCol.there` 处理，因为 `peak` 的第一列不是 `"location"`：

```leantac
{{#example_in Examples/DependentTypes/DB.lean notDone2}}
```
```output error
{{#example_out Examples/DependentTypes/DB.lean notDone2}}
```
<!-- However, adding a third `constructor` results in the first goal being solved, because `HasCol.here` is applicable: -->
然而，添加第三个 `constructor` 解决了第一个证明目标，因为 `HasCol.here` 是适用的：

```leantac
{{#example_in Examples/DependentTypes/DB.lean notDone3}}
```
```output error
{{#example_out Examples/DependentTypes/DB.lean notDone3}}
```
<!-- A fourth instance of `constructor` solves the `Subschema peak []` goal: -->
第四个 `constructor` 实例解决了 `Subschema peak []` 目标：

```leantac
{{#example_decl Examples/DependentTypes/DB.lean notDone4}}
```
<!-- Indeed, a version written without the use of tactics has four constructors: -->
事实上，一个没有使用策术的版本有四个构造函数：

```lean
{{#example_decl Examples/DependentTypes/DB.lean notDone5}}
```

<!-- Instead of experimenting to find the right number of times to write `constructor`, the `repeat` tactic can be used to ask Lean to just keep trying `constructor` as long as it keeps making progress: -->
不要尝试找到写 `constructor` 的正确次数，可以使用 `repeat` 策术要求 Lean 只要取得进展就继续尝试 `constructor`：

```leantac
{{#example_decl Examples/DependentTypes/DB.lean notDone6}}
```
<!-- This more flexible version also works for more interesting `Subschema` problems: -->
这个更灵活的版本也适用于更有趣的 `Subschema` 问题：

```leantac
{{#example_decl Examples/DependentTypes/DB.lean subschemata}}
```

<!-- The approach of blindly trying constructors until something works is not very useful for types like `Nat` or `List Bool`.
Just because an expression has type `Nat` doesn't mean that it's the _correct_ `Nat`, after all.
But types like `HasCol` and `Subschema` are sufficiently constrained by their indices that only one constructor will ever be applicable, which means that the contents of the program itself are less interesting, and a computer can pick the correct one. -->
盲目尝试构造子直到某个符合预期类型的值被构造出来的方法对于 `Nat` 或 `List Bool` 这样的类型并不是很有用。
毕竟，一个表达式的类型是 `Nat` 并不意味着它是 **正确的** `Nat`。
但 `HasCol` 和 `Subschema` 这样的类型受到索引的约束，
只有一个构造子适用。
这意味着程序本身是平凡的，计算机可以选择正确的构造子。


<!-- If one schema is a subschema of another, then it is also a subschema of the larger schema extended with an additional column.
This fact can be captured as a function definition.
`Subschema.addColumn` takes evidence that `smaller` is a subschema of `bigger`, and then returns evidence that `smaller` is a subschema of `c :: bigger`, that is, `bigger` with one additional column: -->
如果一个数据库模式是另一个数据库模式的子数据库模式，那么它也是扩展了一个额外列的更大数据库模式的子数据库模式。
这个事实被下列函数定义表示出来。
`Subschema.addColumn` 接受 `smaller` 是 `bigger` 的子数据库模式的证据，然后返回 `smaller` 是 `c :: bigger` 的子数据库模式的证据，即，`bigger` 增加了一个额外列：

```lean
{{#example_decl Examples/DependentTypes/DB.lean SubschemaAdd}}
```
<!-- A subschema describes where to find each column from the smaller schema in the larger schema.
`Subschema.addColumn` must translate these descriptions from the original larger schema into the extended larger schema.
In the `nil` case, the smaller schema is `[]`, and `nil` is also evidence that `[]` is a subschema of `c :: bigger`.
In the `cons` case, which describes how to place one column from `smaller` into `larger`, the placement of the column needs to be adjusted with `there` to account for the new column `c`, and a recursive call adjusts the rest of the columns. -->
子数据库模式描述了在大数据库模式中找到小数据库模式的每一列的位置。
`Subschema.addColumn` 必须将这些描述从指向原始的大数据库模式转换为指向扩展后的更大数据库模式。
在 `nil` 情况下，小数据库模式是 `[]`，`nil` 也是 `[]` 是 `c :: bigger` 的子数据库模式的证据。
在 `cons` 情况下，它描述了如何将 `smaller` 中的一列放入 `larger`，需要使用 `there` 调整列的放置位置以考虑新列 `c`，递归调用调整其余列。


<!-- Another way to think about `Subschema` is that it defines a _relation_ between two schemas—the existence of an expression  with type `Subschema bigger smaller` means that `(bigger, smaller)` is in the relation.
This relation is reflexive, meaning that every schema is a subschema of itself: -->
另一个思考 `Subschema` 的方式是它定义了两个数据库模式之间的 **关系** —— 存在一个类型为 `Subschema bigger smaller` 的表达式意味着 `(bigger, smaller)` 在这个关系中。
这个关系是自反的，意味着每个数据库模式都是自己的子数据库模式：

```lean
{{#example_decl Examples/DependentTypes/DB.lean SubschemaSame}}
```


<!-- ### Projecting Rows -->
### 投影行

<!-- Given evidence that `s'` is a subschema of `s`, a row in `s` can be projected into a row in `s'`.
This is done using the evidence that `s'` is a subschema of `s`, which explains where each column of `s'` is found in `s`.
The new row in `s'` is built up one column at a time by retrieving the value from the appropriate place in the old row. -->
给定 `s'` 是 `s` 的子数据库模式的证据，可以将 `s` 中的行投影到 `s'` 中的行。
这是通过分析 `s'` 是 `s` 的子数据库模式的证据完成的：它解释了 `s'` 的每一列在 `s` 中的位置。
在 `s'` 中的新行是通过从旧行的适当位置检索值逐列构建的。

<!-- The function that performs this projection, `Row.project`, has three cases, one for each case of `Row` itself.
It uses `Row.get` together with each `HasCol` in the `Subschema` argument to construct the projected row: -->
执行这种投影的函数 `Row.project` 有三种情形，分别对应于 `Row` 本身的三种情形。
它使用 `Row.get` 与 `Subschema` 参数中的每个 `HasCol` 一起构造投影行：

```lean
{{#example_decl Examples/DependentTypes/DB.lean RowProj}}
```


<!-- ## Conditions and Selection -->
## 条件和选取

<!-- Projection removes unwanted columns from a table, but queries must also be able to remove unwanted rows.
This operation is called _selection_.
Selection relies on having a means of expressing which rows are desired. -->
投影从表中删除不需要的列，但查询也必须能够删除不需要的行。
这个操作称为 **选择（selection）**。
选择的前提是有一种表达“哪些行是需要的”的方式。

<!-- The example query language contains expressions, which are analogous to what can be written in a `WHERE` clause in SQL.
Expressions are represented by the indexed family `DBExpr`.
Because expressions can refer to columns from the database, but different sub-expressions all have the same schema, `DBExpr` takes the database schema as a parameter.
Additionally, each expression has a type, and these vary, making it an index: -->
示例查询语言包含表达式，类似于 SQL 中可以写在 `WHERE` 子句中的内容。
表达式由索引族 `DBExpr` 表示。
表达式可以引用数据库中的列，但不同的子表达式都有相同的数据库模式。`DBExpr` 以数据库模式作为形参。
此外，每个表达式都有一个类型，这些类型不同，所以这是一个索引：

```lean
{{#example_decl Examples/DependentTypes/DB.lean DBExpr}}
```
<!-- The `col` constructor represents a reference to a column in the database.
The `eq` constructor compares two expressions for equality, `lt` checks whether one is less than the other, `and` is Boolean conjunction, and `const` is a constant value of some type. -->

`col` 构造子表示对数据库中的列的引用。
`eq` 构造子比较两个表达式是否相等，`lt` 检查一个是否小于另一个，`and` 是布尔合取，`const` 是某种类型的常量值。

<!-- For example, an expression in `peak` that checks whether the `elevation` column is greater than 1000 and the location is `"Denmark"` can be written: -->
例如，在 `peak` 中检查 `elevation` 列的值大于 1000 并且位置等于 `"Denmark"` 的表达式可以写为：

```leantac
{{#example_decl Examples/DependentTypes/DB.lean tallDk}}
```
<!-- This is somewhat noisy.
In particular, references to columns contain boilerplate calls to `by repeat constructor`.
A Lean feature called _macros_ can help make expressions easier to read by eliminating this boilerplate: -->
这有点复杂。
特别是，对列的引用包含了重复的对 `by repeat constructor` 的调用。
Lean 的一个特性叫做 **宏（macro）**，可以消除这些重复代码，使表达式更易于阅读：

```leantac
{{#example_decl Examples/DependentTypes/DB.lean cBang}}
```
<!-- This declaration adds the `c!` keyword to Lean, and instructs Lean to replace any instance of `c!` followed by an expression with the corresponding `DBExpr.col` construction.
Here, `term` stands for Lean expressions, rather than commands, tactics, or some other part of the language.
Lean macros are a bit like C preprocessor macros, except they are better integrated into the language and they automatically avoid some of the pitfalls of CPP.
In fact, they are very closely related to macros in Scheme and Racket. -->
这个声明为 Lean 添加了 `c!` 关键字，并指示 Lean 用相应的 `DBExpr.col` 构造替换后面跟着的任何 `c!` 实例。
这里，`term` 代表 Lean 表达式，而不是命令、策术或语言的其他部分。
Lean 宏有点像 C 预处理器宏，只是它们更好地集成到语言中，并且它们自动避免了 CPP 的一些陷阱。
事实上，它们与 Scheme 和 Racket 中的宏非常密切相关。

<!-- With this macro, the expression can be much easier to read: -->
有了这个宏，表达式就容易阅读得多：

```lean
{{#example_decl Examples/DependentTypes/DB.lean tallDkBetter}}
```

<!-- Finding the value of an expression with respect to a given row uses `Row.get` to extract column references, and it delegates to Lean's operations on values for every other expression: -->
求某行在一个表达式下的值包括对表达式中的 `.col` 调用 `Row.get` 提取列引用，其他构造子则委托给 Lean 中对应的运算进行处理：

```lean
{{#example_decl Examples/DependentTypes/DB.lean DBExprEval}}
```

<!-- Evaluating the expression for Valby Bakke, the tallest hill in the Copenhagen area, yields `false` because Valby Bakke is much less than 1 km over sea level: -->
对 Valby Bakke，哥本哈根地区最高的山，求值得到 `false`，因为 Valby Bakke 的海拔远低于 1 km：

```lean
{{#example_in Examples/DependentTypes/DB.lean valbybakke}}
```
```output info
{{#example_out Examples/DependentTypes/DB.lean valbybakke}}
```
<!-- Evaluating it for a fictional mountain of 1230m elevation yields `true`: -->
对一个海拔 1230 米的虚构的山求值得到 `true`：

```lean
{{#example_in Examples/DependentTypes/DB.lean fakeDkBjerg}}
```
```output info
{{#example_out Examples/DependentTypes/DB.lean fakeDkBjerg}}
```
<!-- Evaluating it for the highest peak in the US state of Idaho yields `false`, as Idaho is not part of Denmark: -->
为美国爱达荷州最高峰求值得到 `false`，因为爱达荷州不是丹麦的一部分：

```lean
{{#example_in Examples/DependentTypes/DB.lean borah}}
```
```output info
{{#example_out Examples/DependentTypes/DB.lean borah}}
```

<!-- ## Queries -->
## 查询

<!-- The query language is based on relational algebra.
In addition to tables, it includes the following operators:
 1. The union of two expressions that have the same schema combines the rows that result from two queries
 2. The difference of two expressions that have the same schema removes rows found in the second result from the rows in the first result
 3. Selection by some criterion filters the result of a query according to an expression
 4. Projection into a subschema, removing columns from the result of a query
 5. Cartesian product, combining every row from one query with every row from another
 6. Renaming a column in the result of a query, which modifies its schema
 7. Prefixing all columns in a query with a name -->
查询语言基于关系代数。
除了表之外，它还包括以下运算符：
 1. 并，将两个具有相同数据库模式的表达式的查询的结果行合并
 2. 差，定义在两个具有相同数据库模式的表达式，从第一个表达式的查询结果中删除同时存在于第二个表达式的查询结果的行
 3. 选择，按照某些标准，根据表达式过滤查询的结果
 4. 投影，从查询结果中删除列
 5. 笛卡尔积，将一个查询的每一行与另一个查询的每一行组合
 6. 重命名，修改查询结果中某一个列的名字
 7. 添加前缀，为查询中的所有列名添加一个前缀
  
<!-- The last operator is not strictly necessary, but it makes the language more convenient to use. -->
最后一个运算符不是严格必要的，但它使语言更方便使用。

<!-- Once again, queries are represented by an indexed family: -->
查询同样由一个索引族表示：

```lean
{{#example_decl Examples/DependentTypes/DB.lean Query}}
```
<!-- The `select` constructor requires that the expression used for selection return a Boolean.
The `product` constructor's type contains a call to `disjoint`, which ensures that the two schemas don't share any names: -->
`select` 构造函数要求用于选择的表达式返回一个布尔值。
`product` 构造函数的类型包含对 `disjoint` 的调用，它确保两个数据库模式没有相同的列名：

```lean
{{#example_decl Examples/DependentTypes/DB.lean disjoint}}
```
<!-- The use of an expression of type `Bool` where a type is expected triggers a coercion from `Bool` to `Prop`.
Just as decidable propositions can be considered to be Booleans, where evidence for the proposition is coerced to `true` and refutations of the proposition are coerced to `false`, Booleans are coerced into the proposition that states that the expression is equal to `true`.
Because all uses of the library are expected to occur in contexts where the schemas are known ahead of time, this proposition can be proved with `by simp`.
Similarly, the `renameColumn` constructor checks that the new name does not already exist in the schema.
It uses the helper `Schema.renameColumn` to change the name of the column pointed to by `HasCol`: -->
将 `Bool` 类型的表达式用在期望一个类型的位置会触发从 `Bool` 到 `Prop` 的强制转换。<!-- TODO: coercion -->
正如可判定命题被视为一个布尔值：命题的证据被强制转换为 `true`，命题的反驳被强制转换为 `false`，布尔值也可以反过来被强制转换为表达式等于 `true` 的命题。
因为预期所有库的使用将发生在数据库模式已经给定的场景下，所以这个命题可以用 `by simp` 证明。
类似地，`renameColumn` 构造子检查新名称是否已经存在于数据库模式中。
它使用辅助函数 `Schema.renameColumn` 来更改 `HasCol` 指向的列的名称：

```lean
{{#example_decl Examples/DependentTypes/DB.lean renameColumn}}
```

<!-- ## Executing Queries -->
## 执行查询

<!-- Executing queries requires a number of helper functions.
The result of a query is a table; this means that each operation in the query language requires a corresponding implementation that works with tables. -->
执行查询需要一些辅助函数。
查询的结果是一个表。
这意味着查询语言中的每个操作都需要一个可以与表一起工作的实现。

<!-- ### Cartesian Product -->
### 笛卡尔积

<!-- Taking the Cartesian product of two tables is done by appending each row from the first table to each row from the second.
First off, due to the structure of `Row`, adding a single column to a row requires pattern matching on its schema in order to determine whether the result will be a bare value or a tuple.
Because this is a common operation, factoring the pattern matching out into a helper is convenient: -->
取两个表的笛卡尔积是通过将第一个表的每一行附加到第二个表的每一行来完成的。
首先，由于 `Row` 的结构，将一列添加到行中需要对数据库模式进行模式匹配，以确定结果是一个裸值还是一个元组。
这是一个常见的操作，所以我们将模式匹配提取到一个辅助函数中方便复用：

```lean
{{#example_decl Examples/DependentTypes/DB.lean addVal}}
```
<!-- Appending two rows is recursive on the structure of both the first schema and the first row, because the structure of the row proceeds in lock-step with the structure of the schema.
When the first row is empty, appending returns the second row.
When the first row is a singleton, the value is added to the second row.
When the first row contains multiple columns, the first column's value is added to the result of recursion on the remainder of the row. -->
对两行进行附加需要同时对第一行和它的数据库模式进行递归，因为行的结构与模式的结构是绑定的。
当第一行为空时，返回第二行。
当第一行是一个单例时，将值添加到第二行。
当第一行包含多列时，将第一列的值添加到其余列和第二行附加的递归调用的结果上。


```lean
{{#example_decl Examples/DependentTypes/DB.lean RowAppend}}
```

<!-- `List.flatMap` applies a function that itself returns a list to every entry in an input list, returning the result of appending the resulting lists in order: -->
`List.flatMap` 接受两个一个函数实参和一个列表，函数对列表中的每一项均会返回一个列表，然后`List.flatMap`按将列表的列表含顺序依次附加：

```lean
{{#example_decl Examples/DependentTypes/DB.lean ListFlatMap}}
```
<!-- The type signature suggests that `List.flatMap` could be used to implement a `Monad List` instance.
Indeed, together with `pure x := [x]`, `List.flatMap` does implement a monad.
However, it's not a very useful `Monad` instance.
The `List` monad is basically a version of `Many` that explores _every_ possible path through the search space in advance, before users have the chance to request some number of values.
Because of this performance trap, it's usually not a good idea to define a `Monad` instance for `List`.
Here, however, the query language has no operator for restricting the number of results to be returned, so combining all possibilities is exactly what is desired: -->
类型签名表明 `List.flatMap` 可以用来实现 `Monad List` 实例。
实际上，与 `pure x := [x]` 一起，`List.flatMap` 确实实现了一个单子。
然而，这不是一个非常有用的 `Monad` 实例。
`List` 单子基本上是一个提前探索搜索空间中的 **每一条** 可能路径的 `Many` 单子，尽管用户可能只需要其中的某些值。
由于这种性能陷阱，通常不建议为 `List` 定义 `Monad` 实例。
然而查询语言没有限制返回的结果数量的运算符，因此返回所有的组合正是所需要的结果：

```lean
{{#example_decl Examples/DependentTypes/DB.lean TableCartProd}}
```

<!-- Just as with `List.product`, a loop with mutation in the identity monad can be used as an alternative implementation technique: -->
正如 `List.product` 一样，这个函数也可以通过在恒等单子下使用带变更（mutation）的循环实现：

```lean
{{#example_decl Examples/DependentTypes/DB.lean TableCartProdOther}}
```


<!-- ### Difference -->
### 差

<!-- Removing undesired rows from a table can be done using `List.filter`, which takes a list and a function that returns a `Bool`.
A new list is returned that contains only the entries for which the function returns `true`.
For instance, -->
从表中删除不需要的行可以使用 `List.filter` 完成，它接受一个列表和一个返回 `Bool` 的函数。
返回一个新列表，这个新列表仅包含旧列表中函数值为 `true` 的条目。
例如，

```lean
{{#example_in Examples/DependentTypes/DB.lean filterA}}
```
<!-- evaluates to -->
求值为

```lean
{{#example_out Examples/DependentTypes/DB.lean filterA}}
```
<!-- because `"Columbia"` and `"Sandy"` have lengths less than or equal to `8`.
Removing the entries of a table can be done using the helper `List.without`: -->
因为 `"Columbia"` 和 `"Sandy"` 的长度小于或等于 `8`。
可以使用辅助函数 `List.without` 删除表的条目：

```lean
{{#example_decl Examples/DependentTypes/DB.lean ListWithout}}
```
<!-- This will be used with the `BEq` instance for `Row` when interpreting queries. -->
这个将在执行查询时与 `Row` 的 `BEq` 实例一起使用。

<!-- ### Renaming Columns -->
### 重命名
<!-- Renaming a column in a row is done with a recursive function that traverses the row until the column in question is found, at which point the column with the new name gets the same value as the column with the old name: -->
在一行数据中重命名一个列需要使用一个递归函数遍历整行直到找到需要重命名的列，
然后将用一个新名字指向该列，而值仍然为这列原有的值：

```lean
{{#example_decl Examples/DependentTypes/DB.lean renameRow}}
```
<!-- While this function changes the _type_ of its argument, the actual return value contains precisely the same data as the original argument.
From a run-time perspective, `renameRow` is nothing but a slow identity function.
One difficulty in programming with indexed families is that when performance matters, this kind of operation can get in the way.
It takes a very careful, often brittle, design to eliminate these kinds of "re-indexing" functions. -->
这个函数改变了其实参的 **类型**，但实际返回的数据完全相同。
从运行时的角度看，`renameRow` 只是一个拖慢运行的恒等函数。
这暗示了使用索引族进行编程时的一个常见问题，当性能很重要时，这种操作可能会造成不必要的性能损失。
需要非常小心，但通常很脆弱的设计来消除这种 **重新索引** 函数。


<!-- ### Prefixing Column Names -->
### 添加前缀

<!-- Adding a prefix to column names is very similar to renaming a column.
Instead of proceeding to a desired column and then returning, `prefixRow` must process all columns: -->
添加前缀与重命名列非常相似。
然而`prefixRow` 必须处理所有列，而非找到一个特定的列然后直接返回：

```lean
{{#example_decl Examples/DependentTypes/DB.lean prefixRow}}
```
<!-- This can be used with `List.map` in order to add a prefix to all rows in a table.
Once again, this function only exists to change the type of a value. -->
这个可以与 `List.map` 一起使用，以便为表中的所有行添加前缀。
和重命名函数一样，这个函数只改变一个值的类型，但不改变值本身。

<!-- ### Putting the Pieces Together -->
### 将所有东西组合在一起

<!-- With all of these helpers defined, executing a query requires only a short recursive function: -->
定义了所有这些辅助函数后，执行查询只需要一个简短的递归函数：

```lean
{{#example_decl Examples/DependentTypes/DB.lean QueryExec}}
```
<!-- Some arguments to the constructors are not used during execution.
In particular, both the constructor `project` and the function `Row.project` take the smaller schema as explicit arguments, but the type of the _evidence_ that this schema is a subschema of the larger schema contains enough information for Lean to fill out the argument automatically.
Similarly, the fact that the two tables have disjoint column names that is required by the `product` constructor is not needed by `Table.cartesianProduct`.
Generally speaking, dependent types provide many opportunities to have Lean fill out arguments on behalf of the programmer. -->
构造子的一些实参在执行过程中没有被用到。
特别是，构造器 `project` 和函数 `Row.project` 都将较小的数据库模式作为显式参数，但表明这个数据库模式是较大数据库模式的子数据库模式的 **证据** 的类型包含足够的信息，以便 Lean 自动填充参数。
类似地，`product` 构造子要求两个表具有不同的列名，但 `Table.cartesianProduct` 不需要。
一般来说，依值类型编程中让 Lean 可以代替程序员自己填写很多实参。

<!-- Dot notation is used with the results of queries to call functions defined both in the `Table` and `List` namespaces, such `List.map`, `List.filter`, and `Table.cartesianProduct`.
This works because `Table` is defined using `abbrev`.
Just like type class search, dot notation can see through definitions created with `abbrev`.  -->
对查询的结果使用点符号（dot notation）以调用在 `Table` 和 `List` 命名空间中定义的函数，如 `List.map`、`List.filter` 和 `Table.cartesianProduct`。
因为 `Table` 是使用 `abbrev` 定义的，所以这样做是可行的。
就像类型类搜索一样，点符号可以看穿使用 `abbrev` 创建的定义。

<!-- The implementation of `select` is also quite concise.
After executing the query `q`, `List.filter` is used to remove the rows that do not satisfy the expression.
Filter expects a function from `Row s` to `Bool`, but `DBExpr.evaluate` has type `Row s → DBExpr s t → t.asType`.
Because the type of the `select` constructor requires that the expression have type `DBExpr s .bool`, `t.asType` is actually `Bool` in this context. -->
`select`的实现也非常简洁。
在执行查询 `q` 后，使用 `List.filter` 删除不满足表达式的行。
`filter` 需要一个从 `Row s` 到 `Bool` 的函数作为参数，但 `DBExpr.evaluate` 的类型是 `Row s → DBExpr s t → t.asType`。
但这并不会产生类型错误，因为 `select` 构造器的类型要求表达式的类型为 `DBExpr s .bool`，在这种情况下，`t.asType` 实际上就是 `Bool`。

<!-- A query that finds the heights of all mountain peaks with an elevation greater than 500 meters can be written: -->
一个找到所有海拔高于 500 米的山峰的高度的查询可以写成：

```leantac
{{#example_decl Examples/DependentTypes/DB.lean Query1}}
```

<!-- Executing it returns the expected list of integers: -->
执行它返回预期的整数列表：

```lean
{{#example_in Examples/DependentTypes/DB.lean Query1Exec}}
```
```output info
{{#example_out Examples/DependentTypes/DB.lean Query1Exec}}
```

<!-- To plan a sightseeing tour, it may be relevant to match all pairs mountains and waterfalls in the same location.
This can be done by taking the Cartesian product of both tables, selecting only the rows in which they are equal, and then projecting out the names: -->
为了规划一个观光旅行，可能需要同一位置的所有山和瀑布的有序对。
这可以通过取两个表的笛卡尔积，选择它们 `location` 相等的行，然后投影出山和瀑布的名称来完成：

```leantac
{{#example_decl Examples/DependentTypes/DB.lean Query2}}
```
<!-- Because the example data includes only waterfalls in the USA, executing the query returns pairs of mountains and waterfalls in the US: -->
因为示例数据只包括美国的瀑布，执行查询返回美国的山和瀑布有序对：

```lean
{{#example_in Examples/DependentTypes/DB.lean Query2Exec}}
```
```output info
{{#example_out Examples/DependentTypes/DB.lean Query2Exec}}
```

<!-- ### Errors You May Meet -->
### 可能遇到的错误

<!-- Many potential errors are ruled out by the definition of `Query`.
For instance, forgetting the added qualifier in `"mountain.location"` yields a compile-time error that highlights the column reference `c! "location"`: -->
很多潜在的错误都被 `Query` 的定义排除了。
例如，忘记在 `"mountain.location"` 中添加限定符会导致编译时错误，突出显示列引用 `c! "location"`：

```leantac
{{#example_in Examples/DependentTypes/DB.lean QueryOops1}}
```
<!-- This is excellent feedback!
On the other hand, the text of the error message is quite difficult to act on: -->
这是一个很棒的反馈！
但是，很难从这个错误信息知道下面应该做什么：
```output error
{{#example_out Examples/DependentTypes/DB.lean QueryOops1}}
```

<!-- Similarly, forgetting to add prefixes to the names of the two tables results in an error on `by simp`, which should provide evidence that the schemas are in fact disjoint; -->
类似地，忘记为两个表的名称添加前缀会导致 `by simp` 上的错误，它应该提供证据表明数据库模式实际上是不同的；

```leantac
{{#example_in Examples/DependentTypes/DB.lean QueryOops2}}
```
<!-- However, the error message is similarly unhelpful: -->
然而，错误信息同样没有帮助：
```output error
{{#example_out Examples/DependentTypes/DB.lean QueryOops2}}
```

<!-- Lean's macro system contains everything needed not only to provide a convenient syntax for queries, but also to arrange for the error messages to be helpful.
Unfortunately, it is beyond the scope of this book to provide a description of implementing languages with Lean macros.
An indexed family such as `Query` is probably best as the core of a typed database interaction library, rather than its user interface. -->
Lean 的宏系统不仅可以为查询提供方便的语法，还可以生成的错误信息变得有用。
不幸的是，本书的范围不包括如何使用 Lean 的宏实现语言。
像 `Query` 这样的索引族可能最适合作为一个有类型的数据库交互库的核心，直接暴露给用户的接口。

<!-- ## Exercises -->
## 练习

<!-- ### Dates -->
### 日期

<!-- Define a structure to represent dates. Add it to the `DBType` universe and update the rest of the code accordingly. Provide the extra `DBExpr` constructors that seem to be necessary. -->
定义一个用来表示日期的结构。将其添加到 `DBType` 宇宙中，并相应地更新其余代码。
定义必要的额外的 `DBExpr` 构造子。

<!-- ### Nullable Types -->
### 可空类型

<!-- Add support for nullable columns to the query language by representing database types with the following structure: -->
通过以下结构表示数据库类型，为查询语言添加对可空列的支持：

```lean
structure NDBType where
  underlying : DBType
  nullable : Bool

abbrev NDBType.asType (t : NDBType) : Type :=
  if t.nullable then
    Option t.underlying.asType
  else
    t.underlying.asType
```

<!-- Use this type in place of `DBType` in `Column` and `DBExpr`, and look up SQL's rules for `NULL` and comparison operators to determine the types of `DBExpr`'s constructors. -->
在 `Column` 和 `DBExpr` 中使用这种类型代替 `DBType`，并查找 SQL 的 `NULL` 和比较运算符的规则，以确定 `DBExpr` 构造函数的类型。

<!-- ### Experimenting with Tactics -->
### 尝试策术

<!-- What is the result of asking Lean to find values of the following types using `by repeat constructor`? Explain why each gives the result that it does. -->
在 Lean 中使用 `by repeat constructor` 观察 Lean 为以下类型找到了什么值，并解释每个结果。
 * `Nat`
 * `List Nat`
 * `Vect Nat 4`
 * `Row []`
 * `Row [⟨"price", .int⟩]`
 * `Row peak`
 * `HasCol [⟨"price", .int⟩, ⟨"price", .int⟩] "price" .int`
