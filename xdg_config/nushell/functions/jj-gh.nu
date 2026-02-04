#!/usr/bin/env nu

def main [subcommand, ...args] {
  let bookmark = jj log -r 'closest_bookmark(@-)' --no-graph --limit 1 --template bookmarks
  gh pr $subcommand $bookmark ...$args
}
