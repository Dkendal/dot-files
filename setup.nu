#!/usr/bin/env nu

let dirs = ls ./xdg_config | where type == dir | each { |dir|
  let name = $dir.name | path parse | get stem

  let source = [$env.HOME ".config" $name ] | path join
  let target = $source | path expand

  let is_linked: bool = if ($target | describe) == string {
      ( $dir.name | path expand) == $target
    } else {
      false
    }

  {
    name: $dir.name
    dir: $source
    exists: ($source | path exists)
    is_linked: $is_linked
    target: $target
  }
}

let conflicts = $dirs | where ($it.exists and not $it.is_linked )

if ( ( $conflicts | length ) > 0 ) {
  print "Skipping the following directories, they exist and are not linked locally:"
  $conflicts | select name target | table --index false | print
}

let linked = $dirs | where ($it.exists and $it.is_linked )

if ( ( $linked | length ) > 0 ) {
  print "Skipping the following directories, already linked:"
  $linked | select name | table --index false | print
}


let remaining = $dirs | where (not $it.exists and not $it.is_linked )

if ( ( $remaining | length ) == 0 ) {
  print "Nothing to link"
  ignore
}

$remaining | where (not $it.exists and not $it.is_linked ) | each { |dir|
  let source =  $dir.name | path expand
  let target = $dir.dir
  ln -s $source $target
  print $"Linked ( $target ) to ( $source )"
}

ignore
