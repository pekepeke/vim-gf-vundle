if v:version < 700
  echoerr 'does not work this version of Vim(' . v:version . ')'
  finish
elseif exists('g:loaded_gf_vundle')
  finish
endif

let s:save_cpo = &cpo
set cpo&vim

" let g:gf_vundle_debug = get(g:, 'g:gf_vundle_debug', 1)
let g:gf_vundle_debug = get(g:, 'g:gf_vundle_debug', 0)

call gf#user#extend('gf#vundle#find', 1000)

let &cpo = s:save_cpo
unlet s:save_cpo

let g:loaded_gf_vundle = 1

" vim: foldmethod=marker
" __END__ {{{1
