#!/bin/bash -x


##RHEL-06-000080  ##RHEL-06-000081


FIX="${*}"
test "X${FIX}" = "X" && FIX='/etc/sysctl.conf'
sleep 1
TSTAMP=`date +%Y-%m-%d_%H:%M:%S`
SELF=`basename $0`
MISSINGRULES=''
DEFREDIRECTS="net.ipv4.conf.default.send_redirects = 0"
ALLREDIRECTS="net.ipv4.conf.all.send_redirects = 0"


test "X${SELF}" = "X" -o "X${TSTAMP}" = "X" -o "X${FIX}" = "X" && exit

grep "^net.ipv4.conf.default.send_redirects[\ ]*=[\ ]*0$" ${FIX} >/dev/null
if [ "X${?}" = "X0" ] ; then
  echo "already has ${DEFREDIRECTS}"
else
  MISSINGRULES="${MISSINGRULES}
${DEFREDIRECTS}"
fi  

grep "^net.ipv4.conf.all.send_redirects[\ ]*=[\ ]*0$" ${FIX} >/dev/null
if [ "X${?}" = "X0" ] ; then
  echo "already has ${ALLREDIRECTS}"
else
  MISSINGRULES="${MISSINGRULES}
${ALLREDIRECTS}"
fi  


MISSINGRULES=`echo "${MISSINGRULES}"|grep '.'`
if [ "X${MISSINGRULES}" != "X" ] ; then
  cp ${FIX} ${FIX}.pre${SELF}.${TSTAMP}
  MISSINGRULES="${DEFREDIRECTS}
${ALLREDIRECTS}"
  grep -v -E "(^net.ipv4.conf.default.send_redirects[\ ]*=|^net.ipv4.conf.all.send_redirects[\ ]*=)" ${FIX}.pre${SELF}.${TSTAMP} > ${FIX}
  echo "${MISSINGRULES}" >> ${FIX}
  diff -u ${FIX}.pre${SELF}.${TSTAMP} ${FIX}
  diff -u ${FIX}.pre${SELF}.${TSTAMP} ${FIX} > ${FIX}.${SELF}.${TSTAMP}.patch
fi

