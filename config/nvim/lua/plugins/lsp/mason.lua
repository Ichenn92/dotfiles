local is_dotfiles_check = vim.env.DOTFILES_CHECK == "1"

return {
  {
    "williamboman/mason-lspconfig.nvim",
    enabled = not is_dotfiles_check,
    opts = {
      ensure_installed = is_dotfiles_check and {} or {
        "lua_ls",
        "gopls",
        "ts_ls",
        "eslint",
        "html",
        "cssls",
        "jsonls",
        "yamlls",
      },
    },
    dependencies = {
      {
        "williamboman/mason.nvim",
        opts = {
          ui = {
            icons = {
              package_installed = "✓",
              package_pending = "➜",
              package_uninstalled = "✗",
            },
          },
        },
      },
      {
        "neovim/nvim-lspconfig",
        -- add shortcut leader o
        dependencies = {
          {
            "SmiteshP/nvim-navbuddy",
            dependencies = {
              "SmiteshP/nvim-navic",
              "MunifTanjim/nui.nvim",
            },
            opts = {
              lsp = { auto_attach = true },
            },
          },
        },
        keys = {
          {
            "<leader>o",
            "<cmd>Navbuddy<CR>",
            desc = "Show LSP symbols in a tree view",
          },
        },
      },
    },
  },
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    enabled = not is_dotfiles_check,
    opts = {
      ensure_installed = is_dotfiles_check and {} or {
        "prettier", -- prettier formatter
        "stylua", -- lua formatter
        "isort", -- python formatter
        "black", -- python formatter
        "pylint",
        "eslint_d",
      },
      run_on_start = not is_dotfiles_check,
    },
    dependencies = {
      "williamboman/mason.nvim",
    },
  },
}
