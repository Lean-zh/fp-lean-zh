import VersoManual
import FPLeanZh.Examples

open Verso.Genre Manual
open Verso.Code.External

open FPLeanZh

set_option verso.exampleProject "../examples"
set_option verso.exampleModule "Examples.DependentTypes.DB"

#doc (Manual) "实际案例：类型化查询" =>
%%%
tag := "typed-queries"
file := "TypedQueries"
%%%
-- Worked Example: Typed Queries

-- Indexed families are very useful when building an API that is supposed to resemble some other language.
-- They can be used to write a library of HTML constructors that don't permit generating invalid HTML, to encode the specific rules of a configuration file format, or to model complicated business constraints.
-- This section describes an encoding of a subset of relational algebra in Lean using indexed families, as a simpler demonstration of techniques that can be used to build a more powerful database query language.

类型族在构建一个模仿其他语言的 API 时非常有用。
它们可以用来编写一个保证生成合法页面的 HTML 生成器，或者编码某种文件格式的配置，或是用来建模复杂的业务约束。
本节描述了如何在 Lean 中使用索引族对关系代数的一个子集进行编码，然而本节的展示的技术完全可以被用来构建一个更加强大的数据库查询语言。

-- This subset uses the type system to enforce requirements such as disjointness of field names, and it uses type-level computation to reflect the schema into the types of values that are returned from a query.
-- It is not a realistic system, however—databases are represented as linked lists of linked lists, the type system is much simpler than that of SQL, and the operators of relational algebra don't really match those of SQL.
-- However, it is large enough to demonstrate useful principles and techniques.

这个子集使用类型系统来保证某些要求，比如字段名称的不相交性，并使用类型上的计算将数据库模式（Schema）反映到从查询返回的值的类型中。
它并不是一个实际的数据库系统——数据库用链表的链表表示；类型系统比 SQL 的简单得多；关系代数的运算符与 SQL 的运算符并不完全匹配。
然而，它足够用来展示使用索引族的一些有用的原则和技术。

-- # A Universe of Data
# 一个数据的宇宙
%%%
tag := "typed-query-data-universe"
%%%

-- In this relational algebra, the base data that can be held in columns can have types {anchorName DBType}`Int`, {anchorName DBType}`String`, and {anchorName DBType}`Bool` and are described by the universe {anchorName DBType}`DBType`:

在这个关系代数中，保存在列中的基本数据的类型包括 {anchorName DBType}`Int`、{anchorName DBType}`String` 和 {anchorName DBType}`Bool`，并由宇宙 {anchorName DBType}`DBType` 描述：

```anchor DBType
inductive DBType where
  | int | string | bool

abbrev DBType.asType : DBType → Type
  | .int => Int
  | .string => String
  | .bool => Bool
```

-- Using {anchorName DBType}`DBType.asType` allows these codes to be used for types.
-- For example:

使用 {anchorName DBType}`DBType.asType` 将这些编码转化为类型。
例如：

```anchor mountHoodEval
#eval ("Mount Hood" : DBType.string.asType)
```
```anchorInfo mountHoodEval
"Mount Hood"
```

-- It is possible to compare the values described by any of the three database types for equality.
-- Explaining this to Lean, however, requires a bit of work.
-- Simply using {anchorName BEqDBType}`BEq` directly fails:

可以对三种类型的任何两个值都判断是否相等。
然而，向 Lean 解释这一点需要一些工作。
直接使用 {anchorName BEqDBType}`BEq` 会失败：

```anchor dbEqNoSplit
def DBType.beq (t : DBType) (x y : t.asType) : Bool :=
  x == y
```
```anchorError dbEqNoSplit
failed to synthesize
  BEq t.asType

Hint: Additional diagnostic information may be available using the `set_option diagnostics true` command.
```
-- Just as in the nested pairs universe, type class search doesn't automatically check each possibility for {anchorName dbEqNoSplit}`t`'s value
-- The solution is to use pattern matching to refine the types of {anchorTerm dbEq}`x` and {anchorName dbEq}`y`:

就像在嵌套对的宇宙中一样，类型类搜索不会自动检查 {anchorName dbEqNoSplit}`t` 的值的每种可能性。
解决方案是使用模式匹配来细化 {anchorTerm dbEq}`x` 和 {anchorName dbEq}`y` 的类型：

```anchor dbEq
def DBType.beq (t : DBType) (x y : t.asType) : Bool :=
  match t with
  | .int => x == y
  | .string => x == y
  | .bool => x == y
```
-- In this version of the function, {anchorName dbEq}`x` and {anchorName dbEq}`y` have types {anchorName DBType}`Int`, {anchorName DBType}`String`, and {anchorName DBType}`Bool` in the three respective cases, and these types all have {anchorName BEqDBType}`BEq` instances.
-- The definition of {anchorName dbEq}`DBType.beq` can be used to define a {anchorName BEqDBType}`BEq` instance for the types that are coded for by {anchorName DBType}`DBType`:

在这个版本的函数中，{anchorName dbEq}`x` 和 {anchorName dbEq}`y` 在三种情形下的类型分别为 {anchorName DBType}`Int`、{anchorName DBType}`String` 和 {anchorName DBType}`Bool`，这些类型都有 {anchorName BEqDBType}`BEq` 实例。
{anchorName dbEq}`DBType.beq` 的定义可以用来为 {anchorName DBType}`DBType` 编码的类型定义一个 {anchorName BEqDBType}`BEq` 实例：

```anchor BEqDBType
instance {t : DBType} : BEq t.asType where
  beq := t.beq
```
-- This is not the same as an instance for the codes:

这个实例与编码本身的实例不同：

```anchor BEqDBTypeCodes
instance : BEq DBType where
  beq
    | .int, .int => true
    | .string, .string => true
    | .bool, .bool => true
    | _, _ => false
```
-- The former instance allows comparison of values drawn from the types described by the codes, while the latter allows comparison of the codes themselves.

前一个实例允许比较编码描述的类型中的值，而后一个实例允许比较编码本身。

-- A {anchorName ReprAsType}`Repr` instance can be written using the same technique.
-- The method of the {anchorName ReprAsType}`Repr` class is called {anchorName ReprAsType}`reprPrec` because it is designed to take things like operator precedence into account when displaying values.
-- Refining the type through dependent pattern matching allows the {anchorName ReprAsType}`reprPrec` methods from the {anchorName ReprAsType}`Repr` instances for {anchorName DBType}`Int`, {anchorName DBType}`String`, and {anchorName DBType}`Bool` to be used:

一个 {anchorName ReprAsType}`Repr` 实例可以使用相同的技术编写。
{anchorName ReprAsType}`Repr` 类的方法被称为 {anchorName ReprAsType}`reprPrec`，因为它在显示值时考虑了操作符优先级等因素。
通过依值模式匹配细化类型，可以使用 {anchorName DBType}`Int`、{anchorName DBType}`String` 和 {anchorName DBType}`Bool` 的 {anchorName ReprAsType}`Repr` 实例的 {anchorName ReprAsType}`reprPrec` 方法：

```anchor ReprAsType
instance {t : DBType} : Repr t.asType where
  reprPrec :=
    match t with
    | .int => reprPrec
    | .string => reprPrec
    | .bool => reprPrec
```

-- # Schemas and Tables
# 数据库模式和表
%%%
tag := "schemas"
%%%

-- A schema describes the name and type of each column in a database:

一个数据库模式描述了数据库中每一列的名称和类型：

```anchor Schema
structure Column where
  name : String
  contains : DBType

abbrev Schema := List Column
```
-- In fact, a schema can be seen as a universe that describes rows in a table.
-- The empty schema describes the unit type, a schema with a single column describes that value on its own, and a schema with at least two columns is represented by a tuple:

事实上，数据库模式可以看作是描述表中行的宇宙。
空数据库模式描述了 Unit 类型，具有单个列的数据库模式描述了那个值本身，具有至少两个列的数据库模式可以有由元组表示：

```anchor Row
abbrev Row : Schema → Type
  | [] => Unit
  | [col] => col.contains.asType
  | col1 :: col2 :: cols => col1.contains.asType × Row (col2::cols)
```

-- As described in {ref "prod"}[the initial section on product types], Lean's product type and tuples are right-associative.
-- This means that nested pairs are equivalent to ordinary flat tuples.

正如在{ref "prod"}[积类型的起始节]中描述的那样，Lean 的积类型和元组是右结合的。
这意味着嵌套对等同于普通的展平元组。

-- A table is a list of rows that share a schema:

表是一个共享数据库模式的行的列表：

```anchor Table
abbrev Table (s : Schema) := List (Row s)
```
-- For example, a diary of visits to mountain peaks can be represented with the schema {anchorName peak}`peak`:

例如，可以用数据库模式 {anchorName peak}`peak` 表示对山峰的拜访日记：

```anchor peak
abbrev peak : Schema := [
  ⟨"name", .string⟩,
  ⟨"location", .string⟩,
  ⟨"elevation", .int⟩,
  ⟨"lastVisited", .int⟩
]
```
-- A selection of peaks visited by the author of this book appears as an ordinary list of tuples:

本书作者拜访过的部分山峰以元组的列表呈现：

```anchor mountainDiary
def mountainDiary : Table peak := [
  ("Mount Nebo",       "USA",     3637, 2013),
  ("Moscow Mountain",  "USA",     1519, 2015),
  ("Himmelbjerget",    "Denmark",  147, 2004),
  ("Mount St. Helens", "USA",     2549, 2010)
]
```
-- Another example consists of waterfalls and a diary of visits to them:

另一个例子包括瀑布和对它们的拜访日记：

```anchor waterfall
abbrev waterfall : Schema := [
  ⟨"name", .string⟩,
  ⟨"location", .string⟩,
  ⟨"lastVisited", .int⟩
]
```

```anchor waterfallDiary
def waterfallDiary : Table waterfall := [
  ("Multnomah Falls", "USA", 2018),
  ("Shoshone Falls",  "USA", 2014)
]
```

-- ## Recursion and Universes, Revisited
## 回顾递归和宇宙
%%%
tag := "recursion-universes-revisited"
%%%

-- The convenient structuring of rows as tuples comes at a cost: the fact that {anchorName Row}`Row` treats its two base cases separately means that functions that use {anchorName Row}`Row` in their types and are defined recursively over the codes (that, is the schema) need to make the same distinctions.
-- One example of a case where this matters is an equality check that uses recursion over the schema to define a function that checks rows for equality.
-- This example does not pass Lean's type checker:

将行结构化为元组的方便性是有代价的：{anchorName Row}`Row` 将其两个基情形的分开处理意味着在类型中使用 {anchorName Row}`Row` 和在编码（即数据库模式）上递归定义的函数需要做出相同的区分。
一个具体的例子是一个通过对数据库模式递归检查行是否相等的函数。
下面的实现无法通过 Lean 的类型检查：

```anchor RowBEqRecursion
def Row.bEq (r1 r2 : Row s) : Bool :=
  match s with
  | [] => true
  | col::cols =>
    match r1, r2 with
    | (v1, r1'), (v2, r2') =>
      v1 == v2 && bEq r1' r2'
```
```anchorError RowBEqRecursion
Type mismatch
  (v1, r1')
has type
  ?m.10 × ?m.11
but is expected to have type
  Row (col :: cols)
```
-- The problem is that the pattern {anchorTerm RowBEqRecursion}`col :: cols` does not sufficiently refine the type of the rows.
-- This is because Lean cannot yet tell whether the singleton pattern {anchorTerm Row}`[col]` or the {anchorTerm Row}`col1 :: col2 :: cols` pattern in the definition of {anchorName Row}`Row` was matched, so the call to {anchorName Row}`Row` does not compute down to a pair type.
-- The solution is to mirror the structure of {anchorName Row}`Row` in the definition of {anchorName RowBEq}`Row.bEq`:

问题在于模式 {anchorTerm RowBEqRecursion}`col :: cols` 并没有足够细化行的类型。
这是因为 Lean 无法确定到底是 {anchorName Row}`Row` 定义中的哪种模式被匹配上：单例模式 {anchorTerm Row}`[col]` 或是 {anchorTerm Row}`col1 :: col2 :: cols` 模式。因此对 {anchorName Row}`Row` 的调用不会计算到一个有序对类型。
解决方案是在 {anchorName RowBEq}`Row.bEq` 的定义中反映 {anchorName Row}`Row` 的结构：

```anchor RowBEq
def Row.bEq (r1 r2 : Row s) : Bool :=
  match s with
  | [] => true
  | [_] => r1 == r2
  | _::_::_ =>
    match r1, r2 with
    | (v1, r1'), (v2, r2') =>
      v1 == v2 && bEq r1' r2'

instance : BEq (Row s) where
  beq := Row.bEq
```

-- Unlike in other contexts, functions that occur in types cannot be considered only in terms of their input/output behavior.
-- Programs that use these types will find themselves forced to mirror the algorithm used in the type-level function so that their structure matches the pattern-matching and recursive behavior of the type.
-- A big part of the skill of programming with dependent types is the selection of appropriate type-level functions with the right computational behavior.

不同于其他上下文，出现在类型中的函数不能仅仅考虑其输入/输出行为。
使用这些类型的程序将发现自己被迫镜像那些类型中使用到的函数所使用的算法，以便它们的结构与类型的模式匹配和递归行为相匹配。
使用依赖类型编程的技巧的一个重要部分是在类型的计算中选择具有正确计算行为函数。

-- ## Column Pointers
## 列指针
%%%
tag := "column-pointers"
%%%

-- Some queries only make sense if a schema contains a particular column.
-- For example, a query that returns mountains with an elevation greater than 1000 meters only makes sense in the context of a schema with an {anchorTerm peak}`"elevation"` column that contains integers.
-- One way to indicate that a column is contained in a schema is to provide a pointer directly to it, and defining the pointer as an indexed family makes it possible to rule out invalid pointers.

如果数据库模式包含特定列，那么某些查询才有意义。
例如，一个返回海拔高于 1000 米的山的查询只在包含整数的 {anchorTerm peak}`"elevation"` 列的数据库模式中才有意义。
一种表示数据库模式包含某个列的方法是直接提供指向这个列的指针。将指针定义为一个索引族使得可以排除无效指针。

-- There are two ways that a column can be present in a schema: either it is at the beginning of the schema, or it is somewhere later in the schema.
-- Eventually, if a column is later in a schema, then it will be the beginning of some tail of the schema.

列可以出现在数据库模式的两个地方：要么在它的开头，要么在它的后面的某个地方。
如果列出现在模式的后面的某个地方，那么它也必然是某一个尾数据库模式的开头。

-- The indexed family {anchorName HasCol}`HasCol` is a translation of the specification into Lean code:

索引族 {anchorName HasCol}`HasCol` 将这种规范表达为 Lean 的代码：

```anchor HasCol
inductive HasCol : Schema → String → DBType → Type where
  | here : HasCol (⟨name, t⟩ :: _) name t
  | there : HasCol s name t → HasCol (_ :: s) name t
```
-- The family's three arguments are the schema, the column name, and its type.
-- All three are indices, but re-ordering the arguments to place the schema after the column name and type would allow the name and type to be parameters.
-- The constructor {anchorName HasCol}`here` can be used when the schema begins with the column {anchorTerm HasCol}`⟨name, t⟩`; it is thus a pointer to the first column in the schema that can only be used when the first column has the desired name and type.
-- The constructor {anchorName HasCol}`there` transforms a pointer into a smaller schema into a pointer into a schema with one more column on it.

这个族的三个参数是数据库模式、列名和它的类型。
所有三个参数都是索引，但重新排列参数，将数据库模式放在列名和类型之后，可以使列名和类型成为参量。
当数据库模式以列 {anchorTerm HasCol}`⟨name, t⟩` 开头时，可以使用构造子 {anchorName HasCol}`here`：它是一个指向当前数据库模式的第一列的指针，只有当第一列具有所需的名称和类型时才能使用。
构造子 {anchorName HasCol}`there` 将一个指向较小数据库模式的指针转换为一个指向在头部包含在一个额外列的数据库模式的指针。

-- Because {anchorTerm peak}`"elevation"` is the third column in {anchorName peak}`peak`, it can be found by looking past the first two columns with {anchorName HasCol}`there`, after which it is the first column.
-- In other words, to satisfy the type {anchorTerm peakElevationInt}`HasCol peak "elevation" .int`, use the expression {anchorTerm peakElevationInt}`.there (.there .here)`.
-- One way to think about {anchorName HasCol}`HasCol` is as a kind of decorated {anchorName Naturals}`Nat`—{anchorName Naturals}`zero` corresponds to {anchorName HasCol}`here`, and {anchorName Naturals}`succ` corresponds to {anchorName HasCol}`there`.
-- The extra type information makes it impossible to have off-by-one errors.

因为 {anchorTerm peak}`"elevation"` 是 {anchorName peak}`peak` 中的第三列，所以可以通过 {anchorName HasCol}`there` 跳过前两列然后使用 {anchorName HasCol}`here` 找到它。
换句话说，要满足类型 {anchorTerm peakElevationInt}`HasCol peak "elevation" .int`，使用表达式 {anchorTerm peakElevationInt}`.there (.there .here)`。
{anchorName HasCol}`HasCol` 也可以理解为是一种带有修饰的 {anchorName Naturals}`Nat`——{anchorName Naturals}`zero` 对应于 {anchorName HasCol}`here`，{anchorName Naturals}`succ` 对应于 {anchorName HasCol}`there`。
额外的类型信息使得不可能出现列序号偏差了一位之类的错误。

-- A pointer to a particular column in a schema can be used to extract that column's value from a row:

指向数据库模式中的列的指针可以用来从行中提取该列的值：

```anchor Rowget
def Row.get (row : Row s) (col : HasCol s n t) : t.asType :=
  match s, col, row with
  | [_], .here, v => v
  | _::_::_, .here, (v, _) => v
  | _::_::_, .there next, (_, r) => get r next
```
-- The first step is to pattern match on the schema, because this determines whether the row is a tuple or a single value.
-- No case is needed for the empty schema because there is a {anchorName HasCol}`HasCol` available, and both constructors of {anchorName HasCol}`HasCol` specify non-empty schemas.
-- If the schema has just a single column, then the pointer must point to it, so only the {anchorName HasCol}`here` constructor of {anchorName HasCol}`HasCol` need be matched.
-- If the schema has two or more columns, then there must be a case for {anchorName HasCol}`here`, in which case the value is the first one in the row, and one for {anchorName HasCol}`there`, in which case a recursive call is used.
-- Because the {anchorName HasCol}`HasCol` type guarantees that the column exists in the row, {anchorName Rowget}`Row.get` does not need to return an {anchorName nullable}`Option`.

第一步是对数据库模式进行模式匹配，因为这决定了行是元组还是单个值。
空模式的情形不需要考虑，因为 {anchorName HasCol}`HasCol` 的两个构造子都对应着非空的数据库模式。
如果数据库模式只有一个列，那么指针必须指向它，因此只需要匹配 {anchorName HasCol}`HasCol` 的 {anchorName HasCol}`here` 构造子。
如果数据库模式有两个或更多列，那么必须有一个 {anchorName HasCol}`here` 的情形，此时值是行中的第一个值，以及一个 {anchorName HasCol}`there` 的情形，此时需要进行递归调用。
因为 {anchorName HasCol}`HasCol` 类型保证了列存在于行中，所以 {anchorName Rowget}`Row.get` 不需要返回一个 {anchorName nullable}`Option`。

-- {anchorName HasCol}`HasCol` plays two roles:
--  1. It serves as _evidence_ that a column with a particular name and type exists in a schema.

--  2. It serves as _data_ that can be used to find the value associated with the column in a row.

{anchorName HasCol}`HasCol` 扮演了两个角色：
 1. 它作为_证据_，证明模式中存在具有特定名称和类型的列。

 2. 它作为_数据_，可以用来在行中找到与列关联的值。

-- The first role, that of evidence, is similar to way that propositions are used.
-- The definition of the indexed family {anchorName HasCol}`HasCol` can be read as a specification of what counts as evidence that a given column exists.
-- Unlike propositions, however, it matters which constructor of {anchorName HasCol}`HasCol` was used.
-- In the second role, the constructors are used like {anchorName Naturals}`Nat`s to find data in a collection.
-- Programming with indexed families often requires the ability to switch fluently between both perspectives.

第一个角色，即证据的角色，类似于命题的使用方式。
索引族 {anchorName HasCol}`HasCol` 的定义可以被视为一个规范，说明什么样的证据可以证明给定的列存在。
然而，与命题不同，使用 {anchorName HasCol}`HasCol` 的哪个构造子很重要。
在第二个角色中，构造子起到类似 {anchorName Naturals}`Nat` 的作用，用于在集合中查找数据。
使用索引族编程通常需要能够流畅地使用它的这两个角色。

-- ## Subschemas
## 子数据库模式
%%%
tag := "subschemas"
%%%

-- One important operation in relational algebra is to _project_ a table or row into a smaller schema.
-- Every column not present in the smaller schema is forgotten.
-- In order for projection to make sense, the smaller schema must be a subschema of the larger schema, which means that every column in the smaller schema must be present in the larger schema.
-- Just as {anchorName HasCol}`HasCol` makes it possible to write a single-column lookup in a row that cannot fail, a representation of the subschema relationship as an indexed family makes it possible to write a projection function that cannot fail.

关系代数中的一个重要操作是将表或行_投影_到一个较小的数据库模式中。
不在这一数据库模式中的每一列都会被舍弃。
为了使投影有意义，小数据库模式必须是大数据库模式的子数据库模式：小数据库模式中的每一列都必须存在于大数据库模式中。
正如 {anchorName HasCol}`HasCol` 允许我们编写一个从行中提取某个列函数且这个函数一定不会失败一样，
将子模式关系表示为索引族允许我们编写一个不会失败的投影函数。

-- The ways in which one schema can be a subschema of another can be defined as an indexed family.
-- The basic idea is that a smaller schema is a subschema of a bigger schema if every column in the smaller schema occurs in the bigger schema.
-- If the smaller schema is empty, then it's certainly a subschema of the bigger schema, represented by the constructor {anchorName Subschema}`nil`.
-- If the smaller schema has a column, then that column must be in the bigger schema, and all the rest of the columns in the subschema must also be a subschema of the bigger schema.
-- This is represented by the constructor {anchorName Subschema}`cons`.

可以将“一个数据库模式是另一个数据库模式的子数据库模式”定义为一个索引族。
基本思想是，如果小数据库模式中的每一列都出现在大数据库模式中，那么小数据库模式就是大数据库模式的子数据库模式。
如果小数据库模式为空，则它肯定是大数据库模式的子数据库模式，由构造子 {anchorName Subschema}`nil` 表示。
如果小数据库模式有一列，那么该列必须在大数据库模式中且子数据库模式中的其余列也必须是大数据库模式的子数据库模式。
这由子 {anchorName Subschema}`cons` 表示。

```anchor Subschema
inductive Subschema : Schema → Schema → Type where
  | nil : Subschema [] bigger
  | cons :
      HasCol bigger n t →
      Subschema smaller bigger →
      Subschema (⟨n, t⟩ :: smaller) bigger
```
-- In other words, {anchorName Subschema}`Subschema` assigns each column of the smaller schema a {anchorName HasCol}`HasCol` that points to its location in the larger schema.

换句话说，{anchorName Subschema}`Subschema` 为小数据库模式的每一列分配一个 {anchorName HasCol}`HasCol`，该 {anchorName HasCol}`HasCol` 指向大数据库模式中的位置。

-- The schema {anchorName travelDiary}`travelDiary` represents the fields that are common to both {anchorName peak}`peak` and {anchorName waterfall}`waterfall`:

模式 {anchorName travelDiary}`travelDiary` 表示 {anchorName peak}`peak` 和 {anchorName waterfall}`waterfall` 共有的字段：

```anchor travelDiary
abbrev travelDiary : Schema :=
  [⟨"name", .string⟩, ⟨"location", .string⟩, ⟨"lastVisited", .int⟩]
```
-- It is certainly a subschema of {anchorName peak}`peak`, as shown by this example:

正如这个例子所示，它肯定是 {anchorName peak}`peak` 的子数据库模式：

```anchor peakDiarySub
example : Subschema travelDiary peak :=
  .cons .here
    (.cons (.there .here)
      (.cons (.there (.there (.there .here))) .nil))
```
-- However, code like this is difficult to read and difficult to maintain.
-- One way to improve it is to instruct Lean to write the {anchorName Subschema}`Subschema` and {anchorName HasCol}`HasCol` constructors automatically.
-- This can be done using the tactic feature that was introduced in {ref "props-proofs-indexing"}[the Interlude on propositions and proofs].
-- That interlude uses {kw}`by decide` and {kw}`by simp` to provide evidence of various propositions.

然而，这样的代码很难阅读和维护。
改进的一种方法是指导 Lean 自动编写 {anchorName Subschema}`Subschema` 和 {anchorName HasCol}`HasCol` 构造子。
这可以通过使用{ref "props-proofs-indexing"}[关于命题和证明的插曲]中介绍的策略特性来完成。
该插曲使用 {kw}`by decide` 和 {kw}`by simp` 提供了各种命题的证据。

-- In this context, two tactics are useful:
--  * The {kw}`constructor` tactic instructs Lean to solve the problem using the constructor of a datatype.
--  * The {kw}`repeat` tactic instructs Lean to repeat a tactic over and over until it either fails or the proof is finished.

此时，两种策略是有用的：
 * {kw}`constructor` 策略指示 Lean 使用数据类型的构造子解决问题。
 * {kw}`repeat` 策略指示 Lean 重复一个策略，直到它失败或证明完成。

-- In the next example, {kw}`by constructor` has the same effect as just writing {anchorName peakDiarySub}`.nil` would have:

下一个例子中，{kw}`by constructor` 的效果与直接写 {anchorName peakDiarySub}`.nil` 是一样的：

```anchor emptySub
example : Subschema [] peak := by constructor
```
-- However, attempting that same tactic with a slightly more complicated type fails:

然而，在一个稍微复杂的类型下尝试相同的策略会失败：

```anchor notDone
example : Subschema [⟨"location", .string⟩] peak := by constructor
```
```anchorError notDone
unsolved goals
case a
⊢ HasCol peak "location" DBType.string

case a
⊢ Subschema [] peak
```
-- Errors that begin with {lit}`unsolved goals` describe tactics that failed to completely build the expressions that they were supposed to.
-- In Lean's tactic language, a _goal_ is a type that a tactic is to fulfill by constructing an appropriate expression behind the scenes.
-- In this case, {kw}`constructor` caused {anchorName SubschemaNames}`Subschema.cons` to be applied, and the two goals represent the two arguments expected by {anchorName Subschema}`cons`.
-- Adding another instance of {kw}`constructor` causes the first goal ({anchorTerm SubschemaNames}`HasCol peak "location" DBType.string`) to be addressed with {anchorName SubschemaNames}`HasCol.there`, because {anchorName peak}`peak`'s first column is not {anchorTerm SubschemaNames}`"location"`:

以 {lit}`unsolved goals` 开头的错误描述了策略未能完全构建它们应该构建的表达式。
在 Lean 的策略语言中，_证明目标（goal）_ 是策略需要通过构造适当的表达式来实现的类型。
在这种情形下，{kw}`constructor` 导致应用 {anchorName SubschemaNames}`Subschema.cons`，两个目标表示 {anchorName Subschema}`cons` 期望的两个参数。
添加另一个 {kw}`constructor` 实例导致第一个目标（{anchorTerm SubschemaNames}`HasCol peak "location" DBType.string`）被 {anchorName SubschemaNames}`HasCol.there` 处理，因为 {anchorName peak}`peak` 的第一列不是 {anchorTerm SubschemaNames}`"location"`：

```anchor notDone2
example : Subschema [⟨"location", .string⟩] peak := by
  constructor
  constructor
```
```anchorError notDone2
unsolved goals
case a.a
⊢ HasCol
  [{ name := "location", contains := DBType.string }, { name := "elevation", contains := DBType.int },
    { name := "lastVisited", contains := DBType.int }]
  "location" DBType.string

case a
⊢ Subschema [] peak
```
-- However, adding a third {kw}`constructor` results in the first goal being solved, because {anchorName SubschemaNames}`HasCol.here` is applicable:

然而，添加第三个 {kw}`constructor` 解决了第一个证明目标，因为 {anchorName SubschemaNames}`HasCol.here` 是适用的：

```anchor notDone3
example : Subschema [⟨"location", .string⟩] peak := by
  constructor
  constructor
  constructor
```
```anchorError notDone3
unsolved goals
case a
⊢ Subschema [] peak
```
-- A fourth instance of {kw}`constructor` solves the {anchorTerm SubschemaNames}`Subschema peak []` goal:

第四个 {kw}`constructor` 实例解决了 {anchorTerm SubschemaNames}`Subschema peak []` 目标：

```anchor notDone4
example : Subschema [⟨"location", .string⟩] peak := by
  constructor
  constructor
  constructor
  constructor
```
-- Indeed, a version written without the use of tactics has four constructors:

事实上，一个没有使用策略的版本有四个构造子：

```anchor notDone5
example : Subschema [⟨"location", .string⟩] peak :=
  .cons (.there .here) .nil
```

-- Instead of experimenting to find the right number of times to write {kw}`constructor`, the {kw}`repeat` tactic can be used to ask Lean to just keep trying {kw}`constructor` as long as it keeps making progress:

不要尝试找到写 {kw}`constructor` 的正确次数，可以使用 {kw}`repeat` 策略要求 Lean 只要取得进展就继续尝试 {kw}`constructor`：

```anchor notDone6
example : Subschema [⟨"location", .string⟩] peak := by repeat constructor
```
-- This more flexible version also works for more interesting {anchorName Subschema}`Subschema` problems:

这个更灵活的版本也适用于更有趣的 {anchorName Subschema}`Subschema` 问题：

```anchor subschemata
example : Subschema travelDiary peak := by repeat constructor

example : Subschema travelDiary waterfall := by repeat constructor
```

-- The approach of blindly trying constructors until something works is not very useful for types like {anchorName Naturals}`Nat` or {anchorTerm misc}`List Bool`.
-- Just because an expression has type {anchorName Naturals}`Nat` doesn't mean that it's the _correct_ {anchorName Naturals}`Nat`, after all.
-- But types like {anchorName HasCol}`HasCol` and {anchorName Subschema}`Subschema` are sufficiently constrained by their indices that only one constructor will ever be applicable, which means that the contents of the program itself are less interesting, and a computer can pick the correct one.

盲目尝试构造子直到某个符合预期类型的值被构造出来的方法对于 {anchorName Naturals}`Nat` 或 {anchorTerm misc}`List Bool` 这样的类型并不是很有用。
毕竟，一个表达式的类型是 {anchorName Naturals}`Nat` 并不意味着它是_正确的_ {anchorName Naturals}`Nat`。
但 {anchorName HasCol}`HasCol` 和 {anchorName Subschema}`Subschema` 这样的类型受到索引的约束，
只有一个构造子适用。
这意味着程序本身是平凡的，计算机可以选择正确的构造子。

-- If one schema is a subschema of another, then it is also a subschema of the larger schema extended with an additional column.
-- This fact can be captured as a function definition.
-- {anchorName SubschemaAdd}`Subschema.addColumn` takes evidence that {anchorName SubschemaAdd}`smaller` is a subschema of {anchorName SubschemaAdd}`bigger`, and then returns evidence that {anchorName SubschemaAdd}`smaller` is a subschema of {anchorTerm SubschemaAdd}`c :: bigger`, that is, {anchorName SubschemaAdd}`bigger` with one additional column:

如果一个数据库模式是另一个数据库模式的子数据库模式，那么它也是扩展了一个额外列的更大数据库模式的子数据库模式。
这个事实被下列函数定义表示出来。
{anchorName SubschemaAdd}`Subschema.addColumn` 接受 {anchorName SubschemaAdd}`smaller` 是 {anchorName SubschemaAdd}`bigger` 的子数据库模式的证据，然后返回 {anchorName SubschemaAdd}`smaller` 是 {anchorTerm SubschemaAdd}`c :: bigger` 的子数据库模式的证据，即，{anchorName SubschemaAdd}`bigger` 增加了一个额外列：

```anchor SubschemaAdd
def Subschema.addColumn :
    Subschema smaller bigger →
    Subschema smaller (c :: bigger)
  | .nil  => .nil
  | .cons col sub' => .cons (.there col) sub'.addColumn
```
-- A subschema describes where to find each column from the smaller schema in the larger schema.
-- {anchorName SubschemaAdd}`Subschema.addColumn` must translate these descriptions from the original larger schema into the extended larger schema.
-- In the {anchorName Subschema}`nil` case, the smaller schema is {lit}`[]`, and {anchorName Subschema}`nil` is also evidence that {lit}`[]` is a subschema of {anchorTerm SubschemaAdd}`c :: bigger`.
-- In the {anchorName Subschema}`cons` case, which describes how to place one column from {anchorName SubschemaAdd}`smaller` into {anchorName SubschemaAdd}`bigger`, the placement of the column needs to be adjusted with {anchorName HasCol}`there` to account for the new column {anchorName SubschemaAdd}`c`, and a recursive call adjusts the rest of the columns.

子数据库模式描述了在大数据库模式中找到小数据库模式的每一列的位置。
{anchorName SubschemaAdd}`Subschema.addColumn` 必须将这些描述从指向原始的大数据库模式转换为指向扩展后的更大数据库模式。
在 {anchorName Subschema}`nil` 的情形下，小数据库模式是 {lit}`[]`，{anchorName Subschema}`nil` 也是 {lit}`[]` 是 {anchorTerm SubschemaAdd}`c :: bigger` 的子数据库模式的证据。
在 {anchorName Subschema}`cons` 的情形下，它描述了如何将 {anchorName SubschemaAdd}`smaller` 中的一列放入 {anchorName SubschemaAdd}`bigger`，需要使用 {anchorName HasCol}`there` 调整列的放置位置以考虑新列 {anchorName SubschemaAdd}`c`，递归调用调整其余列。

-- Another way to think about {anchorName Subschema}`Subschema` is that it defines a _relation_ between two schemas—the existence of an expression  with type {anchorTerm misc}`Subschema smaller bigger` means that {anchorTerm misc}`(smaller, bigger)` is in the relation.
-- This relation is reflexive, meaning that every schema is a subschema of itself:

另一个思考 {anchorName Subschema}`Subschema` 的方式是它定义了两个数据库模式之间的_关系_——存在一个类型为 {anchorTerm misc}`Subschema smaller bigger` 的表达式意味着 {anchorTerm misc}`(smaller, bigger)` 在这个关系中。
这个关系是自反的，意味着每个数据库模式都是自己的子数据库模式：

```anchor SubschemaSame
def Subschema.reflexive : (s : Schema) → Subschema s s
  | [] => .nil
  | _ :: cs => .cons .here (reflexive cs).addColumn
```


-- ## Projecting Rows
## 投影行
%%%
tag := "projecting-rows"
%%%

-- Given evidence that {anchorName RowProj}`s'` is a subschema of {anchorName RowProj}`s`, a row in {anchorName RowProj}`s` can be projected into a row in {anchorName RowProj}`s'`.
-- This is done using the evidence that {anchorName RowProj}`s'` is a subschema of {anchorName RowProj}`s`, which explains where each column of {anchorName RowProj}`s'` is found in {anchorName RowProj}`s`.
-- The new row in {anchorName RowProj}`s'` is built up one column at a time by retrieving the value from the appropriate place in the old row.

给定 {anchorName RowProj}`s'` 是 {anchorName RowProj}`s` 的子数据库模式的证据，可以将 {anchorName RowProj}`s` 中的行投影到 {anchorName RowProj}`s'` 中的行。
这是通过分析 {anchorName RowProj}`s'` 是 {anchorName RowProj}`s` 的子数据库模式的证据完成的：它解释了 {anchorName RowProj}`s'` 的每一列在 {anchorName RowProj}`s` 中的位置。
在 {anchorName RowProj}`s'` 中的新行是通过从旧行的适当位置检索值逐列构建的。

-- The function that performs this projection, {anchorName RowProj}`Row.project`, has three cases, one for each case of {anchorName RowProj}`Row` itself.
-- It uses {anchorName Rowget}`Row.get` together with each {anchorName HasCol}`HasCol` in the {anchorName RowProj}`Subschema` argument to construct the projected row:

执行这种投影的函数 {anchorName RowProj}`Row.project` 有三种情形，分别对应于 {anchorName RowProj}`Row` 本身的三种情形。
它使用 {anchorName Rowget}`Row.get` 与 {anchorName RowProj}`Subschema` 参数中的每个 {anchorName HasCol}`HasCol` 一起构造投影行：

```anchor RowProj
def Row.project (row : Row s) : (s' : Schema) → Subschema s' s → Row s'
  | [], .nil => ()
  | [_], .cons c .nil => row.get c
  | _::_::_, .cons c cs => (row.get c, row.project _ cs)
```


-- # Conditions and Selection
# 条件和选取
%%%
tag := "conditions-and-selection"
%%%

-- Projection removes unwanted columns from a table, but queries must also be able to remove unwanted rows.
-- This operation is called _selection_.
-- Selection relies on having a means of expressing which rows are desired.

投影从表中删除不需要的列，但查询也必须能够删除不需要的行。
这个操作称为_选择（selection）_。
选择的前提是有一种表达“哪些行是需要的”的方式。

-- The example query language contains expressions, which are analogous to what can be written in a {lit}`WHERE` clause in SQL.
-- Expressions are represented by the indexed family {anchorName DBExpr}`DBExpr`.
-- Because expressions can refer to columns from the database, but different sub-expressions all have the same schema, {anchorName DBExpr}`DBExpr` takes the database schema as a parameter.
-- Additionally, each expression has a type, and these vary, making it an index:

示例查询语言包含表达式，类似于 SQL 中可以写在 {lit}`WHERE` 子句中的内容。
表达式由索引族 {anchorName DBExpr}`DBExpr` 表示。
表达式可以引用数据库中的列，但不同的子表达式都有相同的数据库模式。{anchorName DBExpr}`DBExpr` 以数据库模式作为参量。
此外，每个表达式都有一个类型，这些类型不同，所以这是一个索引：

```anchor DBExpr
inductive DBExpr (s : Schema) : DBType → Type where
  | col (n : String) (loc : HasCol s n t) : DBExpr s t
  | eq (e1 e2 : DBExpr s t) : DBExpr s .bool
  | lt (e1 e2 : DBExpr s .int) : DBExpr s .bool
  | and (e1 e2 : DBExpr s .bool) : DBExpr s .bool
  | const : t.asType → DBExpr s t
```
-- The {anchorName DBExpr}`col` constructor represents a reference to a column in the database.
-- The {anchorName DBExpr}`eq` constructor compares two expressions for equality, {anchorName DBExpr}`lt` checks whether one is less than the other, {anchorName DBExpr}`and` is Boolean conjunction, and {anchorName DBExpr}`const` is a constant value of some type.

{anchorName DBExpr}`col` 构造子表示对数据库中的列的引用。
{anchorName DBExpr}`eq` 构造子比较两个表达式是否相等，{anchorName DBExpr}`lt` 检查一个是否小于另一个，{anchorName DBExpr}`and` 是布尔合取，{anchorName DBExpr}`const` 是某种类型的常量值。

-- For example, an expression in {anchorName peak}`peak` that checks whether the {lit}`elevation` column is greater than 1000 and the location is {anchorTerm mountainDiary}`"Denmark"` can be written:

例如，在 {anchorName peak}`peak` 中检查 {lit}`elevation` 列的值大于 1000 并且位置等于 {anchorTerm mountainDiary}`"Denmark"` 的表达式可以写为：

```anchor tallDk
def tallInDenmark : DBExpr peak .bool :=
  .and (.lt (.const 1000) (.col "elevation" (by repeat constructor)))
       (.eq (.col "location" (by repeat constructor)) (.const "Denmark"))
```
-- This is somewhat noisy.
-- In particular, references to columns contain boilerplate calls to {anchorTerm tallDk}`by repeat constructor`.
-- A Lean feature called _macros_ can help make expressions easier to read by eliminating this boilerplate:

这有点复杂。
特别是，对列的引用包含了重复的对 {anchorTerm tallDk}`by repeat constructor` 的调用。
Lean 的一个特性叫做_宏（macro）_，可以消除这些重复代码，使表达式更易于阅读：

```anchor cBang
macro "c!" n:term : term => `(DBExpr.col $n (by repeat constructor))
```
-- This declaration adds the {kw}`c!` keyword to Lean, and instructs Lean to replace any instance of {kw}`c!` followed by an expression with the corresponding {anchorTerm cBang}`DBExpr.col` construction.
-- Here, {anchorName cBang}`term` stands for Lean expressions, rather than commands, tactics, or some other part of the language.
-- Lean macros are a bit like C preprocessor macros, except they are better integrated into the language and they automatically avoid some of the pitfalls of CPP.
-- In fact, they are very closely related to macros in Scheme and Racket.

这个声明为 Lean 添加了 {kw}`c!` 关键字，并指示 Lean 用相应的 {anchorTerm cBang}`DBExpr.col` 构造替换后面跟着的任何 {kw}`c!` 实例。
这里，{anchorName cBang}`term` 代表 Lean 表达式，而不是命令、策略或语言的其他部分。
Lean 宏有点像 C 预处理器宏，只是它们更好地集成到语言中，并且它们自动避免了 CPP 的一些陷阱。
事实上，它们与 Scheme 和 Racket 中的宏非常密切相关。

-- With this macro, the expression can be much easier to read:

有了这个宏，表达式就容易阅读得多：

```anchor tallDkBetter
def tallInDenmark : DBExpr peak .bool :=
  .and (.lt (.const 1000) (c! "elevation"))
       (.eq (c! "location") (.const "Denmark"))
```

Finding the value of an expression with respect to a given row uses {anchorName Rowget}`Row.get` to extract column references, and it delegates to Lean's operations on values for every other expression:

```anchor DBExprEval
def DBExpr.evaluate (row : Row s) : DBExpr s t → t.asType
  | .col _ loc => row.get loc
  | .eq e1 e2  => evaluate row e1 == evaluate row e2
  | .lt e1 e2  => evaluate row e1 < evaluate row e2
  | .and e1 e2 => evaluate row e1 && evaluate row e2
  | .const v => v
```

-- Evaluating the expression for Valby Bakke, the tallest hill in the Copenhagen area, yields {anchorName misc}`false` because Valby Bakke is much less than 1 km over sea level:

对 Valby Bakke（哥本哈根地区最高的山）求值得到 {anchorName misc}`false`，因为 Valby Bakke 的海拔远低于 1 km：

```anchor valbybakke
#eval tallInDenmark.evaluate ("Valby Bakke", "Denmark", 31, 2023)
```
```anchorInfo valbybakke
false
```
-- Evaluating it for a fictional mountain of 1230m elevation yields {anchorName misc}`true`:

对一个海拔 1230 米的虚构的山求值得到 {anchorName misc}`true`：

```anchor fakeDkBjerg
#eval tallInDenmark.evaluate ("Fictional mountain", "Denmark", 1230, 2023)
```
```anchorInfo fakeDkBjerg
true
```
-- Evaluating it for the highest peak in the US state of Idaho yields {anchorName misc}`false`, as Idaho is not part of Denmark:

为美国爱达荷州最高峰求值得到 {anchorName misc}`false`，因为爱达荷州不是丹麦的一部分：

```anchor borah
#eval tallInDenmark.evaluate ("Mount Borah", "USA", 3859, 1996)
```
```anchorInfo borah
false
```

-- # Queries
# 查询
%%%
tag := "typed-query-language"
%%%

-- The query language is based on relational algebra.
-- In addition to tables, it includes the following operators:
--  1. The union of two expressions that have the same schema combines the rows that result from two queries
--  2. The difference of two expressions that have the same schema removes rows found in the second result from the rows in the first result
--  3. Selection by some criterion filters the result of a query according to an expression
--  4. Projection into a subschema, removing columns from the result of a query
--  5. Cartesian product, combining every row from one query with every row from another
--  6. Renaming a column in the result of a query, which modifies its schema
--  7. Prefixing all columns in a query with a name

查询语言基于关系代数。
除了表之外，它还包括以下运算符：
 1. 并（Union），将两个具有相同数据库模式的表达式的查询的结果行合并
 2. 差（Difference），定义在两个具有相同数据库模式的表达式，从第一个表达式的查询结果中删除同时存在于第二个表达式的查询结果的行
 3. 选择（Selection），按照某些标准，根据表达式过滤查询的结果
 4. 投影（Projection），从查询结果中删除列
 5. 笛卡尔积（Cartesian product），将一个查询的每一行与另一个查询的每一行组合
 6. 重命名（Renaming），修改查询结果中某一个列的名字
 7. 添加前缀（Prefixing），为查询中的所有列名添加一个前缀

-- The last operator is not strictly necessary, but it makes the language more convenient to use.

最后一个运算符不是严格必要的，但它使语言更方便使用。

-- Once again, queries are represented by an indexed family:

查询同样由一个索引族表示：

```anchor Query
inductive Query : Schema → Type where
  | table : Table s → Query s
  | union : Query s → Query s → Query s
  | diff : Query s → Query s → Query s
  | select : Query s → DBExpr s .bool → Query s
  | project :
    Query s → (s' : Schema) →
    Subschema s' s →
    Query s'
  | product :
    Query s1 → Query s2 →
    disjoint (s1.map Column.name) (s2.map Column.name) →
    Query (s1 ++ s2)
  | renameColumn :
    Query s → (c : HasCol s n t) → (n' : String) →
    !((s.map Column.name).contains n') →
    Query (s.renameColumn c n')
  | prefixWith :
    (n : String) → Query s →
    Query (s.map fun c => {c with name := n ++ "." ++ c.name})
```
-- The {anchorName Query}`select` constructor requires that the expression used for selection return a Boolean.
-- The {anchorName Query}`product` constructor's type contains a call to {anchorName Query}`disjoint`, which ensures that the two schemas don't share any names:

{anchorName Query}`select` 构造子要求用于选择的表达式返回一个布尔值。
{anchorName Query}`product` 构造子的类型包含对 {anchorName Query}`disjoint` 的调用，它确保两个数据库模式没有相同的列名：

```anchor disjoint
def disjoint [BEq α] (xs ys : List α) : Bool :=
  not (xs.any ys.contains || ys.any xs.contains)
```
-- The use of an expression of type {anchorName misc}`Bool` where a type is expected triggers a coercion from {anchorName misc}`Bool` to {anchorTerm misc}`Prop`.
-- Just as decidable propositions can be considered to be Booleans, where evidence for the proposition is coerced to {anchorName misc}`true` and refutations of the proposition are coerced to {anchorName misc}`false`, Booleans are coerced into the proposition that states that the expression is equal to {anchorName misc}`true`.
-- Because all uses of the library are expected to occur in contexts where the schemas are known ahead of time, this proposition can be proved with {kw}`by simp`.
-- Similarly, the {anchorName renameColumn}`renameColumn` constructor checks that the new name does not already exist in the schema.
-- It uses the helper {anchorName renameColumn}`Schema.renameColumn` to change the name of the column pointed to by {anchorName HasCol}`HasCol`:

将 {anchorName misc}`Bool` 类型的表达式用在期望一个类型的位置会触发从 {anchorName misc}`Bool` 到 {anchorTerm misc}`Prop` 的强制转换。
正如可判定命题被视为一个布尔值：命题的证据被强制转换为 {anchorName misc}`true`，命题的反驳被强制转换为 {anchorName misc}`false`，布尔值也可以反过来被强制转换为表达式等于 {anchorName misc}`true` 的命题。
因为预期所有库的使用将发生在数据库模式已经给定的场景下，所以这个命题可以用 {kw}`by simp` 证明。
类似地，{anchorName renameColumn}`renameColumn` 构造子检查新名称是否已经存在于数据库模式中。
它使用辅助函数 {anchorName renameColumn}`Schema.renameColumn` 来更改 {anchorName HasCol}`HasCol` 指向的列的名称：

```anchor renameColumn
def Schema.renameColumn : (s : Schema) → HasCol s n t → String → Schema
  | c :: cs, .here, n' => {c with name := n'} :: cs
  | c :: cs, .there next, n' => c :: renameColumn cs next n'
```

-- # Executing Queries
# 执行查询
%%%
tag := "executing-queries"
%%%

-- Executing queries requires a number of helper functions.
-- The result of a query is a table; this means that each operation in the query language requires a corresponding implementation that works with tables.

执行查询需要一些辅助函数。
查询的结果是一个表。
这意味着查询语言中的每个操作都需要一个可以与表一起工作的实现。

-- ## Cartesian Product
## 笛卡尔积
%%%
tag := "executing-cartesian-product"
%%%

-- Taking the Cartesian product of two tables is done by appending each row from the first table to each row from the second.
-- First off, due to the structure of {anchorName Row}`Row`, adding a single column to a row requires pattern matching on its schema in order to determine whether the result will be a bare value or a tuple.
-- Because this is a common operation, factoring the pattern matching out into a helper is convenient:

计算两个表的笛卡尔积是通过将第一个表中的每一行追加到第二个表中的每一行来完成的。
首先，由于 {anchorName Row}`Row` 的结构，向行添加单个列需要对其模式进行模式匹配，以确定结果是裸值还是元组。
因为这是一个常见的操作，将模式匹配提取到辅助函数中很方便：

```anchor addVal
def addVal (v : c.contains.asType) (row : Row s) : Row (c :: s) :=
  match s, row with
  | [], () => v
  | c' :: cs, v' => (v, v')
```
-- Appending two rows is recursive on the structure of both the first schema and the first row, because the structure of the row proceeds in lock-step with the structure of the schema.
-- When the first row is empty, appending returns the second row.
-- When the first row is a singleton, the value is added to the second row.
-- When the first row contains multiple columns, the first column's value is added to the result of recursion on the remainder of the row.

追加两行是关于第一个模式和第一行的结构的递归，因为行的结构与模式的结构是同步进行的。
当第一行为空时，追加返回第二行。
当第一行是单元素时，该值被添加到第二行。
当第一行包含多列时，第一列的值被添加到对行剩余部分递归的结果中。

```anchor RowAppend
def Row.append (r1 : Row s1) (r2 : Row s2) : Row (s1 ++ s2) :=
  match s1, r1 with
  | [], () => r2
  | [_], v => addVal v r2
  | _::_::_, (v, r') => (v, r'.append r2)
```

-- {anchorName ListFlatMap}`List.flatMap`, found in the standard library, applies a function that itself returns a list to every entry in an input list, returning the result of appending the resulting lists in order:

标准库中的 {anchorName ListFlatMap}`List.flatMap` 将一个本身返回列表的函数应用于输入列表中的每个条目，并按顺序返回追加结果列表的结果：

```anchor ListFlatMap
def List.flatMap (f : α → List β) : (xs : List α) → List β
  | [] => []
  | x :: xs => f x ++ xs.flatMap f
```
-- The type signature suggests that {anchorName ListFlatMap}`List.flatMap` could be used to implement a {anchorTerm ListMonad}`Monad List` instance.
-- Indeed, together with {anchorTerm ListMonad}`pure x := [x]`, {anchorName ListFlatMap}`List.flatMap` does implement a monad.
-- However, it's not a very useful {anchorName ListMonad}`Monad` instance.
-- The {anchorName ListMonad}`List` monad is basically a version of {anchorName Many (module:=Examples.Monads.Many)}`Many` that explores _every_ possible path through the search space in advance, before users have the chance to request some number of values.
-- Because of this performance trap, it's usually not a good idea to define a {anchorName ListMonad}`Monad` instance for {anchorName ListMonad}`List`.
-- Here, however, the query language has no operator for restricting the number of results to be returned, so combining all possibilities is exactly what is desired:

类型签名表明 {anchorName ListFlatMap}`List.flatMap` 可用于实现 {anchorTerm ListMonad}`Monad List` 实例。
实际上，与 {anchorTerm ListMonad}`pure x := [x]` 一起，{anchorName ListFlatMap}`List.flatMap` 确实实现了一个单子。
然而，它不是一个非常有用的 {anchorName ListMonad}`Monad` 实例。
{anchorName ListMonad}`List` 单子基本上是 {anchorName Many (module:=Examples.Monads.Many)}`Many` 的一个版本，它在用户有机会请求一定数量的值之前，预先探索搜索空间中的 _每条_ 可能路径。
由于这种性能陷阱，为 {anchorName ListMonad}`List` 定义 {anchorName ListMonad}`Monad` 实例通常不是一个好主意。
然而，在这里，查询语言没有用于限制返回结果数量的运算符，因此组合所有可能性正是我们想要的：

```anchor TableCartProd
def Table.cartesianProduct (table1 : Table s1) (table2 : Table s2) :
    Table (s1 ++ s2) :=
  table1.flatMap fun r1 => table2.map r1.append
```

-- Just as with {anchorName ListProduct (module:=Examples.DependentTypes.Finite)}`List.product`, a loop with mutation in the identity monad can be used as an alternative implementation technique:

就像 {anchorName ListProduct (module:=Examples.DependentTypes.Finite)}`List.product` 一样，恒等单子（Identity Monad）中带有可变状态的循环可以用作替代实现技术：

```anchor TableCartProdOther
def Table.cartesianProduct (table1 : Table s1) (table2 : Table s2) :
    Table (s1 ++ s2) := Id.run do
  let mut out : Table (s1 ++ s2) := []
  for r1 in table1 do
    for r2 in table2 do
      out := (r1.append r2) :: out
  pure out.reverse
```


-- ## Difference
## 差
%%%
tag := "executing-difference"
%%%

-- Removing undesired rows from a table can be done using {anchorName misc}`List.filter`, which takes a list and a function that returns a {anchorName misc}`Bool`.
-- A new list is returned that contains only the entries for which the function returns {anchorName misc}`true`.
-- For instance,

从表中删除不需要的行可以使用 {anchorName misc}`List.filter` 完成，它接受一个列表和一个返回 {anchorName misc}`Bool` 的函数。
返回一个新列表，其中仅包含函数返回 {anchorName misc}`true` 的条目。
例如，

```anchorTerm filterA
["Willamette", "Columbia", "Sandy", "Deschutes"].filter (·.length > 8)
```
-- evaluates to
求值为
```anchorTerm filterA
["Willamette", "Deschutes"]
```
-- because {anchorTerm filterA}`"Columbia"` and {anchorTerm filterA}`"Sandy"` have lengths less than or equal to {anchorTerm filterA}`8`.
-- Removing the entries of a table can be done using the helper {anchorName ListWithout}`List.without`:

因为 {anchorTerm filterA}`"Columbia"` 和 {anchorTerm filterA}`"Sandy"` 的长度小于或等于 {anchorTerm filterA}`8`。
可以使用辅助函数 {anchorName ListWithout}`List.without` 删除表中的条目：

```anchor ListWithout
def List.without [BEq α] (source banned : List α) : List α :=
  source.filter fun r => !(banned.contains r)
```
-- This will be used with the {anchorName BEqDBType}`BEq` instance for {anchorName Row}`Row` when interpreting queries.

这将在解释查询时与 {anchorName Row}`Row` 的 {anchorName BEqDBType}`BEq` 实例一起使用。

-- ## Renaming Columns
## 重命名列
%%%
tag := "executing-renaming-columns"
%%%
-- Renaming a column in a row is done with a recursive function that traverses the row until the column in question is found, at which point the column with the new name gets the same value as the column with the old name:

重命名行中的列是通过一个递归函数完成的，该函数遍历行直到找到有问题的列，此时具有新名称的列获得与具有旧名称的列相同的值：

```anchor renameRow
def Row.rename (c : HasCol s n t) (row : Row s) :
    Row (s.renameColumn c n') :=
  match s, row, c with
  | [_], v, .here => v
  | _::_::_, (v, r), .here => (v, r)
  | _::_::_, (v, r), .there next => addVal v (r.rename next)
```
-- While this function changes the _type_ of its argument, the actual return value contains precisely the same data as the original argument.
-- From a run-time perspective, {anchorName renameRow}`Row.rename` is nothing but a slow identity function.
-- One difficulty in programming with indexed families is that when performance matters, this kind of operation can get in the way.
-- It takes a very careful, often brittle, design to eliminate these kinds of “re-indexing” functions.

虽然此函数更改其参数的 _类型_，但实际返回值包含与原始参数完全相同的数据。
从运行时的角度来看，{anchorName renameRow}`Row.rename` 只不过是一个缓慢的恒等函数。
使用索引族编程的一个困难是，当性能很重要时，这种操作可能会造成阻碍。
需要非常仔细、通常是脆弱的设计才能消除这类“重新索引”函数。

-- ## Prefixing Column Names
## 为列名添加前缀
%%%
tag := "executing-prefixing-column-names"
%%%

-- Adding a prefix to column names is very similar to renaming a column.
-- Instead of proceeding to a desired column and then returning, {anchorName prefixRow}`prefixRow` must process all columns:

为列名添加前缀与重命名列非常相似。
{anchorName prefixRow}`prefixRow` 必须处理所有列，而不是处理到所需的列然后返回：

```anchor prefixRow
def prefixRow (row : Row s) :
    Row (s.map fun c => {c with name := n ++ "." ++ c.name}) :=
  match s, row with
  | [], _ => ()
  | [_], v => v
  | _::_::_, (v, r) => (v, prefixRow r)
```
-- This can be used with {anchorName misc}`List.map` in order to add a prefix to all rows in a table.
-- Once again, this function only exists to change the type of a value.

这可以与 {anchorName misc}`List.map` 一起使用，以便为表中的所有行添加前缀。
再一次，此函数仅用于更改值的类型。

-- ## Putting the Pieces Together
## 组合在一起
%%%
tag := "query-exec-runner"
%%%

-- With all of these helpers defined, executing a query requires only a short recursive function:

定义了所有这些辅助函数后，执行查询只需要一个简短的递归函数：

```anchor QueryExec
def Query.exec : Query s → Table s
  | .table t => t
  | .union q1 q2 => exec q1 ++ exec q2
  | .diff q1 q2 => exec q1 |>.without (exec q2)
  | .select q e => exec q |>.filter e.evaluate
  | .project q _ sub => exec q |>.map (·.project _ sub)
  | .product q1 q2 _ => exec q1 |>.cartesianProduct (exec q2)
  | .renameColumn q c _ _ => exec q |>.map (·.rename c)
  | .prefixWith _ q => exec q |>.map prefixRow
```
-- Some arguments to the constructors are not used during execution.
-- In particular, both the constructor {anchorName Query}`project` and the function {anchorName RowProj}`Row.project` take the smaller schema as explicit arguments, but the type of the _evidence_ that this schema is a subschema of the larger schema contains enough information for Lean to fill out the argument automatically.
-- Similarly, the fact that the two tables have disjoint column names that is required by the {anchorName Query}`product` constructor is not needed by {anchorName TableCartProd}`Table.cartesianProduct`.
-- Generally speaking, dependent types provide many opportunities to have Lean fill out arguments on behalf of the programmer.

构造子的一些参数在执行期间未被使用。
特别是，构造子 {anchorName Query}`project` 和函数 {anchorName RowProj}`Row.project` 都将较小的模式作为显式参数，但该模式是较大模式的子模式的 _证据_ 的类型包含足够的信息，让 Lean 自动填充参数。
类似地，{anchorName Query}`product` 构造子要求的两个表具有不相交的列名这一事实，对于 {anchorName TableCartProd}`Table.cartesianProduct` 来说是不需要的。
一般来说，依赖类型提供了许多机会让 Lean 代表程序员填充参数。

-- Dot notation is used with the results of queries to call functions defined both in the {lit}`Table` and {lit}`List` namespaces, such {anchorName misc}`List.map`, {anchorName misc}`List.filter`, and {anchorName TableCartProd}`Table.cartesianProduct`.
-- This works because {anchorName Table}`Table` is defined using {kw}`abbrev`.
-- Just like type class search, dot notation can see through definitions created with {kw}`abbrev`.

点号表示法用于查询结果，以调用在 {lit}`Table` 和 {lit}`List` 命名空间中定义的函数，例如 {anchorName misc}`List.map`、{anchorName misc}`List.filter` 和 {anchorName TableCartProd}`Table.cartesianProduct`。
这是因为 {anchorName Table}`Table` 是使用 {kw}`abbrev` 定义的。
就像类型类搜索一样，点号表示法可以看穿用 {kw}`abbrev` 创建的定义。

-- The implementation of {anchorName Query}`select` is also quite concise.
-- After executing the query {anchorName selectCase}`q`, {anchorName misc}`List.filter` is used to remove the rows that do not satisfy the expression.
-- {anchorName misc}`List.filter` expects a function from {anchorTerm Table}`Row s` to {anchorName misc}`Bool`, but {anchorName DBExprEval}`DBExpr.evaluate` has type {anchorTerm DBExprEvalType}`Row s → DBExpr s t → t.asType`.
-- Because the type of the {anchorName Query}`select` constructor requires that the expression have type {anchorTerm Query}`DBExpr s .bool`, {anchorTerm DBExprEvalType}`t.asType` is actually {anchorName misc}`Bool` in this context.

{anchorName Query}`select` 的实现也非常简洁。
执行查询 {anchorName selectCase}`q` 后，使用 {anchorName misc}`List.filter` 删除不满足表达式的行。
{anchorName misc}`List.filter` 期望一个从 {anchorTerm Table}`Row s` 到 {anchorName misc}`Bool` 的函数，但 {anchorName DBExprEval}`DBExpr.evaluate` 的类型为 {anchorTerm DBExprEvalType}`Row s → DBExpr s t → t.asType`。
因为 {anchorName Query}`select` 构造子的类型要求表达式具有类型 {anchorTerm Query}`DBExpr s .bool`，所以在这种情况下 {anchorTerm DBExprEvalType}`t.asType` 实际上是 {anchorName misc}`Bool`。

-- A query that finds the heights of all mountain peaks with an elevation greater than 500 meters can be written:

查找海拔大于 500 米的所有山峰高度的查询可以写成：

```anchor Query1
open Query in
def example1 :=
  table mountainDiary |>.select
  (.lt (.const 500) (c! "elevation")) |>.project
  [⟨"elevation", .int⟩] (by repeat constructor)
```

-- Executing it returns the expected list of integers:

执行它返回预期的整数列表：

```anchor Query1Exec
#eval example1.exec
```
```anchorInfo Query1Exec
[3637, 1519, 2549]
```

-- To plan a sightseeing tour, it may be relevant to match all pairs mountains and waterfalls in the same location.
-- This can be done by taking the Cartesian product of both tables, selecting only the rows in which they are equal, and then projecting out the names:

为了计划一次观光旅游，匹配同一地点的所有山脉和瀑布对可能是相关的。
这可以通过获取两个表的笛卡尔积，仅选择它们相等的行，然后投影出名称来完成：

```anchor Query2
open Query in
def example2 :=
  let mountain := table mountainDiary |>.prefixWith "mountain"
  let waterfall := table waterfallDiary |>.prefixWith "waterfall"
  mountain.product waterfall (by decide)
    |>.select (.eq (c! "mountain.location") (c! "waterfall.location"))
    |>.project [⟨"mountain.name", .string⟩, ⟨"waterfall.name", .string⟩]
      (by repeat constructor)
```
-- Because the example data includes only waterfalls in the USA, executing the query returns pairs of mountains and waterfalls in the US:

因为示例数据仅包含美国的瀑布，所以执行查询将返回美国的山脉和瀑布对：

```anchor Query2Exec
#eval example2.exec
```
```anchorInfo Query2Exec
[("Mount Nebo", "Multnomah Falls"), ("Mount Nebo", "Shoshone Falls"), ("Moscow Mountain", "Multnomah Falls"),
  ("Moscow Mountain", "Shoshone Falls"), ("Mount St. Helens", "Multnomah Falls"),
  ("Mount St. Helens", "Shoshone Falls")]
```

-- ## Errors You May Meet
## 你可能会遇到的错误
%%%
tag := "typed-queries-error-messages"
%%%


-- Many potential errors are ruled out by the definition of {anchorName Query}`Query`.
-- For instance, forgetting the added qualifier in {anchorTerm Query2}`"mountain.location"` yields a compile-time error that highlights the column reference {anchorTerm QueryOops1}`c! "location"`:

{anchorName Query}`Query` 的定义排除了许多潜在的错误。
例如，忘记在 {anchorTerm Query2}`"mountain.location"` 中添加限定符会产生编译时错误，突出显示列引用 {anchorTerm QueryOops1}`c! "location"`：

```anchor QueryOops1
open Query in
def example2 :=
  let mountains := table mountainDiary |>.prefixWith "mountain"
  let waterfalls := table waterfallDiary |>.prefixWith "waterfall"
  mountains.product waterfalls (by simp)
    |>.select (.eq (c! "location") (c! "waterfall.location"))
    |>.project [⟨"mountain.name", .string⟩, ⟨"waterfall.name", .string⟩]
      (by repeat constructor)
```
-- This is excellent feedback!
-- On the other hand, the text of the error message is quite difficult to act on:

这是极好的反馈！
另一方面，错误消息的文本很难处理：

```anchorError QueryOops1
unsolved goals
case a.a.a.a.a.a.a
mountains : Query (List.map (fun c => { name := "mountain" ++ "." ++ c.name, contains := c.contains }) peak) := ⋯
waterfalls : Query (List.map (fun c => { name := "waterfall" ++ "." ++ c.name, contains := c.contains }) waterfall) := ⋯
⊢ HasCol (List.map (fun c => { name := "waterfall" ++ "." ++ c.name, contains := c.contains }) []) "location" ?m.62066
```

-- Similarly, forgetting to add prefixes to the names of the two tables results in an error on {kw}`by decide`, which should provide evidence that the schemas are in fact disjoint:

类似地，忘记为两个表的名称添加前缀会导致 {kw}`by decide` 出错，该策略本应提供模式实际上不相交的证据：

```anchor QueryOops2
open Query in
def example2 :=
  let mountains := table mountainDiary
  let waterfalls := table waterfallDiary
  mountains.product waterfalls (by decide)
    |>.select (.eq (c! "mountain.location") (c! "waterfall.location"))
    |>.project [⟨"mountain.name", .string⟩, ⟨"waterfall.name", .string⟩]
      (by repeat constructor)
```
-- This error message is more helpful:

此错误消息更有帮助：

```anchorError QueryOops2
Tactic `decide` proved that the proposition
  disjoint (List.map Column.name peak) (List.map Column.name waterfall) = true
is false
```

-- Lean's macro system contains everything needed not only to provide a convenient syntax for queries, but also to arrange for the error messages to be helpful.
-- Unfortunately, it is beyond the scope of this book to provide a description of implementing languages with Lean macros.
-- An indexed family such as {anchorName Query}`Query` is probably best as the core of a typed database interaction library, rather than its user interface.

Lean 的宏系统包含了所需的一切，不仅可以为查询提供方便的语法，还可以安排错误消息以提供帮助。
不幸的是，提供有关使用 Lean 宏实现语言的描述超出了本书的范围。
像 {anchorName Query}`Query` 这样的索引族可能最适合作为类型化数据库交互库的核心，而不是其用户界面。

-- # Exercises
# 练习
%%%
tag := "typed-query-exercises"
%%%

-- ## Dates
## 日期
%%%
tag := "exercises-dates"
%%%

-- Define a structure to represent dates. Add it to the {anchorName DBExpr}`DBType` universe and update the rest of the code accordingly. Provide the extra {anchorName DBExpr}`DBExpr` constructors that seem to be necessary.

定义一个结构来表示日期。将其添加到 {anchorName DBExpr}`DBType` 宇宙中并相应地更新其余代码。提供似乎必要的额外 {anchorName DBExpr}`DBExpr` 构造子。

-- ## Nullable Types
## 可空类型
%%%
tag := "exercises-nullable-types"
%%%

-- Add support for nullable columns to the query language by representing database types with the following structure:

通过使用以下结构表示数据库类型，为查询语言添加对可空列的支持：

```anchor nullable
structure NDBType where
  underlying : DBType
  nullable : Bool

abbrev NDBType.asType (t : NDBType) : Type :=
  if t.nullable then
    Option t.underlying.asType
  else
    t.underlying.asType
```

-- Use this type in place of {anchorName DBExpr}`DBType` in {anchorName Schema}`Column` and {anchorName DBExpr}`DBExpr`, and look up SQL's rules for {lit}`NULL` and comparison operators to determine the types of {anchorName DBExpr}`DBExpr`'s constructors.

在 {anchorName Schema}`Column` 和 {anchorName DBExpr}`DBExpr` 中使用此类型代替 {anchorName DBExpr}`DBType`，并查找 SQL 关于 {lit}`NULL` 和比较运算符的规则，以确定 {anchorName DBExpr}`DBExpr` 构造子的类型。

-- ## Experimenting with Tactics
## 尝试策略
%%%
tag := "exercises-experimenting-with-tactics"
%%%


-- What is the result of asking Lean to find values of the following types using {kw}`by repeat constructor`? Explain why each gives the result that it does.
--  * {anchorName Naturals}`Nat`
--  * {anchorTerm misc}`List Nat`
--  * {anchorTerm misc}`Vect Nat 4`
--
--  * {anchorTerm misc}`Row []`
--  * {anchorTerm misc}`Row [⟨"price", .int⟩]`
--  * {anchorTerm misc}`Row peak`
--  * {anchorTerm misc}`HasCol [⟨"price", .int⟩, ⟨"price", .int⟩] "price" .int`

要求 Lean 使用 {kw}`by repeat constructor` 查找以下类型的值的结果是什么？解释为什么每个都会给出这样的结果。
 * {anchorName Naturals}`Nat`
 * {anchorTerm misc}`List Nat`
 * {anchorTerm misc}`Vect Nat 4`

 * {anchorTerm misc}`Row []`
 * {anchorTerm misc}`Row [⟨"price", .int⟩]`
 * {anchorTerm misc}`Row peak`
 * {anchorTerm misc}`HasCol [⟨"price", .int⟩, ⟨"price", .int⟩] "price" .int`
