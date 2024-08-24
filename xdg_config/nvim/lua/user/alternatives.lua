local util = require("user.util")

local map = util.map

local group = vim.api.nvim_create_augroup("UserAlternatives", { clear = true })

local function glob2re(glob)
  local s = glob
  s = string.gsub(s, "*", "(.+)")
  s = string.gsub(s, "{(.-)}", function(str)
    return "(" .. string.gsub(str, ",", "|") .. ")"
  end)
  return s
end

local function glob2capture(glob)
  local idx = 0
  local s = glob

  local function ref()
    idx = idx + 1
    return "%" .. idx
  end

  s = string.gsub(glob, "*", ref)
  s = string.gsub(s, "{(.-)}", ref)
  s = string.gsub(s, "%[(.-)%]", ref)

  return s
end

local function keymap(opts)
  local events = opts.events or { "BufEnter", "BufWinEnter", "DirChanged" }

  vim.api.nvim_create_autocmd(events, {
    group = group,
    pattern = opts.pattern,
    callback = opts.callback,
  })
end

local function map_alternate(file, pattern, substitute)
  file = vim.fn.fnamemodify(file, ":~:.")

  local alt = string.gsub(file, pattern, substitute)

  local function printAlt()
    print(alt)
  end

  local function open()
    vim.cmd(string.format("e %s", alt))
  end

  vim.api.nvim_buf_create_user_command(0, "PrintAlt", printAlt, { force = true })

  map("n", "<leader>pa", open, { buffer = true })
end

local function alternate_pair(globA, globB)
  keymap({
    pattern = { globA },
    callback = function(args)
      map_alternate(args.file, glob2re(globA), glob2capture(globB))
    end,
  })

  keymap({
    pattern = { globB },
    callback = function(args)
      map_alternate(args.file, glob2re(globB), glob2capture(globA))
    end,
  })
end

local function setup()
  vim.api.nvim_create_user_command("PrintAlt", function()
    print("No alternate defined")
  end, { force = true })

  map("n", "<leader>pa", function()
    print("No alternate defined")
  end)
end

return {
  alternate_pair = alternate_pair,
  map_alternate = map_alternate,
  keymap = keymap,
  setup = setup,
}
