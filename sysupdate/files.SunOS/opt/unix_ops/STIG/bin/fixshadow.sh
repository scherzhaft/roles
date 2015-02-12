#!/bin/bash -x

FIX="${*}"
test "X${FIX}" = "X" && FIX='/etc/shadow'

. /etc/default/SYSconstants || exit 5
sleep 1
TSTAMP=`perl -e 'print int(time)'`
SELF=`basename $0`
test "X${FIX}" != "X" && EXIST=`ls -d ${FIX} 2>/dev/null`

test "X${SELF}" != "X" -a "X${TSTAMP}" != "X" -a "X${EXIST}" != "X" && {
  chmod A- ${EXIST}  ##GEN001430
  perl -p -i.${TSTAMP} -e "s|^([^:]+:[^:]+:[^:]*).*|\1:1:::::|g" ${EXIST}  ##GEN000540
  diff -u ${EXIST}.${TSTAMP} ${EXIST}
  sleep 2
  TSTAMP=`perl -e 'print int(time)'`
  foo=`__getepoc_day`
  test "X${foo}" = "X" && exit 16 
  perl -p -i.${TSTAMP} -e "s|^([^:]+:[^:]{8,}):[^:]*:([^:]*):[^:]*:([^:]*):([^:]*):([^:]*):|\1:${foo}:\2:60:\3:\4:\5:\6|g unless /^root:/" ${EXIST}   ##GEN000700
  diff -u ${EXIST}.${TSTAMP} ${EXIST}
  sleep 2
  TSTAMP=`perl -e 'print int(time)'`
  perl -p -i.${TSTAMP} -e "s|(^[^:]+):[^:]{0,8}:|\1:\*LK\*:|g unless /(:NP:|:\*LK\*:|:\*:|:\!\!:|^root:)/"  ${EXIST}   ##GEN002640
  diff -u ${EXIST}.${TSTAMP} ${EXIST}
}


