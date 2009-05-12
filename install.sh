#! /bin/bash

source "../functions/functions"
RM=rm

stat_busy "Vim installation"

for dir in backup temp; do
  if [ ! -d vim/$dir ]; then
    mkdir vim/$dir
    printhl "$dir created"
  fi
done

for file in vimrc vim viminfo; do
  if [ -e ~/.$file ]; then
    $RM ~/.$file
  fi
  ln -s $PWD/$file ~/.$file
  printhl "$file linked"
done

stat_done
