return {
	"tpope/vim-fugitive",
	-- "tpope/vim-surround",
	{
		"tpope/vim-obsession",
		enabled = true,
		cmd = "Obsession",
	},
	"ThePrimeagen/git-worktree.nvim",
	{
		"folke/todo-comments.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = { signs = false },
	},
	{
		"mg979/vim-visual-multi",
		branch = "master",
		config = function()
			vim.keymap.set("n", "<c-n>", ":call vm#commands#find_under()<CR>", { noremap = true, silent = true })
		end,
	},
	{
		"rmagatti/goto-preview",
		event = "BufEnter",
		config = function()
			require("goto-preview").setup({
				width = 120, -- Width of the floating window
				height = 15, -- Height of the floating window
				border = { "↖", "─", "┐", "│", "┘", "─", "└", "│" }, -- Border characters of the floating window
				default_mappings = true,
				-- nnoremap gpd <cmd>lua require('goto-preview').goto_preview_definition()<CR>
				-- nnoremap gpt <cmd>lua require('goto-preview').goto_preview_type_definition()<CR>
				-- nnoremap gpi <cmd>lua require('goto-preview').goto_preview_implementation()<CR>
				-- nnoremap gpD <cmd>lua require('goto-preview').goto_preview_declaration()<CR>
				-- nnoremap gP <cmd>lua require('goto-preview').close_all_win()<CR>
				-- nnoremap gpr <cmd>lua require('goto-preview').goto_preview_references()<CR>
				debug = false, -- Print debug information
				opacity = nil, -- 0-100 opacity level of the floating window where 100 is fully transparent.
				resizing_mappings = false, -- Binds arrow keys to resizing the floating window.
				post_open_hook = nil, -- A function taking two arguments, a buffer and a window to be ran as a hook.
				references = { -- Configure the telescope UI for slowing the references cycling window.
					telescope = require("telescope.themes").get_dropdown({ hide_preview = false }),
				},
				-- These two configs can also be passed down to the goto-preview definition and implementation calls for one off "peak" functionality.
				focus_on_open = true, -- Focus the floating window when opening it.
				dismiss_on_move = false, -- Dismiss the floating window when moving the cursor.
				force_close = true, -- passed into vim.api.nvim_win_close's second argument. See :h nvim_win_close
				bufhidden = "wipe", -- the bufhidden option to set on the floating window. See :h bufhidden
				stack_floating_preview_windows = true, -- Whether to nest floating windows
				preview_window_title = { enable = true, position = "left" }, -- Whether
			})
		end,
	},
	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		config = function()
			require("nvim-autopairs").setup({})
		end,
	},
}
