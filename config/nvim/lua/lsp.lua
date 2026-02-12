local keymap = vim.keymap
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("UserLspConfig", {}),
  callback = function(ev)
    local opts = { buffer = ev.buf, silent = true }

    opts.desc = "Show documentation for what is under cursor"
    keymap.set("n", "gh", vim.lsp.buf.hover, opts)

    opts.desc = "Go to Definition"
    keymap.set("n", "gd", vim.lsp.buf.definition, opts)

    opts.desc = "Go to declaration"
    keymap.set("n", "gD", vim.lsp.buf.declaration, opts) -- go to declaration

    opts.desc = "See Available Code Action"
    keymap.set("n", "gq", vim.lsp.buf.code_action, opts)

    opts.desc = "References"
    keymap.set("n", "gr", vim.lsp.buf.references, opts)

    opts.desc = "Show LSP implementations"
    keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts) -- show lsp implementations

    opts.desc = "Show LSP type definitions"
    keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", opts) -- show lsp type definitions

    opts.desc = "Signature Help"
    keymap.set("n", "gs", vim.lsp.buf.signature_help, opts)

    opts.desc = "Rename Symbol"
    keymap.set("n", "rn", vim.lsp.buf.rename, opts)

    opts.desc = "Signature Help Insert"
    keymap.set("i", "<C-y>", vim.lsp.buf.signature_help, opts)

    opts.desc = "Hover Diagnostics"
    keymap.set("n", "<leader>dh", vim.diagnostic.open_float, opts)

    opts.desc = "Previous Diagnostic"
    keymap.set("n", "<leader>dp", vim.diagnostic.goto_prev, opts)

    opts.desc = "Next Diagnostic"
    keymap.set("n", "<leader>dn", vim.diagnostic.goto_next, opts)

    opts.desc = "Diagnostic List"
    keymap.set("n", "<leader>dl", vim.diagnostic.setqflist, opts)

    opts.desc = "Restart LSP"
    keymap.set("n", "<leader>rs", ":LspRestart<CR>", opts) -- mapping to restart lsp if necessary

    local lsp_config = require("lspconfig")
    lsp_config["dartls"].setup({
      settings = {
        dart = {
          analysisExcludedFolders = {
            vim.fn.expand("$HOME/AppData/Local/Pub/Cache"),
            vim.fn.expand("$HOME/.pub-cache"),
            vim.fn.expand("/opt/homebrew/"),
            vim.fn.expand("$HOME/tools/flutter/"),
          },
        },
      },
    })
  end,
})

-- vim.lsp.inlay_hint.enable(true)

local severity = vim.diagnostic.severity

vim.diagnostic.config({
  signs = {
    text = {
      [severity.ERROR] = " ",
      [severity.WARN] = " ",
      [severity.HINT] = "󰠠 ",
      [severity.INFO] = " ",
    },
  },
})
