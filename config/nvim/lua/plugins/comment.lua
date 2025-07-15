return {
	{
		"numToStr/Comment.nvim",
		keys = { "gcc", "gc" }, -- only load when you press the comment mapping
		config = function()
			require("Comment").setup()
		end,
		opts = {
			-- add any options here
		},
	},
	{
		"folke/todo-comments.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = {
			-- your configuration comes here
			-- or leave it empty to use the default settings
			-- refer to the configuration section below
		},
	},
}
