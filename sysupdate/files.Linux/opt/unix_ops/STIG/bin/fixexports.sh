#!/bin/bash -x

FIX="${*}"
test "X${FIX}" = "X" && FIX='/etc/exports'


sleep 1
TSTAMP=`perl -e 'print int(time)'`
SELF=`basename $0`
test "X${FIX}" != "X" && EXIST=`ls -d ${FIX} 2>/dev/null`

test "X${SELF}" != "X" -a "X${TSTAMP}" != "X" -a "X${EXIST}" != "X" && {
####  chmod A- ${EXIST}  #GEN005770
####}

  grep '.' ${EXIST}  && {  ##RHEL-06-000309
    echo "..found exports...please remove insecure_locks"
    echo "..and no 'all_squash'"  ##RHEL-06-000515
  }
}
