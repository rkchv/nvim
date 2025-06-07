return {
	"ThePrimeagen/harpoon",
	enabled = true,
	branch = "harpoon2",
	dependencies = {
		"nvim-lua/plenary.nvim",
	},
	config = function(_, opts)
		local harpoon = require("harpoon")
		harpoon:setup()

		local conf = require("telescope.config").values
		local function toggle_telescope(harpoon_files)
			local file_paths = {}
			for _, item in ipairs(harpoon_files.items) do
				table.insert(file_paths, item.value)
			end

			require("telescope.pickers")
				.new({}, {
					prompt_title = "Harpoon",
					finder = require("telescope.finders").new_table({
						results = file_paths,
					}),
					previewer = conf.file_previewer({}),
					sorter = conf.generic_sorter({}),
				})
				:find()
		end

		vim.keymap.set("n", "<leader>am", function()
			harpoon:list():add()
		end, { desc = "Harpoon: Mark File" })

		vim.keymap.set("n", "<leader>rm", function()
			harpoon:list():remove()
		end, { desc = "Harpoon: Remove Mark File" })

		vim.keymap.set("n", "<leader>am", function()
			harpoon:list():add()
		end, { desc = "Harpoon: Mark File" })

		vim.keymap.set("n", "<leader>sm", function()
			toggle_telescope(harpoon:list())
		end, { desc = "Toggle Harpoon Menu" })

		vim.keymap.set("n", "<leader>1", function()
			harpoon:list():select(1)
		end, { desc = "Harpoon File 1" })

		vim.keymap.set("n", "<leader>2", function()
			harpoon:list():select(2)
		end, { desc = "Harpoon File 2" })

		vim.keymap.set("n", "<leader>3", function()
			harpoon:list():select(3)
		end, { desc = "Harpoon File 3" })

		vim.keymap.set("n", "<leader>4", function()
			harpoon:list():select(4)
		end, { desc = "Harpoon File 4" })
	end,
}
