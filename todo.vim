

"" Globals

if !exists('g:splitbelow')
    setlocal splitbelow
endif

if !exists('g:splitright')
    setlocal splitright
endif

let s:root = '/home/howlin/.todo/'
let s:index = 'todo.md'
let s:done_file = 'done/done.md'


"" Mappings

if !exists('g:todo_map_keys')
    let g:todo_map_keys = 1
endif

if !exists('g:todo_map_prefix')
    let g:todo_map_prefix = 't'
endif

" Open the Todo index
execute 'nnoremap <buffer>' g:todo_map_prefix.'o' ':call OpenTodoIndex()<CR>'
" Create new TodoLi
execute 'nnoremap <buffer>' g:todo_map_prefix.'n' ':call NewTodoLi()<CR>'
" Create or modify a Todo Card
execute 'nnoremap <buffer>' g:todo_map_prefix.'m' ':call ViewTodoCard()<CR>'
" Archive a Todo
execute 'nnoremap <buffer>' g:todo_map_prefix.'a' ':silent call CompleteTodo()<CR>'


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

" Split screen vertically or horizontally based on current window width
function! GetSplitDirection()
    if winwidth(0) < 120
        return ''
    else
        return 'v'
    endif
endfunction

" Create new Todo Card with title from TodoLi
function! NewTodoCard(title)
    call append(0, '# ' . a:title)
    call append(1, '')
    exec ':startinsert'
endfunction

" Move Todo Card from root to archive dir
function! ArchiveTodoCard(todo_id)
    let todo_path = s:root.a:todo_id
    let archive_path = s:root.'done/'.a:todo_id
    exec "silent !"."mv "todo_path." ".archive_path
endfunction

function! GetTimeStamp()
    return systemlist('date +\%Y\%m\%d\%H\%M\%S')[0]
endfunction

" Move TodoLi from Index to archive index
function! ArchiveTodoLi(todo_id)
    call search(a:todo_id)
    let todo_li = getline('.')
    let timestamp = GetTimeStamp()
    let done_li = timestamp.'  '.todo_li
    let done_path = s:root.s:done_file
    exec line('.') 'delete _'
    exec writefile([done_li], done_path, "a")
endfunction

" Open Todo Index in a vertical or horizontal split
function! OpenTodoIndex()
    let axis = GetSplitDirection()
    exec ':'.axis.'sp '.s:root.s:index
endfunction

" Create new TodoLi
function! NewTodoLi()
    let timestamp = GetTimeStamp()
    exec ':put ='.timestamp
    exec 'normal! A   '
    exec ':startinsert'
endfunction

" Open or create Todo Card in vertical or horizontal split
function! ViewTodoCard()
    let todo_string = getline('.')
    let todo_id = StringToList(todo_string)[0]
    let todo_path = s:root . todo_id
    let axis = GetSplitDirection()

    " Create Todo Card if one does not yet exist
    if todo_string[21] == '*'
        exec ':'.axis.'sp ' . todo_path
    else
        try
            call cursor('.', 22)
            exec "normal! r*0"
            let todo_label = StringToList(getline('.'))[3]
            exec ':'.axis.'sp ' . todo_path
            call NewTodoCard(todo_label)
        catch
            echo 'ERROR: no todo found to view!'
        endtry
    endif
endfunction

" Archive Todo Card and TodoLi from Index or Todo Card
function! CompleteTodo()
    if expand('%:t') == 'todo.md'
        let todo_id = StringToList(getline('.'))[0]
        call ArchiveTodoCard(todo_id)
        call ArchiveTodoLi(todo_id)
    else
        let todo_id = expand('%:t')
        call ArchiveTodoCard(todo_id)
        exec ":q"
        call ArchiveTodoLi(todo_id)
    endif
endfunction
