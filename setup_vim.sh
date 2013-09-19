#!/bin/bash -e

#-----------------------------------------------------------------------
# Name.....: setup_vim.sh
# Code repo: github.com/arildjensen/scripts
# Author...: Arild Jensen <ajensen@counter-attack.com>
# Purpose  : Sets up ~/.vim just the way I like it.

# Usage....: Run as non-root with no arguments,
#-----------------------------------------------------------------------


# Setup debugging functionality. If you want verbose output prepend the
# command with _DEBUG="on"

DEBUG ()
{
  [ "$_DEBUG" = "on" ] && $@
}

# Setup logging functionality. Unless you're doing trivial stuff you
# should log to the system log.

LOG ()
{
  LOGBIN=`which logger`
    [ -n "$LOGBIN" ] && $LOGBIN "$0 $@"
}


# Setup standard functions to check for userid (useful if you need to
# run as root or other specific user) and for correct number of arguments.

check_userid ()
{
  # Check userid is correct
  if [ "$(id -nu)" = 'root' ]; then
    echo "This script must not be run as root" 1>&2
    exit 1
  fi
}

check_arguments ()
{
  # Check correct number of arguments
  if [ $1 != 0 ]; then
    echo "Incorrect number of arguments: $0" 1>&2
    exit 1
  fi
}

#-----------------------------------------------------------------------

vim_skel () {
	if [ ! -d ~/git ]; then
		mkdir ~/git
  fi

	if [ ! -d ~/git/dot-files/.git ]; then
		git clone https://github.com/arildjensen/dot-files ~/git/dot-files
  fi

	cp ~/git/dot-files/vimrc ~/.vimrc
	
	if [ ! -d ~/.vim/bundle ]; then
		mkdir -p ~/.vim/bundle
  fi;
}

vundle ()
{
	if [ ! -d ~/.vim/bundle/vundle/.git ]; then
  	git clone https://github.com/gmarik/vundle.git ~/.vim/bundle/vundle
	fi
}

main ()
{
  vim_skel
  vundle
  exit 0 # Always exit properly
}

#-----------------------------------------------------------------------

check_userid 
check_arguments $#
main $@
