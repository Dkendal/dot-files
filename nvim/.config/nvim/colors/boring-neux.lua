--
--        ,gggg,
--       d8" "8I                         ,dPYb,
--       88  ,dP                         IP'`Yb
--    8888888P"                          I8  8I
--       88                              I8  8'
--       88        gg      gg    ,g,     I8 dPgg,
--  ,aa,_88        I8      8I   ,8'8,    I8dP" "8I
-- dP" "88P        I8,    ,8I  ,8'  Yb   I8P    I8
-- Yb,_,d88b,,_   ,d8b,  ,d8b,,8'_   8) ,d8     I8,
--  "Y8P"  "Y888888P'"Y88P"`Y8P' "YY8P8P88P     `Y8
--

-- This is the lush quickstart tutorial, it provides a basic overview
-- of the lush experience and API.
--
-- First, enable lush.ify on this file, run:
--
--  `:Lushify`
--
--  or
--
--  `:lua require('lush').ify()`
--
-- (try putting your cursor inside the ` and typing yi`:@"<CR>)
--
-- Calls to hsl()/hsluv() are now highlighted with the correct background colour
-- Highlight names groups will have the highlight style applied to them.

local lush = require("lush")
local hsl = lush.hsl
local hsluv = lush.hsluv
-- You may also use the HSLuv colorspace, see http://www.hsluv.org/ and h: lush-hsluv-colors.
-- Replace calls to hsl() with hsluv()
-- local hsluv = lush.hsluv

-- HSL stands for Hue        (0 - 360)
--                Saturation (0 - 100)
--                Lightness  (0 - 100)
--
-- By working with HSL, it's easy to define relationships between colours.

local sea_foam = hsl(208, 80, 80) -- Vim has a mapping, <n>C-a and <n>C-x to
local sea_crest = hsl(208, 90, 30) -- increment or decrement integers, or
local sea_deep = hsl(208, 90, 10) -- you can just type them normally.
local sea_gull = hsl("#c6c6c6") -- Or use hex form, preceeded with a #.

-- Note: Some CursorLine highlighting will obscure any other highlighing on the
--       current line until you move your cursor.
--
--       You can disable the cursor line temporarily with:
--
--       `setlocal nocursorline`

-- Lush.hsl provides a number of convenience functions for:
--
--   Relative adjustment: rotate(), saturate(), desaturate(), lighten(), darken()
--                        aliased to ro(), sa() de(), li(), da(), mix(), readable()
--   Overide:             hue(), saturation(), lightness()
--   Access:              .h, .s, .l
--   Coercion:            tostring(), "Concatenation: " .. color

-- To define our colour scheme, we will write what is called a lush-spec.
-- We will use lush.hsl as an aid.

-- A lush-spec function which returns a table, which defines our
-- highlight groups. It's usage is much simpler than it reads.
-- We'll define our lush-spec below.

local n = 5
local deg = 360 / n
local color1 = hsl(220, 81, 54)
local color2 = color1.rotate(deg)
local color3 = color1.rotate(deg * 2)
local color4 = color1.rotate(deg * 3)
local color5 = color1.rotate(deg * 4)

local black = hsl("#181C25")
local white = hsl("#ffffff")
local grey = white.darken(55)
local error_red = hsluv(7, 82, 56)
local warn_yellow = hsluv(27, 100, 57)
local info_green = hsluv(123, 87, 78)
local hint_blue = hsluv(230, 62, 79)

-- Call lush with our lush-spec.
---@diagnostic disable: undefined-global

local theme = lush(function()
  return {
    Normal { bg = black, fg = white }, -- normal text
    FloatingMenu { Normal, bg = Normal.bg.lighten(10) },
    Subtle {bg = Normal.bg, fg = Normal.bg.lighten(5)},
    Visual { Normal, gui = "inverse" },
    Error { bg = Normal.bg, fg = error_red },
    Warn { bg = Normal.bg, fg = warn_yellow },
    Info { bg = Normal.bg, fg = info_green },
    Hint { bg = Normal.bg, fg = hint_blue },
    UnderlineError { Error, gui = "underline" },
    UnderlineWarn { Warn, gui = "underline" },
    UnderlineInfo { Info, gui = "underline" },
    UnderlineHint { Hint, gui = "underline" },
    ColorColumn { Normal, bg = Normal.bg.lighten(1)  },
    Comment { Normal, fg = grey, gui = "italic" },
    Conceal { Comment },
    Constant { Normal },
    Cursor { Normal },
    CursorColumn { Normal },
    -- CursorLine {  },
    DiagnosticError { Error, fg = Error.fg.mix(Normal.bg, 50) },
    DiagnosticHint { Hint, fg = Hint.fg.mix(Normal.bg, 50) },
    DiagnosticInfo { Info, fg = Info.fg.mix(Normal.bg, 50) },
    DiagnosticWarn { Warn, fg = Warn.fg.mix(Normal.bg, 50) },
    DiagnosticUnderlineError { UnderlineError },
    DiagnosticUnderlineHint { UnderlineHint },
    DiagnosticUnderlineInfo { UnderlineInfo },
    DiagnosticUnderlineWarn { UnderlineWarn },
    DiffAdd { Info },
    DiffChange { Warn },
    DiffDelete { Error },
    DiffText { Info },
    Directory { Normal },
    ErrorMsg { Error },
    FileIconSeparator { Normal },
    FilePathSeparator { Normal },
    FloatShadow { Normal, bg = Normal.bg.darken(10), fg = grey },
    FloatShadowThrough { Normal },
    FoldColumn { Comment },
    Folded { Comment },
    GalaxyFileIcon { Normal },
    GalaxyFilePath { Normal },
    GalaxyLineColumn { Normal },
    GalaxyLinePercent { Normal },
    GalaxyLspStatus { Normal },
    Identifier { fg = Normal.fg.darken(20) },
    Ignore { Normal },
    IncSearch { Normal },
    LineColumnSeparator { Normal },
    LineNr { Normal, fg = Normal.bg.lighten(23) },
    CursorLineNr { fg = LineNr.fg.lighten(60) },
    LinePercentSeparator { Normal },
    LspStatusSeparator { Normal },
    MatchParen { gui = "bold" },
    ModeMsg { Normal },
    MoreMsg { Normal },
    NonText { Normal },
    NvimInternalError { Error },
    Pmenu { FloatingMenu },
    -- PmenuSbar { Normal },
    -- PmenuSel { Normal },
    -- PmenuThumb { Normal },
    PreProc { Normal, fg = grey  },
    -- Question { Normal },
    -- RedrawDebugClear { Normal },
    -- RedrawDebugComposed { Normal },
    RedrawDebugNormal { Normal },
    -- RedrawDebugRecompose { Normal },
    Search { fg = Normal.bg, bg = Normal.fg },
    -- SignColumn { Normal },
    Special { fg = Normal.fg.darken(40) },
    -- SpecialKey { Normal },
    -- SpellBad { Normal },
    -- SpellCap { Normal },
    -- SpellLocal { Normal },
    -- SpellRare { Normal },
    -- Statement { Normal },
    -- StatusLine { Normal },
    -- StatusLineNC { Normal },
    -- TabLine { Normal },
    -- TabLineFill { Normal },
    -- TabLineSel { Normal },
    -- TermCursor { Normal },
    -- Title { Normal },
    Todo { Normal, bg = warn_yellow, fg = Normal.bg },
    -- Type { Normal },
    Underlined { Normal, gui = "underline" },
    VertSplit { Subtle },
    WarningMsg { Error },
    WildMenu { FloatingMenu },
    lCursor { Visual },
    IndentBlanklineChar { fg = Normal.bg.lighten(4 )},
  }
end)

-- return our parsed theme for extension or use else where.
return theme

-- vi:nowrap:number
