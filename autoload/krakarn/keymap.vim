function! krakarn#keymap#load()
  call krakarn#utils#fzf#load()
  call krakarn#utils#git#load()
endfunction

function! krakarn#keymap#init()
  nnoremap <C-LeftMouse> <LeftMouse>:tselect <C-R><C-W><CR>
  nnoremap <C-P> :call OpenFuzzyFindWithFileFinder('.')<CR>
  nnoremap ð :FileFinder 
  nnoremap <C-S-B> :call OpenFuzzyFindWithBuffer()<CR>
  nnoremap <C-S-C> :call FZFRun(GetMergeConflicts(), 'e')<CR>

  command! -nargs=1 -complete=customlist,FZFComplete FileFinder call OpenFuzzyFindWithFileFinder('<args>')
endfunction
