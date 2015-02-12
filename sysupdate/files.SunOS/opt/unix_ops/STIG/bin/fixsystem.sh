#!/bin/bash -x

FIX="${*}"
test "X${FIX}" = "X" && FIX='/etc/system'

sleep 1
TSTAMP=`perl -e 'print int(time)'`
SELF=`basename $0`
test "X${FIX}" != "X" && EXIST=`ls -d ${FIX}`


test "X${SELF}" != "X" -a "X${TSTAMP}" != "X" -a "X${EXIST}" != "X" && {
  /bin/grep "^exclude: .*rds$"  ${EXIST} || echo "exclude: rds"  >> ${EXIST}  ##GEN007480
  /bin/grep "^exclude: .*tipc$" ${EXIST} || echo "exclude: tipc" >> ${EXIST}  ##GEN007540
}

