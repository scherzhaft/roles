#!/bin/bash -x


. /etc/default/SYSconstants || exit 4

MYGRP='root'
test "X${__OSNAME}" = "XSunOS" && MYGRP='sys'

FIX="${*}"
test "X${FIX}" = "X" && FIX='/usr/sbin/rpcbind /sbin/rpcbind'

sleep 1
TSTAMP=`perl -e 'print int(time)'`
SELF=`basename $0`
test "X${FIX}" != "X" && EXIST=`ls -d ${FIX}`

test "X${SELF}" != "X" -a "X${TSTAMP}" != "X" -a "X${EXIST}" != "X" && {
  test "X${__OSNAME}" = "XSunOS" && chmod A- ${EXIST}  
  test "X${__OSNAME}" != "XSunOS" && setfacl --remove-all ${EXIST}  
  chmod 0555 ${EXIST}  ##we require rpcbind for nfs,  ##GEN003815  ##GEN003810
}


