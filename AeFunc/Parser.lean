import Std.Internal.Parsec
import AeFunc.Lang

open Std.Internal.Parsec (attempt eof many notFollowedBy)
open Std.Internal.Parsec.String (Parser asciiLetter digit digits pchar pstring ws)

namespace AeFunc.Parser

def isKeyword (x : String) : Bool :=
  x == "if" || x == "then" || x == "else" ||
  x == "true" || x == "false" || x == "fun"

def idChar : Parser Char :=
  asciiLetter.orElse fun _ ↦
  (pchar '_').orElse fun _ ↦ digit

def ident : Parser String := do
  let first ← asciiLetter.orElse fun _ ↦ pchar '_'
  let rest ← many idChar
  let x := String.ofList (first :: rest.toList)
  if isKeyword x then
    Std.Internal.Parsec.fail s!"{x} is a keyword"
  else
    pure x

def keyword (s : String) : Parser String := attempt do
  let x ← pstring s
  notFollowedBy idChar
  pure x

def int : Parser Int := do
  let negative ← (some <$> pchar '-').orElse fun _ ↦ pure none
  ws
  let n ← digits
  pure (if negative.isSome then -n else n)

def chainl (term : Parser Expr) (operator : Parser (Expr → Expr → Expr)) : Parser Expr := do
  let first ← term
  let rest ← many (attempt do
    ws
    let op ← operator
    ws
    let next ← term
    pure (op, next))
  pure (rest.foldl (fun left (op, right) ↦ op left right) first)

def addOp : Parser (Expr → Expr → Expr) :=
  ((fun _ ↦ Expr.add) <$> pchar '+').orElse fun _ ↦
  ((fun _ ↦ Expr.sub) <$> pchar '-')

def leOp : Parser (Expr → Expr → Expr) :=
  (fun _ ↦ Expr.le) <$> pstring "<="

def bool : Parser Expr :=
  ((fun _ ↦ Expr.bool true) <$> keyword "true").orElse fun _ ↦
  ((fun _ ↦ Expr.bool false) <$> keyword "false")

def commaSep (item : Parser α) : Parser (List α) := do
  let first ← (some <$> item).orElse fun _ ↦ pure none
  match first with
  | none => pure []
  | some x =>
    let rest ← many (attempt do
      ws
      _ ← pchar ','; ws
      item)
    pure (x :: rest.toList)

mutual
  partial def ite : Parser Expr := do
    _ ← keyword "if"; ws
    let condition ← expr; ws
    _ ← keyword "then"; ws
    let thenBranch ← expr; ws
    _ ← keyword "else"; ws
    let elseBranch ← expr
    pure (Expr.ite condition thenBranch elseBranch)

  partial def func : Parser Expr := do
    _ ← keyword "fun"; ws
    _ ← pchar '('; ws
    let xs ← commaSep ident; ws
    _ ← pchar ')'; ws
    if !xs.Nodup then
      Std.Internal.Parsec.fail "duplicate function parameter"
    _ ← pstring "=>"; ws
    let body ← expr
    pure (Expr.func xs body)

  partial def atom : Parser Expr :=
    (do
      _ ← pchar '('; ws
      let e ← expr; ws
      _ ← pchar ')'
      pure e).orElse fun _ ↦
    (Expr.num <$> int).orElse fun _ ↦
    bool.orElse fun _ ↦
    ite.orElse fun _ ↦
    func.orElse fun _ ↦
    (Expr.id <$> ident)

  partial def app : Parser Expr := do
    let f ← atom
    let calls ← many (attempt do
      ws
      _ ← pchar '('; ws
      let args ← commaSep expr; ws
      _ ← pchar ')'
      pure args)
    pure (calls.foldl Expr.app f)

  partial def add : Parser Expr :=
    chainl app addOp

  partial def expr : Parser Expr :=
    chainl add leOp
end

def parse (s : String) : Except String Expr :=
  Parser.run (do
    ws
    let result ← expr
    ws
    eof
    pure result) s

end AeFunc.Parser
