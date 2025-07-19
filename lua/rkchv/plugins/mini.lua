return {
	{
		"echasnovski/mini.nvim",
		version = false,
		config = function()
			require("mini.ai").setup({
				mappings = {
					around = "a",
					inside = "i",

					around_next = "an",
					inside_next = "in",
					around_last = "al",
					inside_last = "il",

					goto_left = "g[",
					goto_right = "g]",
				},

				-- Number of lines within which textobject is searched
				n_lines = 50,

				-- How to search for object (first inside current line, then inside
				-- neighborhood). One of 'cover', 'cover_or_next', 'cover_or_prev',
				-- 'cover_or_nearest', 'next', 'previous', 'nearest'.
				search_method = "cover_or_next",

				-- Whether to disable showing non-error feedback
				-- This also affects (purely informational) helper messages shown after
				-- idle time if user input is required.
				silent = false,
			})
			require("mini.comment").setup()
			require("mini.move").setup({
				mappings = {
					-- Move visual selection in Visual mode. Defaults are Alt (Meta) + hjkl.
					left = "<M-h>",
					right = "<M-l>",
					down = "<M-j>",
					up = "<M-k>",

					-- Move current line in Normal mode
					line_left = "<M-h>",
					line_right = "<M-l>",
					line_down = "<M-j>",
					line_up = "<M-k>",
				},

				-- Options which control moving behavior
				options = {
					-- Automatically reindent selection during linewise vertical move
					reindent_linewise = true,
				},
			})
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
