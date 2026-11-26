#!/usr/bin/env bash
set -u
verbose=0
output="none"
while [[ $# -gt 0 ]]; do
    case "$1" in
        -v|--verbose) verbose=1; shift ;;
        -o|--output)
            [[ $# -ge 2 ]] || { echo "Missing value for $1" >&2; exit 2; }
            output="$2"; shift 2 ;;
        --output=*) output="${1#*=}"; shift ;;
        --) shift; break ;;
        -*) echo "Unknown option: $1" >&2; exit 2 ;;
        *) break ;;
    esac
done
echo "VERBOSE=$verbose OUTPUT=$output POS_COUNT=$#"
