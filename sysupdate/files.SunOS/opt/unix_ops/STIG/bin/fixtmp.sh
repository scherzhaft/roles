#!/bin/bash -x

FIX="${*}"
test "X${FIX}" = "X" && FIX='/tmp'


sleep 1
TSTAMP=`perl -e 'print int(time)'`
SELF=`basename $0`
test "X${FIX}" != "X" && EXIST=`ls -d ${FIX} 2>/dev/null`

test "X${SELF}" != "X" -a "X${TSTAMP}" != "X" -a "X${EXIST}" != "X" && {
  chgrp root ${EXIST}  #GEN002540
  chmod 1777 ${EXIST}  #GEN002500
  chown root ${EXIST}  #GEN002520
}


