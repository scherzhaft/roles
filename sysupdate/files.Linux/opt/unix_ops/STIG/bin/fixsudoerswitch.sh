#!/bin/bash -x

FIX="${*}"
test "X${FIX}" = "X" && FIX='/etc/nsswitch.conf'
sleep 1
TSTAMP=`date +%Y-%m-%d_%H:%M:%S`
SELF=`basename $0`
MISSINGRULES=''
NSSSWITCHSUDOERS="sudoers: files"


test "X${SELF}" = "X" -o "X${TSTAMP}" = "X" -o "X${FIX}" = "X" && exit

grep "^sudoers:[\ ]*files$" ${FIX} >/dev/null
if [ "X${?}" = "X0" ] ; then
  echo "already has ${NSSSWITCHSUDOERS}"
else
  MISSINGRULES="${MISSINGRULES}
${NSSSWITCHSUDOERS}"
fi  


MISSINGRULES=`echo "${MISSINGRULES}"|grep '.'`
if [ "X${MISSINGRULES}" != "X" ] ; then
  cp ${FIX} ${FIX}.pre${SELF}.${TSTAMP}
  MISSINGRULES="${NSSSWITCHSUDOERS}"
  grep -v  "^sudoers:" ${FIX}.pre${SELF}.${TSTAMP} > ${FIX}
  echo "${MISSINGRULES}" >> ${FIX}
  diff -u ${FIX}.pre${SELF}.${TSTAMP} ${FIX}
  diff -u ${FIX}.pre${SELF}.${TSTAMP} ${FIX} > ${FIX}.${SELF}.${TSTAMP}.patch
fi

