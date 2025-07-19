require("lazy").setup({
	spec = {
		{ import = "rkchv.plugins" },
	},
	
	-- Performance optimizations
	performance = {
		rtp = {
			disabled_plugins = {
				"gzip",
				"matchit",
				"matchparen",
				"netrwPlugin",
				"tarPlugin",
				"tohtml",
				"tutor",
				"zipPlugin",
			},
		},
	},
	
	-- UI settings
	ui = {
		border = "rounded",
		icons = {
			cmd = "⌘",
			config = "⚙",
			event = "📅",
			ft = "📂",
			init = "⚡",
			import = "📥",
			keys = "🗝",
			lazy = "💤 ",
			loaded = "●",
			not_loaded = "○",
			plugin = "🔌",
			runtime = "💻",
			source = "📄",
			start = "🚀",
			task = "📋",
			list = {
				"●",
				"➜",
				"‒",
				"▪",
			},
		},
	},
	
	-- Git settings
	git = {
		timeout = 60000,
	},
	
	-- Install settings
	install = {
		colorscheme = { "kanagawa" },
	},
	
	-- Checker settings
	checker = {
		enabled = true,
		notify = false,
	},
	
	-- Change detection
	change_detection = {
		notify = false,
	},
})
