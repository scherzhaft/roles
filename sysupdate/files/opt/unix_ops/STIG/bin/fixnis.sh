#!/bin/bash -x


. /etc/default/SYSconstants || exit 4
test "X${__OSNAME}" != X || exit

MYGRP='root'
test "X${__OSNAME}" = "XSunOS" && MYGRP='bin'

FIX="${*}"
test "X${FIX}" = "X" && FIX='/usr/lib/netsvc/yp/* /var/yp/*'

sleep 1
TSTAMP=`perl -e 'print int(time)'`
SELF=`basename $0`
test "X${FIX}" != "X" && EXIST=`ls -d ${FIX} 2>/dev/null`

test "X${SELF}" != "X" -a "X${TSTAMP}" != "X" -a "X${EXIST}" != "X" && {
  chmod 755 ${EXIST}
  chown root:${MYGRP} ${EXIST}
  test "X${__OSNAME}" = "XSunOS" && chmod -R A- /usr/lib/netsvc/yp /var/yp  #GEN001361
  test "X${__OSNAME}" != "XSunOS" && setfacl -R --remove-all /var/yp  #GEN001361
}


if [ "X${__OSNAME}" = "XSunOS" ] ; then
  /usr/sbin/svcadm -v  disable -s   svc:/network/nis/client:default ##GEN006380 #GEN006080  ##GEN006420  ##GEN006460  we don't run nis
fi


