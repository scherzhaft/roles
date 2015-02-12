#!/bin/bash -x

FIX="${*}"
test "X${FIX}" = "X" && FIX='/etc/ssh/sshd_config'
sleep 1
OSNAME=`uname -s`
TSTAMP=`perl -e 'print int(time)'`
SELF=`basename $0`
MISSINGRULES=''
COMPRESSION="Compression delayed"
test "X${OSNAME}" != "XLinux" && COMPRESSION="Compression no"

test "X${SELF}" = "X" -o "X${TSTAMP}" = "X" -o "X${FIX}" = "X" && exit

grep "^${COMPRESSION}$" ${FIX} >/dev/null
if [ "X${?}" = "X0" ] ; then
  echo "already has ${COMPRESSION}"
else
  MISSINGRULES="${MISSINGRULES}
${COMPRESSION}"
fi  

MISSINGRULES=`echo "${MISSINGRULES}"|grep '.'`
if [ "X${MISSINGRULES}" != "X" ] ; then
  cp ${FIX} ${FIX}.pre${SELF}.${TSTAMP}
  grep -v  "^Compression[\ ]?*" ${FIX}.pre${SELF}.${TSTAMP} > ${FIX}
  echo "${MISSINGRULES}" >> ${FIX}
  diff -u ${FIX}.pre${SELF}.${TSTAMP} ${FIX}
  diff -u ${FIX}.pre${SELF}.${TSTAMP} ${FIX} > ${FIX}.${SELF}.${TSTAMP}.patch
fi

