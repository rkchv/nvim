-- Oil.nvim Configuration Module
local M = {}

-- Oil configuration quality control
M.oil_config = {
	-- File explorer settings
	default_file_explorer = true,

	-- Column display settings
	columns = {
		"icon",
		-- "permissions",
		-- "size",
		-- "mtime",
	},

	-- Buffer and window options
	buf_options = {
		buflisted = false,
		bufhidden = "hide",
	},

	win_options = {
		wrap = false,
		signcolumn = "no",
		cursorcolumn = false,
		foldcolumn = "0",
		spell = false,
		list = false,
		conceallevel = 3,
		concealcursor = "nvic",
	},

	-- File operation settings
	delete_to_trash = true,
	skip_confirm_for_simple_edits = true,
	prompt_save_on_select_new_entry = true,
	cleanup_delay_ms = 2000,

	-- LSP integration
	lsp_file_methods = {
		enabled = true,
		timeout_ms = 1000,
		autosave_changes = false,
	},

	-- Cursor constraints
	constrain_cursor = "editable",
	watch_for_changes = false,
}

-- Keymap configuration
M.keymaps = {
	["g?"] = { "actions.show_help", mode = "n" },
	["<CR>"] = "actions.select",
	["<C-s>"] = { "actions.select", opts = { vertical = true } },
	["<C-h>"] = { "actions.select", opts = { horizontal = true } },
	["<C-t>"] = { "actions.select", opts = { tab = true } },
	["<C-p>"] = "actions.preview",
	["<C-c>"] = { "actions.close", mode = "n" },
	["<C-l>"] = "actions.refresh",
	["-"] = { "actions.parent", mode = "n" },
	["_"] = { "actions.open_cwd", mode = "n" },
	["`"] = { "actions.cd", mode = "n" },
	["~"] = { "actions.cd", opts = { scope = "tab" }, mode = "n" },
	["gs"] = { "actions.change_sort", mode = "n" },
	["gx"] = "actions.open_external",
	["g."] = { "actions.toggle_hidden", mode = "n" },
	["g\\"] = { "actions.toggle_trash", mode = "n" },
}

-- View options configuration
M.view_options = {
	show_hidden = true,

	is_hidden_file = function(name, bufnr)
		local m = name:match("^%.")
		return m ~= nil
	end,

	is_always_hidden = function(name, bufnr)
		return false
	end,

	natural_order = "fast",
	case_insensitive = false,

	sort = {
		{ "type", "asc" },
		{ "name", "asc" },
	},

	highlight_filename = function(entry, is_hidden, is_link_target, is_link_orphan)
		return nil
	end,
}

-- Git integration configuration
M.git_config = {
	add = function(path)
		return false
	end,
	mv = function(src_path, dest_path)
		return false
	end,
	rm = function(path)
		return false
	end,
}

-- Float window configuration
M.float_config = {
	padding = 2,
	max_width = 0,
	max_height = 0,
	border = "rounded",

	win_options = {
		winblend = 0,
	},

	get_win_title = nil,
	preview_split = "auto",

	override = function(conf)
		return conf
	end,
}

-- Preview window configuration
M.preview_config = {
	update_on_cursor_moved = true,
	preview_method = "fast_scratch",

	disable_preview = function(filename)
		return false
	end,

	win_options = {},
}

-- Confirmation window configuration
M.confirmation_config = {
	max_width = 0.9,
	min_width = { 40, 0.4 },
	width = nil,
	max_height = 0.9,
	min_height = { 5, 0.1 },
	height = nil,
	border = "rounded",

	win_options = {
		winblend = 0,
	},
}

-- Progress window configuration
M.progress_config = {
	max_width = 0.9,
	min_width = { 40, 0.4 },
	width = nil,
	max_height = { 10, 0.9 },
	min_height = { 5, 0.1 },
	height = nil,
	border = "rounded",
	minimized_border = "none",

	win_options = {
		winblend = 0,
	},
}

-- SSH window configuration
M.ssh_config = {
	border = "rounded",
}

-- Keymaps help window configuration
M.keymaps_help_config = {
	border = "rounded",
}

-- Diagnostic function for Oil
function M.check_oil_status()
	print("=== Oil.nvim Status Check ===")

	-- Check if Oil plugin is loaded
	local oil_ok, oil = pcall(require, "oil")
	if oil_ok then
		print("✅ Oil.nvim is available")
	else
		print("❌ Oil.nvim is NOT available")
		return false
	end

	-- Check if nvim-web-devicons is loaded
	local devicons_ok, devicons = pcall(require, "nvim-web-devicons")
	if devicons_ok then
		print("✅ nvim-web-devicons is available")
	else
		print("❌ nvim-web-devicons is NOT available")
	end

	-- Check current buffer type
	local buftype = vim.bo.buftype
	print("📄 Current buffer type: " .. buftype)

	-- Check if we're in an oil buffer
	if vim.b.oil then
		print("✅ Currently in an Oil buffer")
	else
		print("ℹ️  Not in an Oil buffer")
	end

	return true
end

-- Helper function to open oil in different ways
function M.open_oil_directory(dir)
	if not dir then
		dir = vim.fn.expand("%:p:h")
	end
	local oil_ok, oil = pcall(require, "oil")
	if oil_ok then
		oil.open(dir)
	else
		vim.notify("Oil.nvim not available", vim.log.levels.WARN)
	end
end

function M.open_oil_float(dir)
	if not dir then
		dir = vim.fn.expand("%:p:h")
	end
	local oil_ok, oil = pcall(require, "oil")
	if oil_ok then
		oil.open_float(dir)
	else
		vim.notify("Oil.nvim not available", vim.log.levels.WARN)
	end
end

function M.open_oil_sidebar(dir)
	if not dir then
		dir = vim.fn.expand("%:p:h")
	end
	local oil_ok, oil = pcall(require, "oil")
	if oil_ok then
		oil.open_float(dir)
	else
		vim.notify("Oil.nvim not available", vim.log.levels.WARN)
	end
end

-- Helper function to toggle oil
function M.toggle_oil()
	local oil_ok, oil = pcall(require, "oil")
	if oil_ok then
		-- Check if we're already in an oil buffer
		if vim.b.oil then
			-- Close the current oil buffer
			vim.cmd("close")
		else
			-- Open oil in the current directory
			oil.open(vim.fn.expand("%:p:h"))
		end
	else
		vim.notify("Oil.nvim not available", vim.log.levels.WARN)
	end
end

-- Helper function to refresh oil
function M.refresh_oil()
	local oil_ok, oil = pcall(require, "oil")
	if oil_ok then
		-- Refresh the current buffer if it's an oil buffer
		if vim.b.oil then
			vim.cmd("edit")
		else
			vim.notify("Not in an Oil buffer", vim.log.levels.INFO)
		end
	else
		vim.notify("Oil.nvim not available", vim.log.levels.WARN)
	end
end

-- Setup oil configuration
function M.setup_oil_config()
	return {
		default_file_explorer = M.oil_config.default_file_explorer,
		columns = M.oil_config.columns,
		buf_options = M.oil_config.buf_options,
		win_options = M.oil_config.win_options,
		delete_to_trash = M.oil_config.delete_to_trash,
		skip_confirm_for_simple_edits = M.oil_config.skip_confirm_for_simple_edits,
		prompt_save_on_select_new_entry = M.oil_config.prompt_save_on_select_new_entry,
		cleanup_delay_ms = M.oil_config.cleanup_delay_ms,
		lsp_file_methods = M.oil_config.lsp_file_methods,
		constrain_cursor = M.oil_config.constrain_cursor,
		watch_for_changes = M.oil_config.watch_for_changes,
		keymaps = M.keymaps,
		use_default_keymaps = true,
		view_options = M.view_options,
		extra_scp_args = {},
		git = M.git_config,
		float = M.float_config,
		preview_win = M.preview_config,
		confirmation = M.confirmation_config,
		progress = M.progress_config,
		ssh = M.ssh_config,
		keymaps_help = M.keymaps_help_config,
	}
end

-- Setup oil keymaps
function M.setup_oil_keymaps()
	local map = vim.keymap.set

	-- Oil navigation
	map("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory in Oil" })
	map("n", "_", "<CMD>Oil<CR>", { desc = "Open current directory in Oil" })

	-- Oil refresh
	map("n", "<leader>or", function()
		M.refresh_oil()
	end, { desc = "Refresh Oil" })
end

return {
	"stevearc/oil.nvim",
	enabled = true,
	opts = {},
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		require("oil").setup(M.setup_oil_config())
		M.setup_oil_keymaps()
	end,
}
