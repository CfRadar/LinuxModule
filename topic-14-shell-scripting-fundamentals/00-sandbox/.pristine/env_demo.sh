#!/usr/bin/env bash
# Sample script for subshell vs source experimentation
DEMO_VAR="loaded_from_env_demo"
printf 'PID=%s DEMO_VAR=%s\n' "$$" "$DEMO_VAR"
