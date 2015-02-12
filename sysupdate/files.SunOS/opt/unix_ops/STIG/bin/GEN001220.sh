#!/bin/bash -x

FIX="${*}"
test "X${FIX}" = "X" && FIX=`find /bin /usr/bin /usr/lbin /usr/ucb /sbin /usr/sbin \! -type l `

sleep 1
TSTAMP=`perl -e 'print int(time)'`
SELF=`basename $0`
test "X${FIX}" != "X" && EXIST=`ls -d ${FIX} 2>/dev/null`

test "X${SELF}" != "X" -a "X${TSTAMP}" != "X" -a "X${EXIST}" != "X" && {
  chown root   ${EXIST}  ##GEN001220
}
