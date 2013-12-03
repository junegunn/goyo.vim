goyo.vim (고요)
===============

Distraction-free writing in Vim.

![](https://raw.github.com/junegunn/i/master/goyo.png)

Installation
------------

Use your favorite plugin manager.

- [vim-plug](https://github.com/junegunn/vim-plug)
  1. Add `Plug 'junegunn/goyo.vim'` to .vimrc
  2. Run `:PlugInstall`

Usage
-----

`:Goyo [width]`

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
[powerline](https://github.com/Lokaltog/powerline), and
[vim-gitgutter](https://github.com/airblade/vim-gitgutter) are temporarily
disabled while in Goyo mode.

If you have other plugins that you want to disable/enable, or if you want to
change the default settings of Goyo window, you can define before and after
callbacks as follows in your .vimrc.

```vim
function! s:goyo_before()
  "
endfunction

function! s:goyo_after()
  "
endfunction

let g:goyo_callbacks = [function('s:goyo_before'), function('s:goyo_after')]
```

Inspiration
-----------

- [LiteDFM](https://github.com/bilalq/lite-dfm)
- [VimRoom](http://projects.mikewest.org/vimroom/)

License
-------

MIT

