" Plugins via vim-plug (vendored in autoload/plug.vim).
" Base plugins load everywhere. Plugins with a build step need the `dev` profile.
" Install/update: `l0th1 install --plugins` / `l0th1 update --plugins`, or :PlugInstall.

" Build YouCompleteMe with the completers this machine has the tools for.
function! BuildYCM(info)
  if a:info.status == 'installed' || a:info.force
    let l:flags = ['--clang-completer']
    if executable('npm') | call add(l:flags, '--ts-completer') | endif
    if executable('go') | call add(l:flags, '--go-completer') | endif
    if L0th1HasProfile('desktop') | call add(l:flags, '--omnisharp-completer') | endif
    execute '!./install.py ' . join(l:flags)
  endif
endfunction

function! BuildALE(info)
  if a:info.status != 'unchanged' || a:info.force
    !git restore .
    !git clean -f
  endif
endfunction

call plug#begin(g:l0th1_vim_data . '/plugged')

" Base: no build step.
Plug 'ctrlpvim/ctrlp.vim'
Plug 'bling/vim-airline'
Plug 'scrooloose/nerdtree'
Plug 'tpope/vim-unimpaired'
Plug 'lambdalisue/suda.vim'
Plug 'godlygeek/tabular'
Plug 'plasticboy/vim-markdown'
" Themes
Plug 'sainnhe/edge'
Plug 'vim-airline/vim-airline-themes'

if L0th1HasProfile('dev')
  Plug 'Valloric/YouCompleteMe', { 'do': function('BuildYCM') }
  Plug 'w0rp/ale', { 'do': function('BuildALE') }
endif

" Overlay layers may add their own Plug lines.
for s:dir in L0th1OverlayDirs()
  if filereadable(s:dir . '/plugins.vim')
    execute 'source' fnameescape(s:dir . '/plugins.vim')
  endif
endfor

call plug#end()

" Section: Plugin settings {{{
let g:ale_linters = {
 \ 'typescript': ['eslint'],
 \ 'javascript': ['eslint'],
 \ 'c': [],
 \ 'cpp': [],
 \ }

let g:ale_fixers = {
 \ 'javascript': ['prettier_eslint'],
 \ 'markdown': ['prettier', 'remark-lint'],
 \ 'go': ['gofmt'],
 \ 'json': ['prettier'],
 \ 'typescript': ['prettier', 'tslint'],
 \ 'html': ['prettier'],
 \ 'python': ['autopep8'],
 \ 'c': ['clang-format'],
 \ 'cpp': ['clang-format'],
 \ 'rust': ['rustfmt'],
 \ 'sh': ['shfmt']
 \ }
let g:ale_cpp_clangcheck_executable = '/usr/local/opt/llvm/bin/clang-check'
let g:ale_javascript_eslint_options = '--cache --resolve-plugins-relative-to .'

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

let g:ycm_always_populate_location_list = 1


" }}}
