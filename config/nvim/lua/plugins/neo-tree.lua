return {
	"nvim-neo-tree/neo-tree.nvim",
	branch = "v3.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
		"MunifTanjim/nui.nvim",
	},
	config = function()
		-- Disable netrw
		vim.g.loaded = 1
		vim.g.loaded_netrwPlugin = 1

		-- Set key mappings
		vim.keymap.set("n", "<leader>e", ":Neotree toggle<CR>", {})
		vim.keymap.set("n", "<leader>lb", ":Neotree buffers reveal float<CR>", {})

		-- Setup neo-tree with recommended settings
		require("neo-tree").setup({
			filesystem = {
				commands = {
					delete = function(state)
						local node = state.tree:get_node()
						local path = node:get_id()
						local inputs = require("neo-tree.ui.inputs")

						-- Function to handle the confirmation
						local function handle_confirmation(choice)
							if choice then
								-- Use trash instead of rm
								vim.fn.system({ "trash", vim.fn.fnameescape(path) })
								-- Refresh Neo-tree to reflect the changes
								require("neo-tree.sources.manager").refresh(state.name)
								print("File moved to trash: " .. path)
							else
								print("Deletion canceled")
							end
						end

						-- Show confirmation dialog
						inputs.confirm(
							"Are you sure you want to delete this file?", -- Prompt
							handle_confirmation -- Function to call with the user's response
						)
					end,
				},
				window = {
					mappings = {
						["d"] = "delete", -- Map the delete command to use the trash
					},
				},
			},
			window = {
				mappings = {
					["<space>"] = {
						"toggle_node",
						nowait = true, -- disable `nowait` if you have existing combos starting with this char that you want to use
					},
				},
			},
		})
	end,
}
