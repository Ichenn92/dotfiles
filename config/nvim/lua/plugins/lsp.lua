return {
	-- Mason setup for managing LSP servers and tools
	{
		"williamboman/mason.nvim",
		lazy = false,
		config = function()
			require("mason").setup()
		end,
	},
	-- Mason-lspconfig setup to automatically install and manage LSPs
	{
		"williamboman/mason-lspconfig.nvim",
		lazy = false,
		opts = {
			ensure_installed = { "astro", "ts_ls", "lua_ls", "bashls" },
			auto_install = true,
		},
	},
	-- Main LSP configuration
	{
		"neovim/nvim-lspconfig",
		lazy = false,
		config = function()
			local lspconfig = require("lspconfig")
			local capabilities = require("cmp_nvim_lsp").default_capabilities()
			local cmp = require("cmp")
			local luasnip = require("luasnip")
			local has_copilot, copilot_suggestion = pcall(require, "copilot.suggestion")

			-- Super Tab integration
			cmp.setup({
				mapping = {
					["<Tab>"] = cmp.mapping(function(fallback)
						local col = vim.fn.col(".") - 1
						if has_copilot and copilot_suggestion.is_visible() then
							copilot_suggestion.accept()
						elseif cmp.visible() then
							cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
						elseif luasnip.expand_or_jumpable() then
							luasnip.expand_or_jump()
						elseif col == 0 or vim.fn.getline("."):sub(col, col):match("%s") then
							fallback()
						else
							cmp.complete()
						end
					end, { "i", "s" }),
				},
				sources = {
					{ name = "nvim_lsp" },
					{ name = "luasnip" },
					{ name = "buffer" },
					{ name = "path" },
				},
				snippet = {
					expand = function(args)
						luasnip.lsp_expand(args.body)
					end,
				},
			})

			-- Helper function for mapping keys
			local function on_attach(_, bufnr)
				local buf_set_keymap = function(mode, lhs, rhs, desc)
					vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
				end

				-- Diagnostic mappings
				buf_set_keymap("n", "<leader>dh", vim.diagnostic.open_float, "Hover Diagnostics")
				buf_set_keymap("n", "<leader>dp", vim.diagnostic.goto_prev, "Previous Diagnostic")
				buf_set_keymap("n", "<leader>dn", vim.diagnostic.goto_next, "Next Diagnostic")
				-- buf_set_keymap("n", "<leader>dl", vim.diagnostic.setqflist, "Diagnostic List")

				local function suppress_diagnostic_info()
					local original_notify = vim.notify
					vim.notify = function(msg, log_level, _opts)
						-- Suppress the specific info message
						if msg and msg:match("Functional providers must receive") then
							return
						end
						-- Pass other messages through
						original_notify(msg, log_level)
					end

					-- Call the diagnostic function
					local ok = pcall(vim.diagnostic.setqflist)

					-- Restore original notify
					vim.notify = original_notify

					-- Handle errors if `pcall` fails
					if not ok then
						vim.notify("Failed to set diagnostics in qflist", vim.log.levels.ERROR)
					end
				end
				buf_set_keymap("n", "<leader>dl", suppress_diagnostic_info, "Diagnostic List")

				-- LSP-specific mappings
				buf_set_keymap("n", "gd", vim.lsp.buf.definition, "Go to Definition")
				buf_set_keymap("n", "gh", vim.lsp.buf.hover, "Hover Documentation")
				buf_set_keymap("n", "gq", vim.lsp.buf.code_action, "Code Action")
				buf_set_keymap("n", "gr", vim.lsp.buf.references, "References")
				buf_set_keymap("n", "gs", vim.lsp.buf.signature_help, "Signature Help")
				buf_set_keymap("i", "<C-y>", vim.lsp.buf.signature_help, "Signature Help Insert")
				buf_set_keymap("n", "rn", vim.lsp.buf.rename, "Rename Symbol")
			end

			-- Configure diagnostics globally
			vim.diagnostic.config({
				virtual_text = { prefix = "●" },
				float = { border = "rounded" },
				severity_sort = true,
			})

			-- Dart configuration with custom excluded folders
			local dart_excluded_folders = {
				vim.fn.expand("$HOME/AppData/Local/Pub/Cache"),
				vim.fn.expand("$HOME/.pub-cache"),
				vim.fn.expand("/opt/homebrew/"),
				vim.fn.expand("$HOME/tools/flutter/"),
			}

			lspconfig.dartls.setup({
				capabilities = capabilities,
				cmd = { "dart", "language-server", "--protocol=lsp" },
				filetypes = { "dart" },
				init_options = { suggestFromUnimportedLibraries = true },
				settings = {
					dart = {
						analysisExcludedFolders = dart_excluded_folders,
						updateImportsOnRename = true,
					},
				},
				on_attach = on_attach,
			})

			-- General LSP servers setup
			local servers = { "astro", "ts_ls", "lua_ls", "bashls" }
			for _, server in ipairs(servers) do
				lspconfig[server].setup({
					capabilities = capabilities,
					on_attach = on_attach,
				})
			end

			-- Lua-specific settings
			lspconfig.lua_ls.setup({
				capabilities = capabilities,
				settings = {
					Lua = {
						diagnostics = { globals = { "vim" } },
						workspace = { checkThirdParty = false },
					},
				},
				on_attach = on_attach,
			})

			-- Progress indicator for LSP
			require("fidget").setup({})

			-- Navbuddy for better navigation in LSP
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
