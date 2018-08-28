function! krakarn#utils#textObjects#load()
endfunction

function! GetTextMaps()
  return [
        \['ie', 'ggVG'],
        \['il', '^vg_'],
        \['iz', '[zV]z'],
        \['iL', 'V'],
        \['ii', ':<C-u>call <SID>SelectIndentationParagraph(0, 0)'],
        \['ai', ':<C-u>call <SID>SelectIndentationParagraph(1, 0)'],
        \['iI', ':<C-u>call <SID>SelectIndentationParagraph(0, 1)'],
        \['aI', ':<C-u>call <SID>SelectIndentationParagraph(1, 1)'],
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

function! s:SelectIndentationParagraph(includeOuter, continueUntilNoIndentation)
  if a:continueUntilNoIndentation
    call s:SelectIndentationParagraphAux(a:includeOuter, 0)
    return
  endif

  let l:currentLine = getline('.')
  let l:indentation = s:GetIndentation(l:currentLine)

  let l:count = v:count1

  while l:count > 0 
    let l:indentation = s:FindLowerIndentation(l:indentation)

    if l:indentation == -1
      normal! ggVG
      return
    endif

    let l:count -= 1
  endwhile

  call s:SelectIndentationParagraphAux(a:includeOuter, l:indentation)
endfunction

function! s:FindLowerIndentation(indentation)
  if a:indentation <= 0
    return -1
  endif

  let l:searchIndentation = a:indentation - 1
  let l:line = searchpos('^\s\{0,'.l:searchIndentation.'\}[^ \t]', 'nb')[0]
  return s:GetIndentation(getline(l:line))
endfunction

function! s:SelectIndentationParagraphAux(includeOuter, indentation)
  call searchpos('^\s\{0,'.a:indentation.'\}[^ \t]', 'b')

  if !a:includeOuter
    normal! j
  endif

  normal! V

  call searchpos('^\s\{0,'.a:indentation.'\}[^ \t]')

  if !a:includeOuter
    normal! k
  endif
endfunction
