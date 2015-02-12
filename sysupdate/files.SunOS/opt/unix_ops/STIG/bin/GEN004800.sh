#!/bin/bash -x


OSNAME=`uname -s` ; test "X${OSNAME}" != X || exit

if [ "X${OSNAME}" = "XSunOS" ] ; then
  /usr/sbin/svcadm -v disable -s  ftp  #GEN004800  ##GEN000410  ##GEN005020  ##GEN004840  ##GEN004900  ##GEN004820  
fi


