#!/bin/bash

exec >&2

set -euxo pipefail

for file in *.fnl; do
  redo-ifchange "${file%%.fnl}.lua"
done
