#!/bin/bash
set -euo pipefail

IFS=" :" read -ra terms <<<"$1"
file="${terms[0]}"
lnum="${terms[1]}"

context=10
bottom="$((lnum - context))"
top="$((lnum + context))"

if ((bottom < 0)); then
  bottom=0
fi

bat "$file" --line-range "$bottom:$top" --paging=never --color=always --style="numbers,changes,snip" --highlight-line="$lnum"
