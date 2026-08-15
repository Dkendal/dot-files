def main [revset] {
  jj log -r $revset --no-graph -T 'local_bookmarks.map(|x| x.name()).join("\n") ++ "\n"' |
  lines |
  each { |head|
    let base = jj log -r $"closest_bookmark\(($head)-\)" -T 'local_bookmarks.map(|x| x.name()).join("\n") ++ "\n"' --no-graph
    ^gh pr create --head $head --base $base --fill
  }
}
