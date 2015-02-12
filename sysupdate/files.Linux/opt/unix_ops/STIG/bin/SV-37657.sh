#!/bin/bash -x

FIX="${*}"
test "X${FIX}" = "X" && FIX='/etc/audit/audit.rules'
sleep 1
TSTAMP=`date +%Y-%m-%d_%H:%M:%S`
SELF=`basename $0`
MISSINGRULES=''
AAUDITRULE1="-w /etc/audit.rules"
AAUDITRULE2="-w /etc/audit/audit.rules"

test "X${SELF}" = "X" -o "X${TSTAMP}" = "X" -o "X${FIX}" = "X" && exit

grep  -- "^-w .*/etc/audit.rules" ${FIX} >/dev/null
if [ "X${?}" = "X0" ] ; then
  echo "already has ${AAUDITRULE1}"
else
  MISSINGRULES="${MISSINGRULES}
${AAUDITRULE1}"
fi  

grep  -- "^-w .*/etc/audit/audit.rules" ${FIX} >/dev/null
if [ "X${?}" = "X0" ] ; then
  echo "already has ${AAUDITRULE2}"
else
  MISSINGRULES="${MISSINGRULES}
${AAUDITRULE2}"
fi  

MISSINGRULES=`echo "${MISSINGRULES}"|grep '.'`
if [ "X${MISSINGRULES}" != "X" ] ; then
  cp ${FIX} ${FIX}.pre${SELF}.${TSTAMP}
  echo "${MISSINGRULES}" >> ${FIX}
  diff -u ${FIX}.pre${SELF}.${TSTAMP} ${FIX}
  diff -u ${FIX}.pre${SELF}.${TSTAMP} ${FIX} > ${FIX}.${SELF}.${TSTAMP}.patch
fi

