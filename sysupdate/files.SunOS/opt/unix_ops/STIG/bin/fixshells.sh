#!/bin/bash -x

OSNAME=`/bin/uname -s`
MYGRP='root'
test "X${OSNAME}" = "XSunOS" && MYGRP='bin'

sleep 1
TSTAMP=`perl -e 'print int(time)'`
SELF=`basename $0`


FIX='/etc/shells'

test "X${FIX}" != "X" && EXIST=`ls -d ${FIX} 2>/dev/null`

test "X${SELF}" != "X" -a "X${TSTAMP}" != "X" -a "X${EXIST}" != "X" && {
  VALIDSHELLS=`echo "\`awk -F\: {'print $7'} /etc/passwd |/bin/grep -v "false"|/bin/grep -v "null"|/bin/grep -v "sync"|/bin/grep -v "halt"|/bin/grep -v "uuc"|/bin/grep -v "shutdown"|/bin/grep -v "nologin";/bin/grep "^/.*/" /etc/shells\`"|sort -u|/bin/grep '.'`
  test "X${VALIDSHELLS}" != "X" && {  ##GEN002140
    perl -p -i.pre${SELF}.${TSTAMP} -e "s|^/.*\n||g" ${EXIST}
    echo "${VALIDSHELLS}" >> ${EXIST}
    diff -u "${EXIST}.pre${SELF}.${TSTAMP}" "${EXIST}"
    diff -u "${EXIST}.pre${SELF}.${TSTAMP}" "${EXIST}" > "${EXIST}.${SELF}.${TSTAMP}.patch"
  }

}


FIX=`grep "^/.*/" /etc/shells`

sleep 1
TSTAMP=`perl -e 'print int(time)'`
SELF=`basename $0`
test "X${FIX}" != "X" && EXIST=`ls -d ${FIX} 2>/dev/null`

test "X${SELF}" != "X" -a "X${TSTAMP}" != "X" -a "X${EXIST}" != "X" && {
  chmod A- ${EXIST}  #GEN002230
  chmod 0755 ${EXIST}  ##GEN002220
  chown root ${EXIST}  ##GEN002200
  chgrp ${MYGRP} ${EXIST}  ##GEN002210
}



