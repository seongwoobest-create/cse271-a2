# CSE271 Principles of Programming Languages — Assignment 2: Multi-Parameter Functions

## Overview

In this assignment, you will extend the AE-Func language from the lecture to support multi-parameter functions.

## Getting the Code and Running

### Clone

```bash
git clone https://github.com/plrg-unist/cse271-a2.git
cd cse271-a2
```

### Running the Tests

This assignment requires [Lake](https://lean-lang.org/install/). Run the provided test cases with:

```bash
lake test
```

### Running the Interpreter

Run the interpreter with:

```bash
lake exec ae-func
```

Enter an AE-Func expression, then send end-of-file (for example, Ctrl-D on macOS or Linux). The interpreter reads all input as one expression and prints the result. Running it is not required to complete the assignment, but trying diverse inputs is recommended to validate your implementation.

## What You Need to Read

Only these three files are required reading:

- `AeFunc/Lang.lean`: Defines expressions, values, and environments.
- `AeFunc/Interp.lean`: Contains the interpreter logic you will complete.
- `Tests.lean`: Contains the provided test cases.

The following files are provided but do not need to be read:

- `AeFunc/Parser.lean`: Parses AE-Func source text into expressions.
- `AeFunc/Run.lean`: Connects parsing and interpretation and formats results.
- `AeFunc.lean`: Imports the library modules.
- `Main.lean`: Reads standard input and prints the interpreter result.

## What You May Change

- You are expected to change `AeFunc/Interp.lean`, replacing each `sorry` with a proper implementation.
- You may modify the provided templates or introduce helper definitions, but you must preserve the signature of `interp`.
- `AeFunc/Interp.lean` is the only file you will submit.
- You may add your own test cases to `Tests.lean`, but you will not submit this file.

## Language

### Concrete Syntax

You may refer to this syntax when adding your own test cases or writing input for the interpreter.

```text
<expr> ::= <int> | <id> | "true" | "false"
         | <expr> "+" <expr> | <expr> "-" <expr> | <expr> "<=" <expr>
         | "if" <expr> "then" <expr> "else" <expr>
         | "fun" "(" <params> ")" "=>" <expr>
         | <expr> "(" <args> ")"
         | "(" <expr> ")"
<params> ::= "" | <id-list>
<id-list> ::= <id> | <id> "," <id-list>
<args> ::= "" | <expr-list>
<expr-list> ::= <expr> | <expr> "," <expr-list>
```

Parameter names must be distinct.

### Abstract Syntax

$$
\begin{aligned}
e ::= {}& n
  \mid e \mathbin{\texttt{+}} e
  \mid e \mathbin{\texttt{-}} e
  \mid e \mathbin{\texttt{<=}} e
  \mid b \\
  & \mid \texttt{if}\ e\ \texttt{then}\ e\ \texttt{else}\ e
  \mid x
  \mid \texttt{fun}\ (x,\ldots,x)\ \texttt{=>}\ e
  \mid e(e,\ldots,e)
\end{aligned}
$$

Here, $n$ is an integer, $b$ is a boolean, and $x$ is an identifier. The number of parameters or arguments may be zero.

### Semantics

$$
\langle \texttt{fun}\ (x_1,\ldots,x_k)\ \texttt{=>}\ e,\sigma\rangle
\in \mathit{Closure}
= \mathit{Id}^{*} \times \mathit{Expr} \times \mathit{Env}
$$

$$
v \in \mathit{Value}
= \mathbb{Z} \cup \mathit{Bool} \cup \mathit{Closure}
$$

The semantics for functions and applications are:

$$
\frac{}{
  \sigma \vdash \texttt{fun}\ (x_1,\ldots,x_k)\ \texttt{=>}\ e
  \Rightarrow
  \langle \texttt{fun}\ (x_1,\ldots,x_k)\ \texttt{=>}\ e,\sigma\rangle
}
$$

$$
\frac{
  \begin{gathered}
    \sigma \vdash e_0 \Rightarrow
      \langle \texttt{fun}\ (x_1,\ldots,x_k)\ \texttt{=>}\ e,\sigma'\rangle \\
    \sigma \vdash e_1 \Rightarrow v_1
      \quad \cdots \quad
    \sigma \vdash e_k \Rightarrow v_k \\
    \sigma'[x_1 \mapsto v_1,\ldots,x_k \mapsto v_k]
      \vdash e \Rightarrow v
  \end{gathered}
}{
  \sigma \vdash e_0(e_1,\ldots,e_k) \Rightarrow v
}
$$

## Understanding the Tests

Each test case records an expected result and checks it against the result of evaluating an expression. For example:

```lean
/-- info: "42" -/
#guard_msgs in
#eval run "(fun () => 42)()"
```

`run` parses AE-Func source, evaluates it in an empty environment, and returns the result as a string. It returns `"parsing failed"` or `"runtime error"` on failure. In this example, it returns `"42"`.

This test has three parts:

- `/-- info: "42" -/` specifies the expected message.
- `#guard_msgs in` checks that the following command produces exactly that message.
- `#eval run "(fun () => 42)()"` evaluates the program and reports the returned string.

If every test succeeds, `lake test` completes successfully. If a test fails, it displays error messages describing the discrepancy between the expected and actual messages. You are encouraged to add your own test cases to `Tests.lean`.

## Grading

### Grading Policy

- If your submitted code does not compile, you will receive a score of zero.
- Otherwise, your score is proportional to the number of test cases it passes. The grading test cases may differ from the provided ones.
- Late submission is prohibited.

### Academic Integrity

- Do not get help from other people for solving this assignment.
- Do not give your solution to other people.
- Do not upload your solution to any public repository.
- Any cheating results in an **F** grade.

### LLM Usage

- While you are allowed to use LLMs, you are encouraged not to rely on them.
- Try to tackle the assignment on your own, using LLMs, for example, to understand concepts, get hints, and check your work.
- The provided `AGENTS.md` and `CLAUDE.md` files instruct agents to act as educational assistants. You may launch an agent in the project directory and use it for this purpose.
