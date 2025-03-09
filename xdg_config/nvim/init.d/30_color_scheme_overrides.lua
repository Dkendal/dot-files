local hi = require("user.highlight")

local function setup()
end

vim.api.nvim_create_autocmd({ "ColorScheme" }, {
	pattern = "*",
	callback = setup,
})
