function! krakarn#utils#buffer#load()
endfunction

function! CreateScratchBuffer(...)
  new
  setlocal buftype=nofile bufhidden=hide noswapfile

  if a:0 > 0
    execute "setlocal filetype=".a:1
  endif
endfunction

function! CreateBuffer(lines)
  call CreateScratchBuffer()
  call append(1, a:lines)
  1d
endfunction

function! GetCurrentBufferLines(...)
  let l:rx = '[^\s]'

  if a:0 > 0
    let l:rx = a:1
  endif

  let l:lines = []
  execute "g/".l:rx."/call add(l:lines, line('.') . ':' . getline('.'))"

  return l:lines
endfunction

function! CreateBufferFromCurrent()
  let l:ft = &ft
  let l:lines = GetCurrentBufferLines()
  call CreateBuffer(l:lines)
  execute "setlocal filetype=".l:ft
endfunction
