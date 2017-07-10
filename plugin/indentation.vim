" Indentation

function! SetIndentWidth(x)
  execute 'setl tabstop='.a:x
  execute 'setl shiftwidth='.a:x
endf

function! SetFileIndent(ft, x)
  augroup 'IndentGroup'.a:ft
    execute "au BufNewFile,BufReadPost ".a:ft." call SetIndentWidth(".a:x.")"
  augroup END
endf

call SetFileIndent('*', 2)
call SetFileIndent('*.php', 4)

set expandtab
