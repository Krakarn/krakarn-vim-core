function! krakarn#basic#load()
endfunction

function! OnGUIEnter()
  simalt ~x "Maximize window on windows
  set guifont=Lucida_Console:h11
  set guioptions-=m " Remove gui main menu
  set guioptions-=T " Remove gui toolbar
  set winaltkeys=no " Disable windows takeover of alt key
endf

function! OnVimEnter()
  if empty(execute('args'))
    let l:readme = glob('README*')

    if !empty(l:readme)
      exe 'e ' . l:readme
    endif
  endif
endfunction

function! SearchAndReplace(pattern, replacement)
  execute '!ag -0 -l ' . a:pattern . ' | xargs -0 sed -ri.bak -e "s/'.a:pattern.'/'.a:replacement.'/g"'
endfunction

function! krakarn#basic#init()
  filetype plugin indent on

  " Display 

  syntax on
  set relativenumber
  set number
  set list
  set listchars=tab:>-
  set colorcolumn=80

  " Wild stuff

  set wildmenu
  set wildmode=list:full

  " Finding files

  set shellslash
  set path+=**
  let g:NERDTreeRespectWildIgnore = 1

  " Color

  colorscheme desert

  " Encoding
  
  set encoding=utf-8

  " GUI

  au GUIEnter * :call OnGUIEnter()

  autocmd VimEnter * nested call OnVimEnter()
endfunction
