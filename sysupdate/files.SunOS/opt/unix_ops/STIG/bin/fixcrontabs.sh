#!/bin/bash -x

FIX="${*}"
test "X${FIX}" = "X" && FIX='/var/spool/cron/crontabs/* /etc/cron.allow /var/cron/log /etc/cron.d/* /var/spool/cron/atjobs/* '

sleep 1
TSTAMP=`perl -e 'print int(time)'`
SELF=`basename $0`
test "X${FIX}" != "X" && EXIST=`ls -d ${FIX} 2>/dev/null`

test "X${SELF}" != "X" -a "X${TSTAMP}" != "X" -a "X${EXIST}" != "X" && {
  chmod 0600 ${EXIST}  ##GEN003000 ##GEN003360
  chown root ${EXIST} /var/spool/cron/atjobs /var/spool/cron/crontabs ##GEN003040 #GEN003420
  chgrp sys ${EXIST}  /var/spool/cron/atjobs /var/spool/cron/crontabs ##GEN003050 #GEN003430
  chmod A- ${EXIST}  /var/spool/cron/atjobs /var/spool/cron/crontabs ##GEN003090 #GEN002990 #GEN003190 #GEN003210 #GEN003245 #GEN003255 #GEN003410
  chmod 0755 /var/spool/cron/atjobs /var/spool/cron/crontabs #GEN003400 #GEN003020 #GEN003380
}


