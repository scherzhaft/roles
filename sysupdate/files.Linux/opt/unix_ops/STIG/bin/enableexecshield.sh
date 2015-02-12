#!/bin/bash -x

FIX="${*}"
test "X${FIX}" = "X" && FIX='/etc/sysctl.conf'
sleep 1
TSTAMP=`perl -e 'print int(time)'`
SELF=`basename $0`
MISSINGRULES=''
EXECSHIELD="kernel.exec-shield = 1"


test "X${SELF}" = "X" -o "X${TSTAMP}" = "X" -o "X${FIX}" = "X" && exit

grep "^kernel.exec-shield[\ ].*=[\ ].*1$" ${FIX} >/dev/null
if [ "X${?}" = "X0" ] ; then
  echo "already has ${EXECSHIELD}"
else
  MISSINGRULES="${MISSINGRULES}
${EXECSHIELD}"
fi  

MISSINGRULES=`echo "${MISSINGRULES}"|grep '.'`
if [ "X${MISSINGRULES}" != "X" ] ; then
  cp ${FIX} ${FIX}.pre${SELF}.${TSTAMP}
  grep -v  "^kernel.exec-shield[\ ].*" ${FIX}.pre${SELF}.${TSTAMP} > ${FIX}
  echo "${MISSINGRULES}" >> ${FIX}  ##RHEL-06-000079
  diff -u ${FIX}.pre${SELF}.${TSTAMP} ${FIX}
  diff -u ${FIX}.pre${SELF}.${TSTAMP} ${FIX} > ${FIX}.${SELF}.${TSTAMP}.patch
fi

