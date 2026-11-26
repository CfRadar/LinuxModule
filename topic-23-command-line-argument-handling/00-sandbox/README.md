# Topic 23 Sandbox — Command-Line Argument Handling

Open sandbox for free experimentation. Nothing here is graded. Run `bash reset.sh` at any time to restore `files/`.

## Command Quick Reference

- `$0` — Name or path of the current script as invoked.
- `$1`, `$2`, ..., `${10}` — Positional parameters; braces are required for two or more digits (`${10}`).
- `$#` — Number of positional parameters currently set.
- `$@` — All positional parameters; `"$@"` expands each parameter as a separate quoted word.
- `$*` — All positional parameters; `"$*"` joins all parameters into a single string using the first character of `IFS`.
- `$?` — Exit status of the most recently executed foreground command.
- `$$` — Process ID (PID) of the current shell.
- `$!` — Process ID (PID) of the most recently started background job.
- `shift [n]` — Discard the first `n` positional parameters (default `1`) and shift the rest down.
- `getopts` — Bash builtin for parsing short single-letter options (`-a`, `-b val`) using `OPTIND` and `OPTARG`.
- `getopt` — External utility for parsing short and `--long` options (`getopt --test` exits `4` for util-linux enhanced).
- `--` — End-of-options marker; arguments after `--` are treated as positional operands even if they start with `-`.

## Things to Try

1. Run `bash files/basic_args.sh "alpha beta" "" gamma` and compare `"$@"` vs `"$*"` with `IFS='|'`.
2. Test `bash files/getopts_template.sh -v -o "out file.txt" pos1 "pos 2"`.
3. Test `bash files/long_opts_template.sh --verbose --output="my report.txt" -- -literal-dash`.
4. Check `getopt --test; echo $?` in your terminal to see whether enhanced `getopt` is installed.
5. Experiment with `shift 2` when `$#` is `1` to observe the non-zero exit status.
