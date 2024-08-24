local M = require("user.package")

describe("github_url", function()
	it("works", function()
		assert.are.equal(M.github_url("dkendal/nvim-treesitter"), "git@github.com:dkendal/nvim-treesitter.git")
	end)
end)

describe("clone_dir", function()
	it("works", function()
		assert.are.equal(M.clone_dir("dkendal/nvim-treesitter"), "~/.config/nvim/pack/dkendal/opt/nvim-treesitter")
	end)
end)

describe("pack_name", function()
	it("returns the basename", function()
		assert.are.equal(M.pack_name("dkendal/nvim-treesitter"), "nvim-treesitter")
	end)

	it("just returns the name if there's no /", function()
		assert.are.equal(M.pack_name("nvim-treesitter"), "nvim-treesitter")
	end)
end)

describe("package_install_cmd", function()
	it("works", function()
		assert.are.equal(
			M.package_install_cmd("dkendal/nvim-treesitter"),
			[[git clone git@github.com:dkendal/nvim-treesitter.git ~/.config/nvim/pack/dkendal/opt/nvim-treesitter --depth=1]]
		)
	end)
end)
