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

		mason.setup({})

		mason_tool_installer.setup({
			ensure_installed = {
				"terraformls",
				"eslint_d",
				"intelephense",
				-- "html",
				"tailwindcss",
				"yamlls",
				"lua_ls",
				"jsonls",
				"dockerls",
				-- "bashls",
				"gopls",
				"buf_ls",
				"delve",
				-- "htmlbeautifier",
				"beautysh",
				"shellcheck",
				"gofumpt",
				"golines",
				"goimports",
				"gomodifytags",
				"gotests",
				"gotestsum",
				"iferr",
				"impl",
				"json-to-struct",
				"prettier",
				"stylua",
				"prettierd",
				"yamlfix",
				"ts_ls",
			},
		})

		mason_lspconfig.setup({
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
			},
		})
	end,
}
