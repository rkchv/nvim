-- UI Plugins Configuration
-- This file contains all UI-related plugins for Neovim

-- Helper function to setup kanagawa theme
local function setup_kanagawa_theme()
	require("kanagawa").setup({
		overrides = function(colors)
			local theme = colors.theme
			return {
				WinSeparator = { fg = theme.ui.bg_p1 },
			}
		end,
		colors = {
			theme = {
				all = {
					ui = {
						bg_gutter = "none",
					},
				},
			},
		},
	})
	vim.cmd.colorscheme("kanagawa")
end

-- Helper function to setup marks
local function setup_marks()
	require("marks").setup({
		default_mappings = true,
	})
end



return {
	-- Marks plugin for managing bookmarks
	{
		"chentoast/marks.nvim",
		enabled = false,
		config = setup_marks,
	},

	-- Indent blankline for better code structure visualization
	{
		"lukas-reineke/indent-blankline.nvim",
		main = "ibl",
		opts = {
			indent = { char = "│" },
			scope = { enabled = true },
		},
		config = function(_, opts)
			require("ibl").setup(opts)
		end,
	},

	-- Kanagawa color scheme
	{
		"rebelot/kanagawa.nvim",
		config = setup_kanagawa_theme,
	},

	-- Web devicons for file type icons
	{
		"kyazdani42/nvim-web-devicons",
		enabled = true,
	},

	-- Todo comments highlighting
	{
		"folke/todo-comments.nvim",
		enabled = true,
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = { signs = false },
	},
}
