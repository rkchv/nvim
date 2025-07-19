return {
	"VonHeikemen/lsp-zero.nvim",
	enabled = true,
	branch = "v2.x",
	dependencies = {
		{
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
			"neovim/nvim-lspconfig",
			"WhoIsSethDaniel/mason-tool-installer.nvim",
		},
	},

	config = function(_, opts)
		local lsp = require("lsp-zero")
		local mason = require("mason")
		local mason_lspconfig = require("mason-lspconfig")
		local mason_tool_installer = require("mason-tool-installer")

		-- Optimize Mason setup
		mason.setup({
			ui = {
				border = "rounded",
				width = 0.8,
				height = 0.8,
			},
			max_concurrent_installers = 4,
		})

		-- Optimize tool installer with only essential tools
		mason_tool_installer.setup({
			ensure_installed = {
				-- LSP servers
				"lua_ls",
				"gopls",
				"jsonls",
				"yamlls",
				"dockerls",
				"tailwindcss",
				"eslint_d",
				"intelephense",
				"terraformls",
				"buf_ls",
				
				-- Debuggers
				"delve",
				
				-- Formatters
				"prettier",
				"stylua",
				"gofumpt",
				"goimports",
				"golines",
				"beautysh",
				
				-- Linters
				"shellcheck",
				
				-- Tools
				"gomodifytags",
				"gotests",
				"gotestsum",
				"iferr",
				"impl",
				"json-to-struct",
			},
			auto_update = false,
			run_on_start = false,
		})

		-- Optimize LSP config
		mason_lspconfig.setup({
			ensure_installed = {
				"lua_ls",
				"gopls",
				"jsonls",
				"yamlls",
				"dockerls",
				"tailwindcss",
				"eslint_d",
				"intelephense",
				"terraformls",
				"buf_ls",
			},
			automatic_installation = true,
			handlers = {
				lsp.default_setup,
				lua_ls = function()
					local lua_opts = lsp.nvim_lua_ls()
					require("lspconfig").lua_ls.setup(lua_opts)
				end,
				html = function()
					require("lspconfig").html.setup({
						filetypes = { "html", "tmpl" },
					})
				end,
				gopls = function()
					require("lspconfig").gopls.setup({
						settings = {
							gopls = {
								analyses = {
									unusedparams = true,
									shadow = true,
								},
								staticcheck = true,
								gofumpt = true,
								usePlaceholders = true,
							},
						},
					})
				end,
			},
		})

		-- Configure LSP Zero
		lsp.set_sign_icons({
			error = "✘",
			warn = "▲",
			hint = "⚑",
			info = "»",
		})

		-- Performance optimizations for LSP
		lsp.set_preferences({
			suggest_lsp_servers = false,
			setup_servers_on_start = false,
			set_lsp_keymaps = false,
			configure_diagnostics = false,
			manage_nvim_cmp = false,
			call_servers = "local",
			sign_icons = {
				error = "✘",
				warn = "▲",
				hint = "⚑",
				info = "»",
			},
		})
	end,
}
