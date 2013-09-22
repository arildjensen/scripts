#!/bin/bash -e

#-----------------------------------------------------------------------
# Name.....: setup_vim.sh
# Code repo: github.com/arildjensen/scripts
# Author...: Arild Jensen <ajensen@counter-attack.com>
# Purpose  : Sets up ~/.vim just the way I like it.

# Usage....: Run with no arguments,
#-----------------------------------------------------------------------


vim_skel ()
{
  if [ ! -d ~/git ]
  then
    mkdir ~/git
  fi

  if [ ! -d ~/git/dot-files/.git ]
  then
    git clone https://github.com/arildjensen/dot-files ~/git/dot-files
  fi

  cp ~/git/dot-files/vimrc ~/.vimrc
  
  if [ ! -d ~/.vim/bundle ]
  then
    mkdir -p ~/.vim/bundle
  fi
}

#-----------------------------------------------------------------------

vundle ()
{
  lint_cmds=( puppet-lint checkbashisms )

  if [ ! -d ~/.vim/bundle/vundle/.git ]
  then
    git clone https://github.com/gmarik/vundle.git ~/.vim/bundle/vundle
  fi

  for i in "${lint_cmds[@]}"
  do
    command -v $i > /dev/null 2>&1 || 
    {
     echo >&2 "Warning: $i isn't on this system"
    }
  done
}

#-----------------------------------------------------------------------

main ()
{
  vim_skel
  vundle
  exit 0 # Always exit properly
}

#-----------------------------------------------------------------------

main $@
