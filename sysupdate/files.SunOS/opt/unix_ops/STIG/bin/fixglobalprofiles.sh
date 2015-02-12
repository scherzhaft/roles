#!/bin/bash -x

. /etc/default/SYSconstants || exit 15
/usr/sfw/bin/ggrep -V || repo install.SUNWggrp
/usr/sfw/bin/ggrep -V || exit 17


FIX="${*}"
test "X${FIX}" = "X" && FIX='/etc/profile /etc/bash*'
sleep 1
TSTAMP=`perl -e 'print int(time)'`
SELF=`basename $0`
test "X${FIX}" != "X" && EXIST=`ls -d ${FIX} 2>/dev/null`



test "X${SELF}" != "X" -a "X${TSTAMP}" != "X" -a "X${EXIST}" != "X" && {
  NEED=`/usr/sfw/bin/ggrep -L -E -- "(^mesg .*n$|^mesg .*-n$)" ${FIX}`
  test "X${NEED}" != "X" && {
    MKBACKUP=`echo "${NEED}"|perl -p -e "s|(^.*$)|cp \1 \1.pre${SELF}.${TSTAMP}|g"`
    test "X${MKBACKUP}" = "X" && exit
    eval "${MKBACKUP}" || exit
    for i in `echo "${NEED}"` ; do
      printf "\nmesg n\n\n" >> ${i}
      diff -u ${i}.pre${SELF}.${TSTAMP} ${i}
    done
  }
}




