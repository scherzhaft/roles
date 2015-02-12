#!/bin/bash -x

FIX="${*}"
test "X${FIX}" = "X" && FIX='/usr/aset/userlist'


sleep 1
TSTAMP=`perl -e 'print int(time)'`
SELF=`basename $0`
test "X${FIX}" != "X" && EXIST=`ls -d ${FIX} 2>/dev/null`

test "X${SELF}" != "X" -a "X${TSTAMP}" != "X" -a "X${EXIST}" != "X" && {
  chmod A- ${EXIST}  #GEN000000-SOL00270
  chmod 0600 ${EXIST}  #GEN000000-SOL00260
  chown root:root  ${EXIST}  #GEN000000-SOL00240  #GEN000000-SOL00250
}


