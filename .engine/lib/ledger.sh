#!/usr/bin/env bash
# .engine/lib/ledger.sh - Append-only hash-chained progress ledger (.progress/ledger.log)
set -u

_ledger_dir() {
    local root_dir
    root_dir="${COURSE_ROOT_OVERRIDE:-$(course_repo_root)}"
    echo "$root_dir/.progress"
}

_ledger_file() {
    echo "$(_ledger_dir)/ledger.log"
}

ledger_append() {
    local event="$1"
    local mod_id="$2"
    local detail="${3:-ok}"
    local ldir lfile epoch prev_hash payload new_hash

    # Sanitize delimiters in detail
    detail="${detail//|/;}"
    detail="${detail//$'\n'/ }"
    detail="${detail//$'\r'/}"

    ldir="$(_ledger_dir)"
    lfile="$(_ledger_file)"
    mkdir -p "$ldir"

    epoch="$(date +%s)"
    prev_hash="GENESIS"
    if [[ -s "$lfile" ]]; then
        prev_hash="$(tail -n 1 "$lfile" | awk -F'|' '{print $5}')"
        [[ -z "$prev_hash" ]] && prev_hash="GENESIS"
    fi

    payload="${prev_hash}|${epoch}|${event}|${mod_id}|${detail}"
    new_hash="$(sha256_str "$payload")" || return 1
    printf '%s|%s|%s|%s|%s\n' "$epoch" "$event" "$mod_id" "$detail" "$new_hash" >> "$lfile"
}

ledger_verify() {
    local lfile
    lfile="$(_ledger_file)"
    if [[ ! -f "$lfile" ]]; then
        return 0
    fi
    local line_no=0 prev_hash="GENESIS" epoch event mod_id detail chainhash expected payload
    while IFS='|' read -r epoch event mod_id detail chainhash || [[ -n "${epoch:-}" ]]; do
        line_no=$((line_no + 1))
        chainhash="${chainhash%$'\r'}"
        payload="${prev_hash}|${epoch}|${event}|${mod_id}|${detail}"
        expected="$(sha256_str "$payload")" || return 1
        if [[ "$chainhash" != "$expected" ]]; then
            echo "LEDGER_TAMPER line=$line_no" >&2
            return 1
        fi
        prev_hash="$chainhash"
    done < "$lfile"
    return 0
}

ledger_has_event() {
    local target_event="$1"
    local target_id="$2"
    local lfile
    lfile="$(_ledger_file)"
    [[ -f "$lfile" ]] || return 1
    awk -F'|' -v ev="$target_event" -v id="$target_id" '$2 == ev && $3 == id { found=1 } END { exit(found ? 0 : 1) }' "$lfile"
}

ledger_first_epoch() {
    local target_event="$1"
    local target_id="$2"
    local lfile
    lfile="$(_ledger_file)"
    [[ -f "$lfile" ]] || return 1
    awk -F'|' -v ev="$target_event" -v id="$target_id" '$2 == ev && $3 == id { print $1; exit 0 }' "$lfile"
}
