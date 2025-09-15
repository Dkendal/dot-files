---@module 'lazy'
---@module 'orgmode'
---@class astgrep.Range
---@field byteOffset astgrep.ByteOffset
---@field start astgrep.Position
---@field end astgrep.Position

---@class astgrep.ByteOffset
---@field start integer
---@field end integer

---@class astgrep.Position
---@field line integer
---@field column integer

---@class astgrep.Item
---@field text string
---@field file string
---@field lines string
---@field severity string
---@field range astgrep.Range
---@field labels astgrep.Item[]



local people_path = vim.env.HOME .. '/orgfiles/people/'


local rule_org_headline_with_id = {
	language = "org",
	id = "org-headlines-with-id",
	rule = {
		kind = "section",
		all = {
			{
				has = {
					field = "headline",
					has = {
						field = "item",
						pattern = "$HEADLINE_ITEM"
					}
				}
			},
			{
				has = {
					kind = "property_drawer",
					has = {
						kind = "property",
						all = {
							{
								has = {
									field = "name",
									regex = "ID"
								}
							},
							{
								has = {
									field = "value",
									pattern = "$ID"
								}
							}
						}
					}
				}
			}
		}
	}
}


local function action(cmd, opts)
	return function()
		require("orgmode").action(cmd, opts)
	end
end

local function insert_property()
	vim.ui.input({ prompt = "Property key:" }, function(key)
		vim.ui.input({ prompt = ("Value for %s:"):format(key) }, function(value)
			require("orgmode.api").current():get_closest_headline():set_property(key, value)
		end)
	end)
end



---@type OrgLinkType
local hyperlink_people = {
	get_name = function() return 'people' end,
	follow = function(_self, link)
		if not vim.startswith(link, 'people:') then
			return false
		end

		local filename = string.match(link, "people:(.*)")
		filename = people_path .. filename .. ".org"

		vim.cmd("split " .. filename)

		return true
	end,
	autocomplete = function(_self, _link)
		local result = vim.system({ 'fd', '\\.org$', people_path }, { text = true }):wait()

		if result.code == 0 then
			return vim.iter(vim.split(result.stdout, "\n"))
					:filter(function(x) return vim.trim(x) ~= "" end)
					:map(function(x)
						local text = x:gsub("^" .. people_path, ""):gsub("%.org$", "")
						return "people:" .. text .. "][" .. text .. "]]"
					end)
					:totable()
		else
			vim.notify(result.stderr, "error")
			return {}
		end
	end
}


---@type OrgLinkType
local hyperlink_jira = {
	get_name = function() return 'jira' end,
	follow = function(_self, link)
		if not vim.startswith(link, 'jira:') then
			return false
		end

		link = string.match(link, "jira:(%w+-%d+)")
		vim.ui.open("https://blvd.atlassian.net/browse/" .. link)
		return true
	end,
	autocomplete = function()
		return {}
	end
}

local function snacks_picker_org_format(item, picker)
	local format = require("snacks.picker.format")
	local highlight = require("snacks.picker.util.highlight")

	---@type snacks.picker.Highlight[]
	local ret = {}

	vim.list_extend(ret, format.file(item, picker))
	highlight.format(item, item.text, ret)

	return ret
end

local function snacks_picker_ast_grep_transform(item)
	---@type astgrep.Item
	local data = vim.json.decode(item.text)

	---@type snacks.picker.finder.Item
	return {
		file = data.file,
		text = data.text,
		severity = data.severity,
		pos = {
			data.range.start.line + 1,
			data.range.start.column
		},
		end_pos = {
			data.range["end"].line + 1,
			data.range["end"].column
		},
		labels = data.labels,
		meta_variables = data["metaVariables"]
	}
end


local function snacks_picker_ast_grep_finder(opts, path)
	local inline_rule = vim.json.encode(opts.inline_rule)

	return function(_opts, ctx)
		return require("snacks.picker.source.proc").proc(
			{
				cmd = "ast-grep",
				args = {
					[[--config]],
					vim.fn.fnamemodify([[~/orgfiles/sgconfig.yml]], ':p'),
					[[scan]],
					[[--globs=!old_notes/**/*]],
					[[--json=stream]],
					[[--inline-rules]],
					inline_rule,
					path
				},
				transform = snacks_picker_ast_grep_transform,
			}
			, ctx)
	end
end


local function snacks_picker_org_buf_headlines()
	Snacks.picker.pick("Org Buffer Headlines", {
		source = "org buffer headlines",
		buf = 0,
		format = snacks_picker_org_format,
		finder = snacks_picker_ast_grep_finder(
			{
				inline_rule = {
					id = "org-headlines",
					language = "org",
					rule = {
						kind = "headline"
					}
				}
			},
			vim.api.nvim_buf_get_name(0)
		),
	})
end

local function snacks_picker_org_url(rule_or_regex)
	local rule = {}
	if type(rule_or_regex) == "string" then
		rule = {
			regex = rule_or_regex,
			matches = "isUrl"
		}
	elseif vim.isarray(rule_or_regex) then
		local acc = {}

		for index, value in ipairs(rule_or_regex) do
			acc[index] = {
				regex = value,
				matches = "isUrl"
			}
		end

		rule = {
			any = acc
		}
	end

	Snacks.picker.pick("Org urls", {
		source = "Org urls",
		format = snacks_picker_org_format,
		finder = snacks_picker_ast_grep_finder(
			{
				inline_rule = {
					id = "org-url",
					language = "org",
					utils = {
						isUrl = {
							any = {
								{
									kind = "expr",
									inside = {
										kind = "link_desc",
										field = "url"
									}
								},
								{
									kind = "expr",
									inside = {
										kind = "link",
										field = "url"
									}
								}
							}
						}
					},
					rule = rule
				}
			},
			"."
		),
	})
end


local function snacks_picker_insert_org_headline_with_id()
	Snacks.picker.pick("Org urls", {
		source = "Org urls",
		format = snacks_picker_org_format,
		finder = snacks_picker_ast_grep_finder(
			{
				inline_rule = rule_org_headline_with_id
			},
			"."
		),
		confirm = function(picker, item)
			local captures = item.meta_variables.single
			local headline_item = captures.HEADLINE_ITEM.text
			local id = captures.ID.text

			local line = ("[[id:%s][%s]]"):format(id, headline_item)

			picker:close()
			vim.api.nvim_put({ line }, "c", true, true)
		end
	})
end


---@param url_or_buf string | integer | nil
local function snacks_picker_org_backlinks(url_or_buf)
	if type(url_or_buf) == "number" then
		url_or_buf = vim.api.nvim_buf_get_name(url_or_buf)
	elseif type(url_or_buf) == "nil" then
		url_or_buf = vim.api.nvim_buf_get_name(0)
	elseif type(url_or_buf) ~= "string" then
		error("expected a string")
	end

	local acc = {}

	local home_rel = vim.fn.fnamemodify(url_or_buf, ":~")
	local full_path = vim.fn.fnamemodify(url_or_buf, ":p")
	acc[#acc + 1] = full_path
	acc[#acc + 1] = home_rel

	local match

	-- TODO make compatible with hyperlink sources
	match = home_rel:match("~/orgfiles/people/(.-).org")
	if match then
		acc[#acc + 1] = ("people:%s"):format(match)
	end

	snacks_picker_org_url(acc)
end

local function snacks_picker_org_headlines(path)
	Snacks.picker.pick("Org Headlines", {
		source = "org headlines",
		format = snacks_picker_org_format,
		finder = snacks_picker_ast_grep_finder(
			{
				inline_rule = {
					id = "org-headlines",
					language = "org",
					rule = {
						kind = "headline"
					}
				}
			},
			vim.fn.fnamemodify(path, ':p')
		),
	})
end


-- function org_insert_href_id()
-- 	local items = vim.iter(require("orgmode.api").load())
-- 			:enumerate()
-- 			:map(function(idx, item)
-- 				---@type snacks.picker.finder.Item
-- 				return {
-- 					idx = idx,
-- 					file = item.filename,
-- 					text = item.filename
-- 				}
-- 			end)
-- 			:totable()
--
-- 	local function confirm(picker)
-- 		picker:close()
--
-- 		local current = picker:current()
--
-- 		if current == nil then
-- 			return
-- 		end
--
-- 		local line = "[[" .. current.file .. "][" .. current.text .. "]]"
--
-- 		-- vim.api.nvim_put({ line }, "c", true, true)
-- 	end
--
-- 	Snacks.picker.pick("Org Buffer Headlines", {
-- 		source = "org buffer headlines",
-- 		buf = 0,
-- 		format = snacks_picker_org_format,
-- 		finder = snacks_picker_ast_grep_finder(
-- 			{
-- 				inline_rule = {
-- 					id = "org-id",
-- 					language = "org",
-- 					rule = {
-- 						kind = "headline"
-- 					}
-- 				}
-- 			},
-- 			vim.api.nvim_buf_get_name(0)
-- 		),
-- 		confirm = confirm
-- 	})
-- end


--- @type LazyKeysSpec[]
local keys = {
	-- { "<leader>\\",  "<cmd>:silent !org-format.sh %<cr>",                        ft = "org",                  mode = "n", desc = "org format file" },

	{ "<CR>",        action("org_mappings.meta_return"),                         ft = "org",                  mode = "n", desc = "org meta return" },
	{ "<leader>$",   action("org_mappings.archive"),                             ft = "org",                  mode = "n", desc = "org archive subtree" },
	{ "<leader>'",   action("org_mappings.edit_special"),                        ft = "org",                  mode = "n", desc = "org edit special" },
	{ "<leader>*",   action("org_mappings.toggle_heading"),                      ft = "org",                  mode = "n", desc = "org toggle headline" },
	{ "<leader>,",   action("org_mappings.set_priority"),                        ft = "org",                  mode = "n", desc = "org cycle priority" },
	{ "<leader>bt",  action("org_mappings.org_babel_tangle"),                    ft = "org",                  mode = "n", desc = "org tangle" },
	{ "<leader>d!",  action("org_mappings.org_toggle_timestamp_type"),           ft = "org",                  mode = "n", desc = "org toggle timestamp type" },
	{ "<leader>oe",  action("org_mappings.export"),                              ft = "org",                  mode = "n", desc = "org export" },
	{ "<leader>ip",  insert_property,                                            ft = "org",                  mode = "n", desc = "org timestamp (inactive)" },
	{ "<leader>i!",  action("org_mappings.org_time_stamp", "true"),              ft = "org",                  mode = "n", desc = "org timestamp (inactive)" },
	{ "<leader>i.",  action("org_mappings.org_time_stamp"),                      ft = "org",                  mode = "n", desc = "org timestamp" },
	{ "<leader>iT",  action("org_mappings.insert_todo_heading"),                 ft = "org",                  mode = "n", desc = "org insert todo" },
	{ "<leader>id",  action("org_mappings.org_deadline"),                        ft = "org",                  mode = "n", desc = "org deadline" },
	{ "<leader>ih",  action("org_mappings.insert_heading_respect_content"),      ft = "org",                  mode = "n", desc = "org insert headline (respect content)" },
	{ "<leader>is",  action("org_mappings.org_schedule"),                        ft = "org",                  mode = "n", desc = "org schedule" },
	{ "<leader>it",  action("org_mappings.insert_todo_heading_respect_content"), ft = "org",                  mode = "n", desc = "org insert todo (respect content)" },
	{ "<leader>il",  snacks_picker_insert_org_headline_with_id,                  ft = "org",                  mode = "n", desc = "org find and insert link" },
	{ "<leader>li",  action("org_mappings.insert_link"),                         ft = "org",                  mode = "n", desc = "org insert link" },
	{ "<leader>ls",  action("org_mappings.store_link"),                          ft = "org",                  mode = "n", desc = "org store link" },
	{ "<leader>na",  action("org_mappings.add_note"),                            ft = "org",                  mode = "n", desc = "org add note" },

	{ "<leader>oo",  action("org_mappings.open_at_point"),                       ft = "org",                  mode = "n", desc = "org open" },

	{ "<leader>r",   action("capture.refile_headline_to_destination"),           ft = "org",                  mode = "n", desc = "org refile" },
	{ "<leader>t",   action("org_mappings.set_tags"),                            ft = "org",                  mode = "n", desc = "org set tags" },

	-- Time tracking
	{ "<leader>xe",  action("clock.org_set_effort"),                             ft = "org",                  mode = "n", desc = "org set effort" },
	{ "<leader>xi",  action("clock.org_clock_in"),                               ft = "org",                  mode = "n", desc = "org clock in" },
	{ "<leader>xj",  action("clock.org_clock_goto"),                             ft = "org",                  mode = "n", desc = "org clock goto" },
	{ "<leader>xo",  action("clock.org_clock_out"),                              ft = "org",                  mode = "n", desc = "org clock out" },
	{ "<leader>xq",  action("clock.org_clock_cancel"),                           ft = "org",                  mode = "n", desc = "org clock cancel" },

	-- Search
	{ "<leader>ss",  snacks_picker_org_buf_headlines,                            ft = "org",                  mode = "n", desc = "org search buffer headlines" },
	{ "<leader>sS",  function() snacks_picker_org_headlines("~/orgfiles/") end,  ft = "org",                  mode = "n", desc = "org search headlines" },

	-- References
	{ "gr",          function() snacks_picker_org_backlinks(0) end,              ft = "org",                  mode = "n", desc = "org references" },
	{ "gd",          action("org_mappings.open_at_point"),                       ft = "org",                  mode = "n", desc = "org open" },


	-- Insert
	{ "<leader>oil", require("user.orgmode.snacks").insert_file,                 ft = "org",                  mode = "n", desc = "Insert org file link" },
	{ "@f",          require("user.orgmode.snacks").insert_file,                 ft = "org",                  mode = "i", desc = "Insert org file link" },
	{ "@@",          require("user.orgmode.snacks").insert_person,               ft = "org",                  mode = "i", desc = "Insert org file link" },


	{ "<c-.>",       function() Snacks.picker.spelling() end,                    ft = "org",                  mode = "n", desc = "org search headlines" },

	{ "<leader>h",   action("org_mappings.do_promote"),                          ft = "org",                  mode = "n", desc = "org premote headline" },
	{ "<leader>l",   action("org_mappings.do_demote"),                           ft = "org",                  mode = "n", desc = "org demote headline" },
	{ "<leader>H",   action("org_mappings.do_promote", true),                    ft = "org",                  mode = "n", desc = "org promote subtree" },
	{ "<leader>L",   action("org_mappings.do_demote", true),                     ft = "org",                  mode = "n", desc = "org demote subtree" },
	{ "<leader>j",   action("org_mappings.move_subtree_down"),                   ft = "org",                  mode = "n", desc = "org move subtree down" },
	{ "<leader>k",   action("org_mappings.move_subtree_up"),                     ft = "org",                  mode = "n", desc = "org move subtree up" },

	-- insert mode
	{ "<S-CR>",      action("org_mappings.meta_return"),                         ft = "org",                  mode = "i", desc = "org meta return" },
	{ "<C-h>",       action("org_mappings.do_promote"),                          ft = "org",                  mode = "i", desc = "org demote heading" },
	{ "<C-l>",       action("org_mappings.do_demote"),                           ft = "org",                  mode = "i", desc = "org promote heading" },

	-- Toggles
	{ "<leader>td",  action("org_mappings.org_toggle_timestamp_type"),           ft = "org",                  mode = "n", desc = "org toggle timestamp type", },
	{ "<leader>:",   action("org_mappings.set_tags"),                            ft = "org",                  mode = "n", desc = "org set tags" },
}


vim.cmd [[autocmd ColorScheme * hi link @org.todo @comment.note]]

--- @type LazyPluginSpec
return {
	'nvim-orgmode/orgmode',
	dependencies = {
		-- { "akinsho/org-bullets.nvim",     ft = { "org" }, opts = {} },
		{ "lukas-reineke/headlines.nvim", ft = { "org" }, opts = {}, },
		{ "danilshvalov/org-modern.nvim", ft = { "org" } }
	},
	event = 'VeryLazy',
	ft = { 'org' },
	keys = keys,
	config = function()
		local Menu = require("org-modern.menu")

		require('orgmode').setup({
			org_agenda_files = '~/orgfiles/**/*',
			org_default_notes_file = '~/orgfiles/inbox.org',
			org_use_property_inheritance = false,
			org_id_link_to_org_use_id = true,
			org_todo_keywords = { "TODO", "|", "DONE", "CANCELLED" },
			org_todo_keyword_faces = {
				TODO = '',
				DONE = '',
				CANCELLED = ':slant italic'
			},
			org_startup_folded = 'showeverything',
			org_startup_indented = true,
			org_capture_templates = {
				t = {
					description = 'Task',
					template = {
						[[* TODO %?]],
						[[%u]]
					}
				},
				d = {
					description = 'Daily log',
					target = '~/orgfiles/log.org',
					datetree = { tree_type = 'week' },
					template = {
						[[* %?]],
						[[%U]]
					}
				},
			},
			hyperlinks = {
				sources = {
					hyperlink_jira,
					hyperlink_people,
				}
			},
			org_edit_src_filetype_map = {},
			org_adapt_indentation = false,
			mappings = {
				disable_all = false,
				org_return_uses_meta_return = false,
				prefix = '<Leader>o',
				global = {
					org_agenda = "<prefix>a",
					org_capture = "<prefix>c",
				},
				agenda = {
					org_agenda_later = 'f',
					org_agenda_earlier = 'b',
					org_agenda_goto_today = '.',
					org_agenda_day_view = 'vd',
					org_agenda_week_view = 'vw',
					org_agenda_month_view = 'vm',
					org_agenda_year_view = 'vy',
					org_agenda_quit = 'q',
					org_agenda_switch_to = '<CR>',
					org_agenda_goto = '<TAB>',
					org_agenda_goto_date = 'J',
					org_agenda_redo = 'r',
					org_agenda_todo = 't',
					org_agenda_clock_goto = '<prefix>xj',
					org_agenda_set_effort = '<prefix>xe',
					org_agenda_clock_in = 'I',
					org_agenda_clock_out = 'O',
					org_agenda_clock_cancel = 'X',
					org_agenda_clockreport_mode = 'R',
					org_agenda_priority = '<prefix>,',
					org_agenda_priority_up = '+',
					org_agenda_priority_down = '-',
					org_agenda_archive = '<prefix>$',
					org_agenda_toggle_archive_tag = '<prefix>A',
					org_agenda_set_tags = '<prefix>t',
					org_agenda_deadline = '<prefix>id',
					org_agenda_schedule = '<prefix>is',
					org_agenda_filter = '/',
					org_agenda_refile = '<prefix>r',
					org_agenda_add_note = '<prefix>na',
					org_agenda_preview = 'K',
					org_agenda_show_help = 'g?',
				},
				capture = {
					org_capture_finalize = '<C-c>',
					org_capture_refile = '<prefix>r',
					org_capture_kill = '<prefix>k',
					org_capture_show_help = 'g?',
				},
				note = {
					org_note_finalize = '<C-c>',
					org_note_kill = '<prefix>k',
				},
				org = {
					org_do_promote = '<<',
					org_do_demote = '>>',
					org_promote_subtree = '<s',
					org_demote_subtree = '>s',
					org_toggle_checkbox = "<prefix>tc",
					org_toggle_archive_tag = "<prefix>ta",
					org_toggle_timestamp_type = "<prefix>th",
					org_priority_up = "[,",
					org_priority_down = "],",
					org_todo_prev = "[t",
					org_todo = "]t",
				},
			},
			ui = {
				menu = {
					handler = function(data)
						Menu:new({
							window = {
								margin = { 1, 0, 1, 0 },
								padding = { 0, 1, 0, 1 },
								title_pos = "center",
								border = "single",
								zindex = 1000,
							},
							icons = {
								separator = "➜",
							},
						}):open(data)
					end,
				},
			},
		})
	end,
	-- keys = keys
}
