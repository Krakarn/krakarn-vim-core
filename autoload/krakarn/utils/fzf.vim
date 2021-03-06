function! krakarn#utils#fzf#load()
  call krakarn#utils#buffer#load()
endfunction

function! GetFileFinderSystemString(path)
  return 'FileFinder-exe ' . a:path . ' -r -e ".*,' . &wildignore . '"'
endfunction

function! FileFinder(path)
  let l:system = GetFileFinderSystemString(a:path)

  return split(system(l:system))
endfunction

function! FZFRun(list, callback)
  call fzf#run({ 'source': a:list, 'sink': a:callback })
endfunction

function! OpenFuzzyFindWithFileFinder(path)
  call FZFRun(FileFinder(a:path), 'e')
endfunction

function! HandleFuzzyFindWithBufferResult(result)
  let l:line = split(a:result, ':')[0]
  :execute l:line
endfunction

function! OpenFuzzyFindWithBuffer()
  call FZFRun(GetCurrentBufferLines(), function('HandleFuzzyFindWithBufferResult'))
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
