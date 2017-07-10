" Plugins

Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
Plug 'junegunn/fzf', {'dir': '~/.fzf', 'do': 'install --all'}
Plug 'junegunn/fzf.vim'

Plug 'vim-airline/vim-airline'

Plug 'elzr/vim-json'
Plug 'PProvost/vim-ps1'
Plug 'leafgarland/typescript-vim'

Plug 'vim-syntastic/syntastic'
Plug 'Shutnik/jshint2.vim'
Plug 'gcorne/vim-sass-lint'
Plug 'Quramy/tsuquyomi'

Plug 'tpope/vim-fugitive'

" Syntastic

let g:syntastic_sass_checkers=["sasslint"]
let g:syntastic_scss_checkers=["sasslint"]
let g:syntastic_typescript_checkers=["tsuquyomi", "tslint"]
let g:tsuquyomi_disable_quickfix = 1

" Basic

filetype plugin indent on
syntax on
set relativenumber
set number
set list
set listchars=tab:>-
colorscheme desert

" Indentation

function! SetIndentWidth(x)
  execute 'setl tabstop='.a:x
  execute 'setl shiftwidth='.a:x
endf

function! SetFileIndent(ft, x)
  augroup 'IndentGroup'.a:ft
    execute "au BufNewFile,BufReadPost ".a:ft." call SetIndentWidth(".a:x.")"
  augroup END
endf

call SetFileIndent('*', 2)
call SetFileIndent('*.php', 4)

set expandtab

" Expand filenames to forward slash

set ssl

" GUI-specific

function! OnGUIEnter()
  simalt ~x "Maximize window on windows
  set guifont=Lucida_Console:h11
endf
au GUIEnter * :call OnGUIEnter()

" Encoding

set encoding=utf-8
set fileencoding=utf-8

" Keymaps

nnoremap <C-LeftMouse> <LeftMouse>:tselect <C-R><C-W><CR>
nnoremap <C-P> :GFiles<CR>
