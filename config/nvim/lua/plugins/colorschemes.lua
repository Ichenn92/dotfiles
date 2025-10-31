return {
	{
		"projekt0n/github-nvim-theme",
		name = "github-theme",
		lazy = false, -- make sure we load this during startup if it is your main colorscheme
		priority = 1000, -- make sure to load this before all the other start plugins
		config = function()
			require("github-theme").setup({
				options = {
					transparent = true,
					styles = {
						types = "bold", -- @type, classes, etc
						methods = "bold", -- @function, @method
						keywords = "bold", -- if, else, return
						comments = "italic", -- optional
					},
				},
			})

			vim.cmd("colorscheme github_dark")
		end,
	},
	-- {
	-- 	"catppuccin/nvim",
	-- 	name = "catppuccin",
	-- 	priority = 1000,
	-- 	config = function()
	-- 		require("catppuccin").setup({
	-- 			transparent_background = false, -- Default to false, we'll toggle it
	-- 			integrations = {
	-- 				neotree = {
	-- 					enabled = true,
	-- 					show_root = false,
	-- 					transparent_panel = false, -- Keep neo-tree panel opaque
	-- 				},
	-- 			},
	-- 		})
	-- 	end,
	-- },
	-- {
	-- 	"olimorris/onedarkpro.nvim",
	-- 	priority = 1000,
	-- 	config = function()
	-- 		require("onedarkpro").setup({
	-- 			styles = {
	-- 				types = "bold", -- @type, classes, etc
	-- 				methods = "bold", -- @function, @method
	-- 				keywords = "bold", -- if, else, return
	-- 				comments = "italic", -- optional
	-- 			},
	-- 		})
	-- 		require("onedarkpro").load() -- <- actually apply it
	-- 	end,
	-- },
}
