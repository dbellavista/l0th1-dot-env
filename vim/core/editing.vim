" Key mappings: movement, clipboard, tabs and windows.

" Section: Disable mouse scroll {{{
map <ScrollWheelUp> <nop>
map <S-ScrollWheelUp> <nop>
map <C-ScrollWheelUp> <nop>
map <ScrollWheelDown> <nop>
map <S-ScrollWheelDown> <nop>
map <C-ScrollWheelDown> <nop>
" }}}

" Section: Search and navigation {{{
nnoremap <F3> :set hlsearch!<CR>
nnoremap <space>f <Cmd>Files<CR>
nnoremap <space>/ <Cmd>Rg<CR>
nnoremap <space>* <Cmd>execute 'Rg ' . expand('<cword>')<CR>
nnoremap <space>b <Cmd>Buffers<CR>
nnoremap <space>h <Cmd>History<CR>
" Files changed in the working tree (what an agent just touched).
nnoremap <space>g <Cmd>GFiles?<CR>
nnoremap <LocalLeader>t <Cmd>Lexplore<CR>
" }}}

" Section: Git review {{{
nnoremap <space>d <Cmd>Gdiffsplit<CR>
nnoremap <space>s <Cmd>Git<CR>
" ]c / [c jump between changed hunks (signify, and in diff mode).
nnoremap <space>u <Cmd>SignifyHunkUndo<CR>
nnoremap <space>p <Cmd>SignifyHunkDiff<CR>
" }}}

" Section: Agent handoff {{{
" Copy a reference to the cursor line or the selected lines (path:12 or
" path:12-30, relative to the cwd) to paste into an agent prompt.
function! s:CopyRef(first, last) abort
  let l:ref = expand('%:.') . ':' . a:first . (a:last > a:first ? '-' . a:last : '')
  call setreg('"', l:ref)
  if has('clipboard')
    call setreg('+', l:ref)
  endif
  echo 'copied ' . l:ref
endfunction
nnoremap <space>r <Cmd>call <SID>CopyRef(line('.'), line('.'))<CR>
xnoremap <space>r <Esc><Cmd>call <SID>CopyRef(line("'<"), line("'>"))<CR>
" }}}

" Section: Formatting {{{
imap <S-Tab> <Esc><<i
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
