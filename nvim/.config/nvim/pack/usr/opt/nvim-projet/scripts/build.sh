#!/bin/sh

set -e

if [ -n "$1" ]; then
	out="lua/$(dirname "$1")/$(basename "$1" ".fnl").lua"

	mkdir -p "$(dirname "$out")"

	echo "$1 .. $out"

	fennel \
		--correlate \
		--add-macro-path 'fnl/?.fnl' \
		--add-fennel-path 'fnl/?.fnl' \
		--compile "$1" >"$out"

	exit 0
fi

find . -name '*.fnl' -a ! -name 'macros.fnl' -print0 |
	xargs -I "{}" sh "$0" "{}"
