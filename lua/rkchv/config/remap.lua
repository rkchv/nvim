-- Ui/Common
vim.keymap.set("n", "<leader>z", ":ZenMode<CR>", { desc = "Turn on/off Zen mode" })
vim.keymap.set("n", "<Esc>", ":noh<CR>", { desc = "Esc highlighting" })
vim.keymap.set("n", "<F2>", "<cmd>wall<cr>", { desc = "Save all files" })
vim.keymap.set("n", "qq", "<cmd>qall!<cr>", { desc = "Quit all" })
vim.keymap.set("n", "<leader>cf", '<cmd>let @+ = expand("%")<CR>', { desc = "Copy File Name" })
vim.keymap.set("n", "<leader>cp", '<cmd>let @+ = expand("%:p")<CR>', { desc = "Copy File Path" })
vim.keymap.set("n", "-", ":Oil<CR>", { desc = "Open parent directory" })

-- Selection
vim.keymap.set("n", "==", "gg<S-v>G", { desc = "Select all buffer" })
vim.keymap.set("n", "Y", "y$", { desc = "Yank from cursor to end of the line" })
vim.keymap.set("n", "vv", "^vg_", { desc = "Select the current line, excluding indentation" })

-- Editing
vim.keymap.set("n", "<leader>d", [["_d]], { desc = "Delete and don't put in in buffer" })
vim.keymap.set("v", "<leader>d", [["_d]], { desc = "Delete and don't put in in buffer" })
vim.keymap.set("v", "<leader>p", [["_dP]], { desc = "Replace selection with buffer" })
vim.keymap.set("n", "dh", "d^", { desc = "Delete to the first non-blank character of the line" })
vim.keymap.set("n", "J", "mzJ`z", { desc = "Join lines" })

-- Editing/gopher
vim.keymap.set("n", "<leader>aj", ":silent! GoTagAdd json<CR>", { desc = "Add json tags" })
vim.keymap.set("n", "<leader>ay", ":silent! GoTagAdd yaml<CR>", { desc = "Add yaml tags" })
vim.keymap.set("n", "<leader>at", ":silent! GoTestAdd<CR>", { desc = "Add test for func" })
vim.keymap.set("n", "<leader>ae", ":silent! GoTestsExp<CR>", { desc = "Add test for exp func" })
vim.keymap.set("n", "<leader>aa", ":silent! GoTestsAll<CR>", { desc = "Add test for all funcs" })
vim.keymap.set("n", "<leader>ai", ":silent! GoImpl<CR>", { desc = "Generate interface implementation" })
vim.keymap.set("n", "<leader>ar", ":silent! GoIfErr<CR>", { desc = "Generate ifferr statement" })
vim.keymap.set("n", "<leader>ad", ":silent! GoCmt<CR>", { desc = "Generate doc" })

vim.keymap.set(
	{ "n", "v" },
	"<leader>s",
	[[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
	{ desc = "Find and replace" }
)

-- Moving
vim.keymap.set("n", "gl", "g_", { desc = "Move to the last non-blank character of the line" })
vim.keymap.set("n", "gh", "^", { desc = "Move to the first non-blank character of the line" })
vim.keymap.set("n", "gj", "/^#<CR>", { desc = "Jump to the next Markdown header" })
vim.keymap.set("n", "gk", "?^#<CR>", { desc = "Jump to the previous Markdown header" })
vim.keymap.set("v", "<", "<gv", { desc = "Move selection left" })
vim.keymap.set("v", ">", ">gv", { desc = "Move selection right" })
vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Move to left window" })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Move to bottom window" })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Move to top window" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Move to right window" })
vim.keymap.set("n", "<C-d>", "12jzz", { desc = "Scroll down 12 lines and center the cursor" })
vim.keymap.set("n", "<C-u>", "12kzz", { desc = "Scroll up 12 lines and center the cursor" })
vim.keymap.set("n", "n", "nzzzv", { desc = "Search forward and center cursor" })
vim.keymap.set("n", "N", "Nzzzv", { desc = "Search backward and center cursor" })
vim.keymap.set("n", "LL", ":e #<CR>", { desc = "Edit the last opened file" })

-- Lsp
vim.keymap.set("n", "<leader>rn", ":lua vim.lsp.buf.rename()<CR>", { desc = "Rename LSP symbol" })
vim.keymap.set("n", "<leader>nd", ":lua vim.lsp.buf.definition()<CR>", { desc = "LSP Go to Definition" })
vim.keymap.set("n", "<leader>gi", ":lua vim.lsp.buf.implementation()<CR>", { desc = "LSP Go to Implementation" })
vim.keymap.set("n", "<leader>gr", ":lua vim.lsp.buf.references()<CR>", { desc = "LSP References" })
vim.keymap.set("n", "<leader>ga", ":lua vim.lsp.buf.code_action()<CR>", { desc = "LSP Code Action" })
vim.keymap.set("n", "<leader>ld", ":lua vim.lsp.buf.declaration()<CR>", { desc = "LSP Declaration" })
vim.keymap.set("n", "<leader>e", ":lua vim.diagnostic.open_float()<CR>", { desc = "Diagnostic Float" })
vim.keymap.set("n", "K", ":lua vim.lsp.buf.hover()<CR>", { desc = "Hover (LSP)" })

vim.keymap.set("n", "<leader>uu", function()
	require("conform").format({ async = true, lsp_fallback = true })
end, { desc = "Format file" })

-- Keys disabling
vim.keymap.set("n", "q", "<nop>")
vim.keymap.set("n", "ZQ", "<nop>")
vim.keymap.set("n", "<F1>", "<nop>")
vim.keymap.set("n", "<F3>", "<nop>")
vim.keymap.set("n", "<C-[", "<nop>")
