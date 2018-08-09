function! krakarn#contextMenu#load()
  call krakarn#utils#menu#load()
endfunction

function! OpenContextMenu()
  call OpenMenu(s:contextMenu)
endfunction

function! krakarn#contextMenu#init()
  let s:actionSearch = {-> execute('Ag ' . expand('<cword>')) }

  let s:contextMenu = CreateMenu('Context Menu', [
        \   CreateMenuItem('Search', s:actionSearch)
        \ ])
endfunction
