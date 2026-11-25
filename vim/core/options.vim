" Core editor behaviour: no plugin dependencies.

if has('unix')
  set shell=/bin/bash
endif

" Section: Vim undo {{{
set undolevels=1000
let &undodir = g:l0th1_vim_state . '/undo'
if !isdirectory(&undodir)
  call mkdir(&undodir, 'p')
endif
set undofile
" Swap and write-backup files stay out of the project, where agents and
" `git status` would see them.
let &directory = g:l0th1_vim_state . '/swap//'
let &backupdir = g:l0th1_vim_state . '/backup//'
for s:dir in [&directory, &backupdir]
  if !isdirectory(s:dir)
    call mkdir(s:dir, 'p')
  endif
endfor
" }}}

" Section: Vim buffers {{{
set hidden
" Files change under us when agents edit them: reload unmodified buffers on
" focus/buffer switch, when idle, and every 2s while sitting in normal mode
" (covers the case where vim never loses focus, e.g. another zellij pane).
set autoread
set updatetime=300
augroup l0th1_checktime
  autocmd!
  autocmd FocusGained,BufEnter,CursorHold,CursorHoldI * silent! checktime
augroup END
function! s:CheckTime(timer) abort
  if mode() ==# 'n' && getcmdwintype() ==# ''
    silent! checktime
  endif
endfunction
if has('timers') && !exists('s:checktime_timer')
  let s:checktime_timer = timer_start(2000, function('s:CheckTime'), {'repeat': -1})
endif
" }}}

" Section: Vim behavior {{{
set modelines=0
set nomodeline
set visualbell
set viminfo^=\!
set t_vb=
set noerrorbells
set history=1000
set scrolloff=10
set sidescroll=1
set fenc=utf-8
" }}}

" Section: Folding and Indentation {{{
set autoindent
set copyindent
set tabstop=2
set shiftwidth=2
set expandtab
set shiftround
set foldmethod=indent
set foldnestmax=2
" }}}

" Section: Search settings {{{
set smartcase
set incsearch
set hlsearch
set wildignore+=*.so,*.swp,*.zip,*.exe,*.pyc,__pycache__/*,.venv/*
" }}}

" Section: CAPS mode {{{
set imsearch=-1
set keymap=insert-only_capslock
set iminsert=0
" }}}

" Section: visualization {{{
set number
set laststatus=2
set title
let &titleold = fnamemodify(getcwd(), ':t')
set ruler
set mouse-=a
set list listchars=tab:\ \ ,trail:~,extends:>,precedes:<
set nowrap
" }}}

" Section: Diff {{{
set diffopt+=algorithm:histogram,indent-heuristic,linematch:60
" }}}
