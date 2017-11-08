function! krakarn#init()
  call krakarn#basic#init()
  call krakarn#indentation#init()
  call krakarn#keymap#init()
  call krakarn#linters#init()
  call krakarn#autocomplete#init()
  call krakarn#configs#init()
endfunction
