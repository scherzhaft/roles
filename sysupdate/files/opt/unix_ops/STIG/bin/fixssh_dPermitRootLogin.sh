#!/bin/bash -x

FIX="${*}"
test "X${FIX}" = "X" && FIX='/etc/ssh/sshd_config'
sleep 1
TSTAMP=`perl -e 'print int(time)'`
SELF=`basename $0`
MISSINGRULES=''
PERMITROOT="PermitRootLogin no"


test "X${SELF}" = "X" -o "X${TSTAMP}" = "X" -o "X${FIX}" = "X" && exit

grep "^PermitRootLogin[\ ].*no$" ${FIX} >/dev/null
if [ "X${?}" = "X0" ] ; then
  echo "already has ${PERMITROOT}"
else
  MISSINGRULES="${MISSINGRULES}
${PERMITROOT}"
fi  

MISSINGRULES=`echo "${MISSINGRULES}"|grep '.'`
if [ "X${MISSINGRULES}" != "X" ] ; then
  cp ${FIX} ${FIX}.pre${SELF}.${TSTAMP}
  grep -v  "^PermitRootLogin[\ ].*" ${FIX}.pre${SELF}.${TSTAMP} > ${FIX}
  echo "${MISSINGRULES}" >> ${FIX}  ##RHEL-06-000237
  diff -u ${FIX}.pre${SELF}.${TSTAMP} ${FIX}
  diff -u ${FIX}.pre${SELF}.${TSTAMP} ${FIX} > ${FIX}.${SELF}.${TSTAMP}.patch
fi

