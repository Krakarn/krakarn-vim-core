" # Plugins

" # Filesystem

Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
Plug 'junegunn/fzf', {'dir': '~/.fzf', 'do': 'install --all'}
Plug 'junegunn/fzf.vim'

" ## Editing

" ### Statusline

Plug 'vim-airline/vim-airline'

" ### Languages

 " Syntax & visual help
Plug 'elzr/vim-json', {'dir': expand(g:vimpath . '/plugged/elzr.vim-json')}
 " JSON#parse and JSON#stringify
Plug 'vimlab/vim-json', {'dir': expand(g:vimpath . '/plugged/vimlab.vim-json')}
Plug 'PProvost/vim-ps1'
Plug 'leafgarland/typescript-vim'
Plug 'vim-scripts/rest.vim'

" ### Linters

Plug 'vim-syntastic/syntastic'
Plug 'Shutnik/jshint2.vim'
Plug 'gcorne/vim-sass-lint'
Plug 'Quramy/tsuquyomi'

" ### Autocompletion

Plug 'ervandew/supertab'

" ## Source version control

Plug 'jreybert/vimagit'

" ### Google

Plug 'szw/vim-g'
