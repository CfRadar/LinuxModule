#!/usr/bin/env bash
declare -A ports
ports["north dock"]=8080
ports["south dock"]=9090
for k in "${!ports[@]}"; do
    echo "$k -> ${ports[$k]}"
done
