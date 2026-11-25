#!/usr/bin/env bash
# export-progress.sh - Generates a tamper-evident progress report for the instructor.
set -u

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
export COURSE_ROOT_OVERRIDE="$ROOT_DIR"

# shellcheck source=.engine/lib/common.sh
source "$ROOT_DIR/.engine/lib/common.sh"
# shellcheck source=.engine/lib/ledger.sh
source "$ROOT_DIR/.engine/lib/ledger.sh"

read_student_file || exit 1

OUT_FILE=""
while [[ $# -gt 0 ]]; do
    case "$1" in
        --out) OUT_FILE="${2:-}"; shift 2 ;;
        *)     shift ;;
    esac
done

SAFE_ID="$(printf '%s' "$STUDENT_ID" | tr -cd 'A-Za-z0-9._-')"
[[ -z "$OUT_FILE" ]] && OUT_FILE="$ROOT_DIR/progress-report-${SAFE_ID}.txt"

LEDGER_FILE="$ROOT_DIR/.progress/ledger.log"
TIMES_FILE="$ROOT_DIR/.engine/module-times.tsv"

LEDGER_STATUS="VALID"
if ! ledger_verify >/dev/null 2>&1; then
    LEDGER_STATUS="TAMPERED"
fi

get_min_plausible_min() {
    local mod_id="$1"
    if [[ -f "$TIMES_FILE" ]]; then
        local val
        val="$(awk -F'\t' -v id="$mod_id" '$1 == id { print $2; exit }' "$TIMES_FILE")"
        if [[ -n "$val" && "$val" =~ ^[0-9]+$ ]]; then
            echo "$val"
            return 0
        fi
    fi
    echo "5"
}

tmp_body="$(mktemp)"
{
    echo "=== LINUX COURSE PROGRESS REPORT ==="
    echo "GeneratedAtUTC: $(date -u +%Y-%m-%dT%H:%M:%SZ)"
    echo "StudentID: $STUDENT_ID"
    echo "StudentSeed: $STUDENT_SEED"
    echo "Environment: $(detect_shell_env)"
    echo "LedgerIntegrity: $LEDGER_STATUS"
    echo ""
    echo "--- Passed Modules & Timing Audit ---"
    if [[ -f "$LEDGER_FILE" ]]; then
        # Collect unique passed IDs in order
        passed_ids="$(awk -F'|' '$2 == "PASS" { if (!seen[$3]++) print $3 }' "$LEDGER_FILE")"
        if [[ -z "$passed_ids" ]]; then
            echo "  (none yet)"
        else
            while IFS= read -r mid; do
                [[ -z "$mid" ]] && continue
                u_epoch="$(ledger_first_epoch "UNLOCK" "$mid" || true)"
                p_epoch="$(ledger_first_epoch "PASS" "$mid" || true)"
                min_plaus="$(get_min_plausible_min "$mid")"
                flag="OK"
                gap_str="n/a"
                if [[ -n "$u_epoch" && -n "$p_epoch" && "$u_epoch" =~ ^[0-9]+$ && "$p_epoch" =~ ^[0-9]+$ ]]; then
                    gap_sec=$(( p_epoch - u_epoch ))
                    gap_min=$(( gap_sec / 60 ))
                    gap_str="${gap_sec}s (${gap_min}m)"
                    if [[ "$gap_sec" -lt $(( min_plaus * 60 )) ]]; then
                        flag="FLAG_FAST(<${min_plaus}m)"
                    fi
                else
                    flag="FLAG_NO_UNLOCK_RECORD"
                fi
                printf "  %-12s | gap=%-14s | %s\n" "$mid" "$gap_str" "$flag"
            done <<< "$passed_ids"
        fi
    else
        echo "  (no ledger found)"
    fi
    echo ""
    echo "--- Ledger Entries ---"
    if [[ -f "$LEDGER_FILE" ]]; then
        cat "$LEDGER_FILE"
    else
        echo "(empty)"
    fi
} > "$tmp_body"

BODY_SHA="$(sha256_file "$tmp_body")"
{
    cat "$tmp_body"
    echo ""
    echo "ReportBodySHA256: $BODY_SHA"
} > "$OUT_FILE"
rm -f "$tmp_body"

echo "Progress report written to: $OUT_FILE"
