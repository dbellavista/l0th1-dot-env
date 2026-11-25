" Per-language settings.

augroup l0th1_filetypes
  autocmd!
  autocmd FileType vim setlocal foldmethod=marker
  autocmd FileType go setlocal ts=2 sts=2 sw=2 noexpandtab
  autocmd FileType markdown setlocal tw=79 colorcolumn=80
augroup END
