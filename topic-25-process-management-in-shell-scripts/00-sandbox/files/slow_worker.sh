#!/usr/bin/env bash
set -u
ticks="${1:-20}"
i=0
while [[ "$i" -lt "$ticks" ]]; do
    sleep 0.1
    i=$((i + 1))
done
printf 'finished %d ticks\n' "$ticks"
exit 0
