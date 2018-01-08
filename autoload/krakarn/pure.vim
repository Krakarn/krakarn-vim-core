" Pure

function! Id(x)
  return a:x
endfunction

function! Const(x)
  return {... -> a:x}
endfunction

function! ListFold(f, d, xs)
  if len(a:xs) == 0
    return a:d
  endif

  let l:Head = a:xs[0]
  let l:tail = a:xs[1:]

  return a:f(ListFold(a:f, a:d, l:tail), l:Head)
endfunction

function! ListMap(f, xs)
  return ListFold({acc, x -> [a:f(x)] + acc}, [], a:xs)
endfunction

function! ListForEach(f, xs)
  for x in a:xs
    call a:f(x)
  endfor
endfunction

function! ListFilter(f, xs)
  return ListFold({acc, x -> a:f(x) ? [x] + acc : acc}, [], a:xs)
endfunction

function! ListZip(xs, ys)
  if len(a:xs) == 0 || len (a:ys) == 0
    return []
  endif

  let l:xy = [a:xs[0], a:ys[0]]

  return [l:xy] + Zip(a:xs[1:], a:ys[1:])
endfunction

function! ListFirst(tuple)
  return a:tuple[0]
endfunction

function! ListSecond(tuple)
  return a:tuple[1]
endfunction

function IsT(tx)
  let l:vexists = exists("a:tx['v']")
  let l:texists = exists("a:tx['t']")

  return l:vexists && l:texists && type(a:tx['t']) == v:t_dict
endfunction

" Associates a value with a type
" so that it can be used with the
" list of pure functions that start
" at g:Equals
function! T(x, t)
  return {
        \ 'v': a:x,
        \ 't': a:t,
        \ }
endfunction

" Unpacks a T'd value
function! R(tx)
  let l:Result = a:tx['v']

  return l:Result
endfunction

" Tries to automatically associate a value with a type
function A(x)
  let l:t = g:Any
  let l:type = type(a:x)

  if l:type == v:t_string || l:type == v:t_list
    let l:t = g:List
  elseif l:type == v:t_func
    let l:t = g:Function
  elseif l:type == v:t_number
    let l:t = g:Number
  elseif a:x is g:True || a:x is g:False
    let l:t = g:Boolean
  elseif a:x is g:Nothing || IsJust(a:x)
    let l:t = g:Maybe
  endif

  return T(a:x, l:t)
endfunction

function! E(f, ...)
  if type(a:f) isnot v:t_func
    throw "f is not a function"
  endif

  let l:xs = []
  let l:i = 0

  for X in a:000
    if IsT(X)
      let l:tx = X
    else
      let l:tx = A(X)
    endif

    call add(l:xs, {'tx': l:tx, 'i': l:i})

    let l:i += 1
  endfor

  execute("let l:Result = a:f(" . join(ListMap({x -> "l:xs[" . x['i'] . "]['tx']"}, l:xs), ',') . ")")

  return l:Result
endfunction

function Eval(f, ...)
  if type(a:f) isnot v:t_func
    throw "f is not a function"
  endif

  let l:xs = []
  let l:i = 0

  for X in a:000
    call add(l:xs, {'v': X, 'i': l:i})
    let l:i += 1
  endfor

  execute("let l:Result = R(E(a:f, " . join(ListMap({x -> "l:xs[" . x['i'] . "]['v']"}, l:xs), ',') . "))")

  return l:Result
endfunction

" Equals :: Setoid t => t x -> t x -> Boolean
let g:Equals    = {tx1, tx2     -> T(tx1.t.equals(tx1.v, tx2.v), g:Boolean)}

" Lte :: Ord t => t x -> t x -> Boolean
let g:Lte       = {tx1, tx2     -> T(tx1.t.lte(tx1.v, tx2.v), g:Boolean)}

" Concat :: Semigroup t => t x -> t x -> t x
let g:Concat    = {tx1, tx2     -> T(tx1.t.concat(tx1.v, tx2.v), tx1.t)}

" Empty :: Monoid t => t x
let g:Empty     = {t            -> T(t.empty(), t)}

" Map :: Functor t => (x -> y) -> t x -> t y
let g:Map       = {f, tx        -> T(tx.t.map(f.v, tx.v), tx.t)}

" Bimap :: Bifunctor t => (x -> y) -> (z -> v) -> t x z -> t y v
let g:Bimap     = {f, g, tx     -> T(tx.t.bimap(f.v, g, tx.v), tx.t)}

" Contramap :: Contravariant t => (x -> y) -> t y -> t x
let g:Contramap = {f, tx        -> T(tx.t.contramap(f.v, tx.v), tx.t)}

" Promap :: Profunctor t -> (x -> y) -> (z -> v) -> t y z -> t x v
let g:Promap    = {f, g, tx     -> T(tx.t.promap(f.v, g, tx.v), tx.t)}

" Ap :: Apply t => t (x -> y) -> t x -> t y
let g:Ap        = {tf, tx       -> T(tx.t.ap(tf.v, tx.v), tx.t)}

" Of :: Applicative t => x -> t x
let g:Of        = {tx           -> T(tx.t.of(tx.v), tx.t)}

" Alt :: Alt t => t x -> t x -> t x
let g:Alt       = {tx1, tx2     -> T(tx1.t.alt(tx1.v, tx2.v), tx1.t)}

" Zero :: Plus t => t x
let g:Zero      = {t            -> T(t.zero(), t)}

" Chain :: Chain t => (x -> t y) -> t x -> t y
let g:Chain     = {fxy, tx      -> T(tx.t.chain(fxy.v, tx.v), tx.t)}

" Reduce :: Foldable t => (x -> y -> x) -> x -> t y -> x
let g:Reduce    = {fxxy, x, tx  -> A(tx.t.reduce(fxxy.v, x, tx.v))}

" Extend :: Extend t => (t x -> y) -> t x -> t y
let g:Extend    = {ftxy, tx     -> T(tx.t.extend(ftxy.v, tx), tx.t)}

" Extract :: Comonad t => t x -> x
let g:Extract   = {tx           -> A(tx.t.extract(tx.v))}

" Traverse :: (Traversable t, Applicative a) => (x -> a y) -> t x -> a (t y)
let g:Traverse  = {ufux, ty     -> T(exists("ty.t.traverse") ? ty.t.traverse(ufux.v, ty.v) : ty.t.reduce({utx, y -> ufux.t.ap(ufux.t.map({x -> {tx -> ty.t.concat(ty.t.of(x), tx)}}, ufux.v(y)), utx)}, ufux.t.of(ty.t.empty()), ty.v), ufux.t)}

" Join :: Monad t => t (t x) -> t x
let g:Join      = {ttx          -> T(ttx.t.chain(function('Id'), ttx.v), ttx.t)}

let g:And       = {b1, b2 -> NumberToBoolean(b1 is g:True && b2 is g:True)}
let g:Or        = {b1, b2 -> NumberToBoolean(b1 is g:True || b2 is g:True)}
let g:Not       = {b      -> b is g:True ? g:False : g:True}

" Any
let g:Any = {}
let g:Any.equals  = {x1, x2 -> NumberToBoolean(x1 is x2)}
let g:Any.lte     = {x1, x2 -> NumberToBoolean(x1 < x2)}
let g:Any.concat  = {x1, x2 -> x1 + x2}
let g:Any['map']  = {f, x -> f(x)}
let g:Any.of      = function('Id')

" Boolean
let g:True = {}
let g:False = {}
let g:Boolean = {}
let g:Boolean.equals  = Any.equals
let g:Boolean.lte     = {b1, b2 -> Or(b1, g:Boolean.equals(b1, b2)) ? g:False : g:True}
let g:Boolean.concat  = {b1, b2 -> And(b1, b2)}
let g:Boolean.empty   = Const(True)
let g:Boolean.alt     = {b1, b2 -> Or(b1, b2)}
let g:Boolean.zero    = Const(False)

function! NumberToBoolean(x)
  return a:x == 0 ? g:False : g:True
endfunction

function! BooleanToNumber(b)
  return a:b is g:False ? 0 : 1
endfunction

" Number
let g:Number = {}
let g:Number.equals = Any.equals
let g:Number.lte    = Any.lte
let g:Number.concat = Any.concat
let g:Number.empty  = {... -> 0}
let g:Number.alt    = {x1, x2 -> g:Number.lte(x1, x2) ? x2 : x1}
let g:Number.zero   = Number.empty

" List
let g:List = {}
let g:List.equals = {list1, list2 -> NumberToBoolean(len(list1) == len(list2) && ListFold({acc, xy -> acc ? Eval(Equals, ListFirst(xy), ListSecond(xy)) : acc}, 1, ListZip(list1, list2)))}
let g:List.lte    = {list1, list2 -> NumberToBoolean(len(list1) < len(list2) && ListFold({acc, xy -> acc ? Eval(Lte, ListFirst(xy), ListSecond(xy)) : acc}, 1, ListZip(list1, list2)))}
let g:List.concat   = Any.concat
let g:List.empty    = Const([])
let g:List['map']   = {f, list -> ListMap(f, list)}
let g:List.bimap    = {f, g, tupleLike -> [f(ListFirst(tupleLike))] + [g(ListSecond(tupleLike))] + tupleLike[2:]}
let g:List.ap       = {fs, xs -> Eval(g:Join, g:List.map({f -> g:List.map(f, xs)}, fs))}
let g:List.of       = {x -> [x]}
let g:List.alt      = {list1, list2 -> g:List.lte(list1, list2) ? list2 : list1}
let g:List.zero     = List.empty
let g:List.chain    = {fys, xs -> g:List.reduce({ys, x -> g:List.concat(fys(x), ys)}, [], xs)}
let g:List.reduce   = {fy, d, xs -> ListFold(fy, d, xs)}

" Function
let g:Function = {}
let g:Function.concat   = {f, g -> {x -> g(f(x))}}
let g:Function.empty    = {... -> {x -> x}}
let g:Function['map']   = {f, g -> {x -> f(g(x))}}
let g:Function.promap   = {ab, cd, fbc -> {a -> cd(fbc(ab(a)))}}
let g:Function.ap       = {fxfab, fxa -> {x -> fxfab(x)(fxa(x))}}
let g:Function.of       = {x -> Const(x)}
let g:Function.chain    = {fafxb, fxa -> {x -> fafxb(fxa(x))(x)}}
let g:Function.extend   = {ffxab, fxa -> {x -> ffxab(fxa)}}

" Maybe
let g:Nothing = {}

function Just(x)
  return {'Just': a:x}
endfunction

function IsJust(x)
  return exists("a:x['Just']")
endfunction

function FromJust(x)
  return a:x['Just']
endfunction

let g:Maybe = {}
let g:Maybe.equals   = {m1, m2 -> (m1 is g:Nothing || m2 is g:Nothing) ? NumberToBoolean(m1 is m2) : Just(Eval(g:Equals, FromJust(m1), FromJust(m2)))}
let g:Maybe.lte      = {m1, m2 -> m1 isnot g:Nothing && m2 isnot g:Nothing ? Eval(g:Lte, FromJust(m1), FromJust(m2)) : g:False}
let g:Maybe.concat   = {m1, m2 -> (m1 is g:Nothing || m2 is g:Nothing) ? g:Nothing : Just(Eval(g:Concat, FromJust(m1), FromJust(m2)))}
let g:Maybe['map']   = {f, m -> m is g:Nothing ? g:Nothing : Just(f(FromJust(m)))}
let g:Maybe.ap       = {mf, m -> mf is g:Nothing ? g:Nothing : g:Maybe.map(FromJust(mf), m)}
let g:Maybe.of       = {x -> Just(x)}
let g:Maybe.zero     = Const(Nothing)
let g:Maybe.chain    = {fm, m -> m is g:Nothing ? g:Nothing : fm(FromJust(m))}
let g:Maybe.traverse = {ftx, m -> m is g:Nothing ? g:Nothing : Eval(g:Map, function('Just'), ftx(FromJust(m)))}

function! krakarn#pure#init()
endfunction
