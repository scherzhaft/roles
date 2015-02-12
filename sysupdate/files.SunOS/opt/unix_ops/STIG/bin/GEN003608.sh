#!/bin/bash -x

FIX="${*}"

sleep 1
TSTAMP=`perl -e 'print int(time)'`
SELF=`basename $0`
EXIST=`arp -a|awk {'print $4'}|/bin/grep -v "L"|/bin/grep "P" `

test "X${SELF}" != "X" -a "X${TSTAMP}" != "X" -a "X${EXIST}" != "X" && {
  echo "...found static arp entry"  ##GEN003608
}
