import AeFunc.Interp
import AeFunc.Parser

open AeFunc.Parser (parse)

partial def run (code : String) : String :=
  match parse code with
  | .error _ => "parsing failed"
  | .ok e =>
    match interp e (fun _ ↦ none) with
    | none => "runtime error"
    | some v => s!"{v}"
