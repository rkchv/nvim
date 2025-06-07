return {
	{
		"Exafunction/codeium.vim",
		event = "BufEnter",
		enabled = true,
		config = function()
			vim.keymap.set("i", "<C-g>", function()
				return vim.fn["codeium#Accept"]()
			end, { expr = true, silent = true, desc = "Codeium Accept" })

			vim.keymap.set("i", "<C-x>", function()
				return vim.fn["codeium#Clear"]()
			end, { expr = true, silent = true, desc = "Codeium Clear" })

			vim.keymap.set("i", "<C-]>", function()
				return vim.fn
			end, { expr = true, silent = true, desc = "Codeium Cycle Completions Next" })

			vim.g.codeium_filetypes = {
				markdown = false,
			}
		end,
	},

	{
		"github/copilot.vim",
		event = "InsertEnter",
		enabled = false, -- если хочешь наоборот включить codeium, а copilot выключить — поменяй местами enabled
		config = function()
			vim.g.copilot_no_tab_map = true
			vim.api.nvim_set_keymap("i", "<C-g>", 'copilot#Accept("<CR>")', {
				expr = true,
				silent = true,
				desc = "Copilot Accept",
			})

			vim.g.copilot_filetypes = {
				markdown = false,
				gitcommit = false,
			}
		end,
	},
}
