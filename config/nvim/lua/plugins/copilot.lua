-- return {
--   'github/copilot.vim',
-- }
return {
	"zbirenbaum/copilot.lua",
	config = function()
		require("copilot").setup({
			suggestion = { enabled = true },
			panel = { enabled = true },
			filetypes = { markdown = true, lua = true, javascript = true }, -- customize as needed
			-- Set to `false` if you prefer disabling telemetry
			telemetry = { enabled = false },
		})
	end,
}
