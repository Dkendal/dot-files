local M = {}

function M.pack_name(name)
	return vim.fs.basename(name)
end

function M.github_url(name)
	return string.format("git@github.com:%s.git", name)
end

function M.clone_dir(name)
	local pack_dir, basename = unpack(vim.split(name, "/", { plain = true }))
	return string.format("~/.config/nvim/pack/%s/opt/%s", pack_dir, basename)
end

function M.package_install_cmd(name, opts)
	return string.format("git clone %s %s --depth=1", M.github_url(name), M.clone_dir(name))
end

function M.package_install(name, opts)
	opts = opts or {}

	local dry_run = opts.dry_run or false

	local ok = xpcall(function()
		local cmd = M.package_install_cmd(name)

		if dry_run then
			vim.print(string.format("Would run: %s", cmd))
			return
		else
			vim.fn.system(cmd)
		end
	end, function(err)
		vim.print(string.format("Error installing %s: %s", name, vim.inspect(err)))
	end)
end

function M.packadd(name, cb)
	name = M.pack_name(name)

	local ok, res = xpcall(function()
		vim.cmd.packadd(name)
		if cb then
			cb()
		end
	end, debug.traceback)

	if not ok then
		vim.notify(string.format("Error loading %s: %s", name, res), vim.log.levels.ERROR)
	end

	return ok, res
end

---@param f function
function M.protected(f)
	return xpcall(f, function(err)
		vim.notify_once(vim.inspect(err), vim.log.levels.ERROR)
	end)
end

---@param pkgname string Name of the lua module to test for installation
---@param modname string Name of the lua rock package
--- Check if a lua rock is installed and install it if not
function M.ensure_rock(_pkgname, modname)
	local ok, _res = pcall(require, modname)
	if not ok then
		vim.notify(string.format("Installing %s", modname), vim.log.levels.INFO)
		local res
		ok, res = pcall(vim.fn.system, string.format("luarocks install %s", modname))
		if not ok then
			vim.notify(string.format("Error installing %s: %s", modname, res), vim.log.levels.ERROR)
		end
	end
end

function M.safe_require(name, f)
	local ok, res = xpcall(require, debug.traceback, name)

	if not ok then
		vim.notify(string.format("Error loading %s: %s", name, res), vim.log.levels.ERROR)
	end

	if f then
		f(res)
	end
end

function M.init()
	vim.api.nvim_create_user_command("PackageInstall", function(args)
		M.package_install(args.fargs[1])
	end, {
		nargs = 1,
	})
end

return M
