return {
	"nvim-neo-tree/neo-tree.nvim",
	branch = "v3.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		-- "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
		-- "MunifTanjim/nui.nvim",
	},
	config = function()
		-- Disable netrw
		vim.g.loaded = 1
		vim.g.loaded_netrwPlugin = 1

		-- Set key mappings
		vim.keymap.set("n", "<leader>e", ":Neotree toggle<CR>", {})
		vim.keymap.set("n", "<leader>lb", ":Neotree buffers reveal float<CR>", {})
		vim.keymap.set("n", "<leader>nr", ":Neotree reveal<CR>", {})

		-- Setup neo-tree with recommended settings
		require("neo-tree").setup({
			filesystem = {
				commands = {
					delete = function(state)
						local node = state.tree:get_node()
						local path = node:get_id()
						local inputs = require("neo-tree.ui.inputs")

						-- Show confirmation dialog with updated API
						inputs.confirm(
							"Are you sure you want to trash " .. vim.fn.fnamemodify(path, ":t") .. "?",
							function(confirmed)
								if confirmed then
									-- Use trash command with proper shell escaping
									local cmd = "trash " .. vim.fn.shellescape(path)
									local result = vim.fn.system(cmd)
									
									if vim.v.shell_error == 0 then
										-- Refresh Neo-tree to reflect the changes
										require("neo-tree.sources.manager").refresh(state.name)
										vim.notify("File moved to trash: " .. vim.fn.fnamemodify(path, ":t"))
									else
										vim.notify("Failed to trash file: " .. vim.trim(result or ""), vim.log.levels.ERROR)
									end
								else
									vim.notify("Deletion canceled")
								end
							end
						)
					end,
					system_open = function(state)
						local node = state.tree:get_node()
						local path = node:get_id()

						if vim.fn.has("mac") == 1 then
							-- macOS: open file in default application
							vim.fn.jobstart({ "open", path }, { detach = true })
						elseif vim.fn.has("unix") == 1 then
							-- Linux: open file in default application
							vim.fn.jobstart({ "xdg-open", path }, { detach = true })
						elseif vim.fn.has("win32") == 1 then
							-- Windows: open folder in explorer
							local p
							local lastSlashIndex = path:match("^.+()\\[^\\]*$") -- Match the last slash and everything before it
							if lastSlashIndex then
								p = path:sub(1, lastSlashIndex - 1) -- Extract substring before the last slash
							else
								p = path -- If no slash found, return original path
							end
							vim.cmd("silent !start explorer " .. p)
						else
							print("Unsupported operating system")
						end
					end,
				},
				window = {
					mappings = {
						["d"] = "delete", -- Map the delete command to use the trash
						["oo"] = "system_open",
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
