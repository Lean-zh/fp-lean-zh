import Examples.Support

book declaration {{{ Plus }}}
  class Plus (α : Type) where
    plus : α → α → α
stop book declaration


bookExample type {{{ PlusType }}}
  Plus
  ===>
  Type → Type
end bookExample


book declaration {{{ PlusNat }}}
  instance : Plus Nat where
    plus := Nat.add
stop book declaration


expect info {{{ plusNatFiveThree }}}
  #eval Plus.plus 5 3
message
"8
"
end expect


book declaration {{{ openPlus }}}
open Plus (plus)
stop book declaration

expect info {{{ plusNatFiveThreeAgain }}}
  #eval plus 5 3
message
"8
"
end expect

#check plus

bookExample type {{{ plusType }}}
  @Plus.plus
  ===>
  {α : Type} → [Plus α] → α → α → α
end bookExample

expect error {{{ plusFloatFail }}}
  #eval plus 5.2 917.25861
message
"failed to synthesize instance
  Plus Float"
end expect


book declaration {{{ Pos }}}
  inductive Pos : Type where
    | one : Pos
    | succ : Pos → Pos
stop book declaration


expect error {{{ sevenOops }}}
  def seven : Pos := 7
message
"failed to synthesize instance
  OfNat Pos 7"
end expect


book declaration {{{ seven }}}
  def seven : Pos :=
    Pos.succ (Pos.succ (Pos.succ (Pos.succ (Pos.succ (Pos.succ Pos.one)))))
stop book declaration


expect error {{{ fourteenOops }}}
  def fourteen : Pos := seven + seven
message
"failed to synthesize instance
  HAdd Pos Pos ?m.299"
end expect

expect error {{{ fortyNineOops }}}
  def fortyNine : Pos := seven * seven
message
"failed to synthesize instance
  HMul Pos Pos ?m.299"
end expect



book declaration {{{ PlusPos }}}
  def Pos.plus : Pos → Pos → Pos
    | Pos.one, k => Pos.succ k
    | Pos.succ n, k => Pos.succ (n.plus k)

  instance : Plus Pos where
    plus := Pos.plus

  def fourteen : Pos := plus seven seven
stop book declaration


book declaration {{{ AddPos }}}
  instance : Add Pos where
    add := Pos.plus
stop book declaration

namespace Extra
book declaration {{{ betterFourteen }}}
  def fourteen : Pos := seven + seven
stop book declaration
end Extra

namespace Foo

axiom x : Nat
axiom y : Nat

evaluation steps {{{ plusDesugar }}}
  x + y
  ===>
  HAdd.hAdd x y
end evaluation steps

end Foo



book declaration {{{ posToNat }}}
def Pos.toNat : Pos → Nat
  | Pos.one => 1
  | Pos.succ n => n.toNat + 1
stop book declaration

namespace Argh

book declaration {{{ posToStringStructure }}}
def posToString (atTop : Bool) (p : Pos) : String :=
  let paren s := if atTop then s else "(" ++ s ++ ")"
  match p with
  | Pos.one => "Pos.one"
  | Pos.succ n => paren s!"Pos.succ {posToString false n}"
stop book declaration

book declaration {{{ UglyToStringPos }}}
instance : ToString Pos where
  toString := posToString true
stop book declaration


expect info {{{ sevenLong }}}
  #eval s!"There are {seven}"
message
"\"There are Pos.succ (Pos.succ (Pos.succ (Pos.succ (Pos.succ (Pos.succ Pos.one)))))\"
"
end expect

end Argh

section Blah


book declaration {{{ PosToStringNat }}}
instance : ToString Pos where
  toString x := toString (x.toNat)
stop book declaration

expect info {{{ sevenShort }}}
  #eval s!"There are {seven}"
message
"\"There are 7\"
"
end expect
end Blah

expect info {{{ sevenEvalStr }}}
  #eval seven
message
"7
"
end expect



namespace Foo

evaluation steps {{{ timesDesugar }}}
  x * y
  ===>
  HMul.hMul x y
end evaluation steps

end Foo



book declaration {{{ PosMul }}}
  def Pos.mul : Pos → Pos → Pos
    | Pos.one, k => k
    | Pos.succ n, k => n.mul k + k

  instance : Mul Pos where
    mul := Pos.mul
stop book declaration


expect info {{{ muls }}}
  #eval [seven * Pos.one,
         seven * seven,
         Pos.succ Pos.one * seven]
message
"[7, 49, 14]"
end expect

namespace NatLits


book declaration {{{ OfNat }}}
class OfNat (α : Type) (_ : Nat) where
  ofNat : α
stop book declaration

end NatLits

similar datatypes OfNat NatLits.OfNat


book declaration {{{ LT4 }}}
  inductive LT4 where
    | zero
    | one
    | two
    | three
  deriving Repr
stop book declaration


book declaration {{{ LT4ofNat }}}
  instance : OfNat LT4 0 where
    ofNat := LT4.zero

  instance : OfNat LT4 1 where
    ofNat := LT4.one

  instance : OfNat LT4 2 where
    ofNat := LT4.two

  instance : OfNat LT4 3 where
    ofNat := LT4.three
stop book declaration


expect info {{{ LT4three }}}
  #eval (3 : LT4)
message
  "LT4.three"
end expect

expect info {{{ LT4zero }}}
  #eval (0 : LT4)
message
  "LT4.zero"
end expect

expect error {{{ LT4four }}}
  #eval (4 : LT4)
message
  "failed to synthesize instance
  OfNat LT4 4"
end expect



book declaration {{{ OfNatPos }}}
  instance : OfNat Pos (n + 1) where
    ofNat :=
      let rec natPlusOne : Nat → Pos
        | 0 => Pos.one
        | k + 1 => Pos.succ (natPlusOne k)
      natPlusOne n
stop book declaration


book declaration {{{ eight }}}
  def eight : Pos := 8
stop book declaration


expect error {{{ zeroBad }}}
  def zero : Pos := 0
message
"failed to synthesize instance
  OfNat Pos 0"
end expect

namespace AltPos


book declaration {{{ AltPos }}}
  structure Pos where
    succ ::
    pred : Nat
stop book declaration

end AltPos

bookExample type {{{ printlnType }}}
  @IO.println
  ===>
  {α : Type} → [ToString α] → α → IO Unit
end bookExample


expect info {{{ printlnMetas }}}
  #check IO.println
message
"IO.println : ?m.3630 → IO Unit"
end expect

expect info {{{ printlnNoMetas }}}
  #check @IO.println
message
"@IO.println : {α : Type u_1} → [inst : ToString α] → α → IO Unit"
end expect


book declaration {{{ ListSum }}}
  def List.sum [Add α] [OfNat α 0] : List α → α
    | [] => 0
    | x :: xs => x + xs.sum
stop book declaration


book declaration {{{ fourNats }}}
  def fourNats : List Nat := [1, 2, 3, 4]
stop book declaration


book declaration {{{ fourPos }}}
  def fourPos : List Pos := [1, 2, 3, 4]
stop book declaration


expect info {{{ fourNatsSum }}}
  #eval fourNats.sum
message
"10"
end expect


expect error {{{ fourPosSum }}}
  #eval fourPos.sum
message
"failed to synthesize instance
  OfNat Pos 0"
end expect

namespace PointStuff


book declaration {{{ PPoint }}}
  structure PPoint (α : Type) where
    x : α
    y : α
  deriving Repr
stop book declaration


book declaration {{{ AddPPoint }}}
  instance [Add α] : Add (PPoint α) where
    add p1 p2 := { x := p1.x + p2.x, y := p1.y + p2.y }
stop book declaration

instance [Mul α] : HMul (PPoint α) α (PPoint α) where
  hMul p z := {x := p.x * z, y := p.y * z}

expect info {{{ HMulPPoint }}}
  #eval {x := 2.5, y := 3.7 : PPoint Float} * 2.0
message
 "{ x := 5.000000, y := 7.400000 }"
end expect

end PointStuff



bookExample type {{{ ofNatType }}}
  @OfNat.ofNat
  ===>
  {α : Type} → (n : Nat) → [OfNat α n] → α
end bookExample

bookExample type {{{ addType }}}
  @Add.add
  ===>
  {α : Type} → [Add α] → α → α → α
end bookExample


namespace Foo

evaluation steps {{{ minusDesugar }}}
  x - y
  ===>
  HSub.hSub x y
end evaluation steps

evaluation steps {{{ divDesugar }}}
  x / y
  ===>
  HDiv.hDiv x y
end evaluation steps

evaluation steps {{{ modDesugar }}}
  x % y
  ===>
  HMod.hMod x y
end evaluation steps

evaluation steps {{{ powDesugar }}}
  x ^ y
  ===>
  HPow.hPow x y
end evaluation steps

evaluation steps {{{ ltDesugar }}}
  x < y
  ===>
  LT.lt x y
end evaluation steps

evaluation steps {{{ leDesugar }}}
  x ≤ y
  ===>
  LE.le x y
end evaluation steps

evaluation steps {{{ gtDesugar }}}
  x > y
  ===>
  LT.lt y x
end evaluation steps

evaluation steps {{{ geDesugar }}}
  x ≥ y
  ===>
  LE.le y x
end evaluation steps


end Foo

namespace OverloadedInt

axiom x : Int

evaluation steps {{{ negDesugar }}}
  (- x)
  ===>
  Neg.neg x
end evaluation steps

end OverloadedInt

namespace OverloadedBits

axiom x : UInt8
axiom y : UInt8

bookExample type {{{ UInt8 }}}
  UInt8
  ===>
  Type
end bookExample

bookExample type {{{ UInt16 }}}
  UInt16
  ===>
  Type
end bookExample

bookExample type {{{ UInt32 }}}
  UInt32
  ===>
  Type
end bookExample

bookExample type {{{ UInt64 }}}
  UInt64
  ===>
  Type
end bookExample

bookExample type {{{ USize }}}
  USize
  ===>
  Type
end bookExample


evaluation steps {{{ bAndDesugar }}}
  x &&& y
  ===>
  AndOp.and x y
end evaluation steps

evaluation steps {{{ bOrDesugar }}}
  x ||| y
  ===>
  OrOp.or x y
end evaluation steps

evaluation steps {{{ bXorDesugar }}}
  x ^^^ y
  ===>
  Xor.xor x y
end evaluation steps

evaluation steps {{{ complementDesugar }}}
  ~~~ x
  ===>
  Complement.complement x
end evaluation steps

evaluation steps {{{ shrDesugar }}}
  x >>> y
  ===>
  ShiftRight.shiftRight x y
end evaluation steps

evaluation steps {{{ shlDesugar }}}
  x <<< y
  ===>
  ShiftLeft.shiftLeft x y
end evaluation steps

evaluation steps {{{ beqDesugar }}}
  x == y
  ===>
  BEq.beq x y
end evaluation steps



end OverloadedBits


book declaration {{{ addNatPos }}}
  def addNatPos : Nat → Pos → Pos
    | 0, p => p
    | n + 1, p => Pos.succ (addNatPos n p)

  def addPosNat : Pos → Nat → Pos
    | p, 0 => p
    | p, n + 1 => Pos.succ (addPosNat p n)
stop book declaration



book declaration {{{ haddInsts }}}
  instance : HAdd Nat Pos Pos where
    hAdd := addNatPos

  instance : HAdd Pos Nat Pos where
    hAdd := addPosNat
stop book declaration


expect info {{{ posNatEx }}}
  #eval (3 : Pos) + (5 : Nat)
message
  "8"
end expect

expect info {{{ natPosEx }}}
  #eval (3 : Nat) + (5 : Pos)
message
  "8"
end expect

namespace ProblematicHPlus

book declaration {{{ HPlus }}}
  class HPlus (α : Type) (β : Type) (γ : Type) where
    hPlus : α → β → γ
stop book declaration


book declaration {{{ HPlusInstances }}}
  instance : HPlus Nat Pos Pos where
    hPlus := addNatPos

  instance : HPlus Pos Nat Pos where
    hPlus := addPosNat
stop book declaration

expect error {{{ hPlusOops }}}
  #eval HPlus.hPlus (3 : Pos) (5 : Nat)
message
"typeclass instance problem is stuck, it is often due to metavariables
  HPlus Pos Nat ?m.7227"
end expect


expect info {{{ hPlusLotsaTypes }}}
  #eval (HPlus.hPlus (3 : Pos) (5 : Nat) : Pos)
message
  "8"
end expect

end ProblematicHPlus



namespace BetterHPlus

book declaration {{{ HPlusOut }}}
  class HPlus (α : Type) (β : Type) (γ : outParam Type) where
    hPlus : α → β → γ
stop book declaration

instance : HPlus Nat Pos Pos where
  hPlus := addNatPos

instance : HPlus Pos Nat Pos where
  hPlus := addPosNat

expect info {{{ hPlusWorks }}}
  #eval HPlus.hPlus (3 : Pos) (5 : Nat)
message
  "8"
end expect


book declaration {{{ notDefaultAdd }}}
  instance [Add α] : HPlus α α α where
    hPlus := Add.add
stop book declaration

expect info {{{ plusFiveThree }}}
  #check HPlus.hPlus (5 : Nat) (3 : Nat)
message
  "HPlus.hPlus 5 3 : Nat"
end expect

expect info {{{ plusFiveMeta }}}
  #check HPlus.hPlus (5 : Nat)
message
  "HPlus.hPlus 5 : ?m.7428 → ?m.7430"
end expect


book declaration {{{ defaultAdd }}}
  @[defaultInstance]
  instance [Add α] : HPlus α α α where
    hPlus := Add.add
stop book declaration


expect info {{{ plusFive }}}
  #check HPlus.hPlus (5 : Nat)
message
  "HPlus.hPlus 5 : Nat → Nat"
end expect

end BetterHPlus

similar datatypes ProblematicHPlus.HPlus BetterHPlus.HPlus

bookExample type {{{ fiveType }}}
  5
  ===>
  Nat
end bookExample


book declaration {{{ northernTrees }}}
  def northernTrees : Array String :=
    #["beech", "birch", "elm", "oak"]
stop book declaration

bookExample {{{ northernTreesSize }}}
  northernTrees.size
  ===>
  4
end bookExample

bookExample {{{ northernTreesTwo }}}
  northernTrees[2]
  ===>
  "elm"
end bookExample


expect error {{{ northernTreesEight }}}
  northernTrees[8]
message
"failed to prove index is valid, possible solutions:
  - Use `have`-expressions to prove the index is valid
  - Use `a[i]!` notation instead, runtime check is perfomed, and 'Panic' error message is produced if index is not valid
  - Use `a[i]?` notation instead, result is an `Option` type
  - Use `a[i]'h` notation instead, where `h` is a proof that index is valid
⊢ 8 < Array.size northernTrees"
end expect

inductive EvenList (α : Type) : Type where
  | nil : EvenList α
  | cons : α → α → EvenList α → EvenList α


book declaration {{{ NonEmptyList }}}
  structure NonEmptyList (α : Type) : Type where
    head : α
    tail : List α
stop book declaration

def NonEmptyList.toList (xs : NonEmptyList α) := xs.head :: xs.tail

book declaration {{{ idahoSpiders }}}
  def idahoSpiders : NonEmptyList String := {
    head := "Banded Garden Spider",
    tail := [
      "Long-legged Sac Spider",
      "Wolf Spider",
      "Hobo Spider",
      "Cat-faced Spider"
    ]
  }
stop book declaration

bookExample {{{ firstSpider }}}
  idahoSpiders.head
   ===>
  "Banded Garden Spider"
end bookExample

bookExample {{{ moreSpiders }}}
  idahoSpiders.tail.length
  ===>
  4
end bookExample

book declaration {{{ NEListGetHuh }}}
  def NonEmptyList.get? : NonEmptyList α → Nat → Option α
    | xs, 0 => some xs.head
    | {head := _, tail := []}, n + 1 => none
    | {head := _, tail := h :: t}, n + 1 => get? {head := h, tail := t} n
stop book declaration

namespace UseList
book declaration {{{ NEListGetHuhList }}}
  def NonEmptyList.get? : NonEmptyList α → Nat → Option α
    | xs, 0 => some xs.head
    | xs, n + 1 => xs.tail.get? n
stop book declaration
end UseList

book declaration {{{ inBoundsNEList }}}
  abbrev NonEmptyList.inBounds (xs : NonEmptyList α) (i : Nat) : Prop :=
    i ≤ xs.tail.length
stop book declaration


book declaration {{{ NEListGet }}}
  def NonEmptyList.get (xs : NonEmptyList α) (i : Nat) (ok : xs.inBounds i) : α :=
    match i with
    | 0 => xs.head
    | n + 1 => xs.tail[n]
stop book declaration



book declaration {{{ spiderBoundsChecks }}}
theorem atLeastThreeSpiders : idahoSpiders.inBounds 2 := by simp

theorem notSixSpiders : ¬idahoSpiders.inBounds 5 := by simp
stop book declaration

book declaration {{{ GetElemNEList }}}
  instance : GetElem (NonEmptyList α) Nat α NonEmptyList.inBounds where
    getElem := NonEmptyList.get
stop book declaration


bookExample {{{ firstSpider }}}
  idahoSpiders[0]
   ===>
  "Banded Garden Spider"
end bookExample


expect error {{{ tenthSpider }}}
  idahoSpiders[9]
message
  "failed to prove index is valid, possible solutions:
  - Use `have`-expressions to prove the index is valid
  - Use `a[i]!` notation instead, runtime check is perfomed, and 'Panic' error message is produced if index is not valid
  - Use `a[i]?` notation instead, result is an `Option` type
  - Use `a[i]'h` notation instead, where `h` is a proof that index is valid
⊢ NonEmptyList.inBounds idahoSpiders 9"
end expect




book declaration {{{ ListPosElem }}}
  instance : GetElem (List α) Pos α (fun n k => n.length > k.toNat) where
    getElem (xs : List α) (i : Pos) ok := xs[i.toNat]
stop book declaration

namespace PointStuff


book declaration {{{ PPointBoolGetElem }}}
  instance : GetElem (PPoint α) Bool α (fun _ _ => True) where
    getElem (p : PPoint α) (i : Bool) _ :=
      if not i then p.x else p.y
stop book declaration


instance : GetElem (PPoint α) Nat α (fun _ n => n < 2) where
  getElem (p : PPoint α) (i : Nat) _ :=
    match i with
    | 0 => p.x
    | 1 => p.y
end PointStuff

bookExample {{{ boolEqTrue }}}
  "Octopus" ==  "Cuttlefish"
  ===>
  false
end bookExample

bookExample {{{ boolEqFalse }}}
  "Octopodes" ==  "Octo".append "podes"
  ===>
  true
end bookExample

expect error {{{ functionEq }}}
  (fun (x : Nat) => 1 + x) == (Nat.succ ·)
message
"failed to synthesize instance
  BEq (Nat → Nat)"
end expect

bookExample type {{{ functionEqProp }}}
  (fun (x : Nat) => 1 + x) = (Nat.succ ·)
  ===>
  Prop
end bookExample

example : (fun (x : Nat) => 1 + x) = (Nat.succ ·) := by
  funext x ; induction x <;> simp_arith

-- Example for exercise
inductive Method where
  | GET
  | POST
  | PUT
  | DELETE

structure Response where

class HTTP (m : Method) where
  doTheWork : (uri : String) → IO Response

expect info {{{ twoLessFour }}}
  #check 2 < 4
message
  "2 < 4 : Prop"
end expect

expect error {{{ funEqDec }}}
  if (fun (x : Nat) => 1 + x) = (Nat.succ ·) then "yes" else "no"
message
"failed to synthesize instance
  Decidable ((fun x => 1 + x) = fun a => Nat.succ a)"
end expect

bookExample : Nat {{{ ifProp }}}
  if 2 < 4 then 1 else 2
  ===>
  1
end bookExample

namespace Cmp
book declaration {{{ Ordering }}}
  inductive Ordering where
  | lt
  | eq
  | gt
stop book declaration
end Cmp

similar datatypes Ordering Cmp.Ordering


book declaration {{{ OrdPos }}}
  def Pos.comp : Pos → Pos → Ordering
    | Pos.one, Pos.one => Ordering.eq
    | Pos.one, Pos.succ _ => Ordering.lt
    | Pos.succ _, Pos.one => Ordering.gt
    | Pos.succ n, Pos.succ k => comp n k

  instance : Ord Pos where
    compare := Pos.comp
stop book declaration

namespace H

book declaration {{{ Hashable }}}
  class Hashable (α : Type) where
    hash : α → UInt64
stop book declaration
end H

similar datatypes Hashable H.Hashable

bookExample type {{{ mixHash }}}
  mixHash
  ===>
  UInt64 → UInt64 → UInt64
end bookExample


book declaration {{{ HashablePos }}}
  def hashPos : Pos → UInt64
    | Pos.one => 0
    | Pos.succ n => mixHash 1 (hashPos n)

  instance : Hashable Pos where
    hash := hashPos
stop book declaration

book declaration {{{ HashableNonEmptyList }}}
  instance [Hashable α] : Hashable (NonEmptyList α) where
    hash xs := mixHash (hash xs.head) (hash xs.tail)
stop book declaration



book declaration {{{ BEqHashableDerive }}}
  deriving instance BEq, Hashable for Pos
  deriving instance BEq, Hashable, Repr for NonEmptyList
stop book declaration

namespace A
book declaration {{{ HAppend }}}
  class HAppend (α : Type) (β : Type) (γ : outParam Type) where
    hAppend : α → β → γ
stop book declaration
end A

namespace AppendOverloads
section
axiom xs : List Nat
axiom ys : List Nat
bookExample {{{ desugarHAppend }}}
  xs ++ ys
   ===>
  HAppend.hAppend xs ys
end bookExample
end
end AppendOverloads


book declaration {{{ AppendNEList }}}
  instance : Append (NonEmptyList α) where
    append xs ys :=
      { head := xs.head, tail := xs.tail ++ ys.head :: ys.tail }
stop book declaration

expect info {{{ appendSpiders }}}
  #eval idahoSpiders ++ idahoSpiders
  message
  "{ head := \"Banded Garden Spider\",
  tail := [\"Long-legged Sac Spider\",
           \"Wolf Spider\",
           \"Hobo Spider\",
           \"Cat-faced Spider\",
           \"Banded Garden Spider\",
           \"Long-legged Sac Spider\",
           \"Wolf Spider\",
           \"Hobo Spider\",
           \"Cat-faced Spider\"] }"
end expect


similar datatypes HAppend A.HAppend
