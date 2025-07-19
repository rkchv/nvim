-- Performance optimizations
vim.loader.enable()
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Disable unused providers for faster startup
vim.g.loaded_ruby_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_node_provider = 0

-- Set leader keys early
vim.g.mapleader = " "
vim.g.maplocalleader = ","

-- Netrw settings (if you still use it occasionally)
vim.g.netrw_browse_split = 0
vim.g.netrw_banner = 0
vim.g.netrw_winsize = 25

-- Load core modules with error handling
local function safe_require(module)
	local ok, result = pcall(require, module)
	if not ok then
		vim.notify("Failed to load " .. module .. ": " .. result, vim.log.levels.ERROR)
		return false
	end
	return result
end

-- Load modules in order of dependency
safe_require("rkchv.core.lazy")
safe_require("rkchv.config.lazy")
safe_require("rkchv.config.set")
safe_require("rkchv.config.remap")

-- Initialize performance monitoring
local performance = safe_require("rkchv.core.performance")
if performance then
	performance.setup_performance_autocmds()
end
