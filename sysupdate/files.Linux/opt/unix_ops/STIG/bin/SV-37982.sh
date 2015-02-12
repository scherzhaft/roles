#!/bin/bash -x


##RHEL-06-000503
FIX="${*}"
test "X${FIX}" = "X" && FIX='/etc/modprobe.conf'
sleep 1
TSTAMP=`date +%Y-%m-%d_%H:%M:%S`
SELF=`basename $0`
MISSINGRULES=''
DISABLEUSB="install usb-storage /bin/true"


test "X${SELF}" = "X" -o "X${TSTAMP}" = "X" -o "X${FIX}" = "X" && exit

grep "^install[\ ].*usb-storage[\ ].*/bin/true$" ${FIX} >/dev/null
if [ "X${?}" = "X0" ] ; then
  echo "already has ${DISABLEUSB}"
else
  MISSINGRULES="${MISSINGRULES}
${DISABLEUSB}"
fi  

MISSINGRULES=`echo "${MISSINGRULES}"|grep '.'`
if [ "X${MISSINGRULES}" != "X" ] ; then
  cp ${FIX} ${FIX}.pre${SELF}.${TSTAMP}
  MISSINGRULES="${DISABLEUSB}"
  grep -v  "^install[\ ].*usb-storage[\ ].*" ${FIX}.pre${SELF}.${TSTAMP} > ${FIX}
  echo "${MISSINGRULES}" >> ${FIX}
  diff -u ${FIX}.pre${SELF}.${TSTAMP} ${FIX}
  diff -u ${FIX}.pre${SELF}.${TSTAMP} ${FIX} > ${FIX}.${SELF}.${TSTAMP}.patch
fi

