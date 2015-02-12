#!/bin/bash -x


. /etc/default/SYSconstants || exit 4

MYGRP='root'
test "X${__OSNAME}" = "XSunOS" && MYGRP='bin'

FIX="${*}"
test "X${FIX}" = "X" && FIX=`su - root -c 'echo %BEGIN$PATH'|grep "^%BEGIN"|perl -p -e "s|^%BEGIN||g"|sed 's/ /\\ /g; s/:/ /g'`


sleep 1
TSTAMP=`perl -e 'print int(time)'`
SELF=`basename $0`
test "X${FIX}" != "X" && EXIST=`ls -ld ${FIX} 2>/dev/null|awk {'print $1" "$9'}|/bin/grep  "w. "|awk {'print $2'}`

test "X${SELF}" != "X" -a "X${TSTAMP}" != "X" -a "X${EXIST}" != "X" && {
  test "X${__OSNAME}" = "XSunOS" && chmod A- ${EXIST}  #GEN001369
  test "X${__OSNAME}" != "XSunOS" && setfacl --remove-all ${EXIST}  #GEN001369
  chmod o-w ${EXIST}  ##GEN000960
}


