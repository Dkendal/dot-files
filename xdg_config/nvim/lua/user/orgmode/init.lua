local M = {}

function M.insert_most_recent_quill_doc()
  local cmd = {
    "nu",
    "-c",
    [[
    let path = ls ~/Documents/Quill/ | sort-by modified | last | get name;
    pandoc $path -t org --wrap auto -s --lua-filter ~/dot-files/pandoc/remove-id.lua
    ]]
  }

  -- Run synchronously and capture output
  local result = vim.system(cmd):wait()

  if result.code ~= 0 then
    vim.notify("Failed to run Nushell command:\n" .. (result.stderr or ""), vim.log.levels.ERROR)
    return
  end

  -- Split into lines for Neovim's buffer API
  local lines = vim.split(result.stdout or "", "\n", { plain = true })

  -- Insert at current cursor
  local row = vim.api.nvim_win_get_cursor(0)[1] - 1
  vim.api.nvim_buf_set_lines(0, row, row, false, lines)
end

return M
