inductive Expr where
  | num (n : Int)
  | add (l r : Expr)
  | sub (l r : Expr)
  | le (l r : Expr)
  | bool (b : Bool)
  | ite (c t f : Expr)
  | id (x : String)
  | func (xs : List String) (b : Expr)
  | app (f : Expr) (as : List Expr)

inductive Value where
  | num (n : Int)
  | bool (b : Bool)
  | clo (xs : List String) (b : Expr) (env : String → Option Value)

abbrev Env := String → Option Value

def Value.toString : Value → String := fun
  | .num n => s!"{n}"
  | .bool b => s!"{b}"
  | .clo _ _ _ => "<function>"

instance : ToString Value where
  toString := Value.toString
