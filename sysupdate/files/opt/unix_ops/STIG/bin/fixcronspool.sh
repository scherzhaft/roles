#!/bin/bash -x


. /etc/default/SYSconstants || exit 4

MYGRP='root'
test "X${__OSNAME}" = "XSunOS" && MYGRP='bin'

FIX="${*}"

test "X${FIX}" = "X" && FIX='/etc/cron.allow /etc/cron.d /etc/cron.d/* /etc/cron.daily /etc/cron.d/cron.allow /etc/cron.hourly /etc/cron.monthly /etc/crontab /etc/cron.weekly /var/cron/log /var/spool/cron /var/spool/cron/* /var/spool/cron/atjobs /var/spool/cron/atjobs/* /var/spool/cron/crontabs /var/spool/cron/crontabs/*'

sleep 1
TSTAMP=`perl -e 'print int(time)'`
SELF=`basename $0`
test "X${FIX}" != "X" && EXIST=`find ${FIX} 2>/dev/null`

test "X${SELF}" != "X" -a "X${TSTAMP}" != "X" -a "X${EXIST}" != "X" && {
  chmod o-w ${EXIST}  ##GEN003020
  test "X${__OSNAME}" = "XSunOS" && chmod A- ${EXIST}  #GEN003110
  test "X${__OSNAME}" != "XSunOS" && setfacl --remove-all ${EXIST}  #GEN003110
}


