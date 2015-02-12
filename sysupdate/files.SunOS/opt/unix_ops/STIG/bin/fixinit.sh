#!/bin/bash -x


. /etc/default/SYSconstants || exit 15
/usr/sfw/bin/ggrep -V || repo install.SUNWggrp
/usr/sfw/bin/ggrep -V || exit 17


FIX="${*}"
test "X${FIX}" = "X" && FIX=`find /etc/rc*.d /etc/init.d /lib/svc/method \! -type d`

sleep 1
TSTAMP=`perl -e 'print int(time)'`
SELF=`basename $0`
test "X${FIX}" != "X" && EXIST=`ls -d ${FIX} 2>/dev/null`

test "X${SELF}" != "X" -a "X${TSTAMP}" != "X" -a "X${EXIST}" != "X" && {
  chmod A-   ${EXIST}  ##GEN001590
  chmod go-w ${EXIST}  ##GEN001580
  chown root:root ${EXIST}  ##GEN001700  ##GEN001660  ##GEN001680
}


test "X${FIX}" != "X" && EXIST=`/usr/sfw/bin/ggrep  -l "LD_LIBRARY_PATH.*:\." ${FIX} 2>/dev/null`

test "X${SELF}" != "X" -a "X${TSTAMP}" != "X" -a "X${EXIST}" != "X" && {
  echo "...found bad lib paths"
  echo "${EXIST}"  ##GEN001605
}


test "X${FIX}" != "X" && EXIST=`/usr/sfw/bin/ggrep  -l "LD_PRELOAD.*:\." ${FIX} 2>/dev/null`

test "X${SELF}" != "X" -a "X${TSTAMP}" != "X" -a "X${EXIST}" != "X" && {
  echo "...found bad preload paths"
  echo "${EXIST}"  ##GEN001610
}


test "X${FIX}" != "X" && EXIST=`/usr/sfw/bin/ggrep  -l "PATH.*:\." ${FIX} 2>/dev/null`

test "X${SELF}" != "X" -a "X${TSTAMP}" != "X" -a "X${EXIST}" != "X" && {
  echo "...found bad search paths"
  echo "${EXIST}"  ##GEN001600
}


