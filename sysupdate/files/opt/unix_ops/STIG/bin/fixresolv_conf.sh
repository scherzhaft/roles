#!/bin/bash -x


. /etc/default/SYSconstants || exit 4

MYGRP='root'
test "X${__OSNAME}" = "XSunOS" && MYGRP='sys'

FIX="${*}"
test "X${FIX}" = "X" && FIX='/etc/resolv.conf'

sleep 1
TSTAMP=`perl -e 'print int(time)'`
SELF=`basename $0`
test "X${FIX}" != "X" && EXIST=`ls -d ${FIX} 2>/dev/null`

test "X${SELF}" != "X" -a "X${TSTAMP}" != "X" -a "X${EXIST}" != "X" && {
  chmod 644 ${EXIST}  ##GEN001364
  chown root:${MYGRP} ${EXIST}  ##GEN001363 ##GEN001362
  test "X${__OSNAME}" = "XSunOS" && chmod A- ${EXIST}  #GEN001365
  test "X${__OSNAME}" != "XSunOS" && setfacl --remove-all ${EXIST}  #GEN001365
}


##GEN001375  yes our default resolver config has atleast 2 servers
