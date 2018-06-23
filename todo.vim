

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
let s:boards = s:root.'boards/'
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
" Open Todo Board or Card
exec 'autocmd FileType todo nnoremap' g:todo_map_prefix.'o' ':call Open()<CR>'
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
    call append(0, '')
    call append(1, a:title)
    call append(2, underline)
    call append(3, '')
    exec ':startinsert'
endfunction

" Create new TodoLi
function! NewTodoLi()
    let timestamp = GetTimeStamp()
    exec ':put ='.timestamp
    exec 'normal! A    '
    exec ':startinsert'
endfunction

" Open or create Todo Card in vertical or horizontal split
function! ViewTodoCard(todo_string)
    let axis = GetSplitDirection()
    let todo_list = StringToList(a:todo_string)
    let todo_id = todo_list[0][0:13]
    let todo_path =  s:cards . todo_id . s:suffix

    " Open Todo Card
    if a:todo_string[14] == '*'
        exec ':'.axis.'sp ' . todo_path
    else
        " Or create Card if one does not yet exist
        call cursor('.', 15)
        exec "normal! r*0"
        let todo_label = todo_list[1]
        exec ':'.axis.'sp ' . todo_path
        call NewTodoCard(todo_label)
    endif
endfunction

" Archive Todo Card and TodoLi from Index or Todo Card
function! CompleteTodo()
    let todo_id = StringToList(getline('.'))[0][0:13]
    let todo_card = todo_id.s:suffix
    call ArchiveTodoCard(todo_card)
    call ArchiveTodoLi(todo_id)
endfunction

" Open Todo Board
function! OpenBoard()
    let axis = GetSplitDirection()
    normal! 0/.todoByW
    let board = expand('<cWORD>')
    exec ':'.axis.'sp ' . s:boards . board
endfunction

" Open Todo Board or Card
function! Open()
    let current_line = getline('.')
    if match(current_line, '^\d\{14}.\s\{2}') > -1
        call ViewTodoCard(current_line)
    elseif match(current_line, '\.todo') > -1
        call OpenBoard()
    else
        echo 'ERROR: No Todo found! Double check cursor position.'
        return
    endif
endfunction
