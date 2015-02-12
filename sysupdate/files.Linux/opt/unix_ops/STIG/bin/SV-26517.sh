#!/bin/bash -x

FIX="${*}"
test "X${FIX}" = "X" && FIX='/etc/audit/auditd.conf'
sleep 1
TSTAMP=`date +%Y-%m-%d_%H:%M:%S`
SELF=`basename $0`

test "X${SELF}" = "X" -o "X${TSTAMP}" = "X" -o "X${FIX}" = "X" && exit

grep  -- "^disk_error_action.*=.*SYSLOG$" ${FIX} >/dev/null
DONTNEED="$?"
test "X${DONTNEED}" = "X0" && exit

for i in `echo "${FIX}"` ; do
  cp ${i} ${i}.pre${SELF}.${TSTAMP}
  grep  -v  "^disk_error_action" ${i}.pre${SELF}.${TSTAMP} > ${i}
  echo 'disk_error_action = SYSLOG' >> ${i} 
  diff -u ${i}.pre${SELF}.${TSTAMP} ${i}
  diff -u ${i}.pre${SELF}.${TSTAMP} ${i} > ${i}.${SELF}.${TSTAMP}.patch
done
