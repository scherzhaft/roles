#!/bin/bash -x

FIX="${*}"
test "X${FIX}" = "X" && FIX='/etc/skel'
sleep 1
TSTAMP=`perl -e 'print int(time)'`
SELF=`basename $0`
test "X${FIX}" != "X" && EXIST=`find ${FIX}  -type f`

test "X${SELF}" != "X" -a "X${TSTAMP}" != "X" -a "X${EXIST}" != "X" && {
  chown root:bin  ${EXIST}  ##GEN001830  ##GEN001830
  chmod A- ${EXIST}  ##GEN001810
}
