local lspconfig = require('lspconfig')
local util = require('lspconfig/util')

function assign(...) return vim.tbl_extend('force', ...) end

vim.lsp.set_log_level(3)

local lsp_status = require('lsp-status')

lsp_status.register_progress()

-- Use an on_attach function to only map the following keys 
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
    lsp_status.on_attach(client, bufnr)

    local function bmap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
    local function bopt(...) vim.api.nvim_buf_set_option(bufnr, ...) end

    -- Enable completion triggered by <c-x><c-o>
    -- bopt('omnifunc', 'v:lua.vim.lsp.omnifunc')

    -- Mappings.
    local opts = {noremap = true, silent = true, noremap = true}

    -- See `:help vim.lsp.*` for documentation on any of the below functions
    bmap('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
    bmap('n', 'gO', '<Cmd>lua vim.lsp.buf.document_symbol()<CR>', opts)
    bmap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
    bmap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
    bmap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
    bmap('i', '<C-h>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
    bmap('n', '<space>Wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>',
         opts)
    bmap('n', '<space>Wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>',
         opts)
    bmap('n', '<space>Wl',
         '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>',
         opts)
    bmap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
    bmap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
    bmap('n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
    bmap('v', '<space>ca', '<cmd>lua vim.lsp.buf.range_code_action()<CR>', opts)
    bmap('n', '<c-.>', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
    bmap('v', '<c-.>', '<cmd>lua vim.lsp.buf.range_code_action()<CR>', opts)
    -- bmap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
    bmap('n', 'gr', '<cmd>TroubleToggle lsp_references<CR>', opts)
    bmap('n', '<space>ee',
         '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
    bmap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
    bmap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
    -- bmap('n', '<space>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
    bmap('n', '<space>F', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)
end

local capabilities = lsp_status.capabilities

capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)

local opts = {
    autostart = true,
    on_attach = on_attach,
    capabilities = capabilities
}

-- by way of vsnip
opts.capabilities.textDocument.completion.completionItem.snippetSupport = true

lspconfig.tsserver.setup(assign(opts, {
    verbose = true,
    settings = {
        typescript = {
            preferences = {
                importModuleSpecifierPreference = 'relative',
                provideRefactorNotApplicableReason = true
            }
        }
    },
    flags = {debounce_text_changes = 500}
}))

lspconfig.racket_langserver.setup({
    cmd = {'racket', '--lib', 'racket-langserver'},
    filetypes = {'racket', 'scheme'},
    single_file_support = true
})

lspconfig.pyright.setup(assign(opts, {
    cmd = {
        '/home/dylan/.asdf/installs/nodejs/16.4.2/bin/node',
        '/home/dylan/.asdf/installs/nodejs/16.4.2/.npm/bin/pyright-langserver',
        "--stdio"
    }
}))

lspconfig.jsonls.setup(assign(opts, {
    cmd = {
        '/home/dylan/.asdf/installs/nodejs/16.4.2/bin/node',
        '/home/dylan/.asdf/installs/nodejs/16.4.2/.npm/bin/vscode-json-language-server',
        "--stdio"
    },
    settings = {
        json = {
            schemas = {
                {
                    fileMatch = {"package.json"},
                    url = "https://json.schemastore.org/package.json"
                }, {
                    fileMatch = {"tsconfig.json", "tsconfig*.json"},
                    url = "https://json.schemastore.org/tsconfig"
                }
            }
        }
    }
}))

lspconfig.efm.setup(assign(opts, {}))

lspconfig.clangd.setup(assign(opts, {}))

lspconfig.elixirls.setup(assign(opts, {
    cmd = {'/home/dylan/.elixir-ls/release/language_server.sh'}
}))

lspconfig.efm.setup(assign(opts, {
    init_options = {documentFormatting = true},
    filetypes = {
        'vim',
        'markdown', 'fennel', 'lua', 'javascript', 'javascriptreact',
        'typescript', 'typescriptreact', 'json', 'html', 'css', 'elixir', 'vcl'
    },
    -- single_file_support = true,
    settings = {
        logLevel = 8,
        logFile = "/tmp/efm.log",
        languages = {
            vcl = {
                {
                    lintCommand = 'varnishd -C -f',
                    lintFormats = {
                        '%EMessage from VCC-compiler',
                        '%C(\'%f\' Line %l Pos %c)',
                        '%CAt: (\'%f\' Line %l Pos %c) -- %s', '%C  %.%#',
                        '%E%m', '%Z--%.%#'
                    }
                }
            },
            elixir = {
                {
                    lintCommand = 'mix-failed --vimgrep',
                    lintFormats = {'%f:%l: %m'}
                }
            },
            lua = {{formatCommand = 'lua-format -i', formatStdin = true}},
            fennel = {
                {
                    lintCommand = 'fennel --globals vim,jit,unpack --compile',
                    lintFormats = {'%f:%l'}
                }
            },
            bash = {
                {
                    lintCommand = "shellcheck -f gcc -x",
                    lintSource = "shellcheck",
                    lintFormats = {
                        '%f:%l:%c: %trror: %m', '%f:%l:%c: %tarning: %m',
                        '%f:%l:%c: %tote: %m'
                    }
                }
            },
            sh = {
                {
                    lintCommand = "shellcheck -f gcc -x",
                    lintSource = "shellcheck",
                    lintFormats = {
                        '%f:%l:%c: %trror: %m', '%f:%l:%c: %tarning: %m',
                        '%f:%l:%c: %tote: %m'
                    }
                }
            }
        }
    }
}))
