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
unlock_module "$MODULE_DIR" "T09-M04" "linux" "540a9ed092739e92" "a7e6a012396f80767169d327af7a7a31d690b82d053f60e305b30d3cf8e94a03" "$@"
