#!/usr/bin/env bash
set -u

val="${1:-15}"

if [[ "$val" =~ ^[0-9]+$ ]]; then
    if (( val >= 100 )); then
        echo "TIER=HIGH"
    elif [[ "$val" -ge 20 ]]; then
        echo "TIER=MEDIUM"
    else
        echo "TIER=LOW"
    fi
else
    echo "TIER=INVALID"
fi

case "$val" in
    *0*) echo "FLAG=HAS_ZERO" ;;&
    *5)  echo "FLAG=ENDS_FIVE" ;;&
esac
