#!/bin/bash -x

FIX="${*}"
test "X${FIX}" = "X" && FIX='/etc/security/limits.conf'
sleep 1
TSTAMP=`date +%Y-%m-%d_%H:%M:%S`
SELF=`basename $0`

test "X${SELF}" = "X" -o "X${TSTAMP}" = "X" -o "X${FIX}" = "X" && exit

grep  -- "^\*.*hard .*maxlogins .*30" ${FIX} >/dev/null
DONTNEED="$?"
test "X${DONTNEED}" = "X0" && exit

for i in `echo "${FIX}"` ; do
  cp ${i} ${i}.pre${SELF}.${TSTAMP}
  grep  -v  "^[^#].* maxlogins " ${i}.pre${SELF}.${TSTAMP} > ${i}
  echo '* hard maxlogins 30' >> ${i}  ##RHEL-06-000319
  diff -u ${i}.pre${SELF}.${TSTAMP} ${i}
  diff -u ${i}.pre${SELF}.${TSTAMP} ${i} > ${i}.${SELF}.${TSTAMP}.patch
done
