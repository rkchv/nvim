return {
	{
		"NeogitOrg/neogit",
		enabled = true,
		lazy = false,
		dependencies = {
			"nvim-lua/plenary.nvim",
			"sindrets/diffview.nvim",
			"nvim-telescope/telescope.nvim",
		},
		config = function()
			local neogit = require("neogit")
			neogit.setup()

			vim.keymap.set("n", "<leader>go", function()
				neogit.open()
			end, { desc = "Open Neogit" })

			vim.keymap.set("n", "<leader>gc", ":Neogit commit<CR>", { silent = true, noremap = true })
			vim.keymap.set("n", "<leader>gp", ":Neogit pull<CR>", { silent = true, noremap = true })
			vim.keymap.set("n", "<leader>gs", ":Neogit push<CR>", { silent = true, noremap = true })
			vim.keymap.set("n", "<leader>gb", ":Telescope git_branches<CR>", { silent = true, noremap = true })
			vim.keymap.set("n", "<leader>gB", ":G blame<CR>", { silent = true, noremap = true })
		end,
	},
	{
		"lewis6991/gitsigns.nvim",

		opts = function(_, opts)
			opts.signs = {
				add = { text = "+" },
				change = { text = "~" },
				delete = { text = "_" },
				topdelete = { text = "‾" },
				changedelete = { text = "~" },
			}

			opts.signs_staged_enable = false
			opts.current_line_blame = true
			opts.current_line_blame_formatter = "<author>, <author_time:%Y-%m-%d> - <summary>"
			opts.trouble = false
		end,

		config = function(_, opts)
			require("gitsigns").setup(opts)
		end,
	},
}
