function! krakarn#linters#load()
endfunction

function! krakarn#linters#init()
  let g:syntastic_sass_checkers=["sasslint"]
  let g:syntastic_scss_checkers=["sasslint"]
  let g:syntastic_typescript_checkers=["tsuquyomi", "tslint"]
  let g:tsuquyomi_disable_quickfix = 1
  let g:tsuquyomi_single_quote_import = 1
  " let g:airline#extensions#ale#enabled = 1
  " let g:ale_linters = {
  "       \  'haskell': ['ghc-mod', 'hlint'],
  "       \}
  " let g:ale_lint_delay = 500
  " let g:ale_completion_enabled = 1
  " let g:ale_lint_on_insert_leave = 1
  " let g:ale_lint_on_text_changed = 'normal'
  " let g:ale_sign_column_always = 1
  let g:coverage_json_report_path = 'coverage/coverage-final.json'
endfunction
