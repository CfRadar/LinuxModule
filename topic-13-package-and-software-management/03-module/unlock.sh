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
unlock_module "$MODULE_DIR" "T13-M03" "linux" "280403e136bee302" "a5e24beb5acdd83a46e5c2b9c738ae5bf9012a0967d1381ce0913e6a2d56d5d8" "$@"
