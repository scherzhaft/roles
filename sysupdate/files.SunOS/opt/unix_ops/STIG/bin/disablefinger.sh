#!/bin/bash -x


OSNAME=`uname -s` ; test "X${OSNAME}" != X || exit

if [ "X${OSNAME}" = "XSunOS" ] ; then
  /usr/sbin/svcadm -v disable -s  svc:/network/finger:default
fi
