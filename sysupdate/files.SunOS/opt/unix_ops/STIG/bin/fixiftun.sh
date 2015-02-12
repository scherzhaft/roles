#!/bin/bash -x

FIX="${*}"
test "X${FIX}" = "X" && FIX='ip.*tun'

sleep 1
TSTAMP=`perl -e 'print int(time)'`
SELF=`basename $0`
test "X${FIX}" != "X" && EXIST=`/usr/sbin/ifconfig -a| grep "${FIX}"`

test "X${SELF}" != "X" -a "X${TSTAMP}" != "X" -a "X${EXIST}" != "X" && {
  test "X${EXIST}" != "X" && "echo ...found tunnel interface"   ##GEN007820
}


