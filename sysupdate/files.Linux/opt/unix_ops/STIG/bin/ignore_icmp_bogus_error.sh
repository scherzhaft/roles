#!/bin/bash -x

FIX="${*}"
test "X${FIX}" = "X" && FIX='/etc/sysctl.conf'
sleep 1
TSTAMP=`perl -e 'print int(time)'`
SELF=`basename $0`
MISSINGRULES=''
ICMPBOGUSERR="net.ipv4.icmp_ignore_bogus_error_responses = 1"


test "X${SELF}" = "X" -o "X${TSTAMP}" = "X" -o "X${FIX}" = "X" && exit

grep "^net.ipv4.icmp_ignore_bogus_error_responses[\ ].*=[\ ].*1$" ${FIX} >/dev/null
if [ "X${?}" = "X0" ] ; then
  echo "already has ${ICMPBOGUSERR}"
else
  MISSINGRULES="${MISSINGRULES}
${ICMPBOGUSERR}"
fi  

MISSINGRULES=`echo "${MISSINGRULES}"|grep '.'`
if [ "X${MISSINGRULES}" != "X" ] ; then
  cp ${FIX} ${FIX}.pre${SELF}.${TSTAMP}
  grep -v  "^net.ipv4.icmp_ignore_bogus_error_responses[\ ].*" ${FIX}.pre${SELF}.${TSTAMP} > ${FIX}
  echo "${MISSINGRULES}" >> ${FIX}  ##RHEL-06-000093
  diff -u ${FIX}.pre${SELF}.${TSTAMP} ${FIX}
  diff -u ${FIX}.pre${SELF}.${TSTAMP} ${FIX} > ${FIX}.${SELF}.${TSTAMP}.patch
fi

