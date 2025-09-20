local M = {}

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
						pattern = "$HEADLINE_ITEM",
					},
				},
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
									regex = "ID",
								},
							},
							{
								has = {
									field = "value",
									pattern = "$ID",
								},
							},
						},
					},
				},
			},
		},
	},
}

local function format_org(item, picker)
	local format = require("snacks.picker.format")
	local highlight = require("snacks.picker.util.highlight")

	---@type snacks.picker.Highlight[]
	local ret = {}

	vim.list_extend(ret, format.file(item, picker))
	highlight.format(item, item.text, ret)

	return ret
end

local function transform_ast_grep(item)
	---@type astgrep.Item
	local data = vim.json.decode(item.text)

	---@type snacks.picker.finder.Item
	return {
		file = data.file,
		text = data.text,
		severity = data.severity,
		pos = {
			data.range.start.line + 1,
			data.range.start.column,
		},
		end_pos = {
			data.range["end"].line + 1,
			data.range["end"].column,
		},
		labels = data.labels,
		meta_variables = data["metaVariables"],
	}
end

local function finder_ast_grep(opts, path)
	local inline_rule = vim.json.encode(opts.inline_rule)

	return function(_opts, ctx)
		return require("snacks.picker.source.proc").proc({
			cmd = "ast-grep",
			args = {
				[[--config]],
				vim.fn.fnamemodify([[~/orgfiles/sgconfig.yml]], ":p"),
				[[scan]],
				[[--globs=!old_notes/**/*]],
				[[--json=stream]],
				[[--inline-rules]],
				inline_rule,
				path,
			},
			transform = transform_ast_grep,
		}, ctx)
	end
end

function M.org_buf_headlines()
	Snacks.picker.pick("Org Buffer Headlines", {
		source = "org buffer headlines",
		buf = 0,
		format = format_org,
		finder = finder_ast_grep({
			inline_rule = {
				id = "org-headlines",
				language = "org",
				rule = {
					kind = "headline",
				},
			},
		}, vim.api.nvim_buf_get_name(0)),
	})
end

local function org_url(rule_or_regex)
	local rule = {}
	if type(rule_or_regex) == "string" then
		rule = {
			regex = rule_or_regex,
			matches = "isUrl",
		}
	elseif vim.isarray(rule_or_regex) then
		local acc = {}

		for index, value in ipairs(rule_or_regex) do
			acc[index] = {
				regex = value,
				matches = "isUrl",
			}
		end

		rule = {
			any = acc,
		}
	end

	Snacks.picker.pick("Org urls", {
		source = "Org urls",
		format = format_org,
		finder = finder_ast_grep({
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
									field = "url",
								},
							},
							{
								kind = "expr",
								inside = {
									kind = "link",
									field = "url",
								},
							},
						},
					},
				},
				rule = rule,
			},
		}, "."),
	})
end

function M.insert_org_headline_with_id()
	Snacks.picker.pick("Org urls", {
		source = "Org urls",
		format = format_org,
		finder = finder_ast_grep({
			inline_rule = rule_org_headline_with_id,
		}, "."),
		confirm = function(picker, item)
			local captures = item.meta_variables.single
			local headline_item = captures.HEADLINE_ITEM.text
			local id = captures.ID.text

			local line = ("[[id:%s][%s]]"):format(id, headline_item)

			picker:close()
			vim.api.nvim_put({ line }, "c", true, true)
		end,
	})
end

---@param url_or_buf string | integer | nil
function M.org_backlinks(url_or_buf)
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

	org_url(acc)
end

function M.org_headlines(path)
	Snacks.picker.pick("Org Headlines", {
		source = "org headlines",
		format = format_org,
		finder = finder_ast_grep({
			inline_rule = {
				id = "org-headlines",
				language = "org",
				rule = {
					kind = "headline",
				},
			},
		}, vim.fn.fnamemodify(path, ":p")),
	})
end


return M
