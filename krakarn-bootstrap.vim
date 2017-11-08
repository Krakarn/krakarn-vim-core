" Bootstrap using vim-plug

" Determine paths

let g:vimpath = expand('<sfile>:p:h')

let s:plugpath = g:vimpath . '/autoload/plug.vim'
let s:depspath = g:vimpath . '/plugged/krakarn-vim-core/plugins.vim'

if has('win32')
  let s:plugpath = substitute(s:plugpath, '/', '\\', 'g')
  let s:depspath = substitute(s:depspath, '/', '\\', 'g')
endif

let s:firsttime = empty(glob(s:plugpath))
let s:installed = !empty(glob(s:depspath))

function! LoadDependencies()
  exec 'source ' . s:depspath
endfunction

function! LoadPlugins(doInit)
  call plug#begin()
  Plug 'krakarn/krakarn-vim-core'

  if s:installed
    call LoadDependencies()
  endif

  call plug#end()

  if a:doInit
    call krakarn#init()
    runtime plugin/*.vim
  endif
endfunction

function! FirstTime(doInit)
  call LoadPlugins(0)
  PlugInstall --sync

  if s:firsttime
    let s:firsttime = 0
    let s:installed = 1
    call FirstTime(0)
  endif

  if a:doInit
    call krakarn#init()
    runtime plugin/*.vim
  endif
endfunction

" Check if vim-plug is not installed and install it if that's the case

if s:firsttime
  silent! exec '!curl -fLo ' . s:plugpath . ' --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * call FirstTime(1)
elseif !s:installed
  autocmd VimEnter * call FirstTime(1)
else
  try
    call LoadPlugins(1)
  catch
    echohl ErrorMsg
    echo v:exception
    echohl None
  endtry
endif
