#!/usr/bin/env bash
# @NAME: starter_dual
# @PURPOSE: Demonstrate interactive TTY vs piped stdin detection
set -euo pipefail

if [[ -t 0 ]]; then
    printf 'MODE=interactive\n'
else
    printf 'MODE=batch\n'
    while IFS= read -r line || [[ -n "$line" ]]; do
        line="${line%$'\r'}"
        [[ -n "$line" ]] && printf 'LINE=%s\n' "$line"
    done
fi
