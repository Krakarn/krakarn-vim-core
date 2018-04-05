function! krakarn#linters#load()
endfunction

function! krakarn#linters#init()
  let g:syntastic_sass_checkers=["sasslint"]
  let g:syntastic_scss_checkers=["sasslint"]
  let g:syntastic_typescript_checkers=["tsuquyomi", "tslint"]
  let g:tsuquyomi_disable_quickfix = 1
endfunction
