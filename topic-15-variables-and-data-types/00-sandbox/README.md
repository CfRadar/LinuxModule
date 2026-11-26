# Topic 15 Sandbox — Variables & Data Types

Open sandbox for free experimentation. Nothing here is graded. Run `bash reset.sh` at any time to restore `files/`.

## Command Quick Reference

- `declare` — Declare variables and set attributes (`-i` integer, `-a` indexed array, `-A` associative array, `-r` readonly, `-x` export, `-p` print).
- `local` — Restrict a variable's visibility to the enclosing function and its callees (dynamic scoping).
- `readonly` — Mark variables or functions as immutable; subsequent assignment fails.
- `export` — Mark variables for inheritance by child processes in the environment.
- `unset` — Remove a variable or array element (`unset 'map[key]'` for associative keys).
- `typeset` — Legacy synonym for `declare` in Bash.
- `$?` — Exit status of the most recently executed foreground pipeline.
- `$$` — Process ID of the current shell (unchanged inside `(...)` subshells).
- `$BASHPID` — Process ID of the current Bash process (changes inside `(...)` subshells).
- `$!` — Process ID of the most recently started background job.
- `$#` — Number of positional parameters passed to the script or function.
- `$@` / `$*` — Positional parameters; `"$@"` preserves each argument separately, `"$*"` joins them with the first char of `IFS`.
- `$_` — Last argument of the previous command executed in the current shell.

## Things to Try

1. Compare `x = 1` vs `x=1` and `${var}_tail` vs `$var_tail`.
2. Run `bash files/scope_puzzle.sh` and trace why `inner` sees `outer`'s `local` variable.
3. Run `bash files/octal_trap.sh` to see how `08` and `010` behave with and without `10#`.
4. Experiment with `declare -A map` vs forgetting `declare -A` in `files/assoc_demo.sh`.
5. Test `echo "sub: $$ vs $BASHPID"` inside `( ... )` and compare with the parent shell.
