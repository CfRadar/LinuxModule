# Topic 08 Sandbox — Input, Output and Redirection

Open sandbox for free experimentation. Nothing here is graded. Run `bash reset.sh` at any time to restore `files/`.

## Command Quick Reference

- `echo` — Print text arguments to standard output (watch out for `-n`, `-e` flags).
- `printf` — Format and print data reliably using a format string (`printf '%s\n' "$var"`).
- `tee` — Read stdin and write to both stdout and one or more files (`tee -a` appends).
- `>` — Redirect stdout to a file (overwriting/truncating existing content).
- `>>` — Redirect stdout to a file (appending to the end).
- `<` — Redirect a file into stdin.
- `2>` — Redirect stderr (FD 2) to a file.
- `2>&1` — Duplicate stderr onto wherever stdout currently points (order matters).
- `|` — Pipe stdout of the left command into stdin of the right command.
- `<<` — Here-document: feed multi-line input to stdin (`<<'EOF'` disables expansion; `<<-EOF` strips leading tabs).
- `<<<` — Here-string: feed a single string (plus a trailing newline) to stdin.
- `/dev/null` — Discard any output written to it.
- `exec` — Open, duplicate, or close file descriptors persistently in the current shell (`exec 3> file`, `exec 3>&-`).

## Things to Try

1. Run `bash files/probe_noisy.sh` and separate stdout from stderr using `1>` and `2>`.
2. Compare `bash files/probe_noisy.sh > out.log 2>&1` with `bash files/probe_noisy.sh 2>&1 > out.log`.
3. Experiment with `printf '%s\n' "-n"` vs `echo "-n"`.
4. Test `cat <<'EOF'` vs `cat <<EOF` using `$HOME` inside `files/`.
5. Try swapping stdout and stderr of `bash files/probe_noisy.sh` using `3>&1 1>&2 2>&3 3>&-`.
