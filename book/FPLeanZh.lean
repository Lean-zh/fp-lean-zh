import VersoManual

import FPLeanZh.Intro
import FPLeanZh.Acks
import FPLeanZh.GettingToKnow
import FPLeanZh.HelloWorld
import FPLeanZh.PropsProofsIndexing
import FPLeanZh.TypeClasses
import FPLeanZh.Monads
import FPLeanZh.FunctorApplicativeMonad
import FPLeanZh.MonadTransformers
import FPLeanZh.DependentTypes
import FPLeanZh.TacticsInductionProofs
import FPLeanZh.ProgramsProofs
import FPLeanZh.NextSteps

open Verso.Genre Manual
open Verso Code External

open Verso Doc Elab in
open Lean (quote) in
@[role_expander versionString]
def versionString : RoleExpander
  | #[], #[] => do
    let version ← IO.FS.readFile "../examples/lean-toolchain"
    let version := version.stripPrefix "leanprover/lean4:" |>.trim
    pure #[← ``(Verso.Doc.Inline.code $(quote version))]
  | _, _ => throwError "Unexpected arguments"


#doc (Manual) "Lean 函数式编程" =>
-- "Functional Programming in Lean"

%%%
authors := ["David Thrane Christiansen"]
translators := ["Oling Cat", "Qiu233", "JiechengZhao"]
%%%

-- _Copyright Microsoft Corporation 2023 and Lean FRO, LLC 2023–2025_
_版权所有 Microsoft Corporation 2023 和 Lean FRO, LLC 2023–2025_

-- This is a free book on using Lean as a programming language. All code samples are tested with Lean release {versionString}[].
这是一本关于将 Lean 作为编程语言使用的免费书籍。所有代码示例都使用 Lean 版本 {versionString}[] 进行测试。

{include 1 FPLeanZh.Intro}

{include 1 FPLeanZh.Acks}

{include 1 FPLeanZh.GettingToKnow}
