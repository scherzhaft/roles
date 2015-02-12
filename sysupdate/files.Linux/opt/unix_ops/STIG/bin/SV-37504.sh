#!/bin/bash -x

FIX="${*}"
test "X${FIX}" = "X" && FIX='/etc/mail/helpfile'
sleep 1
TSTAMP=`date +%Y-%m-%d_%H:%M:%S`
SELF=`basename $0`

test "X${SELF}" != "X" -a "X${TSTAMP}" != "X" -a "X${FIX}" != "X" && rm ${FIX}
