#!/usr/bin/env bash
# .engine/lib/common.sh - Shared utilities for student-side and authoring scripts.
set -u

course_repo_root() {
    local dir
    dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd -P)"
    echo "$dir"
}

detect_shell_env() {
    local uname_s
    uname_s="$(uname -s 2>/dev/null || echo unknown)"
    if [[ -n "${WSL_DISTRO_NAME:-}" ]] || grep -qiE 'microsoft|wsl' /proc/version 2>/dev/null; then
        echo "wsl"
    elif [[ "$uname_s" == MINGW* || "$uname_s" == MSYS* || "$uname_s" == CYGWIN* ]]; then
        echo "gitbash"
    elif [[ "$uname_s" == Linux* ]]; then
        echo "linux"
    elif [[ "$uname_s" == Darwin* ]]; then
        echo "macos"
    else
        echo "unknown"
    fi
}

is_gitbash() {
    [[ "$(detect_shell_env)" == "gitbash" ]]
}

sha256_str() {
    local input="$1"
    if command -v sha256sum >/dev/null 2>&1; then
        printf '%s' "$input" | sha256sum | awk '{print $1}'
    elif command -v shasum >/dev/null 2>&1; then
        printf '%s' "$input" | shasum -a 256 | awk '{print $1}'
    elif command -v openssl >/dev/null 2>&1; then
        printf '%s' "$input" | openssl dgst -sha256 -r | awk '{print $1}'
    else
        echo "ERROR: No sha256 tool available" >&2
        return 1
    fi
}

sha256_file() {
    local file="$1"
    if command -v sha256sum >/dev/null 2>&1; then
        sha256sum "$file" | awk '{print $1}'
    elif command -v shasum >/dev/null 2>&1; then
        shasum -a 256 "$file" | awk '{print $1}'
    elif command -v openssl >/dev/null 2>&1; then
        openssl dgst -sha256 -r "$file" | awk '{print $1}'
    else
        echo "ERROR: No sha256 tool available" >&2
        return 1
    fi
}

normalize_code() {
    local raw="${1:-}"
    printf '%s' "$raw" | tr -d ' \t\r\n' | tr '[:lower:]' '[:upper:]'
}

canonical_dir() {
    local p="$1"
    if [[ -d "$p" ]]; then
        (cd "$p" && pwd -P)
    else
        local parent base
        parent="$(dirname "$p")"
        base="$(basename "$p")"
        if [[ -d "$parent" ]]; then
            echo "$(cd "$parent" && pwd -P)/$base"
        else
            return 1
        fi
    fi
}

# safe_rm_tree <target_dir>
# Asserts target is non-empty, strictly inside repo root, and inside a workspace* directory.
safe_rm_tree() {
    local target="${1:-}"
    if [[ -z "$target" ]]; then
        echo "safe_rm_tree: empty path refused" >&2
        return 1
    fi

    local root_dir resolved_root resolved_target rel
    root_dir="${COURSE_ROOT_OVERRIDE:-$(course_repo_root)}"
    resolved_root="$(canonical_dir "$root_dir")" || {
        echo "safe_rm_tree: cannot resolve repo root" >&2
        return 1
    }
    resolved_target="$(canonical_dir "$target")" || {
        echo "safe_rm_tree: cannot resolve target parent for '$target'" >&2
        return 1
    }

    if [[ "$resolved_target" == "$resolved_root" ]]; then
        echo "safe_rm_tree: refusing to remove repo root" >&2
        return 1
    fi
    if [[ "$resolved_target" != "$resolved_root/"* ]]; then
        echo "safe_rm_tree: target '$resolved_target' is outside repo root '$resolved_root'" >&2
        return 1
    fi

    rel="${resolved_target#"$resolved_root"/}"
    case "$rel" in
        workspace|workspace.*|*/workspace|*/workspace/*|*/workspace.*|*/workspace.*/*)
            ;;
        *)
            echo "safe_rm_tree: target '$rel' is not inside a workspace* directory" >&2
            return 1
            ;;
    esac

    if [[ -e "$resolved_target" || -L "$resolved_target" ]]; then
        rm -rf "$resolved_target"
    fi
}

read_student_file() {
    local root_dir student_file
    root_dir="${COURSE_ROOT_OVERRIDE:-$(course_repo_root)}"
    student_file="$root_dir/.student"
    if [[ ! -f "$student_file" ]]; then
        echo "ERROR: Course not initialized. Run 'bash setup.sh' from the repository root first." >&2
        return 1
    fi
    # Parse safely without sourcing arbitrary code
    STUDENT_ID=""
    STUDENT_SEED=""
    while IFS='=' read -r k v; do
        case "$k" in
            STUDENT_ID) STUDENT_ID="${v%$'\r'}" ;;
            STUDENT_SEED) STUDENT_SEED="${v%$'\r'}" ;;
        esac
    done < "$student_file"
    if [[ -z "$STUDENT_ID" || -z "$STUDENT_SEED" ]]; then
        echo "ERROR: .student file is malformed. Re-run 'bash setup.sh'." >&2
        return 1
    fi
    export STUDENT_ID STUDENT_SEED
}

read_meta_env() {
    local mfile="$1"
    ID=""
    TITLE=""
    ENV="any"
    TIME_MIN="60"
    DIFFICULTY="hard"
    TRAPS=""
    POINTS=""
    MIN_PLAUSIBLE_MINUTES=""
    local k v
    while IFS='=' read -r k v || [[ -n "${k:-}" ]]; do
        [[ -z "${k:-}" || "$k" == \#* ]] && continue
        v="${v%$'\r'}"
        v="${v%\"}"
        v="${v#\"}"
        case "$k" in
            ID) ID="$v" ;;
            TITLE) TITLE="$v" ;;
            ENV) ENV="$v" ;;
            TIME_MIN) TIME_MIN="$v" ;;
            DIFFICULTY) DIFFICULTY="$v" ;;
            TRAPS) TRAPS="$v" ;;
            POINTS) POINTS="$v" ;;
            MIN_PLAUSIBLE_MINUTES) MIN_PLAUSIBLE_MINUTES="$v" ;;
        esac
    done < "$mfile"
}

# Deterministic integer in [0, mod-1] from STUDENT_SEED + key
seed_int() {
    local seed="$1"
    local key="$2"
    local mod="$3"
    local h hex_part
    h="$(sha256_str "${seed}:${key}")"
    hex_part="${h:0:8}"
    echo $(( 16#$hex_part % mod ))
}

# Deterministic pick from arguments: seed_pick "$SEED" "key" item1 item2 ...
seed_pick() {
    local seed="$1"
    local key="$2"
    shift 2
    local items=("$@")
    local idx
    idx="$(seed_int "$seed" "$key" "${#items[@]}")"
    echo "${items[$idx]}"
}

stop_tracked_pids() {
    local ws_dir="$1"
    local pids_file="$ws_dir/.pids"
    if [[ ! -f "$pids_file" ]]; then
        return 0
    fi
    local pid
    while IFS= read -r pid || [[ -n "$pid" ]]; do
        pid="${pid%$'\r'}"
        [[ -z "$pid" || "$pid" == \#* ]] && continue
        if [[ "$pid" =~ ^[0-9]+$ ]]; then
            if kill -0 "$pid" 2>/dev/null; then
                kill -TERM "$pid" 2>/dev/null || true
                sleep 0.2
                if kill -0 "$pid" 2>/dev/null; then
                    kill -KILL "$pid" 2>/dev/null || true
                fi
            fi
        fi
    done < "$pids_file"
    rm -f "$pids_file"
}

run_with_timeout() {
    local secs="$1"
    shift
    if command -v timeout >/dev/null 2>&1; then
        timeout -k 2 "$secs" "$@"
    else
        "$@"
    fi
}
