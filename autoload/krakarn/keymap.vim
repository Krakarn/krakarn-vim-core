" Keymap

function! OpenFuzzyFindWithVimFind()
  call fzf#run({
  \ 'source': split(expand('**')),
  \ 'sink': 'e'
 \})
endfunction

" @todo: change system('grep') into some system call that returns all files
" recursively in the current working path
function! FZF()
  call fzf#run({
  \ 'source': split(system('grep')),
  \ 'sink': 'e'
 \})
endfunction

function! krakarn#keymap#init()

  nnoremap <C-LeftMouse> <LeftMouse>:tselect <C-R><C-W><CR>
  nnoremap <C-P> :call OpenFuzzyFindWithVimFind()<CR>

endfunction
