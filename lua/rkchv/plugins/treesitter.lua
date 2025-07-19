-- Tree-sitter Configuration Module
local M = {}

-- Tree-sitter performance settings
M.performance = {
	-- Maximum file size for highlighting (100KB)
	max_filesize = 100 * 1024,
	
	-- Languages where Tree-sitter is most beneficial
	priority_languages = {
		"go",
		"typescript",
		"javascript",
		"lua",
		"c",
		"rust",
	},
	
	-- File types where Tree-sitter should be disabled
	disabled_filetypes = {
		"gitcommit",
		"gitrebase",
		"hgcommit",
		"svn",
		"cvs",
		".",
	},
}

-- Tree-sitter language configuration
M.languages = {
	-- Core development languages
	core = {
		"go",           -- Go programming
		"gomod",        -- Go modules
		"lua",          -- Lua scripting
		"c",            -- C programming
	},
	
	-- Web development
	web = {
		"typescript",   -- TypeScript
		"javascript",   -- JavaScript
		"tsx",          -- TypeScript React
		"html",         -- HTML markup
		"css",          -- CSS styling
		"json",         -- JSON data
	},
	
	-- Infrastructure and config
	infra = {
		"terraform",    -- Infrastructure as Code
		"dockerfile",   -- Docker configurations
		"yaml",         -- YAML files
		"toml",         -- Configuration files
		"proto",        -- Protocol Buffers
	},
	
	-- Documentation and data
	docs = {
		"markdown",     -- Documentation
		"sql",          -- Database queries
		"bash",         -- Shell scripts
	},
}

-- Helper function to get all languages
function M.get_all_languages()
	local all_langs = {}
	for category, langs in pairs(M.languages) do
		for _, lang in ipairs(langs) do
			table.insert(all_langs, lang)
		end
	end
	return all_langs
end

-- Helper function to check if file should disable highlighting
function M.should_disable_highlighting(lang, buf)
	-- Check file size
	local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
	if ok and stats and stats.size > M.performance.max_filesize then
		return true
	end
	
	-- Check filetype
	local filetype = vim.bo.filetype
	if vim.tbl_contains(M.performance.disabled_filetypes, filetype) then
		return true
	end
	
	return false
end

-- Tree-sitter keymaps configuration
M.keymaps = {
	-- INCREMENTAL SELECTION: Smart code block selection
	incremental_selection = {
		init_selection = "gnn",     -- Start selecting current node
		node_incremental = "grn",   -- Expand: word → expression → statement → function
		scope_incremental = "grc",  -- Expand: current scope → outer scope
		node_decremental = "grm",   -- Shrink: function → statement → expression → word
	},
	
	-- TEXT OBJECTS: Intelligent code block selection
	textobjects = {
		-- Functions
		["af"] = "@function.outer",  -- Select entire function (including signature)
		["if"] = "@function.inner",  -- Select function body only
		
		-- Classes
		["aC"] = "@class.outer",    -- Select entire class
		["iC"] = "@class.inner",    -- Select class body only
		
		-- Control flow
		["ac"] = "@conditional.outer", -- Select if/else/switch block
		["ic"] = "@conditional.inner", -- Select condition body only
		
		-- Code blocks
		["ae"] = "@block.outer",    -- Select code block (curly braces)
		["ie"] = "@block.inner",    -- Select block content only
		
		-- Loops
		["al"] = "@loop.outer",     -- Select for/while loop
		["il"] = "@loop.inner",     -- Select loop body only
		
		-- Statements
		["as"] = "@statement.outer", -- Select statement
		["is"] = "@statement.inner", -- Select statement content
		
		-- Comments
		["ad"] = "@comment.outer",  -- Select comment block
		
		-- Function calls
		["am"] = "@call.outer",     -- Select function call
		["im"] = "@call.inner",     -- Select function call arguments
	},
	
	-- MOVEMENT: Jump between code structures
	movement = {
		-- Jump to next/previous function definitions
		goto_next_start = {
			["[["] = "@function.outer", -- Jump to next function start
		},
		goto_next_end = {
			["]]"] = "@function.outer", -- Jump to next function end
		},
		-- Uncomment for reverse navigation:
		-- goto_previous_start = {
		--   ["]["] = "@function.outer", -- Jump to previous function start
		-- },
		-- goto_previous_end = {
		--   ["[]"] = "@function.outer", -- Jump to previous function end
		-- }
	},
	
	-- SWAP: Swap adjacent code elements
	swap = {
		swap_next = {
			["<leader>a"] = "@parameter.inner", -- Swap with next parameter
		},
		swap_previous = {
			["<leader>A"] = "@parameter.inner", -- Swap with previous parameter
		},
	},
}

-- LSP Integration configuration
M.lsp_integration = {
	enable = true,
	peek_definition_code = {
		["DF"] = "@function.outer", -- Peek function definition
	},
}

-- Diagnostic function for Tree-sitter
function M.check_treesitter_status()
	print("=== Tree-sitter Status Check ===")

	-- Check if Tree-sitter is loaded
	local ts_ok, ts = pcall(require, "nvim-treesitter")
	if ts_ok then
		print("✅ Tree-sitter is available")
	else
		print("❌ Tree-sitter is NOT available")
		return false
	end

	-- Check if textobjects is loaded
	local textobjects_ok, textobjects = pcall(require, "nvim-treesitter.textobjects")
	if textobjects_ok then
		print("✅ Tree-sitter textobjects is available")
	else
		print("❌ Tree-sitter textobjects is NOT available")
	end

	-- Check current filetype
	local filetype = vim.bo.filetype
	print("📄 Current filetype: " .. filetype)

	-- Check if highlighting is enabled
	local highlight_enabled = vim.treesitter.highlight.get_hl(0, {0, 0}, {0, 1})
	if highlight_enabled then
		print("✅ Tree-sitter highlighting is active")
	else
		print("⚠️  Tree-sitter highlighting may be disabled")
	end

	-- Check installed parsers
	local parsers = require("nvim-treesitter.parsers").get_parser_configs()
	local installed_count = 0
	for parser, _ in pairs(parsers) do
		installed_count = installed_count + 1
	end
	print("📦 Installed parsers: " .. installed_count)

	return true
end

-- Setup Tree-sitter keymaps with better control
function M.setup_treesitter_keymaps()
	local map = vim.keymap.set
	
	-- Incremental selection keymaps
	map("n", "gnn", "<cmd>lua require('nvim-treesitter.incremental_selection').init_selection()<CR>", { desc = "Start Tree-sitter selection" })
	map("n", "grn", "<cmd>lua require('nvim-treesitter.incremental_selection').node_incremental()<CR>", { desc = "Expand Tree-sitter selection" })
	map("n", "grc", "<cmd>lua require('nvim-treesitter.incremental_selection').scope_incremental()<CR>", { desc = "Expand Tree-sitter scope" })
	map("n", "grm", "<cmd>lua require('nvim-treesitter.incremental_selection').node_decremental()<CR>", { desc = "Shrink Tree-sitter selection" })
	
	-- Movement keymaps
	map("n", "[[", "<cmd>lua require('nvim-treesitter.textobjects.move').goto_next_start('@function.outer')<CR>", { desc = "Jump to next function start" })
	map("n", "]]", "<cmd>lua require('nvim-treesitter.textobjects.move').goto_next_end('@function.outer')<CR>", { desc = "Jump to next function end" })
	
	-- Swap keymaps
	map("n", "<leader>a", "<cmd>lua require('nvim-treesitter.textobjects.swap').swap_next('@parameter.inner')<CR>", { desc = "Swap with next parameter" })
	map("n", "<leader>A", "<cmd>lua require('nvim-treesitter.textobjects.swap').swap_previous('@parameter.inner')<CR>", { desc = "Swap with previous parameter" })
	
	-- Diagnostic command
	vim.api.nvim_create_user_command("TSStatus", function()
		M.check_treesitter_status()
	end, {})
end

-- Main Tree-sitter configuration
function M.setup()
	require("nvim-treesitter.configs").setup({
		-- Languages to ensure are installed
		ensure_installed = M.get_all_languages(),

		-- Performance settings
		auto_install = false,
		highlight = { 
			enable = true,
			-- Performance: disable for large files
			disable = M.should_disable_highlighting,
		},
		indent = { enable = true },

		-- INCREMENTAL SELECTION: Smart code block selection
		incremental_selection = {
			enable = true,
			keymaps = M.keymaps.incremental_selection,
		},

		-- TEXT OBJECTS: Intelligent code block selection and manipulation
		textobjects = {
			enable = true,
			
			-- LSP Integration: Use Tree-sitter with LSP for better accuracy
			lsp_interop = M.lsp_integration,

			-- SELECTION KEYMAPS: Quick selection of code blocks
			keymaps = M.keymaps.textobjects,

			-- MOVEMENT: Jump between code structures
			move = {
				enable = true,
				set_jumps = true, -- Add jumps to jumplist for Ctrl-o/Ctrl-i
				goto_next_start = M.keymaps.movement.goto_next_start,
				goto_next_end = M.keymaps.movement.goto_next_end,
			},

			-- SELECT: Alternative selection method
			select = {
				enable = true,
				keymaps = {
					["af"] = "@function.outer",
					["if"] = "@function.inner",
					["ac"] = "@class.outer",
					["ic"] = "@class.inner",
				},
			},

			-- SWAP: Swap adjacent code elements
			swap = {
				enable = true,
				swap_next = M.keymaps.swap.swap_next,
				swap_previous = M.keymaps.swap.swap_previous,
			},
		},
	})
end

return {
	"nvim-treesitter/nvim-treesitter",
	enabled = true,
	build = ":TSUpdate",
	dependencies = {
		"nvim-treesitter/nvim-treesitter-textobjects",
	},

	config = function()
		M.setup()
		M.setup_treesitter_keymaps()
	end,
}
