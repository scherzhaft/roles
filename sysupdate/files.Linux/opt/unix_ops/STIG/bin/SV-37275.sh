#!/bin/bash -x

FIX="${*}"
test "X${FIX}" = "X" && FIX='/etc/profile.d/*'
sleep 1
TSTAMP=`date +%Y-%m-%d_%H:%M:%S`
SELF=`basename $0`
EXIST=`ls -d ${FIX} 2>/dev/null`

test "X${SELF}" != "X" -a "X${TSTAMP}" != "X" -a "X${EXIST}" != "X" && chmod 644 ${EXIST}
