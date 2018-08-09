" # Plugins

" ## Process

Plug 'Shougo/vimproc'

" ## Filesystem

Plug 'scrooloose/nerdtree', {'do': 'NERDTreeToggle'}
Plug 'junegunn/fzf', {'dir': '~/.fzf', 'do': 'install --all'}
Plug 'junegunn/fzf.vim'

" ## Testing

Plug 'junegunn/vader.vim'

" ## Editing

" ### Statusline

Plug 'vim-airline/vim-airline'

" ### Languages

Plug 'eagletmt/ghcmod-vim'

 " Syntax & visual help
Plug 'elzr/vim-json', {'dir': expand(g:vimpath . '/plugged/elzr.vim-json')}
 " JSON#parse and JSON#stringify
Plug 'vimlab/vim-json', {'dir': expand(g:vimpath . '/plugged/vimlab.vim-json')}
Plug 'PProvost/vim-ps1'
Plug 'leafgarland/typescript-vim'
Plug 'vim-scripts/rest.vim'
Plug 'purescript-contrib/purescript-vim'
Plug 'wilsaj/chuck.vim'
Plug 'davidbeckingsale/writegood.vim'

" ### Linters

Plug 'w0rp/ale'
" Plug 'vim-syntastic/syntastic'
Plug 'Shutnik/jshint2.vim'
"Plug 'Quramy/tsuquyomi'
Plug 'FrigoEU/psc-ide-vim'

" ### Autocompletion

Plug 'ervandew/supertab'
Plug 'eagletmt/neco-ghc'

" ## Source version control

Plug 'jreybert/vimagit'

" ### Google

Plug 'szw/vim-g'
