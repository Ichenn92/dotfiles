vim.g.mapleader = " "
vim.g.background = "light"

-- core
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true
vim.opt.updatetime = 50
vim.opt.hlsearch = true

-- line numbers
vim.opt.relativenumber = false
vim.opt.number = true
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
vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.smartcase = true

-- cursor line
vim.opt.cursorline = false
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

-- PERFORMANCE TWEAKS FOR WARP
vim.opt.lazyredraw = true -- Don't redraw during macro/ex
vim.opt.ttyfast = true -- Assume fast terminal
vim.opt.redrawtime = 10000 -- Increase max redraw time

-- Dynamically toggle line numbers:
-- Shows absolute + relative numbers in normal mode when focused.
-- Hides relative numbers (only absolute) in insert mode or on focus loss.
vim.cmd([[
  augroup numbertoggle
    autocmd!
    autocmd BufEnter,FocusGained,InsertLeave * set number relativenumber
    autocmd BufLeave,FocusLost,InsertEnter   * set number norelativenumber
  augroup END
]])
