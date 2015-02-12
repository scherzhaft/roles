#!/bin/bash -x

exit 0

FIX="${*}"
test "X${FIX}" = "X" && FIX='/etc/audit/audit.rules'
sleep 1
TSTAMP=`date +%Y-%m-%d_%H:%M:%S`
SELF=`basename $0`
MISSINGRULES=''
LCHOWN32RULE="-a always,exit -F arch=b32 -S lchown"
LCHOWN64RULE="-a always,exit -F arch=b64 -S lchown32"



test "X${SELF}" = "X" -o "X${TSTAMP}" = "X" -o "X${FIX}" = "X" && exit

grep  -- "^-a .*always,exit .*-F .*arch=b32 .*-S .*lchown" ${FIX} >/dev/null
if [ "X${?}" = "X0" ] ; then
  echo "already has ${LCHOWN32RULE}"
else
  MISSINGRULES="${MISSINGRULES}
${LCHOWN32RULE}"
fi  

grep  -- "^-a .*always,exit .*-F .*arch=b64 .*-S .*lchown32" ${FIX} >/dev/null
if [ "X${?}" = "X0" ] ; then
  echo "already has ${LCHOWN64RULE}"
else
  MISSINGRULES="${MISSINGRULES}
${LCHOWN64RULE}"
fi  

MISSINGRULES=`echo "${MISSINGRULES}"|grep '.'`
if [ "X${MISSINGRULES}" != "X" ] ; then
  cp ${FIX} ${FIX}.pre${SELF}.${TSTAMP}
  echo "${MISSINGRULES}" >> ${FIX}
  diff -u ${FIX}.pre${SELF}.${TSTAMP} ${FIX}
  diff -u ${FIX}.pre${SELF}.${TSTAMP} ${FIX} > ${FIX}.${SELF}.${TSTAMP}.patch
fi

