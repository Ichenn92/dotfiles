return {
  {
    "williamboman/mason-lspconfig.nvim",
    opts = {
      ensure_installed = {
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
    opts = {
      ensure_installed = {
        "prettier", -- prettier formatter
        "stylua", -- lua formatter
        "isort", -- python formatter
        "black", -- python formatter
        "pylint",
        "eslint_d",
      },
    },
    dependencies = {
      "williamboman/mason.nvim",
    },
  },
}
