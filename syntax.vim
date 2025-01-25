" Todo syntax
" Language:    Todo
" Maintainer:  Howlin Bash <howlinbash@posteo.de>

if !exists("main_syntax")
  let main_syntax = 'markdown'
endif

" syn match  String       /^yellow$/
" syn match  Comment       /^grey$/ contains=mkdLink,mkdInlineURL,@Spell " grey italic
" syn match  Identifier       /^violet$/ contains=mkdLink,mkdInlineURL,@Spell " violet
" syn match  Function       /^blue$/ contains=mkdLink,mkdInlineURL,@Spell " blue
" syn match  Keyword       /^teal$/ contains=mkdLink,mkdInlineURL,@Spell " lightteal
" syn match  Constant       /^orange$/ contains=mkdLink,mkdInlineURL,@Spell " orange
" syn match  Error       /^red$/ contains=mkdLink,mkdInlineURL,@Spell " red
" syn match  LineNr       /^white$/ contains=mkdLink,mkdInlineURL,@Spell " white
" syn match  VertSplit       /^hidden$/ contains=mkdLink,mkdInlineURL,@Spell " Invisible grey
" syn match  WarningMsg       /^gold$/ contains=mkdLink,mkdInlineURL,@Spell " Gold

syn region Identifier       start="^\s*#"                   end="$" 
syn region Keyword       start="^\s*##"                  end="$"
syn match  Identifier       /^.\+\n=\+$/ contains=mkdLink,mkdInlineURL,@Spell
syn match  Keyword       /^.\+\n-\+$/ contains=mkdLink,mkdInlineURL,@Spell

syn match   h1 '^=\+'
syn match   Constant /^- /
syn match   Constant '^ *- '
syn match   id '^\d\{14}\s' conceal cchar=☐
syn match   id '^\d\{14}\*' conceal cchar=⚀
syn match   id '^\d\{14}\s\s\d\{14}\s' conceal cchar=☒
syn match   id '^\d\{14}\s\s\d\{14}\*' conceal cchar=☑
syn match   todolink '\w*\.todo' contains=todosuffix
syn match   todosuffix '\.todo' conceal
" syn match   box1 '☐'
" syn match   box2 '⚀'

highlight todoli guifg=red
" Extract the foreground color of a highlight group (e.g., 'Identifier')
let fg_color = synIDattr(synIDtrans(hlID('Function')), 'fg')

" Use the extracted color to define the Conceal group
if fg_color != ""
    execute 'highlight Conceal guifg=' . fg_color
endif

" hi link todolink Underlined
" hi link todolink Underlined
" hi h1 ctermbg=209
" hi h1 ctermfg=209
" hi h2 ctermfg=209
" hi h3 ctermfg=209
" hi list ctermfg=209

setlocal conceallevel=1
setlocal concealcursor=nvi
" let b:current_syntax = 'todo'
