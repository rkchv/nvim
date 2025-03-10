return {
  "nvim-telescope/telescope.nvim",
  enabled = true,
  cmd = { "Telescope" },

  dependencies = {
    "nvim-lua/plenary.nvim",
    "ThePrimeagen/git-worktree.nvim",
    {
      "nvim-telescope/telescope-fzf-native.nvim",
      build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release",
    },
  },

  opts = function(_, opts)
    local actions = require("telescope.actions")
    opts.defaults = {
      -- preview = {
      --   treesitter = false,
      -- },
      vimgrep_arguments = {
        "rg",
        "--color=never",
        "--no-heading",
        "--with-filename",
        "--line-number",
        "--column",
        "--smart-case",
        "--hidden",
      },
      file_ignore_patterns = {
        ".git/",
        "vendor",
        "node_modules",
        "assets",
        "commercial",
        ".DS_Store",
        "build/",
        "dist/",
        ".expo/"
      },
      layout_config = {
        prompt_position = "top",
        height = 0.5,
        width = 0.87,
      },
      layout_strategy = "horizontal",
      mappings = {
        i = {
          ["<c-j>"] = actions.move_selection_next,
          ["<c-k>"] = actions.move_selection_previous,
        },
      },
      sorting_strategy = "ascending",
      winblend = 0,
    }
    opts.pickers = {
      -- colorscheme = { enable_preview = true },
      find_files = { hidden = true, no_ignore = true },
      -- git_files = { hidden = true },
    }
    opts.extensions = {
      file_browser = {
        hijack_netrw = true,
      },
    }
  end,

  config = function(_, opts)
    local telescope = require("telescope")
    local builtin = require("telescope.builtin")
    local gitworktree = require("telescope").extensions.git_worktree

    telescope.setup(opts)
    telescope.load_extension("fzf")
    telescope.load_extension("git_worktree")

    -- Map("n", "<leader>fa", "<cmd> Telescope find_files follow=true no_ignore=true hidden=true <CR>")

    vim.keymap.set("n", "<leader>?", builtin.oldfiles, { desc = "[?] Find recently opened files" })
    vim.keymap.set("n", "<leader>/", function()
      builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
        winblend = 10,
        previewer = true,
      }))
    end, { desc = "[/] Fuzzily search in current buffer]" })

    vim.keymap.set("n", "<leader>fj", builtin.find_files, { desc = "[S]earch [F]iles" })
    vim.keymap.set("n", "<leader>fk", builtin.git_files, {})
    vim.keymap.set("n", "<leader>fh", builtin.grep_string, { desc = "[S]earch current [W]ord" })
    vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "[S]earch by [G]rep" })
    vim.keymap.set("n", "<leader>fd", builtin.diagnostics, { desc = "[S]earch [D]iagnostics" })
    vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "[ ] Find existing buffers" })
    vim.keymap.set("n", "<leader>fs", builtin.git_status, { desc = "" })
    vim.keymap.set("n", "<leader>ft", gitworktree.git_worktrees, { silent = true })
    vim.keymap.set("n", "<leader>gt", gitworktree.create_git_worktree, { silent = true })
    vim.keymap.set("n", "<leader>hm", ":Telescope harpoon marks<CR>", { desc = "Harpoon [M]arks" })

    vim.api.nvim_set_keymap("n", "td", ":TodoTelescope<CR>", { noremap = true })
    vim.api.nvim_set_keymap(
      "n",
      "<Leader><tab>",
      "<Cmd>lua require('telescope.builtin').commands()<CR>",
      { noremap = false }
    )
  end,
}
