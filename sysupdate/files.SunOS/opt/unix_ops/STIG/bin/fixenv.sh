#!/bin/bash -x


. /etc/default/SYSconstants || exit 15
/usr/sfw/bin/ggrep -V || repo install.SUNWggrp
/usr/sfw/bin/ggrep -V || exit 17



FIX="${*}"
test "X${FIX}" = "X" && FIX='/etc/.login /etc/profile /etc/bash* /etc/environment /etc/security/environ /etc/csh.login /etc/csh.cshrc'

sleep 1
TSTAMP=`perl -e 'print int(time)'`
SELF=`basename $0`
test "X${FIX}" != "X" && EXIST=`ls -d ${FIX} 2>/dev/null`

test "X${SELF}" != "X" -a "X${TSTAMP}" != "X" -a "X${EXIST}" != "X" && {
  chmod 0644 ${EXIST}  ##GEN001720
  chown root:sys ${EXIST}  ##GEN001740  ##GEN001760
  chmod A- ${EXIST}  ##GEN001730
}


test "X${FIX}" != "X" && EXIST=`/usr/sfw/bin/ggrep  -l "LD_LIBRARY_PATH.*:\." ${FIX} 2>/dev/null`

test "X${SELF}" != "X" -a "X${TSTAMP}" != "X" -a "X${EXIST}" != "X" && {
  echo "...found bad lib paths"
  echo "${EXIST}"  ##GEN001845
}


test "X${FIX}" != "X" && EXIST=`/usr/sfw/bin/ggrep  -l "LD_PRELOAD.*:\." ${FIX} 2>/dev/null`

test "X${SELF}" != "X" -a "X${TSTAMP}" != "X" -a "X${EXIST}" != "X" && {
  echo "...found bad preload paths"
  echo "${EXIST}"  ##GEN001850
}


