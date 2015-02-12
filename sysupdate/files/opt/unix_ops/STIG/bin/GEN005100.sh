#!/bin/bash -x


. /etc/default/SYSconstants || exit 4

MYGRP='root'
test "X${__OSNAME}" = "XSunOS" && MYGRP='bin'

FIX="${*}"
test "X${FIX}" = "X" && FIX='/usr/sbin/in.tftpd'


sleep 1
TSTAMP=`perl -e 'print int(time)'`
SELF=`basename $0`
test "X${FIX}" != "X" && EXIST=`ls -d ${FIX} 2>/dev/null`

test "X${SELF}" != "X" -a "X${TSTAMP}" != "X" -a "X${EXIST}" != "X" && {
  test "X${__OSNAME}" = "XSunOS" && chmod A- ${EXIST} 
  test "X${__OSNAME}" != "XSunOS" && setfacl --remove-all ${EXIST}  
  chmod 0755 ${EXIST}  #GEN005100
}


