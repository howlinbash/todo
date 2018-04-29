#!/bin/bash

function print_aliases() {
   for a in $(cat ~/.bash_aliases | grep todo/boards | cut -d '=' -f 1 | cut -d ' ' -f 2); do
       echo $a;
   done
}

if [ "$1" == "list" ]; then
    print_aliases
    exit 1
fi

function alias_exists_error() {
    echo 'Alias already exists, pick a new one'
    exit 1
}

if [[ $2 ]]; then
    # if alias already exists exit the program
    type $2 &>/dev/null && alias_exists_error
    echo "alias $2='cd ~/.todo/boards/$1 && $EDITOR index.todo'" >> ~/.bash_aliases
    echo "nmap <Leader>$2 :call DynamicSplit('~/.todo/boards/$1/index.todo')<CR>" >> ~/.vim/vimrc.d/mappings.vim
else
    type $1 &>/dev/null && alias_exists_error
    echo "alias $1='cd ~/.todo/boards/$1 && $EDITOR index.todo'" >> ~/.bash_aliases
    echo "nmap <Leader>$1 :call DynamicSplit('~/.todo/boards/$1/index.todo')<CR>" >> ~/.vim/vimrc.d/mappings.vim
fi

board=$1
len=${#board} 

i=1
while [ "$i" -le "$len" ]; do
    underline+="="
    i=$(($i + 1))
done

mkdir ~/.todo/boards/$board
cd ~/.todo/boards/$board
mkdir archive
touch index.todo archive/archive_index.todo
echo $board > index.todo
echo $underline >> index.todo
echo '' >> index.todo
$EDITOR index.todo
