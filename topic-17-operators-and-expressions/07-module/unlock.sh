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
unlock_module "$MODULE_DIR" "T17-M07" "any" "e9cf3a9b15345450" "dba76361c93ec68944337834b5e309bff3a6c4f74f1657c76b947eeb205d21bf" "$@"
