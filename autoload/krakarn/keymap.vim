" Keymap

function! GetFileFinderSystemString(path)
  return 'FileFinder-exe ' . a:path . ' -r -e ".*,' . &wildignore . '"'
endfunction

function! FileFinder(path)
  let l:system = GetFileFinderSystemString(a:path)

  return split(system(l:system))
endfunction

function! OpenFuzzyFindWithFileFinder(path)

  let l:filefinder = FileFinder(a:path)

  call fzf#run({
  \ 'source': l:filefinder,
  \ 'sink': 'e'
 \})

endfunction

function! CallFZF(query, path)
  let l:filefinder = join(FileFinder(a:path), "\n")
  return split(system("echo " . l:filefinder . " | fzf --filter=\"" . a:query . "\" --sync"))
endfunction

function! FZFComplete(ArgLead, CmdLine, CursorPos)
  return CallFZF(a:ArgLead, '.')
endfunction

function! OpenFZFBuffer()
  bad FZF
  wincmd v
  wincmd l
  buffer FZF
endfunction

command! -nargs=1 -complete=customlist,FZFComplete FileFinder call OpenFuzzyFindWithFileFinder('<args>')

function! krakarn#keymap#init()

  nnoremap <C-LeftMouse> <LeftMouse>:tselect <C-R><C-W><CR>
  nnoremap <C-P> :call OpenFuzzyFindWithFileFinder('.')<CR>
  nnoremap ð :FileFinder 

endfunction
