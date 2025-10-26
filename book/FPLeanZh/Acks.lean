import VersoManual
import FPLeanZh.Examples

open Verso.Genre Manual
open Verso.Code.External

open FPLeanZh

set_option verso.exampleProject "../examples"
set_option verso.exampleModule "Examples.TODO"

#doc (Manual) "Acknowledgments" =>
%%%
number := false
%%%

/-
This free online book was made possible by the generous support of Microsoft Research, who paid for it to be written and given away.
During the process of writing, they made the expertise of the Lean development team available to both answer my questions and make Lean easier to use.
In particular, Leonardo de Moura initiated the project and helped me get started, Chris Lovett set up the CI and deployment automation and provided great feedback as a test reader, Gabriel Ebner provided technical reviews, Sarah Smith kept the administrative side working well, and Vanessa Rodriguez helped me diagnose a tricky interaction between the source-code highlighting library and certain versions of Safari on iOS.
-/
这本免费在线书籍的出版得益于微软研究院的慷慨支持，他们出资编写并免费赠送了这本书。
在编写过程中，他们提供了 Lean 开发团队的专业知识来回答我的问题并使 Lean 更易于使用。
特别是，Leonardo de Moura 发起了这个项目并帮助我入门，Chris Lovett 设置了 CI
和部署自动化并作为测试读者提供了很好的反馈，Gabriel Ebner 提供了技术评论，
Sarah Smith 使管理方面工作顺利，Vanessa Rodriguez 帮助我诊断了源代码高亮显示库和
iOS 上某些版本的 Safari 之间的棘手交互。

/-
Writing this book has taken up many hours outside of normal working hours.
My wife Ellie Thrane Christiansen has taken on a larger than usual share of running the family, and this book could not exist if she had not done so.
An extra day of work each week has not been easy for my family—thank you for your patience and support while I was writing.
-/
编写这本书占用了正常工作时间以外的很多时间。
我的妻子 Ellie Thrane Christiansen 承担了比平时更多的家庭事务，如果没有她，这本书就不可能存在。
每周多一天工作对我的家人来说并不容易——感谢你们在我写作期间的耐心和支持。

/-
The online community surrounding Lean provided enthusiastic support for the project, both technical and emotional.
In particular, Sebastian Ullrich provided key help when I was learning Lean's metaprogramming system in order to write the supporting code that allowed the text of error messages to be both checked in CI and easily included in the book itself.
Within hours of posting a new revision, excited readers would be finding mistakes, providing suggestions, and showering me with kindness.
In particular, I'd like to thank Arien Malec, Asta Halkjær From, Bulhwi Cha, Craig Stuntz, Daniel Fabian, Evgenia Karunus, eyelash, Floris van Doorn, František Silváši, Henrik Böving, Ian Young, Jeremy Salwen, Jireh Loreaux, Kevin Buzzard, Lars Ericson, Liu Yuxi, Mac Malone, Malcolm Langfield, Mario Carneiro, Newell Jensen, Patrick Massot, Paul Chisholm, Pietro Monticone, Tomas Puverle, Yaël Dillies, Zhiyuan Bao, and Zyad Hassan for their many suggestions, both stylistic and technical.
-/
围绕 Lean 的在线社区为该项目提供了热情的支持，包括技术和情感支持。
特别是，Sebastian Ullrich 在我学习 Lean 的元编程系统时提供了关键帮助，
以便编写支持代码，使错误消息的文本既可以在 CI 中进行检查，又可以轻松地包含在书中。
在发布新修订版的几个小时内，兴奋的读者就会发现错误、提供建议并向我表达善意。
我要特别感谢 Arien Malec、Asta Halkjær From、Bulhwi Cha、Craig Stuntz、Daniel Fabian、
Evgenia Karunus、eyelash、Floris van Doorn、František Silváši、Henrik Böving、
Ian Young、Jeremy Salwen、Jireh Loreaux、Kevin Buzzard、Lars Ericson、Liu Yuxi、
Mac Malone、Malcolm Langfield、Mario Carneiro、Newell Jensen、Patrick Massot、
Paul Chisholm、Pietro Monticone、Tomas Puverle、Yaël Dillies、Zhiyuan Bao
和 Zyad Hassan 提出的许多建议，包括风格和技术方面的建议。
