#!/usr/bin/env bash
set -u
echo "PROG=$0"
echo "COUNT=$#"
for arg in "$@"; do
    printf 'AT=[%s]\n' "$arg"
done
IFS='|'
echo "STAR=[$*]"
