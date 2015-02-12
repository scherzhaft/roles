#!/bin/bash -x

FIX="${*}"
test "X${FIX}" = "X" && FIX='/root/.netscape /root/.mozilla /.mozilla /.netscape'


sleep 1
TSTAMP=`perl -e 'print int(time)'`
SELF=`basename $0`
test "X${FIX}" != "X" && EXIST=`ls -d ${FIX} 2>/dev/null`

test "X${SELF}" != "X" -a "X${TSTAMP}" != "X" -a "X${EXIST}" != "X" && {
  tar cvf GEN004220.tar ${EXIST}
  rm -rf ${EXIST}  ##GEN004220
}


