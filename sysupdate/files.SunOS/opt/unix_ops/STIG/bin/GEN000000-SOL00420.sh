#!/bin/bash -x

FIX="${*}"
test "X${FIX}" = "X" && FIX=`/usr/bin/find / \! -local -prune -xattr  -print`

sleep 1
TSTAMP=`perl -e 'print int(time)'`
SELF=`basename $0`
test "X${FIX}" != "X" && EXIST=`ls -d ${FIX} 2>/dev/null`

test "X${SELF}" != "X" -a "X${TSTAMP}" != "X" -a "X${EXIST}" != "X" && {
  echo "...found files with hidden xattr's"
  echo "${EXIST}"  #GEN000000-SOL00420
}


