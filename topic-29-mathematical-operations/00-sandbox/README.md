# Topic 29 Sandbox — Mathematical Operations

Open sandbox for free experimentation. Nothing here is graded. Run `bash reset.sh` at any time to restore `files/`.

## Command Quick Reference

- `$(( expr ))` — Bash integer arithmetic expansion supporting `+`, `-`, `*`, `/`, `%`, `**`, bitwise ops, and base prefixes (`0x`, `10#`).
- `10#val` — Force base-10 interpretation in `$(( ))` so leading-zero strings like `08` or `09` are not treated as invalid octal.
- `let "expr"` — Bash builtin for evaluating integer expressions; exits `1` when the final expression evaluates to `0`.
- `expr` — POSIX external integer/string evaluator; requires spaces around operators, escaped `\*`, and exits `1` when the result is `0`.
- `printf` — Format integers (`%d`, `%02d`, `%x`) and floating-point values (`%.2f`, `%.4f`) reliably.
- `LC_ALL=C awk` — Portable floating-point arithmetic (`+`, `-`, `*`, `/`, `sqrt()`, `sprintf`) independent of locale decimal separators.
- `bc` — Arbitrary-precision calculator (Linux); defaults to `scale=0` (integer division) unless `scale=N` or `-l` is specified.
- `bc -l` — Load the standard math library (`s()`, `c()`, `a()`, `l()`, `e()`) with default `scale=20`.

## Things to Try

1. Test `echo $((08 + 1))` vs `echo $((10#08 + 1))` in Bash.
2. Run `expr 5 - 5; echo $?` and `let "x = 5 - 5"; echo $?` to observe zero-result exit codes.
3. Inspect `files/hex_registers.txt` and convert hex values with `printf '%d\n' 0x1a`.
4. Compute the mean of `files/telemetry.csv` using `LC_ALL=C awk -F',' 'NR>1 {s+=$2; n++} END {printf "%.4f\n", s/n}' files/telemetry.csv`.
5. Practice integer-cent math on `files/invoices.tsv` using pure Bash `/` and `%` formatting.
