# Topic 19 Sandbox — Conditional Statements

Open sandbox for free experimentation. Nothing here is graded. Run `bash reset.sh` at any time to restore `files/`.

## Command Quick Reference

- `if ...; then ...; fi` — Execute commands conditionally when the test command exits `0`.
- `elif` — Chain an additional conditional branch when the preceding `if`/`elif` exited non-zero.
- `else` — Execute a fallback branch when all preceding `if`/`elif` conditions exited non-zero.
- `test` — Evaluate file, string, or integer expressions and return exit status `0` (true) or `1` (false).
- `[ ... ]` — POSIX synonym for `test`; requires spaces around `[` and `]` and quoting around variables.
- `[[ ... ]]` — Bash extended conditional expression; prevents word splitting, supports `&&`, `||`, glob `==`, and regex `=~`.
- `case ... in ... esac` — Match a word against one or more glob patterns and run the matching branch.
- `;;` — Terminate a `case` branch and exit the `case` statement.
- `;&` — Fall through unconditionally to the body of the next `case` branch.
- `;;&` — Continue testing subsequent `case` patterns after running the matched branch.

## Things to Try

1. Compare `[ -n "$var" ]` with `[ -n $var ]` when `var=""` or `var="two words"`.
2. Experiment with `[[ $name == *.log ]]` vs `[[ $name == "*.log" ]]` inside `files/`.
3. Test `case` pattern ordering with `files/routes.txt` (for example `*.tar.gz` before `*.gz`).
4. Practice numeric comparisons (`-eq`, `-ne`, `-lt`, `-le`, `-gt`, `-ge`) vs string comparisons (`=`, `!=`) on `"10"` and `"2"`.
5. Run `bash files/sample_check.sh` and inspect how `;;`, `;&`, and `;;&` behave on different inputs.
