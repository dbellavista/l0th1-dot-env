" Plugins via vim-plug (vendored in autoload/plug.vim).
" Base plugins load everywhere. Plugins with a build step need the `dev` profile.
" Install/update: `l0th1 install --plugins` / `l0th1 update --plugins`, or :PlugInstall.

" Packages bundled with Vim 9.1+: gc comments, .editorconfig, % on keywords,
" yank flash, :HelpToc (also for markdown headings).
for s:pack in ['comment', 'editorconfig', 'matchit', 'hlyank', 'helptoc']
  silent! execute 'packadd!' s:pack
endfor

call plug#begin(g:l0th1_vim_data . '/plugged')

" Base: no build step.
" fzf.vim needs the fzf binary: fzf#install() downloads one if it is not on PATH.
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'tpope/vim-fugitive'
Plug 'mhinz/vim-signify'
Plug 'tpope/vim-unimpaired'
Plug 'lambdalisue/suda.vim'
Plug 'sainnhe/edge'

if L0th1HasProfile('dev')
  " LSP client in Vim9script: completion, hover, goto, rename, diagnostics, format.
  Plug 'yegappan/lsp'
endif

" Overlay layers may add their own Plug lines.
for s:dir in L0th1OverlayDirs()
  if filereadable(s:dir . '/plugins.vim')
    execute 'source' fnameescape(s:dir . '/plugins.vim')
  endif
endfor

call plug#end()

" Section: Plugin settings {{{
" fzf: popup window; :Files lists what ripgrep would search (respects .gitignore).
let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.8 } }
if executable('rg')
  let $FZF_DEFAULT_COMMAND = 'rg --files --hidden --glob "!.git/"'
endif

" signify: git only, sign column always shown so text doesn't shift.
let g:signify_vcs_list = ['git']
set signcolumn=yes

" netrw: tree listing, no banner.
let g:netrw_banner = 0
let g:netrw_liststyle = 3
let g:netrw_winsize = 25
" }}}
