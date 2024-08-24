complete -c mix_env -a "dev test prod"

function mix_env -d "Change MIX_ENV" -a "env"
    set --export MIX_ENV "$env"
end
