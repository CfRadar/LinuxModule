# Topic 14 Sandbox — Shell Scripting Fundamentals

Open sandbox for free experimentation. Nothing here is graded. Run `bash reset.sh` at any time to restore `files/`.

## Command Quick Reference

- `#!/usr/bin/env bash` — Portable shebang line that locates `bash` via `PATH`.
- `bash` — Execute a script file with the Bash interpreter (`bash script.sh`, or `bash -n script.sh` to syntax-check).
- `source` / `.` — Execute a script in the current shell process so variable and directory changes persist.
- `chmod +x` — Grant execute permission on a script file for direct `./script.sh` invocation on POSIX systems.
- `#` — Start a shell comment (ignored by the interpreter except `#!` on line 1).
- `exit` — Terminate a script and return an exit status code (`0` for success, `1`–`255` for failure).
- `[[ -t 0 ]]` — Test whether standard input (fd 0) is connected to an interactive terminal.
- `read` — Read a line from standard input (`read -r` preserves backslashes; `-t` sets a timeout).

## Things to Try

1. Compare running `bash files/env_demo.sh` vs `source files/env_demo.sh` and inspect `echo "$DEMO_VAR"`.
2. Inspect `files/broken_crlf.sh` with `tr -cd '\r' < files/broken_crlf.sh | wc -c` to see carriage return bytes.
3. Syntax-check `files/starter_basic.sh` with `bash -n files/starter_basic.sh`.
4. Test `files/starter_dual.sh` both interactively (`bash files/starter_dual.sh`) and piped (`printf 'alpha\nbeta\n' | bash files/starter_dual.sh`).
5. Copy `files/starter_basic.sh`, add a `#` comment after a trailing `\` line continuation, and observe what `bash -n` reports.
