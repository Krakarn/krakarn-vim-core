" Keymap

function! OpenFuzzyFindWithFileFinder()

  let l:system = 'FileFinder-exe -r -e ".*,' . &wildignore . '"'

  call fzf#run({
  \ 'source': split(system(l:system)),
  \ 'sink': 'e'
 \})

endfunction

function! krakarn#keymap#init()

  nnoremap <C-LeftMouse> <LeftMouse>:tselect <C-R><C-W><CR>
  nnoremap <C-P> :call OpenFuzzyFindWithFileFinder()<CR>

endfunction
