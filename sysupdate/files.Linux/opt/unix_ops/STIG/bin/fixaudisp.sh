#!/bin/bash -x


exit 0


FIX="${*}"
test "X${FIX}" = "X" && FIX='/etc/audisp/plugins.d/syslog.conf'
sleep 1
TSTAMP=`perl -e 'print int(time)'`
SELF=`basename $0`
MISSINGRULES=''
AUDISP="active = yes"


test "X${SELF}" = "X" -o "X${TSTAMP}" = "X" -o "X${FIX}" = "X" && exit

grep "^${AUDISP}$" ${FIX} >/dev/null
if [ "X${?}" = "X0" ] ; then
  echo "already has ${AUDISP}"
else
  MISSINGRULES="${MISSINGRULES}
${AUDISP}"
fi  

MISSINGRULES=`echo "${MISSINGRULES}"|grep '.'`
if [ "X${MISSINGRULES}" != "X" ] ; then
  cp ${FIX} ${FIX}.pre${SELF}.${TSTAMP}
  perl -p -i -e "s|^[\s,#]*active[\s]*=.*$||" ${FIX}
  echo "${MISSINGRULES}" >> ${FIX}  ##RHEL-06-000509
  diff -u ${FIX}.pre${SELF}.${TSTAMP} ${FIX}
  diff -u ${FIX}.pre${SELF}.${TSTAMP} ${FIX} > ${FIX}.${SELF}.${TSTAMP}.patch
fi

