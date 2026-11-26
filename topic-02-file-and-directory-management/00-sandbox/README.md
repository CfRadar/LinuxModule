# Topic 02 Sandbox — File & Directory Management

Open sandbox for free experimentation. Nothing here is graded. Run `bash reset.sh` at any time to restore `files/`.

## Command Quick Reference

- `pwd` — Print the current working directory (`-P` resolves symlinks to the physical path).
- `ls` — List directory contents (`-a`/`-A` show hidden dotfiles, `-l` long format, `-d` directory itself).
- `cd` — Change the shell's current working directory using relative or absolute paths.
- `mkdir` — Create directories (`-p` creates missing parent directories without failing if present).
- `rmdir` — Remove empty directories only (`-p` removes empty parent chains bottom-up).
- `touch` — Create empty files or update file access and modification timestamps (`-t`, `-d`, `-r`).
- `cp` — Copy files and directories (`-r`/`-a` recursive/archive, `-p` preserve metadata, `-n` no clobber).
- `mv` — Move or rename files and directories (`-n` prevents overwriting an existing destination).
- `rm` — Remove files or directories (`-r` recursive, `-f` force/ignore missing, `--` ends options).
- `tree` — Display directory hierarchies recursively in a tree format (`-a`, `-L`, `-d`, `-P`).
- `file` — Determine true file type by inspecting magic bytes rather than filename extensions (`-b`, `--mime-type`).
- `stat` — Display detailed file and filesystem metadata (`-c` custom format string such as `%s`, `%F`, `%Y`).

## Things to Try

1. Compare `ls files/`, `ls -A files/`, and `ls -la files/` to spot hidden dotfiles inside `files/`.
2. Run `file -b --mime-type files/*` and compare the true magic types against the file extensions.
3. Inspect size, type, and epoch timestamp with `stat -c '%n | %s | %F | %Y' files/*`.
4. Practice `mkdir -p`, `touch`, and `rmdir -p` on temporary subdirectories with spaces in their names inside `files/`.
5. Test `cp -n` vs `cp -p` and practice handling filenames starting with `-` using `--`.
