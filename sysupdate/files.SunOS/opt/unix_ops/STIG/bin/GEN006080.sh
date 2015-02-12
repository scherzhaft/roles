#!/bin/bash -x


OSNAME=`uname -s` ; test "X${OSNAME}" != X || exit

if [ "X${OSNAME}" = "XSunOS" ] ; then
  /usr/sbin/svcadm -v disable -s  swat  #GEN006080
fi


