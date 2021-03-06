#!/bin/bash -x


. /etc/default/SYSconstants || exit 4
/usr/sfw/bin/ggrep -V || repo install.SUNWggrp
/usr/sfw/bin/ggrep -V || exit 6


DANGERZONEPATHS=`/usr/sbin/zoneadm list -cv|grep -v " global "|awk {'print $4'}|grep -v "^PATH$"`

test "X${DANGERZONEPATHS}" != "X" && FILTER=`echo "${DANGERZONEPATHS}"|awk {'print "^"$1'}`


mkdir -p /opt/unix_ops/log
sleep 1


if [ "X${FILTER}" != "X" ] ; then
  /usr/bin/find `ls -d /*|grep -v proc|grep -v "^/zone"`  \! -local -prune -o -type b -o -type c -print|/usr/sfw/bin/ggrep -v -G "${FILTER}"  > /opt/unix_ops/log/GEN002260_alldevices.log  ##GEN002260
else
  /usr/bin/find `ls -d /*|grep -v proc|grep -v "^/zone"`  \! -local -prune -o -type b -o -type c -print  > /opt/unix_ops/log/GEN002260_alldevices.log  ##GEN002260
fi


exit 0


