local abbr = vim.cmd.abbr
local cabbr = vim.cmd.cabbr
local iabbr = vim.cmd.iabbr

iabbr([[<expr> D@ strftime('%Y-%m-%d %a')]])
iabbr([[<expr> d@ strftime('%Y-%m-%d')]])
iabbr([[<expr> t@ strftime('%Y%m%d%k%M')]])
iabbr([[<expr> ts@ strftime('%Y-%m-%d %a %k:%M')]])
iabbr([[<expr> us@ strftime('%s')]])
iabbr([[acount account]])
iabbr([[overide override]])
iabbr([[resouces resources]])
iabbr([[teh the]])

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
