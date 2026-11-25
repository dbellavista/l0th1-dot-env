" User commands and helper functions.

" Sessions {{{
fun! SessionQuit()
  execute 'mksession! .session.vim'
  execute 'qa'
endfunction
command! Q call SessionQuit()
" }}}

" HTML Entities {{{
" Escape/unescape & < > HTML entities in range (default current line).
function! HtmlEntities(line1, line2, action)
  let search = @/
  let range = 'silent ' . a:line1 . ',' . a:line2
  if a:action == 0  " must convert &amp; last
    execute range . 'sno/&lt;/</eg'
    execute range . 'sno/&gt;/>/eg'
    execute range . 'sno/&amp;/&/eg'
  else              " must convert & first
    execute range . 'sno/&/&amp;/eg'
    execute range . 'sno/</&lt;/eg'
    execute range . 'sno/>/&gt;/eg'
  endif
  nohl
  let @/ = search
endfunction
command! -range -nargs=1 Entities call HtmlEntities(<line1>, <line2>, <args>)
" }}}

" Formatting {{{
fun! DoFormat()
  let l:old_fdm = &foldmethod
  setlocal foldmethod=manual
  if &filetype == 'xml'
    write
  endif
  execute "ALEFix"
  let &foldmethod = l:old_fdm
endfunction

function! FormatEslint()
  let current_file = @%
  execute "up"
  execute "silent !./node_modules/.bin/eslint --fix '" . current_file . "' > /tmp/eslintlog"
  execute "redraw!"
endfunction
" }}}

" Javascript ES5 -> ES6 rewrite {{{
function! Es6fy()
  execute '%s/function(\([^)]*\))/(\1) =>/g'
  execute '%s/\(describe.*\), () =>/\1, function()/g'
  execute '%s/\(exports\..* =\) (\(.*\)) =>/\1 function(\2)/g'
  execute '%s/\(exports\..* =\) \(\w\+\) =>/\1 function(\2)/g'
  execute '%s/\.each(() =>/.each(function()/g'
  execute '%s/(\(\w\+\)) =>/\1 =>/g'
  execute '%s/for (var/for (let/g'
  execute '%s/var/const/g'
  execute '%s/const \(\w\+\);/let \1;/g'
  execute '%s/const \(\w\+\) = \(NaN\|false\|true\|null\|\d\+\);/let \1 = \2;/g'
  execute "v,\s*\*,s,\",',g"
endfunction
" }}}
