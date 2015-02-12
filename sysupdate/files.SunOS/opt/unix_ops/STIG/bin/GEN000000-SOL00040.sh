#!/bin/bash -x

FIX="${*}"
test "X${FIX}" = "X" && FIX='/etc/security/audit_user'

sleep 1
TSTAMP=`perl -e 'print int(time)'`
SELF=`basename $0`
test "X${FIX}" != "X" && EXIST=`ls -d ${FIX} 2>/dev/null`

test "X${SELF}" != "X" -a "X${TSTAMP}" != "X" -a "X${EXIST}" != "X" && {
  perl -p -i.pre${SELF}.${TSTAMP} -e "s|(^[\w,\s,\:,\,]+[\#]*.*$)|##\1|g unless /(^[\s]*root:|^[\s]*#)/" ${EXIST}  ##GEN000000-SOL00040
}


