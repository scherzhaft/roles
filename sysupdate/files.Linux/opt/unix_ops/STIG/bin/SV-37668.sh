#!/bin/bash -x

exit 0

FIX="${*}"
test "X${FIX}" = "X" && FIX='/etc/audit/audit.rules'
sleep 1
TSTAMP=`date +%Y-%m-%d_%H:%M:%S`
SELF=`basename $0`
MISSINGRULES=''
CHOWN32RULE="-a always,exit -F arch=b32 -S chown"
CHOWN64RULE="-a always,exit -F arch=b64 -S chown32"



test "X${SELF}" = "X" -o "X${TSTAMP}" = "X" -o "X${FIX}" = "X" && exit

grep  -- "^-a .*always,exit .*-F .*arch=b32 .*-S .*chown" ${FIX} >/dev/null
if [ "X${?}" = "X0" ] ; then
  echo "already has ${CHOWN32RULE}"
else
  MISSINGRULES="${MISSINGRULES}
${CHOWN32RULE}"
fi  

grep  -- "^-a .*always,exit .*-F .*arch=b64 .*-S .*chown32" ${FIX} >/dev/null
if [ "X${?}" = "X0" ] ; then
  echo "already has ${CHOWN64RULE}"
else
  MISSINGRULES="${MISSINGRULES}
${CHOWN64RULE}"
fi  

MISSINGRULES=`echo "${MISSINGRULES}"|grep '.'`
if [ "X${MISSINGRULES}" != "X" ] ; then
  cp ${FIX} ${FIX}.pre${SELF}.${TSTAMP}
  echo "${MISSINGRULES}" >> ${FIX}
  diff -u ${FIX}.pre${SELF}.${TSTAMP} ${FIX}
  diff -u ${FIX}.pre${SELF}.${TSTAMP} ${FIX} > ${FIX}.${SELF}.${TSTAMP}.patch
fi

