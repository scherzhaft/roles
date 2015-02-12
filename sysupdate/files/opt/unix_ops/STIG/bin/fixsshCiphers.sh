#!/bin/bash -x

FIX="${*}"
test "X${FIX}" = "X" && FIX='/etc/ssh/ssh_config'
sleep 1
OSNAME=`uname -s`
TSTAMP=`perl -e 'print int(time)'`
SELF=`basename $0`
MISSINGRULES=''
CIPHERS="Ciphers aes128-ctr,aes192-ctr,aes256-ctr,aes128-cbc,3des-cbc,aes192-cbc,aes256-cbc"
test "X${OSNAME}" != "XLinux" && CIPHERS="Ciphers aes128-ctr,aes192-ctr,aes256-ctr"

test "X${SELF}" = "X" -o "X${TSTAMP}" = "X" -o "X${FIX}" = "X" && exit

grep "^${CIPHERS}$" ${FIX} >/dev/null
if [ "X${?}" = "X0" ] ; then
  echo "already has ${CIPHERS}"
else
  MISSINGRULES="${MISSINGRULES}
${CIPHERS}"
fi  

MISSINGRULES=`echo "${MISSINGRULES}"|grep '.'`
if [ "X${MISSINGRULES}" != "X" ] ; then  ##GEN005510
  cp ${FIX} ${FIX}.pre${SELF}.${TSTAMP}
  grep -v  "^Ciphers[\ ]?*" ${FIX}.pre${SELF}.${TSTAMP} > ${FIX}
  echo "${MISSINGRULES}" >> ${FIX}
  diff -u ${FIX}.pre${SELF}.${TSTAMP} ${FIX}
  diff -u ${FIX}.pre${SELF}.${TSTAMP} ${FIX} > ${FIX}.${SELF}.${TSTAMP}.patch
fi

OSNAME=`uname -s`
test "X${OSNAME}" != "XLinux" && COMPRESSION="Compression no"

