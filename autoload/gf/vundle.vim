let s:save_cpo = &cpo
set cpo&vim

function! gf#vundle#find() "{{{2
  let line = getline('.')

  let package = s:parse_line(line)
  if empty(package)
    return 0
  endif

  for fn in ['s:find_from_neobundle', 's:find_from_vundle', 's:find_from_rtp']
    let path = call(fn, [package])
    if !empty(path)
      break
    endif
  endfor

  return !empty(path) ? {
        \ 'path' : isdirectory(path) ? path . '/' : path,
        \ 'line' : 0,
        \ 'col' : 0,
        \ } : 0
endfunction

function! s:find_from_neobundle(package) "{{{2
  if !exists(':NeoBundle')
    call s:log("neobundle is unusable")
    return ""
  endif

  let config = neobundle#get(a:package)
  if empty(config)
    call s:log("neobundle config : not found")
    return ""
  endif

  call s:log("config : %s", config.path)
  return config.path
endfunction

function! s:find_from_vundle(package) "{{{2
  if !exists('g:bundles')
    return ""
  endif
  let configs = filter(g:bundles, 'v:val.name == a:package')
  if !empty(configs)
    return ""
  endif
  return get(configs[0], 'rtpath', "")
endfunction

function! s:find_from_rtp(package) "{{{2
  for f in split(&rtp, ',')
    " call s:log("%s", f)
    if f =~# a:package . '$'
      call s:log("rtp : %s", f)
      return f
    endif
  endfor

  return ""
endfunction

function! s:parse_line(line)
  if a:line !~# '^\s*\(Vundle\|NeoBundle\)'
    call s:log("abort line : %s", a:line)
    return ""
  endif
  let q = '["' . "'" . ']'
  let s = matchstr(a:line, q. '[a-zA-Z0-9_\-/]\+' . q)
  call s:log(string(q. '[a-zA-Z0-9_\-\./]\+' . q))
  let package = substitute(s, '\(' . q . '\|\.git' . q . '\?$\)', '', 'g')

  let package = fnamemodify(package, ':p:t')
  call s:log("parse %s <- %s <- %s", package, s, a:line)
  return package
endfunction

function! s:log(...) " {{{2
  if !g:gf_vundle_debug
    return
  endif
  if exists(':NeoBundle') && !neobundle#is_sourced('vimconsole.vim')
    NeoBundleSource vimconsole.vim
  endif
  let args = copy(a:000)
  if empty(args)
    vimconsole#log('gf_vundle')
    return
  endif
  let args[0] = strftime("%Y/%m/%d %T") . "> gf_vundle : " . args[0]
  call call('vimconsole#log', args)
endfunction


let &cpo = s:save_cpo
" __END__ {{{1
