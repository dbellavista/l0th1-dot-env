" Key mappings: movement, clipboard, tabs and windows.

" Section: Disable mouse scroll {{{
map <ScrollWheelUp> <nop>
map <S-ScrollWheelUp> <nop>
map <C-ScrollWheelUp> <nop>
map <ScrollWheelDown> <nop>
map <S-ScrollWheelDown> <nop>
map <C-ScrollWheelDown> <nop>
" }}}

" Section: Search {{{
nnoremap <F3> :set hlsearch!<CR>
map <F4> :call ToggleHighlight(1)<CR>
nnoremap <space>/ :Unite grep:.<cr>
" }}}

" Section: IDE Like {{{
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in") && exists(':NERDTree') | exe 'NERDTree' argv()[0] | wincmd p | ene | endif
map <LocalLeader>t :NERDTreeToggle<CR>
" }}}

" Section: Formatting {{{
nnoremap <C-Q> :call DoFormat()<CR>
nmap <F1> mz:call TabToggle()<CR>'z
imap <S-Tab> <Esc><<i
nnoremap <leader>l :TagbarToggle<CR>
let g:tagbar_usearrows = 1
nmap <silent> <C-l> <Plug>(jsdoc)
map <F10> :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
\ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
\ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>
" }}}

" Section: Editing and Movement {{{
noremap <leader>o <Esc>i<CR><Esc>
noremap <leader>O <Esc>i<CR><Esc>-$
inoremap <C-h> <C-w>
nnoremap <up> gk
nnoremap <down> gj
nnoremap <silent> <F12> :bn<CR>
nnoremap <silent> <S-F12> :bp<CR>
" }}}

" Section: Copy&Paste configuration {{{
if exists('+pastetoggle')
  set pastetoggle=<F2> " avoid auto-indent while pasting
endif
nnoremap Y y$

vnoremap <LocalLeader>v "+p
nnoremap <LocalLeader>v "+p
vnoremap <LocalLeader>c "+y
vnoremap <LocalLeader>V "+y$
vnoremap <LocalLeader>x "+d
vnoremap <LocalLeader>X "+dd

nnoremap <LocalLeader>p "*p
vnoremap <LocalLeader>y "*y
nnoremap <LocalLeader>Y "*y$
vnoremap <LocalLeader>d "*d
nnoremap <LocalLeader>dd "*dd
" }}}

" Section: Tabs Management {{{
" Cmd- (MacVim) and Alt-/Meta- (terminal sends Esc+key) variants.
noremap <D-j> <C-w><C-w>
noremap <D-k> <C-w>W
noremap <D-J> <C-w><C-R>
noremap <D-K> <C-w>R

noremap <Esc>h :tabprev<CR>
noremap <Esc>l :tabnext<CR>
noremap <Esc>H :tabfirst<CR>
noremap <Esc>L :tablast<CR>

noremap <Esc><left> :tabprev<CR>
noremap <Esc><right> :tabnext<CR>
noremap <Esc><up> :tabfirst<CR>
noremap <Esc><down> :tablast<CR>
noremap <Esc>c :tabclose<CR>
noremap <Esc>t :tabnew %<CR>
noremap <Esc>j <C-w><C-w>
noremap <Esc>k <C-w>W
noremap <Esc>J <C-w><C-R>
noremap <Esc>K <C-w>R
" }}}
