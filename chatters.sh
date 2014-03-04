#!/bin/sh

#-----------------------------------------------------------------------
# Name........: chatters.sh
# Code repo...: github.com/arildjensen/scripts
# Author......: Arild Jensen <ajensen@counter-attack.com>
# Purpose.....: Capture 1000 packets and list who is generating the most Internet traffic.
# Dependencies: sudo access to run tcpdump as root.
# Usage.......: Run with no arguments on NAT box.
#-----------------------------------------------------------------------

sudo /usr/sbin/tcpdump -i eth1 -f -n -c 1000 \
  not src net 192.168.0.0/16 and \
  not src net 10.0.0.0/8 and \
  not src net 172.16.0.0/24 \
  2>/dev/null |\
  awk '{print $5}' |\
  awk -F. '{print $1 "." $2 "." $3 "." $4 }' |\
  sort -n |\
  uniq -c |\
  sort -n
