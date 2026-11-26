# Topic 07 Sandbox — Text Processing

Open sandbox for free experimentation. Nothing here is graded. Run `bash reset.sh` at any time to restore `files/`.

## Command Quick Reference

- `sort` — Sort lines of text files lexicographically, numerically (`-n`), by key (`-k`), or uniquely (`-u`).
- `uniq` — Filter or count (`-c`) adjacent matching lines in a sorted stream.
- `cut` — Extract specific byte ranges, character positions, or delimited fields (`-d`, `-f`) from each line.
- `paste` — Merge lines of files side by side using a delimiter (`-d`) or serialize a single file (`-s`).
- `tr` — Translate, squeeze (`-s`), or delete (`-d`) characters from standard input.
- `sed` — Perform non-interactive stream editing using addresses, BRE/ERE (`-E`) patterns, and substitutions.
- `awk` — Scan and process structured records using field splitting (`-F`), patterns, and associative arrays.
- `column` — Format delimited input into aligned table columns (`-t`, `-s`).
- `join` — Combine lines of two sorted files on a common key field.
- `comm` — Compare two sorted files line by line into unique-left, unique-right, and common columns.
- `diff` — Show line-by-line differences between text files, including unified patch format (`-u`).
- `cmp` — Compare two files byte by byte and report the first differing byte offset and line.

## Things to Try

1. Inspect `files/messy_sales.csv` with `tr -d '\r'` and pipe into `column -t -s ','`.
2. Compare `LC_ALL=C sort files/names.txt` vs `LC_ALL=en_US.UTF-8 sort files/names.txt` (if available) or numeric `sort -n` vs default `sort`.
3. Use `cut -f1,3 files/services_v1.tsv` and `join -t $'\t'` against `files/services_v2.tsv` after sorting.
4. Experiment with `diff -u files/services_v1.tsv files/services_v2.tsv` and `comm <(sort files/services_v1.tsv) <(sort files/services_v2.tsv)`.
5. Summarize totals by region in `files/messy_sales.csv` using `awk -F','`.
