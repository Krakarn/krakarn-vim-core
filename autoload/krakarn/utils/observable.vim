function! krakarn#utils#observable#load()
  call krakarn#utils#pure#load()
  call krakarn#utils#observable#operators#load()
endfunction

function! CreateObservable(handleObserver)
  let l:observable = {
      \  'handleObserver': a:handleObserver,
      \  'subscriptions': [],
      \}

  let l:observable['subscribe'] = {onNext, onError, onComplete -> Subscribe(l:observable, onNext, onError, onComplete)}
  let l:observable['let'] = {operator -> function(operator, [l:observable])}

  return l:observable
endfunction

let g:Observable = {
      \  'create': function('CreateObservable'),
      \  'merge': {observables -> CreateObservable({observer -> ObservableMerge(observer, observables)})},
      \  'concat': {observables -> CreateObservable({observer -> ObservableConcat(observer, observables)})},
      \  'defer': {f -> CreateObservable({observer -> ObservableDefer(observer, f)})},
      \  'of': {x -> CreateObservable({observer -> ObservableOf(observer, x)})},
      \  'never': {-> CreateObservable(function('ObservableNever'))},
      \  'empty': {-> CreateObservable(function('ObservableEmpty'))},
      \  'fromArray': {xs -> CreateObservable({observer -> ObservableFromArray(observer, xs)})},
      \  'timer': {initialDelay, period -> CreateObservable({observer -> ObservableTimer(observer, initialDelay, period)})},
      \}

function! ObservableMerge(observer, observables)
  let l:ncompleted = {'n': 0}

  function! OnComplete(observer, observables, n)
    let l:n = a:n['n'] + 1

    let a:n['n'] = l:n

    if l:n >= len(a:observables)
      call a:observer['complete']()
    endif
  endfunction

  let l:subscriptions = ListMap(
    \{observable ->
    \  observable.subscribe(
    \    a:observer['next'],
    \    a:observer['error'],
    \    {-> OnComplete(a:observer, a:observables, l:ncompleted)}
    \  )
    \}, a:observables)

  return {_ -> ListForEach({s -> s.unsubscribe()}, l:subscriptions)}
endfunction

function! ObservableConcat(observer, observables)
  let l:ncompleted = {'n': 0}
  let l:subscription = {'s': {}}

  function! OnComplete(subscription, observer, observables, n)
    let l:n = a:n['n'] + 1

    let a:n['n'] = l:n

    if l:n >= len(a:observables)
      call a:observer['complete']()
    else
      call SubscribeToNext(a:subscription, a:observer, a:observables, a:n)
    endif
  endfunction

  function! SubscribeToNext(subscription, observer, observables, n)
    let l:nextObservable = a:observables[a:n['n']]

    let a:subscription["s"] = l:nextObservable['subscribe'](
          \  a:observer['next'],
          \  a:observer['error'],
          \  {-> OnComplete(a:subscription, a:observer, a:observables, a:n)}
          \)
  endfunction

  call SubscribeToNext(l:subscription, a:observer, a:observables, l:ncompleted)

  return {_ -> l:subscription['s']['unsubscribe']()}
endfunction

function! ObservableDefer(observer, f)
  let l:observable = a:f(a:observer)

  let l:subscription = l:observable['subscribe'](a:observer['next'], a:observer['error'], a:observer['complete'])

  return {_ -> l:subscription['unsubscribe']()}
endfunction

function! ObservableOf(observer, x)
  call a:observer['next'](a:x)
  call a:observer['complete']()
endfunction

function! ObservableNever(observer)
endfunction

function! ObservableEmpty(observer)
  call a:observer['complete']()
endfunction

function! ObservableFromArray(observer, xs)
  call ListForEach({x -> a:observer['next'](x)}, a:xs)
  call a:observer['complete']()
endfunction

function! ObservableTimer(observer, initialDelay, period)
  let l:o = {'n': 0, 'timer': v:null, 'delay': a:period}

  function! SendNext(observer, o)
    let a:o['n'] += 1

    call a:observer['next'](a:o['n'])

    call timer_stop(a:o['timer'])

    let a:o['timer'] = timer_start(a:o['delay'],
          \  {timer -> SendNext(a:observer, a:o)},
          \)
  endfunction

  let l:o['timer'] = timer_start(a:initialDelay, {timer -> SendNext(a:observer, l:o)})

  return {_ -> [timer_stop(l:o['timer']), execute("echom 'MADNESS" . l:o['timer'] . "'")]}
endfunction

" Observer
function! CreateObserver(subscription)
  let l:observer = {
      \  'subscription': a:subscription,
      \  'completed': g:False
      \}

  let l:observer['next'] = {x -> Next(l:observer, x)}
  let l:observer['error'] = {error -> Error(l:observer, error)}
  let l:observer['complete'] = {... -> Complete(l:observer)}

  return l:observer
endfunction

function! Next(observer, x)
  if (a:observer['completed'] is g:True)
    return v:null
  endif

  call a:observer['subscription']['onNext'](a:x)
endfunction

function! Complete(observer)
  if (a:observer['completed'] is g:True)
    return v:null
  endif

  let a:observer['completed'] = g:True

  call a:observer['subscription']['onComplete']()
endfunction

function! Error(observer, error)
  if (a:observer['completed'] is g:True)
    return v:null
  endif

  let a:observer['completed'] = g:True

  call a:observer['subscription']['onError'](a:error)
endfunction

function! Subscribe(observable, onNext, onError, onComplete)
  let l:subscription = {
        \  'observable': a:observable,
        \  'onNext': a:onNext,
        \  'onError': a:onError,
        \  'onComplete': a:onComplete,
        \}

  let l:subscription['unsubscribe'] = {-> Unsubscribe(l:subscription)}

  let l:observer = CreateObserver(l:subscription)
  let l:subscription['observer'] = l:observer

  call add(a:observable['subscriptions'], l:subscription)

  let l:OnDestroy = a:observable['handleObserver'](l:observer)

  if type(l:OnDestroy) isnot v:t_func
    let l:OnDestroy = {_ -> v:null}
  endif

  let l:OnDestroy = Eval(g:Map, {_ -> execute("")}, l:OnDestroy)

  let l:subscription['onDestroy'] = l:OnDestroy

  if l:observer['completed'] is g:True
    call l:subscription['unsubscribe']()
  else
    let l:OnComplete = Eval(g:Map, {_ -> l:subscription['unsubscribe']()}, l:subscription['onComplete'])
    let l:OnError    = Eval(g:Map, {_ -> l:subscription['unsubscribe']()}, l:subscription['onError'])
    let l:subscription['onComplete'] = {-> l:OnComplete(v:null)}
    let l:subscription['onError'] = l:OnError
  endif

  return l:subscription
endfunction

function! Unsubscribe(subscription)
  let a:subscription['observable']['subscriptions'] = ListFilter({s -> s isnot a:subscription}, a:subscription['observable']['subscriptions'])
  call a:subscription['onDestroy'](v:null)
endfunction
