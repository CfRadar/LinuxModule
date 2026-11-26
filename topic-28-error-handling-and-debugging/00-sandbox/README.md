# Topic 28 Sandbox — Error Handling and Debugging

Open sandbox for free experimentation. Nothing here is graded. Run `bash reset.sh` at any time to restore `files/`.

## Command Quick Reference

- `set -x` / `set +x` — Enable or disable shell execution tracing (xtrace).
- `PS4` — Prompt string printed before each traced command when `set -x` is active (supports `${BASH_SOURCE}`, `${LINENO}`, `${FUNCNAME[0]}`).
- `BASH_XTRACEFD` — File descriptor number where `set -x` writes trace output instead of stderr (`2`).
- `LINENO` — Built-in variable holding the current line number in the script or function.
- `BASH_LINENO` — Array of line numbers corresponding to each call frame in `FUNCNAME`.
- `FUNCNAME` — Array of active function names on the call stack (`FUNCNAME[0]` is the current function).
- `PIPESTATUS` — Array of exit statuses from each command in the most recently executed foreground pipeline.
- `trap '...' ERR` — Execute a handler whenever a simple command exits non-zero (combine with `set -E` / `set -o errtrace` to inherit into functions).
- `trap '...' EXIT` — Execute cleanup logic unconditionally when the shell exits.
- `bash -n` — Parse a script and check syntax without executing any commands.
- `shellcheck` — Static analysis tool for shell scripts (if installed in your environment).
- `logger` / `printf >&2` — Emit structured diagnostic or syslog-style messages to stderr or log files.

## Things to Try

1. Run `bash files/buggy_pipe.sh` and inspect `${PIPESTATUS[@]}` after a failing upstream stage.
2. Run `BASH_XTRACEFD=3 PS4='+ ${LINENO}:${FUNCNAME[0]:-main}: ' bash -x files/trace_demo.sh 3>trace.log` and compare stdout vs `trace.log`.
3. Run `bash files/trap_err.sh` with and without `set -E` to see how `ERR` traps behave inside functions.
4. Run `bash -n files/lint_target.sh` and inspect why syntax-valid scripts can still fail at runtime due to unquoted expansions or `local x=$(...)`.
