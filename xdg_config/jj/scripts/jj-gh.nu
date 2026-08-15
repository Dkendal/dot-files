def "main pr view" [] {
  let r = 'latest(heads(::@ & bookmarks()))'
  let template = 'local_bookmarks'
  let branch = jj show --no-patch -r $r -T $template
  gh pr view $branch
}

def main [...args] {
  gh ...$args
}


def gh [...args] {
  let root = jj git root
  with-env { GIT_DIR: $root, GIT_WORK_TREE: $root } {
    ^gh ...$args
  }
}

