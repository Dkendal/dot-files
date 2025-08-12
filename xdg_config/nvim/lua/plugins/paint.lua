local function org_todo_kw(kw, hl)
	return {
				filter = { filetype = "orgagenda" },
				pattern = [[^.:%s*(]] .. kw .. [[)]],
				hl = hl
			},
			{
				filter = { filetype = "org" },
				pattern = [[%*+%s*(]] .. kw .. [[)]],
				hl = hl,
			}
end

--- @module 'lazy'
--- @type LazyPluginSpec
return {
	"folke/paint.nvim",
	opts = {
		highlights = {
			-- org_todo_kw('TODO', '@comment.info'),
			-- org_todo_kw('CANCELLED', '@comment.error'),
			-- org_todo_kw('DONE', '@comment.todo'),
			{
				filter = { filetype = "fugitive" },
				pattern = "^M",
				hl = "DiffChange",
			},
			{
				filter = { filetype = "fugitive" },
				pattern = "^A",
				hl = "DiffAdd",
			},
			{
				filter = { filetype = "fugitive" },
				pattern = "^D",
				hl = "DiffDelete",
			},
		},
	},
}
