# Topic 12 Sandbox — Compression and Archiving

Open sandbox for free experimentation. Nothing here is graded. Run `bash reset.sh` at any time to restore `files/`.

## Command Quick Reference

- `gzip` — Compress files into `.gz` format (use `-k` to keep original, `-c` for stdout, `-d` to decompress).
- `gunzip` — Decompress `.gz` files (equivalent to `gzip -d`).
- `bzip2` — Compress files into `.bz2` format using Burrows-Wheeler block sorting (`-k`, `-c`, `-d`).
- `bunzip2` — Decompress `.bz2` files (equivalent to `bzip2 -d`).
- `xz` — Compress files into `.xz` format with high compression ratio (`-k`, `-c`, `-d`).
- `unxz` — Decompress `.xz` files (equivalent to `xz -d`).
- `tar` — Create (`-c`), list (`-t`), or extract (`-x`) tape archives (`-f <file>`, `-C <dir>`, `-z` gzip, `-j` bzip2, `-J` xz).
- `zip` — Package and compress files into `.zip` archives (`-r` recursive, `-j` junk paths, `-x` exclude).
- `unzip` — List (`-l`), test (`-t`), or extract (`-d <dir>`) `.zip` archives.
- `7z` — Create (`a`), list (`l`), test (`t`), or extract (`x -o<dir>`) `.7z` and multi-format archives.
- `file` — Identify true file/compression format by inspecting magic bytes rather than extension.
- `sha256sum` — Compute or verify SHA-256 cryptographic digests for archive integrity checks.

## Things to Try

1. Compare compressed sizes of `files/telemetry.log` across `gzip -k`, `bzip2 -k`, and `xz -k`.
2. Archive `files/project/` using `tar -czf /tmp/proj.tar.gz -C files project` and inspect with `tar -tzf /tmp/proj.tar.gz`.
3. Practice extracting with `--strip-components=1` and `--exclude='*.yml'` into a temporary directory.
4. Test `tar -tf` on a compressed archive before extracting to inspect its internal paths.
5. Practice quoting filenames with spaces like `files/release notes.txt` when archiving.
