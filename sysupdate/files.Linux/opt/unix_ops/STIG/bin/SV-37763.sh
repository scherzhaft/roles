#!/bin/bash -x


##RHEL-06-000124
FIX="${*}"
test "X${FIX}" = "X" && FIX='/etc/modprobe.conf'
sleep 1
TSTAMP=`date +%Y-%m-%d_%H:%M:%S`
SELF=`basename $0`
MISSINGRULES=''
DCCPOFF="install dccp /bin/true"
DCCPIPV4OFF="install dccp_ipv4 /bin/true"
DCCPIPV6OFF="install dccp_ipv6 /bin/true"


test "X${SELF}" = "X" -o "X${TSTAMP}" = "X" -o "X${FIX}" = "X" && exit

grep "^install[\ ]?*dccp[\ ]?*/bin/true$" ${FIX} >/dev/null
if [ "X${?}" = "X0" ] ; then
  echo "already has ${DCCPOFF}"
else
  MISSINGRULES="${MISSINGRULES}
${DCCPOFF}"
fi  

grep "^install[\ ]?*dccp_ipv4[\ ]?*/bin/true$" ${FIX} >/dev/null
if [ "X${?}" = "X0" ] ; then
  echo "already has ${DCCPIPV4OFF}"
else
  MISSINGRULES="${MISSINGRULES}
${DCCPIPV4OFF}"
fi  

grep "^install[\ ]?*dccp_ipv6[\ ]?*/bin/true$" ${FIX} >/dev/null
if [ "X${?}" = "X0" ] ; then
  echo "already has ${DCCPIPV6OFF}"
else
  MISSINGRULES="${MISSINGRULES}
${DCCPIPV6OFF}"
fi  

MISSINGRULES=`echo "${MISSINGRULES}"|grep '.'`
if [ "X${MISSINGRULES}" != "X" ] ; then
  MISSINGRULES="${DCCPOFF}
${DCCPIPV4OFF}
${DCCPIPV6OFF}"

  cp ${FIX} ${FIX}.pre${SELF}.${TSTAMP}
  grep -v  -E "(^install[\ ]?*dccp[\ ]?*|^install[\ ]?*dccp_ipv)" ${FIX}.pre${SELF}.${TSTAMP} > ${FIX}
  echo "${MISSINGRULES}" >> ${FIX}
  diff -u ${FIX}.pre${SELF}.${TSTAMP} ${FIX}
  diff -u ${FIX}.pre${SELF}.${TSTAMP} ${FIX} > ${FIX}.${SELF}.${TSTAMP}.patch
fi

