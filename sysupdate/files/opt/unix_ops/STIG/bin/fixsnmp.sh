#!/bin/bash -x



. /etc/default/SYSconstants || exit 4
GREP='grep'
test "X${__OSNAME}" != "XLinux" && {
  /usr/sfw/bin/ggrep -V || repo install.SUNWggrp
  /usr/sfw/bin/ggrep -V || exit 6
  GREP='/usr/sfw/bin/ggrep'
}


FIX="${*}"
test "X${FIX}" = "X" && FIX='/etc/sma/snmp/snmpd.conf /var/sma_snmp/snmpd.conf /etc/snmp/conf/snmpd.conf /usr/sfw/lib/sma_snmp/snmpd.conf /var/net-snmp/snmpd.conf /etc/snmp/snmpd.conf'

sleep 1
##RANDOPASS=`cat /dev/urandom| tr -dc 'a-zA-Z0-9-_@%&_:<>='|fold -w 22| head -1`
RANDOPASS='_%Z9<:A9@%__9-a=z&_@0z' 
TSTAMP=`perl -e 'print int(time)'`
SELF=`basename $0`
test "X${FIX}" != "X" && EXIST=`ls -d ${FIX} 2>/dev/null`

test "X${SELF}" != "X" -a "X${TSTAMP}" != "X" -a "X${EXIST}" != "X" -a "X${RANDOPASS}" != "X" && {
  perl -p -i.${TSTAMP}  -e "s|^(.*[\w]+-community)[\s]+[^C,^\n]+|\1    ${RANDOPASS}|g" ${EXIST}  #GEN005300


  sleep 1
  TSTAMP=`perl -e 'print int(time)'`
  perl -p -i.${TSTAMP}  -e "s|([\s]+)public([\s]+)|\1${RANDOPASS}\2|g" ${EXIST}  ##RHEL-06-000341


  sleep 1
  TSTAMP=`perl -e 'print int(time)'`
  DISABLENONV3=`${GREP} -l 'v1\|v2c\|com2sec' ${EXIST}`
  test "X${DISABLENONV3}" != "X" && {
    perl -p -i.${TSTAMP}  -e "s|^|####|g"  ${DISABLENONV3}  ##RHEL-06-000340
  }


  sleep 1
  TSTAMP=`perl -e 'print int(time)'`
  grep snmpv3 ${EXIST} || {
    net-snmp-config --create-snmpv3-user -a "${RANDOPASS}SNMPv3" snmpv3
  }

  chown root ${EXIST}  #GEN005360
  chgrp root ${EXIST}  #GEN005365


  test "X${__OSNAME}" = "XLinux" && {
    /sbin/chkconfig  snmpd off
    /sbin/service snmpd stop
  }


  test "X${__OSNAME}" = "XSunOS" && {
    chmod A- ${EXIST}  #GEN005375
    /usr/sbin/svcadm -v  disable -s svc:/application/management/sma:default  ##GEN005305
  }


  chmod 0600 ${EXIST}  #GEN005320
}


