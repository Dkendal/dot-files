local cmp = require("cmp")
local lspkind = require("lspkind")

local function format(_, vim_item)
	vim_item.kind = lspkind.presets.default[vim_item.kind]
	return vim_item
end

local config = {
	snippet = {
		expand = function(args)
			require("luasnip").lsp_expand(args.body)
		end,
	},
	mapping = {
		["<C-y>"] = cmp.mapping.confirm({ select = true }),
		["<C-g>"] = cmp.mapping.abort(),
		["<C-c>"] = cmp.mapping.abort(),
		["<C-Space>"] = cmp.mapping.complete(),
		["<C-d>"] = cmp.mapping.scroll_docs(-4),
		["<C-u>"] = cmp.mapping.scroll_docs(4),
		["<CR>"] = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true }),
	},
	formatting = { format = format },
	sources = {
		{ name = "nvim_lsp" },
		{ name = "nvim_lua" },
		{ name = "luasnip" },
		{ name = "orgmode" },
		{ name = "path" },
		{ name = "emoji" },
		{ name = "calc" },
	},
}

cmp.setup(config)
