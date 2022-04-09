function compile(src)
    local out = src:gsub("fnl", "lua")

    local flags = table.concat({
        '--add-package-path "/usr/local/share/nvim/runtime/lua/?.lua"',
        '--add-package-path "lua/?.lua"', '--add-fennel-path fnl/?.fnl'
    }, " ")

    tup.definerule({
        inputs = {src},
        command = 'fennel ' .. flags .. ' --compile ' .. src .. ' > ' .. out,
        outputs = {out}
    })
end

compile 'fnl/viper/autocmd.fnl'
compile 'fnl/viper/functions.fnl'
compile 'fnl/viper/list.fnl'
compile 'fnl/viper/registry.fnl'
compile 'fnl/viper/remote.fnl'
compile 'fnl/viper/timers.fnl'
