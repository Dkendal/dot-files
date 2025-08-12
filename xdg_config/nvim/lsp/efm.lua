---@type vim.lsp.Config
return {
	init_options = { documentFormatting = true },
	settings = {
		rootMarkers = { ".git/", ".jj/" },
		commands = {
		},
		languages = {
			org = {
				{
					formatCommand = [[
						TMP="$(mktemp)" &&
						cat "${INPUT}" > "$TMP" &&
						emacs "${TMP}" \
							--batch \
							--eval "(progn
								(require 'org)
								(find-file (get-env \"TMP\"))
								(org-align-all-tags)
								(org-table-map-tables 'org-table-align t)
								(indent-region (point-min) (point-max))
								(save-buffer))" &&
						cat "$TMP"
					]],
					formatStdin = true
				}
			}
		}
	}
}
