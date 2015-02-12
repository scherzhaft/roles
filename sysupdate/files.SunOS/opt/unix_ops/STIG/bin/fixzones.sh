#!/bin/bash -x

FIX="${*}"
test "X${FIX}" = "X" && FIX='/etc/zones'

sleep 1
TSTAMP=`perl -e 'print int(time)'`
SELF=`basename $0`
test "X${FIX}" != "X" && EXIST=`ls -d ${FIX} 2>/dev/null`

test "X${SELF}" != "X" -a "X${TSTAMP}" != "X" -a "X${EXIST}" != "X" && {
  chmod -R A-   ${EXIST}  ##GEN000000-SOL00600
  chown -R root:sys   ${EXIST}  ##GEN000000-SOL00540  ##GEN000000-SOL00560
  chmod g-w,o-w       ${EXIST}  ##GEN000000-SOL00580
  chmod u-x,g-wx,o-wx       ${EXIST}/*  ##GEN000000-SOL00580
}
