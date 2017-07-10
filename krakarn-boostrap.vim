" Bootstrap using vim-plug

function! LoadPlugins()
  call plug#begin()
  Plug 'krakarn/krakarn-vim-core'
  call plug#end()
endfunction

function! FirstTime()
  call LoadPlugins()

  PlugInstall --sync | source $MYVIMRC
endfunction

" Determine path

if has('win32')
  let s:vimpath = $HOMEDRIVE . $HOMEPATH . '/vimfiles'
else
  let s:vimpath = '~/.vim'
endif

let s:plugpath = s:vimpath . '/autoload/plug.vim'

if has('win32')
  let s:plugpath = substitute(s:plugpath, '/', '\\', 'g')
endif

" Check if vim-plug is not installed and install it if that's the case

let s:firsttime = empty(glob(s:plugpath))

if s:firsttime
  exec '!curl -fLo ' . s:plugpath . ' --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * call FirstTime()
else
  call LoadPlugins()
endif
