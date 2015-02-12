#!/bin/bash -x

##GEN002860  ##GEN000000-SOL00040  ##RHEL-06-000313  ##RHEL-06-000311
##RHEL-06-000159  ##RHEL-06-000161  ##RHEL-06-000160  ##RHEL-06-000005  ##RHEL-06-000136  ##RHEL-06-000137
##RHEL-06-000510  ##RHEL-06-000511  ##RHEL-06-000154  ##RHEL-06-000148  ##RHEL-06-000145  ##RHEL-06-000383  ##RHEL-06-000384  ##RHEL-06-000522  ##RHEL-06-000385  ##RHEL-06-000522



. /etc/default/SYSconstants || exit 4
GREP='grep'
test "X${__OSNAME}" != "XLinux" && {
  /usr/sfw/bin/ggrep -V || repo install.SUNWggrp
  /usr/sfw/bin/ggrep -V || exit 6
  GREP='/usr/sfw/bin/ggrep'
}


test -f /export/home/steckers/.bash_login && . /export/home/steckers/.bash_login
HOSTNAME=`/bin/hostname|awk -F. {'print $1'}` ; test "X${HOSTNAME}" = "X" && exit
SELFDIR=`dirname $0`
export PATH=/sbin:/usr/sbin:${PATH}


FSTAB=/etc/fstab
test "X${1}" != "X" && FSTAB="$1"
test -f ${FSTAB} || FSTAB=/etc/vfstab
test -f ${FSTAB} || exit

TSTAMP=`perl -e 'print int(time)'` ; test "X${TSTAMP}" != "X" || exit
OSNAME=`uname -s` ; test "X${OSNAME}" != X || exit
AUDITVOL="/vol/audit"
MOUNTPOINT="/audit"
mkdir -p ${MOUNTPOINT}
MNTINUSE=`df -h ${MOUNTPOINT} 2>/dev/null|tail -1|awk {'print $NF'}`
test "X${MNTINUSE}" != "X/" && exit
LinuxFSTAB='${AUDITNAS}:${AUDITVOL}    ${MOUNTPOINT}    nfs    rw,bg,hard,rsize=32768,wsize=32768,vers=3,nosuid,nointr,tcp,timeo=600,noexec,addr=${MYADDR}  0 0'
SunOSFSTAB='${AUDITNAS}:${AUDITVOL}    -    ${MOUNTPOINT}    nfs     -       yes     proto=tcp,hard,nosuid'

MYIPS=`ifconfig -a|grep '.'|${GREP} "\W.*inet"|perl -p -e "s| addr:| |g"|awk {'print $2'}|grep "^[0-9].*\.[0-9].*\.[0-9].*\.[0-9].*"|sort -u|grep -v "^127.0.0.1$"`

MYBKUPIP=`echo "${MYIPS}"|grep "^[0-9].*\.[0-9].*\.99\.[0-9].*$"|head -1`
MYPRODIP=`echo "${MYIPS}"|grep "^[0-9].*\.[0-9].*\.98\.[0-9].*$"|head -1`
MYDMZIP=`echo "${MYIPS}"|grep "^[0-9].*\.[0-9].*\.96\.[0-9].*$"|head -1`


trybkup()
{
echo "I have a backup-net interface"
AUDITNAS="b_foo"
getent hosts ${AUDITNAS} >/dev/null
if [ "X${?}" != "X0" ] ; then
  PRODNAS=`echo "${AUDITNAS}"|sed -e "s|^b_||"`
  test "X${PRODNAS}" != "X" && PRODNASIP=`getent hosts ${PRODNAS}|awk {'print $1'}`
  test "X${PRODNASIP}" != "X" && BKUPNASIP=`echo "${PRODNASIP}"|awk -F. {'print $1"."$2".99."$4'}`
  if [ "X${BKUPNASIP}" != "X" ] ; then
    echo "${BKUPNASIP}    ${AUDITNAS}" >> /etc/hosts
    /etc/init.d/nscd stop
    /etc/init.d/nscd start
    sleep 4
    start=1
    for i in {1..70} ; do
      getent hosts ${AUDITNAS} && break
      sleep 2
      start=`expr 1 + ${start}`
      echo again
    done
    echo "${start}" > /tmp/nscd_hit_count.${TSTAMP}
  fi
fi
}



tryprod()
{
AUDITNAS=''
MYADDR=''
echo "WARNING:   backup-net interface problematic or doesn't exist...trying prod interface"
AUDITNAS="foo"
getent hosts ${AUDITNAS} >/dev/null
if [ "X${?}" != "X0" ] ; then
  echo "Error:  This system is unable to resolve ${AUDITNAS}...exiting"
  return
fi

sleep 2
if ping -c11 ${AUDITNAS} ; then
  MYADDR="${MYPRODIP}"
fi
}


setupmount()
{
MYFSTAB_formula=`eval echo \"\\$${OSNAME}FSTAB\"`
MYFSTAB=`eval echo "\"${MYFSTAB_formula}\""`
##MYFILTER=`echo "${MYFSTAB}"|perl -p -e "s|[ \t]+|\W.*|g"|perl -p -e "s|b_||"`
##MYFILTER=`echo "${MYFSTAB}"|perl -p -e "s|[ \t]+|\\\\\\\\W.*|g"|perl -p -e "s|b_||"`
cp "${FSTAB}" "${FSTAB}.preaudit.${TSTAMP}"
grep -v "[[:space:]].*/audit[[:space:]].*" "${FSTAB}.preaudit.${TSTAMP}" > "${FSTAB}.new.${TSTAMP}"
if [ -s "${FSTAB}.new.${TSTAMP}" ] ; then
  cat "${FSTAB}.new.${TSTAMP}" > ${FSTAB}
  echo "${MYFSTAB}" >> ${FSTAB}
fi


test -f "${FSTAB}.preaudit.${TSTAMP}" && CHANGE=`diff -u "${FSTAB}.preaudit.${TSTAMP}" ${FSTAB}|grep -v "^No differences encountered$"`
test "X${CHANGE}" != "X" && diff -u "${FSTAB}.preaudit.${TSTAMP}" ${FSTAB} > "${FSTAB}.auditpatch.${TSTAMP}"
test -f "${FSTAB}.auditpatch.${TSTAMP}" && cat "${FSTAB}.auditpatch.${TSTAMP}"
test "X${CHANGE}" != "X" && mount ${MOUNTPOINT}
sleep 1


MNTINUSE=`df -h ${MOUNTPOINT} 2>/dev/null|tail -1|awk {'print $6'}`
test "X${MNTINUSE}" != "X${MOUNTPOINT}" && exit

}



if [ "X${MYBKUPIP}" != "X" ] ; then
  trybkup
  ping -c11 ${AUDITNAS}
  sleep 2
  if ping -c11 ${AUDITNAS} ; then
    MYADDR="${MYBKUPIP}"
  else
    tryprod
  fi
else
  tryprod
fi


if [ "X${MYADDR}" != "X" ] ; then
  setupmount
  mkdir -p "${MOUNTPOINT}/${HOSTNAME}"
else
  mkdir -p "${MOUNTPOINT}"
  ln -s /var/log/audit "/audit/${HOSTNAME}"
fi


case "${OSNAME}" in
  Linux)
    CRON=/etc/cron.allow
    ENABLEROOTCRON=`printf "\`cat ${CRON}\`\nroot\n"|sort -ru`
    HOME=/home/garfield
    cp /etc/audit/auditd.conf /etc/audit/auditd.conf.bak.${TSTAMP}
    echo 'log_file = %NASAUDIT%/audit.log
log_format = RAW
priority_boost = 3
flush = INCREMENTAL
freq = 20
num_logs = 5
#dispatcher = /sbin/audispd
max_log_file = 100
##max_log_file_action = keep_logs
max_log_file_action = rotate
space_left = 75
#space_left_action = SYSLOG
space_left_action = email
action_mail_acct = root
admin_space_left = 50
admin_space_left_action = SYSLOG
disk_full_action = SYSLOG
disk_error_action = SYSLOG'|perl -p -e "s|%NASAUDIT%|${MOUNTPOINT}/${HOSTNAME}|g"  > /etc/audit/auditd.conf

    sleep 1
    echo
    /sbin/chkconfig --level 0126  auditd off
    /sbin/chkconfig --level 345 auditd on
    /sbin/chkconfig --level 345 nfs on
    /sbin/chkconfig --level 345 nfslock on
    /sbin/chkconfig --level 345 portmap on
    /sbin/chkconfig --level 345 netfs on
    rm -f /etc/rc?.d/S??auditd  /etc/rc?.d/K??auditd
    sleep 1
    ln -sf /etc/init.d/auditd  /etc/rc3.d/S99auditd
    ln -sf /etc/init.d/auditd  /etc/rc4.d/S99auditd
    ln -sf /etc/init.d/auditd  /etc/rc5.d/S99auditd
    ln -sf /etc/init.d/auditd  /etc/rc0.d/K01auditd
    ln -sf /etc/init.d/auditd  /etc/rc1.d/K01auditd
    ln -sf /etc/init.d/auditd  /etc/rc2.d/K01auditd
    ln -sf /etc/init.d/auditd  /etc/rc6.d/K01auditd
    sleep 1
    ls -ld /etc/rc?.d/S??auditd  /etc/rc?.d/K??auditd
    /etc/init.d/auditd stop
    sleep 3
    /etc/init.d/auditd start
    sleep 2
 
  ;;
  SunOS)
    CRON=/etc/cron.d/cron.allow
    ENABLEROOTCRON=`printf "\`cat ${CRON} /etc/cron.allow \`\nroot\n"|sort -ru`
    sleep 1
    ln -sf ${CRON} /etc/cron.allow
    HOME=/export/home/garfield
    cp /etc/security/audit_control /etc/security/audit_control.bak.${TSTAMP}
    echo '#
# Copyright (c) 1988 by Sun Microsystems, Inc.
#
# ident "@(#)audit_control.txt 1.4 00/07/17 SMI"
#
dir:%NASAUDIT%
flags:lo,fr,fd,am,fm,as
naflags:lo,am,-ex,-nt,-fw,-fa,-fm,-fd,-nt,-pc,as
minfree:20'|perl -p -e "s|%NASAUDIT%|${MOUNTPOINT}/${HOSTNAME}|g" > /etc/security/audit_control 
    sleep 1

    /usr/sbin/svcadm -v enable -s svc:/network/rpc/bind:default
    /usr/sbin/svcadm -v enable -s svc:/network/nfs/status:default
    /usr/sbin/svcadm -v enable -s svc:/network/nfs/nlockmgr:default
    /usr/sbin/svcadm -v enable -s svc:/network/nfs/mapid:default
    /usr/sbin/svcadm -v enable -s svc:/network/nfs/cbd:default
    /usr/sbin/svcadm -v enable -s svc:/network/nfs/rquota:default
    /usr/sbin/svcadm -v enable -s svc:/network/nfs/client:default

    sleep 1
    /usr/sbin/svcadm disable svc:/system/auditd:default
    sleep 3
    /usr/sbin/svcadm enable svc:/system/auditd:default
    sleep 2

esac


find /var/audit "${MOUNTPOINT}/${HOSTNAME}" -type f -exec chown root:root {} \;
find /var/audit "${MOUNTPOINT}/${HOSTNAME}" -type f -exec chmod 0640 {} \;
chmod go-w /var/audit "${MOUNTPOINT}/${HOSTNAME}"
chmod 640 /etc/security/audit_*
chown root:sys /etc/security/audit_user
chmod 0750 /usr/sbin/auditd /usr/sbin/audit /usr/sbin/bsmrecord /usr/sbin/auditreduce /usr/sbin/praudit /usr/sbin/auditconfig


test "X${HOME}" = "X" && exit
test "X${CRON}" = "X" && exit


test "X${ENABLEROOTCRON}" != "X" && echo "${ENABLEROOTCRON}" > ${CRON}
mkdir -p "${HOME}"

test -f "${SELFDIR}/compressaudit.sh" && cp "${SELFDIR}/compressaudit.sh" "${HOME}"

test -f "${HOME}/compressaudit.sh" && {
  chmod 755 "${HOME}/compressaudit.sh"
  crontab -l|grep -v '/compressaudit\.sh' > /tmp/$$cronedit
  echo '22 3,15 * * *'" ${HOME}/compressaudit.sh"' > /dev/null 2>&1' >> /tmp/$$cronedit
  crontab /tmp/$$cronedit


}
