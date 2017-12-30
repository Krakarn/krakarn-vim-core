function! s:findStart(line)
  return len(a:line)
endfunction

function! s:getCompletions(line, cursor)
  if (has('win32'))
    let l:scriptPath = expand(fnamemodify(resolve(expand('<sfile>:p')), ':h:h:h') . '/powershell-autocomplete.ps1')

    return execute(system("PowerShell -NoProfile -NonInteractive -File " . l:scriptPath))
  else
    throw "Autocomplete not supported on this OS."
  endif
endfunction

function! krakarn#autocomplete#powershell#omnifunc(findstart, base)
  if a:findstart
    let line = strpart(getline("."), 0, (col(".") - 1))

    return s:findStart(line)
  else
    return s:getCompletions(a:base, col("."))
  endif
endfunction
