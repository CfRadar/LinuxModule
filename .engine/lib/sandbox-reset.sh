#!/usr/bin/env bash
# .engine/lib/sandbox-reset.sh - Restores a topic 00-sandbox/files/ directory from .pristine/
set -u

sandbox_reset() {
    local sandbox_dir="$1"
    local pristine_dir="$sandbox_dir/.pristine"
    local files_dir="$sandbox_dir/files"

    if [[ ! -d "$pristine_dir" ]]; then
        echo "ERROR: Missing pristine template at $pristine_dir" >&2
        return 1
    fi

    # Clear existing files without invoking rm -rf outside safe_rm_tree
    if [[ -d "$files_dir" ]]; then
        find "$files_dir" -mindepth 1 -delete 2>/dev/null || {
            echo "ERROR: Failed to clear $files_dir" >&2
            return 1
        }
    else
        mkdir -p "$files_dir"
    fi

    cp -a "$pristine_dir/." "$files_dir/"
    echo "Sandbox reset complete: $files_dir"
}
