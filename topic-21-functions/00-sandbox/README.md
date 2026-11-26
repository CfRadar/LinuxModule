# Topic 21 Sandbox — Functions

Open sandbox for free experimentation. Nothing here is graded. Run `bash reset.sh` at any time to restore `files/`.

## Command Quick Reference

- `name() { ...; }` — Declare a Bash function (parentheses take no parameter list; arguments arrive in `$1`, `$2`, `$@`).
- `function name { ...; }` — Alternative Bash keyword syntax for declaring a function.
- `local var=val` — Restrict a variable's scope to the current function and its callees.
- `return N` — Exit a function with numeric status `0..255` (modulo 256); use `printf`/`echo` on stdout for data.
- `declare -n ref="$1"` — Create a nameref variable pointing to a variable name passed by the caller.
- `declare -F name` — Check whether `name` is defined as a shell function without matching external binaries.
- `source file` / `. file` — Execute a script in the current shell environment to load its functions and variables.
- `${BASH_SOURCE[0]}` — Path of the currently executing or sourced script file, useful for relative library loading.
- `unset -f name` — Remove a function definition from the current shell.

## Things to Try

1. Source `files/demo_lib.sh` twice and inspect `DEMO_LIB_LOADS` to see how an include guard works.
2. Run `bash files/scope_demo.sh` to observe dynamic scoping vs `local` isolation.
3. Inspect `files/demo_lib.sh` to see how `BASH_SOURCE[0]` resolves the library directory regardless of `PWD`.
4. Practice writing a recursive function that walks `files/tree_data` using `local` loop variables.
5. Test `declare -F demo_greet` after sourcing `files/demo_lib.sh`, then `unset -f demo_greet` and re-check.
