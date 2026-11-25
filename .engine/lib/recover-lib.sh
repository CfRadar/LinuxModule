#!/usr/bin/env bash
# .engine/lib/recover-lib.sh - Safe, idempotent module workspace recovery.
set -u

recover_module() {
    local module_dir="$1"
    local module_id="$2"
    shift 2

    local keep_backup=0
    local assume_yes=0
    local section=""
    while [[ $# -gt 0 ]]; do
        case "$1" in
            --keep-backup) keep_backup=1; shift ;;
            --yes|-y)      assume_yes=1; shift ;;
            --section)     section="${2:-}"; shift 2 ;;
            *)             shift ;;
        esac
    done

    local root_dir
    root_dir="${COURSE_ROOT_OVERRIDE:-$(course_repo_root)}"
    read_student_file || return 1

    if [[ "$assume_yes" -ne 1 ]]; then
        local reply
        if [[ -n "$section" ]]; then
            printf "Type 'yes' to reset section %s of %s: " "$section" "$module_id"
        else
            printf "Type 'yes' to reset workspace of %s: " "$module_id"
        fi
        IFS= read -r reply
        if [[ "$reply" != "yes" ]]; then
            echo "Aborted."
            return 1
        fi
    fi

    stop_tracked_pids "$module_dir/workspace" || true

    if [[ "$keep_backup" -eq 1 && -d "$module_dir/workspace" ]]; then
        local bak_dir="$module_dir/workspace.bak-$(date +%Y%m%d-%H%M%S)"
        cp -a "$module_dir/workspace" "$bak_dir"
        echo "Backup saved to: $bak_dir"
    fi

    local code_file="$root_dir/.progress/codes/${module_id}.code"
    local norm_code=""
    if [[ -f "$code_file" ]]; then
        norm_code="$(normalize_code "$(cat "$code_file")")"
    else
        printf "Enter unlock code for %s to re-extract pristine files: " "$module_id"
        IFS= read -r norm_code
        norm_code="$(normalize_code "$norm_code")"
    fi

    local payload="$module_dir/payload.enc"
    local tmp_tar tmp_extract
    tmp_tar="$(mktemp)"
    tmp_extract="$(mktemp -d)"

    if ! CODE="$norm_code" openssl enc -d -aes-256-cbc -pbkdf2 -iter 200000 -pass env:CODE -in "$payload" -out "$tmp_tar" 2>/dev/null; then
        rm -f "$tmp_tar"
        rm -rf "$tmp_extract"
        echo "ERROR: Could not decrypt payload.enc for recovery." >&2
        return 1
    fi

    if ! tar -xzf "$tmp_tar" -C "$tmp_extract" 2>/dev/null; then
        rm -f "$tmp_tar"
        rm -rf "$tmp_extract"
        echo "ERROR: Could not extract payload.enc for recovery." >&2
        return 1
    fi
    rm -f "$tmp_tar"

    # Restore pristine module engine/scripts without touching ledger
    cp -f "$tmp_extract/README.md" "$module_dir/README.md"
    cp -f "$tmp_extract/verify.sh" "$module_dir/verify.sh"
    [[ -f "$tmp_extract/enter.sh" ]] && cp -f "$tmp_extract/enter.sh" "$module_dir/enter.sh"
    mkdir -p "$module_dir/.engine"
    cp -a "$tmp_extract/.engine/." "$module_dir/.engine/"
    rm -rf "$tmp_extract"

    if [[ -n "$section" ]]; then
        local sec_padded sec_dir
        printf -v sec_padded '%02d' "$((10#$section))"
        sec_dir="$module_dir/workspace/section-${sec_padded}"
        safe_rm_tree "$sec_dir" || return 1
        (
            export STUDENT_ID STUDENT_SEED MODULE_DIR="$module_dir" RECOVER_SECTION="$sec_padded"
            bash "$module_dir/.engine/setup.sh" --section "$sec_padded"
        ) || {
            echo "ERROR: Section recovery setup failed." >&2
            return 1
        }
        ledger_append "RECOVER" "$module_id" "section=$sec_padded"
        echo "Recovered section $sec_padded of $module_id."
    else
        safe_rm_tree "$module_dir/workspace" || return 1
        (
            export STUDENT_ID STUDENT_SEED MODULE_DIR="$module_dir"
            bash "$module_dir/.engine/setup.sh"
        ) || {
            echo "ERROR: Workspace recovery setup failed." >&2
            return 1
        }
        ledger_append "RECOVER" "$module_id" "full"
        echo "Recovered $module_id workspace."
    fi
    return 0
}
