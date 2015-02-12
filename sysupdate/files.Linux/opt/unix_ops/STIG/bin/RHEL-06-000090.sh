#!/bin/bash -x

FIX="${*}"
test "X${FIX}" = "X" && FIX='/etc/sysctl.conf'
sleep 1
TSTAMP=`perl -e 'print int(time)'`
SELF=`basename $0`
MISSINGRULES=''
IP4DEFSECREDIR="net.ipv4.conf.default.secure_redirects = 0"


test "X${SELF}" = "X" -o "X${TSTAMP}" = "X" -o "X${FIX}" = "X" && exit

grep "^net.ipv4.conf.default.secure_redirects[\ ].*=[\ ].*0$" ${FIX} >/dev/null
if [ "X${?}" = "X0" ] ; then
  echo "already has ${IP4DEFSECREDIR}"
else
  MISSINGRULES="${MISSINGRULES}
${IP4DEFSECREDIR}"
fi  

MISSINGRULES=`echo "${MISSINGRULES}"|grep '.'`
if [ "X${MISSINGRULES}" != "X" ] ; then
  cp ${FIX} ${FIX}.pre${SELF}.${TSTAMP}
  grep -v  "^net.ipv4.conf.default.secure_redirects[\ ].*" ${FIX}.pre${SELF}.${TSTAMP} > ${FIX}
  echo "${MISSINGRULES}" >> ${FIX}  ##RHEL-06-000090
  diff -u ${FIX}.pre${SELF}.${TSTAMP} ${FIX}
  diff -u ${FIX}.pre${SELF}.${TSTAMP} ${FIX} > ${FIX}.${SELF}.${TSTAMP}.patch
fi

