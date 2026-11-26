#!/usr/bin/env bash
set -Euo pipefail

on_err() {
    local rc=$?
    local line="${1:-$LINENO}"
    printf 'ERR rc=%d line=%s func=%s\n' "$rc" "$line" "${FUNCNAME[1]:-main}" >&2
}
trap 'on_err "$LINENO"' ERR

inner() {
    false
}

outer() {
    inner
}

outer
