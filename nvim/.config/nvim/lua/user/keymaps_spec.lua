local T = require("pl.tablex")

local function glob2re(glob)
	local s = glob
	s = string.gsub(s, "*", "(.+)")
	s = string.gsub(s, "{(.-)}", function(str)
		return "(" .. string.gsub(str, ",", "|") .. ")"
	end)
	return s
end

local function glob2capture(glob)
	local idx = 0
	local s = glob

	local function ref()
		idx = idx + 1
		return "%" .. idx
	end

	s = string.gsub(glob, "*", ref)
	s = string.gsub(s, "{(.-)}", ref)
	s = string.gsub(s, "%[(.-)%]", ref)

	return s
end

it("does the thing", function()
	local function f(src, test)
		return T.map(function(glob)
			return {
				glob2re(glob),
				glob2capture(glob),
			}
		end, { src, test })
	end

	local v = f("src/*.hs", "spec/*Spec.hs")

	assert.are.equal(v, "")
end)

it("glob2capture can parse asterics", function()
	assert.are.equal(glob2capture("src/*.hs"), "src/%1.hs")
end)

it("glob2capture can parse choices", function()
	print(string.match("[ab]a", "aa"))
	assert.are.equal("src/%1.%2", glob2capture("src/{test,spec}.{ts,tsx,js,jsx}"))
end)

it("glob2capture can parse character sets", function()
	assert.are.equal(glob2capture("src/[ab].hs"), "src/%1.hs")
end)

it("glob2re can parse asterics", function()
	assert.are.equal(glob2re("src/*.hs"), "src/(.+).hs")
end)

it("glob2re can parse choices", function()
	assert.are.equal("src/(test|spec).(ts|tsx|js|jsx)", glob2re("src/{test,spec}.{ts,tsx,js,jsx}"))
end)

it("glob2re can parse character sets", function()
	assert.are.equal(glob2re("src/[ab].hs"), "src/[ab].hs")
end)
