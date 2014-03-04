#!/bin/bash -e

#-----------------------------------------------------------------------
# Name........: ssl_cert_check.sh
# Code repo...: github.com/arildjensen/scripts
# Author......: Arild Jensen <ajensen@counter-attack.com>
# Purpose.....: Download and print out the SSL certificate for any website
# Dependencies: openssl
# Usage.......: Run as any user with one argument,
#               * Hostname of website (e.g., www.google.com)
#-----------------------------------------------------------------------


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

  openssl s_client -showcerts -connect $1:443 < /dev/null | openssl x509 -text

  exit 0 # Always exit properly
}

#-----------------------------------------------------------------------

check_arguments $# 1
main $@
