#!/usr/bin/env bash
set -u
MODULE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
ROOT_DIR="${COURSE_ROOT_OVERRIDE:-}"
if [[ -z "$ROOT_DIR" ]]; then
    d="$MODULE_DIR"
    while [[ "$d" != "/" ]]; do
        if [[ -f "$d/.engine/lib/common.sh" ]]; then
            ROOT_DIR="$d"
            break
        fi
        d="$(dirname "$d")"
    done
fi
source "$ROOT_DIR/.engine/lib/common.sh"
source "$ROOT_DIR/.engine/lib/ledger.sh"
source "$ROOT_DIR/.engine/lib/unlock-lib.sh"
unlock_module "$MODULE_DIR" "T30-M03" "linux" "8bc44b4b6afc1c58" "616f60cf332b3f53c3fc5f25feb698cdd8526388eb8cb90978786332be880db8" "$@"
