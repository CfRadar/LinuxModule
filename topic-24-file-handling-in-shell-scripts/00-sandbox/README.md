# Topic 24 Sandbox — File Handling in Shell Scripts

Open sandbox for free experimentation. Nothing here is graded. Run `bash reset.sh` at any time to restore `files/`.

## Command Quick Reference

- `>` / `>>` — Redirect stdout to overwrite (`>`) or append (`>>`) to a file.
- `set -C` — Enable `noclobber` so `>` refuses to overwrite an existing file (`>|` overrides).
- `test` / `[[ ... ]]` — Check file existence (`-e`), regular file (`-f`), directory (`-d`), non-empty (`-s`), and permissions (`-r`, `-w`, `-x`).
- `shopt -s nullglob dotglob` — Make unmatched globs expand to nothing (`nullglob`) and include dotfiles (`dotglob`).
- `find ... -print0` — Emit NUL-delimited paths for safe iteration over names with spaces or special characters.
- `mktemp` / `mktemp -d` — Create unique temporary files or directories respecting `$TMPDIR`.
- `trap <cmd> EXIT` — Register a cleanup handler that runs automatically when a script exits.
- `exec 3<file` / `exec 4>file` — Open explicit file descriptors for reading (`<`) or writing (`>`).
- `read -r -u 3 line` — Read one line from file descriptor `3` without colliding with `stdin` (FD 0).
- `exec 3<&-` / `exec 4>&-` — Close explicit read or write file descriptors when finished.
- `mapfile` / `readarray` — Read lines from stdin or a file descriptor into a Bash array.

## Things to Try

1. Compare `wc -l files/sample.cfg` with a `while IFS= read -r line || [[ -n "$line" ]]` loop to see the effect of a missing trailing newline.
2. Test `set -C` in a subshell by redirecting into `files/notes.txt`, then try `>|` to force overwrite.
3. Compare `[[ -f files/empty.dat ]]` and `[[ -s files/empty.dat ]]` on the zero-byte file.
4. Practice `shopt -s nullglob dotglob` inside an empty directory vs `files/tree/`.
5. Open `files/stream_a.txt` on FD 3 and `files/stream_b.txt` on FD 4 and read one pair per iteration with `read -r -u 3` and `read -r -u 4`.
