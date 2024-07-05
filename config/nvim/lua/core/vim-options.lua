vim.g.mapleader = " "
vim.g.background = "light"

-- theme
local themes = { "onedark_vivid", "github_light_high_contrast" }
local current_theme_index = 1
_G.switch_theme = function()
  current_theme_index = 3 - current_theme_index -- Toggle between 1 and 2
  vim.cmd("colorscheme " .. themes[current_theme_index])
end
vim.api.nvim_set_keymap('n', '<c-s>t', ':lua switch_theme()<CR>', { noremap = true, silent = true })


-- core
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true
vim.opt.updatetime = 50

-- line numbers
vim.opt.relativenumber = true
vim.opt.number = true

-- Navigate vim panes better
-- vim.keymap.set('n', '<c-k>', ':wincmd k<CR>')
-- vim.keymap.set('n', '<c-j>', ':wincmd j<CR>')
-- vim.keymap.set('n', '<c-h>', ':wincmd h<CR>')
-- vim.keymap.set('n', '<c-l>', ':wincmd l<CR>')
vim.keymap.set('n', '<leader>w', ':wincmd w<CR>') -- focus floating window

vim.keymap.set('n', '<leader>h', ':nohlsearch<CR>')
vim.wo.number = true

-- Window
vim.opt.scrolloff = 8

-- tabs && indentation
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.autoindent = true
vim.opt.smartindent = false

-- line wrapping
vim.opt.wrap = false

-- search settings
vim.opt.ignorecase = true
vim.opt.hlsearch = false
vim.opt.incsearch = true
vim.smartcase = true

-- cursor line
vim.opt.cursorline = true
-- vim.opt.cursorcolumn = true
vim.opt.colorcolumn = "80"

-- appearance
vim.opt.termguicolors = true
vim.opt.background = "dark"
vim.opt.signcolumn = "yes"

-- backspace
vim.opt.backspace = "indent,eol,start"

-- clipboard
vim.opt.clipboard:append("unnamedplus")

-- split window
vim.opt.splitright = true
vim.opt.splitbelow = true

vim.opt.iskeyword:append("-")
