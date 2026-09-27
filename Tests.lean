import AeFunc

/-- info: "42" -/
#guard_msgs in
#eval run "(fun () => 42)()"

/-- info: "-7" -/
#guard_msgs in
#eval run "(fun (x) => x)(-7)"

/-- info: "13" -/
#guard_msgs in
#eval run "(fun (x, y) => x + y)(4, 9)"

/-- info: "13" -/
#guard_msgs in
#eval run "(fun (x, y, z) => x - y - z)(20, 3, 4)"

/-- info: "true" -/
#guard_msgs in
#eval run "(fun (x, y) => x <= y)(2, 2)"

/-- info: "20" -/
#guard_msgs in
#eval run "(fun (flag, x, y) => if flag then x else y)(false, 10, 20)"

/-- info: "11" -/
#guard_msgs in
#eval run "(fun (x, y) => x + y)((fun (n) => n + 1)(4), (fun () => 6)())"

/-- info: "11" -/
#guard_msgs in
#eval run "(fun (x) => fun (y, z) => x + y - z)(10)(4, 3)"

/-- info: "5" -/
#guard_msgs in
#eval run "(fun (f, x, y) => f(x, y))(fun (a, b) => a - b, 9, 4)"

/-- info: "3" -/
#guard_msgs in
#eval run "(fun (x, y) => if x <= y then y - x else x - y)(2, 5)"

/-- info: "11" -/
#guard_msgs in
#eval run "(fun (x) => (fun (f) => (fun (x) => f(1))(100))(fun (y) => x + y))(10)"

/-- info: "110" -/
#guard_msgs in
#eval run "(fun (x) => (fun (f) => (fun (x) => f(x))(100))(fun (y) => x + y))(10)"

/-- info: "-17" -/
#guard_msgs in
#eval run "(fun (x) => (fun (x, y) => x - y)(3, x))(20)"

/-- info: "25" -/
#guard_msgs in
#eval run "(fun (x, y) => fun (z) => x - y + z)(30, 7)(2)"

/-- info: "102" -/
#guard_msgs in
#eval run "(fun (x) => (fun (apply) => (fun (x) => apply(fun (y) => x + y, 2))(100))(fun (f, n) => f(n)))(10)"

/-- info: "runtime error" -/
#guard_msgs in
#eval run "(fun (x, y) => x + y)(1)"

/-- info: "runtime error" -/
#guard_msgs in
#eval run "(fun () => 42)(1)"

/-- info: "runtime error" -/
#guard_msgs in
#eval run "(if true then missing else fun (x) => x)(1)"

/-- info: "runtime error" -/
#guard_msgs in
#eval run "(fun (x, y, z) => y)(missing, 2, 3)"

/-- info: "runtime error" -/
#guard_msgs in
#eval run "(fun (x, y, z) => x)(1, 2, missing)"
