

"" Mappings

map <Leader>todo :vsp ~/.todo/todo.md<CR>|        " Open todo list in vsplit
map <Leader>htodo :sp ~/.todo/todo.md<CR>|        " Open todo list in split
map <Leader>id :r! date +\%Y\%m\%d\%H\%M\%S<CR>kJA<space><space>|     " create ID
map <leader>vv :call ViewTodo('v')<CR>|          " Open todo in vsplit
map <leader>vh :call ViewTodo()<CR>|          " Open todo in split
map <leader>vd :silent call CompleteTodo()<CR>|   " Complete Todo


"" Globals

let s:home = '/home/howlin/.todo/'
let s:done_file = 'done/done.md'


"" Todo Functions

" Remove whitespace from string
function! Strip(input_string)
    return substitute(a:input_string, '^\s*\(.\{-}\)\s*$', '\1', '')
endfunction

" Take an indefinite amount of whitespace as list delimiter
function! StringToList(input_string)
    let list = split(a:input_string, '  ')
    let stripped_list = map(list, 'Strip(v:val)')
    return filter(stripped_list, 'v:val != ""')
endfunction

" Create new Todo with title from TodoLi
function! NewTodo(title)
    call append(0, '# ' . a:title)
    call append(1, '')
    exec ':startinsert'
endfunction

" Open or create Todo in vertical or horizontal split
function! ViewTodo(axis)
    let todo_string = getline('.')
    let todo_id = StringToList(todo_string)[0]
    let todo_path = s:home . todo_id

    " Create Todo if one does not yet exist
    if todo_string[21] != '*'
        call cursor('.', 22)
        exec "normal! r*0"
        let todo_label = StringToList(getline('.'))[3]
        exec ':'.a:axis.'sp ' . todo_path
        call NewTodo(todo_label)
    else
        exec ':'.a:axis.'sp ' . todo_path
    endif
endfunction

" Move Todo from root to archive dir
function! ArchiveTodo(todo_id)
    let todo_path = s:home.a:todo_id
    let archive_path = s:home.'done/'.a:todo_id
    exec "silent !"."mv "todo_path." ".archive_path
endfunction

" Move TodoLi from Index to archive index
function! ArchiveTodoLi(todo_id)
    call search(a:todo_id)
    let todo_li = getline('.')
    let timestamp = systemlist('date +\%Y\%m\%d\%H\%M\%S')[0]
    let done_li = timestamp.'  '.todo_li
    let done_path = s:home.s:done_file
    exec line('.') 'delete _'
    exec writefile([done_li], done_path, "a")
endfunction

" Archive Todo and TodoLi from Index or Todo
function! CompleteTodo()
    if expand('%:t') == 'todo.md'
        let todo_id = StringToList(getline('.'))[0]
        call ArchiveTodo(todo_id)
        call ArchiveTodoLi(todo_id)
    else
        let todo_id = expand('%:t')
        call ArchiveTodo(todo_id)
        exec ":q"
        call ArchiveTodoLi(todo_id)
    endif
endfunction
