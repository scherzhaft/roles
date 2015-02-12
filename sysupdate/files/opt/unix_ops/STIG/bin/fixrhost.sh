#!/bin/bash -x


##GEN001980  ##GEN002060  ##GEN002020  ##RHEL-06-000019
TSTAMP=`perl -e 'print int(time)'`
SELF=`basename $0`
test "X${SELF}" = "X" -o "X${TSTAMP}" = "X" && exit



LOOKHERE4RACCESS="/lib /opt /lib64 /bin /home /boot /sbin /usr /etc /root /var /export"
RMLIST=`find ${LOOKHERE4RACCESS} -name .rhosts -o -name .shosts -o -name hosts.equiv -o -name shosts.equiv|awk '{if ($1 != "" ) { print "rm "$1}}'`
test "X${RMLIST}" != "X" && echo "${RMLIST}" > /tmp/${SELF}.${TSTAMP}.rmlog
test -f /tmp/${SELF}.${TSTAMP}.rmlog && echo "...found  execute /tmp/${SELF}.${TSTAMP}.rmlog to remove the following ####"
echo
test -f /tmp/${SELF}.${TSTAMP}.rmlog && cat /tmp/${SELF}.${TSTAMP}.rmlog
echo
grep '+' /etc/passwd /etc/shadow /etc/group && {
  echo
  echo "...found...remove"
  } 
