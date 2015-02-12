#!/bin/bash -x

FIX="${*}"
test "X${FIX}" = "X" && FIX='/etc/default/sulogin'

sleep 1
TSTAMP=`perl -e 'print int(time)'`
SELF=`basename $0`
test "X${FIX}" != "X" && EXIST=`ls -d ${FIX} 2>/dev/null`

test "X${SELF}" != "X" -a "X${TSTAMP}" != "X" -a "X${EXIST}" != "X" && {
  rm -f ${EXIST}  ##GEN000020
}


