def "parse vars" [] {
  $in | from csv --noheaders --no-infer | rename 'op' 'name' 'value'
}

def --env "update-env" [] {
  for $var in $in {
    if $var.op == "set" {
      if ($var.name | str upcase) == 'PATH' {
        $env.PATH = ($var.value | split row (char esep))
      } else {
        load-env {($var.name): $var.value}
      }
    } else if $var.op == "hide" and $var.name in $env {
      hide-env $var.name
    }
  }
}
export-env {
  
  'hide,GOBIN,
hide,GOROOT,
hide,LUA_INIT,
hide,MIX_ARCHIVES,
hide,MIX_HOME,
set,PATH,/Users/dylan.kendal/.hoop/bin:/Users/dylan.kendal/.cargo/bin:/Users/dylan.kendal/.local/bin:/opt/homebrew/bin:/Applications/kitty.app/Contents/MacOS:/Users/dylan.kendal/.nix-profile/bin:/etc/profiles/per-user/dylan.kendal/bin:/run/current-system/sw/bin:/nix/var/nix/profiles/default/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin
hide,MISE_SHELL,
hide,__MISE_DIFF,
hide,__MISE_DIFF,' | parse vars | update-env
  $env.MISE_SHELL = "nu"
  let mise_hook = {
    condition: { "MISE_SHELL" in $env }
    code: { mise_hook }
  }
  add-hook hooks.pre_prompt $mise_hook
  add-hook hooks.env_change.PWD $mise_hook
}

def --env add-hook [field: cell-path new_hook: any] {
  let field = $field | split cell-path | update optional true | into cell-path
  let old_config = $env.config? | default {}
  let old_hooks = $old_config | get $field | default []
  $env.config = ($old_config | upsert $field ($old_hooks ++ [$new_hook]))
}

export def --env --wrapped main [command?: string, --help, ...rest: string] {
  let commands = ["deactivate", "shell", "sh"]

  if ($command == null) {
    ^"/etc/profiles/per-user/dylan.kendal/bin/mise"
  } else if ($command == "activate") {
    $env.MISE_SHELL = "nu"
  } else if ($command in $commands) {
    ^"/etc/profiles/per-user/dylan.kendal/bin/mise" $command ...$rest
    | parse vars
    | update-env
  } else {
    ^"/etc/profiles/per-user/dylan.kendal/bin/mise" $command ...$rest
  }
}

def --env mise_hook [] {
  ^"/etc/profiles/per-user/dylan.kendal/bin/mise" hook-env -s nu
    | parse vars
    | update-env
}

