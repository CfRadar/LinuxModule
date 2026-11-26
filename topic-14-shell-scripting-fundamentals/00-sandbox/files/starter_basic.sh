#!/usr/bin/env bash
# @NAME: starter_basic
# @PURPOSE: Minimal structured Bash script template
# @USAGE: starter_basic.sh <arg>
set -euo pipefail

if [[ $# -lt 1 || -z "${1:-}" ]]; then
    printf 'Usage: %s <arg>\n' "$0" >&2
    exit 2
fi

printf 'ARG=%s\n' "$1"
