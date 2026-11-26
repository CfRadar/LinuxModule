#!/usr/bin/env bash
printf 'STDOUT: probe initialized\n'
printf 'STDERR: WARN cache cold\n' >&2
printf 'STDOUT: processed 42 records\n'
printf 'STDERR: CRIT threshold exceeded\n' >&2
if [[ "${1:-}" == "fail" ]]; then
    exit 2
fi
exit 0
