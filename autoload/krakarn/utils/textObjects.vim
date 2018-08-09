function! krakarn#utils#textObjects#load()
endfunction

function! GetTextMaps()
  return [
        \['ie', 'ggVG'],
        \['il', '^vg_'],
        \['iz', '[zV]z'],
        \['iL', 'V'],
        \['ii', ':<C-u>call <SID>SelectIndentationParagraph(0)'],
        \['ai', ':<C-u>call <SID>SelectIndentationParagraph(1)'],
        \]
endfunction

function! MapTextObjects(textMaps)
  for [s:k, s:m] in a:textMaps
    let l:command = s:m

    if s:m[0] !=# ':'
      let l:command = ':normal! ' . s:m
    endif

    let l:command .= '<CR>'

    execute 'onoremap <silent> ' . s:k . ' ' . l:command
    execute 'vnoremap <silent> ' . s:k . ' ' . l:command
  endfor
endfunction

function! s:GetIndentation(lineString)
  return match(a:lineString, '[^ \t]')
endfunction

function! s:IsWhiteSpaceOnly(lineString)
  return match(a:lineString, '^[ \t]*$') == 0
endfunction

function! s:SelectIndentationParagraph(includeOuter)
  echom 'SelectIndentationParagraph'

  let l:currentLine = getline('.')
  let l:indentation = s:GetIndentation(l:currentLine)

  if l:indentation <= 0
    normal! ggVG
    return
  endif

  let l:searchIndentation = l:indentation - 1

  call searchpos('^\s\{0,'.l:searchIndentation.'\}[^ \t]', 'b')

  if !a:includeOuter
    normal! j
  endif

  normal! V

  call searchpos('^\s\{0,'.l:searchIndentation.'\}[^ \t]')

  if !a:includeOuter
    normal! k
  endif
endfunction
