#!/bin/bash -x

FIX="${*}"
test "X${FIX}" = "X" && FIX=`grep "^DUMPADM_SAVDIR=" /etc/dumpadm.conf|awk -F\= {'print $2'}`

/usr/sbin/dumpadm -n  #GEN003510

sleep 1
TSTAMP=`perl -e 'print int(time)'`
SELF=`basename $0`
test "X${FIX}" != "X" && EXIST=`ls -d ${FIX} 2>/dev/null`

test "X${SELF}" != "X" -a "X${TSTAMP}" != "X" -a "X${EXIST}" != "X" && {
  chgrp root ${EXIST}  #GEN003521
  chmod 0700 ${EXIST}  #GEN003522
  chmod A- ${EXIST}  #GEN003523
}


