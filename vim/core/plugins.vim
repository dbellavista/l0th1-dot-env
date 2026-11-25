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
Plug 'ctrlpvim/ctrlp.vim'
Plug 'bling/vim-airline'
Plug 'scrooloose/nerdtree'
Plug 'tpope/vim-unimpaired'
Plug 'lambdalisue/suda.vim'
" Themes
Plug 'sainnhe/edge'
Plug 'vim-airline/vim-airline-themes'

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
let g:airline_powerline_fonts = 1
let g:airline#extensions#keymap#enabled = 0

let g:NERDTreeDirArrowExpandable = '▸'
let g:NERDTreeDirArrowCollapsible = '▾'

let g:ctrlp_working_path_mode = 'ra'
let g:ctrlp_custom_ignore = {
      \ 'dir':  '\v[\/](\.git|\.hg|\.svn|\.tmp|tmp|dist|releases|node_modules|build|__?tmp|libs|coverage|doc\/out|dock\/gen|vendor|doc\/jsod)$',
      \ 'file': '\v\.(exe|so|dll|gif|png)$',
      \ 'link': 'some_bad_symbolic_links'
      \ }



" }}}
