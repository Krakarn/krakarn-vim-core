" Basic

function! krakarn#basic#init()
  filetype plugin indent on
  syntax on
  
  set relativenumber
  set number
  set list
  set listchars=tab:>-
  set ssl

  colorscheme desert

  " Encoding
  
  set encoding=utf-8
  set fileencoding=utf-8

  au GUIEnter * :call OnGUIEnter()
endfunction

" GUI-specific

function! OnGUIEnter()
  simalt ~x "Maximize window on windows
  set guifont=Lucida_Console:h11
endf
