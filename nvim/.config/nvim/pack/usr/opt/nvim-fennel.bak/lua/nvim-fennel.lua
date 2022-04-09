local fennel = require 'fennel'

debug.traceback = fennel.traceback

_G.fennel = fennel

table.insert(package.loaders or package.searchers, fennel.searcher)

function init.update_fennel_runtime_path()
    -- Replicate what vim does to allow loading fnl modules
    fennel.path = ""

    for _, p in ipairs(vim.split(vim.o.runtimepath, ',')) do
        fennel.path = fennel.path .. ';' .. p .. '/fnl/?.fnl' .. ';' .. p ..
                          '/fnl/?/index.fnl'
    end

    fennel["macro-path"] = fennel.path
end

init.update_fennel_runtime_path()
