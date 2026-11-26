# Topic 18 Sandbox — Input & Output in Shell Scripts

Open sandbox for free experimentation. Nothing here is graded. Run `bash reset.sh` at any time to restore `files/`.

## Command Quick Reference

- `read -r` — Read a line from standard input without interpreting backslashes (`\`) as escape characters.
- `IFS= read -r` — Preserve leading and trailing whitespace when reading a full line.
- `read -p` — Display a prompt string before reading (use `>&2` or `printf ... >&2` when stdout carries data).
- `read -s` — Silent mode for reading sensitive input without echoing characters to the terminal.
- `read -t` — Time out and return non-zero (`>128`) if no input arrives within the specified seconds.
- `read -n` — Read at most `N` characters instead of waiting for a newline.
- `read -a` — Split the input line on `IFS` and store fields into an indexed array.
- `read -d` — Read until a custom delimiter character (use `-d ''` for NUL-delimited streams).
- `echo` — Print arguments separated by spaces (watch out for `-n`, `-e`, and backslash quirks).
- `printf` — Format and print data reliably using a format string (`printf '%s\n' "$var"`).
- `printf -v` — Assign formatted output directly into a shell variable without a subshell.
- `<<EOF` / `<<'EOF'` / `<<-EOF` — Here documents for multi-line stdin (unquoted expands, quoted is literal, `<<-` strips leading tabs).
- `<<<` — Here string for feeding a single string (plus trailing newline) as stdin without a pipeline subshell.
- `1>` / `2>` / `>&2` — Redirect stdout, redirect stderr, or route prompts/diagnostics to stderr.

## Things to Try

1. Compare `while read line` vs `while IFS= read -r line || [[ -n "$line" ]]` on `files/backslashes.txt` and `files/no_trailing_nl.txt`.
2. Split `files/records.csv` using `IFS=':' read -ra cols` and observe how consecutive colons (`::`) behave vs consecutive spaces.
3. Compare `printf "$msg\n"` vs `printf '%s\n' "$msg"` when `msg='100%s\ncheck'`.
4. Run `bash files/prompt_demo.sh | cat` and observe which lines go to stdout vs stderr.
5. Feed a string into `read -r a b <<< "alpha beta"` and compare with `echo "alpha beta" | read -r a b`.
