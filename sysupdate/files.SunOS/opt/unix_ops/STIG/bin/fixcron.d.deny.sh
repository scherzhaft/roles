#!/bin/bash -x

FIX="${*}"
test "X${FIX}" = "X" && FIX='/etc/cron.d/*.deny'

sleep 1
TSTAMP=`perl -e 'print int(time)'`
SELF=`basename $0`
test "X${FIX}" != "X" && EXIST=`ls -d ${FIX} 2>/dev/null`

test "X${SELF}" != "X" -a "X${TSTAMP}" != "X" -a "X${EXIST}" != "X" && {
  chmod 600 ${EXIST}
  chown root:sys ${EXIST}
}
