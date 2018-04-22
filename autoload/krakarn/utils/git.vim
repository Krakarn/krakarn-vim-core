function! krakarn#utils#git#load()
  call krakarn#utils#pure#load()
endfunction

function! GetGitRoot()
  return substitute(system('git rev-parse --show-toplevel'), '\n', '', '')
endfunction

function! GetMergeConflicts()
  let conflicts = split(system('git diff --name-only --diff-filter=U'), '\n')
  let gitRoot = GetGitRoot() . '/'

  return Eval(g:Map, {conflict -> gitRoot . conflict}, conflicts)
endfunction
