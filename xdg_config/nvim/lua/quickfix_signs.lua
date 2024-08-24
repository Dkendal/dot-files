local V = vim.fn

local qflist = {}

local ns = V.nvim_create_namespace('quickfix_signs')

local function is_qf_visible()
  local tabnr = V.nvim_get_current_tabpage()
  local wins = V.nvim_tabpage_list_wins(tabnr)

  for _, item in ipairs(wins) do
    local all_info = V.getwininfo(item)
    for _, info in ipairs(all_info) do
      if info.quickfix == 1 then
        return true
      end
    end
  end

  return false
end

local function buf_redraw(bufnr)
  vim.api.nvim_buf_clear_namespace(bufnr, ns, 0, -1)

  if is_qf_visible() == false then
    return
  end

  for _, item in ipairs(qflist) do
    if item.bufnr == bufnr then

      local chunks = {}

      local hi = "Comment"

      if item.type == "W" then
        hi = "WarningMsg"
      end

      if item.type == "E" then
        hi = "ErrorMsg"
      end

      if #item.module > 0 then
        table.insert(chunks, {item.module, hi})
      end

      if #item.text > 0 then
        table.insert(chunks, {item.text, hi})
      end

      vim.api.nvim_buf_set_virtual_text(bufnr, ns, item.lnum - 1, chunks, {})
    end
  end
end

local function bufenter(bufnr)
  buf_redraw(bufnr)
end

local function quickfixpost(bufnr)
  qflist = {}

  for _, item in ipairs(vim.api.nvim_call_function('getqflist', {})) do
    if item.bufnr > 0 and item.valid then
      table.insert(qflist, item)
    end
  end

  buf_redraw(bufnr)
end

return {
  bufenter = bufenter;
  quickfixpost = quickfixpost;
}
