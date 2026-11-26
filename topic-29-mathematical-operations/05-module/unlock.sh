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
unlock_module "$MODULE_DIR" "T29-M05" "any" "b91776f7ea959391" "7a30fbe0675de622405087a8a56bc8f8427508b90387a86370722c3fc232959b" "$@"
