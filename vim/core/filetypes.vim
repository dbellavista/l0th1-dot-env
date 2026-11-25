" Per-language settings.

let g:markdown_fenced_languages = ['python', 'bash=sh', 'sh', 'json', 'yaml', 'toml', 'vim', 'diff']
let g:markdown_folding = 1

augroup l0th1_filetypes
  autocmd!
  autocmd FileType vim setlocal foldmethod=marker
  autocmd FileType go setlocal ts=2 sts=2 sw=2 noexpandtab
  " Soft wrap: agents write one paragraph per line, hard wrapping would reflow it.
  autocmd FileType markdown setlocal textwidth=0 colorcolumn= wrap linebreak breakindent foldlevel=99
  autocmd FileType python setlocal foldnestmax=2
let g:markdown_fenced_languages = ['python', 'bash=sh', 'sh', 'json', 'yaml', 'toml', 'vim', 'diff']
let g:markdown_folding = 1

augroup END
