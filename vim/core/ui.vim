" Appearance: colours, cursor, GUI.

syntax enable

set cul
augroup BgHighlight
  autocmd!
  autocmd WinEnter * set cul
  autocmd WinLeave * set nocul
augroup END

" Insert mode cursor
let &t_SI = "\<Esc>]50;CursorShape=1\x7"
let &t_SR = "\<Esc>]50;CursorShape=2\x7"
let &t_EI = "\<Esc>]50;CursorShape=0\x7"

if has('termguicolors')
  set termguicolors
endif

function! Dark()
  let g:edge_style = 'aura'
  let g:edge_better_performance = 1
  try
    colorscheme edge
  catch /^Vim\%((\a\+)\)\=:E185/
    " edge not installed yet (fresh machine before :PlugInstall): use a bundled scheme.
    colorscheme wombat256mod
  endtry
endfunction
call Dark()

if has('gui_running')
  set guifont=DejaVu\ Sans\ Mono\ for\ Powerline:h12
  set guioptions-=m  "remove menu bar
  set guioptions-=T  "remove toolbar
  set guioptions-=r  "remove right-hand scroll bar
  set guioptions-=l
  set guioptions-=R
  set guioptions-=L
endif
