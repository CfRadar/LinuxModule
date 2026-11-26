# Topic 20 Sandbox — Loops & Iteration

Open sandbox for free experimentation. Nothing here is graded.

## Command Quick Reference

- `for` — Iterate over a list of words, array elements, glob matches, or a C-style `((init; cond; step))` counter.
- `while` — Repeat a block as long as the test command or condition exits `0`.
- `until` — Repeat a block until the test command or condition exits `0` (opposite polarity of `while`).
- `break` — Exit the current loop immediately, or `break N` to exit `N` enclosing loops.
- `continue` — Skip the rest of the current iteration and jump to the next one, or `continue N` for `N` levels out.
- `select` — Display a numbered interactive menu on stderr, read a choice into `REPLY`, and loop until `break` or EOF.
- `IFS= read -r` — Read a line verbatim without word-trimming or backslash interpretation.
- `shopt -s nullglob` — Expand non-matching globs to nothing instead of a literal `*` string.
- `find ... -print0` — Emit NUL-delimited paths safe for spaces and special characters, paired with `while IFS= read -r -d ''`.

## Things to Try

1. Compare `for x in $(cat files/items.txt)` vs `while IFS= read -r x; do ...; done < files/items.txt` on `files/items.txt`.
2. Test `for f in files/nonexistent/*.log` with and without `shopt -s nullglob`.
3. Walk `files/tree/` safely using `while IFS= read -r -d '' f; do printf '%s\n' "$f"; done < <(find files/tree -type f -print0)`.
4. Practice `break 2` and `continue 2` on nested `for` loops over `files/matrix.csv`.
5. Test a `select` menu with `PS3="Pick> "` and invalid input handling via `REPLY`.
