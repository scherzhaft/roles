#!/bin/bash -x


##RHEL-06-000125
FIX="${*}"
test "X${FIX}" = "X" && FIX='/etc/modprobe.conf'
sleep 1
TSTAMP=`date +%Y-%m-%d_%H:%M:%S`
SELF=`basename $0`
MISSINGRULES=''
SCTPOFF="install sctp /bin/true"


test "X${SELF}" = "X" -o "X${TSTAMP}" = "X" -o "X${FIX}" = "X" && exit

grep "^install .*sctp .*/bin/true$" ${FIX} >/dev/null
if [ "X${?}" = "X0" ] ; then
  echo "already has ${SCTPOFF}"
else
  MISSINGRULES="${MISSINGRULES}
${SCTPOFF}"
fi  

MISSINGRULES=`echo "${MISSINGRULES}"|grep '.'`
if [ "X${MISSINGRULES}" != "X" ] ; then
  cp ${FIX} ${FIX}.pre${SELF}.${TSTAMP}
  grep -v  "^install .*sctp .*" ${FIX}.pre${SELF}.${TSTAMP} > ${FIX}
  echo "${MISSINGRULES}" >> ${FIX}
  diff -u ${FIX}.pre${SELF}.${TSTAMP} ${FIX}
  diff -u ${FIX}.pre${SELF}.${TSTAMP} ${FIX} > ${FIX}.${SELF}.${TSTAMP}.patch
fi

