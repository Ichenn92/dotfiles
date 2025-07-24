return {
	{
		"neovim/nvim-lspconfig",
		-- only load when editing Dart/TS files
		ft = { "dart", "typescript", "typescriptreact", "html", "css" },
		config = function()
			local lspconfig = require("lspconfig")
			local cmp_nvim_lsp = require("cmp_nvim_lsp")
			local capabilities = cmp_nvim_lsp.default_capabilities()
			local cmp = require("cmp")
			local luasnip = require("luasnip")
			local has_copilot, copilot_suggestion = pcall(require, "copilot.suggestion")

			-- super-tab / snippet / copilot integration
			cmp.setup({
				snippet = {
					expand = function(args)
						luasnip.lsp_expand(args.body)
					end,
				},
				mapping = {
					["<Tab>"] = cmp.mapping(function(fallback)
						local col = vim.fn.col(".") - 1
						if has_copilot and copilot_suggestion.is_visible() then
							copilot_suggestion.accept()
						elseif cmp.visible() then
							cmp.select_next_item()
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
			})

			-- common on_attach & diagnostics
			local function on_attach(_, bufnr)
				local bufmap = function(mode, lhs, rhs, desc)
					vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc, silent = true })
				end
				vim.keymap.set("n", "gh", vim.lsp.buf.hover, { desc = "Hover Documentation" })
				bufmap("n", "gd", vim.lsp.buf.definition, "Go to Definition")
				bufmap("n", "gq", vim.lsp.buf.code_action, "Code Action")
				bufmap("n", "gr", vim.lsp.buf.references, "References")
				bufmap("n", "gs", vim.lsp.buf.signature_help, "Signature Help")
				bufmap("n", "rn", vim.lsp.buf.rename, "Rename Symbol")
				bufmap("i", "<C-y>", vim.lsp.buf.signature_help, "Signature Help Insert")
				bufmap("n", "<leader>dh", vim.diagnostic.open_float, "Hover Diagnostics")
				bufmap("n", "<leader>dp", vim.diagnostic.goto_prev, "Previous Diagnostic")
				bufmap("n", "<leader>dn", vim.diagnostic.goto_next, "Next Diagnostic")
				bufmap("n", "<leader>dl", vim.diagnostic.setqflist, "Diagnostic List")
			end

			vim.diagnostic.config({
				virtual_text = { prefix = "●" },
				float = { border = "rounded" },
				severity_sort = true,
			})

			-- Optimized server configurations with performance tweaks
			local servers = {
				cssls = {
					autostart = false, -- Start manually when needed
					flags = { debounce_text_changes = 500 }, -- Increased debounce
				},
				html = {
					filetypes = { "html" },
					autostart = false, -- Start manually when needed
					init_options = { hostInfo = "neovim", preferences = { disableSuggestions = true } },
					flags = { debounce_text_changes = 500 }, -- Increased debounce
				},
				ts_ls = {
					filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
					-- autostart = true, -- Keep TypeScript LSP on since it's frequently used
					init_options = { 
						hostInfo = "neovim", 
						preferences = { 
							disableSuggestions = true,
							-- Reduce memory usage
							maxTsServerMemory = 3072,
						}
					},
					flags = { debounce_text_changes = 500 }, -- Increased debounce
				},
				dartls = {
					filetypes = { "dart" },
					cmd = { "dart", "language-server", "--protocol=lsp" },
					-- autostart = true, -- Keep Dart LSP on since it's frequently used
					init_options = { suggestFromUnimportedLibraries = true },
					flags = { debounce_text_changes = 500 }, -- Increased debounce
					settings = {
						dart = {
							updateImportsOnRename = true,
							-- Performance: Exclude more folders from analysis
							analysisExcludedFolders = {
								vim.fn.expand("$HOME/.pub-cache"),
								vim.fn.expand("$HOME/AppData/Local/Pub/Cache"),
								vim.fn.expand("$HOME/tools/flutter"),
								vim.fn.expand("$HOME/Library/Developer/Xcode"),
								"/opt/homebrew/",
								"/usr/local/",
								"**/node_modules",
								"**/.git",
							},
							-- Limit concurrent analysis
							maxFileSize = 4194304, -- 4MB limit
						},
					},
				},
			}

			for name, opts in pairs(servers) do
				lspconfig[name].setup(vim.tbl_deep_extend("force", {
					capabilities = capabilities,
					on_attach = on_attach,
					handlers = {
						["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" }),
						["textDocument/signatureHelp"] = vim.lsp.with(
							vim.lsp.handlers.signature_help,
							{ border = "rounded" }
						),
					},
				}, opts))
			end

			-- lightweight progress indicator & navbuddy if you like:
			require("fidget").setup({ window = { blend = 0 }, timer = { spinner_rate = 200 } })
			require("nvim-navbuddy").setup({ lsp = { auto_attach = true } })
			vim.keymap.set("n", "<leader>o", ":Navbuddy<CR>", { noremap = true, silent = true })
		end,
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			{ "j-hui/fidget.nvim", tag = "legacy" },
			"RobertBrunhage/dart-tools.nvim",
			{ "SmiteshP/nvim-navbuddy", dependencies = { "SmiteshP/nvim-navic", "MunifTanjim/nui.nvim" } },
		},
	},
}
