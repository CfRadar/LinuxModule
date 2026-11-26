#!/usr/bin/env bash
val="010"
echo "unprefixed 010 in arithmetic: $(( val + 1 ))"
echo "base-10 10#010 in arithmetic: $(( 10#$val + 1 ))"
safe_eight="08"
echo "base-10 10#08 in arithmetic: $(( 10#$safe_eight + 1 ))"
