function! krakarn#utils#menu#load()
  call krakarn#utils#pure#load()
endfunction

function! CreateMenuItem(label, action)
  return { 'label': a:label, 'action': a:action }
endfunction

function! CreateMenu(title, menuItems)
  return { 'title': a:title, 'menuItems': a:menuItems }
endfunction

function! ShowMenu(menu)
  execute 'echo "' . (a:menu.title) . '"'

  let l:i = 0

  while l:i < len(a:menu.menuItems)
    call ShowMenuItem(a:menu.menuItems[l:i], l:i)
    let l:i += 1
  endwhile
endfunction

function! ShowMenuItem(menuItem, i)
  execute 'echo "' . (a:i + 1) . '. ' . (a:menuItem.label) . '"'
endfunction

function! OpenMenu(menu)
  call ShowMenu(a:menu)

  let l:choiceIndex = getchar() - 48

  if l:choiceIndex > len(a:menu.menuItems)
        \ || l:choiceIndex <= 0
    echo 'Choice not found: ' . l:choiceIndex
    return
  endif

  call a:menu.menuItems[l:choiceIndex - 1].action()
endfunction
