" Basic

function! krakarn#basic#init()
  filetype plugin indent on

  " Display 

  syntax on
  set relativenumber
  set number
  set list
  set listchars=tab:>-

  " Wild stuff

  set wildmenu
  set wildmode=list:full

  " Finding files

  set ssl
  set path+=**

  " Color

  colorscheme desert

  " Encoding
  
  set encoding=utf-8
  set fileencoding=utf-8

  " Setup GUI initialization

  au GUIEnter * :call OnGUIEnter()
endfunction

" GUI-specific

function! OnGUIEnter()
  simalt ~x "Maximize window on windows
  set guifont=Lucida_Console:h11
endf
