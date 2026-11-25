#!/usr/bin/env bash
# .engine/lib/unlock-lib.sh - Decrypts payload.enc and initializes module workspace.
set -u

unlock_module() {
    local module_dir="$1"
    local module_id="$2"
    local module_env="$3"
    local code_salt="$4"
    local code_hash="$5"
    shift 5

    local provided_code=""
    while [[ $# -gt 0 ]]; do
        case "$1" in
            --code)
                provided_code="${2:-}"
                shift 2
                ;;
            *)
                shift
                ;;
        esac
    done

    local root_dir
    root_dir="${COURSE_ROOT_OVERRIDE:-$(course_repo_root)}"
    read_student_file || return 1

    if [[ "$module_env" == "linux" ]] && is_gitbash; then
        echo "============================================================" >&2
        echo " BLOCKED: $module_id requires a real Linux environment (ENV=linux)." >&2
        echo "============================================================" >&2
        echo "You appear to be running in Git Bash on Windows." >&2
        echo "Linux permissions, processes, sysinfo, networking, or package" >&2
        echo "tools in this module do not behave accurately on NTFS/Git Bash." >&2
        echo "" >&2
        echo "Please open Ubuntu under WSL2 (e.g. 'wsl -d Ubuntu'), clone" >&2
        echo "or copy the course into your Linux home folder (~/...), and" >&2
        echo "run 'bash unlock.sh' there." >&2
        return 1
    fi

    local payload="$module_dir/payload.enc"
    if [[ ! -f "$payload" ]]; then
        echo "ERROR: Missing $payload" >&2
        return 1
    fi

    if [[ -f "$module_dir/verify.sh" && -d "$module_dir/workspace" ]]; then
        echo "Module $module_id is already unlocked."
        echo "Read: $module_dir/README.md"
        return 0
    fi

    local raw_code="$provided_code"
    if [[ -z "$raw_code" ]]; then
        printf "Enter unlock code for %s (format XXXX-XXXX-XXXX): " "$module_id"
        IFS= read -r raw_code
    fi

    local norm_code actual_hash
    norm_code="$(normalize_code "$raw_code")"
    if [[ -z "$norm_code" ]]; then
        echo "ERROR: Empty unlock code." >&2
        return 1
    fi

    actual_hash="$(sha256_str "${code_salt}:${norm_code}")"
    if [[ "$actual_hash" != "$code_hash" ]]; then
        echo "ERROR: Code incorrect." >&2
        return 1
    fi

    local tmp_tar
    tmp_tar="$(mktemp)"
    if ! CODE="$norm_code" openssl enc -d -aes-256-cbc -pbkdf2 -iter 200000 -pass env:CODE -in "$payload" -out "$tmp_tar" 2>/dev/null; then
        rm -f "$tmp_tar"
        echo "ERROR: Decryption failed (bad decrypt)." >&2
        return 1
    fi

    if ! tar -xzf "$tmp_tar" -C "$module_dir" 2>/dev/null; then
        rm -f "$tmp_tar"
        echo "ERROR: Failed to extract module archive." >&2
        return 1
    fi
    rm -f "$tmp_tar"

    mkdir -p "$root_dir/.progress/codes"
    printf '%s\n' "$norm_code" > "$root_dir/.progress/codes/${module_id}.code"

    if [[ -f "$module_dir/.engine/setup.sh" ]]; then
        (
            export STUDENT_ID STUDENT_SEED MODULE_DIR="$module_dir"
            bash "$module_dir/.engine/setup.sh"
        ) || {
            echo "ERROR: Module workspace setup failed." >&2
            return 1
        }
    fi

    ledger_append "UNLOCK" "$module_id" "env=$(detect_shell_env)"

    echo "Unlocked $module_id successfully."
    echo "Next: read $module_dir/README.md and work inside $module_dir/workspace/"
    return 0
}
