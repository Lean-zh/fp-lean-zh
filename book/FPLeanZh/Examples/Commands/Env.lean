import Lean.Environment
import Std.Data.HashMap
import SubVerso.Highlighting.Highlighted
import SubVerso.Module


open Lean Std

open SubVerso Highlighting Module Highlighted

namespace FPLeanZh

structure Container where
  /-- The container's temporary working directory -/ /- 容器的临时工作目录 -/
  workingDirectory : System.FilePath
  /-- The saved outputs from each command run in the container -/ /- 容器中运行的每个命令的保存输出 -/
  outputs : HashMap String String := {}

initialize containersExt : (EnvExtension (NameMap Container)) ← registerEnvExtension (pure {})
