" Appearance: colours, cursor, GUI.

syntax enable

set cul
augroup BgHighlight
  autocmd!
  autocmd WinEnter * set cul
  autocmd WinLeave * set nocul
augroup END

" Cursor shape (DECSCUSR): bar in insert, underline in replace, block otherwise.
let &t_SI = "\<Esc>[6 q"
let &t_SR = "\<Esc>[4 q"
let &t_EI = "\<Esc>[2 q"

if has('termguicolors')
  " True-colour escape codes, needed inside tmux/screen.
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
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

" Statusline (replaces airline): mode, git branch, file, flags, keymap,
" LSP diagnostic counts, filetype, position.
let s:modes = {'n': 'NORMAL', 'i': 'INSERT', 'R': 'REPLACE', 'v': 'VISUAL',
      \ 'V': 'V-LINE', "\<C-v>": 'V-BLOCK', 'c': 'COMMAND', 't': 'TERMINAL',
      \ 's': 'SELECT', 'S': 'S-LINE', "\<C-s>": 'S-BLOCK'}

function! L0th1Mode() abort
  return get(s:modes, mode(), mode())
endfunction

function! L0th1Branch() abort
  let l:head = exists('*FugitiveHead') ? FugitiveHead(7) : ''
  return empty(l:head) ? '' : ' ' . l:head . ' '
endfunction

function! L0th1Diags() abort
  if !get(g:, 'loaded_lsp', 0)
    return ''
  endif
  let l:c = lsp#lsp#ErrorCount()
  let l:out = []
  if l:c.Error | call add(l:out, 'E' . l:c.Error) | endif
  if l:c.Warn | call add(l:out, 'W' . l:c.Warn) | endif
  return empty(l:out) ? '' : ' ' . join(l:out) . ' '
endfunction

set noshowmode
set statusline=%#PmenuSel#\ %{L0th1Mode()}\ %*
set statusline+=%#StatusLineNC#%{L0th1Branch()}%*
set statusline+=\ %f%(\ %h%m%r%)%(\ %k%)
set statusline+=%=
set statusline+=%#ErrorMsg#%{L0th1Diags()}%*
set statusline+=\ %{&filetype}\ \ %l:%c\ \ %P\ 
