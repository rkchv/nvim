return {
	{
		"chentoast/marks.nvim",
		enabled = false,
		config = function()
			require("marks").setup({
				default_mappings = true,
			})
		end,
	},
	{
		"lukas-reineke/indent-blankline.nvim",
		main = "ibl",
		opts = {
			indent = { char = "│" },
			scope = {
				enabled = true,
			},
		},
		config = function(_, opts)
			require("ibl").setup(opts)
		end,
	},
	{
		"rebelot/kanagawa.nvim",
		config = function(_, opts)
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
		end,
	},
	{
		"kyazdani42/nvim-web-devicons",
		enable = true,
	},
	{
		"folke/todo-comments.nvim",
		enable = true,
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = { signs = false },
	},
}
