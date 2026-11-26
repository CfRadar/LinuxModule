#!/usr/bin/env bash
false
rc=$?
echo "captured rc=$rc"
echo "main=$$"
( echo "sub_dollar=$$ sub_bashpid=$BASHPID" )
