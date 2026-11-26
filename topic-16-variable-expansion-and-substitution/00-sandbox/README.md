# Topic 16 Sandbox — Variable Expansion and Substitution

Open sandbox for free experimentation. Nothing here is graded. Run `bash reset.sh` at any time to restore `files/`.

## Command Quick Reference

- `'...'` — Single quotes preserve every character literally, including `$` and `\`.
- `"..."` — Double quotes preserve spaces and globs while allowing `$var`, `$(cmd)`, and `$((...))`.
- `$'...'` — ANSI-C quoting interprets backslash escapes like `\n`, `\t`, and `\'`.
- `${var:-default}` — Use `default` if `var` is unset or empty (`""`).
- `${var-default}` — Use `default` only if `var` is unset (empty `""` stays empty).
- `${var:=default}` — Assign `default` to `var` if `var` is unset or empty, then expand.
- `${var:?msg}` — Print `msg` to stderr and exit non-zero if `var` is unset or empty.
- `${var:+alt}` — Expand to `alt` only if `var` is set and non-empty; otherwise empty.
- `${#var}` — Expand to the character length of `var`.
- `${var#pat}` / `${var##pat}` — Strip shortest / longest leading match of `pat`.
- `${var%pat}` / `${var%%pat}` — Strip shortest / longest trailing match of `pat`.
- `${var/pat/rep}` / `${var//pat/rep}` — Replace first / all matches of `pat` with `rep`.
- `${!ref}` — Indirect expansion: expand the variable whose name is stored in `ref`.
- `${var^^}` / `${var,,}` — Convert `var` to uppercase / lowercase (Bash 4+).
- `$(cmd)` — Command substitution: capture stdout of `cmd` (trailing newlines stripped).
- `$((expr))` — Arithmetic expansion: evaluate integer expression (`10#08` forces base 10).
- `{a..z}` / `{01..10..2}` — Brace expansion: generate sequences and comma lists before variable expansion.
- `~` — Tilde expansion: unquoted `~` at word start expands to `$HOME`; quoted `"~"` stays literal.

## Things to Try

1. Compare `x=""; echo "${x:-fallback}"` with `echo "${x-fallback}"`.
2. Test `p="/var/log/app.tar.gz"` with `${p##*/}`, `${p%/*}`, `${p%.*}`, and `${p%%.*}`.
3. Inspect `files/messy_paths.txt` and practice extracting basenames and extensions without `sed` or `basename`.
4. Compare `echo ~` vs `echo "~"` and test `${p/#\~/$HOME}` on a quoted `~/data` string.
5. Run `echo {01..05}` vs `n=5; echo {01..$n}` to observe why brace expansion runs before variable expansion.
