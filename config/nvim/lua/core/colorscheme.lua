local status, _ = pcall(vim.cmd, "colorscheme catppuccin-frappe")
if not status then
  print("Colorscheme not found!")
  return
end

-- vim.api.nvim_set_hl(0, "Normal", {bg = "none"})
-- vim.api.nvim_set_hl(0, "NormalFloat", {bg = "none"})
-- vim.api.nvim_set_hl(0, "NormalNC", {bg = "none"})

-- theme
local themes = { "catppuccin-frappe", "catppuccin-latte" }
local current_theme_index = 1
_G.switch_theme = function()
  current_theme_index = 3 - current_theme_index -- Toggle between 1 and 2
  vim.cmd("colorscheme " .. themes[current_theme_index])
end
vim.api.nvim_set_keymap('n', '<c-s>t', ':lua switch_theme()<CR>', { noremap = true, silent = true })

