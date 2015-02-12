#!/bin/bash -x


OSNAME=`uname -s` ; test "X${OSNAME}" != X || exit

if [ "X${OSNAME}" = "XSunOS" ] ; then
  NOPASS=`/usr/bin/logins -p`   ##GEN000560
  test "X${NOPASS}" != "X" && echo "found logins with no password"
fi


