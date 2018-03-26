

"" Mappings

map <Leader>todo :vsp ~/.todo/todo.md<CR>|        " Open todo list in vsplit
map <Leader>htodo :sp ~/.todo/todo.md<CR>|        " Open todo list in split
map <Leader>id :r! date +\%Y\%m\%d\%H\%M\%S<CR>kJA<space><space>|     " create ID
map <leader>vv :call ViewTodo(1, 1)<CR>|          " Open new todo in vsplit
map <leader>vh :call ViewTodo(0, 1)<CR>|          " Open new todo in split
map <leader>va :call ViewTodo(1, 0)<CR>|          " Open todo in vsplit
map <leader>vah :call ViewTodo(0, 0)<CR>|         " Open todo in split
map <leader>done :call Done()<cr>|                " File todo as completed

"" Todo Functions

function! Strip(input_string)
    return substitute(a:input_string, '^\s*\(.\{-}\)\s*$', '\1', '')
endfunction

function! Done()
    let oldname = expand('%:p')
    let newname = expand('%:h').'/done/'.expand('%:t')
    exec "saveas " . newname 
    call delete(oldname) 
    exec ":q"
endfunction

function! StringToList(input_string)
    let list = split(a:input_string, '  ')
    let stripped_list = map(list, 'Strip(v:val)')
    return filter(stripped_list, 'v:val != ""')
endfunction

function! NewTodo(title)
    call append(0, '# ' . a:title)
    call append(1, '')
    exec ':startinsert'
endfunction

function! ViewTodo(vsplit, create_todo)
    let todo = StringToList(getline('.'))
    let path = '~/.todo/' . todo[0]
    if a:vsplit
        exec ':vsp ' . path
    else
        exec ':sp ' . path
    endif
    if a:create_todo
        call NewTodo(todo[1])
    endif
endfunction
