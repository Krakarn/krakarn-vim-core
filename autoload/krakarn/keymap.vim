" Keymap

function! OpenFuzzyFindWithVimFind()
  call fzf#run({
  \ 'source': split(expand('**')),
  \ 'sink': 'e'
 \})
endfunction

function! krakarn#keymap#init()

  nnoremap <C-LeftMouse> <LeftMouse>:tselect <C-R><C-W><CR>
  nnoremap <C-P> :call OpenFuzzyFindWithVimFind()<CR>

endfunction
