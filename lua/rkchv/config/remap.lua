-- Performance: Use local variables for better performance
local map = vim.keymap.set
local opts = { noremap = true, silent = true }

-- UI/Common mappings
map("n", "<leader>z", ":ZenMode<CR>", { desc = "Turn on/off Zen mode" })
map("n", "<Esc>", ":noh<CR>", { desc = "Esc highlighting" })
map("n", "<F2>", "<cmd>wall<cr>", { desc = "Save all files" })
map("n", "qq", "<cmd>qall!<cr>", { desc = "Quit all" })
map("n", "<leader>cf", '<cmd>let @+ = expand("%")<CR>', { desc = "Copy File Name" })
map("n", "<leader>cp", '<cmd>let @+ = expand("%:p")<CR>', { desc = "Copy File Path" })
map("n", "-", ":Oil<CR>", { desc = "Open parent directory" })

-- Selection mappings
map("n", "==", "gg<S-v>G", { desc = "Select all buffer" })
map("n", "Y", "y$", { desc = "Yank from cursor to end of the line" })
map("n", "vv", "^vg_", { desc = "Select the current line, excluding indentation" })

-- Custom yank function that moves to end of selection
local function yank_to_end()
	-- Get the current cursor position before yanking
	local cursor_pos = vim.api.nvim_win_get_cursor(0)

	-- Get the visual selection marks before yanking
	local start_pos = vim.api.nvim_buf_get_mark(0, "<")
	local end_pos = vim.api.nvim_buf_get_mark(0, ">")

	-- Yank the selection
	vim.cmd("normal! y")

	-- Move cursor to end of selection using a safer approach
	if start_pos and end_pos then
		-- Use g` to move to the end mark, which is more reliable
		vim.cmd("normal! g`>")
	end
end

-- Override y in visual mode to move to end after yanking
map("v", "y", yank_to_end, { desc = "Yank and move to end of selection" })

-- Editing mappings
map({"n", "v"}, "<leader>d", [["_d]], { desc = "Delete and don't put in buffer" })
map("v", "<leader>p", [["_dP]], { desc = "Replace selection with buffer" })
map("n", "dh", "d^", { desc = "Delete to the first non-blank character of the line" })
map("n", "J", "mzJ`z", { desc = "Join lines" })

-- Simple find and replace 
map({ "n", "v" }, "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], { desc = "Find and replace" })

-- Navigation mappings
map("n", "gl", "g_", { desc = "Move to the last non-blank character of the line" })
map("n", "gh", "^", { desc = "Move to the first non-blank character of the line" })

-- Window navigation
map("n", "<C-h>", "<C-w>h", { desc = "Move to left window" })
map("n", "<C-j>", "<C-w>j", { desc = "Move to bottom window" })
map("n", "<C-k>", "<C-w>k", { desc = "Move to top window" })
map("n", "<C-l>", "<C-w>l", { desc = "Move to right window" })

-- Scrolling 
map("n", "<C-d>", "12jzz", { desc = "Scroll down 12 lines and center the cursor" })
map("n", "<C-u>", "12kzz", { desc = "Scroll up 12 lines and center the cursor" })

-- Search improvements
map("n", "n", "nzzzv", { desc = "Search forward and center cursor" })
map("n", "N", "Nzzzv", { desc = "Search backward and center cursor" })

-- File management
map("n", "LL", ":e #<CR>", { desc = "Edit the last opened file" })

-- LSP mappings with performance optimization
local function lsp_rename()
	vim.lsp.buf.rename()
end

local function lsp_definition()
	vim.lsp.buf.definition()
end

local function lsp_implementation()
	vim.lsp.buf.implementation()
end

local function lsp_references()
	vim.lsp.buf.references()
end

local function lsp_code_action()
	vim.lsp.buf.code_action()
end

local function lsp_declaration()
	vim.lsp.buf.declaration()
end

local function diagnostic_float()
	vim.diagnostic.open_float()
end

local function lsp_hover()
	vim.lsp.buf.hover()
end

map("n", "<leader>rn", lsp_rename, { desc = "Rename LSP symbol" })
map("n", "<leader>nd", lsp_definition, { desc = "LSP Go to Definition" })
map("n", "<leader>gi", lsp_implementation, { desc = "LSP Go to Implementation" })
map("n", "<leader>gr", lsp_references, { desc = "LSP References" })
map("n", "<leader>ga", lsp_code_action, { desc = "LSP Code Action" })
map("n", "<leader>ld", lsp_declaration, { desc = "LSP Declaration" })
map("n", "<leader>e", diagnostic_float, { desc = "Diagnostic Float" })
map("n", "K", lsp_hover, { desc = "Hover (LSP)" })

-- Formatting with performance optimization
map("n", "<leader>uu", function()
	require("conform").format({ async = true, lsp_fallback = true })
end, { desc = "Format file" })

-- Disable unused keys for better performance
map("n", "q", "<nop>")
map("n", "ZQ", "<nop>")
map("n", "<F1>", "<nop>")
map("n", "<F3>", "<nop>")
map("n", "<C-[", "<nop>")
