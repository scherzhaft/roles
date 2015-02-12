#!/bin/bash -x


##RHEL-06-000126
FIX="${*}"
test "X${FIX}" = "X" && FIX='/etc/modprobe.conf'
sleep 1
TSTAMP=`date +%Y-%m-%d_%H:%M:%S`
SELF=`basename $0`
MISSINGRULES=''
RDSOFF="install rds /bin/true"


test "X${SELF}" = "X" -o "X${TSTAMP}" = "X" -o "X${FIX}" = "X" && exit

grep "^install .*rds .*/bin/true$" ${FIX} >/dev/null
if [ "X${?}" = "X0" ] ; then
  echo "already has ${RDSOFF}"
else
  MISSINGRULES="${MISSINGRULES}
${RDSOFF}"
fi  

MISSINGRULES=`echo "${MISSINGRULES}"|grep '.'`
if [ "X${MISSINGRULES}" != "X" ] ; then
  cp ${FIX} ${FIX}.pre${SELF}.${TSTAMP}
  grep -v  "^install .*rds .*" ${FIX}.pre${SELF}.${TSTAMP} > ${FIX}
  echo "${MISSINGRULES}" >> ${FIX}
  diff -u ${FIX}.pre${SELF}.${TSTAMP} ${FIX}
  diff -u ${FIX}.pre${SELF}.${TSTAMP} ${FIX} > ${FIX}.${SELF}.${TSTAMP}.patch
fi

