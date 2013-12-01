" Copyright (c) 2013 Junegunn Choi
"
" MIT License
"
" Permission is hereby granted, free of charge, to any person obtaining
" a copy of this software and associated documentation files (the
" "Software"), to deal in the Software without restriction, including
" without limitation the rights to use, copy, modify, merge, publish,
" distribute, sublicense, and/or sell copies of the Software, and to
" permit persons to whom the Software is furnished to do so, subject to
" the following conditions:
"
" The above copyright notice and this permission notice shall be
" included in all copies or substantial portions of the Software.
"
" THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
" EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
" MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
" NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
" LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
" OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
" WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

let s:cpo_save = &cpo
set cpo&vim

function! s:get_color(group, attr)
  return synIDattr(synIDtrans(hlID(a:group)), a:attr)
endfunction

function! s:set_color(group, attr, color)
  let gui = has('gui_running')
  execute printf("hi %s %s%s=%s", a:group, gui ? 'gui' : 'cterm', a:attr, a:color)
endfunction

function! s:blank()
  let main = bufwinnr(t:goyo_master)
  if main != -1
    execute main . 'wincmd w'
  else
    call s:goyo_off()
  endif
endfunction

function! s:init_pad(command)
  execute a:command

  setlocal buftype=nofile bufhidden=wipe nomodifiable nobuflisted noswapfile
        \ nonu nocursorline colorcolumn=
        \ winfixwidth winfixheight statusline=\ 
  let bufnr = winbufnr(0)

  execute winnr('#') . 'wincmd w'
  return bufnr
endfunction

function! s:setup_pad(bufnr, vert, size)
  let win = bufwinnr(a:bufnr)
  execute win . 'wincmd w'
  execute (a:vert ? 'vertical ' : '') . 'resize ' . max([0, a:size])
  augroup goyop
    autocmd WinEnter <buffer> call s:blank()
  augroup END
  execute winnr('#') . 'wincmd w'
endfunction

function! s:hmargin()
  let nwidth = max([len(string(line('$'))) + 1, &numberwidth])
  let width  = t:goyo_width + (&number ? nwidth : 0)
  return (&columns - width)
endfunction

function! s:resize_pads()
  let hmargin = s:hmargin()
  let tmargin = get(g:, 'goyo_margin_top', 4)
  let bmargin = get(g:, 'goyo_margin_bottom', 4)

  augroup goyop
    autocmd!
  augroup END
  call s:setup_pad(t:goyo_pads.l, 1, hmargin / 2 - 1)
  call s:setup_pad(t:goyo_pads.r, 1, hmargin / 2 - 1)
  call s:setup_pad(t:goyo_pads.t, 0, tmargin - 1)
  call s:setup_pad(t:goyo_pads.b, 0, bmargin - 2)
endfunction

function! s:tranquilize()
  let bg = s:get_color('Normal', 'bg')
  for grp in ['NonText', 'FoldColumn', 'ColorColumn', 'VertSplit',
            \ 'StatusLine', 'StatusLineNC', 'SignColumn']
    if bg == -1
      call s:set_color(grp, '', 'NONE')
      call s:set_color(grp, 'fg', get(g:, 'goyo_bg', 'black'))
      call s:set_color(grp, 'bg', 'NONE')
    else
      call s:set_color(grp, 'fg', bg)
      call s:set_color(grp, 'bg', bg)
    endif
  endfor
endfunction

function! s:goyo_on(width)
  " New tab
  tab split

  let t:goyo_master = winbufnr(0)
  let t:goyo_width  = a:width
  let t:goyo_pads = {}
  let t:goyo_revert =
    \ { 'laststatus':     &laststatus,
    \   'showtabline':    &showtabline,
    \   'fillchars':      &fillchars,
    \   'winwidth':       &winwidth,
    \   'winheight':      &winheight,
    \   'number':         &number,
    \   'relativenumber': &relativenumber,
    \   'colorcolumn':    &colorcolumn,
    \   'statusline':     &statusline
    \ }

  " gitgutter
  let t:goyo_disabled_gitgutter = get(g:, 'gitgutter_enabled', 0)
  if t:goyo_disabled_gitgutter
    GitGutterDisable
  endif

  set nonu nornu
  set colorcolumn=
  set statusline=\ 
  set winwidth=1
  set winheight=1
  set laststatus=0
  set showtabline=0
  set fillchars+=vert:\ 
  set fillchars+=stl:.
  set fillchars+=stlnc:\ 

  let t:goyo_pads.l = s:init_pad('vertical new')
  let t:goyo_pads.r = s:init_pad('vertical rightbelow new')
  let t:goyo_pads.t = s:init_pad('topleft new')
  let t:goyo_pads.b = s:init_pad('botright new')

  call s:resize_pads()
  call s:tranquilize()

  augroup goyo
    autocmd!
    autocmd BufWinLeave <buffer> call s:goyo_off()
    autocmd TabLeave    *        call s:goyo_off()
    autocmd VimResized  *        call s:resize_pads()
    autocmd ColorScheme *        call s:tranquilize()
  augroup END

  let t:goyohan = 1
endfunction

function! s:goyo_off()
  augroup goyo
    autocmd!
  augroup END

  if !exists('t:goyohan')
    return
  endif

  for [k, v] in items(t:goyo_revert)
    execute printf("let &%s = %s", k, string(v))
  endfor
  execute 'colo '. g:colors_name

  if t:goyo_disabled_gitgutter
    GitGutterEnable
  endif

  if tabpagenr() == 1
    tabnew
    normal! gt
    bd
  endif
  tabclose
endfunction

function! s:goyo(...)
  let width = a:0 > 0 ? a:1 : get(g:, 'goyo_width', 80)

  if get(t:, 'goyohan', 0) == 0
    call s:goyo_on(width)
  elseif a:0 > 0
    let t:goyo_width = width
    call s:resize_pads()
  else
    call s:goyo_off()
  end
endfunction

command! -nargs=? Goyo call s:goyo(<args>)

let &cpo = s:cpo_save
unlet s:cpo_save

