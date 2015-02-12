#!/bin/bash -x

FIX="${*}"
test "X${FIX}" = "X" && FIX='/etc/apache/httpd-standalone-ipp.conf /etc/printers.conf /etc/sfw/smb.conf'


sleep 1
TSTAMP=`perl -e 'print int(time)'`
SELF=`basename $0`
test "X${FIX}" != "X" && EXIST=`ls -d ${FIX} 2>/dev/null`

test "X${SELF}" != "X" -a "X${TSTAMP}" != "X" -a "X${EXIST}" != "X" && {
  chmod A- ${EXIST}  #GEN003950
  chown root ${EXIST}  #GEN003920
  chmod 0644 ${EXIST}  #GEN003940
  chgrp root ${EXIST}  #GEN003930
}

/usr/sbin/svcadm -v disable -s ipp-listener  ##GEN003900  ##our unix boxes don't print


