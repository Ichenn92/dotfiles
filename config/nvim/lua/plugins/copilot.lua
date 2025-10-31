return {
	"zbirenbaum/copilot.lua",
	cmd = "Copilot",
	event = "InsertEnter",
	config = function()
		vim.lsp.config('copilot', { enabled = false })
		require("copilot").setup({
			panel = {
				enabled = false,
				auto_refresh = true,
				keymap = {
					jump_prev = "[[",
					jump_next = "]]",
					accept = "<CR>",
					refresh = "gr",
					open = "<M-CR>",
				},
				layout = {
					position = "bottom", -- | top | left | right
					ratio = 0.4,
				},
			},
			suggestion = {
				enabled = true,
				auto_trigger = true,
				debounce = 75,
				keymap = {
					dismiss = false, -- use <c-e> to dismiss completion, integrated into nvim-cmp mapping
					accept = false, -- use <tab> to accept completion, integrated into nvim-cmp mapping
					accept_word = false,
					accept_line = "<C-l>",
					next = "<M-Space>",
					prev = false,
				},
			},
			server_opts_overrides = {},
			filetypes = { markdown = true, lua = true, javascript = true, typescript = true, dart = true }, -- customize as needed
			telemetry = { enabled = false },
		})
	end,
}
