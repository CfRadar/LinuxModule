#!/usr/bin/env bash
mode="prod"
count=5
if [ "$mode" = "prod" -a "$count" -gt 3 ]; then
    echo "legacy check passed"
fi
