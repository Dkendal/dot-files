---@type LazyPluginSpec
return
{
	dir = "~/src/dkendal/nvim-treeclimber",
	opts = {
		highlight = 80,
	},
	keys = {
		-- Core navigation
		{
			"<M-h>",
			"<Plug>(treeclimber-select-previous)",
			mode = { "n", "x", "o" },
			desc = "Select previous node",
		},
		{
			"<M-l>",
			"<Plug>(treeclimber-select-next)",
			mode = { "n", "x", "o" },
			desc = "Select next node",
		},
		{
			"<M-k>",
			"<Plug>(treeclimber-select-parent)",
			mode = { "n", "x", "o" },
			desc = "Select parent node",
		},
		{
			"<M-j>",
			"<Plug>(treeclimber-select-shrink)",
			mode = { "n", "x", "o" },
			desc = "Select child node",
		},
		-- Growth selection
		{
			"<M-H>",
			"<Plug>(treeclimber-select-grow-backward)",
			mode = { "n", "x", "o" },
			desc = "Grow selection backward",
		},
		{
			"<M-L>",
			"<Plug>(treeclimber-select-grow-forward)",
			mode = { "n", "x", "o" },
			desc = "Grow selection forward",
		},
		-- Sibling navigation
		{
			"<M-[>",
			"<Plug>(treeclimber-select-siblings-backward)",
			mode = { "n", "x", "o" },
			desc = "Select first sibling",
		},
		{
			"<M-]>",
			"<Plug>(treeclimber-select-siblings-forward)",
			mode = { "n", "x", "o" },
			desc = "Select last sibling",
		},
		-- Top level
		{
			"<M-g>",
			"<Plug>(treeclimber-select-top-level)",
			mode = { "n", "x", "o" },
			desc = "Select top-level node",
		},
		-- Movement selection
		{
			"<M-b>",
			"<Plug>(treeclimber-select-backward)",
			mode = { "n", "x", "o" },
			desc = "Select and move to node start",
		},
		{
			"<M-e>",
			"<Plug>(treeclimber-select-forward-end)",
			mode = { "n", "x", "o" },
			desc = "Select and move to node end",
		},
		-- Visual/operator mode specific
		{
			"i.",
			"<Plug>(treeclimber-select-current-node)",
			mode = { "x", "o" },
			desc = "Select current node (inner)",
		},
		{
			"a.",
			"<Plug>(treeclimber-select-expand)",
			mode = { "x", "o" },
			desc = "Select parent node (around)",
		},
		-- Commands
		{
			"<leader>k",
			"<Plug>(treeclimber-show-control-flow)",
			mode = "n",
			desc = "Show control flow",
		},
	},
	cmd = { "TCDiffThis", "TCShowControlFlow", "TCHighlightExternalDefinitions" },
}
