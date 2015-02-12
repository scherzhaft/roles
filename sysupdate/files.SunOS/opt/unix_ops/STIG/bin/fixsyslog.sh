#!/bin/bash -x


/usr/sbin/slack-get log-solaris


FIX="${*}"
test "X${FIX}" = "X" && FIX='/etc/syslog.conf'

sleep 1
TSTAMP=`perl -e 'print int(time)'`
SELF=`basename $0`
test "X${FIX}" != "X" && EXIST=`ls -d ${FIX} 2>/dev/null`

test "X${SELF}" != "X" -a "X${TSTAMP}" != "X" -a "X${EXIST}" != "X" && {
  chmod 640 ${EXIST}
  chown root:sys ${EXIST}
  chmod A- ${EXIST}  ##GEN005395
}

##GEN003660  ##GEN005440  ##GEN005480  ##GEN005450  ##GEN000440  ##GEN006600  ##taken care of in log-solaris slackrole


