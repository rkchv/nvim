-- Zen Mode Configuration Module
local M = {}

-- Zen mode configuration
M.zen_config = {
	window = {
		backdrop = 0.8,
		width = 100,
		height = 1,
		options = {},
	},
	plugins = {
		options = {
			enabled = true,
			ruler = false,
			showcmd = false,
			laststatus = 0,
		},
		gitsigns = { enabled = true },
		twilight = { enabled = true },
		tmux = { enabled = true },
		todo = { enabled = false },
	},
	on_open = function(win)
		-- require("gitsigns").toggle_signs(false)
	end,
	on_close = function()
		-- require("gitsigns").toggle_signs(true)
	end,
}

return {
	"folke/zen-mode.nvim",
	enabled = true,
	cmd = "ZenMode",
	opts = M.zen_config,
}
