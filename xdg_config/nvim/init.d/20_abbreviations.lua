local abbr = vim.cmd.abbr
local cabbr = vim.cmd.cabbr
local iabbr = vim.cmd.iabbr

abbr([[<expr> D@ strftime('%Y-%m-%d %a')]])
abbr([[<expr> d@ strftime('%Y-%m-%d')]])
abbr([[<expr> t@ strftime('%Y%m%d%k%M')]])
abbr([[<expr> ts@ strftime('%Y-%m-%d %a %k:%M')]])
abbr([[<expr> us@ strftime('%s')]])
abbr([[acount account]])
abbr([[overide override]])
abbr([[resouces resources]])
abbr([[teh the]])

cabbr([[<expr> @% expand('%')]])
cabbr([[<expr> @%p expand('%:p')]])
cabbr([[<expr> R 'Rename '.expand('%:t')]])
cabbr([[H Helptags]])
cabbr([[V Verbose]])
cabbr([[bda Wipeout]])
cabbr([[bda Wipeout]])
cabbr([[norg Neorg]])
cabbr([[Norg Neorg]])
cabbr([[n Neorg]])
cabbr([[nw Neorg workspace]])
cabbr([[ne Neorg export]])
cabbr([[nim Neorg inject-metadata]])
cabbr([[ni Neorg index]])
cabbr([[nj Neorg journal]])
cabbr([[nt Neorg toc]])
cabbr([[ngws Neorg generate-workspace-summary]])

iabbr([[dont don't]])
iabbr([[reuslt result]])
