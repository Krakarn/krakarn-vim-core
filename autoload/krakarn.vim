function! krakarn#init()
  " Libs
  call krakarn#pure#init()
  call krakarn#observable#init()
  call krakarn#buffer#init()

  " Config
  call krakarn#basic#init()
  call krakarn#indentation#init()
  call krakarn#keymap#init()
  call krakarn#linters#init()
  call krakarn#autocomplete#init()
  call krakarn#configs#init()
endfunction
