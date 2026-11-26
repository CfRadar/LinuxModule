#!/usr/bin/env bash
set -u
name="${1:-worker}"
delay="${2:-0.1}"
code="${3:-0}"
printf '[%s] start pid=%s\n' "$name" "$$"
sleep "$delay"
printf '[%s] done exit=%s\n' "$name" "$code"
exit "$code"
