local M = {}

-- ===== GIT PLUGIN KEYMAPS SUMMARY =====
-- 
-- NEOGIT OPERATIONS:
--   <leader>go    - Open Neogit interface
--   <leader>gcm   - Neogit commit (conflict-free version of gc)
--   <leader>gp    - Neogit pull
--   <leader>gps   - Neogit push (conflict-free version of gs)
--   <leader>gl    - Neogit log
--   <leader>gbr   - Git branches (conflict-free version of gb)
--   <leader>gB    - Git blame
--
-- TELESCOPE GIT (from telescope.lua - no conflicts):
--   <leader>gc    - Git commits (telescope)
--   <leader>gb    - Git bcommits (telescope)
--   <leader>gs    - Git status (telescope)
--   <leader>gt    - Git status (our addition)
--   <leader>gF    - Git files
--   <leader>gT    - Git tags
--
-- DIFFVIEW OPERATIONS:
--   <leader>gd    - Diffview open
--   <leader>gD    - Diffview close
--   <leader>gh    - Diffview toggle files
--
-- GITSIGNS (buffer-specific):
--   <leader>hs    - Stage hunk
--   <leader>hr    - Reset hunk
--   <leader>hS    - Stage buffer
--   <leader>hu    - Undo stage hunk
--   <leader>hR    - Reset buffer
--   <leader>hp    - Preview hunk
--   <leader>hb    - Blame line
--   <leader>tb    - Toggle line blame
--   <leader>hd    - Diff this
--   <leader>hD    - Diff this ~
--   <leader>tgd   - Toggle deleted (conflict-free version of td)
--
-- GIT UTILITIES:
--   <leader>gu    - Copy git URL
--   <leader>gR    - Open git root
--   <leader>gI    - Edit .gitignore
--
-- NAVIGATION:
--   [c            - Previous hunk
--   ]c            - Next hunk
--   ih            - Git hunk text object

-- Git configuration
local config = {
	neogit = {
		disable_signs = false,
		disable_hint = false,
		disable_context_highlighting = false,
		disable_commit_confirmation = false,
		auto_refresh = true,
		sort_branches = "-committerdate",
		kind = "tab",
		commit_popup = {
			kind = "split",
		},
		popup = {
			kind = "split",
		},
		signs = {
			section = { " ", " " },
			item = { " ", " " },
			hunk = { "", "" },
		},
		integrations = {
			diffview = true,
			telescope = true,
		},
		sections = {
			untracked = {
				folded = false,
				hidden = false,
			},
			unstaged = {
				folded = false,
				hidden = false,
			},
			staged = {
				folded = false,
				hidden = false,
			},
			stashes = {
				folded = true,
				hidden = false,
			},
			unpulled = {
				folded = true,
				hidden = false,
			},
			unmerged = {
				folded = false,
				hidden = false,
			},
			recent = {
				folded = true,
				hidden = false,
			},
		},
		mappings = {
			commit_popup = {
				["q"] = "Close",
			},
			popup = {
				["?"] = "HelpPopup",
			},
		},
	},
	gitsigns = {
		signs = {
			add = { text = "│" },
			change = { text = "│" },
			delete = { text = "_" },
			topdelete = { text = "‾" },
			changedelete = { text = "~" },
			untracked = { text = "┆" },
		},
		signcolumn = true,
		numhl = false,
		linehl = false,
		word_diff = false,
		watch_gitdir = {
			interval = 1000,
			follow_files = true,
		},
		attach_to_untracked = true,
		current_line_blame = true,
		current_line_blame_opts = {
			virt_text = true,
			virt_text_pos = "eol",
			delay = 1000,
			ignore_whitespace = false,
		},
		current_line_blame_formatter = "<author>, <author_time:%Y-%m-%d> - <summary>",
		sign_priority = 6,
		update_debounce = 100,
		status_formatter = nil,
		max_file_length = 40000,
		preview_config = {
			border = "single",
			style = "minimal",
			relative = "cursor",
			row = 0,
			col = 1,
		},
		-- yadm configuration removed as it's deprecated
		on_attach = function(bufnr)
			local gs = package.loaded.gitsigns

			local function map(mode, l, r, opts)
				opts = opts or {}
				opts.buffer = bufnr
				vim.keymap.set(mode, l, r, opts)
			end

			-- Navigation
			map("n", "]c", function()
				if vim.wo.diff then
					return "]c"
				end
				vim.schedule(function()
					gs.next_hunk()
				end)
				return "<Ignore>"
			end, { expr = true, desc = "Next hunk" })

			map("n", "[c", function()
				if vim.wo.diff then
					return "[c"
				end
				vim.schedule(function()
					gs.prev_hunk()
				end)
				return "<Ignore>"
			end, { expr = true, desc = "Previous hunk" })

			-- Actions
			map({ "n", "v" }, "<leader>hs", ":Gitsigns stage_hunk<CR>", { desc = "Stage hunk" })
			map({ "n", "v" }, "<leader>hr", ":Gitsigns reset_hunk<CR>", { desc = "Reset hunk" })
			map("n", "<leader>hS", gs.stage_buffer, { desc = "Stage buffer" })
			map("n", "<leader>hu", gs.undo_stage_hunk, { desc = "Undo stage hunk" })
			map("n", "<leader>hR", gs.reset_buffer, { desc = "Reset buffer" })
			map("n", "<leader>hp", gs.preview_hunk, { desc = "Preview hunk" })
			map("n", "<leader>hb", function()
				gs.blame_line({ full = true })
			end, { desc = "Blame line" })
			map("n", "<leader>tb", gs.toggle_current_line_blame, { desc = "Toggle line blame" })
			map("n", "<leader>hd", gs.diffthis, { desc = "Diff this" })
			map("n", "<leader>hD", function()
				gs.diffthis("~")
			end, { desc = "Diff this ~" })
			map("n", "<leader>tgd", gs.toggle_deleted, { desc = "Toggle deleted" })

			-- Text object
			map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", { desc = "Git hunk" })
		end,
	},
}

-- Keymap definitions
local keymaps = {
	-- ===== NEOGIT OPERATIONS =====
	-- Main Neogit interface
	["<leader>go"] = { "Open Neogit", function() require("neogit").open() end },
	["<leader>gcm"] = { "Neogit Commit", ":Neogit commit<CR>", { silent = true, noremap = true } },
	["<leader>gp"] = { "Neogit Pull", ":Neogit pull<CR>", { silent = true, noremap = true } },
	["<leader>gps"] = { "Neogit Push", ":Neogit push<CR>", { silent = true, noremap = true } },
	["<leader>gl"] = { "Neogit Log", ":Neogit log<CR>", { silent = true, noremap = true } },
	["<leader>gbr"] = { "Git Branches", ":Telescope git_branches<CR>", { silent = true, noremap = true } },
	["<leader>gB"] = { "Git Blame", ":G blame<CR>", { silent = true, noremap = true } },
	
	-- ===== TELESCOPE GIT OPERATIONS =====
	-- Note: <leader>gc, <leader>gb, <leader>gs are defined in telescope.lua
	-- <leader>gc = git_commits, <leader>gb = git_bcommits, <leader>gs = git_status
	["<leader>gt"] = { "Git Status (Telescope)", function() require("telescope.builtin").git_status() end },
	["<leader>gF"] = { "Git Files (Telescope)", function() require("telescope.builtin").git_files() end },
	["<leader>gT"] = { "Git Tags (Telescope)", function() require("telescope.builtin").git_branches() end },
	
	-- ===== DIFFVIEW OPERATIONS =====
	["<leader>gd"] = { "Diffview Open", ":DiffviewOpen<CR>", { silent = true, noremap = true } },
	["<leader>gD"] = { "Diffview Close", ":DiffviewClose<CR>", { silent = true, noremap = true } },
	["<leader>gh"] = { "Diffview Toggle Files", ":DiffviewToggleFiles<CR>", { silent = true, noremap = true } },
	
	-- ===== GIT UTILITIES =====
	["<leader>gu"] = { "Copy Git URL", function() M.copy_git_url() end },
	["<leader>gR"] = { "Open Git Root", function() M.open_git_root() end },
	["<leader>gI"] = { "Edit .gitignore", function() M.edit_gitignore() end },
}

-- Helper functions
function M.copy_git_url()
	local output = vim.fn.system("git remote get-url origin")
	if output and output ~= "" then
		output = output:gsub("%s+", "")
		vim.fn.setreg("+", output)
		vim.notify("Git URL copied to clipboard: " .. output, vim.log.levels.INFO)
	else
		vim.notify("No git remote found", vim.log.levels.WARN)
	end
end

function M.open_git_root()
	local git_root = vim.fn.system("git rev-parse --show-toplevel")
	if git_root and git_root ~= "" then
		git_root = git_root:gsub("%s+", "")
		vim.cmd("edit " .. git_root)
	else
		vim.notify("Not in a git repository", vim.log.levels.WARN)
	end
end

function M.edit_gitignore()
	local git_root = vim.fn.system("git rev-parse --show-toplevel")
	if git_root and git_root ~= "" then
		git_root = git_root:gsub("%s+", "")
		local gitignore_path = git_root .. "/.gitignore"
		vim.cmd("edit " .. gitignore_path)
	else
		vim.notify("Not in a git repository", vim.log.levels.WARN)
	end
end

function M.setup_keymaps()
	for key, value in pairs(keymaps) do
		local desc, func, opts = unpack(value)
		if type(func) == "string" then
			vim.keymap.set("n", key, func, opts or { desc = "Git: " .. desc })
		else
			vim.keymap.set("n", key, func, { desc = "Git: " .. desc })
		end
	end
end

function M.setup()
	-- Setup keymaps
	M.setup_keymaps()
end

return {
	{
		"NeogitOrg/neogit",
		enabled = true,
		lazy = false,
		dependencies = {
			"nvim-lua/plenary.nvim",
			"sindrets/diffview.nvim",
			"nvim-telescope/telescope.nvim",
		},
		opts = function(_, opts)
			return vim.tbl_deep_extend("force", opts or {}, config.neogit)
		end,
		config = function(_, opts)
			local neogit = require("neogit")
			neogit.setup(opts)
			M.setup()
		end,
	},
	{
		"lewis6991/gitsigns.nvim",
		enabled = true,
		opts = function(_, opts)
			return vim.tbl_deep_extend("force", opts or {}, config.gitsigns)
		end,
		config = function(_, opts)
			require("gitsigns").setup(opts)
		end,
	},
	{
		"sindrets/diffview.nvim",
		enabled = true,
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		opts = {
			enhanced_diff_hl = true,
			use_icons = true,
			icons = {
				folder_closed = " ",
				folder_open = " ",
			},
			signs = {
				fold_closed = " ",
				fold_open = " ",
			},
			file_panel = {
				win_config = {
					width = 35,
				},
			},
		},
	},
}
