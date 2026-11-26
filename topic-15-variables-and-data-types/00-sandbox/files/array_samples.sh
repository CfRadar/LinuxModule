#!/usr/bin/env bash
declare -a items=("alpha node" "beta node" "gamma node")
echo "count=${#items[@]}"
for item in "${items[@]}"; do
    echo "item=$item"
done
