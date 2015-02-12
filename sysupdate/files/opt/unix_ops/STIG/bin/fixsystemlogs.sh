#!/bin/bash -x


. /etc/default/SYSconstants || exit 4

FIX="${*}"
test "X${FIX}" = "X" && FIX='/var/adm  /var/log'


sleep 1
TSTAMP=`perl -e 'print int(time)'`
SELF=`basename $0`
test "X${FIX}" != "X" && EXIST=`find ${FIX} \( -perm -o+r -o -perm -o+w -o -perm -o+x -o -perm -g+w -o -perm -g+x  \) -a \! \( -type d -o -name "*tmpx" -o -name "utmp*" -o -name "btmp*" -o -name "wtmp*" -o -name lastlog -o -name "sa[0-9]*" \)`

test "X${SELF}" != "X" -a "X${TSTAMP}" != "X" -a "X${EXIST}" != "X" && {
  chmod g-wx,o-rwx ${EXIST}  ##GEN001260  ##RHEL-06-000135
}


test "X${FIX}" != "X" && EXIST=`find ${FIX} \! \( -type d -o -name "*tmpx" \)`

test "X${SELF}" != "X" -a "X${TSTAMP}" != "X" -a "X${EXIST}" != "X" && {
  chown root:root ${EXIST}  ##RHEL-06-000134  ##RHEL-06-000133
  test "X${__OSNAME}" = "XSunOS" && chmod A- ${EXIST}  ##GEN001270
  test "X${__OSNAME}" != "XSunOS" && setfacl --remove-all  ${EXIST} 
}


chmod 0600 /var/adm/maillog* /var/adm/secure* /var/adm/cron* /var/log/maillog* /var/log/secure* /var/log/cron*


