#!/usr/bin/env bash

# Fixes the issue:
# invalid data in index - calculated checksum does not match expected
# @see https://discourse.nixos.org/t/invalid-data-in-git-index-while-nix-flaek-update/36738/6
git config --local index.skipHash false
git reset --mixed

# Use the repo's tracked git hooks (e.g. the pre-push secret scanner).
git config --local core.hooksPath git-hooks
