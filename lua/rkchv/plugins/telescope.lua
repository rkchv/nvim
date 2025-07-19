-- Telescope Configuration Module
local M = {}

-- Telescope performance and quality settings
M.telescope_settings = {
	-- File types where telescope is most useful
	priority_filetypes = {
		"lua",
		"go",
		"javascript",
		"typescript",
		"python",
		"c",
		"cpp",
		"rust",
	},

	-- File types where telescope should be disabled
	disabled_filetypes = {
		"gitcommit",
		"gitrebase",
		"hgcommit",
		"svn",
		"cvs",
		".",
	},

	-- Maximum file size for telescope operations (100KB)
	max_filesize = 100 * 1024,

	-- File patterns to ignore
	file_ignore_patterns = {
		"node_modules",
		".git/",
		"dist",
		"build",
		"target",
		"*.pyc",
		"__pycache__",
		".DS_Store",
		"*.so",
		"*.dylib",
		"*.dll",
		"*.exe",
		"*.out",
		"*.log",
		"*.tmp",
		"*.temp",
	},
}

-- Helper function to get all ignore patterns
function M.get_file_ignore_patterns()
	return M.telescope_settings.file_ignore_patterns
end

-- Helper function to check if file should be ignored
function M.should_ignore_file(filename)
	for _, pattern in ipairs(M.telescope_settings.file_ignore_patterns) do
		if filename:match(pattern) then
			return true
		end
	end
	return false
end

-- Helper function to check if telescope should be enabled for current filetype
function M.should_enable_telescope()
	local filetype = vim.bo.filetype
	return not vim.tbl_contains(M.telescope_settings.disabled_filetypes, filetype)
end

-- Helper function to get disabled filetypes as a list
function M.get_disabled_filetypes_list()
	return M.telescope_settings.disabled_filetypes
end

-- Diagnostic function for telescope
function M.check_telescope_status()
	print("=== Telescope Status Check ===")

	-- Check if telescope is loaded
	local telescope_ok, telescope = pcall(require, "telescope")
	if telescope_ok then
		print("✅ Telescope is available")
	else
		print("❌ Telescope is NOT available")
		return false
	end

	-- Check if builtin functions are available
	local builtin_ok, builtin = pcall(require, "telescope.builtin")
	if builtin_ok then
		print("✅ Telescope builtin functions are available")
	else
		print("❌ Telescope builtin functions are NOT available")
		return false
	end



	-- Check if refactoring extension is loaded
	local refactoring_ok, _ = pcall(require, "telescope.extensions.refactoring")
	if refactoring_ok then
		print("✅ Telescope refactoring extension is available")
	else
		print("⚠️  Telescope refactoring extension is NOT available")
	end

	-- Check current filetype
	local filetype = vim.bo.filetype
	print("📄 Current filetype: " .. filetype)

	-- Check if filetype is disabled
	if vim.tbl_contains(M.telescope_settings.disabled_filetypes, filetype) then
		print("⚠️  Telescope is disabled for this filetype")
	else
		print("✅ Telescope should work for this filetype")
	end

	-- Check file size
	local filename = vim.api.nvim_buf_get_name(0)
	if filename and filename ~= "" then
		local ok, stats = pcall(vim.loop.fs_stat, filename)
		if ok and stats and stats.size > M.telescope_settings.max_filesize then
			print("⚠️  File is large (" .. math.floor(stats.size / 1024) .. "KB), telescope may be slow")
		end
	end

	return true
end

-- Setup telescope configuration
function M.setup_telescope_config()
	local actions = require("telescope.actions")
	local trouble_ok, trouble = pcall(require, "trouble.providers.telescope")

	local config = {
		-- Better defaults for a smoother experience
		prompt_prefix = " ",
		selection_caret = " ",
		path_display = { "truncate" },
		file_ignore_patterns = M.get_file_ignore_patterns(),
		
		-- Improved layout and display - centered and compact
		layout_config = {
			horizontal = {
				prompt_position = "top",
				preview_width = 0,
				results_width = 0.6,
			},
			vertical = {
				mirror = false,
			},
			width = 0.5,
			height = 0.5,
			preview_cutoff = 0,
		},
		
		-- Better sorting and filtering
		sorting_strategy = "ascending",
		scroll_strategy = "cycle",
		color_devicons = true,
		
		-- Enhanced mappings
		mappings = {
			i = {
				["<c-j>"] = actions.move_selection_next,
				["<c-k>"] = actions.move_selection_previous,
				["<c-n>"] = actions.cycle_history_next,
				["<c-p>"] = actions.cycle_history_prev,
				["<c-c>"] = actions.close,
				["<c-u>"] = actions.preview_scrolling_up,
				["<c-d>"] = actions.preview_scrolling_down,
				["<c-q>"] = actions.send_to_qflist + actions.open_qflist,
			},
			n = {
				["<c-j>"] = actions.move_selection_next,
				["<c-k>"] = actions.move_selection_previous,
				["<c-q>"] = actions.send_to_qflist + actions.open_qflist,
				["q"] = actions.close,
			},
		},
	}

	-- Add trouble integration if available
	if trouble_ok then
		config.mappings.i["<c-t>"] = require("trouble.sources.telescope").open
		config.mappings.n["<c-t>"] = require("trouble.sources.telescope").open
	end

	return config
end

-- Setup telescope pickers
function M.setup_telescope_pickers()
	return {
		find_files = {
			hidden = true,
			no_ignore = true,
			no_ignore_parent = true,
			follow = true,
			-- Include dotfiles but exclude .git directory
			file_ignore_patterns = M.get_file_ignore_patterns(),
		},
		git_files = {
			hidden = true,
			show_untracked = true,
			recurse_submodules = true,
		},
		live_grep = {
			additional_args = function()
				return { "--hidden", "--no-ignore", "--glob", "!.git/*" }
			end,
		},
		grep_string = {
			additional_args = function()
				return { "--hidden", "--no-ignore", "--glob", "!.git/*" }
			end,
		},
		diagnostics = {
			initial_mode = "normal",
		},
		oldfiles = {
			prompt_title = "History",
			results_title = "Recent Files",
		},
		buffers = {
			initial_mode = "normal",
			sort_mru = true,
			ignore_current_buffer = true,
		},
		keymaps = {
			show_plug = false,
		},
	}
end

-- Setup telescope keymaps (conflict-free)
function M.setup_telescope_keymaps()
	local builtin = require("telescope.builtin")
	local map = vim.keymap.set

	-- File and search mappings (conflict-free)
	map("n", "<leader><tab>", builtin.commands, { desc = "Show available commands" })
	map("n", "<leader>?", builtin.oldfiles, { desc = "Recently opened files" })
	map("n", "<leader>/", builtin.current_buffer_fuzzy_find, { desc = "Search in current buffer" })
	map("n", "<leader>fd", builtin.diagnostics, { desc = "Search diagnostics" })
	map("n", "<leader>fj", builtin.find_files, { desc = "Find files" })
	map("n", "<leader>ff", builtin.live_grep, { desc = "Live grep" })
	map("n", "<leader>fw", builtin.grep_string, { desc = "Search word under cursor" })
	map("n", "<leader>fb", builtin.buffers, { desc = "Show buffers" })
	map("n", "<leader>fk", builtin.keymaps, { desc = "Find keymaps" })
	map("n", "<leader>fh", builtin.help_tags, { desc = "Search help tags" })
	map("n", "<leader>fm", builtin.marks, { desc = "Search marks" })
	map("n", "<leader>fo", builtin.vim_options, { desc = "Search vim options" })
	map("n", "<leader>fc", builtin.command_history, { desc = "Command history" })
	map("n", "<leader>fs", builtin.search_history, { desc = "Search history" })

	-- Git mappings (using conflict-free prefixes)
	map("n", "<leader>tc", builtin.git_commits, { desc = "Git commits" })
	map("n", "<leader>tb", builtin.git_bcommits, { desc = "Git commits for buffer" })
	map("n", "<leader>ts", builtin.git_status, { desc = "Git status" })
	map("n", "<leader>tt", builtin.git_stash, { desc = "Git stash" })

	-- Refactoring (conflict-free)
	map({ "n", "x" }, "<leader>tr", function()
		local refactoring = require("telescope").extensions.refactoring
		refactoring.refactors()
	end, { desc = "Refactoring actions" })

	-- Additional tools
	map("n", "<leader>td", ":TodoTelescope<CR>", { desc = "Todo list" })
	map("n", "<leader>cl", "<cmd>Telescope neoclip<CR>", { desc = "Clipboard history" })
	

end

-- Setup telescope extensions
function M.setup_telescope_extensions()
	local telescope = require("telescope")
	
	-- Load refactoring extension
	local refactoring_ok, _ = pcall(require, "telescope.extensions.refactoring")
	if refactoring_ok then
		telescope.load_extension("refactoring")
	end
end

-- Setup autocmds for better telescope integration
function M.setup_autocmds()
	-- Enable enhanced telescope features for priority filetypes
	vim.api.nvim_create_autocmd("FileType", {
		pattern = M.telescope_settings.priority_filetypes,
		callback = function()
			-- Enable enhanced telescope features for priority filetypes
			vim.bo.buftype = ""
		end,
	})

	-- Disable telescope for certain filetypes
	vim.api.nvim_create_autocmd("FileType", {
		pattern = M.telescope_settings.disabled_filetypes,
		callback = function()
			-- Disable telescope for these filetypes
			vim.b.telescope_enabled = false
		end,
	})
end

-- Setup neoclip configuration
function M.setup_neoclip()
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
				},
				n = {
					paste = "<CR>",
				},
			},
		},
	})
end

return {
	{
		"nvim-telescope/telescope.nvim",
		enabled = true,
		cmd = { "Telescope" },

		dependencies = {
			"nvim-lua/plenary.nvim",
			"ThePrimeagen/refactoring.nvim",
		},

		opts = function(_, opts)
			opts.defaults = M.setup_telescope_config()
			opts.pickers = M.setup_telescope_pickers()
		end,

		config = function(_, opts)
			local telescope = require("telescope")
			telescope.setup(opts)
			
			M.setup_telescope_extensions()
			M.setup_telescope_keymaps()
			M.setup_autocmds()
		end,
	},
	{
		"AckslD/nvim-neoclip.lua",
		dependencies = {
			{ "nvim-telescope/telescope.nvim" },
		},
		config = function()
			M.setup_neoclip()
		end,
	},
}
