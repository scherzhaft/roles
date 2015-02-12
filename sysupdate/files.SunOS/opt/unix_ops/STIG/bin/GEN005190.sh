#!/bin/bash -x

FIX="${*}"
test "X${FIX}" = "X" && FIX=`/usr/bin/find / \! -local -prune -o -name .Xauthority -print`

sleep 1
TSTAMP=`perl -e 'print int(time)'`
SELF=`basename $0`
test "X${FIX}" != "X" && EXIST=`ls -d ${FIX} 2>/dev/null`

test "X${SELF}" != "X" -a "X${TSTAMP}" != "X" -a "X${EXIST}" != "X" && {
  chmod A- ${EXIST}  #GEN005190
}

##GEN005220 ##GEN005240 ##GEN005160 ##yes our systems require Xauthority's


