import AeFunc.Lang

/-- Bind `x` to `v`, leaving all other bindings unchanged. -/
def updateEnv (env : Env) (x : String) (v : Value) : Env :=
  fun y ↦ if x == y then some v else env y

/-- Bind identifiers to values in order, failing if their counts differ. -/
def updateEnvMult (env : Env) (xs : List String) (vs : List Value) 
    : Option Env :=
  match xs, vs with
  | [], [] => sorry
  | x :: xs', v :: vs' => sorry
  | _, _ => sorry

mutual

  /-- Evaluate two integer operands and apply `op`, failing on invalid operands. -/
  partial def binOp (op : Int → Int → Value) (e1 e2 : Expr) (env : Env)
      : Option Value :=
    match interp e1 env with
    | none => none
    | some v1 =>
      match interp e2 env with
      | none => none
      | some v2 =>
        match v1, v2 with
        | .num n1, .num n2 => some (op n1 n2)
        | _, _ => none

  /--
  Evaluate expressions from left to right in the same environment.
  Return their values in the original order, or `none` if any argument fails.
  -/
  partial def interpMult (es : List Expr) (env : Env) : Option (List Value) :=
    match es with
    | [] => sorry
    | e :: es' => sorry

  /-- Evaluate an expression, returning `none` on error. -/
  partial def interp (e : Expr) (env : Env) : Option Value :=
    match e with
    | .num n => some (.num n)
    | .add e1 e2 => binOp (fun n1 n2 ↦ .num (n1 + n2)) e1 e2 env
    | .sub e1 e2 => binOp (fun n1 n2 ↦ .num (n1 - n2)) e1 e2 env
    | .le e1 e2 => binOp (fun n1 n2 ↦ .bool (n1 ≤ n2)) e1 e2 env
    | .bool b => some (.bool b)
    | .ite c t f =>
      match interp c env with
      | some (.bool true) => interp t env
      | some (.bool false) => interp f env
      | _ => none
    | .id x => env x
    | .func xs b => sorry
    | .app f as => sorry

end
