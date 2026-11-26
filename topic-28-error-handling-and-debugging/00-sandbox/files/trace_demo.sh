#!/usr/bin/env bash
set -u

helper() {
    local item="$1"
    printf 'processed:%s\n' "$item"
}

helper "sample-record"
