-- AI Assistant Configuration Module
local M = {}

-- AI suggestion quality control
M.suggestion_quality = {
	-- Minimum confidence threshold for auto-accepting suggestions
	min_confidence = 0.7,

	-- Maximum suggestion length to auto-accept
	max_auto_accept_length = 50,

	-- File types where AI suggestions are more reliable
	reliable_filetypes = {
		"lua",
		"go",
		"javascript",
		"typescript",
		"c",
	},

	-- File types where AI suggestions should be disabled
	disabled_filetypes = {
		markdown = false,
		gitcommit = false,
		gitrebase = false,
		hgcommit = false,
		svn = false,
		cvs = false,
		["."] = false,
	},
}

-- Helper function to convert disabled filetypes dict to list
function M.get_disabled_filetypes_list()
	local list = {}
	for filetype, _ in pairs(M.suggestion_quality.disabled_filetypes) do
		table.insert(list, filetype)
	end
	return list
end

-- Diagnostic function for Copilot
function M.check_copilot_status()
	print("=== Copilot Status Check ===")

	-- Check if Copilot plugin is loaded
	if vim.fn.exists("*copilot#Accept") == 1 then
		print("✅ Copilot functions are available")
	else
		print("❌ Copilot functions are NOT available")
		print("   Try: :Copilot auth")
		return false
	end

	-- Check authentication
	local auth_status = vim.fn["copilot#GetStatus"]()
	if auth_status == "OK" then
		print("✅ Copilot is authenticated")
	else
		print("❌ Copilot authentication issue: " .. tostring(auth_status))
		print("   Try: :Copilot auth")
		return false
	end

	-- Check if suggestions are enabled
	if vim.g.copilot_enabled then
		print("✅ Copilot suggestions are enabled")
	else
		print("⚠️  Copilot suggestions are disabled")
	end

	-- Check current filetype
	local filetype = vim.bo.filetype
	print("📄 Current filetype: " .. filetype)

	-- Check if filetype is disabled
	if vim.g.copilot_filetypes and vim.g.copilot_filetypes[filetype] == false then
		print("⚠️  Copilot is disabled for this filetype")
	else
		print("✅ Copilot should work for this filetype")
	end

	return true
end

function M.accept_suggestion()
	if vim.fn.exists("*copilot#Accept") == 1 then
		local suggestion = vim.fn["copilot#Accept"]("")
		if suggestion ~= "" then
			vim.api.nvim_feedkeys(suggestion, "n", true)
		else
			vim.notify("No Copilot suggestion to accept", vim.log.levels.INFO)
		end
	else
		vim.notify("Copilot not available", vim.log.levels.WARN)
	end
end

function M.reject_suggestion()
	if vim.fn.exists("*copilot#Dismiss") == 1 then
		vim.fn["copilot#Dismiss"]()
	else
		vim.notify("Copilot not available", vim.log.levels.WARN)
	end
end

function M.next_suggestion()
	if vim.fn.exists("*copilot#Next") == 1 then
		vim.fn["copilot#Next"]()
	else
		vim.notify("Copilot not available", vim.log.levels.WARN)
	end
end

function M.previous_suggestion()
	if vim.fn.exists("*copilot#Previous") == 1 then
		vim.fn["copilot#Previous"]()
	else
		vim.notify("Copilot not available", vim.log.levels.WARN)
	end
end

-- Enhanced AI chat functions
function M.explain_code()
	local mode = vim.fn.mode()
	if mode == "v" or mode == "V" then
		vim.cmd("CopilotChatExplain")
	else
		-- Explain current line
		vim.cmd("normal! V")
		vim.cmd("CopilotChatExplain")
	end
end

function M.review_code()
	local mode = vim.fn.mode()
	if mode == "v" or mode == "V" then
		vim.cmd("CopilotChatReview")
	else
		-- Review current function/block
		vim.cmd("normal! Vaf")
		vim.cmd("CopilotChatReview")
	end
end

function M.optimize_code()
	local mode = vim.fn.mode()
	if mode == "v" or mode == "V" then
		vim.cmd("CopilotChatOptimize")
	else
		-- Optimize current function/block
		vim.cmd("normal! Vaf")
		vim.cmd("CopilotChatOptimize")
	end
end

function M.generate_tests()
	local mode = vim.fn.mode()
	if mode == "v" or mode == "V" then
		vim.cmd("CopilotChatTests")
	else
		-- Generate tests for current function
		vim.cmd("normal! Vaf")
		vim.cmd("CopilotChatTests")
	end
end

function M.generate_docs()
	local mode = vim.fn.mode()
	if mode == "v" or mode == "V" then
		vim.cmd("CopilotChatDocs")
	else
		-- Generate docs for current function
		vim.cmd("normal! Vaf")
		vim.cmd("CopilotChatDocs")
	end
end

-- AI suggestion quality assessment
function M.assess_suggestion_quality()
	local filetype = vim.bo.filetype
	local line_count = vim.api.nvim_buf_line_count(0)

	-- Adjust confidence based on context
	local confidence = 0.5

	-- Higher confidence for reliable filetypes
	if vim.tbl_contains(M.suggestion_quality.reliable_filetypes, filetype) then
		confidence = confidence + 0.3
	end

	-- Lower confidence for large files
	if line_count > 1000 then
		confidence = confidence - 0.1
	end

	return confidence
end

-- Setup AI keymaps with better control
function M.setup_ai_autocomplete_keymaps()
	local map = vim.keymap.set

	-- Alternative accept keybinding
	map("i", "<C-l>", function()
		M.accept_suggestion()
	end, { desc = "Accept AI Suggestion (Alternative)" })

	map("i", "<C-x>", function()
		M.reject_suggestion()
	end, { desc = "Reject AI Suggestion" })

	map("i", "<C-n>", function()
		M.next_suggestion()
	end, { desc = "Next AI Suggestion" })

	map("i", "<C-p>", function()
		M.previous_suggestion()
	end, { desc = "Previous AI Suggestion" })
end

function M.setup_ai_chat_keymaps()
	local map = vim.keymap.set

	-- Enhanced AI chat keymaps (using functions)
	map("v", "<leader>ze", function()
		M.explain_code()
	end, { desc = "Explain Code" })

	map("v", "<leader>zr", function()
		M.review_code()
	end, { desc = "Review Code" })

	map("v", "<leader>zo", function()
		M.optimize_code()
	end, { desc = "Optimize Code" })

	map("n", "<leader>zt", function()
		M.generate_tests()
	end, { desc = "Generate Tests" })

	map("n", "<leader>zd", function()
		M.generate_docs()
	end, { desc = "Generate Documentation" })

	-- Diagnostic command
	vim.api.nvim_create_user_command("CopilotCheck", function()
		M.check_copilot_status()
	end, {})
end

-- Configure Copilot settings
function M.setup_copilot()
	-- Disable default tab mapping to avoid conflicts
	vim.g.copilot_no_tab_map = true
	vim.g.copilot_assume_mapped = true

	-- Configure filetypes where Copilot should be active
	vim.g.copilot_filetypes = M.suggestion_quality.disabled_filetypes
end

-- Configure CopilotChat settings
function M.setup_copilot_chat()
	-- CopilotChat configuration
	local copilot_chat = require("CopilotChat")

	-- Set up CopilotChat with proper options
	copilot_chat.setup({
		-- System prompt for better responses
		system_prompt = "You are a helpful programming assistant. Provide clear, concise, and accurate code suggestions. Always explain your reasoning and consider best practices.",
		-- Show help text
		show_help = "yes",
		-- Debug mode (set to false in production)
		debug = false,
		-- Model configuration
		model = "gpt-4",
		-- Temperature for responses
		temperature = 0.1,
		-- Maximum tokens
		max_tokens = 2000,
		-- Auto-close on selection
		auto_close = true,
		-- Compact mode
		compact = true,
	})

	-- Custom function to center CopilotChat window
	local function center_copilot_chat()
		local win_id = vim.api.nvim_get_current_win()
		local win_config = vim.api.nvim_win_get_config(win_id)

		-- Get screen dimensions
		local screen_width = vim.o.columns
		local screen_height = vim.o.lines

		-- Calculate centered position
		local width = math.floor(screen_width * 0.8)
		local height = math.floor(screen_height * 0.8)
		local row = math.floor((screen_height - height) / 2)
		local col = math.floor((screen_width - width) / 2)

		-- Update window position
		vim.api.nvim_win_set_config(win_id, {
			relative = "editor",
			width = width,
			height = height,
			row = row,
			col = col,
			style = "minimal",
			border = "rounded",
		})
	end

	-- Create autocmd to center CopilotChat window when it opens
	vim.api.nvim_create_autocmd("BufWinEnter", {
		pattern = "*copilot*",
		callback = function()
			vim.defer_fn(center_copilot_chat, 100)
		end,
	})
end

-- Set up autocmds for better AI integration
function M.setup_autocmds()
	-- Enable enhanced AI features for reliable filetypes
	vim.api.nvim_create_autocmd("FileType", {
		pattern = M.suggestion_quality.reliable_filetypes,
		callback = function()
			-- Enable enhanced AI features for reliable filetypes
			vim.bo.commentstring = "// %s"
		end,
	})

	-- Disable AI for certain filetypes
	vim.api.nvim_create_autocmd("FileType", {
		pattern = M.get_disabled_filetypes_list(),
		callback = function()
			-- Disable Copilot for these filetypes
			vim.b.copilot_enabled = false
		end,
	})
end

return {
	{
		"github/copilot.vim",
		event = "InsertEnter",
		config = function()
			M.setup_copilot()
			M.setup_ai_autocomplete_keymaps()
			M.setup_autocmds()
		end,
	},

	{
		"CopilotC-Nvim/CopilotChat.nvim",
		dependencies = {
			{ "github/copilot.vim" },
			{ "nvim-lua/plenary.nvim" },
		},
		enabled = true,
		build = "make tiktoken",
		config = function()
			M.setup_copilot_chat()
			M.setup_ai_chat_keymaps()
		end,
	},

	{
		"Exafunction/codeium.vim",
		event = "BufEnter",
		enabled = false,
	},
}
