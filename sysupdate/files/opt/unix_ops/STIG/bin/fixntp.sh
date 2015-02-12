#!/bin/bash -x


. /etc/default/SYSconstants || exit 4

MYGRP='root'
test "X${__OSNAME}" = "XSunOS" && MYGRP='sys'

FIX="${*}"
test "X${FIX}" = "X" && FIX='/etc/ntp.conf /etc/inet/ntp*'

sleep 1
TSTAMP=`perl -e 'print int(time)'`
SELF=`basename $0`
test "X${FIX}" != "X" && EXIST=`ls -d ${FIX} 2>/dev/null`

test "X${SELF}" != "X" -a "X${TSTAMP}" != "X" -a "X${EXIST}" != "X" && {
  chmod 640 ${EXIST}  ##GEN000252
  chown root:${MYGRP} ${EXIST}  #GEN000251  ##GEN000250
  test "X${__OSNAME}" = "XSunOS" && chmod A- ${EXIST}  #GEN000253
  test "X${__OSNAME}" != "XSunOS" && setfacl --remove-all ${EXIST}  #GEN000253
}


