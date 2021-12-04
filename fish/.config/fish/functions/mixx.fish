complete -c mixx -f -a '(ls apps)'

function mixx --description "run mix in an app" -a app
    pushd "apps/$app"
    mix $argv[2..-1]
    popd
end
