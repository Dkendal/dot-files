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

vim.g.ext_orgmode_hyperlinks_sources_jira_path = vim.env.HOME .. "/orgfiles/people/"

local function action(cmd, opts)
	return function()
		require("orgmode").action(cmd, opts)
	end
end

local function insert_property()
	vim.ui.input({ prompt = "Property key:" }, function(key)
		vim.ui.input({ prompt = ("Value for %s:"):format(key) }, function(value)
			require("orgmode.api").current():get_closest_headline():set_property(key:upper(), value)
		end)
	end)
end

local function insert_created_timestamp()
	local Date = require("orgmode.objects.date")
	local now = Date.now()
	require("orgmode.api").current():get_closest_headline():set_property("CREATED", now:to_wrapped_string(false))
end


--- @type LazyKeysSpec[]
local keys = {
	{
		"<CR>",
		action("org_mappings.meta_return"),
		ft = "org",
		mode = "n",
		desc = "Meta return (smart insertion)",
	},
	{
		"<leader>$",
		action("org_mappings.archive"),
		ft = "org",
		mode = "n",
		desc = "org archive subtree",
	},
	{
		"<leader>'",
		action("org_mappings.edit_special"),
		ft = "org",
		mode = "n",
		desc = "org edit special",
	},
	{
		"<leader>*",
		action("org_mappings.toggle_heading"),
		ft = "org",
		mode = "n",
		desc = "org toggle headline",
	},
	{
		"<leader>,",
		action("org_mappings.set_priority"),
		ft = "org",
		mode = "n",
		desc = "org cycle priority",
	},
	{
		"<leader>bt",
		action("org_mappings.org_babel_tangle"),
		ft = "org",
		mode = "n",
		desc = "org tangle",
	},
	{
		"<leader>d!",
		action("org_mappings.org_toggle_timestamp_type"),
		ft = "org",
		mode = "n",
		desc = "org toggle timestamp type",
	},
	{
		"<leader>oe",
		action("org_mappings.export"),
		ft = "org",
		mode = "n",
		desc = "org export",
	},
	{
		"<leader>ip",
		insert_property,
		ft = "org",
		mode = "n",
		desc = "org add property",
	},
	{
		"<leader>ic",
		insert_created_timestamp,
		ft = "org",
		mode = "n",
		desc = "org add CREATED timestamp",
	},
	{
		"<leader>i!",
		action("org_mappings.org_time_stamp", "true"),
		ft = "org",
		mode = "n",
		desc = "org timestamp (inactive)",
	},
	{
		"<leader>i.",
		action("org_mappings.org_time_stamp"),
		ft = "org",
		mode = "n",
		desc = "org timestamp (active)",
	},
	{
		"<leader>iT",
		action("org_mappings.insert_todo_heading"),
		ft = "org",
		mode = "n",
		desc = "org insert todo",
	},
	{
		"<leader>id",
		action("org_mappings.org_deadline"),
		ft = "org",
		mode = "n",
		desc = "org deadline",
	},
	{
		"<leader>ih",
		action("org_mappings.insert_heading_respect_content"),
		ft = "org",
		mode = "n",
		desc = "org insert headline (respect content)",
	},
	{
		"<leader>is",
		action("org_mappings.org_schedule"),
		ft = "org",
		mode = "n",
		desc = "org schedule",
	},
	{
		"<leader>it",
		action("org_mappings.insert_todo_heading_respect_content"),
		ft = "org",
		mode = "n",
		desc = "org insert todo (respect content)",
	},
	{
		"<leader>il",
		function() require("ext.orgmode.snacks").insert_org_headline_with_id() end,
		ft = "org",
		mode = "n",
		desc = "org find and insert link",
	},
	{
		"<leader>li",
		action("org_mappings.insert_link"),
		ft = "org",
		mode = "n",
		desc = "org insert link",
	},
	{
		"<leader>ls",
		action("org_mappings.store_link"),
		ft = "org",
		mode = "n",
		desc = "org store link",
	},
	{
		"<leader>na",
		action("org_mappings.add_note"),
		ft = "org",
		mode = "n",
		desc = "org add note",
	},

	{
		"<leader>oo",
		action("org_mappings.open_at_point"),
		ft = "org",
		mode = "n",
		desc = "org open link at point",
	},

	{
		"<leader>r",
		action("capture.refile_headline_to_destination"),
		ft = "org",
		mode = "n",
		desc = "org refile",
	},
	{
		"<leader>t",
		action("org_mappings.set_tags"),
		ft = "org",
		mode = "n",
		desc = "org set tags",
	},

	-- Time tracking
	{
		"<leader>xe",
		action("clock.org_set_effort"),
		ft = "org",
		mode = "n",
		desc = "org set effort",
	},
	{
		"<leader>xi",
		action("clock.org_clock_in"),
		ft = "org",
		mode = "n",
		desc = "org clock in",
	},
	{
		"<leader>xj",
		action("clock.org_clock_goto"),
		ft = "org",
		mode = "n",
		desc = "org clock goto",
	},
	{
		"<leader>xo",
		action("clock.org_clock_out"),
		ft = "org",
		mode = "n",
		desc = "org clock out",
	},
	{
		"<leader>xq",
		action("clock.org_clock_cancel"),
		ft = "org",
		mode = "n",
		desc = "org clock cancel",
	},

	-- Search
	{
		"<leader>st",
		function() require("ext.orgmode.snacks").picker_orgmode_todos() end,
		ft = "org",
		mode = "n",
		desc = "Search TODOs",
	},
	{
		"<leader>ss",
		function() require("ext.orgmode.snacks").org_buf_headlines() end,
		ft = "org",
		mode = "n",
		desc = "Search buffer headlines",
	},
	{
		"<leader>sS",
		function() require("ext.orgmode.snacks").org_headlines("~/orgfiles/") end,
		ft = "org",
		mode = "n",
		desc = "Search all headlines",
	},

	-- References
	{
		"gr",
		function() require("ext.orgmode.snacks").org_backlinks(0) end,
		ft = "org",
		mode = "n",
		desc = "Show backlinks/references",
	},
	{
		"gd",
		action("org_mappings.open_at_point"),
		ft = "org",
		mode = "n",
		desc = "Goto definition (open link)",
	},

	-- Insert
	{
		"<leader>oil",
		require("ext.orgmode.snacks").insert_file,
		ft = "org",
		mode = "n",
		desc = "Insert file link",
	},
	{
		"@f",
		require("ext.orgmode.snacks").insert_file,
		ft = "org",
		mode = "i",
		desc = "Insert file link",
	},
	{
		"@@",
		require("ext.orgmode.snacks").insert_person,
		ft = "org",
		mode = "i",
		desc = "Insert person link",
	},

	{
		"<c-.>",
		function()
			Snacks.picker.spelling()
		end,
		ft = "org",
		mode = "n",
		desc = "Spell check",
	},

	{
		"<leader>h",
		action("org_mappings.do_promote"),
		ft = "org",
		mode = "n",
		desc = "org promote headline",
	},
	{
		"<leader>l",
		action("org_mappings.do_demote"),
		ft = "org",
		mode = "n",
		desc = "org demote headline",
	},
	{
		"<leader>H",
		action("org_mappings.do_promote", true),
		ft = "org",
		mode = "n",
		desc = "org promote subtree",
	},
	{
		"<leader>L",
		action("org_mappings.do_demote", true),
		ft = "org",
		mode = "n",
		desc = "org demote subtree",
	},
	{
		"<leader>j",
		action("org_mappings.move_subtree_down"),
		ft = "org",
		mode = "n",
		desc = "org move subtree down",
	},
	{
		"<leader>k",
		action("org_mappings.move_subtree_up"),
		ft = "org",
		mode = "n",
		desc = "org move subtree up",
	},

	-- insert mode
	{
		"<S-CR>",
		action("org_mappings.meta_return"),
		ft = "org",
		mode = "i",
		desc = "Meta return (smart insertion)",
	},
	{
		"<C-h>",
		action("org_mappings.do_promote"),
		ft = "org",
		mode = "i",
		desc = "org promote heading",
	},
	{
		"<C-l>",
		action("org_mappings.do_demote"),
		ft = "org",
		mode = "i",
		desc = "org demote heading",
	},

	-- Toggles
	{
		"<leader>td",
		action("org_mappings.org_toggle_timestamp_type"),
		ft = "org",
		mode = "n",
		desc = "org toggle timestamp type",
	},
	{
		"<leader>:",
		action("org_mappings.set_tags"),
		ft = "org",
		mode = "n",
		desc = "org set tags",
	},

	-- Jira
	{
		"<leader>ojf",
		function() require("ext.orgmode.jira").fetch_issue() end,
		ft = "org",
		mode = "n",
		desc = "Fetch Jira issue for headline",
	},
}

vim.cmd([[autocmd ColorScheme * hi link @org.todo @comment.note]])

local function config()
	local Menu = require("org-modern.menu")
	local Date = require("orgmode.objects.date")

	require("orgmode").setup({
		org_agenda_files = { "~/orgfiles/inbox.org", "~/orgfiles/log.org", "~/orgfiles/projects.org", "~/orgfiles/personal.org" },
		org_default_notes_file = "~/orgfiles/inbox.org",
		org_use_property_inheritance = false,
		org_id_link_to_org_use_id = true,
		org_todo_keywords = { "TODO", "|", "DONE", "CANCELLED" },
		org_agenda_skip_scheduled_if_done = true,
		org_agenda_skip_deadline_if_done = true,
		org_todo_keyword_faces = {
			TODO = "",
			DONE = "",
			CANCELLED = ":slant italic",
		},
		org_startup_folded = "showeverything",
		org_startup_indented = true,
		org_agenda_custom_commands = {
			c = {
				description = "Combined view",
				types = {
					{
						type = "tags_todo",
						org_agenda_files = { "~/orgfiles/log.org", "~/orgfiles/inbox.org" },
						org_agenda_sorting_strategy = { 'priority-down' }
					},
				},
			},
		},
		org_capture_templates = {
			t = {
				description = "Task",
				template = {
					[[* TODO %?]],
					[[:PROPERTIES:]],
					[[:CREATED: %U]],
					[[:END:]],
				},
			},
			m = {
				description = "Current Meeting",
				target = "~/orgfiles/log.org",
				datetree = { tree_type = "week" },
				template = [[%(
						  return vim.system({ "org-schedule-now",  "dylan.kendal@blvd.co" }):wait().stdout
						)]],
			},
			d = {
				description = "Daily log",
				target = "~/orgfiles/log.org",
				datetree = { tree_type = "week" },
				template = {
					[[* %?]],
					[[:PROPERTIES:]],
					[[:CREATED: %U]],
					[[:END:]],
				},
			},
		},
		hyperlinks = {
			sources = {
				require("ext.orgmode.hyperlinks.sources.jira"),
				require("ext.orgmode.hyperlinks.sources.people"),
			},
		},
		org_edit_src_filetype_map = {},
		org_adapt_indentation = false,
		mappings = {
			disable_all = false,
			org_return_uses_meta_return = false,
			prefix = "<Leader>o",
			global = {
				org_agenda = "<prefix>a",
				org_capture = "<prefix>c",
			},
			agenda = {
				org_agenda_later = "f",
				org_agenda_earlier = "b",
				org_agenda_goto_today = ".",
				org_agenda_day_view = "vd",
				org_agenda_week_view = "vw",
				org_agenda_month_view = "vm",
				org_agenda_year_view = "vy",
				org_agenda_quit = "q",
				org_agenda_switch_to = "<CR>",
				org_agenda_goto = "<TAB>",
				org_agenda_goto_date = "J",
				org_agenda_redo = "r",
				org_agenda_todo = "t",
				org_agenda_clock_goto = "<prefix>xj",
				org_agenda_set_effort = "<prefix>xe",
				org_agenda_clock_in = "I",
				org_agenda_clock_out = "O",
				org_agenda_clock_cancel = "X",
				org_agenda_clockreport_mode = "R",
				org_agenda_priority = "<prefix>,",
				org_agenda_priority_up = "+",
				org_agenda_priority_down = "-",
				org_agenda_archive = "<prefix>$",
				org_agenda_toggle_archive_tag = "<prefix>A",
				org_agenda_set_tags = "<prefix>t",
				org_agenda_deadline = "<prefix>id",
				org_agenda_schedule = "<prefix>is",
				org_agenda_filter = "/",
				org_agenda_refile = "<prefix>r",
				org_agenda_add_note = "<prefix>na",
				org_agenda_preview = "K",
				org_agenda_show_help = "g?",
			},
			capture = {
				org_capture_finalize = "<C-c>",
				org_capture_refile = "<prefix>r",
				org_capture_kill = "<prefix>k",
				org_capture_show_help = "g?",
			},
			note = {
				org_note_finalize = "<C-c>",
				org_note_kill = "<prefix>k",
			},
			org = {
				org_do_promote = "<<",
				org_do_demote = ">>",
				org_promote_subtree = "<s",
				org_demote_subtree = ">s",
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

	local EventManager = require('orgmode.events')

	EventManager.listen(EventManager.event.TodoChanged, function(event)
		-- Only set CREATED if this is a new TODO (old_todo_state is nil/empty)
		if not event.old_todo_state and event.headline and event.headline:get_todo() then
			if not event.headline:get_property('CREATED') then
				local now = Date.now()
				event.headline:set_property('CREATED', now:to_wrapped_string(true))
			end
		end
	end)
end

--- @type LazyPluginSpec
return {
	"nvim-orgmode/orgmode",
	dependencies = {
		-- { "akinsho/org-bullets.nvim",     ft = { "org" }, opts = {} },
		{ "lukas-reineke/headlines.nvim", ft = { "org" }, opts = {} },
		{ "danilshvalov/org-modern.nvim", ft = { "org" } },
	},
	event = "VeryLazy",
	ft = { "org" },
	keys = keys,
	config = config,
}
