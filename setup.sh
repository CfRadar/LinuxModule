#!/usr/bin/env bash
# setup.sh - Initialize student environment, verify tools, create .student and ledger SETUP event.
set -u

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
export COURSE_ROOT_OVERRIDE="$ROOT_DIR"

# shellcheck source=.engine/lib/common.sh
source "$ROOT_DIR/.engine/lib/common.sh"
# shellcheck source=.engine/lib/ledger.sh
source "$ROOT_DIR/.engine/lib/ledger.sh"

PROVIDED_ID=""
while [[ $# -gt 0 ]]; do
    case "$1" in
        --id) PROVIDED_ID="${2:-}"; shift 2 ;;
        *)    shift ;;
    esac
done

echo "=== Linux & Shell Scripting Course Setup ==="

# 1. Bash version >= 4
if [[ "${BASH_VERSINFO[0]:-0}" -lt 4 ]]; then
    echo "ERROR: Bash >= 4.0 is required (found ${BASH_VERSION:-unknown})." >&2
    exit 1
fi

# 2. Required tools
missing=()
for cmd in openssl tar gzip sha256sum awk sed grep find timeout; do
    if ! command -v "$cmd" >/dev/null 2>&1; then
        missing+=("$cmd")
    fi
done
if [[ "${#missing[@]}" -gt 0 ]]; then
    echo "ERROR: Missing required tools: ${missing[*]}" >&2
    echo "Install them (e.g. via Ubuntu apt or Git for Windows) and re-run setup.sh." >&2
    exit 1
fi

# 3. Environment detection & /mnt/c warning
ENV_KIND="$(detect_shell_env)"
echo "Detected environment: $ENV_KIND (Bash ${BASH_VERSION})"
if [[ "$ENV_KIND" == "wsl" && "$ROOT_DIR" == /mnt/[a-zA-Z]/* ]]; then
    echo ""
    echo "WARNING: This repository is located on a Windows drive ($ROOT_DIR)." >&2
    echo "Linux permissions (chmod/chown/umask) do NOT behave correctly under /mnt/c." >&2
    echo "Move or clone the repository inside your WSL home directory (e.g. ~/linux-course)." >&2
    echo ""
elif [[ "$ENV_KIND" == "gitbash" ]]; then
    echo "Note: Git Bash supports ENV=any modules. Modules marked ENV=linux require WSL2 (Ubuntu)."
fi

# 4. Student ID handling (safe to re-run)
STUDENT_FILE="$ROOT_DIR/.student"
if [[ -f "$STUDENT_FILE" ]]; then
    read_student_file >/dev/null 2>&1 || true
    if [[ -n "${STUDENT_ID:-}" ]]; then
        if [[ -n "$PROVIDED_ID" && "$PROVIDED_ID" == "$STUDENT_ID" ]]; then
            echo "Already initialized for student: $STUDENT_ID (seed: $STUDENT_SEED)"
            exit 0
        fi
        echo "Course is already initialized for student: $STUDENT_ID"
        printf "Overwrite existing Student ID? Type 'yes' to change, or Enter to keep: "
        IFS= read -r confirm
        if [[ "$confirm" != "yes" ]]; then
            echo "Keeping existing Student ID ($STUDENT_ID)."
            exit 0
        fi
    fi
fi

RAW_ID="$PROVIDED_ID"
while [[ -z "$RAW_ID" ]]; do
    printf "Enter your Student ID (name or roll number, e.g. 2026CS042): "
    IFS= read -r RAW_ID
    RAW_ID="$(printf '%s' "$RAW_ID" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')"
done

# Strip unsafe characters from ID
CLEAN_ID="$(printf '%s' "$RAW_ID" | tr -cd 'A-Za-z0-9._@ -')"
if [[ -z "$CLEAN_ID" ]]; then
    echo "ERROR: Invalid Student ID." >&2
    exit 1
fi

FULL_HASH="$(sha256_str "$CLEAN_ID")"
SEED="${FULL_HASH:0:16}"

{
    printf 'STUDENT_ID=%s\n' "$CLEAN_ID"
    printf 'STUDENT_SEED=%s\n' "$SEED"
} > "$STUDENT_FILE"

ledger_append "SETUP" "COURSE" "id=${CLEAN_ID};env=${ENV_KIND}"

echo ""
echo "Setup complete!"
echo "  Student ID   : $CLEAN_ID"
echo "  Student Seed : $SEED"
echo ""
echo "Next steps:"
echo "  1. Run 'bash status.sh' to see the course map."
echo "  2. Read 'README.md' for the starter unlock code."
echo "  3. 'cd topic-01-terminal-and-shell-fundamentals/01-module' and run 'bash unlock.sh'."
