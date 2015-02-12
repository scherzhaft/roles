#!/bin/bash -x

FIX="${*}"
test "X${FIX}" = "X" && FIX='/etc/ssh/sshd_config'
sleep 1
TSTAMP=`perl -e 'print int(time)'`
SELF=`basename $0`
MISSINGRULES=''
EMPTYPASSWORDS="PermitEmptyPasswords no"


test "X${SELF}" = "X" -o "X${TSTAMP}" = "X" -o "X${FIX}" = "X" && exit

grep "^PermitEmptyPasswords[\ ].*no$" ${FIX} >/dev/null
if [ "X${?}" = "X0" ] ; then
  echo "already has ${EMPTYPASSWORDS}"
else
  MISSINGRULES="${MISSINGRULES}
${EMPTYPASSWORDS}"
fi  

MISSINGRULES=`echo "${MISSINGRULES}"|grep '.'`
if [ "X${MISSINGRULES}" != "X" ] ; then
  cp ${FIX} ${FIX}.pre${SELF}.${TSTAMP}
  grep -v  "^PermitEmptyPasswords[\ ].*" ${FIX}.pre${SELF}.${TSTAMP} > ${FIX}
  echo "${MISSINGRULES}" >> ${FIX}  ##RHEL-06-000239
  diff -u ${FIX}.pre${SELF}.${TSTAMP} ${FIX}
  diff -u ${FIX}.pre${SELF}.${TSTAMP} ${FIX} > ${FIX}.${SELF}.${TSTAMP}.patch
fi

