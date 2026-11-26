#!/usr/bin/env bash
set -u
verbose=0
output="none"
OPTIND=1
while getopts ":vo:" opt; do
    case "$opt" in
        v) verbose=1 ;;
        o) output="$OPTARG" ;;
        :) echo "Missing argument for -$OPTARG" >&2; exit 2 ;;
        \?) echo "Unknown option -$OPTARG" >&2; exit 2 ;;
    esac
done
shift $((OPTIND - 1))
echo "VERBOSE=$verbose OUTPUT=$output POS_COUNT=$#"
