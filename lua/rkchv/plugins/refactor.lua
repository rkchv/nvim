return {
	{
		"ThePrimeagen/refactoring.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
		},
		lazy = false,
		config = function()
			require("refactoring").setup()
		end,
	},

	-- Autoformat
	{
		"stevearc/conform.nvim",
		lazy = false,
		config = function()
			require("conform").setup({
				formatters_by_ft = {
					-- html = { "eslint_d" },
					html = { "prettierd", "prettier" },
					lua = { "stylua" },
					javascript = { "prettierd", "prettier" },
					typescript = { "prettierd", "prettier" },
					javascriptreact = { "prettierd", "prettier" },
					typescriptreact = { "prettierd", "prettier" },
					json = { "prettierd", "prettier" },
					css = { "prettierd", "prettier" },
					scss = { "prettierd", "prettier" },
					markdown = { "prettierd", "prettier" },
					bash = { "beautysh" },
					yml = { "ymlfix" },
					proto = { "buf" },
					sh = { "shellcheck" },
					go = { "gofumpt" },
				},
				format_on_save = {
					timeout_ms = 500,
					lsp_fallback = true,
				},
				stop_after_first = false,
			})
		end,
	},

	-- Find and replace
	{
		"MagicDuck/grug-far.nvim",
		config = function()
			require("grug-far").setup({})
		end,
	},

	-- Helpers
	{
		"echasnovski/mini.nvim",
		version = false,
		config = function()
			require("mini.comment").setup()
			require("mini.move").setup()
			require("mini.ai").setup()
			require("mini.pairs").setup()
			require("mini.surround").setup({
				{
					custom_surroundings = nil,
					highlight_duration = 500,
					mappngs = {
						-- Add surroundng in Normal and Visual modes
						add = "sa",
						-- Delete surrounding
						delete = "sd",
						-- Find surrounding (to the right)
						find = "sf",
						-- Find surrounding (to the left)
						find_left = "sF",
						-- Highlight surrounding
						highlight = "sh",
						-- Replace surrounding
						replace = "sr",
						-- Update `n_lines`
						update_n_lines = "sn",
						-- Suffix to search with "prev" method
						suffix_last = "l",
						-- Suffix to search with "next" method
						suffix_next = "n",
					},
					n_lines = 20,
					respect_selection_type = false,
					search_method = "cover",
					silent = true,
				},
			})
		end,
	},
}
