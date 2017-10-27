goyo.vim ([고요](http://en.wiktionary.org/wiki/고요하다))
=========================================================

Distraction-free writing in Vim.

![](https://raw.github.com/junegunn/i/master/goyo.png)

(Color scheme: [seoul256](https://github.com/junegunn/seoul256.vim))

Best served with [limelight.vim](https://github.com/junegunn/limelight.vim).

Installation
------------

Use your favorite plugin manager.

- [vim-plug](https://github.com/junegunn/vim-plug)
  1. Add `Plug 'junegunn/goyo.vim'` to .vimrc
  2. Run `:PlugInstall`

Usage
-----

- `:Goyo`
    - Toggle Goyo
- `:Goyo [dimension]`
    - Turn on or resize Goyo
- `:Goyo!`
    - Turn Goyo off

The window can be resized with the usual `[count]<CTRL-W>` + `>`, `<`, `+`,
`-` keys.

### Dimension expression

The expected format of a dimension expression is
`[WIDTH][XOFFSET][x[HEIGHT][YOFFSET]]`. `XOFFSET` and `YOFFSET` should be
prefixed by `+` or `-`. Each component can be given in percentage.

```vim
" Width
Goyo 120

" Height
Goyo x30

" Both
Goyo 120x30

" In percentage
Goyo 120x50%

" With offsets
Goyo 50%+25%x50%-25%
```

Configuration
-------------

- `g:goyo_width` (default: 80)
- `g:goyo_height` (default: 85%)
- `g:goyo_linenr` (default: 0)

### Callbacks

By default, [vim-airline](https://github.com/bling/vim-airline),
[vim-powerline](https://github.com/Lokaltog/vim-powerline),
[powerline](https://github.com/Lokaltog/powerline),
[lightline.vim](https://github.com/itchyny/lightline.vim),
[vim-signify](https://github.com/mhinz/vim-signify),
and [vim-gitgutter](https://github.com/airblade/vim-gitgutter) are temporarily
disabled while in Goyo mode.

If you have other plugins that you want to disable/enable, or if you want to
change the default settings of Goyo window, you can set up custom routines
to be triggered on `GoyoEnter` and `GoyoLeave` events.

```vim
function! s:goyo_enter()
  silent !tmux set status off
  silent !tmux list-panes -F '\#F' | grep -q Z || tmux resize-pane -Z
  set noshowmode
  set noshowcmd
  set scrolloff=999
  Limelight
  " ...
endfunction

function! s:goyo_leave()
  silent !tmux set status on
  silent !tmux list-panes -F '\#F' | grep -q Z && tmux resize-pane -Z
  set showmode
  set showcmd
  set scrolloff=5
  Limelight!
  " ...
endfunction

autocmd! User GoyoEnter nested call <SID>goyo_enter()
autocmd! User GoyoLeave nested call <SID>goyo_leave()
```

More examples can be found here:
[Customization](https://github.com/junegunn/goyo.vim/wiki/Customization)

### Advanced configuration

Goyo reloads the color scheme on exit, therefore, custom patches will be lost.
To reliably apply custom colors, autocmd ColorScheme can be used as suggested below.

in .vimrc
```vim
" Override Colors in a Color Scheme
fun! s:patch_colorscheme()
    hi clear LineNr
    hi clear SignColumn
endf
```

```vim
" Set colorscheme and patch it
colo seoul256
call s:patch_colorscheme()
```

```vim
" Re-patch colorscheme whenever ColorScheme is applied
aug patch_colors
  au!
  au ColorScheme * call s:patch_colorscheme()
aug END
```
source [#84](https://github.com/junegunn/goyo.vim/issues/84) and [vim.wikia](http://vim.wikia.com/wiki/Override_Colors_in_a_Color_Scheme)

Inspiration
-----------

- [LiteDFM](https://github.com/bilalq/lite-dfm)
- [VimRoom](http://projects.mikewest.org/vimroom/)

Pros.
-----

1. Works well with splits. Doesn't mess up with the current window arrangement
1. Works well with popular statusline plugins
1. Prevents accessing the empty windows around the central buffer
1. Can be closed with any of `:q[uit]`, `:clo[se]`, `:tabc[lose]`, or `:Goyo`
1. Can dynamically change the width of the window
1. Adjusts its colors when color scheme is changed
1. Realigns the window when the terminal (or window) is resized or when the size
   of the font is changed
1. Correctly hides colorcolumns and Emojis in statusline
1. Highly customizable with callbacks

License
-------

MIT
