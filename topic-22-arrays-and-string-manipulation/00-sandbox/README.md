# Topic 22 Sandbox — Arrays and String Manipulation

Open sandbox for free experimentation. Nothing here is graded. Run `bash reset.sh` at any time to restore `files/`.

## Command Quick Reference

- `arr=(a b c)` — Initialize an indexed array with literal elements.
- `declare -a arr` — Explicitly declare an indexed array.
- `declare -A map` — Declare an associative array (string-keyed hash map).
- `${#arr[@]}` — Expand to the number of populated elements in `arr`.
- `${arr[@]}` — Expand each element as a separate word when double-quoted (`"${arr[@]}"`).
- `${arr[*]}` — Expand all elements as a single word joined by the first character of `IFS` when double-quoted.
- `${!arr[@]}` — Expand to all populated indices (indexed) or keys (associative) of `arr`.
- `${arr[@]:off:len}` — Slice `len` elements from `arr` starting at `off` (use a space before negative `off`: `${arr[@]: -2}`).
- `${#str}` — Expand to the character length of string `str` (byte length under `LC_ALL=C`).
- `${str:off:len}` — Extract a substring of `len` characters starting at `off` (space required before negative `off`).
- `${str/pat/rep}` — Replace the first match of `pat` in `str` with `rep`.
- `${str//pat/rep}` — Replace all matches of `pat` in `str` with `rep`.
- `${str#pat}` / `${str##pat}` — Strip shortest / longest matching prefix `pat` from `str`.
- `${str%pat}` / `${str%%pat}` — Strip shortest / longest matching suffix `pat` from `str`.
- `${str^^}` / `${str,,}` — Convert all characters in `str` to uppercase / lowercase (`^` / `,` for first char only).
- `IFS=',' read -ra cols` — Split a line on `,` into indexed array `cols`.
- `mapfile -t -d ';'` — Read `;`-delimited records into an indexed array, stripping the delimiter.

## Things to Try

1. Compare `"${arr[@]}"` vs `"${arr[*]}"` with `IFS='|'` on an array whose elements contain spaces.
2. Load `files/inventory.csv` with `IFS=',' read -ra fields` and observe what happens to the trailing empty field on line 1.
3. Practice negative slicing `${str: -4}` vs `${str:-4}` on strings from `files/tags.txt`.
4. Read `files/kv_pairs.tsv` into a `declare -A` associative array and iterate over sorted keys with `LC_ALL=C sort`.
5. Test `${#s}` on `café` with default locale vs `LC_ALL=C`.
