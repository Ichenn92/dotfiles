vim.keymap.set("n", "<leader>yf", function()
	vim.fn.setreg("+", vim.fn.expand("%:p"))
	vim.notify("📋 File path copied to clipboard!")
end, { desc = "Copy file path with filename" })
