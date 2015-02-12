#!/bin/bash -x


##RHEL-06-000030  ##GEN000560


FIX="${*}"
test "X${FIX}" = "X" && FIX='/etc/pam.d/system-auth'
sleep 1
TSTAMP=`date +%Y-%m-%d_%H:%M:%S`
SELF=`basename $0`

test "X${SELF}" != "X" -a "X${TSTAMP}" != "X" -a "X${FIX}" != "X" && perl -p -i.pre${SELF}.${TSTAMP} -e "s|nullok||g" ${FIX}
