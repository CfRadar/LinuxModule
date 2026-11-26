#!/usr/bin/env bash
set -u

x="global_x"

inner() {
    printf 'inner sees x=%s\n' "$x"
}

outer_dynamic() {
    local x="outer_x"
    inner
}

outer_isolated() {
    local x="outer_x"
    local inner_x="isolated"
    printf 'outer_isolated x=%s inner_x=%s\n' "$x" "$inner_x"
}

printf 'before: x=%s\n' "$x"
outer_dynamic
outer_isolated
printf 'after: x=%s\n' "$x"
