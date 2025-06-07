return {
	"nvim-lualine/lualine.nvim",
	enabled = true,
	lazy = false,
	opts = function(_, opts)
		opts.options = {
			icons_enabled = false,
			theme = "auto",
			disabled_filetypes = {
				statusline = { "alpha", "dashboard", "fzf", "lazy", "mason", "TelescopePrompt" },
			},
			always_divide_middle = true,
			refresh = {
				statusline = 1000,
				tabline = 1000,
				winbar = 1000,
			},
		}

		opts.sections = {
			lualine_a = { "mode" },
			lualine_b = { "branch", "diff", "diagnostics" },
			lualine_c = {
				{
					"filename",
					path = 1,
				},
			},
			lualine_x = {
				{ "progress", separator = " ", padding = { left = 1, right = 0 } },
				{ "location", padding = { left = 0, right = 1 } },
			},
			lualine_y = { "filetype" },
			lualine_z = { "encoding" },
		}

		opts.extensions = { "lazy" }
	end,
}
