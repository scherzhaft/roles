#!/bin/bash -x


##RHEL-06-000098
FIX="${*}"
test "X${FIX}" = "X" && FIX='/etc/modprobe.conf'
sleep 1
TSTAMP=`date +%Y-%m-%d_%H:%M:%S`
SELF=`basename $0`
MISSINGRULES=''
IPV6OFF="install ipv6 /bin/true"


test "X${SELF}" = "X" -o "X${TSTAMP}" = "X" -o "X${FIX}" = "X" && exit

grep "^install ?*ipv6 ?*/bin/true$" ${FIX} >/dev/null
if [ "X${?}" = "X0" ] ; then
  echo "already has ${IPV6OFF}"
else
  MISSINGRULES="${MISSINGRULES}
${IPV6OFF}"
fi  

MISSINGRULES=`echo "${MISSINGRULES}"|grep '.'`
if [ "X${MISSINGRULES}" != "X" ] ; then
  cp ${FIX} ${FIX}.pre${SELF}.${TSTAMP}
  grep -v  "^install .*ipv6 .*" ${FIX}.pre${SELF}.${TSTAMP} > ${FIX}
  echo "${MISSINGRULES}" >> ${FIX}
  diff -u ${FIX}.pre${SELF}.${TSTAMP} ${FIX}
  diff -u ${FIX}.pre${SELF}.${TSTAMP} ${FIX} > ${FIX}.${SELF}.${TSTAMP}.patch
fi

