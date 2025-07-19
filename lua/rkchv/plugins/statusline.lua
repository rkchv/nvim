local M = {}

-- Constants for better maintainability
local DISABLED_FILETYPES = { "alpha", "dashboard", "fzf", "lazy", "mason", "TelescopePrompt" }
local REFRESH_INTERVAL = 1000

-- Helper function to create section components
local function create_section_components()
	return {
		lualine_a = { "mode" },
		lualine_b = { "branch", "diff", "diagnostics" },
		lualine_c = {
			{
				"filename",
				path = 1,
			},
		},
		lualine_x = {
			{ "progress", separator = " ", padding = { left = 1, right = 0 } },
			{ "location", padding = { left = 0, right = 1 } },
		},
		lualine_y = { "filetype" },
		lualine_z = { "encoding" },
	}
end

-- Helper function to create options configuration
local function create_options()
	return {
		icons_enabled = false,
		theme = "auto",
		disabled_filetypes = {
			statusline = DISABLED_FILETYPES,
		},
		always_divide_middle = true,
		refresh = {
			statusline = REFRESH_INTERVAL,
			tabline = REFRESH_INTERVAL,
			winbar = REFRESH_INTERVAL,
		},
	}
end

M.config = {
	"nvim-lualine/lualine.nvim",
	enabled = true,
	lazy = false,
	opts = function(_, opts)
		opts.options = create_options()
		opts.sections = create_section_components()
		opts.extensions = { "lazy" }
	end,
}

return M.config
