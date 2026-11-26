#!/usr/bin/env bash
set -u
SB_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
ROOT_DIR="$(cd "$SB_DIR/../.." && pwd -P)"
source "$ROOT_DIR/.engine/lib/sandbox-reset.sh"
sandbox_reset "$SB_DIR"
