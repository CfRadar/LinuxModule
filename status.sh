#!/usr/bin/env bash
# status.sh - Displays per-topic unlock/pass progress map from the ledger and workspace state.
set -u

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
export COURSE_ROOT_OVERRIDE="$ROOT_DIR"

# shellcheck source=.engine/lib/common.sh
source "$ROOT_DIR/.engine/lib/common.sh"
# shellcheck source=.engine/lib/ledger.sh
source "$ROOT_DIR/.engine/lib/ledger.sh"

if [[ -f "$ROOT_DIR/.student" ]]; then
    read_student_file || exit 1
else
    STUDENT_ID="(not initialized)"
fi

echo "=== Course Progress Map (Student: $STUDENT_ID) ==="
echo "Legend: [P]=Passed  [U]=Unlocked  [.]=Locked"
echo ""

unit_status() {
    local dir="$1"
    local id="$2"
    if ledger_has_event "PASS" "$id"; then
        echo "P"
    elif [[ -f "$dir/verify.sh" ]] || ledger_has_event "UNLOCK" "$id"; then
        echo "U"
    else
        echo "."
    fi
}

shopt -s nullglob
topic_dirs=("$ROOT_DIR"/topic-[0-9][0-9]-*)
shopt -u nullglob

if [[ "${#topic_dirs[@]}" -eq 0 ]]; then
    echo "No topics found in repository."
else
    for tdir in "${topic_dirs[@]}"; do
        tbase="$(basename "$tdir")"
        tnum="${tbase#topic-}"
        tnum="${tnum%%-*}"
        line=""
        for m in 01 02 03 04 05 06 07 08; do
            mdir="$tdir/${m}-module"
            st="$(unit_status "$mdir" "T${tnum}-M${m}")"
            line+="${m}:[${st}] "
        done
        t_st="$(unit_status "$tdir/09-test" "T${tnum}-TEST")"
        printf "Topic %-2s | %s| Test:[%s]\n" "$tnum" "$line" "$t_st"
    done
fi

if [[ -d "$ROOT_DIR/final-exam" ]]; then
    fe_st="$(unit_status "$ROOT_DIR/final-exam" "FINAL-EXAM")"
    echo ""
    echo "Final Exam: [$fe_st]"
fi

echo ""
if ledger_verify >/dev/null 2>&1; then
    echo "Ledger integrity: OK"
else
    echo "Ledger integrity: TAMPERED OR INVALID"
fi
