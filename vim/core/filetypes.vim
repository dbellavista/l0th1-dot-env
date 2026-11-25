" Per-language settings.

" Section: Latex {{{
let g:tex_flavor = "luatex"
let g:Tex_DefaultTargetFormat='pdf'
let g:Tex_MultipleCompileFormats='pdf'
let g:Tex_CompileRule_pdf='lualatex -shell-escape -output-directory tmp/ $*.tex && mv ./tmp/*.pdf ./'
let g:Tex_BibtexFlavor = "bibtex"
let g:Tex_CompileRule_bib = g:Tex_BibtexFlavor . ' tmp/$*'
let g:tex_verbspell = 1
autocmd FileType latex inoremap <LocalLeader>d é
" }}}

" Section: VimScript {{{
autocmd FileType vim set foldmethod=marker
" }}}

" Section: XML {{{
autocmd BufNewFile,BufRead *.wxl set filetype=xml
autocmd BufNewFile,BufRead *.wxs set filetype=xml
autocmd BufNewFile,BufRead *.wxi set filetype=xml
autocmd FileType xml let b:ale_javascript_prettier_options = '--parser xml'
" }}}

" Section: C/C++ {{{
let g:C_IndentArguments = "-nbad -bap -nbc -bbo -hnl -br -brs -c33 -cd33 -ncdb -ce -ci4 -cli0 -d0 -di1 -nfc1 -i8 -ip0 -l80 -lp -npcs -nprs -npsl -sai -saf -saw -ncs -nsc -sob -nfca -cp33 -ss -ts8 -il1"
autocmd FileType c,cpp,cmake inoremap <F7> <Esc>:w<CR>:silent make \|redraw!\|cw<CR>
autocmd FileType c,cpp,cmake nnoremap <F7> :silent make \|redraw!\|cw<CR>
autocmd FileType c,cpp,cmake inoremap <F5> <Esc>:w<CR>:silent make -- install\|redraw!\|cw<CR>
autocmd FileType c,cpp,cmake nnoremap <F5> :silent make -- install\|redraw!\|cw<CR>
autocmd FileType c,cpp,cmake inoremap <F6> <Esc>:w<CR>:CMake<CR>i
autocmd FileType c,cpp,cmake nnoremap <F6> :CMake<CR>
" }}}

" Section: C# {{{
autocmd FileType cs nnoremap <F5> :wa!<cr>:OmniSharpBuildAsync<cr>
" }}}

" Section: Markdown {{{
autocmd FileType markdown setlocal tw=79
autocmd FileType markdown setlocal colorcolumn=80
" }}}

" Section: Go {{{
autocmd FileType go setlocal ts=2 sts=2 sw=2 noexpandtab
" }}}

" Section: Javascript {{{
autocmd FileType javascript :call IfTestFoldMoar()
function! IfTestFoldMoar()
  let s:v = expand('%')
  let s:ok = match(s:v, 'test/')
  if s:ok == 0
    set foldnestmax=5
  else
    set foldnestmax=7
  endif
endfunction
" }}}
