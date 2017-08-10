" Configs

let s:debug = 0

function! Log(msg)
  if (s:debug)
    echo a:msg
  endif
endfunction

function! LogError(msg)
  let l:out = 'Error: ' . a:msg

  echohl ErrorMsg
  echo l:out
  echohl None
endfunction

function! EchoException()
  call LogError(v:throwpoint . ": " . v:exception)
endfunction

function! MassageGitIgnoreEntry(i, str)
  " Remove comment
  let l:sub = substitute(a:str, '\(\s*#.*\)$', '', 'g')

  " Remove slashes in the beginning of the ignore setting to make it
  " vim-compatible
  let l:sub = substitute(l:sub, '^\(\s*[\\\/]\)', '', '')
  return l:sub
endfunction

function! IsNotEmpty(i, str)
  return len(a:str) > 0
endfunction

function! GetGitIgnore()
  let l:gitignore = ''

  if filereadable('./.gitignore')
    let l:gitignore = readfile('./.gitignore')
    let l:gitignore = map(l:gitignore, function('MassageGitIgnoreEntry'))
    let l:gitignore = filter(l:gitignore, function('IsNotEmpty'))
    let l:gitignore = join(l:gitignore, ',')
  endif

  return l:gitignore
endfunction

function! krakarn#configs#init()
  try

    let s:vimjsonpath = expand('./vim.json')
    let s:vimjsoncontent = ""
    let s:config = 0

    call Log('Checking for ' . s:vimjsonpath . '...')

    " Check for config file
    if filereadable(s:vimjsonpath)

      " Read options from config file

      let s:vimjsoncontent = join(readfile(s:vimjsonpath), "\n")

      call Log('Contents for ' . s:vimjsonpath . ':')
      call Log(s:vimjsoncontent)

      let s:config = JSON#parse(s:vimjsoncontent)

      call Log('Parsed content for ' . s:vimjsonpath . ':')
      call Log(s:config)

      if exists("s:config")
        " Handle options

        " File ignore
        if exists("s:config.ignore")
          call Log('Adding to wildignore: ' . s:config.ignore)
          execute 'set wildignore=' . s:config.ignore
        endif
      endif

    endif

    call Log('Parsed content for .gitignore:')
    let l:gitignore = GetGitIgnore()
    call Log(l:gitignore)
    call Log('Adding to wildignore: ' . l:gitignore)
    execute 'set wildignore+=' . l:gitignore

  catch

    call EchoException()

  endtry
endfunction
