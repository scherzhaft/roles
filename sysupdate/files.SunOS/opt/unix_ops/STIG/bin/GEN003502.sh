#!/bin/bash -x

FIX="${*}"
test "X${FIX}" = "X" && FIX=`grep "^COREADM_GLOB_PATTERN=" /etc/coreadm.conf|awk -F\= {'print $2'}`

/usr/bin/coreadm -d log  #GEN003500
/usr/bin/coreadm -i /var/core/core.%f.%p  #GEN003501

sleep 1
TSTAMP=`perl -e 'print int(time)'`
SELF=`basename $0`
test "X${FIX}" != "X" && EXIST=`ls -d ${FIX} 2>/dev/null`

test "X${SELF}" != "X" -a "X${TSTAMP}" != "X" -a "X${EXIST}" != "X" && {
  chown root   ${EXIST}  ##GEN003502
}


