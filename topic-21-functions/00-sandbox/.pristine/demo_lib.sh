#!/usr/bin/env bash
# Sample reusable function library with include guard.
if [[ -n "${_DEMO_LIB_LOADED:-}" ]]; then
    return 0
fi
_DEMO_LIB_LOADED=1
DEMO_LIB_LOADS=$(( ${DEMO_LIB_LOADS:-0} + 1 ))
DEMO_LIB_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"

demo_greet() {
    local target="${1:-world}"
    printf 'Hello, %s (from %s)\n' "$target" "$DEMO_LIB_DIR"
}

demo_sum() {
    local total=0
    local n
    for n in "$@"; do
        total=$(( total + n ))
    done
    printf '%d\n' "$total"
}
