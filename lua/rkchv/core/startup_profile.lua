local M = {}

local profile_data = {}
local start_time = vim.loop.hrtime()

function M.start_profile(name)
	profile_data[name] = {
		start = vim.loop.hrtime(),
		name = name,
	}
end

function M.end_profile(name)
	if profile_data[name] then
		local end_time = vim.loop.hrtime()
		local duration = (end_time - profile_data[name].start) / 1000000 -- Convert to milliseconds
		profile_data[name].duration = duration
	end
end

function M.print_profile_results()
	local results = {}
	for name, data in pairs(profile_data) do
		if data.duration then
			table.insert(results, { name = name, duration = data.duration })
		end
	end

	-- Sort by duration (slowest first)
	table.sort(results, function(a, b)
		return a.duration > b.duration
	end)

	print("=== Startup Profile Results ===")
	for i, result in ipairs(results) do
		print(string.format("%2d. %-30s %8.2fms", i, result.name, result.duration))
	end

	-- Calculate total time
	local total_time = 0
	for _, result in ipairs(results) do
		total_time = total_time + result.duration
	end
	print(string.format("Total startup time: %.2fms", total_time))
end

-- Profile Lazy.nvim loading
function M.profile_lazy()
	M.start_profile("Lazy.nvim Setup")

	-- Hook into Lazy's loading process
	local original_require = require
	require = function(module)
		if module:match("^rkchv%.") then
			M.start_profile("Module: " .. module)
			local result = original_require(module)
			M.end_profile("Module: " .. module)
			return result
		end
		return original_require(module)
	end
end

-- Setup profiling
function M.setup()
	M.profile_lazy()

	-- Print results after startup
	vim.api.nvim_create_autocmd("VimEnter", {
		callback = function()
			vim.defer_fn(M.print_profile_results, 200)
		end,
	})
end

return M

