return {
	{
		"catppuccin/nvim",
		name = "catppuccin",
		priority = 1000,
	},
	{
		"olimorris/onedarkpro.nvim",
		priority = 1000,
		config = function()
			require("onedarkpro").setup({
				styles = {
					types = "bold", -- @type, classes, etc
					methods = "bold", -- @function, @method
					keywords = "bold", -- if, else, return
					comments = "italic", -- optional
				},
			})
			require("onedarkpro").load() -- <- actually apply it
		end,
	},
}
