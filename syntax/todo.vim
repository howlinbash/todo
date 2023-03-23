" Todo syntax
" Language:    Todo
" Maintainer:  Howlin Bash <howlinbash@posteo.de>

if version < 600
  syntax clear
elseif exists("b:current_syntax")
  finish
endif

if !exists("main_syntax")
  let main_syntax = 'markdown'
endif

" ru! syntax/markdown.vim
" unlet b:current_syntax

syn match   h1 '^=\+'
syn match   h2 '^-\+'
syn match   h3 '^#\+'
syn match   list '^* '
syn match   id '^\d\{14}\s' conceal cchar=☐
syn match   id '^\d\{14}\*' conceal cchar=⚀
syn match   id '^\d\{14}\s\s\d\{14}\s' conceal cchar=☒
syn match   id '^\d\{14}\s\s\d\{14}\*' conceal cchar=☑
syn match   todolink '\w*\.todo' contains=todosuffix
syn match   todosuffix '\.todo' conceal
syn match   box1 '☐'
syn match   box2 '⚀'
hi Conceal ctermbg=none ctermfg=081
hi link todolink Underlined
hi h1 ctermfg=209
hi h2 ctermfg=209
hi h3 ctermfg=209
hi list ctermfg=209

setlocal conceallevel=1
setlocal concealcursor=nvi
" let b:current_syntax = 'todo'
