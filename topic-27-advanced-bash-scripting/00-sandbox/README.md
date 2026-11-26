# Topic 27 Sandbox — Advanced Bash Scripting

Open sandbox for free experimentation. Nothing here is graded. Run `bash reset.sh` at any time to restore `files/`.

## Command Quick Reference

- `<(cmd)` — Process substitution (read): exposes `cmd` stdout as a readable FIFO/FD path.
- `>(cmd)` — Process substitution (write): exposes `cmd` stdin as a writable FIFO/FD path.
- `set -euo pipefail` — Strict mode: exit on error (`-e`), error on unset vars (`-u`), propagate pipeline failures (`-o pipefail`).
- `set -x` — Print expanded commands to stderr (or `BASH_XTRACEFD`) before executing them.
- `shopt` — Toggle Bash-specific shell options (`nullglob`, `failglob`, `dotglob`, `globstar`, `extglob`, `nocaseglob`, `lastpipe`).
- `mkfifo` — Create a named pipe (FIFO) special file for inter-process streaming.
- `exec 3<>file` — Open a file or FIFO on file descriptor 3 for both reading and writing.
- `exec {fd}>file` — Dynamically allocate an unused file descriptor (`>= 10`) into `$fd`.
- `BASH_SUBSHELL` — Integer tracking current subshell nesting depth (`0` in the top-level shell).
- `tee >(p1) >(p2)` — Fan a single stream out to multiple parallel consumer processes.

## Things to Try

1. Compare `files/node_a.log` and `files/node_b.log` without temp files using `diff <(sort files/node_a.log) <(sort files/node_b.log)`.
2. Test `while IFS= read -r line; do ...; done < <(cat files/sample.tsv)` and verify variables survive after the loop.
3. Experiment with `shopt -s globstar dotglob` inside `files/tree/` using `printf '%s\n' **/*.conf`.
4. Create a temporary FIFO with `mkfifo`, open it with `exec 3<>`, write a line, and read it back with `read -r -u 3`.
5. Run `bash -c 'set -euo pipefail; true | false | true'` vs `PIPESTATUS` inspection.
