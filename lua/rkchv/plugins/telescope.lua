return {
	{
		"nvim-telescope/telescope.nvim",
		enabled = true,
		cmd = { "Telescope" },

		dependencies = {
			"nvim-lua/plenary.nvim",
			"ThePrimeagen/refactoring.nvim",
			{
				"nvim-telescope/telescope-fzf-native.nvim",
				build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release",
			},
		},

		opts = function(_, opts)
			local actions = require("telescope.actions")

			opts.defaults = {
				preview = false,
				layout_config = { height = 0.5, width = 0.60 },
				sorting_strategy = "ascending",
				mappings = {
					i = {
						["<c-j>"] = actions.move_selection_next,
						["<c-k>"] = actions.move_selection_previous,
					},
				},
			}
			opts.pickers = {
				find_files = { hidden = true, no_ignore = false },
				git_files = { hidden = true, no_ignore = false },
			}
		end,

		config = function(_, opts)
			local telescope = require("telescope")
			local builtin = require("telescope.builtin")

			telescope.setup(opts)
			telescope.load_extension("fzf")
			telescope.load_extension("refactoring")

			local refactoring = telescope.extensions.refactoring

			vim.keymap.set("n", "<leader><tab>", builtin.commands, { desc = "Show available commands" })
			vim.keymap.set("n", "<leader>?", builtin.oldfiles, { desc = "Recently opened files" })
			vim.keymap.set("n", "<leader>/", builtin.current_buffer_fuzzy_find, { desc = "Search here" })
			vim.keymap.set("n", "<leader>fd", builtin.diagnostics, { desc = "Search by diagnosticts" })
			vim.keymap.set("n", "<leader>fj", builtin.find_files, { desc = "Search needed file" })
			-- vim.keymap.set("n", "<leader>ff", builtin.grep_string, { desc = "Search word under cursor" })
			vim.keymap.set("n", "<leader>ff", builtin.live_grep, { desc = "Search word in all files" })
			vim.keymap.set("n", "<leader>gc", builtin.git_commits, { desc = "Search Git Commits" })
			vim.keymap.set("n", "<leader>gb", builtin.git_bcommits, { desc = "Search Git Commits for Buffer" })
			vim.keymap.set("n", "<leader>gs", builtin.git_status, { desc = "Changed files in repo" })
			vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "All opened session buffers" })
			vim.keymap.set("n", "<leader>fk", builtin.keymaps, { desc = "Find Keymaps" })

			vim.keymap.set({ "n", "x" }, "<leader>rr", function()
				refactoring.refactors()
			end)

			vim.keymap.set("n", "<leader>td", ":TodoTelescope<CR>", { desc = "Todo List" })
			vim.keymap.set("n", "<leader>cl", "<cmd>Telescope neoclip<CR>", { desc = "Telescope Neoclip" })
		end,
	},
	{
		"AckslD/nvim-neoclip.lua",
		dependencies = {
			{ "nvim-telescope/telescope.nvim" },
		},
		config = function()
			require("neoclip").setup({
				history = 1000,
				enable_persistent_history = false,
				length_limit = 1048576,
				continuous_sync = false,
				db_path = vim.fn.stdpath("data") .. "/databases/neoclip.sqlite3",
				filter = nil,
				preview = false,
				prompt = nil,
				default_register = '"',
				default_register_macros = "q",
				enable_macro_history = true,
				content_spec_column = false,
				disable_keycodes_parsing = false,
				on_select = {
					move_to_front = false,
					close_telescope = true,
				},
				on_paste = {
					set_reg = false,
					move_to_front = false,
					close_telescope = true,
				},
				on_replay = {
					set_reg = false,
					move_to_front = false,
					close_telescope = true,
				},
				on_custom_action = {
					close_telescope = true,
				},
				keys = {
					telescope = {
						i = {
							paste = "<CR>",
							-- select = "<cr>",
							-- paste_behind = "P",
							-- delete = "",
							-- replay = "",
							-- edit = "",
							-- custom = {},
						},
						n = {
							paste = "<CR>",
							-- select = "<cr>",
							-- paste_behind = "P",
							-- delete = "",
							-- replay = "",
							-- edit = "",
							-- custom = {},
						},
					},
				},
			})
		end,
	},
}
