#!/usr/bin/env bash
set -u

printf 'alpha\nbeta\ngamma\n' | grep -q 'missing' | cat
echo "Dollar-question: $?"
echo "PIPESTATUS: ${PIPESTATUS[*]}"
