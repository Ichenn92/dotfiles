return {
	"kdheepak/lazygit.nvim",
	cmd = {
		"LazyGit",
		"LazyGitConfig",
		"LazyGitCurrentFile",
		"LazyGitFilter",
		"LazyGitFilterCurrentFile",
	},
	config = function()
		-- Set up environment variables for LazyGit integration
		vim.env.GIT_EDITOR = 'nvim'
		vim.env.EDITOR = 'nvim'
		
		-- Configure LazyGit to work better with Neovim
		vim.g.lazygit_floating_window_winblend = 0 -- transparency of floating window
		vim.g.lazygit_floating_window_scaling_factor = 0.9 -- scaling factor for floating window
		vim.g.lazygit_floating_window_corner_chars = {'╭', '╮', '╰', '╯'} -- customize lazygit popup window corner characters
		vim.g.lazygit_floating_window_use_plenary = 0 -- use plenary.nvim to manage floating window if available
		vim.g.lazygit_use_neovim_remote = 1 -- use neovim remote for opening files from lazygit
		vim.g.lazygit_use_custom_config_file_path = 0 -- config file path is used if provided
	end,
	-- optional for floating window border decoration
	dependencies = {
		"nvim-lua/plenary.nvim",
	},
	-- setting the keybinding for LazyGit with 'keys' is recommended in
	-- order to load the plugin when the command is run for the first time
	keys = {
		{ "<leader>lg", "<cmd>LazyGit<cr>", desc = "LazyGit" },
		{ "<leader>lf", "<cmd>LazyGitCurrentFile<cr>", desc = "LazyGit Current File" },
	},
}
