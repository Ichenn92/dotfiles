return {
	"nvim-telescope/telescope.nvim",
	config = function()
		local builtin = require("telescope.builtin")

		vim.keymap.set("n", "<leader>tb", builtin.buffers, {})
		vim.keymap.set("n", "<leader>to", builtin.oldfiles, {})
		vim.keymap.set("n", "<leader>tlb", function()
			builtin.git_branches({ show_remote_tracking_branches = false })
		end, {})

		vim.keymap.set("n", "<leader>tlrb", builtin.git_branches, {})
		vim.keymap.set("n", "<leader>tt", require("telescope").extensions.live_grep_args.live_grep_args)
		vim.keymap.set("n", "<leader>tg", builtin.grep_string, {})
		vim.keymap.set("n", "<leader>th", builtin.help_tags, {})

		vim.keymap.set("n", "<leader>ts", builtin.lsp_document_symbols, {})
		vim.keymap.set("n", "<leader>tf", builtin.find_files, {})

		-- 🔥 Add this line to bind <leader>se to open Telescope emoji picker
    vim.keymap.set("n", "<leader>te", "<cmd>Telescope emoji<cr>", { desc = "Show emoji search" })

		require("telescope").setup({
			defaults = require("telescope.themes").get_dropdown({
				file_ignore_patterns = { "%.g%.dart$", "%.freezed%.dart$" },
				file_sorter = require("telescope.sorters").get_fzy_sorter,
				file_previewer = require("telescope.previewers").vim_buffer_cat.new,
				grep_previewer = require("telescope.previewers").vim_buffer_vimgrep.new,
				qflist_previewer = require("telescope.previewers").vim_buffer_qflist.new,
				mappings = {
					i = {
						["<C-x>"] = false,
					},
				},
			}),
			extensions = {
				fzy_native = {
					override_generic_sorter = false,
					override_file_sorter = true,
				},
				["ui-select"] = {
					specific_opts = {
						codeactions = false,
					},
				},
				emoji = {
					action = function(emoji)
						vim.fn.setreg("*", emoji.value)
						print([[Press p or "*p to paste this emoji]] .. emoji.value)
						vim.api.nvim_put({ emoji.value }, "c", false, true)
					end,
				},
			},
		})

		require("telescope").load_extension("fzy_native")
		require("telescope").load_extension("live_grep_args")
		require("telescope").load_extension("ui-select")
		require("telescope").load_extension("emoji")
	end,

	dependencies = {
		"nvim-telescope/telescope-fzy-native.nvim",
		"nvim-telescope/telescope-live-grep-args.nvim",
		-- Allows using telescope for things like code action (handy for searching)
		"nvim-telescope/telescope-ui-select.nvim",
		"xiyaowong/telescope-emoji.nvim",
	},
}
