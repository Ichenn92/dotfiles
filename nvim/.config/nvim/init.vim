set nocompatible              " be iMproved, required
filetype off                  " required

call plug#begin()
" Briefly highlight which text was yanked.
Plug 'machakann/vim-highlightedyank'
" Show git file changes in the gutter.
Plug 'mhinz/vim-signify'
" Plug 'jiangmiao/auto-pairs' " Create double surround
Plug 'arcticicestudio/nord-vim' " ColorScheme
Plug 'vim-scripts/AutoComplPop' " autocomplet popup
Plug 'Yggdroot/indentLine'
Plug 'vim-airline/vim-airline' " add bar info at the bottom
Plug 'vim-airline/vim-airline-themes' " theme
Plug 'tpope/vim-fugitive' " git plugin for vim
Plug 'tpope/vim-surround' " allow changing surrounding content like '' or parenthesis
Plug 'git://git.wincent.com/command-t.git' "fuzzfile
Plug 'rstacruz/sparkup', {'rtp': 'vim/'} " parser for html
Plug 'scrooloose/nerdtree' " navigation file
Plug 'ryanoasis/vim-devicons' " vim icon for nerdtree
" Install Denite 
"if has('nvim')
"  Plug 'Shougo/denite.nvim', { 'do': ':UpdateRemotePlugins' }
"else
"  Plug 'Shougo/denite.nvim'
"  Plug 'roxma/nvim-yarp'
"  Plug 'roxma/vim-hug-neovim-rpc'
"endif
call plug#end()

filetype plugin indent on    " required
" Put your non-Plugin stuff after this line
Plug 'bhilburn/powerlevel9k'
Plug 'cakebaker/scss-syntax.vim'
Plug 'chr4/nginx.vim'
Plug 'chrisbra/csv.vim'
Plug 'ekalinin/dockerfile.vim'
Plug 'elixir-editors/vim-elixir'
Plug 'Glench/Vim-Jinja2-Syntax'
Plug 'godlygeek/tabular' | Plug 'tpope/vim-markdown'
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app & yarn install' }
Plug 'jvirtanen/vim-hcl'
Plug 'lifepillar/pgsql.vim'
Plug 'othree/html5.vim'
Plug 'pangloss/vim-javascript'
Plug 'PotatoesMaster/i3-vim-syntax'
Plug 'stephpy/vim-yaml'
"Plug 'tmux-plugins/vim-tmux'
Plug 'tpope/vim-git'
Plug 'tpope/vim-liquid'
Plug 'tpope/vim-rails'
Plug 'vim-python/python-syntax'
Plug 'vim-ruby/vim-ruby'
Plug 'wgwoods/vim-systemd-syntax'

set shell=/bin/bash
set runtimepath^=~/.vim/bundle/ctrlp.vim
"let g:ctrlp_working_path_mode = 0
packloadall

" ======================================================================================== "
" === Airline Settings === "
" ======================================================================================== "
let g:airline_theme='bubblegum'
let g:airline#extensions#tabline#enabled = 1
let g:airline_powerline_fonts = 1

" ======================================================================================== "
" === ColorScheme === "
" ======================================================================================== "
colorscheme nord

" -----------------------------------------------------------------------------
" === Basic Settings ===
" === Research any of these by running :help <setting> ===
" -----------------------------------------------------------------------------
let mapleader=" "
let maplocalleader=" "

"set hidden
"set cryptmethod=blowfish2

:augroup numbertoggle
:  autocmd!
:  autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
:  autocmd BufLeave,FocusLost,InsertEnter   * set norelativenumber
:augroup END
syntax on
set backspace=indent,eol,start
set backupdir=/tmp//,.
set number relativenumber
set autoindent
set autoread
set clipboard+=unnamedplus
set colorcolumn=120
set complete+=kspell
set completeopt=menuone,longest
set cursorline
set directory=/tmp//,.
set encoding=utf-8
set expandtab smarttab
set formatoptions=tcqrn1
set hlsearch
set ignorecase
set incsearch
set laststatus=2
set matchpairs+=<:> " Use % to jump between pairs
set mmp=5000
set modelines=2
set mouse=a
set nocompatible
set noerrorbells visualbell t_vb=
set noshiftround
set nospell
set nostartofline
set regexpengine=1
set ruler
set scrolloff=5
set shiftwidth=2
set showcmd
set showmatch
set shortmess+=c
set showmode
set smartcase
set softtabstop=2
set spelllang=en_us
set splitbelow
set splitright
set ttimeout
set timeoutlen=1000
set ttimeoutlen=0
set undodir=/tmp
set undofile
set virtualedit=block
set whichwrap=b,s,<,>
set wildmenu
set wildmode=full
set wrap

" ======================================================================================== "
" === Split Settings === "
" ======================================================================================== "
" Navigate around splits with a single key combo.
nnoremap <C-l> <C-w><C-l>
nnoremap <C-h> <C-w><C-h>
nnoremap <C-k> <C-w><C-k>
nnoremap <C-j> <C-w><C-j>

" Prevent x from overriding what's in the clipboard.
noremap x "_x
noremap X "_x

" Auto-resize splits when Vim gets resized.
autocmd VimResized * wincmd =

" ======================================================================================== "
" === Nerdtree Settings === "
" ======================================================================================== "
augroup nerdtree_open
    autocmd!
    autocmd VimEnter * NERDTree | wincmd p
augroup END
set mouse=a
map <C-n> :NERDTreeToggle<CR>
let NERDTreeShowHidden = 0
let g:NERDTreeIgnore = ['^node_modules$']
let g:NERDTreeNodeDelimiter = "\u00a0"
let g:NERDTreeDirArrowExpandable = '▸'
let g:NERDTreeDirArrowCollapsible = '▾'
let NERDTreeQuitOnOpen = 0
let NERDTreeAutoDeleteBuffer = 1
let NERDTreeMinimalUI = 1
let NERDTreeDirArrows = 1
set ttyfast
set lazyredraw

" ======================================================================================== "
" === CTRLP === "
" ======================================================================================== "
let g:ctrlp_max_height = 50
let g:ctrlp_custom_ignore = 'node_modules\|^\.DS_Store\|^\.git'
let g:ctrlp_working_path_mode = 'ar' " CtrlP scans through .git project
let g:ctrlp_max_files = 0 " Set no max file limit
let g:ctrlp_show_hidden = 1

" ======================================================================================== "
" === Denite shorcuts === "
" ======================================================================================== "
"   ;         - Browser currently open buffers
"   <leader>t - Browse list of files in current directory
"   <leader>g - Search current directory for occurences of given term and
"   close window if no results
"   <leader>j - Search current directory for occurences of word under cursor
"nmap ; :Denite buffer -split=floating -winrow=1<CR>
"nmap <leader>t :Denite file/rec -split=floating -winrow=1<CR>
"nnoremap <leader>g :<C-u>Denite grep:. -no-empty -mode=normal<CR>
"nnoremap <leader>j :<C-u>DeniteCursorWord grep:. -mode=normal<CR>
" Custom options for Denite
"   auto_resize             - Auto resize the Denite window height automatically.
"   prompt                  - Customize denite prompt
"   direction               - Specify Denite window direction as directly below current pane
"   winminheight            - Specify min height for Denite window
"   highlight_mode_insert   - Specify h1-CursorLine in insert mode
"   prompt_highlight        - Specify color of prompt
"   highlight_matched_char  - Matched characters highlight
"   highlight_matched_range - matched range highlight
"let s:denite_options = {'default' : {
"\ 'auto_resize': 1,
"\ 'prompt': 'λ:',
"\ 'direction': 'rightbelow',
"\ 'winminheight': '10',
"\ 'highlight_mode_insert': 'Visual',
"\ 'highlight_mode_normal': 'Visual',
"\ 'prompt_highlight': 'Function',
"\ 'highlight_matched_char': 'Function',
"\ 'highlight_matched_range': 'Normal'
"\ }}
