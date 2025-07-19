-- Autocomplete Configuration Module
local M = {}

-- Autocomplete quality control
M.completion_quality = {
	-- File types where autocomplete is more reliable
	reliable_filetypes = {
		"lua",
		"go",
		"javascript",
		"typescript",
		"c",
	},

	-- File types where autocomplete should be disabled
	disabled_filetypes = {
		markdown = false,
		gitcommit = false,
		gitrebase = false,
		hgcommit = false,
		svn = false,
		cvs = false,
		["."] = false,
	},

	-- Source priorities for different completion types
	source_priorities = {
		path = 250,
		buffer = 500,
		luasnip = 825,
		nvim_lsp = 900,
	},

	-- Maximum item counts per source
	max_item_counts = {
		path = 20,
		buffer = 10,
		luasnip = 10,
		nvim_lsp = 10,
	},

	-- Keyword lengths for triggering completion
	keyword_lengths = {
		path = 3,
		buffer = 3,
		luasnip = 1,
		nvim_lsp = 1,
	},
}

-- Helper function to convert disabled filetypes dict to list
function M.get_disabled_filetypes_list()
	local list = {}
	for filetype, _ in pairs(M.completion_quality.disabled_filetypes) do
		table.insert(list, filetype)
	end
	return list
end

-- Helper function to check if words exist before cursor
function M.has_words_before()
	local line, col = (unpack or table.unpack)(vim.api.nvim_win_get_cursor(0))
	return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

-- Helper function to check backspace behavior
function M.check_backspace()
	local col = vim.fn.col(".") - 1
	return col == 0 or vim.fn.getline("."):sub(col, col):match("%s")
end

-- Diagnostic function for autocomplete
function M.check_autocomplete_status()
	print("=== Autocomplete Status Check ===")

	-- Check if nvim-cmp is loaded
	local cmp_ok, cmp = pcall(require, "cmp")
	if cmp_ok then
		print("✅ nvim-cmp is available")
	else
		print("❌ nvim-cmp is NOT available")
		return false
	end

	-- Check if LuaSnip is loaded
	local luasnip_ok, luasnip = pcall(require, "luasnip")
	if luasnip_ok then
		print("✅ LuaSnip is available")
	else
		print("❌ LuaSnip is NOT available")
	end

	-- Check current filetype
	local filetype = vim.bo.filetype
	print("📄 Current filetype: " .. filetype)

	-- Check if filetype is disabled
	if vim.tbl_contains(M.get_disabled_filetypes_list(), filetype) then
		print("⚠️  Autocomplete is disabled for this filetype")
	else
		print("✅ Autocomplete should work for this filetype")
	end

	-- Check LSP status
	local clients = vim.lsp.get_active_clients()
	if #clients > 0 then
		print("✅ LSP clients are active: " .. #clients)
		for _, client in ipairs(clients) do
			print("   - " .. client.name)
		end
	else
		print("⚠️  No LSP clients are active")
	end

	return true
end

-- Setup autocomplete keymaps with better control
function M.setup_autocomplete_keymaps(cmp, luasnip)
	local mapping = {
		["<C-j>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
		["<C-k>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
		["<C-c>"] = cmp.mapping({ i = cmp.mapping.abort(), c = cmp.mapping.close() }),
		["<CR>"] = cmp.mapping.confirm({ select = true }),

		["<Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_next_item()
			elseif luasnip.expand_or_jumpable() then
				luasnip.expand_or_jump()
			elseif M.check_backspace() then
				fallback()
			elseif M.has_words_before() then
				cmp.complete()
			else
				fallback()
			end
		end, { "i", "s" }),

		["<S-Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_prev_item()
			elseif luasnip.jumpable(-1) then
				luasnip.jump(-1)
			else
				fallback()
			end
		end, { "i", "s" }),
	}

	return mapping
end

-- Setup autocomplete sources with quality control
function M.setup_autocomplete_sources()
	local sources = {
		{
			name = "path",
			keyword_length = M.completion_quality.keyword_lengths.path,
			max_item_count = M.completion_quality.max_item_counts.path,
			priority = M.completion_quality.source_priorities.path,
		},
		{
			name = "buffer",
			keyword_length = M.completion_quality.keyword_lengths.buffer,
			max_item_count = M.completion_quality.max_item_counts.buffer,
			priority = M.completion_quality.source_priorities.buffer,
		},
		{
			name = "luasnip",
			keyword_length = M.completion_quality.keyword_lengths.luasnip,
			max_item_count = M.completion_quality.max_item_counts.luasnip,
			priority = M.completion_quality.source_priorities.luasnip,
		},
		{
			name = "nvim_lsp",
			keyword_length = M.completion_quality.keyword_lengths.nvim_lsp,
			max_item_count = M.completion_quality.max_item_counts.nvim_lsp,
			priority = M.completion_quality.source_priorities.nvim_lsp,
		},
	}

	return sources
end

-- Setup autocomplete formatting
function M.setup_autocomplete_formatting()
	local source_mapping = {
		nvim_lsp = "[LSP]",
		luasnip = "[Snippet]",
		buffer = "[Buffer]",
		path = "[Path]",
	}

	local formatting = {
		format = function(entry, vim_item)
			vim_item.menu = source_mapping[entry.source.name]
			return vim_item
		end,
	}

	return formatting
end

-- Setup autocomplete window configuration
function M.setup_autocomplete_window()
	local window = {
		completion = { scrollbar = false },
		documentation = { scrollbar = false },
	}

	return window
end

-- Setup autocomplete snippet configuration
function M.setup_autocomplete_snippet(luasnip)
	local snippet = {
		expand = function(args)
			luasnip.lsp_expand(args.body)
		end,
	}

	return snippet
end

-- Setup cmdline autocomplete
function M.setup_cmdline_autocomplete(cmp)
	-- Search completion
	cmp.setup.cmdline({ "/", "?" }, {
		mapping = cmp.mapping.preset.cmdline(),
		sources = { { name = "buffer" } },
	})

	-- Command line completion
	cmp.setup.cmdline(":", {
		mapping = cmp.mapping.preset.cmdline(),
		sources = cmp.config.sources({
			{ name = "path" },
		}, {
			{ name = "cmdline", option = { ignore_cmds = { "Man", "!'" } } },
		}),
	})
end

-- Main setup function
function M.setup_autocomplete()
	local cmp = require("cmp")
	local luasnip = require("luasnip")

	local confirm_opts = {
		behavior = cmp.ConfirmBehavior.Replace,
		select = true,
	}

	local opts = {
		confirm_opts = confirm_opts,
		formatting = M.setup_autocomplete_formatting(),
		mapping = M.setup_autocomplete_keymaps(cmp, luasnip),
		snippet = M.setup_autocomplete_snippet(luasnip),
		sources = M.setup_autocomplete_sources(),
		window = M.setup_autocomplete_window(),
	}

	-- Set group_index for all sources
	for _, source in ipairs(opts.sources) do
		source.group_index = source.group_index or 1
	end

	-- Setup main autocomplete
	cmp.setup(opts)

	-- Setup cmdline autocomplete
	M.setup_cmdline_autocomplete(cmp)

	-- Load friendly snippets
	require("luasnip.loaders.from_vscode").lazy_load()
end

-- Create diagnostic command
vim.api.nvim_create_user_command("AutocompleteCheck", function()
	M.check_autocomplete_status()
end, {})

return {
	"hrsh7th/nvim-cmp",
	lazy = false,
	enabled = true,
	dependencies = {
		"L3MON4D3/LuaSnip",
		"hrsh7th/cmp-nvim-lsp",
		"saadparwaiz1/cmp_luasnip",
		"hrsh7th/cmp-buffer",
		"hrsh7th/cmp-path",
		"hrsh7th/cmp-cmdline",
		"rafamadriz/friendly-snippets",
	},

	config = function()
		M.setup_autocomplete()
	end,
}
