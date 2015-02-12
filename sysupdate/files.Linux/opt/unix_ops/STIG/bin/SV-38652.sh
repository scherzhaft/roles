#!/bin/bash -x

FIX="${*}"
test "X${FIX}" = "X" && FIX='/etc/audit/audit.rules'
sleep 1
TSTAMP=`date +%Y-%m-%d_%H:%M:%S`
SELF=`basename $0`
MISSINGRULES=''
DEL32RULE="-a exit,always -F arch=b32 -S rmdir"
DEL64RULE="-a exit,always -F arch=b64 -S rmdir"

test "X${SELF}" = "X" -o "X${TSTAMP}" = "X" -o "X${FIX}" = "X" && exit

grep  -- "^-a .*exit,always .*-F .*arch=b32 .*-S .*rmdir" ${FIX} >/dev/null
if [ "X${?}" = "X0" ] ; then
  echo "already has ${DEL32RULE}"
else
  MISSINGRULES="${MISSINGRULES}
${DEL32RULE}"
fi  

grep  -- "^-a .*exit,always .*-F .*arch=b64 .*-S .*rmdir" ${FIX} >/dev/null
if [ "X${?}" = "X0" ] ; then
  echo "already has ${DEL64RULE}"
else
  MISSINGRULES="${MISSINGRULES}
${DEL64RULE}"
fi  

MISSINGRULES=`echo "${MISSINGRULES}"|grep '.'`
if [ "X${MISSINGRULES}" != "X" ] ; then
  cp ${FIX} ${FIX}.pre${SELF}.${TSTAMP}
  echo "${MISSINGRULES}" >> ${FIX}
  diff -u ${FIX}.pre${SELF}.${TSTAMP} ${FIX}
  diff -u ${FIX}.pre${SELF}.${TSTAMP} ${FIX} > ${FIX}.${SELF}.${TSTAMP}.patch
fi

