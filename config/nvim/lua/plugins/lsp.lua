return {
	{
		"williamboman/mason.nvim",
		lazy = false,
		config = function()
			require("mason").setup()
		end,
	},
	{
		"williamboman/mason-lspconfig.nvim",
		lazy = false,
		ensure_installed = { "tsserver", "eslint_d", "prettier" },
		opts = {
			auto_install = true,
		},
	},
	{
		"neovim/nvim-lspconfig",
		lazy = false,
		config = function()
			local lsp_config = require("lspconfig")
			local capabilities = require("cmp_nvim_lsp").default_capabilities()

			-- Initialize Mason and Mason-Lspconfig with your LSP servers
			require("mason").setup()
			require("mason-lspconfig").setup({
				ensure_installed = { "astro", "ts_ls", "lua_ls", "bashls" },
			})

			-- Key mappings for diagnostics
			vim.keymap.set("n", "<leader>dh", vim.diagnostic.open_float)
			vim.keymap.set("n", "<leader>dp", vim.diagnostic.goto_prev)
			vim.keymap.set("n", "<leader>dn", vim.diagnostic.goto_next)
			vim.keymap.set("n", "<leader>dl", vim.diagnostic.setqflist)

			-- Attach diagnostics and LSP settings
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("UserLspConfig", {}),
				callback = function(ev)
					local opts = { buffer = ev.buf }
					vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
					vim.keymap.set("n", "gh", vim.lsp.buf.hover, opts)
					vim.keymap.set("n", "gq", vim.lsp.buf.code_action, opts)
					vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
					vim.keymap.set("n", "gs", vim.lsp.buf.signature_help, opts)
					vim.keymap.set("i", "<C-y>", vim.lsp.buf.signature_help, opts)
					vim.keymap.set("n", "rn", vim.lsp.buf.rename, opts)
				end,
			})

			-- General diagnostics configuration
			vim.diagnostic.config({ virtual_text = true, signs = false })

			-- Dart LSP setup with excluded folders
			local dartExcludedFolders = {
				vim.fn.expand("$HOME/AppData/Local/Pub/Cache"),
				vim.fn.expand("$HOME/.pub-cache"),
				vim.fn.expand("/opt/homebrew/"),
				vim.fn.expand("$HOME/tools/flutter/"),
			}

			lsp_config.dartls.setup({
				capabilities = capabilities,
				cmd = { "dart", "language-server", "--protocol=lsp" },
				filetypes = { "dart" },
				init_options = { suggestFromUnimportedLibraries = true },
				settings = {
					dart = {
						analysisExcludedFolders = dartExcludedFolders,
						updateImportsOnRename = true,
					},
				},
			})

			-- Additional LSP Configurations
			lsp_config.astro.setup({ capabilities = capabilities })
			lsp_config.ts_ls.setup({ capabilities = capabilities })
			lsp_config.lua_ls.setup({
				capabilities = capabilities,
				settings = {
					Lua = { diagnostics = { globals = { "vim" } } },
				},
			})

			-- Fidget configuration for LSP progress
			require("fidget").setup({})
			-- Navbuddy configuration for better navigation in LSP
			require("nvim-navbuddy").setup({ lsp = { auto_attach = true } })
			vim.api.nvim_set_keymap("n", "<leader>o", ":Navbuddy<CR>", { noremap = true, silent = true })
		end,
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			{ "j-hui/fidget.nvim", tag = "legacy" },
			"RobertBrunhage/dart-tools.nvim",
			{
				"SmiteshP/nvim-navbuddy",
				dependencies = { "SmiteshP/nvim-navic", "MunifTanjim/nui.nvim" },
			},
		},
	},
}
