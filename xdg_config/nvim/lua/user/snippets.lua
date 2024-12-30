local dedent = require('user.snippet_support').dedent

local function process_snippets(snippets)
	local out = {}

	for _, s in ipairs(snippets) do
		assert(type(s.trigger) == 'string', 'trigger must be a string')
		assert(type(s.body) == 'string', 'body must be a string')
		table.insert(out, {
			trigger = s.trigger,
			body = dedent(s.body),
		})
	end

	return out
end

local M = {}

local global_snippets = {
	{
		trigger = 'hello',
		body = 'Hello, ${1:world}!',
	}
}

local snippets_by_filetype = {
	lua = {
		{
			trigger = "aug",
			body = dedent [[
				local group = vim.api.nvim_create_augroup("${1:group_name}", { clear = true })
			]],
		},
		{
			trigger = "snip",
			body = dedent [[
				{
					trigger = "${1:trigger}",
					body = "${2:body}",
				}
			]],
		}
	},
	elixir = process_snippets(require("user.snippets.elixir")),
	rust =
	{
		{
			trigger = 'p',
			body = [[println!("$1");]]
		},
		{
			trigger = 'i',
			body = [[dbg!($1);]]
		},
		{
			trigger = '.c',
			body = [[.collect::<Vec<_>>()]]
		},
		{
			trigger = 'f',
			body = [[format!("{}", $1);]]
		},
		{
			trigger = 'd',
			body = [[Default::default()]]
		},
		{
			trigger = 't',
			body = [[todo!($1);]]
		},
		{
			trigger = 'pa',
			body = [[panic!($1);]]
		},
		{
			trigger = 'u',
			body = [[unreachable!($1);]]
		}
	}
}

local function get_buf_snips()
	local ft = vim.bo.filetype
	local snips = vim.list_slice(global_snippets)

	if ft and snippets_by_filetype[ft] then
		vim.list_extend(snips, snippets_by_filetype[ft])
	end

	return snips
end

-- cmp source for snippets to show up in completion menu

function M.setup()
	local cmp_source = {}
	local cache = {}

	function cmp_source.complete(_, _, callback)
		local bufnr = vim.api.nvim_get_current_buf()

		if not cache[bufnr] then
			local completion_items = vim.tbl_map(function(s)
				---@type lsp.CompletionItem
				local item = {
					word = s.trigger,
					label = s.trigger,
					kind = vim.lsp.protocol.CompletionItemKind.Snippet,
					insertText = s.body,
					insertTextFormat = vim.lsp.protocol.InsertTextFormat.Snippet,
				}
				return item
			end, get_buf_snips())

			cache[bufnr] = completion_items
		end

		callback(cache[bufnr])
	end

	require('cmp').register_source('user_snippets', cmp_source)
end

return M
