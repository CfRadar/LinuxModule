# Topic 17 Sandbox — Operators & Expressions

Open sandbox for free experimentation. Nothing here is graded. Run `bash reset.sh` at any time to restore `files/`.

## Command Quick Reference

- `$(( expr ))` — Arithmetic expansion; evaluates integer expressions (`+`, `-`, `*`, `/`, `%`, `**`, `++`, `--`) and substitutes the numeric result.
- `(( expr ))` — Arithmetic evaluation command; exits `0` when the result is non-zero and exits `1` when the result is `0`.
- `[ expr ]` — POSIX `test` command; requires quoted variables and `-eq`, `-ne`, `-lt`, `-le`, `-gt`, `-ge` for integers, `=`, `!=`, `-z`, `-n` for strings.
- `[[ expr ]]` — Bash extended conditional expression; prevents word splitting/globbing on variables, supports `&&`, `||`, `!`, glob `==`, and regex `=~`.
- `-e` / `-f` / `-d` / `-s` — File test operators: exists (`-e`), regular file (`-f`), directory (`-d`), exists and non-empty (`-s`).
- `-r` / `-w` / `-x` — File permission tests: readable (`-r`), writable (`-w`), executable (`-x`).
- `-nt` / `-ot` — File timestamp comparison: `file1 -nt file2` (newer than), `file1 -ot file2` (older than).
- `=~` — Extended regular expression match inside `[[ ... ]]` (leave the right-hand pattern unquoted or in a variable).

## Things to Try

1. Compare `x=0; (( x++ )); echo "rc=$? x=$x"` with `x=0; (( ++x )); echo "rc=$? x=$x"` under `set -e` or `|| echo zero`.
2. Test `[ 10 -lt 2 ]` vs `[[ 10 < 2 ]]` vs `(( 10 < 2 ))` to see numeric vs lexicographical comparison.
3. Inspect `files/names.txt` and test `[[ "$line" =~ ^[A-Za-z]+-[0-9]{2}$ ]]` vs quoting the regex.
4. Compare `[ -s files/empty.log ]` and `[ -e files/empty.log ]`, and test `files/newer.txt -nt files/older.txt`.
5. Run `bash files/legacy_checks.sh` and rewrite its `[ ... -a ... ]` tests using `[[ ... && ... ]]`.
