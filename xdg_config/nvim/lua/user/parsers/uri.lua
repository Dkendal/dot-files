local lpeg = require("lpeg")

-- Import locale patterns
local locale = lpeg.locale()
local P, R, S, C, Ct, Cg = lpeg.P, lpeg.R, lpeg.S, lpeg.C, lpeg.Ct, lpeg.Cg

-- Helper patterns
local digit = locale.digit
local alpha = locale.alpha
local alnum = locale.alnum

-- URI component patterns
local unreserved = alnum + S("-._~")
local pct_encoded = P("%") * R("09", "AF", "af") * R("09", "AF", "af")
local sub_delims = S("!$&'()*+,;=")
local pchar = unreserved + pct_encoded + sub_delims + S(":@")

-- Scheme: starts with alpha, followed by alpha/digit/+/-/.
local scheme = C(alpha * (alnum + S("+-.")) ^ 0)

-- Host: similar to your original but slightly more restrictive
-- Removed underscore as it's not valid in hostnames per RFC
local host_char = alnum + S(".-")
local host = C(host_char ^ 1)

-- Port: digits only
local port = C(digit ^ 1)

-- Authority: host with optional port - FIXED to capture separately
local authority = Cg(host, "host") * (P(":") * Cg(port, "port")) ^ -1

-- Path: starts with / followed by path characters
local path_segment = pchar ^ 0
local path_absolute = P("/") * (path_segment * (P("/") * path_segment) ^ 0) ^ -1
local path = C(path_absolute ^ -1) -- Path can be empty

-- Query: ? followed by query characters
local query_char = pchar + S("/?")
local query = P("?") * C(query_char ^ 0)

-- Fragment: # followed by fragment characters
local fragment_char = pchar + S("/?")
local fragment = P("#") * C(fragment_char ^ 0)

-- Complete URI pattern
local uri = Ct(
  Cg(scheme, "scheme") * P("://") *
  authority *   -- Now properly captures host and port separately
  Cg(path, "path") *
  Cg(query ^ -1, "query") *
  Cg(fragment ^ -1, "fragment")
)

-- Function to parse a URI string
local function parse_uri(uri_string)
  local result = uri:match(uri_string)
  if result then
    -- Clean up empty captures
    if result.path == "" then
      result.path = "/"
    end
    if result.query == "" then
      result.query = nil
    end
    if result.fragment == "" then
      result.fragment = nil
    end
    -- Convert port to number if present
    if result.port then
      result.port = tonumber(result.port)
    end
  end
  return result
end

-- Return the parser function
return {
  parse_uri = parse_uri,
}
