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
local hsl = lush.hsl
-- You may also use the HSLuv colorspace, see http://www.hsluv.org/ and h: lush-hsluv-colors.
-- Replace calls to hsl() with hsluv()
-- local hsluv = lush.hsluv

-- HSL stands for Hue        (0 - 360)
--                Saturation (0 - 100)
--                Lightness  (0 - 100)
--
-- By working with HSL, it's easy to define relationships between colours.
--
local alabaster = hsl("#e0e2db")
local eerie_black = hsl("#121616")
local lava = hsl("#c42021")
local viridian_green = hsl("#2f9c95")
local plum = hsl("#88498f")
local yellow = lava.rotate(10)

local sea_foam = hsl(208, 80, 80) -- Vim has a mapping, <n>C-a and <n>C-x to
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

-- Call lush with our lush-spec.
local theme = lush(function()
    return {
        Normal { fg = alabaster, bg = eerie_black},
        Comment { fg = Normal.bg.lighten(39).ro(40), gui="italic" },
        -- NormalFloat	Normal text in floating windows.
        -- ColorColumn	used for the columns set with 'colorcolumn'
        -- Conceal		placeholder characters substituted for concealed
        -- Cursor		character under the cursor
        -- CursorColumn	Screen-column at the cursor, when 'cursorcolumn' is set.
        -- CursorIM	like Cursor, but used when in IME mode |CursorIM|
        CursorLine { bg = Normal.bg.li(8).ro(10) },
        CursorLineNr { CursorLine },
        -- DiffAdd		diff mode: Added line |diff.txt|
        -- DiffChange	diff mode: Changed line |diff.txt|
        -- DiffDelete	diff mode: Deleted line |diff.txt|
        -- DiffText	diff mode: Changed text within a changed line |diff.txt|
        Directory {},
        EndOfBuffer {},
        ErrorMsg {},
        FoldColumn {},
        Folded {},
        IncSearch {},
        LineNr { fg=Normal.bg.li(17).ro(40) },
        -- LineNrAbove {},
        -- LineNrBelow {},
        MatchParen {},
        Menu {},
        ModeMsg {},
        MoreMsg {},
        MsgArea {},
        MsgSeparator {},
        NonText {},
        NormalNC {},
        Visual { CursorLine },
        Pmenu { bg=Normal.bg.li(3) },
        PmenuSbar {},
        PmenuSel { bg=Pmenu.bg.lighten(15), fg=Normal.fg },
        PmenuThumb {},
        Question {},
        QuickFixLine {},
        Scrollbar {},
        Search {},
        SignColumn {},
        -- SpecialKey	Unprintable characters: text displayed differently from what
        -- SpellBad	Word that is not recognized by the spellchecker. |spell|
        -- SpellCap	Word that should start with a capital. |spell|
        -- SpellLocal	Word that is recognized by the spellchecker as one that is
        -- SpellRare	Word that is recognized by the spellchecker as one that is
        -- StatusLine	status line of current window
        -- StatusLineNC	status lines of not-current windows
        -- Substitute	|:substitute| replacement text highlighting
        TabLine { bg=Normal.bg.li(8).ro(40), fg=Normal.fg},
        TabLineFill { },
        TabLineSel { TabLine, bg=TabLine.bg.li(13), fg=TabLine.fg.li(50)},
        -- TermCursor	cursor in a focused terminal
        -- TermCursorNC	cursor in an unfocused terminal
        -- The 'statusline' syntax allows the use of 9 different highlights in the
        -- Title		titles for output from ":set all", ":autocmd" etc.
        -- Tooltip		Current font, background and foreground of the tooltips.
        -- VertSplit	the column separating vertically split windows
        -- VisualNOS	Visual mode selection when vim is "Not Owning the Selection".
        -- WarningMsg	warning messages
        Whitespace { fg=Normal.bg.li(20) },
        WildMenu { Normal },
        -- lCursor		the character under the cursor when |language-mapping|
    Keyword { fg = lava },
    TSKeyword { Keyword },
    Literal { fg=Normal.fg },
    TSFunction { fg = viridian_green },
    TSProperty { Normal  },
    TSVariable { Normal },
    TSField { TSVariable },
    TSKeywordFunction { Keyword },
    TSKeywordReturn { Keyword },
    TSFuncBuiltin { TSFunction, gui="bold"},
    TSInclude { TSFuncBuiltin },
    TSPunctBracket { },
    SString { Literal },
    TSNumber { Literal },
    TSBoolean { Literal },
    TSConstructor { fg=Normal.fg.da(62) },
    }
end)

-- return our parsed theme for extension or use else where.
return theme

-- vi:nowrap:number
