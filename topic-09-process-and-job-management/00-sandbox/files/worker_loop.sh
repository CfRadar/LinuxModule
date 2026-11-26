#!/usr/bin/env bash
set -u
dur="${1:-20}"
i=0
while (( i < dur )); do
    sleep 1
    ((i++))
done
