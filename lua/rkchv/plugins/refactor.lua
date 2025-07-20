return {
	{
		"stevearc/conform.nvim",
		lazy = false,
		config = function()
			require("conform").setup({
				formatters_by_ft = {
					-- Web technologies
					html = { "prettierd", "prettier" },
					css = { "prettierd", "prettier" },
					scss = { "prettierd", "prettier" },
					javascript = { "prettierd", "prettier", "eslint_d" },
					typescript = { "prettierd", "prettier", "eslint_d" },
					javascriptreact = { "prettierd", "prettier", "eslint_d" },
					typescriptreact = { "prettierd", "prettier", "eslint_d" },
					json = { "prettierd", "prettier" },
					jsonc = { "prettierd", "prettier" },
					
					-- Scripting languages
					lua = { "stylua" },
					python = { "black", "isort" },
					sh = { "beautysh", "shellcheck" },
					bash = { "beautysh", "shellcheck" },
					zsh = { "beautysh" },
					
					-- Configuration files
					yml = { "yamlfix" },
					yaml = { "yamlfix" },
					toml = { "taplo" },
					
					-- Other languages
					go = { "gofumpt" },
					rust = { "rustfmt" },
					c = { "clang_format" },
					cpp = { "clang_format" },
					java = { "google_java_format" },
					proto = { "buf" },
					sql = { "sqlformat" },
					markdown = { "prettierd", "prettier", "markdownlint" },
					md = { "prettierd", "prettier", "markdownlint" },
				},
				format_on_save = {
					timeout_ms = 500,
					lsp_fallback = true,
				},
				format_after_save = {
					timeout_ms = 500,
				},
				notify_on_error = true,
				format_on_save_ignore = {
					"javascript",
					"typescript",
					"javascriptreact",
					"typescriptreact",
				},
				-- Custom formatters
				formatters = {
					-- Add custom formatters if needed
					shfmt = {
						prepend_args = { "-i", "2", "-ci" },
					},
					prettierd = {
						prepend_args = { "--config-precedence", "prefer-file" },
					},
				},
			})

		end,
	},

	-- Enhanced find and replace
	{
		"MagicDuck/grug-far.nvim",
		config = function()
			require("grug-far").setup({
				-- Customize the UI
				ui = {
					width = 0.8,
					height = 0.8,
					border = "rounded",
				},
				-- Search options
				search = {
					-- Default search options
					case_sensitive = false,
					word_boundary = false,
					regex = false,
				},
				-- Replace options
				replace = {
					-- Preview changes before applying
					preview = true,
					-- Confirm each replacement
					confirm = true,
				},
			})

			-- Keymaps for find and replace
			vim.keymap.set("n", "<leader>fr", function()
				require("grug-far").open()
			end, { desc = "Find and replace" })
			
			vim.keymap.set("n", "<leader>fx", function()
				require("grug-far").open({ regex = true })
			end, { desc = "Find and replace (regex)" })
									
		end,
	},

}
