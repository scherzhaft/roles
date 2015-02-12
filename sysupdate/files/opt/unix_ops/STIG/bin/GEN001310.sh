#!/bin/bash -x


. /etc/default/SYSconstants || exit 4



FIX="${*}"
FIX=`find  /lib/* /lib64/* \! -type l `

sleep 1
TSTAMP=`perl -e 'print int(time)'`
SELF=`basename $0`
test "X${FIX}" != "X" && EXIST=`ls -d ${FIX}`

test "X${SELF}" != "X" -a "X${TSTAMP}" != "X" -a "X${EXIST}" != "X" && {
  chown root ${EXIST}  ##RHEL-06-000046
  chmod g-w,o-w  ${EXIST}  ##GEN001300  ##RHEL-06-000045
  test "X${__OSNAME}" = "XSunOS" && chmod A-   ${EXIST}  ##GEN001310
}


EXIST=''
FIX=`find /usr/lib/* /usr/lib64/* \! -type l `

sleep 1
TSTAMP=`perl -e 'print int(time)'`
SELF=`basename $0`
test "X${FIX}" != "X" && EXIST="${FIX}"

test "X${SELF}" != "X" -a "X${TSTAMP}" != "X" -a "X${EXIST}" != "X" && {
  for i in `echo "${EXIST}"` ; do
    chown root ${i}  ##RHEL-06-000046
    chmod g-w,o-w  ${i}  ##GEN001300  ##RHEL-06-000045
    test "X${__OSNAME}" = "XSunOS" && chmod A-       ${i}  ##GEN001310
  done
}


EXIST=''
FIX=`find  /usr/sfw/lib \! -type l `

sleep 1
TSTAMP=`perl -e 'print int(time)'`
SELF=`basename $0`
test "X${FIX}" != "X" && EXIST="${FIX}"

test "X${SELF}" != "X" -a "X${TSTAMP}" != "X" -a "X${EXIST}" != "X" && {
  for i in `echo "${EXIST}"` ; do
    chmod g-w,o-w  ${i}  ##GEN001300
    chmod A-       ${i}  ##GEN001310
  done
}



