import AeFunc.Run

def main : IO Unit := do
  let stdin ← IO.getStdin
  let source ← stdin.readToEnd
  IO.println (run source)
