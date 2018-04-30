

"" Globals

if !exists('g:splitbelow')
    setlocal splitbelow
endif

if !exists('g:splitright')
    setlocal splitright
endif

let s:root = '/home/howlin/.todo/'
let s:suffix = '.todo'
let s:archive = s:root.'archive/'
let s:cards = s:root.'cards/'
let s:archive_index = s:archive.'archive_index'.s:suffix


"" Mappings

if !exists('g:todo_map_keys')
    let g:todo_map_keys = 1
endif

if !exists('g:todo_map_prefix')
    let g:todo_map_prefix = 't'
endif

exec 'autocmd BufRead,BufNewFile *'.s:suffix.' set filetype=todo'

" Create new TodoLi
exec 'autocmd FileType todo nnoremap' g:todo_map_prefix.'n' ':call NewTodoLi()<CR>'
" Create or modify a Todo Card
exec 'autocmd FileType todo nnoremap' g:todo_map_prefix.'m' ':call ViewTodoCard()<CR>'
" Archive a Todo
exec 'autocmd FileType todo nnoremap' g:todo_map_prefix.'a' ':silent call CompleteTodo()<CR>'


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

" Check if passed string is a valid TodoLi
function Valid(todo_line)
    if a:todo_line =~# '^\d\{14}\s\{2}\w\{3}\s\{2}[* ]\s\{2}'
        return 1
    else 
        return 0
    endif
endfunction

function! GetTimeStamp()
    return systemlist('date +\%Y\%m\%d\%H\%M\%S')[0]
endfunction

" Move Todo Card from root to archive dir
function! ArchiveTodoCard(todo_card)
    exec 'silent !'.'mv 's:cards.a:todo_card.' '.s:archive.a:todo_card
endfunction

" Move TodoLi from Index to archive index
function! ArchiveTodoLi(todo_id)
    call search(a:todo_id)
    let todo_li = getline('.')
    let timestamp = GetTimeStamp()
    let done_li = timestamp.'  '.todo_li
    exec line('.') 'delete _'
    exec writefile([done_li], s:archive_index, "a")
endfunction

" Create new Todo Card with title from TodoLi
function! NewTodoCard(title)
    let underline = ''
    while len(underline) < len(a:title)
        let underline = underline.'='
    endwhile
    call append(0, a:title)
    call append(1, underline)
    call append(2, '')
    exec ':startinsert'
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
    let axis = GetSplitDirection()
    let todo_string = getline('.')
    let todo_list = StringToList(todo_string)
    let todo_id = todo_list[0]
    let todo_path =  s:cards . todo_id . s:suffix

    " If cursor is not under valid TodoLi, abort function
    if !Valid(todo_string)
        echo 'ERROR: No Todo Card found! Double check cursor position.'
        return
    endif

    " Open Todo Card
    if todo_string[21] == '*'
        exec ':'.axis.'sp ' . todo_path
    else
        " Or create Card if one does not yet exist
        call cursor('.', 22)
        exec "normal! r*0"
        let todo_label = todo_list[2]
        exec ':'.axis.'sp ' . todo_path
        call NewTodoCard(todo_label)
    endif
endfunction

" Archive Todo Card and TodoLi from Index or Todo Card
function! CompleteTodo()
    let todo_id = StringToList(getline('.'))[0]
    let todo_card = todo_id.s:suffix
    call ArchiveTodoCard(todo_card)
    call ArchiveTodoLi(todo_id)
endfunction
