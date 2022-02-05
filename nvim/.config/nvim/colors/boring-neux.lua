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
local lush = require('lush')
local hsl = lush.hsluv
-- You may also use the HSLuv colorspace, see http://www.hsluv.org/ and h: lush-hsluv-colors.
-- Replace calls to hsl() with hsluv()
-- local hsluv = lush.hsluv

-- HSL stands for Hue        (0 - 360)
--                Saturation (0 - 100)
--                Lightness  (0 - 100)
--
-- By working with HSL, it's easy to define relationships between colours.

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

local true_black = lush.hsl("#0A0B0B")

local n = 5
local deg = 360 / n
local color1 = hsl(220, 81, 54)
local color2 = color1.rotate(deg)
local color3 = color1.rotate(deg * 2)
local color4 = color1.rotate(deg * 3)
local color5 = color1.rotate(deg * 4)

local fg = true_black.lighten(97)
local bg = true_black.lighten(0)

-- Call lush with our lush-spec.
local theme = lush(function()
    return {
        Normal { fg = fg, bg = bg },
        ColorColumn { bg = bg.lighten(1) },
        Inverse { fg = bg, bg = fg },
        Search { fg = fg, bg = bg.mix(color2, 34) },
        IncSearch { Search },
        Visual { bg = bg.mix(color1, 20) },
        LineNr { fg = fg.darken(79), bg = bg },
        VertSplit { LineNr },
        TabLineSel { LineNr },
        TabLineFill { LineNr },
        Conceal { LineNr },
        Conceal { LineNr },
        CursorLineNr { LineNr },
        Folded { LineNr },
        FoldColumn { LineNr },
        SignColumn { LineNr },
        StatusLine { fg = fg, bg = bg.lighten(4) },
        StatusLineNC { StatusLine },
        Pmenu { StatusLine },
        PmenuSel { Pmenu, bg = Pmenu.bg.lighten(16) },
        PmenuThumb { Pmenu, fg = fg, bg = Pmenu.bg.lighten(16), gui = "bold" },
        PmenuSBar { Pmenu },
        WildMenu { fg = fg, bg = color2.mix(bg, 57) },
        ErrorMsg { fg = fg, bg = color3 },
        DiffAdd { bg = hsl(122, 100, 59).darken(81) },
        DiffDelete { bg = hsl(0, 100, 59).darken(89) },
        DiffText { gui = "bold" },
        DiffChange { bg = hsl(35, 100, 59).darken(64) },
        -- Syntax
        Cursor { Inverse },
        Error { ErrorMsg },
        Todo { fg = fg, bg = color4 },
        String { fg = color1 }
    }
end)

-- return our parsed theme for extension or use else where.
return theme

-- vi:nowrap:number
