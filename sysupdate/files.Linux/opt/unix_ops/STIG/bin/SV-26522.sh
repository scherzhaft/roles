#!/bin/bash -x

FIX="${*}"
test "X${FIX}" = "X" && FIX='/etc/audit/audit.rules'
sleep 1
TSTAMP=`date +%Y-%m-%d_%H:%M:%S`
SELF=`basename $0`
MISSINGRULES=''
UDELRULE="-w /usr/sbin/userdel -p x -k userdel"
GDELRULE="-w /usr/sbin/groupdel -p x -k groupdel"

test "X${SELF}" = "X" -o "X${TSTAMP}" = "X" -o "X${FIX}" = "X" && exit

grep  -- "^-w .*/usr/sbin/userdel .*-p .*x .*-k .*" ${FIX} >/dev/null
if [ "X${?}" = "X0" ] ; then
  echo "already has userdel exec rule"
else
  MISSINGRULES="${MISSINGRULES}
${UDELRULE}"
fi  

grep  -- "^-w .*/usr/sbin/groupdel .*-p .*x .*-k .*" ${FIX} >/dev/null
if [ "X${?}" = "X0" ] ; then
  echo "already has groupdel exec rule"
else
  MISSINGRULES="${MISSINGRULES}
${GDELRULE}"
fi  

MISSINGRULES=`echo "${MISSINGRULES}"|grep '.'`
if [ "X${MISSINGRULES}" != "X" ] ; then
  cp ${FIX} ${FIX}.pre${SELF}.${TSTAMP}
  echo "${MISSINGRULES}" >> ${FIX}
  diff -u ${FIX}.pre${SELF}.${TSTAMP} ${FIX}
  diff -u ${FIX}.pre${SELF}.${TSTAMP} ${FIX} > ${FIX}.${SELF}.${TSTAMP}.patch
fi

