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
autocmd BufRead,BufNewFile /mnt/* set undodir=.
" }}}

" Section: Vim buffers {{{
set hidden
set autoread
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
set foldmethod=syntax
set foldnestmax=2
" }}}

" Section: Search settings {{{
set smartcase
set incsearch
set hlsearch!
set wildignore+=*.so,*.swp,*.zip,
set wildignore+=*.swp,*.zip,*.exe
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
