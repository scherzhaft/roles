#!/bin/bash -x


. /etc/default/SYSconstants || exit 4

MYGRP='root'
test "X${__OSNAME}" = "XSunOS" && MYGRP='bin'

FIX="${*}"
test "X${FIX}" = "X" && FIX='/usr/sbin/traceroute /bin/traceroute'


sleep 1
TSTAMP=`perl -e 'print int(time)'`
SELF=`basename $0`
test "X${FIX}" != "X" && EXIST=`ls -d ${FIX} 2>/dev/null`

test "X${SELF}" != "X" -a "X${TSTAMP}" != "X" -a "X${EXIST}" != "X" && {
  test "X${__OSNAME}" = "XSunOS" && chmod A- ${EXIST}  #GEN004010
  test "X${__OSNAME}" != "XSunOS" && setfacl --remove-all ${EXIST}  #GEN004010
  chmod 0700 ${EXIST}  #GEN004000
  chown root:${MYGRP} ${EXIST}  ##GEN003960  ##GEN003980
}


