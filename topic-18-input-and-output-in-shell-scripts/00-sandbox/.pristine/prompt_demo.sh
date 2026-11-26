#!/usr/bin/env bash
printf 'Enter tag: ' >&2
IFS= read -r tag
printf 'TAG=%s\n' "$tag"
