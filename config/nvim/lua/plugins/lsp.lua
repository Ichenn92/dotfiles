return {
	{
		"williamboman/mason.nvim",
		lazy = false,
		config = function()
			require("mason").setup()
		end,
	},
	{
		-- bridges the gap between mason and lspconfig
		"williamboman/mason-lspconfig.nvim",
		lazy = false,
		opts = {
			auto_install = true,
		},
	},
	{
		"neovim/nvim-lspconfig",
		lazy = false,
		config = function()
			local lsp_config = require("lspconfig")
			require("mason").setup()
			require("mason-lspconfig").setup({
				ensure_installed = {
					-- dart sdk ships with LSP
					"astro",
					"tsserver",
					"lua_ls",
				},
			})
      require'lspconfig'.bashls.setup{}

			local capabilities = require("cmp_nvim_lsp").default_capabilities()

			vim.keymap.set("n", "<leader>dh", vim.diagnostic.open_float)
			vim.keymap.set("n", "<leader>dp", vim.diagnostic.goto_prev)
			vim.keymap.set("n", "<leader>dn", vim.diagnostic.goto_next)
			vim.keymap.set("n", "<leader>dl", vim.diagnostic.setqflist)

			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("UserLspConfig", {}),
				callback = function(ev)
					-- Buffer local mappings.
					-- See `:help vim.lsp.*` for documentation on any of the below functions
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

			vim.diagnostic.config({
				virtual_text = true,
				signs = false,
			})

			local dartExcludedFolders = {
				vim.fn.expand("$HOME/AppData/Local/Pub/Cache"),
				vim.fn.expand("$HOME/.pub-cache"),
				vim.fn.expand("/opt/homebrew/"),
				vim.fn.expand("$HOME/tools/flutter/"),
			}

			lsp_config["dartls"].setup({
				capabilities = capabilities,
				cmd = {
					"dart",
					"language-server",
					"--protocol=lsp",
					-- "--port=8123",
					-- "--instrumentation-log-file=/Users/robertbrunhage/Desktop/lsp-log.txt",
				},
				filetypes = { "dart" },
				init_options = {
					onlyAnalyzeProjectsWithOpenFiles = false,
					suggestFromUnimportedLibraries = true,
					closingLabels = true,
					outline = false,
					flutterOutline = false,
				},
				settings = {
					dart = {
						analysisExcludedFolders = dartExcludedFolders,
						updateImportsOnRename = true,
						completeFunctionCalls = true,
						showTodos = true,
					},
				},
			})

			lsp_config.astro.setup({
				capabilities = capabilities,
			})

			lsp_config.tsserver.setup({
				capabilities = capabilities,
			})

			lsp_config.lua_ls.setup({
				capabilities = capabilities,
				settings = {
					Lua = {
						diagnostics = {
							globals = { "vim" },
						},
					},
				},
			})

			-- Tooltip for the lsp in bottom right
			require("fidget").setup({})

			-- Hot reload :)
			require("dart-tools")
		end,
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			{ "j-hui/fidget.nvim", tag = "legacy" },
			"RobertBrunhage/dart-tools.nvim",
			{
				"SmiteshP/nvim-navbuddy",
				dependencies = {
					"SmiteshP/nvim-navic",
					"MunifTanjim/nui.nvim",
				},
				opts = { lsp = { auto_attach = true } },
				config = function()
					require("nvim-navbuddy").setup({
						lsp = { auto_attach = true },
					})
					vim.api.nvim_set_keymap("n", "<leader>o", ":Navbuddy<CR>", { noremap = true, silent = true })
				end,
			},
		},
	},
}
