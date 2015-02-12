#!/bin/bash -x

FIX="${*}"
test "X${FIX}" = "X" && FIX='/etc/syslog.conf'
sleep 1
TSTAMP=`date +%Y-%m-%d_%H:%M:%S`
SELF=`basename $0`
grep -E "(authpriv.info;.*authpriv.none;|authpriv.none;.*authpriv.info)" ${FIX}
NEEDS="$?"

test "X${NEEDS}" != "X0" -a "X${SELF}" != "X" -a "X${TSTAMP}" != "X" -a "X${FIX}" != "X" && perl -p -i.pre${SELF}.${TSTAMP} -e 's|;authpriv.none;|;authpriv.info;authpriv.none;|' ${FIX}
