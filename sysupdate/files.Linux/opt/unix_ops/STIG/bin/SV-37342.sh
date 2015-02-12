#!/bin/bash -x

FIX="${*}"
test "X${FIX}" = "X" && FIX='/etc/securetty'
sleep 1
TSTAMP=`date +%Y-%m-%d_%H:%M:%S`
SELF=`basename $0`

test "X${SELF}" != "X" -a "X${TSTAMP}" != "X" -a "X${FIX}" != "X" && chmod 600 ${FIX}
