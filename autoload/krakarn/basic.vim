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
  let g:NERDTreeRespectWildIgnore = 1

  " Color

  colorscheme desert

  " Encoding
  
  set encoding=utf-8

  " Supertab

  au GUIEnter * :call OnGUIEnter()

  autocmd VimEnter * nested call OnVimEnter()
endfunction

" GUI-specific

function! OnGUIEnter()
  simalt ~x "Maximize window on windows
  set guifont=Lucida_Console:h11
endf

function! OnVimEnter()
  if empty(execute('args'))
    let l:readme = glob('README*')

    if !empty(l:readme)
      exe 'e ' . l:readme
    endif
  endif
endfunction
