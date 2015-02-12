#!/bin/bash -x

FIX="${*}"
test "X${FIX}" = "X" && FIX='/etc/rpmrc /usr/lib/rpm/rpmrc /usr/lib/rpm/redhat/rpmrc ~root/.rpmrc'


sleep 1
TSTAMP=`perl -e 'print int(time)'`
SELF=`basename $0`
test "X${FIX}" != "X" && EXIST=`ls -d ${FIX} 2>/dev/null`
test "X${EXIST}" != "X" && EXIST=`grep -l nosignature ${EXIST} 2>/dev/null`

test "X${SELF}" != "X" -a "X${TSTAMP}" != "X" -a "X${EXIST}" != "X" && {
  perl -p -i.${SELF}.${TSTAMP} -e "s|nosignature||g" ${EXIST}  ##RHEL-06-000514
}


