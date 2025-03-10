return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "jose-elias-alvarez/null-ls.nvim"
    },
    enabled = true,

    config = function()
      local lspconfig = require('lspconfig')

      lspconfig.emmet_language_server.setup({
        filetypes = { "typescriptreact", "javascriptreact", "html", "css" },
      })

      lspconfig.ts_ls.setup({})

      lspconfig.zls.setup({})

      lspconfig.bashls.setup({})

      lspconfig.yamlls.setup({
        settings = {
          yaml = {
            format = {
              enable = true,
            },
            schemas = {
              ["http://json.schemastore.org/github-workflow"] = ".github/workflows/*",
            },
          },
        },
      })

      lspconfig.lua_ls.setup({
        settings = {
          Lua = {
            format = {
              enable = true,
              defaultConfig = {
                indent_style = "space",
                indent_size = "2",
              }
            },
            runtime = {
              version = 'LuaJIT', -- LuaJIT is used in Neovim
            },
            diagnostics = {
              enable = true,       -- Enable diagnostics for undefined variables
              globals = { 'vim' }, -- Recognize 'vim' as a global variable in Neovim config files
            },
            telemetry = {
              enable = false, -- Disable telemetry (send anonymous usage data)
            },
          },
        },
      })

      lspconfig.gopls.setup({
        -- settings = {
        --   gopls = {
        --     analyses = {
        --       unusedparams = true,
        --       shadow = true,
        --       nilness = true,
        --     },
        --     staticcheck = true,
        --     completeUnimported = true,
        --     gofumpt = true,
        --     usePlaceholders = true,
        --     linksInHover = true,
        --   },
        -- },
      })

      lspconfig.ccls.setup({
        require('lspconfig').ccls.setup({
          root_dir = require('lspconfig.util').root_pattern('compile_commands.json', '.ccls', '.git')
        }),

        init_options = {
          compilationDatabaseDirectory = "build",
          index = {
            threads = 0,
          },
          clang = {
            excludeArgs = { "-frounding-math" },
          },
        }
      })

      -- null_ls.setup({
      --   sources = {
      --     null_ls.builtins.diagnostics.buf,
      --     null_ls.builtins.formatting.buf,
      --   },
      -- })
    end,
  },
}
