#!/bin/bash -x

FIX="${*}"
test "X${FIX}" = "X" && FIX='/dev/audio'


sleep 1
TSTAMP=`perl -e 'print int(time)'`
SELF=`basename $0`
test "X${FIX}" != "X" && EXIST=`ls -d ${FIX} 2>/dev/null`

test "X${SELF}" != "X" -a "X${TSTAMP}" != "X" -a "X${EXIST}" != "X" && {
  chmod -R 0660 ${EXIST}  #GEN002320
  chmod A- ${EXIST}  #GEN002330
}


