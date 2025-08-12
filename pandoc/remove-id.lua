-- This filter removes identifiers from all headers.
function Header (elem)
  -- Set the element's identifier to an empty string.
  elem.identifier = ""
  -- Return the modified element.
  return elem
end
