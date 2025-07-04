import SubVerso.Examples
import Lean.Data.NameMap
import Std.Data.HashMap
import VersoManual

open Lean (NameMap MessageSeverity)
open Std

namespace FPLeanZh


open Verso Doc Elab Genre.Manual ArgParse Code Highlighted WebAssets Output Html
open SubVerso.Highlighting
open Lean

-- TODO syntax highlighting for C#, TypeScript, Python etc (use the same technique as C in the manual)

@[code_block_expander CSharp]
def CSharp : CodeBlockExpander
  | _args, code => do
    return #[← ``(Block.code $(quote code.getString))]

@[role_expander CSharp]
def inlineCSharp : RoleExpander
  | _args, code => do
    let #[code] := code
      | throwErrorAt (mkNullNode code) "Expected exactly one code argument" /- 预期只有一个代码参数 -/
    let `(inline|code($code)) := code
      | throwErrorAt code "Exected code" /- 预期代码 -/
    return #[← ``(Inline.code $(quote code.getString))]

@[code_block_expander Kotlin]
def Kotlin : CodeBlockExpander
  | _args, code => do
    return #[← ``(Block.code $(quote code.getString))]

@[role_expander Kotlin]
def inlineKotlin : RoleExpander
  | _args, code => do
    let #[code] := code
      | throwErrorAt (mkNullNode code) "Expected exactly one code argument" /- 预期只有一个代码参数 -/
    let `(inline|code($code)) := code
      | throwErrorAt code "Exected code" /- 预期代码 -/
    return #[← ``(Inline.code $(quote code.getString))]

@[code_block_expander cpp]
def cpp : CodeBlockExpander
  | _args, code => do
    return #[← ``(Block.code $(quote code.getString))]

@[role_expander cpp]
def inlineCpp : RoleExpander
  | _args, code => do
    let #[code] := code
      | throwErrorAt (mkNullNode code) "Expected exactly one code argument" /- 预期只有一个代码参数 -/
    let `(inline|code($code)) := code
      | throwErrorAt code "Exected code" /- 预期代码 -/
    return #[← ``(Inline.code $(quote code.getString))]


@[code_block_expander typescript]
def typescript : CodeBlockExpander
  | _args, code => do
    return #[← ``(Block.code $(quote code.getString))]

@[role_expander typescript]
def inlineTypescript : RoleExpander
  | _args, code => do
    let #[code] := code
      | throwErrorAt (mkNullNode code) "Expected exactly one code argument" /- 预期只有一个代码参数 -/
    let `(inline|code($code)) := code
      | throwErrorAt code "Exected code" /- 预期代码 -/
    return #[← ``(Inline.code $(quote code.getString))]

@[role_expander c]
def c : RoleExpander
  | _args, code => do
    let #[code] := code
      | throwErrorAt (mkNullNode code) "Expected exactly one code argument" /- 预期只有一个代码参数 -/
    let `(inline|code($code)) := code
      | throwErrorAt code "Exected code" /- 预期代码 -/
    return #[← ``(Inline.code $(quote code.getString))]

@[role_expander java]
def java : RoleExpander
  | _args, code => do
    let #[code] := code
      | throwErrorAt (mkNullNode code) "Expected exactly one code argument" /- 预期只有一个代码参数 -/
    let `(inline|code($code)) := code
      | throwErrorAt code "Exected code" /- 预期代码 -/
    return #[← ``(Inline.code $(quote code.getString))]

@[role_expander rust]
def rust : RoleExpander
  | _args, code => do
    let #[code] := code
      | throwErrorAt (mkNullNode code) "Expected exactly one code argument" /- 预期只有一个代码参数 -/
    let `(inline|code($code)) := code
      | throwErrorAt code "Exected code" /- 预期代码 -/
    return #[← ``(Inline.code $(quote code.getString))]

@[code_block_expander python]
def python : CodeBlockExpander
  | _args, code => do
    return #[← ``(Block.code $(quote code.getString))]

@[role_expander python]
def inlinePython : RoleExpander
  | _args, code => do
    let #[code] := code
      | throwErrorAt (mkNullNode code) "Expected exactly one code argument" /- 预期只有一个代码参数 -/
    let `(inline|code($code)) := code
      | throwErrorAt code "Exected code" /- 预期代码 -/
    return #[← ``(Inline.code $(quote code.getString))]

@[code_block_expander fsharp]
def fsharp : CodeBlockExpander
  | _args, code => do
    return #[← ``(Block.code $(quote code.getString))]

@[role_expander fsharp]
def fsharpInline : RoleExpander
  | _args, code => do
    let #[code] := code
      | throwErrorAt (mkNullNode code) "Expected exactly one code argument" /- 预期只有一个代码参数 -/
    let `(inline|code($code)) := code
      | throwErrorAt code "Exected code" /- 预期代码 -/
    return #[← ``(Inline.code $(quote code.getString))]


@[code_block_expander fsharpError]
def fsharpError : CodeBlockExpander
  | _args, code => do
    return #[← ``(Block.code $(quote code.getString))]


section

variable [Monad m] [MonadError m]

structure IncludePythonConfig where
  file : String
  anchor? : Option Ident

instance : FromArgs IncludePythonConfig m where
  fromArgs :=   IncludePythonConfig.mk <$> .positional' `file <*> .named' `anchor true

end

/-
If a line could be an anchor indicator, returns the anchor's name along with `true` for a start
and `false` for an end.

An anchor consists of a line that contains `ANCHOR:` or `ANCHOR_END:` followed by the name
of the anchor.
-/
/- 如果一行可能是锚点指示符，则返回锚点名称，以及 `true` 表示开始，`false` 表示结束。

锚点由包含 `ANCHOR:` 或 `ANCHOR_END:` 的行组成，后跟锚点名称。
-/
def anchor? (line : String) : Except String (String × Bool) := do
  let mut line := line.trim
  line := line.dropWhile (· ≠ 'A')
  if line.startsWith "ANCHOR:" then
    line := line.stripPrefix "ANCHOR:"
    line := line.trimLeft
    if line.isEmpty then throw "Expected name after `ANCHOR: `" /- 预期在 `ANCHOR: ` 之后有名称 -/ else return (line, true)
  else if line.startsWith "ANCHOR_END:" then
    line := line.stripPrefix "ANCHOR_END:"
    line := line.trimLeft
    if line.isEmpty then throw "Expected name after `ANCHOR_END: `" /- 预期在 `ANCHOR_END: ` 之后有名称 -/ else return (line, false)
  else throw s!"Expected `ANCHOR:` or `ANCHOR_END:`, got {line}" /- 预期 `ANCHOR:` 或 `ANCHOR_END:`，得到 {line} -/

private def stringAnchors (s : String) : Except String (String × HashMap String String) := do
  let mut out := ""
  let mut anchors : HashMap String String := {}
  let mut openAnchors : HashMap String String := {}
  let lines := s.split (· == '\n')
  for line in lines do
    if let some (a, isOpener) := anchor? line |>.toOption then
      if isOpener then
        if openAnchors.contains a then throw s!"Already open: {a}" /- 已经打开：{a} -/
        else openAnchors := openAnchors.insert a ""
      else
        if let some txt := openAnchors[a]? then
          anchors := anchors.insert a txt
          openAnchors := openAnchors.erase a
        else throw s!"Not open: {a}" /- 未打开：{a} -/
    else
      out := out ++ line ++ "\n"
      for (k, v) in openAnchors do
        openAnchors := openAnchors.insert k (v ++ line ++ "\n")
  for a in openAnchors.keys do
    throw s!"Anchor {a} never closed" /- 锚点 {a} 从未关闭 -/
  return (out, anchors)

@[code_block_expander includePython]
def includePython : CodeBlockExpander
  | args, code => do
    let {file, anchor?} ← parseThe IncludePythonConfig args
    let s ← IO.FS.readFile file
    let txt ←
      if let some a := anchor? then
        let .ok (_, as) := stringAnchors s
          | throwErrorAt a m!"Couldn't parse anchors" /- 无法解析锚点 -/
        let some txt := as[a.getId.eraseMacroScopes.toString]?
          | throwErrorAt a m!"Not found in {as.keys}" /- 未在 {as.keys} 中找到 -/
        pure txt
      else
        pure s
    _ ← ExpectString.expectString "file" /- 文件 -/ code txt
    return #[← ``(Block.code $(quote code.getString))]
