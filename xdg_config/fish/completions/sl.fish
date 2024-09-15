
function __fish_sl_needs_command
    set cmd (commandline -opc)
    if [ (count $cmd) -eq 1 -a $cmd[1] = 'sl' ]
        return 0
    end
    return 1
end

function __fish_sl_using_command
    set cmd (commandline -opc)
    if [ (count $cmd) -gt 1 ]
        if [ $argv[1] = $cmd[2] ]
            return 0
        end
    end
    return 1
end

# Main command completions
complete -f -c sl -n '__fish_sl_needs_command' -a pull -d 'Pull commits from the specified source'
complete -f -c sl -n '__fish_sl_needs_command' -a show -d 'Show commit in detail'
complete -f -c sl -n '__fish_sl_needs_command' -a diff -d 'Show differences between commits'
complete -f -c sl -n '__fish_sl_needs_command' -a goto -d 'Update working copy to a given commit'
complete -f -c sl -n '__fish_sl_needs_command' -a status -d 'List files with pending changes'
complete -f -c sl -n '__fish_sl_needs_command' -a add -d 'Start tracking the specified files'
complete -f -c sl -n '__fish_sl_needs_command' -a remove -d 'Delete the specified tracked files'
complete -f -c sl -n '__fish_sl_needs_command' -a forget -d 'Stop tracking the specified files'
complete -f -c sl -n '__fish_sl_needs_command' -a revert -d 'Change the specified files to match a commit'
complete -f -c sl -n '__fish_sl_needs_command' -a purge -d 'Delete untracked files'
complete -f -c sl -n '__fish_sl_needs_command' -a shelve -d 'Save pending changes and revert working copy to a clean state'
complete -f -c sl -n '__fish_sl_needs_command' -a commit -d 'Save all pending changes or specified files in a new commit'
complete -f -c sl -n '__fish_sl_needs_command' -a amend -d 'Meld pending changes into the current commit'
complete -f -c sl -n '__fish_sl_needs_command' -a metaedit -d 'Edit commit message and other metadata'
complete -f -c sl -n '__fish_sl_needs_command' -a rebase -d 'Move commits from one location to another'
complete -f -c sl -n '__fish_sl_needs_command' -a graft -d 'Copy commits from a different location'
complete -f -c sl -n '__fish_sl_needs_command' -a hide -d 'Hide commits and their descendants'
complete -f -c sl -n '__fish_sl_needs_command' -a unhide -d 'Unhide commits and their ancestors'
complete -f -c sl -n '__fish_sl_needs_command' -a previous -d 'Check out an ancestor commit'
complete -f -c sl -n '__fish_sl_needs_command' -a next -d 'Check out a descendant commit'
complete -f -c sl -n '__fish_sl_needs_command' -a split -d 'Split a commit into smaller commits'
complete -f -c sl -n '__fish_sl_needs_command' -a fold -d 'Combine multiple commits into a single commit'
complete -f -c sl -n '__fish_sl_needs_command' -a histedit -d 'Interactively reorder, combine, or delete commits'
complete -f -c sl -n '__fish_sl_needs_command' -a absorb -d 'Intelligently integrate pending changes into current stack'
complete -f -c sl -n '__fish_sl_needs_command' -a uncommit -d 'Uncommit part or all of the current commit'
complete -f -c sl -n '__fish_sl_needs_command' -a unamend -d 'Undo the last amend operation on the current commit'
complete -f -c sl -n '__fish_sl_needs_command' -a undo -d 'Undo the last local command'
complete -f -c sl -n '__fish_sl_needs_command' -a redo -d 'Undo the last undo'
complete -f -c sl -n '__fish_sl_needs_command' -a config -d 'Show config settings'
complete -f -c sl -n '__fish_sl_needs_command' -a doctor -d 'Attempt to check and fix issues'
complete -f -c sl -n '__fish_sl_needs_command' -a grep -d 'Search for a pattern in tracked files in the working directory'
complete -f -c sl -n '__fish_sl_needs_command' -a journal -d 'Show the history of the checked out commit or a bookmark'
complete -f -c sl -n '__fish_sl_needs_command' -a web -d 'Launch Sapling Web GUI on localhost'

# Help topics
complete -f -c sl -n '__fish_sl_needs_command' -a help -d 'Show help for a command or topic'
complete -f -c sl -n '__fish_sl_using_command help' -a 'commands filesets glossary patterns revisions templating' -d 'Help topic'

# File completion for commands that typically operate on files
complete -F -c sl -n '__fish_sl_using_command add'
complete -F -c sl -n '__fish_sl_using_command remove'
complete -F -c sl -n '__fish_sl_using_command forget'
complete -F -c sl -n '__fish_sl_using_command revert'
complete -F -c sl -n '__fish_sl_using_command commit'

# Main command completions
complete -f -c sl -n '__fish_sl_needs_command goto' -a goto -d 'Update working copy to a given commit'
complete -f -c sl -n '__fish_sl_needs_command goto' -a go -d 'Alias for goto'

# Option completions
complete -f -c sl -n '__fish_sl_using_command goto; or __fish_sl_using_command go' -s C -l clean -d 'Discard uncommitted changes (no backup)'
complete -f -c sl -n '__fish_sl_using_command goto; or __fish_sl_using_command go' -s c -l check -d 'Require clean working copy'
complete -f -c sl -n '__fish_sl_using_command goto; or __fish_sl_using_command go' -s m -l merge -d 'Merge uncommitted changes'
complete -f -c sl -n '__fish_sl_using_command goto; or __fish_sl_using_command go' -s r -l rev -d 'Revision' -a '(sl log --template "{node|short}\t{desc|firstline}\n")'
complete -f -c sl -n '__fish_sl_using_command goto; or __fish_sl_using_command go' -l inactive -d 'Update without activating bookmarks'
complete -f -c sl -n '__fish_sl_using_command goto; or __fish_sl_using_command go' -s B -l bookmark -d 'Create new bookmark' -a '(sl bookmarks --template "{bookmark}\n")'
complete -f -c sl -n '__fish_sl_using_command goto; or __fish_sl_using_command go' -s t -l tool -d 'Specify merge tool' -a 'vimdiff kdiff3 meld'

complete -c sl -n '__fish_seen_subcommand_from pr' -a 'submit' -d 'Create or update GitHub pull requests from local commits'
complete -c sl -n '__fish_seen_subcommand_from pr' -a 'pull' -d 'Import a pull request into your working copy'
complete -c sl -n '__fish_seen_subcommand_from pr' -a 'follow' -d 'Join the nearest descendant\'s pull request'
complete -c sl -n '__fish_seen_subcommand_from pr' -a 'link' -d 'Identify a commit as the head of a GitHub pull request'
complete -c sl -n '__fish_seen_subcommand_from pr' -a 'unlink' -d 'Remove a commit\'s association with a GitHub pull request'
complete -c sl -n '__fish_seen_subcommand_from pr' -a 'list' -d 'List GitHub pull requests with gh pr list [flags]'

# Fish shell completion for 'sl pull' command

# Option completions
complete -f -c sl -n '__fish_sl_using_command pull' -s u -l update -d 'Update to new branch head if new descendants were pulled'
complete -f -c sl -n '__fish_sl_using_command pull' -s f -l force -d 'Run even when remote repository is unrelated'
complete -f -c sl -n '__fish_sl_using_command pull' -s r -l rev -d 'A remote commit to pull' -a '(sl log --template "{node|short}\t{desc|firstline}\n")' -x
complete -f -c sl -n '__fish_sl_using_command pull' -s B -l bookmark -d 'A bookmark to pull' -a '(sl bookmarks --template "{bookmark}\n")' -x
complete -f -c sl -n '__fish_sl_using_command pull' -l rebase -d 'Rebase current commit or current stack onto master'
complete -f -c sl -n '__fish_sl_using_command pull' -s t -l tool -d 'Specify merge tool for rebase' -a 'vimdiff kdiff3 meld' -x
complete -f -c sl -n '__fish_sl_using_command pull' -s d -l dest -d 'Destination for rebase or update' -a '(sl bookmarks --template "{bookmark}\n")' -x

# Source completion
complete -f -c sl -n '__fish_sl_using_command pull' -a '(sl paths --template "{name}\n")' -d 'Pull source'

# Help option
complete -f -c sl -n '__fish_sl_using_command pull' -l help -d 'Show help for pull command'
complete -f -c sl -n '__fish_sl_using_command pull' -l verbose -d 'Show complete help'
#
# Fish shell completion for 'sl diff' command

# Main command completion
complete -f -c sl -n '__fish_sl_needs_command' -a diff -d 'Show differences between commits'
complete -f -c sl -n '__fish_sl_needs_command' -a d -d 'Alias for diff'

# Option completions
complete -f -c sl -n '__fish_sl_using_command diff; or __fish_sl_using_command d' -s r -l rev -d 'Revision' -a '(sl log --template "{node|short}\t{desc|firstline}\n")' -x
complete -f -c sl -n '__fish_sl_using_command diff; or __fish_sl_using_command d' -s c -l change -d 'Change made by revision' -a '(sl log --template "{node|short}\t{desc|firstline}\n")' -x
complete -f -c sl -n '__fish_sl_using_command diff; or __fish_sl_using_command d' -s a -l text -d 'Treat all files as text'
complete -f -c sl -n '__fish_sl_using_command diff; or __fish_sl_using_command d' -s g -l git -d 'Use git extended diff format'
complete -f -c sl -n '__fish_sl_using_command diff; or __fish_sl_using_command d' -l binary -d 'Generate binary diffs in git mode (default)'
complete -f -c sl -n '__fish_sl_using_command diff; or __fish_sl_using_command d' -l nodates -d 'Omit dates from diff headers'
complete -f -c sl -n '__fish_sl_using_command diff; or __fish_sl_using_command d' -l noprefix -d 'Omit a/ and b/ prefixes from filenames'
complete -f -c sl -n '__fish_sl_using_command diff; or __fish_sl_using_command d' -s p -l show-function -d 'Show which function each change is in'
complete -f -c sl -n '__fish_sl_using_command diff; or __fish_sl_using_command d' -l reverse -d 'Produce a diff that undoes the changes'
complete -f -c sl -n '__fish_sl_using_command diff; or __fish_sl_using_command d' -s w -l ignore-all-space -d 'Ignore white space when comparing lines'
complete -f -c sl -n '__fish_sl_using_command diff; or __fish_sl_using_command d' -s b -l ignore-space-change -d 'Ignore changes in the amount of white space'
complete -f -c sl -n '__fish_sl_using_command diff; or __fish_sl_using_command d' -s B -l ignore-blank-lines -d 'Ignore changes whose lines are all blank'
complete -f -c sl -n '__fish_sl_using_command diff; or __fish_sl_using_command d' -s Z -l ignore-space-at-eol -d 'Ignore changes in whitespace at EOL'
complete -f -c sl -n '__fish_sl_using_command diff; or __fish_sl_using_command d' -s U -l unified -d 'Number of lines of context to show' -x
complete -f -c sl -n '__fish_sl_using_command diff; or __fish_sl_using_command d' -l stat -d 'Output diffstat-style summary of changes'
complete -f -c sl -n '__fish_sl_using_command diff; or __fish_sl_using_command d' -l root -d 'Produce diffs relative to subdirectory' -r
complete -f -c sl -n '__fish_sl_using_command diff; or __fish_sl_using_command d' -l only-files-in-revs -d 'Only show changes for files modified in the requested revisions'
complete -f -c sl -n '__fish_sl_using_command diff; or __fish_sl_using_command d' -s I -l include -d 'Include files matching the given patterns' -r
complete -f -c sl -n '__fish_sl_using_command diff; or __fish_sl_using_command d' -s X -l exclude -d 'Exclude files matching the given patterns' -r
complete -f -c sl -n '__fish_sl_using_command diff; or __fish_sl_using_command d' -s s -l sparse -d 'Only show changes in files in the sparse config'

# File completion
complete -f -c sl -n '__fish_sl_using_command diff; or __fish_sl_using_command d' -a '(__fish_complete_path)' -d 'File'

# Help options
complete -f -c sl -n '__fish_sl_using_command diff; or __fish_sl_using_command d' -l help -d 'Show help for diff command'
complete -f -c sl -n '__fish_sl_using_command diff; or __fish_sl_using_command d' -l verbose -d 'Show complete help'

# Fish shell completion for 'sl pr' command

# Main command completion
complete -f -c sl -n '__fish_sl_needs_command' -a pr -d 'Exchange local commit data with GitHub pull requests'

# Subcommand completions
complete -f -c sl -n '__fish_sl_using_command pr' -a submit -d 'Create or update GitHub pull requests from local commits'
complete -f -c sl -n '__fish_sl_using_command pr' -a pull -d 'Import a pull request into your working copy'
complete -f -c sl -n '__fish_sl_using_command pr' -a follow -d 'Join the nearest descendant\'s pull request'
complete -f -c sl -n '__fish_sl_using_command pr' -a link -d 'Identify a commit as the head of a GitHub pull request'
complete -f -c sl -n '__fish_sl_using_command pr' -a unlink -d 'Remove a commit\'s association with a GitHub pull request'
complete -f -c sl -n '__fish_sl_using_command pr' -a list -d 'Call \'gh pr list [flags]\' with the current repo'

# Help options
complete -f -c sl -n '__fish_sl_using_command pr' -l help -d 'Show help for pr command'
complete -f -c sl -n '__fish_sl_using_command pr' -l verbose -d 'Show complete help'

# Subcommand-specific completions

# 'sl pr submit' completions
complete -f -c sl -n '__fish_sl_using_command pr; and __fish_seen_subcommand_from submit' -l help -d 'Show help for pr submit command'

# 'sl pr pull' completions
complete -f -c sl -n '__fish_sl_using_command pr; and __fish_seen_subcommand_from pull' -l help -d 'Show help for pr pull command'

# 'sl pr follow' completions
complete -f -c sl -n '__fish_sl_using_command pr; and __fish_seen_subcommand_from follow' -l help -d 'Show help for pr follow command'

# 'sl pr link' completions
complete -f -c sl -n '__fish_sl_using_command pr; and __fish_seen_subcommand_from link' -l help -d 'Show help for pr link command'

# 'sl pr unlink' completions
complete -f -c sl -n '__fish_sl_using_command pr; and __fish_seen_subcommand_from unlink' -l help -d 'Show help for pr unlink command'

# 'sl pr list' completions
complete -f -c sl -n '__fish_sl_using_command pr; and __fish_seen_subcommand_from list' -l help -d 'Show help for pr list command'
# Note: You might want to add more specific completions for 'list' based on the 'gh pr list' command options
