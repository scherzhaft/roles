#!/bin/bash -x


##RHEL-06-000088


FIX="${*}"
test "X${FIX}" = "X" && FIX='/etc/sysctl.conf'
sleep 1
TSTAMP=`date +%Y-%m-%d_%H:%M:%S`
SELF=`basename $0`
MISSINGRULES=''
DEFLOG_MARTIANS="net.ipv4.conf.default.log_martians = 1"
ALLLOG_MARTIANS="net.ipv4.conf.all.log_martians = 1"


test "X${SELF}" = "X" -o "X${TSTAMP}" = "X" -o "X${FIX}" = "X" && exit

grep "^net.ipv4.conf.default.log_martians[\ ]*=[\ ]*1$" ${FIX} >/dev/null
if [ "X${?}" = "X0" ] ; then
  echo "already has ${DEFLOG_MARTIANS}"
else
  MISSINGRULES="${MISSINGRULES}
${DEFLOG_MARTIANS}"
fi  

grep "^net.ipv4.conf.all.log_martians[\ ]*=[\ ]*1$" ${FIX} >/dev/null
if [ "X${?}" = "X0" ] ; then
  echo "already has ${ALLLOG_MARTIANS}"
else
  MISSINGRULES="${MISSINGRULES}
${ALLLOG_MARTIANS}"
fi  


MISSINGRULES=`echo "${MISSINGRULES}"|grep '.'`
if [ "X${MISSINGRULES}" != "X" ] ; then
  MISSINGRULES="${DEFLOG_MARTIANS}
${ALLLOG_MARTIANS}"
  cp ${FIX} ${FIX}.pre${SELF}.${TSTAMP}
  grep -v -E "(^net.ipv4.conf.default.log_martians[\ ]*=|^net.ipv4.conf.all.log_martians[\ ]*=)" ${FIX}.pre${SELF}.${TSTAMP} > ${FIX}
  echo "${MISSINGRULES}" >> ${FIX}
  diff -u ${FIX}.pre${SELF}.${TSTAMP} ${FIX}
  diff -u ${FIX}.pre${SELF}.${TSTAMP} ${FIX} > ${FIX}.${SELF}.${TSTAMP}.patch
fi

