function! krakarn#load()
  call krakarn#basic#load()
  call krakarn#indentation#load()
  call krakarn#keymap#load()
  call krakarn#linters#load()
  call krakarn#autocomplete#load()
  call krakarn#configs#load()
endfunction

function! krakarn#init()
  call krakarn#basic#init()
  call krakarn#indentation#init()
  call krakarn#keymap#init()
  call krakarn#linters#init()
  call krakarn#autocomplete#init()
  call krakarn#configs#init()
endfunction
