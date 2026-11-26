#!/usr/bin/env bash
set -u
n="${1:-3}"
for _ in $(seq 1 "$n"); do
    sleep 1
done
