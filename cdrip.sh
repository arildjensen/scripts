#!/bin/sh

#-----------------------------------------------------------------------
# Name.....: cdrip.sh
# Code repo: github.com/arildjensen/scripts
# Author...: Arild Jensen <ajensen@counter-attack.com>
# Purpose  : Rips CDs just the way I want it.

# Usage....: Run with no arguments.
#-----------------------------------------------------------------------

options="-a cddb,read,encode,tag,move,playlist,clean"
options="${options} -d /dev/cdrom"
options="${options} -o m4a"
options="${options} -V"
options="${options} -x"
options="${options} -p"
options="${options} -q high"

# First check if Atomic Parsley is installed. The cd ripper will run without
# it but we want it installed.
if [ ! $(command -v AtomicParsley) ] ; then
  echo >&2 "Missing Atomic Parsley package. Exiting."
  exit 1
fi

# Now rip into high quality AAC files with all the fixins'
abcde ${options}
