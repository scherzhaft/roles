#!/bin/bash -x

FIX="${*}"
test "X${FIX}" = "X" && FIX='/etc/pam.d/*kshell'
sleep 1
TSTAMP=`date +%Y-%m-%d_%H:%M:%S`
SELF=`basename $0`

test "X${SELF}" = "X" -o "X${TSTAMP}" = "X" -o "X${FIX}" = "X" && exit

for i in `echo "${FIX}"` ; do
  perl -p -i.pre${SELF}.${TSTAMP} -e "s|^*.*pam_rhosts_auth\.so\n||g" ${i}
  diff -u ${i}.pre${SELF}.${TSTAMP} ${i}
  diff -u ${i}.pre${SELF}.${TSTAMP} ${i} > ${i}.${SELF}.${TSTAMP}.patch
done
