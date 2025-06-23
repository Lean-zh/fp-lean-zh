<!--
# Safe Array Indices
-->

# 安全数组索引 { #safe-array-indices }

<!--
The `GetElem` instance for `Array` and `Nat` requires a proof that the provided `Nat` is smaller than the array.
In practice, these proofs often end up being passed to functions along with the indices.
Rather than passing an index and a proof separately, a type called `Fin` can be used to bundle up the index and the proof into a single value.
This can make code easier to read.
Additionally, many of the built-in operations on arrays take their index arguments as `Fin` rather than as `Nat`, so using these built-in operations requires understanding how to use `Fin`.
-->

`Array` 和 `Nat` 的 `GetElem` 实例需要证明提供的 `Nat` 小于数组。
在实践中，这些证明通常最终会连同索引一起传递给函数。
与其分别传递索引和证明，可以使用名为 `Fin` 的类型将索引和证明捆绑到单个值中。
这可以使代码更易阅。此外，许多对数组的内置操作将其索引参数作为 `Fin` 而非 `Nat`，
因此使用这些内置操作需要了解如何使用 `Fin`。

<!--
The type `Fin n` represents numbers that are strictly less than `n`.
In other words, `Fin 3` describes `0`, `1`, and `2`, while `Fin 0` has no values at all.
The definition of `Fin` resembles `Subtype`, as a `Fin n` is a structure that contains a `Nat` and a proof that it is less than `n`:
-->

类型 `Fin n` 表示严格小于 `n` 的数字。换句话说，`Fin 3` 描述 `0`、`1` 和 `2`，
而 `Fin 0` 没有任何值。`Fin` 的定义类似于 `Subtype`，因为 `Fin n` 是一个包含 `Nat`
和小于 `n` 的证明的结构体：

```lean
{{#example_decl Examples/ProgramsProofs/Fin.lean Fin}}
```

<!--
Lean includes instances of `ToString` and `OfNat` that allow `Fin` values to be conveniently used as numbers.
In other words, the output of `{{#example_in Examples/ProgramsProofs/Fin.lean fiveFinEight}}` is `{{#example_out Examples/ProgramsProofs/Fin.lean fiveFinEight}}`, rather than something like `{val := 5, isLt := _}`.
-->

Lean 包含 `ToString` 和 `OfNat` 的实例，允许将 `Fin` 值方便地用作数字。
换句话说，`{{#example_in Examples/ProgramsProofs/Fin.lean fiveFinEight}}`
的输出为 `{{#example_out Examples/ProgramsProofs/Fin.lean fiveFinEight}}`，
而非类似 `{val := 5, isLt := _}` 的值。

<!--
Instead of failing when the provided number is larger than the bound, the `OfNat` instance for `Fin` returns a value modulo the bound.
This means that `{{#example_in Examples/ProgramsProofs/Fin.lean finOverflow}}` results in `{{#example_out Examples/ProgramsProofs/Fin.lean finOverflow}}` rather than a compile-time error.
-->

当提供的数字大于边界时，`OfNat` 实例对于 `Fin` 不会失败，而是返回一个对边界取模的值。
这意味着 `#eval (45 : Fin 10)` 的结果是 `5`，而非编译时错误。

<!--
In a return type, a `Fin` returned as a found index makes its connection to the data structure in which it was found more clear.
The `Array.find` in the [previous section](./arrays-termination.md#proving-termination) returns an index that the caller cannot immediately use to perform lookups into the array, because the information about its validity has been lost.
A more specific type results in a value that can be used without making the program significantly more complicated:
-->

在返回类型中，将 `Fin` 作为找到的索引返回，能够让它与其所在的数据结构的连接更加清晰。
[上一节](./arrays-termination.md#proving-termination)中的 `Array.find` 返回一个索引，
调用者不能立即使用它来执行数组查找，因为有关其有效性的信息已丢失。
更具体类型的值可以直接使用，而不会使程序变得复杂得多：

```lean
{{#example_decl Examples/ProgramsProofs/Fin.lean ArrayFindHelper}}

{{#example_decl Examples/ProgramsProofs/Fin.lean ArrayFind}}
```

<!--
## Exercise
-->

## 练习 { #exercise }

<!--
Write a function `Fin.next? : Fin n → Option (Fin n)` that returns the next largest `Fin` when it would be in bounds, or `none` if not.
Check that
-->

编写一个函数 `Fin.next? : Fin n → Option (Fin n)` 当 `Fin` 在边界内时返回下一个最大的 `Fin`，
否则返回 `none`。检查

```lean
{{#example_in Examples/ProgramsProofs/Fin.lean nextThreeFin}}
```

<!--
outputs
-->

会输出

```output info
{{#example_out Examples/ProgramsProofs/Fin.lean nextThreeFin}}
```

<!--
and that
-->

而

```lean
{{#example_in Examples/ProgramsProofs/Fin.lean nextSevenFin}}
```

<!--
outputs
-->

会输出

```output info
{{#example_out Examples/ProgramsProofs/Fin.lean nextSevenFin}}
```