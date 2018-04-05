function! krakarn#utils#observable#operators#load()
endfunction

function! OperatorMap(observable, f)
  return CreateObservable({observer -> OperatorMapHandleObserver(a:observable, observer, a:f)})
endfunction

function! OperatorMapHandleObserver(observable, observer, f)
  let l:subscription = a:observable['subscribe'](
        \  {x -> a:observer['next'](a:f(x))},
        \  a:observer['error'],
        \  a:observer['complete'],
        \)

  return {_ -> l:subscription.unsubscribe()}
endfunction

function! OperatorDo(observable, f)
  return g:Operators['map'](a:observable, {x -> [a:f(x), x][1]})
endfunction

function! OperatorTake(observable, n)
  return CreateObservable({observer -> OperatorTakeHandleObserver(a:observable, observer, a:n)})
endfunction

function! OperatorTakeHandleObserver(observable, observer, n)
  let l:count = 0

  let l:subscription = a:observable['subscribe'](
        \  {x -> l:count < a:n ? [execute("let l:count += 1"), a:observer['next'](x)] : a:observer['complete']()},
        \  a:observer['error'],
        \  a:observer['complete'],
        \)

  return {_ -> [l:subscription.unsubscribe(), execute("echom 'MADNESS'")]}
endfunction

function! OperatorDelay(observable, delay)

endfunction

let g:Operator = {
      \  'do': function('OperatorDo'),
      \  'map': function('OperatorMap'),
      \  'take': function('OperatorTake'),
      \}
