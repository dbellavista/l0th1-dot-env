" Language servers (yegappan/lsp, dev profile).
"   python:   ty (types, hover, goto, completion) + ruff (lint, format, fixes)
"   markdown: marksman (links, headings, references)
" Install: `uv tool install ty`, ruff, `brew install marksman`.
" Servers whose executable is missing are skipped. :LspShowAllServers to check.

if !L0th1HasProfile('dev')
  finish
endif

" With several servers on a filetype, the first one that supports a feature
" handles it, and diagnostics are merged. ruff must come first: with ty first,
" ruff's diagnostics get dropped (yegappan/lsp, Nov 2026). ruff's hover only
" explains noqa codes, so it is turned off and hover falls through to ty.
let s:servers = [
  \ #{name: 'ruff', filetype: ['python'], path: 'ruff', args: ['server'],
  \    features: #{hover: v:false}},
  \ #{name: 'ty', filetype: ['python'], path: 'ty', args: ['server']},
  \ #{name: 'marksman', filetype: ['markdown'], path: 'marksman', args: ['server']},
  \ ]

augroup l0th1_lsp
  autocmd!
  autocmd User LspSetup call LspOptionsSet(#{
    \ autoHighlightDiags: v:true,
    \ showDiagWithVirtualText: v:true,
    \ diagVirtualTextAlign: 'after',
    \ completionMatcher: 'fuzzy',
    \ showSignature: v:true,
    \ ignoreMissingServer: v:true,
    \ })
  autocmd User LspSetup call LspAddServer(filter(copy(s:servers), 'executable(v:val.path)'))
  autocmd User LspAttached call s:Mappings()
augroup END

function! s:Mappings() abort
  nnoremap <buffer> <silent> gd <Cmd>LspGotoDefinition<CR>
  nnoremap <buffer> <silent> gD <Cmd>LspPeekDefinition<CR>
  nnoremap <buffer> <silent> gr <Cmd>LspShowReferences<CR>
  nnoremap <buffer> <silent> K <Cmd>LspHover<CR>
  nnoremap <buffer> <silent> [d <Cmd>LspDiag prevWrap<CR>
  nnoremap <buffer> <silent> ]d <Cmd>LspDiag nextWrap<CR>
  nnoremap <buffer> <silent> <leader>d <Cmd>LspDiag show<CR>
  nnoremap <buffer> <silent> <leader>rn <Cmd>LspRename<CR>
  nnoremap <buffer> <silent> <leader>ca <Cmd>LspCodeAction<CR>
  nnoremap <buffer> <silent> <leader>s <Cmd>LspDocumentSymbol<CR>
  nnoremap <buffer> <silent> <C-Q> <Cmd>LspFormat<CR>
  xnoremap <buffer> <silent> <C-Q> :LspFormat<CR>
endfunction
