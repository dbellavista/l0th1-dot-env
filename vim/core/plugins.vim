" Plugins via vim-plug (vendored in autoload/plug.vim).
" Base plugins load everywhere. Plugins with a build step need the `dev` profile.
" Install/update: `l0th1 install --plugins` / `l0th1 update --plugins`, or :PlugInstall.

function! BuildYCM(info)
  if a:info.status == 'installed' || a:info.force
    !./install.py --ts-completer --omnisharp-completer --clang-completer --gocode-completer
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
Plug 'aperezdc/vim-template'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'saltstack/salt-vim'
Plug 'bling/vim-airline'
Plug 'pangloss/vim-javascript'
Plug 'elzr/vim-json'
Plug 'dag/vim-fish'
Plug 'leafgarland/typescript-vim'
Plug 'tyrannicaltoucan/vim-quantum'
Plug 'derekwyatt/vim-scala'
Plug 'scrooloose/nerdtree'
Plug 'vim-scripts/SyntaxRange'
Plug 'tpope/vim-unimpaired'
Plug 'Matt-Deacalion/vim-systemd-syntax'
Plug 'briancollins/vim-jst'
Plug 'tmhedberg/SimpylFold'
Plug 'PProvost/vim-ps1'
Plug 'lambdalisue/suda.vim'
Plug 'godlygeek/tabular'
Plug 'rust-lang/rust.vim'
Plug 'plasticboy/vim-markdown'
Plug 'Glench/Vim-Jinja2-Syntax'
Plug 'tidalcycles/vim-tidal'
" Themes
Plug 'tlhr/anderson.vim'
Plug 'sainnhe/edge'
Plug 'altercation/vim-colors-solarized'
Plug 'vim-airline/vim-airline-themes'

if L0th1HasProfile('dev')
  Plug 'Valloric/YouCompleteMe', { 'do': function('BuildYCM') }
  Plug 'w0rp/ale', { 'do': function('BuildALE') }
  Plug 'heavenshell/vim-jsdoc', {
    \ 'for': ['javascript', 'javascript.jsx', 'typescript'],
    \ 'do': 'make install'
    \ }
endif

" Private layers may add their own Plug lines.
for s:dir in L0th1PrivateDirs()
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
 \ 'xml': ['xmllint', 'prettier'],
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

let g:ycm_extra_conf_globlist = ['~/Documents/BlackMagic/*', '~/Documents/Personal/Projects/challenges/*', '!/*']
let g:ycm_always_populate_location_list = 1

let g:javascript_plugin_jsdoc = 1
let g:jsdoc_underscore_private = 1
let g:jsdoc_access_descriptions = 2
let g:jsdoc_enable_es6 = 1
let g:jsdoc_tags = {} | let g:jsdoc_tags['extends'] = 'augments'

let g:templates_no_autocmd = 0
let g:templates_directory = g:l0th1_vim . '/templates'
let g:templates_user_variables = [['AUTHOR', 'GetAuthor']]
function! GetAuthor()
  return 'Daniele Bellavista'
endfunction
" }}}
