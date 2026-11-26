# Topic 31 Sandbox — Practical Shell Scripting Projects

Open sandbox for free experimentation. Nothing here is graded. Run `bash reset.sh` at any time to restore `files/`.

## Command Quick Reference

- `awk` — Pattern scanning and text processing language, also reliable for floating-point arithmetic.
- `du` — Estimate file and directory disk space usage (`-sk` for KiB totals).
- `mv` — Move or rename files and directories (`-n` prevents overwriting existing targets).
- `tar` — Create, list (`-t`), and extract (`-x`) compressed or uncompressed archives.
- `sha256sum` — Compute and verify SHA-256 cryptographic checksums.
- `find` — Search directory trees by name, type, depth (`-maxdepth`), size, and age.
- `kill` — Send signals (such as `TERM` or `KILL`, or `0` to probe liveness) to processes.
- `curl` — Transfer data over HTTP/HTTPS with status code (`-w '%{http_code}'`) and timeout (`--max-time`) controls.
- `python3` — Run inline Python one-liners for local HTTP servers (`-m http.server`), JSON parsing, or SQLite tasks.
- `sqlite3` — Query and back up SQLite databases (`.backup`, `.dump`) from the command line.
- `git` — Initialize bare repositories (`git init --bare`), commit, and push backup branches.
- `mktemp` — Create unique temporary files or directories safely for atomic staging.

## Things to Try

1. Test floating-point division in `awk` (`awk 'BEGIN { printf "%.2f\n", 10 / 3 }'`).
2. Inspect `files/sample_access.log` and count HTTP 5xx responses with `awk`.
3. Create a bare Git repository in a temporary directory and push a branch to it.
4. Start a temporary `python3 -m http.server` in a subshell, query it with `curl -s -o /dev/null -w '%{http_code}\n'`, and stop the server.
5. Practice `find files -maxdepth 2 -type f -print0 | xargs -0 ls -ld`.
