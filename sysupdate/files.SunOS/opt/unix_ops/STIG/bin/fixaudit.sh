#!/bin/bash -x

FIX="${*}"
test "X${FIX}" = "X" && FIX=`grep "^dir:" /etc/security/audit_control|awk -F\: {'print $2'}`

chmod A- /usr/sbin/auditd /usr/sbin/audit /usr/sbin/bsmrecord /usr/sbin/auditreduce /usr/sbin/praudit /usr/sbin/auditconfig  #GEN002718
chmod A- /etc/security/audit_user  #GEN000000-SOL00110

sleep 1
TSTAMP=`perl -e 'print int(time)'`
SELF=`basename $0`
test "X${FIX}" != "X" && EXIST=`ls -d ${FIX} 2>/dev/null`

test "X${SELF}" != "X" -a "X${TSTAMP}" != "X" -a "X${EXIST}" != "X" && {
  chmod -R A- ${EXIST}  #GEN002710
}


