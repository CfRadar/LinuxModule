# Topic 26 Sandbox — Regular Expressions & Pattern Matching

Open sandbox for free experimentation. Nothing here is graded.

## Command Quick Reference

- `*`, `?`, `[...]` — Shell pathname globbing wildcards (`*` matches any string, `?` matches one character, `[abc]` matches one character from a set).
- `shopt -s extglob` — Enable Bash extended globbing (`?(pat)`, `*(pat)`, `+(pat)`, `@(pat)`, `!(pat)`).
- `grep -E` — Search text using Extended Regular Expressions (`+`, `?`, `{m,n}`, `(...)`, `|`).
- `grep -o` — Print only the matched substring instead of the entire matching line.
- `grep -w` — Match whole words only (bounded by non-word characters).
- `sed -E` — Stream edit text using Extended Regular Expressions and `\1`..`\9` backreferences.
- `awk` — Process structured fields and records using `~`, `!~`, regex `FS`, and `match()`.
- `[[ $str =~ $re ]]` — Match a string against an unquoted ERE variable in pure Bash and inspect `${BASH_REMATCH[@]}`.

## Things to Try

1. Inside `files/glob_lab/`, compare `ls *.log`, `ls app?.log`, and `ls app[0-9].log`.
2. Enable `shopt -s extglob` and test `ls files/glob_lab/app+([0-9]).log` vs `ls files/glob_lab/app*([0-9]).log`.
3. Run `grep -E '([0-9]{1,3}\.){3}[0-9]{1,3}' files/torture_lines.txt` and notice why `999.999.1.1` also matches.
4. Compare `grep '\+' files/torture_lines.txt` (BRE) with `grep -E '\+' files/torture_lines.txt` (ERE).
5. Test `sed -E 's/^([a-z_]+)=.*/\1=REDACTED/' files/config_sample.ini` on `SECRET_KEY` lines.
6. In Bash, test `re='^v([0-9]+)\.([0-9]+)$'; [[ "v12.34" =~ $re ]] && printf '%s\n' "${BASH_REMATCH[@]}"`.
