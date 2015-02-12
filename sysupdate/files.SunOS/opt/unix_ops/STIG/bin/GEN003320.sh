#!/bin/bash -x

FIX="${*}"
test "X${FIX}" = "X" && FIX='/etc/cron.d/at.allow'

sleep 1
TSTAMP=`perl -e 'print int(time)'`
SELF=`basename $0`
test "X${FIX}" != "X" && EXIST=`ls -d ${FIX}`

test "X${SELF}" != "X" -a "X${TSTAMP}" != "X" -a "X${EXIST}" != "X" && {
  cp -p /etc/cron.d/at.allow "/etc/cron.d/at.allow.${SELF}.${TSTAMP}"
  echo root > /etc/cron.d/at.allow
}

####GEN003320
