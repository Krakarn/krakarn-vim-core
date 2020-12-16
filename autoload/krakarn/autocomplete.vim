function! krakarn#autocomplete#init()
endfunction

function! krakarn#autocomplete#load()
  let g:SuperTabDefaultCompletionType = "<c-x><c-o>"
  let g:necoghc_enable_detailed_browse = 1
  let g:ale_completion_enabled = 1
  set omnifunc=ale#completion#OmniFunc
endfunction
