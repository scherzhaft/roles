#!/bin/bash -x


OSNAME=`uname -s` ; test "X${OSNAME}" != X || exit

if [ "X${OSNAME}" = "XSunOS" ] ; then
  /usr/sbin/svcadm -v enable -s svc:/network/ipfilter:default
fi
