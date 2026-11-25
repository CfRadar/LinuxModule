#!/usr/bin/env bash
# .engine/lib/verify-lib.sh - Shared verification, scoring, integrity check, and code reveal.
set -u

VERIFY_MODULE_DIR=""
VERIFY_MODULE_ID=""
VERIFY_MODE="module"      # module | test | exam
VERIFY_MIN_PCT=100
VERIFY_TOTAL_WEIGHT=0
VERIFY_EARNED_WEIGHT=0
VERIFY_TOTAL_COUNT=0
VERIFY_PASSED_COUNT=0
VERIFY_CRITICAL_FAILED=0
VERIFY_FAILED_TASKS=()
VERIFY_CURRENT_SECTION=""
VERIFY_SECTION_TOTAL=0
VERIFY_SECTION_EARNED=0
VERIFY_SECTION_RESULTS=()
VERIFY_INTEGRITY_OK=1

verify_init() {
    VERIFY_MODULE_DIR="$1"
    VERIFY_MODULE_ID="$2"
    VERIFY_MODE="${3:-module}"
    case "$VERIFY_MODE" in
        module) VERIFY_MIN_PCT=100 ;;
        test)   VERIFY_MIN_PCT=90 ;;
        exam)   VERIFY_MIN_PCT=85 ;;
        *)      VERIFY_MIN_PCT=100 ;;
    esac
    VERIFY_TOTAL_WEIGHT=0
    VERIFY_EARNED_WEIGHT=0
    VERIFY_TOTAL_COUNT=0
    VERIFY_PASSED_COUNT=0
    VERIFY_CRITICAL_FAILED=0
    VERIFY_FAILED_TASKS=()
    VERIFY_CURRENT_SECTION=""
    VERIFY_SECTION_TOTAL=0
    VERIFY_SECTION_EARNED=0
    VERIFY_SECTION_RESULTS=()
    VERIFY_INTEGRITY_OK=1

    read_student_file || exit 2

    echo "============================================================"
    echo " Verifying: $VERIFY_MODULE_ID  (Student: $STUDENT_ID)"
    echo "============================================================"
}

verify_self_integrity() {
    local module_dir="${1:-$VERIFY_MODULE_DIR}"
    local manifest="$module_dir/.engine/manifest.sha256"
    if [[ ! -f "$manifest" ]]; then
        echo "INTEGRITY ERROR: Missing .engine/manifest.sha256" >&2
        VERIFY_INTEGRITY_OK=0
        return 1
    fi
    local expected_hash rel_path full_path actual_hash
    while IFS=' ' read -r expected_hash rel_path || [[ -n "${expected_hash:-}" ]]; do
        [[ -z "${expected_hash:-}" ]] && continue
        rel_path="${rel_path#\* }"
        rel_path="${rel_path%$'\r'}"
        full_path="$module_dir/$rel_path"
        if [[ ! -f "$full_path" ]]; then
            echo "INTEGRITY ERROR: Missing $rel_path" >&2
            VERIFY_INTEGRITY_OK=0
            return 1
        fi
        actual_hash="$(sha256_file "$full_path")"
        if [[ "$actual_hash" != "$expected_hash" ]]; then
            echo "INTEGRITY ERROR: File modified ($rel_path). Run recover.sh to restore." >&2
            VERIFY_INTEGRITY_OK=0
            return 1
        fi
    done < "$manifest"
    return 0
}

_flush_section_summary() {
    if [[ -n "$VERIFY_CURRENT_SECTION" && "$VERIFY_SECTION_TOTAL" -gt 0 ]]; then
        local spct=$(( VERIFY_SECTION_EARNED * 100 / VERIFY_SECTION_TOTAL ))
        VERIFY_SECTION_RESULTS+=("${VERIFY_CURRENT_SECTION}: ${VERIFY_SECTION_EARNED}/${VERIFY_SECTION_TOTAL} (${spct}%)")
    fi
}

verify_section() {
    local sec_label="$1"
    _flush_section_summary
    VERIFY_CURRENT_SECTION="$sec_label"
    VERIFY_SECTION_TOTAL=0
    VERIFY_SECTION_EARNED=0
    echo ""
    echo "--- $sec_label ---"
}

# verify_check <task_num> <neutral_requirement> <cmd...>
verify_check() {
    local task_num="$1"
    local req_text="$2"
    shift 2
    verify_check_weighted "$task_num" 1 0 "$req_text" "$@"
}

# verify_check_weighted <task_num> <weight> <critical:0|1> <neutral_requirement> <cmd...>
verify_check_weighted() {
    local _vc_task_num="$1"
    local _vc_weight="$2"
    local _vc_critical="$3"
    local _vc_req_text="$4"
    shift 4

    VERIFY_TOTAL_COUNT=$((VERIFY_TOTAL_COUNT + 1))
    VERIFY_TOTAL_WEIGHT=$((VERIFY_TOTAL_WEIGHT + _vc_weight))
    VERIFY_SECTION_TOTAL=$((VERIFY_SECTION_TOTAL + _vc_weight))

    local _vc_rc=0
    "$@" >/dev/null 2>&1 || _vc_rc=$?

    local _vc_crit_tag=""
    [[ "$_vc_critical" -eq 1 ]] && _vc_crit_tag=" [CRITICAL]"

    if [[ "$_vc_rc" -eq 0 ]]; then
        VERIFY_PASSED_COUNT=$((VERIFY_PASSED_COUNT + 1))
        VERIFY_EARNED_WEIGHT=$((VERIFY_EARNED_WEIGHT + _vc_weight))
        VERIFY_SECTION_EARNED=$((VERIFY_SECTION_EARNED + _vc_weight))
        printf "  [PASS] Task %-4s%s: %s  (%d/%d passed)\n" \
            "$_vc_task_num" "$_vc_crit_tag" "$_vc_req_text" "$VERIFY_PASSED_COUNT" "$VERIFY_TOTAL_COUNT"
    else
        VERIFY_FAILED_TASKS+=("$_vc_task_num")
        [[ "$_vc_critical" -eq 1 ]] && VERIFY_CRITICAL_FAILED=$((VERIFY_CRITICAL_FAILED + 1))
        printf "  [FAIL] Task %-4s%s: %s  (%d/%d passed)\n" \
            "$_vc_task_num" "$_vc_crit_tag" "$_vc_req_text" "$VERIFY_PASSED_COUNT" "$VERIFY_TOTAL_COUNT"
    fi
}

verify_finish() {
    _flush_section_summary
    stop_tracked_pids "$VERIFY_MODULE_DIR/workspace" || true

    local pct=0
    if [[ "$VERIFY_TOTAL_WEIGHT" -gt 0 ]]; then
        pct=$(( VERIFY_EARNED_WEIGHT * 100 / VERIFY_TOTAL_WEIGHT ))
    fi

    echo ""
    echo "============================================================"
    if [[ "${#VERIFY_SECTION_RESULTS[@]}" -gt 0 ]]; then
        echo "Section Breakdown:"
        local sline
        for sline in "${VERIFY_SECTION_RESULTS[@]}"; do
            echo "  - $sline"
        done
        echo ""
    fi

    echo "Checks passed: $VERIFY_PASSED_COUNT / $VERIFY_TOTAL_COUNT"
    echo "Weighted score: ${pct}% (required: ${VERIFY_MIN_PCT}%)"

    verify_self_integrity "$VERIFY_MODULE_DIR" || true
    if [[ "$VERIFY_INTEGRITY_OK" -ne 1 ]]; then
        echo "RESULT: INTEGRITY CHECK FAILED — verification aborted."
        echo "============================================================"
        return 2
    fi

    local passed=0
    if [[ "$VERIFY_TOTAL_COUNT" -gt 0 && $(( VERIFY_EARNED_WEIGHT * 100 )) -ge $(( VERIFY_MIN_PCT * VERIFY_TOTAL_WEIGHT )) && "$VERIFY_CRITICAL_FAILED" -eq 0 ]]; then
        passed=1
    fi

    if [[ "$passed" -eq 1 ]]; then
        echo "RESULT: PASS"
        echo "============================================================"
        ledger_append "PASS" "$VERIFY_MODULE_ID" "score=${pct}%"
        if [[ "$VERIFY_MODE" != "exam" ]]; then
            reveal_next_code "$VERIFY_MODULE_DIR" "$VERIFY_MODULE_ID"
        fi
        return 0
    else
        echo "RESULT: FAIL"
        if [[ "$VERIFY_CRITICAL_FAILED" -gt 0 ]]; then
            echo "Critical checks failed: $VERIFY_CRITICAL_FAILED"
        fi
        echo "Failed tasks: ${VERIFY_FAILED_TASKS[*]:-none}"
        echo "============================================================"
        ledger_append "FAIL" "$VERIFY_MODULE_ID" "score=${pct}%;failed=${VERIFY_FAILED_TASKS[*]:-none}"
        return 1
    fi
}
