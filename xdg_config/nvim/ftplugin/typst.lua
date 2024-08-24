vim.api.nvim_create_user_command("Open", [[! open -a skim %:r.pdf]], {
	nargs = 0,
})
