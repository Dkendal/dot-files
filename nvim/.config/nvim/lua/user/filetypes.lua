vim.g.do_filetype_lua = 1

vim.filetype.add({
	extension = {
		rkt = "racket",
	},
	filename = {
		WORKSPACE = "bzl",
		[".swcrc"] = "json",
		BUILD = "bzl",
		Earthfile = "Earthfile",
		["tsconfig.json"] = "jsonc",
	},
	pattern = {},
})

