#!/bin/bash -x

FIX="${*}"
test "X${FIX}" = "X" && FIX='/etc/audit/audit.rules'
sleep 1
TSTAMP=`date +%Y-%m-%d_%H:%M:%S`
SELF=`basename $0`
MISSINGRULES=''
SCHEDPARAM32RULE="-a always,exit -F arch=b32 -S sched_setparam"
SCHEDPARAM64RULE="-a always,exit -F arch=b64 -S sched_setparam"



test "X${SELF}" = "X" -o "X${TSTAMP}" = "X" -o "X${FIX}" = "X" && exit

grep  -- "^-a .*always,exit .*-F .*arch=b32 .*-S .*sched_setparam" ${FIX} >/dev/null
if [ "X${?}" = "X0" ] ; then
  echo "already has ${SCHEDPARAM32RULE}"
else
  MISSINGRULES="${MISSINGRULES}
${SCHEDPARAM32RULE}"
fi  

grep  -- "^-a .*always,exit .*-F .*arch=b64 .*-S .*sched_setparam" ${FIX} >/dev/null
if [ "X${?}" = "X0" ] ; then
  echo "already has ${SCHEDPARAM64RULE}"
else
  MISSINGRULES="${MISSINGRULES}
${SCHEDPARAM64RULE}"
fi  

MISSINGRULES=`echo "${MISSINGRULES}"|grep '.'`
if [ "X${MISSINGRULES}" != "X" ] ; then
  cp ${FIX} ${FIX}.pre${SELF}.${TSTAMP}
  echo "${MISSINGRULES}" >> ${FIX}
  diff -u ${FIX}.pre${SELF}.${TSTAMP} ${FIX}
  diff -u ${FIX}.pre${SELF}.${TSTAMP} ${FIX} > ${FIX}.${SELF}.${TSTAMP}.patch
fi

