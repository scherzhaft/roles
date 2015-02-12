#!/bin/bash -x


test -x /sbin/sh || exit 1

grep "^/sbin/sh$" /etc/shells || {
  echo /sbin/sh >> /etc/shells
  sleep 1
  grep "^/sbin/sh$" /etc/shells || exit 2
}

FIX="${*}"
FIX=''
test "X${FIX}" = "X" && FIX='/sbin/sh'

sleep 1
TSTAMP=`perl -e 'print int(time)'`
SELF=`basename $0`
test "X${FIX}" != "X" && EXIST=`ls -d ${FIX} 2>/dev/null`

test "X${SELF}" != "X" -a "X${TSTAMP}" != "X" -a "X${EXIST}" != "X" && {
  /usr/sbin/usermod -s ${EXIST} root  #GEN001080
}


