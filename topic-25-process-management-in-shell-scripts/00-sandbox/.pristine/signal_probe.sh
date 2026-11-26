#!/usr/bin/env bash
set -u
cleanup() {
    printf 'caught signal or exit in pid=%s\n' "$$"
}
trap cleanup EXIT
trap 'printf "SIGTERM received\n"; exit 143' TERM
trap 'printf "SIGINT received\n"; exit 130' INT
printf 'probe ready pid=%s\n' "$$"
sleep 5
