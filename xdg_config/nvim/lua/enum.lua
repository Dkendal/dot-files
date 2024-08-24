local Enum = {}

--------------------------------------------------------------------------------
--                                                                            --
--    Copied from https://github.com/torch/xlua/blob/master/init.lua     --
--                                                                            --
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- splicing: remove elements from a table
--------------------------------------------------------------------------------
function Enum.splice(tbl, start, length)
    length = length or 1
    start = start or 1
    local endd = start + length
    local spliced = {}
    local remainder = {}
    for i, elt in ipairs(tbl) do
        if i < start or i >= endd then
            table.insert(spliced, elt)
        else
            table.insert(remainder, elt)
        end
    end
    return spliced, remainder
end

function Enum.with_index(tbl)
    local out = {}

    for index, value in ipairs(tbl) do
        out[index] = {index, value}
    end

    return out
end

function Enum.transpose_index(tbl)
    local out = {}
    for index, value in ipairs(tbl) do
        out[value] = index
    end
    return out
end

return Enum
