# Topic 01 Sandbox — Terminal & Shell Fundamentals

Open sandbox for free experimentation. Nothing here is graded. Run `bash reset.sh` at any time to restore `files/`.

## Command Quick Reference

- `echo` — Print text arguments to standard output.
- `printf` — Format and print data reliably without `echo` flag quirks.
- `type` — Show whether a command name is a shell builtin, alias, function, or external file.
- `help` — Display built-in Bash help for shell builtins and keywords.
- `info` — Read GNU Info documentation pages when available.
- `uname` — Print operating system and kernel identification details.
- `compgen` — Generate Bash completion candidates programmatically (`-c`, `-b`, `-f`, `-v`).
- `history` — Display or inspect the current shell's command history list.
- `;` — Run commands sequentially regardless of previous exit status.
- `&&` — Run the right-hand command only if the left-hand command succeeded (exit 0).
- `||` — Run the right-hand command only if the left-hand command failed (exit non-0).
- `--` — Mark the end of command options so names starting with `-` are treated as filenames.

## Things to Try

1. Compare `type cd`, `type ls`, and `type if`.
2. Inspect `files/crlf_sample.cfg` with `cat -A` or `od -c` to see `\r\n` vs `\n`.
3. Try creating and listing a file named `-example.txt` inside `files/` using `--`.
4. Practice `help compgen` and run `compgen -b | head` inside `files/`.
5. Experiment with `false && echo one || echo two` vs `true || echo one && echo two`.
