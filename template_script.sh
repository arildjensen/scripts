#!/bin/bash -e

#-----------------------------------------------------------------------
# Name........: template_script.sh
# Code repo...: github.com/arildjensen/scripts
# Author......: Arild Jensen <ajensen@counter-attack.com>
# Purpose.....: Serves as a sample or template script on which to build
#               new bash scripts.
# Dependencies:
# Usage.......: Run as user 'arild' with two arguments,
#               * first arg (e.g,. abc)
#               * second arg (e.g., xyz
#-----------------------------------------------------------------------


# Setup logging functionality. Unless you're doing trivial stuff you
# should log to the system log.

LOG ()
{
  command -v logger > /dev/null 2>&1 && $LOGBIN "$0 $@"
}


# Setup standard functions to check for userid (useful if you need to
# run as root or other specific user) and for correct number of arguments.

is_user ()
{
  # Check userid is correct
  if [ "$(id -nu)" != $1 ]; then
    echo "This script must be run as $1" 1>&2
    exit 1
  fi
}

is_not_user ()
{
  if [ "$(id -nu)" = $1 ]; then
    echo "This script must NOT be run as $1" 1>&2
    exit 1
  fi
}

check_arguments ()
{
  # Check correct number of arguments
  if [ $1 != $2 ]; then
    echo "Incorrect number of arguments: $1. Correct number is $2." 1>&2
    exit 1
  fi
}

#-----------------------------------------------------------------------

main ()
{
  FIRSTARG=$1
  SECONDARG=$2

  # Print out arguments
  echo "First argument was $FIRSTARG and the second was $SECONDARG."
  DEBUG echo "Debugging feature was enabled."

  exit 0 # Always exit properly
}

#-----------------------------------------------------------------------

is_not_user "root"
check_arguments $# 2
main $@
