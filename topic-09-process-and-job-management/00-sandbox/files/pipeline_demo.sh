#!/usr/bin/env bash
set -u
sleep 2 &
p1=$!
sleep 3 &
p2=$!
wait "$p1" "$p2"
