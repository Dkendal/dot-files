local M = {}

function M.dedent(str)
    -- Handle empty or nil input
    if not str or str == "" then
        return ""
    end

    -- Split the string into lines
    local lines = {}
    for line in str:gmatch("[^\r\n]+") do
        table.insert(lines, line)
    end

    -- Find the minimum indentation level
    local min_indent = math.huge
    for _, line in ipairs(lines) do
        -- Skip empty lines when calculating minimum indentation
        local non_space = line:match("^(%s*)[^%s]")
        if non_space then
            min_indent = math.min(min_indent, #non_space)
        end
    end

    -- Handle case where no indentation was found
    if min_indent == math.huge then
        return str
    end

    -- Remove the common indentation from each line
    local result = {}
    for _, line in ipairs(lines) do
        -- Preserve empty lines without trying to dedent them
        if line:match("^%s*$") then
            table.insert(result, "")
        else
            table.insert(result, line:sub(min_indent + 1))
        end
    end

    -- Join the lines back together
    return table.concat(result, "\n")
end

return M
