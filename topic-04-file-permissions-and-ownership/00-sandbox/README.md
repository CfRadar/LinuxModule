# Topic 04 Sandbox — File Permissions and Ownership

Open sandbox for free experimentation in a Linux/WSL2 environment. Nothing here is graded. Run `bash reset.sh` at any time to restore `files/`.

## Command Quick Reference

- `chmod` — Modify file or directory permission bits using symbolic (`u+x`, `go-w`, `a=rX`) or octal (`0750`, `2770`) modes.
- `chown` — Change user and/or group ownership (`chown user:group`, `chown :group`, `-h` for symlinks; changing user owner requires root).
- `chgrp` — Change group ownership of files or directories to a group the current user belongs to (`-R` recursive, `-h` symlinks).
- `umask` — Display or set the file mode creation mask subtracted bitwise from `0666` (files) and `0777` (directories); `-S` shows symbolic form.
- `stat` — Inspect exact numeric (`-c '%04a'`), symbolic (`-c '%A'`), and ownership (`-c '%U:%G'`) metadata.
- `id` — Print current user UID, primary GID, and supplementary group memberships (`id -un`, `id -gn`, `id -Gn`).
- `ls -ld` — Inspect permissions and ownership of a directory itself rather than its contents.

## Things to Try

1. Compare `stat -c '%04a %A %U:%G' files/deploy.sh` with `ls -l files/deploy.sh`.
2. Experiment with `chmod u+x`, `chmod go-w`, and `chmod 0640` on `files/app.conf.tmpl`.
3. Run `(umask 0027; mkdir files/test_dir && touch files/test_dir/note.txt)` and compare the created modes with `(umask 0077; ...)`.
4. Contrast `chmod -R u=rwX,g=rX,o= files/mixed_tree` (capital `X`) with lowercase `x` on a copy of `files/mixed_tree`.
5. Run `id -Gn` to list your supplementary groups and test `chgrp` on a file inside `files/`.
6. Experiment with SGID (`chmod 2770`) and sticky bit (`chmod 1777` or `3770`) on a new directory inside `files/`, and test `4644` vs `4755` (`S` vs `s`).
