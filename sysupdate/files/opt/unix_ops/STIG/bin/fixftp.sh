#!/bin/bash -x


. /etc/default/SYSconstants || exit 4

MYGRP='root'
test "X${__OSNAME}" = "XSunOS" && MYGRP='sys'

FIX="${*}"
test "X${FIX}" = "X" && FIX='/etc/ftpd/* /etc/ftpusers /etc/vsftpd.ftpusers /etc/vsftpd/ftpusers'

sleep 1
TSTAMP=`perl -e 'print int(time)'`
SELF=`basename $0`
test "X${FIX}" != "X" && EXIST=`ls -d ${FIX} 2>/dev/null`

test "X${SELF}" != "X" -a "X${TSTAMP}" != "X" -a "X${EXIST}" != "X" && {
  test "X${__OSNAME}" = "XSunOS" && chmod A- ${EXIST}  #GEN004950
  test "X${__OSNAME}" != "XSunOS" && setfacl --remove-all ${EXIST}  #GEN004950
  chmod 640 ${EXIST} ##GEN004940 
  chown root:${MYGRP} ${EXIST}  ##GEN004930
}


