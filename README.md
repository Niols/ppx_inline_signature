# `ppx_inline_signature`

This OCaml PPX allows to write value signatures in an OCaml implementation file.
In short, it rewrites:

``` ocaml
val foo : int -> string
let foo x = ">>> " ^ string_of_int x ^ " <<<"
```

into:

``` ocaml
let foo : int -> string = fun x ->
  ">>> " ^ string_of_int x ^ " <<<"
```

It also supports recursive functions:

``` ocaml
val foo : int -> string
val bar : string -> int

let rec foo x = ">>> " ^ string_of_int (x + bar "12") ^ " <<<"
and bar y = int_of_string (foo 13 ^ y)
```

gets rewritten into:

``` ocaml
let rec foo : int -> string = fun x ->
  ">>> " ^ string_of_int (x + bar "12") ^ " <<<"

and bar : string -> int = fun y ->
  int_of_string (foo 13 ^ y)
```

(Don't try to run this code, though, please.) That's all there is to it, really.
It allows to declare value types easily without cluttering the function
definition. It is obviously inspired by Haskell's syntax.
