# Topic 06 Sandbox — File Searching and Finding

Open sandbox for free experimentation. Nothing here is graded. Run `bash reset.sh` at any time to restore `files/`.

## Command Quick Reference

- `find` — Walk directory trees recursively and match entries by name, type, depth, size, or timestamp (`-name`, `-iname`, `-type`, `-maxdepth`, `-mindepth`, `-size`, `-mtime`, `-newer`, `-empty`, `-prune`, `-print0`).
- `locate` — Query a prebuilt filename database for fast path lookups (`-d`, `-b`, `-i`, `-c`, `-e`, `-r`, `--regex`) on Linux.
- `updatedb` — Build or refresh a filename database (`-U`, `-o`, `-l`) for `locate` on Linux.
- `which` — Print the path of external executables resolved along `$PATH` (`-a` lists all matches).
- `whereis` — Search standard system binary, manual, and source directories (ignores custom `$PATH` entries) on Linux.
- `type` — Identify how Bash resolves a command name (alias, keyword, function, builtin, or external file; `-t`, `-a`, `-P`).
- `grep` — Search file contents for literal strings or regular expressions (`-r`, `-i`, `-n`, `-l`, `-v`, `-c`, `-F`, `-E`, `-w`, `-x`, `-I`, `--exclude-dir`).
- `xargs` — Build and run commands from standard input (`-0`, `-I{}`, `-n`, `-P`, `-r`).

## Things to Try

1. Compare `find files -name "*.log"` vs `find files -iname "*.log"` and observe how `files/.hidden/env.conf` appears.
2. Practice pruning `files/cache` while finding empty files in `files/` without descending into `files/cache`.
3. Run `grep -rnI "ERROR" files/` vs `grep -rn "ERROR" files/` to see how `files/assets/blob.bin` behaves.
4. Test `find files -type f -name "*.txt" -print0 | xargs -0 wc -l` on filenames containing spaces.
5. Compare `type -a echo`, `type -P echo`, and `which -a echo`.
