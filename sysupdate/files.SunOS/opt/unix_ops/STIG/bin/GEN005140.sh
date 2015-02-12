#!/bin/bash -x


OSNAME=`uname -s` ; test "X${OSNAME}" != X || exit

if [ "X${OSNAME}" = "XSunOS" ] ; then
  /usr/sbin/svcadm -v disable -s  svc:/network/tftp/*  #GEN005140  ##GEN005120  ##GEN005080
fi


