return {
	"mhartington/formatter.nvim",
	config = function()
		local settings = {
			lua = {
				require("formatter.filetypes.lua").stylua,
			},
			-- markdown = {
			-- 	require("formatter.filetypes.markdown").prettier,
			-- },
			-- javascript = {
			--   require("formatter.filetypes.javascript").prettier,
			-- },
			typescript = {
				require("formatter.filetypes.typescript").prettier,
			},
			dart = {
				require("formatter.filetypes.dart").dartformat,
			},
			json = {
				require("formatter.filetypes.json").prettier,
			},
			yaml = {
				require("formatter.filetypes.yaml").prettier,
			},
			sh = {
				require("formatter.filetypes.sh").shfmt,
			},
			["*"] = {
				require("formatter.filetypes.any").remove_trailing_whitespace,
			},
		}

		require("formatter").setup({
			logging = true,
			log_level = vim.log.levels.WARN,
			filetype = settings,
		})

		vim.keymap.set("n", "<leader>f", function()
			if settings[vim.bo.filetype] ~= nil then
				vim.cmd([[Format]])
			else
				vim.lsp.buf.format({
					filter = function(client)
						local clients = vim.lsp.get_active_clients()
						local formattingDartWithDcmls = false

						-- Check if dcmls is attached
						for _, c in ipairs(clients) do
							if c.name == "dcmls" then
								formattingDartWithDcmls = true
								break -- No need to continue checking clients if dcmls is found
							end
						end

						-- Return false for dart if dcmls is attached
						if formattingDartWithDcmls and client.name == "dartls" then
							return false
						end

						return true
					end,
				})
			end
		end)
	end,
}
