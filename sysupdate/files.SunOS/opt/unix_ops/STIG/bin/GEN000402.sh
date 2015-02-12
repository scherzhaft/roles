#!/bin/bash -x


OSNAME=`uname -s` ; test "X${OSNAME}" != X || exit

if [ "X${OSNAME}" = "XSunOS" ] ; then
  mkdir -p  /etc/dt/config/
  cd /usr/dt/config/ || exit 7
  CONFIG=`find . -depth -print|/bin/grep "/Xresources$"`
  test "X${CONFIG}" != "X" && {
    find . -depth -print|cpio -pdmu /etc/dt/config/
    cd /etc/dt/config/ || exit 12
    perl -p -i -e "s|^[\s,\!]*(Dtlogin\*greeting.labelString:[\s]*).*$|\1I\'ve read \\& consent to terms in IS user agreem't\.|g" ${CONFIG}    ##GEN000402
    
    /usr/sbin/svcadm -v disable -s  svc:/application/graphical-login/cde-login:default
    /usr/sbin/svcadm -v disable -s  svc:/application/gdm2-login:default
  }
fi


