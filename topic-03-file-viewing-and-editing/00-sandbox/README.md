# Topic 03 Sandbox — File Viewing and Editing

Open sandbox for free experimentation. Nothing here is graded. Run `bash reset.sh` at any time to restore `files/`.

## Command Quick Reference

- `cat` — Concatenate files and print their contents to standard output (`-n` numbers lines, `-A` reveals control chars and line endings).
- `tac` — Concatenate and print files in reverse line order (last line first).
- `less` — View files or command output one screen at a time with forward/backward navigation (`-F` quit if one screen, `-X` no termcap init, `-N` line numbers, `-S` chop long lines, `-R` pass ANSI colors).
- `more` — Basic forward-only file pager for stepping through text one screenful at a time.
- `head` — Output the first part of files (`-n N` lines, `-c N` bytes, `-q` suppress multi-file headers).
- `tail` — Output the last part of files (`-n N` last lines, `-n +K` starting from line K, `-c N` bytes, `-f` follow appended data).
- `nl` — Number lines of files (`-b a` all lines, `-b t` non-empty lines only, `-w` width, `-s` separator).
- `wc` — Count newlines (`-l`), words (`-w`), and bytes (`-c`) or characters (`-m`).
- `nano` — Friendly terminal text editor configured via `~/.nanorc` (`set tabsize`, `set unix`, `set trimblanks`).
- `vi` — Classic POSIX visual/line text editor with Normal, Insert, and Ex (`:`) modes.
- `vim` — Vi IMproved modal editor (`vim -Nu NONE -es` runs clean non-interactive Ex scripts).

## Things to Try

1. Compare `wc -l files/no_trailing_nl.txt` with `nl -b a files/no_trailing_nl.txt` to see how a missing final newline affects line counts.
2. Inspect `files/crlf_config.ini` using `cat -A` to spot `^M$` (`\r\n`) endings and `^I` tabs.
3. Slice lines 25 through 40 of `files/large_app.log` using `tail -n +25` piped into `head -n 16`.
4. Compare `cat -n files/numbered_nginx.conf` against `nl -b t files/numbered_nginx.conf` on blank lines.
5. Practice non-interactive viewing with `less -FX -N -S files/large_app.log` and test `tac files/no_trailing_nl.txt`.
6. Practice non-interactive Vim Ex inspection: `vim -Nu NONE -es -R files/numbered_nginx.conf -c '1,10p' -c 'q!'`.
