def main [revset] {
  jj log -r $revset --no-graph -T 'local_bookmarks.map(|x| x.name()).join("\n") ++ "\n"' |
  lines |
  each { |head|
    let base = jj log -r $"closest_bookmark\(($head)-\)" -T 'local_bookmarks.map(|x| x.name()).join("\n") ++ "\n"' --no-graph
    try {
      print $"head=($head) base=($base)"
      ^gh pr edit $head --base $base
    } catch { |err|
      print $err.msg
      ^gh pr view $head --web
    }
  }
}
