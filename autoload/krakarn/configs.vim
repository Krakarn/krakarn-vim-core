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
          let &wildignore = s:config.ignore . ',' . &wildignore
        endif

        if filereadable('./.gitignore')
          let l:gitignore = join(readfile('./.gitignore'), ',')

          call Log('Adding to wildignore: ' . l:gitignore)
          let &wildignore = l:gitignore . ',' . &wildignore
        endif
      endif

    endif

  catch

    call EchoException()

  endtry
endfunction
