#!/bin/bash

root="$HOME/.todo"
board="$root/boards/$1.todo"
alias=$2
bashrc="$HOME/.bash_aliases"
vimrc="$HOME/.vim/vimrc.d/mappings.vim"

function print_aliases() {
   for a in $(cat $bashrc | grep todo/boards | cut -d '=' -f 1 | cut -d ' ' -f 2); do
       echo $a;
   done
}

function alias_exists_error() {
    echo 'Alias already exists, pick a new one'
    exit 1
}

function check_todo_is_uniq() {
   for a in $(cat $bashrc | grep todo/boards | cut -d '=' -f 1 | cut -d ' ' -f 2); do
       if [ "$a" == "$1" ]; then
           echo "Todo list already exists, pick a new alias or type '$1'"
           exit 1
       fi
   done
}


if [ "$1" == "list" ]; then
    print_aliases
    exit 1
fi

check_todo_is_uniq  $1

if [[ $alias ]]; then
    # if alias already exists exit the program
    type $alias &>/dev/null && alias_exists_error
    echo "alias $alias='\$EDITOR $board'" >> $bashrc
    echo "nmap <Leader>$alias :call DynamicSplit('$board')<CR>" >> $vimrc
else
    type $1 &>/dev/null && alias_exists_error
    echo "alias $1='\$EDITOR $board'" >> $bashrc
    echo "nmap <Leader>$1 :call DynamicSplit('$board')<CR>" >> $vimrc
fi

len=${#1} 
i=1
while [ "$i" -le "$len" ]; do
    underline+="="
    i=$(($i + 1))
done

touch $board
echo $1 > $board
echo $underline >> $board
echo '' >> $board
$EDITOR $board
