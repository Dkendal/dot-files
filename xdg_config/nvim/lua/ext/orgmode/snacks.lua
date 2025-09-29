---@module 'snacks'

local M = {}

local cwd = "~/"

local rules = {
  org_headline_with_id = {
    language = "org",
    id = "org-headlines-with-id",
    rule = {
      kind = "section",
      all = {
        {
          has = {
            field = "headline",
            has = {
              field = "item",
              pattern = "$HEADLINE_ITEM",
            },
          },
        },
        {
          has = {
            kind = "property_drawer",
            has = {
              kind = "property",
              all = {
                {
                  has = {
                    field = "name",
                    regex = "ID",
                  },
                },
                {
                  has = {
                    field = "value",
                    pattern = "$ID",
                  },
                },
              },
            },
          },
        },
      },
    },
  },
  org_todos = {
    language = "org",
    id = "org-todo-headlines",
    rule = {
      kind = "section",
      all = {
        {
          has = {
            field = "headline",
            has = {
              field = "item",
              regex = "TODO .*",
              pattern = "$TEXT"
            },
          },
        },
      },
    },
  }
}

local function format_org(item, picker)
  local format = require("snacks.picker.format")
  local highlight = require("snacks.picker.util.highlight")

  ---@type snacks.picker.Highlight[]
  local ret = {}

  vim.list_extend(ret, format.file(item, picker))
  highlight.format(item, item.text, ret)

  return ret
end

local function transform_ast_grep(item)
  ---@type astgrep.Item
  local data = vim.json.decode(item.text)
  local file = vim.fs.joinpath(cwd, data.file)

  ---@type snacks.picker.finder.Item
  return {
    file = file,
    text = data.text,
    severity = data.severity,
    pos = {
      data.range.start.line + 1,
      data.range.start.column,
    },
    end_pos = {
      data.range["end"].line + 1,
      data.range["end"].column,
    },
    labels = data.labels,
    meta_variables = data["metaVariables"],
  }
end

local function finder_ast_grep(opts, path)
  local inline_rule = vim.json.encode(opts.inline_rule)

  return function(_opts, ctx)
    return require("snacks.picker.source.proc").proc({
      cmd = "ast-grep",
      args = {
        [[--config]],
        vim.fn.fnamemodify([[~/orgfiles/sgconfig.yml]], ":p"),
        [[scan]],
        [[--globs=!**/old_notes/**/*]],
        [[--json=stream]],
        [[--inline-rules]],
        inline_rule,
        path,
      },
      cwd = cwd,
      transform = transform_ast_grep,
    }, ctx)
  end
end

function M.org_buf_headlines()
  Snacks.picker.pick("Org Buffer Headlines", {
    source = "org buffer headlines",
    buf = 0,
    format = format_org,
    finder = finder_ast_grep({
      inline_rule = {
        id = "org-headlines",
        language = "org",
        rule = {
          kind = "headline",
        },
      },
    }, vim.api.nvim_buf_get_name(0)),
  })
end

--- @class ext.orgmode.snacks.PickerAstConfig
--- @field rule    {}
--- @field source  nil | string
--- @field path    nil | string
--- @field format  nil | string |fun(item: snacks.picker.Item, picker: snacks.Picker):vim.api.keyset.set_extmark | { [1]: string, [2]: string?, virtual: boolean, field: string } | { col: number, row: number, field: string }[]

--- @param opts ext.orgmode.snacks.PickerAstConfig
function M.picker_ast_grep(opts)
  local rule = opts.rule
  local source = opts.source or "ast-grep"
  local path = opts.path or "."
  local format = opts.format or format_org

  Snacks.picker.pick(source, {
    source = source,
    buf = 0,
    format = format,
    finder = finder_ast_grep({
      inline_rule = rule,
    }, path),
  })
end

local function org_url(rule_or_regex)
  local rule = {}
  if type(rule_or_regex) == "string" then
    rule = {
      regex = rule_or_regex,
      matches = "isUrl",
    }
  elseif vim.isarray(rule_or_regex) then
    local acc = {}

    for index, value in ipairs(rule_or_regex) do
      acc[index] = {
        regex = value,
        matches = "isUrl",
      }
    end

    rule = {
      any = acc,
    }
  end

  Snacks.picker.pick("Org urls", {
    source = "Org urls",
    format = format_org,
    finder = finder_ast_grep({
      inline_rule = {
        id = "org-url",
        language = "org",
        utils = {
          isUrl = {
            any = {
              {
                kind = "expr",
                inside = {
                  kind = "link_desc",
                  field = "url",
                },
              },
              {
                kind = "expr",
                inside = {
                  kind = "link",
                  field = "url",
                },
              },
            },
          },
        },
        rule = rule,
      },
    }, "."),
  })
end

function M.insert_org_headline_with_id()
  Snacks.picker.pick("Org urls", {
    source = "Org urls",
    format = format_org,
    finder = finder_ast_grep({
      inline_rule = rules.org_headline_with_id,
    }, "."),
    confirm = function(picker, item)
      local captures = item.meta_variables.single
      local headline_item = captures.HEADLINE_ITEM.text
      local id = captures.ID.text

      local line = ("[[id:%s][%s]]"):format(id, headline_item)

      picker:close()
      vim.api.nvim_put({ line }, "c", true, true)
    end,
  })
end

---@param url_or_buf string | integer | nil
function M.org_backlinks(url_or_buf)
  if type(url_or_buf) == "number" then
    url_or_buf = vim.api.nvim_buf_get_name(url_or_buf)
  elseif type(url_or_buf) == "nil" then
    url_or_buf = vim.api.nvim_buf_get_name(0)
  elseif type(url_or_buf) ~= "string" then
    error("expected a string")
  end

  local acc = {}

  local home_rel = vim.fn.fnamemodify(url_or_buf, ":~")
  local full_path = vim.fn.fnamemodify(url_or_buf, ":p")
  acc[#acc + 1] = full_path
  acc[#acc + 1] = home_rel

  local match

  -- TODO make compatible with hyperlink sources
  match = home_rel:match("~/orgfiles/people/(.-).org")
  if match then
    acc[#acc + 1] = ("people:%s"):format(match)
  end

  org_url(acc)
end

function M.org_headlines(path)
  Snacks.picker.pick("Org Headlines", {
    source = "org headlines",
    format = format_org,
    finder = finder_ast_grep({
      inline_rule = {
        id = "org-headlines",
        language = "org",
        rule = {
          kind = "headline",
        },
      },
    }, vim.fn.fnamemodify(path, ":p")),
  })
end

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

function M.picker_orgmode_todos()
  return M.picker_ast_grep({
    rule = rules.org_todos,
    source = "Org TODOs",
    format = function(item, picker)
      local format = require("snacks.picker.format")
      local highlight = require("snacks.picker.util.highlight")

      ---@type snacks.picker.Highlight[]
      local ret = {}

      -- item.meta_variables.single.TEXT.text

      vim.list_extend(ret, format.file(item, picker))

      highlight.format(item, item.text, ret)

      return ret
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
