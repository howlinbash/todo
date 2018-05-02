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

ru! syntax/markdown.vim
unlet b:current_syntax

syn match   id '^\d\{14}\s' conceal cchar=☐
syn match   id '^\d\{14}\*' conceal cchar=⚀
syn match   id '^\d\{14}\s\s\d\{14}\s' conceal cchar=☒
syn match   id '^\d\{14}\s\s\d\{14}\*' conceal cchar=☑
syn match   todolink '\w*\.todo' contains=todosuffix
syn match   todosuffix '\.todo' conceal
hi Conceal ctermbg=none
hi link todolink Underlined

setlocal conceallevel=1
setlocal concealcursor=nvi
let b:current_syntax = 'todo'
