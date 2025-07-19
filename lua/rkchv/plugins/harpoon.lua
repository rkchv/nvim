local M = {}

-- Harpoon configuration
local config = {
	menu = {
		width = function()
			return math.floor(vim.api.nvim_win_get_width(0) * 0.7)
		end,
	},
}

-- Keymap definitions
local keymaps = {
	-- File management
	["<leader>ha"] = { "Add File", function(harpoon) harpoon:list():add() end },
	["<leader>hc"] = { "Clear All Files", function(harpoon) harpoon:list():clear() end },
	["<leader>hr"] = { "Remove File", function(harpoon) harpoon:list():remove() end },
	
	-- Navigation (extended to 8 files)
	["<leader>1"] = { "Go to File 1", function(harpoon) harpoon:list():select(1) end },
	["<leader>2"] = { "Go to File 2", function(harpoon) harpoon:list():select(2) end },
	["<leader>3"] = { "Go to File 3", function(harpoon) harpoon:list():select(3) end },
	["<leader>4"] = { "Go to File 4", function(harpoon) harpoon:list():select(4) end },
	["<leader>5"] = { "Go to File 5", function(harpoon) harpoon:list():select(5) end },
	["<leader>6"] = { "Go to File 6", function(harpoon) harpoon:list():select(6) end },
	["<leader>7"] = { "Go to File 7", function(harpoon) harpoon:list():select(7) end },
	["<leader>8"] = { "Go to File 8", function(harpoon) harpoon:list():select(8) end },
	
	-- UI and menus
	["<leader>hm"] = { "Toggle Menu", function(harpoon) harpoon.ui:toggle_quick_menu(harpoon:list()) end },
	["<leader>ht"] = { "Telescope Menu", function(harpoon) M.toggle_telescope(harpoon:list()) end },
	
	-- Quick navigation
	["<leader>hp"] = { "Previous File", function(harpoon) harpoon:list():prev() end },
	["<leader>hn"] = { "Next File", function(harpoon) harpoon:list():next() end },
	
	-- Terminal management
	["<leader>htt"] = { "Toggle Terminal", function(harpoon) M.toggle_terminal(harpoon) end },
	["<leader>hat"] = { "Add Terminal", function(harpoon) harpoon:list("term"):add() end },
	["<leader>1t"] = { "Go to Terminal 1", function(harpoon) harpoon:list("term"):select(1) end },
	["<leader>2t"] = { "Go to Terminal 2", function(harpoon) harpoon:list("term"):select(2) end },
	["<leader>3t"] = { "Go to Terminal 3", function(harpoon) harpoon:list("term"):select(3) end },
	["<leader>4t"] = { "Go to Terminal 4", function(harpoon) harpoon:list("term"):select(4) end },
	
	-- Buffer and workspace management
	["<leader>hb"] = { "Add Buffer", function(harpoon) harpoon:list("buffers"):add() end },
	["<leader>hg"] = { "Add Git File", function(harpoon) harpoon:list("git"):add() end },
	["<leader>hw"] = { "Add to Workspace", function(harpoon) harpoon:list("workspace"):add() end },
	
	-- Information and utilities
	["<leader>hi"] = { "Show Info", function(harpoon) M.show_info(harpoon) end },
	["<leader>hf"] = { "Add File & Show Menu", function(harpoon) M.add_and_show(harpoon) end },
	
	-- Quick jump shortcuts
	["<leader>h1"] = { "Jump to File 1", function(harpoon) harpoon:list():select(1) end },
	["<leader>h2"] = { "Jump to File 2", function(harpoon) harpoon:list():select(2) end },
	["<leader>h3"] = { "Jump to File 3", function(harpoon) harpoon:list():select(3) end },
	["<leader>h4"] = { "Jump to File 4", function(harpoon) harpoon:list():select(4) end },
}

-- Helper functions
function M.toggle_telescope(harpoon_files)
	local conf = require("telescope.config").values
	local file_paths = {}
	
	for _, item in ipairs(harpoon_files.items) do
		table.insert(file_paths, item.value)
	end

	require("telescope.pickers")
		.new({}, {
			prompt_title = "Harpoon Files",
			finder = require("telescope.finders").new_table({
				results = file_paths,
			}),
			previewer = conf.file_previewer({}),
			sorter = conf.generic_sorter({}),
		})
		:find()
end

function M.toggle_terminal(harpoon)
	local term_list = harpoon:list("term")
	if term_list:length() == 0 then
		term_list:add()
	else
		term_list:toggle()
	end
end

function M.show_info(harpoon)
	local list = harpoon:list()
	local count = #list.items
	vim.notify(string.format("Harpoon: %d files marked", count), vim.log.levels.INFO)
end

function M.add_and_show(harpoon)
	harpoon:list():add()
	harpoon.ui:toggle_quick_menu(harpoon:list())
end

function M.setup_autocmds(harpoon)
	-- Note: Auto-save/load functionality is not available in current Harpoon version
	-- Harpoon lists are automatically persisted by the plugin
end

function M.setup_keymaps(harpoon)
	for key, value in pairs(keymaps) do
		local desc, func = unpack(value)
		vim.keymap.set("n", key, function()
			func(harpoon)
		end, { desc = "Harpoon: " .. desc })
	end
end

-- Main setup function
function M.setup()
	local harpoon = require("harpoon")
	
	-- Configure harpoon
	harpoon:setup(config)
	
	-- Setup keymaps
	M.setup_keymaps(harpoon)
	
	-- Setup autocmds
	M.setup_autocmds(harpoon)
end

return {
	"ThePrimeagen/harpoon",
	enabled = true,
	branch = "harpoon2",
	dependencies = {
		"nvim-lua/plenary.nvim",
	},
	config = function(_, opts)
		M.setup()
	end,
}
