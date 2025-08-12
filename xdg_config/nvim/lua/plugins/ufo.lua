---@type LazyPluginSpec
return {
		"kevinhwang91/nvim-ufo",
		lazy = false,
		dependencies = {
			"kevinhwang91/promise-async",
		},
		config = function()
			local ufo_handler = function(virtText, lnum, endLnum, width, truncate)
				local newVirtText = {}
				local suffix = (" 󰁂 %d "):format(endLnum - lnum)
				local sufWidth = vim.fn.strdisplaywidth(suffix)
				local targetWidth = width - sufWidth
				local curWidth = 0
				for _, chunk in ipairs(virtText) do
					local chunkText = chunk[1]
					local chunkWidth = vim.fn.strdisplaywidth(chunkText)
					if targetWidth > curWidth + chunkWidth then
						table.insert(newVirtText, chunk)
					else
						chunkText = truncate(chunkText, targetWidth - curWidth)
						local hlGroup = chunk[2]
						table.insert(newVirtText, { chunkText, hlGroup })
						chunkWidth = vim.fn.strdisplaywidth(chunkText)
						-- str width returned from truncate() may less than 2nd argument, need padding
						if curWidth + chunkWidth < targetWidth then
							suffix = suffix .. (" "):rep(targetWidth - curWidth - chunkWidth)
						end
						break
					end
					curWidth = curWidth + chunkWidth
				end
				table.insert(newVirtText, { suffix, "MoreMsg" })
				return newVirtText
			end

			require("ufo").setup({
				preview = {
					win_config = {
						border = { "", "─", "", "", "", "─", "", "" },
						winblend = 0,
					},
				},
				fold_virt_text_handler = ufo_handler,
				provider_selector = function(_bufnr, _filetype, _buftype)
					return { "treesitter", "indent" }
				end,
			})
		end,
		keys = {
			{ "zR", function() require("ufo").openAllFolds() end,  mode = "n" },
			{ "zM", function() require("ufo").closeAllFolds() end, mode = "n" },
			{ "zr", function() require("ufo").openFoldsExceptKinds() end,  mode = "n" },
			{ "zm", function() require("ufo").closeFoldsWith() end, mode = "n" },
		}
	}
