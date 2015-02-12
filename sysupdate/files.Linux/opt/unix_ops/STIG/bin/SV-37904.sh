#!/bin/bash -x

FIX="${*}"
test "X${FIX}" = "X" && FIX='/etc/ssh/sshd_config'
sleep 1
TSTAMP=`date +%Y-%m-%d_%H:%M:%S`
SELF=`basename $0`
MISSINGRULES=''
PRIVSEP="UsePrivilegeSeparation yes"


test "X${SELF}" = "X" -o "X${TSTAMP}" = "X" -o "X${FIX}" = "X" && exit

grep "^UsePrivilegeSeparation[\ ]*yes$" ${FIX} >/dev/null
if [ "X${?}" = "X0" ] ; then
  echo "already has ${PRIVSEP}"
else
  MISSINGRULES="${MISSINGRULES}
${PRIVSEP}"
fi  

MISSINGRULES=`echo "${MISSINGRULES}"|grep '.'`
if [ "X${MISSINGRULES}" != "X" ] ; then
  cp ${FIX} ${FIX}.pre${SELF}.${TSTAMP}
  grep -v  "^UsePrivilegeSeparation[\ ]?*" ${FIX}.pre${SELF}.${TSTAMP} > ${FIX}
  echo "${MISSINGRULES}" >> ${FIX}
  diff -u ${FIX}.pre${SELF}.${TSTAMP} ${FIX}
  diff -u ${FIX}.pre${SELF}.${TSTAMP} ${FIX} > ${FIX}.${SELF}.${TSTAMP}.patch
fi

