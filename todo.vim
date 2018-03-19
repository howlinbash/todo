

"" Mappings

map <leader>ff :vsp <cfile><cr>p|              " create file
map <leader>hff :w\|:sp <cfile><cr>|              " create file
map <Leader>todo :vsp ~/.todo/todo.md<CR>|        " Open todo list in current session
map <Leader>htodo :sp ~/.todo/todo.md<CR>|        " H-Open todo list in current session
map <leader>done :call Done()<cr>|
map <Leader>id :r! date +\%Y\%m\%d\%H\%M\%S<CR>kJA|        " append date to line


"" Todo Functions

function! Done()
  let a:oldname = expand('%:p')
  let a:newname = expand('%:h').'/done/'.expand('%:t')
  exec "saveas " . a:newname 
  call delete(a:oldname) 
  exec ":q"
endfunction
