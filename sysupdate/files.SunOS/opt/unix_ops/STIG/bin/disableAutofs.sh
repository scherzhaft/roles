#!/bin/bash -x


OSNAME=`uname -s` ; test "X${OSNAME}" != X || exit

if [ "X${OSNAME}" = "XLinux" ] ; then
  /sbin/service autofs stop
  /sbin/chkconfig autofs off
else
  /usr/sbin/svcadm -v disable -s svc:/system/filesystem/autofs
fi
