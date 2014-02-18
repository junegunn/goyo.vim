goyo.vim ([고요](http://en.wiktionary.org/wiki/고요하다))
=========================================================

Distraction-free writing in Vim.

![](https://raw.github.com/junegunn/i/master/goyo.png)

(Color scheme: [seoul256](https://github.com/junegunn/seoul256.vim))

Installation
------------

Use your favorite plugin manager.

- [vim-plug](https://github.com/junegunn/vim-plug)
  1. Add `Plug 'junegunn/goyo.vim'` to .vimrc
  2. Run `:PlugInstall`

Usage
-----

`:Goyo [width]`

You might map this to a key combo in your `.vimrc` like so:
```vim
"" Map Goyo toggle to <Leader> + spacebar
nnoremap <Leader><Space> :Goyo<CR>  
```

Configuration
-------------

- `g:goyo_width` (default: 80)
- `g:goyo_margin_top` (default: 4)
- `g:goyo_margin_bottom` (default: 4)
- `g:goyo_linenr` (default: 0)
- `g:goyo_callbacks` ([before_funcref, after_funcref])

### Callbacks

By default, [vim-airline](https://github.com/bling/vim-airline),
[vim-powerline](https://github.com/Lokaltog/vim-powerline),
[powerline](https://github.com/Lokaltog/powerline),
[lightline.vim](https://github.com/itchyny/lightline.vim), and
[vim-gitgutter](https://github.com/airblade/vim-gitgutter) are temporarily
disabled while in Goyo mode.

If you have other plugins that you want to disable/enable, or if you want to
change the default settings of Goyo window, you can define before and after
callbacks as follows in your .vimrc.

```vim
function! s:goyo_before()
  silent !tmux set status off
  set noshowmode
  set noshowcmd
  " ...
endfunction

function! s:goyo_after()
  silent !tmux set status on
  set showmode
  set showcmd
  " ...
endfunction

let g:goyo_callbacks = [function('s:goyo_before'), function('s:goyo_after')]
```

More examples can be found here:
[Customization](https://github.com/junegunn/goyo.vim/wiki/Customization)

(If you get the error `Unknown function: s:goyo_before`, define the callback
functions as globals. e.g. `g:goyo_before`)

Inspiration
-----------

- [LiteDFM](https://github.com/bilalq/lite-dfm)
- [VimRoom](http://projects.mikewest.org/vimroom/)

Pros.
-----

1. Works well with splits. Doesn't mess up with the current window arrangement
1. Works well with popular statusline plugins
1. Prevents accessing the empty windows around the central buffer
1. Can be closed with any of `:q[uit]`, `:clo[se]`, `:tabc[lose]`, `:bd[elete]`,
   or `:Goyo`
1. Can dynamically change the width of the window
1. Adjusts its colors when color scheme is changed
1. Realigns the window when the terminal (or window) is resized or when the size
   of the font is changed
1. Correctly hides colorcolumns and Emojis in statusline
1. Highly customizable with callbacks

License
-------

MIT

