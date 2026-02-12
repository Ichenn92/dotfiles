return {
	"nvim-telescope/telescope.nvim",
	config = function()
		local builtin = require("telescope.builtin")
		local lga_actions = require("telescope-live-grep-args.actions")

		vim.keymap.set("n", "<leader>tb", builtin.buffers, {})
		vim.keymap.set("n", "<leader>to", builtin.oldfiles, {})

		vim.keymap.set("n", "<leader>tt", require("telescope").extensions.live_grep_args.live_grep_args)

		vim.keymap.set("n", "<leader>ts", builtin.lsp_document_symbols, {})
		vim.keymap.set("n", "<leader>tf", builtin.find_files, {})

		require("telescope").setup({
			defaults = {
				file_ignore_patterns = { "%.g%.dart$", "%.freezed%.dart$" },
				file_sorter = require("telescope.sorters").get_fzy_sorter,
				file_previewer = require("telescope.previewers").vim_buffer_cat.new,
				grep_previewer = require("telescope.previewers").vim_buffer_vimgrep.new,
				qflist_previewer = require("telescope.previewers").vim_buffer_qflist.new,
			},
			preview = {
				treesitter = true,
			},
			extensions = {
				fzy_native = {
					override_generic_sorter = false,
					override_file_sorter = true,
				},
				live_grep_args = {
					auto_quoting = true,
					mappings = {
						i = {
							["<C-k>"] = lga_actions.quote_prompt(),
							["<C-i>"] = lga_actions.quote_prompt({ postfix = " --iglob " }),
						},
					},
				},
				["ui-select"] = {
					require("telescope.themes").get_dropdown({
						specific_opts = {
							codeactions = false,
						},
					}),
				},
			},
		})

		require("telescope").load_extension("fzy_native")
		require("telescope").load_extension("live_grep_args")
		require("telescope").load_extension("ui-select")
	end,

	dependencies = {
		"nvim-telescope/telescope-fzy-native.nvim",
		"nvim-telescope/telescope-live-grep-args.nvim",
		-- Allows using telescope for things like code action (handy for searching)
		"nvim-telescope/telescope-ui-select.nvim",
	},
}
