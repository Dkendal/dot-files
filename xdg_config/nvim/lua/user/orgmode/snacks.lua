---@module 'snacks'

local M = {}


-- Optional keymap
-- vim.keymap.set("n", "<leader>qd", insert_quill_doc, { desc = "Insert latest Quill doc" })

function M.insert_person()
  local people_path = vim.env.HOME .. '/orgfiles/people/'
  local result = vim.system({ 'fd', '\\.org$', people_path }, { text = true }):wait()

  if result.code ~= 0 then
    vim.notify(result.stderr, vim.diagnostic.severity.ERROR)
    return
  end


  local items = vim.iter(vim.split(result.stdout, "\n"))
      :filter(function(x) return vim.trim(x) ~= "" end)
      :totable()

  return require("snacks").picker.select(items, {
      prompt = "Contact > ",
      format_item = function(item)
        return vim.fs.basename(item):gsub("%.org$", "")
      end,
    },
    function(item)
      if not item then
        return
      end
      local f = vim.fs.basename(item):gsub("%.org$", "")
      local text = "[[people:" .. f .. "][@" .. f .. "]]"
      vim.api.nvim_put({ text }, "c", true, true)
    end
  )
end

function M.insert_headline()
  local items = vim.iter(require("orgmode.api").load())
      :map(function(item)
        ---@cast item OrgApiFile
        return item.headlines
      end)
      :flatten()
      :enumerate()
      :map(function(idx, item)
        ---@cast item OrgApiHeadline
        ---@type snacks.picker.finder.Item
        return {
          idx = idx,
          file = item.file.filename,
          text = item.line,
          pos = { item.position.start_line, item.position.start_col },
          end_pos = { item.position.end_line, item.position.end_col }
        }
      end)
      :totable()

  return Snacks.picker.pick({
    source = "Org headline",
    items = items,
    format = function(x)
      return {
        { vim.fn.pathshorten(x.file) },
        { ":",                       "SnacksPickerDelim" },
        { tostring(x.pos[1]),        "SnacksPickerRow" },
        { ":",                       "SnacksPickerDelim" },
        { tostring(x.pos[2]),        "SnacksPickerCol" },
        { " -> ",                    "SnacksPickerDelim" },
        { x.text }
      }
    end,
    confirm = function(picker)
      picker:close()

      local current = picker:current()

      if current == nil then
        return
      end

      vim.print(vim.inspect(current))
    end
  })
end

function M.insert_file()
  local items = vim.iter(require("orgmode.api").load())
      :enumerate()
      :map(function(idx, item)
        ---@type snacks.picker.finder.Item
        return {
          idx = idx,
          file = item.filename,
          text = item.filename
        }
      end)
      :totable()

  return Snacks.picker.pick({
    source = "Org file",
    items = items,
    transform = function(item)
      item.text = item.text
          :gsub("^" .. vim.env.HOME .. "/orgfiles/", "")
          :gsub(".org$", "")

      return item
    end,
    confirm = function(picker)
      picker:close()

      local current = picker:current()

      if current == nil then
        return
      end

      local line = "[[" .. current.file .. "][" .. current.text .. "]]"

      vim.api.nvim_put({ line }, "c", true, true)
    end
  })
end

function M.picker_orgmode_grep()
  return Snacks.picker.grep({ cwd = "~/orgfiles", ft = "org", cmd = "rg" })
end

function M.picker_orgmode_headlines()
  return Snacks.picker.grep({ cwd = "~/orgfiles", ft = "org", cmd = "rg", args = { "-e", "^\\*", "." } })
end

return M
