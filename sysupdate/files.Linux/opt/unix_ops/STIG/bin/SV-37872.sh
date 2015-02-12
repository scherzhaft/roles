#!/bin/bash -x

FIX="${*}"
test "X${FIX}" = "X" && FIX='/etc/ssh/sshd_config'
sleep 1
TSTAMP=`date +%Y-%m-%d_%H:%M:%S`
SELF=`basename $0`
MISSINGRULES=''
KERBEROSAUTHAPI="KerberosAuthentication no"


test "X${SELF}" = "X" -o "X${TSTAMP}" = "X" -o "X${FIX}" = "X" && exit

grep "^KerberosAuthentication[\ ]*no$" ${FIX} >/dev/null
if [ "X${?}" = "X0" ] ; then
  echo "already has ${KERBEROSAUTHAPI}"
else
  MISSINGRULES="${MISSINGRULES}
${KERBEROSAUTHAPI}"
fi  

MISSINGRULES=`echo "${MISSINGRULES}"|grep '.'`
if [ "X${MISSINGRULES}" != "X" ] ; then
  cp ${FIX} ${FIX}.pre${SELF}.${TSTAMP}
  grep -v  "^KerberosAuthentication[\ ]?*" ${FIX}.pre${SELF}.${TSTAMP} > ${FIX}
  echo "${MISSINGRULES}" >> ${FIX}
  diff -u ${FIX}.pre${SELF}.${TSTAMP} ${FIX}
  diff -u ${FIX}.pre${SELF}.${TSTAMP} ${FIX} > ${FIX}.${SELF}.${TSTAMP}.patch
fi

