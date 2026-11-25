#!/usr/bin/env bash
# .engine/lib/reveal.sh - Split + XOR obfuscation for .engine/next.blob
set -u

_reveal_xor_hex() {
    local text="$1"
    local key="$2"
    local out="" i klen tlen c k c_ord k_ord x
    tlen="${#text}"
    klen="${#key}"
    for (( i=0; i<tlen; i++ )); do
        c="${text:i:1}"
        k="${key:$((i % klen)):1}"
        printf -v c_ord '%d' "'$c"
        printf -v k_ord '%d' "'$k"
        x=$(( c_ord ^ k_ord ))
        printf -v hex_byte '%02x' "$x"
        out+="$hex_byte"
    done
    echo "$out"
}

_reveal_unxor_hex() {
    local hex="$1"
    local key="$2"
    local out="" i hlen klen byte_hex c_ord k k_ord x ch
    hlen="${#hex}"
    klen="${#key}"
    for (( i=0; i<hlen; i+=2 )); do
        byte_hex="${hex:i:2}"
        k="${key:$(((i / 2) % klen)):1}"
        c_ord=$(( 16#$byte_hex ))
        printf -v k_ord '%d' "'$k"
        x=$(( c_ord ^ k_ord ))
        printf -v ch "\\$(printf '%03o' "$x")"
        out+="$ch"
    done
    echo "$out"
}

encode_next_code() {
    local current_id="$1"
    local next_code="$2"
    local out_file="$3"
    local key xor_hex p1 p2 p3
    key="$(sha256_str "linuxcourse-blob-v1:${current_id}")"
    xor_hex="$(_reveal_xor_hex "$next_code" "$key")"
    local len="${#xor_hex}"
    local third=$(( len / 3 ))
    p1="${xor_hex:0:third}"
    p2="${xor_hex:third:third}"
    p3="${xor_hex:$((third * 2))}"
    {
        echo "# blob-v1"
        echo "A=$p1"
        echo "B=$p2"
        echo "C=$p3"
    } > "$out_file"
}

decode_next_code() {
    local current_id="$1"
    local blob_file="$2"
    [[ -f "$blob_file" ]] || return 1
    local a="" b="" c="" line
    while IFS= read -r line || [[ -n "$line" ]]; do
        line="${line%$'\r'}"
        case "$line" in
            A=*) a="${line#A=}" ;;
            B=*) b="${line#B=}" ;;
            C=*) c="${line#C=}" ;;
        esac
    done < "$blob_file"
    [[ -n "$a" && -n "$b" && -n "$c" ]] || return 1
    local key
    key="$(sha256_str "linuxcourse-blob-v1:${current_id}")"
    _reveal_unxor_hex "${a}${b}${c}" "$key"
}

reveal_next_code() {
    local module_dir="$1"
    local current_id="$2"
    local blob_file="$module_dir/.engine/next.blob"
    if [[ ! -f "$blob_file" ]]; then
        echo ""
        echo "No next-module unlock code (end of chain)."
        return 0
    fi
    local next_code
    next_code="$(decode_next_code "$current_id" "$blob_file")" || {
        echo "ERROR: Could not read next unlock code." >&2
        return 1
    }
    echo ""
    echo "+--------------------------------------------------+"
    echo "|              NEXT MODULE UNLOCK CODE             |"
    echo "+--------------------------------------------------+"
    printf "|  %-46s  |\n" "$next_code"
    echo "+--------------------------------------------------+"
    echo ""
}
