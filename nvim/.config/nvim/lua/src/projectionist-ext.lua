local function split_path(str)
  return str:gmatch("[^/]+")
end

local function rb_class_start(input)
  local buffer = {}
  for str in split_path(input) do
    local const = (
      str
      :gsub("^%l", string.upper)
      :gsub("_(%l)", string.upper)
    )

    const = "module "..const

    const = string.rep("  ", #buffer)..const

    table.insert(buffer, const)
  end

  local last = buffer[#buffer]

  buffer[#buffer] = string.gsub(last, "^(%s+)module", "%1class")

  return buffer
end

local function rb_class_end(input)
  local buffer = {}

  for _ in split_path(input) do
    local ws = string.rep("  ", #buffer)
    table.insert(buffer, ws.."end")
  end

  local reversed = {}

  for i = #buffer, 1, -1 do
    table.insert(reversed, buffer[i])
  end

  return reversed
end

local function rb_class_indent(input)
  local n = 0
  for _ in input:gmatch("[^/]+") do
    n = n + 1
  end
  return string.rep("  ", n)
end


return {
  rb_class_start = rb_class_start,
  rb_class_end = rb_class_end,
  rb_class_indent = rb_class_indent,
}
