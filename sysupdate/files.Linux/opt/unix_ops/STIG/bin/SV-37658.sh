#!/bin/bash -x

exit 0

FIX="${*}"
test "X${FIX}" = "X" && FIX='/etc/audit/audit.rules'
sleep 1
TSTAMP=`date +%Y-%m-%d_%H:%M:%S`
SELF=`basename $0`
MISSINGRULES=''
ADJTIME32RULE="-a exit,always -F arch=b32 -S adjtime"
ADJTIME64RULE="-a exit,always -F arch=b64 -S adjtime"

test "X${SELF}" = "X" -o "X${TSTAMP}" = "X" -o "X${FIX}" = "X" && exit

grep  -- "^-a .*exit,always .*-F .*arch=b32 .*-S .*adjtime" ${FIX} >/dev/null
if [ "X${?}" = "X0" ] ; then
  echo "already has ${ADJTIME32RULE}"
else
  MISSINGRULES="${MISSINGRULES}
${ADJTIME32RULE}"
fi  

grep  -- "^-a .*exit,always .*-F .*arch=b64 .*-S .*adjtime" ${FIX} >/dev/null
if [ "X${?}" = "X0" ] ; then
  echo "already has ${ADJTIME64RULE}"
else
  MISSINGRULES="${MISSINGRULES}
${ADJTIME64RULE}"
fi  

MISSINGRULES=`echo "${MISSINGRULES}"|grep '.'`
if [ "X${MISSINGRULES}" != "X" ] ; then
  cp ${FIX} ${FIX}.pre${SELF}.${TSTAMP}
  echo "${MISSINGRULES}" >> ${FIX}
  diff -u ${FIX}.pre${SELF}.${TSTAMP} ${FIX}
  diff -u ${FIX}.pre${SELF}.${TSTAMP} ${FIX} > ${FIX}.${SELF}.${TSTAMP}.patch
fi

