#!/usr/bin/env bash
x="global"
inner() {
    echo "inner sees x=$x"
}
outer() {
    local x="outer_local"
    inner
}
echo "before: x=$x"
outer
echo "after: x=$x"
