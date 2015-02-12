#!/bin/bash -x


. /etc/default/SYSconstants || exit 4

FIX="${*}"
test "X${FIX}" = "X" && FIX='/etc/services'


sleep 1
TSTAMP=`perl -e 'print int(time)'`
SELF=`basename $0`
test "X${FIX}" != "X" && EXIST=`ls -d ${FIX} 2>/dev/null`

test "X${SELF}" != "X" -a "X${TSTAMP}" != "X" -a "X${EXIST}" != "X" && {
  test "X${__OSNAME}" = "XSunOS" && chmod A- ${EXIST}  #GEN003790
  test "X${__OSNAME}" != "XSunOS" && setfacl --remove-all ${EXIST}  #GEN003790
}


