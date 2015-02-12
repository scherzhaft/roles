#!/bin/bash -x

FIX="${*}"
test "X${FIX}" = "X" && FIX='/etc/defaultrouter'

sleep 1
TSTAMP=`perl -e 'print int(time)'`
SELF=`basename $0`
test "X${FIX}" != "X" && EXIST=`ls -d ${FIX} 2>/dev/null`

test "X${SELF}" != "X" -a "X${TSTAMP}" != "X" -a "X${EXIST}" != "X" && {
  echo "yes, our systems have defaultrouters"  ##GEN005560  
  echo "we don't use ipv6" ##GEN007700 ##GEN007780 ##GEN007900 ##GEN005570
}


