#!/bin/bash -x

FIX="${*}"
test "X${FIX}" = "X" && FIX='/etc/audit/audit.rules'
sleep 1
TSTAMP=`date +%Y-%m-%d_%H:%M:%S`
SELF=`basename $0`
MISSINGRULES=''
SCHEDULER32RULE="-a always,exit -F arch=b32 -S sched_setscheduler"
SCHEDULER64RULE="-a always,exit -F arch=b64 -S sched_setscheduler"



test "X${SELF}" = "X" -o "X${TSTAMP}" = "X" -o "X${FIX}" = "X" && exit

grep  -- "^-a .*always,exit .*-F .*arch=b32 .*-S .*sched_setscheduler" ${FIX} >/dev/null
if [ "X${?}" = "X0" ] ; then
  echo "already has ${SCHEDULER32RULE}"
else
  MISSINGRULES="${MISSINGRULES}
${SCHEDULER32RULE}"
fi  

grep  -- "^-a .*always,exit .*-F .*arch=b64 .*-S .*sched_setscheduler" ${FIX} >/dev/null
if [ "X${?}" = "X0" ] ; then
  echo "already has ${SCHEDULER64RULE}"
else
  MISSINGRULES="${MISSINGRULES}
${SCHEDULER64RULE}"
fi  

MISSINGRULES=`echo "${MISSINGRULES}"|grep '.'`
if [ "X${MISSINGRULES}" != "X" ] ; then
  cp ${FIX} ${FIX}.pre${SELF}.${TSTAMP}
  echo "${MISSINGRULES}" >> ${FIX}
  diff -u ${FIX}.pre${SELF}.${TSTAMP} ${FIX}
  diff -u ${FIX}.pre${SELF}.${TSTAMP} ${FIX} > ${FIX}.${SELF}.${TSTAMP}.patch
fi

