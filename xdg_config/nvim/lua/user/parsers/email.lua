local lpeg = require "lpeg"

-- Get locale patterns
local locale = lpeg.locale()

-- Basic patterns
local P, R, S, C = lpeg.P, lpeg.R, lpeg.S, lpeg.C
local Ct = lpeg.Ct

-- Define character sets for email parts
local atext = locale.alnum + S("!#$%&'*+-/=?^_`{|}~")
local dot = P(".")
local at = P("@")

-- Local part patterns
-- The local part can contain dots, but not at the beginning or end, and not consecutive
local local_char = atext
local local_part = C(
  local_char ^ 1 * (dot * local_char ^ 1) ^ 0
)

-- Domain patterns
-- Domain labels can contain alphanumeric and hyphens (but not at start/end of label)
local domain_char = locale.alnum
local hyphen = P("-")
local domain_label = domain_char ^ 1 * (hyphen ^ -1 * domain_char ^ 1) ^ 0
local domain = C(domain_label * (dot * domain_label) ^ 1) -- at least one dot required

-- Complete email pattern
local email = Ct(local_part * at * domain)

-- Function to extract emails from text
local function parse_emails(text)
  local matches = {}
  local pattern = email / function(capture)
    table.insert(matches, {
      full = capture[1] .. "@" .. capture[2],
      local_part = capture[1],
      domain = capture[2]
    })
    return ""
  end
  pattern = (pattern + P(1)) ^ 0
  pattern:match(text)
  return matches
end

-- Function to validate a single email
local function validate_email(email_str)
  local match = email:match(email_str)
  if match and #email_str == #(match[1] .. "@" .. match[2]) then
    return {
      valid = true,
      local_part = match[1],
      domain = match[2]
    }
  else
    return { valid = false }
  end
end

return {
  validate_email = validate_email,
  parse_emails = parse_emails
}
