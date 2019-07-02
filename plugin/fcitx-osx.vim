" fcitx.vim  记住插入模式小企鹅输入法的状态
 " Author:       lilydjwg
" Maintainer:   lilydjwg
" Modified by:  codefalling
" Note:         另有使用 Python3 接口的新版本
" 此修改版用于 OS X 下的 https://github.com/CodeFalling/fcitx-remote-for-osx
 " ---------------------------------------------------------------------
" Load Once:
if exists('g:fcitx_remote')
  finish
endif

if (has("win32") || has("win95") || has("win64") || has("win16"))
  " Windows 下不要载入
  finish
endif
if exists('$SSH_TTY')
  finish
endif
if !executable("fcitx-remote")
  finish
endif
let s:keepcpo = &cpo
let g:loaded_fcitx = 1
set cpo&vim
" ---------------------------------------------------------------------
" Functions:
function Fcitx2en()
  let inputstatus = system("fcitx-remote")
  if inputstatus == 2
    let b:inputtoggle = 1
    let t = system("fcitx-remote -c")
  endif
endfunction
function Fcitx2zh()
  try
    if b:inputtoggle == 1
      let t = system("fcitx-remote -o")
      let b:inputtoggle = 0
    endif
  catch /inputtoggle/
    let b:inputtoggle = 0
  endtry
endfunction
" ---------------------------------------------------------------------
function BindAu()
  augroup Fcitx
   au InsertLeave * call Fcitx2en()
   au VimEnter * call Fcitx2en()
  augroup END
endfunction

function UnBindAu()
  au! Fcitx InsertLeave *
endfunction

call BindAu()

"Called once right before you start selecting multiple cursors
function! Multiple_cursors_after()
  call Fcitx2en()
  call BindAu()
endfunction

" ---------------------------------------------------------------------
"  Restoration And Modelines:
let &cpo=s:keepcpo
unlet s:keepcpo

let g:fcitx_remote = 1
