function! krakarn#keymap#load()
  call krakarn#utils#fzf#load()
  call krakarn#utils#git#load()
  call krakarn#contextMenu#load()
  call krakarn#utils#textObjects#load()
endfunction

function! krakarn#keymap#init()
  call krakarn#contextMenu#init()

  nnoremap <C-LeftMouse> <LeftMouse>:tselect <C-R><C-W><CR>
  nnoremap <C-P> :call OpenFuzzyFindWithFileFinder('.')<CR>
  nnoremap ð :FileFinder 
  nnoremap <C-S-B> :call OpenFuzzyFindWithBuffer()<CR>
  nnoremap <C-S-C> :call FZFRun(GetMergeConflicts(), 'e')<CR>
  nnoremap <C-]> :ALEGoToDefinitionInTab<CR>
  nnoremap <F12> :ALEFindReferences<CR>
  nnoremap  :execute 'Ag ' . expand('<cword>')<CR>
  nnoremap ö :execute getline('.')<CR>
  nnoremap <S-F1> :execute 'help ' . expand('<cword>')<CR>
  nnoremap <F2> :call OpenContextMenu()<CR>

  command! -nargs=1 -complete=customlist,FZFComplete FileFinder call OpenFuzzyFindWithFileFinder('<args>')

  noremenu PopUp.Find\ References :ALEFindReferences<CR>

  let l:textMaps = GetTextMaps()
  call MapTextObjects(l:textMaps)
endfunction
