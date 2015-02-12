#!/bin/bash -x

exit 0

FIX="${*}"
test "X${FIX}" = "X" && FIX='/etc/audit/audit.rules'
sleep 1
TSTAMP=`date +%Y-%m-%d_%H:%M:%S`
SELF=`basename $0`
MISSINGRULES=''
FCHOWN32RULE="-a always,exit -F arch=b32 -S fchown"
FCHOWN64RULE="-a always,exit -F arch=b64 -S fchown32"



test "X${SELF}" = "X" -o "X${TSTAMP}" = "X" -o "X${FIX}" = "X" && exit

grep  -- "^-a .*always,exit .*-F .*arch=b32 .*-S .*fchown" ${FIX} >/dev/null
if [ "X${?}" = "X0" ] ; then
  echo "already has ${FCHOWN32RULE}"
else
  MISSINGRULES="${MISSINGRULES}
${FCHOWN32RULE}"
fi  

grep  -- "^-a .*always,exit .*-F .*arch=b64 .*-S .*fchown32" ${FIX} >/dev/null
if [ "X${?}" = "X0" ] ; then
  echo "already has ${FCHOWN64RULE}"
else
  MISSINGRULES="${MISSINGRULES}
${FCHOWN64RULE}"
fi  

MISSINGRULES=`echo "${MISSINGRULES}"|grep '.'`
if [ "X${MISSINGRULES}" != "X" ] ; then
  cp ${FIX} ${FIX}.pre${SELF}.${TSTAMP}
  echo "${MISSINGRULES}" >> ${FIX}
  diff -u ${FIX}.pre${SELF}.${TSTAMP} ${FIX}
  diff -u ${FIX}.pre${SELF}.${TSTAMP} ${FIX} > ${FIX}.${SELF}.${TSTAMP}.patch
fi

