#!/bin/bash -x


##RHEL-06-000248  ##RHEL-06-000247
OSNAME=`uname -s` ; test "X${OSNAME}" != X || exit
test "X${OSNAME}" != "XLinux" -a "X${OSNAME}" != "XSunOS" && exit
FIX="${*}"
test "X${FIX}" = "X" && {
  test "X${OSNAME}" = "XLinux" && FIX='/usr/sbin/ntpdate'
  test "X${OSNAME}" = "XSunOS" && FIX='/usr/sbin/ntpdate'
  test "X${FIX}" != "X" || exit
}

fixSunOS()
{
  /usr/sbin/svcadm -v enable -s svc:/system/cron:default
  export CRONALLOW=/etc/cron.d/cron.allow
  fixLinux
}

fixLinux()
{
ENABLEROOTCRON=`printf "\`cat ${CRONALLOW}  /etc/cron.allow 2>/dev/null \`\nroot\n"|sort -ru`
test "X${CRONALLOW}" != "X" &&  ln -sf ${CRONALLOW} /etc/cron.allow
test "X${ENABLEROOTCRON}" != "X" && echo "${ENABLEROOTCRON}" > /etc/cron.allow


test "X${OSNAME}" = "XLinux" && {
  ##RHEL-06-000224
  /sbin/chkconfig crond on
  /sbin/service crond start
  }


crontab -l|grep "${NTPONESHOT}" || {
  crontab -l|grep -v '/ntpdate' > /tmp/$$crontab.pre${SELF}.${TSTAMP}
  cp /tmp/$$crontab.pre${SELF}.${TSTAMP} /tmp/$$crontab.edit${SELF}.${TSTAMP}
  echo '0 2 * * *'" ${NTPONESHOT}"' > /dev/null 2>&1' >> /tmp/$$crontab.edit${SELF}.${TSTAMP}
  crontab /tmp/$$crontab.edit${SELF}.${TSTAMP}
}

cat << __EOF__ > /etc/rc3.d/S99ntponeshot
#!/bin/bash


${NTPONESHOT}

exit 0
__EOF__

}




sleep 1
TSTAMP=`perl -e 'print int(time)'`
SELF=`basename $0`
test "X${FIX}" != "X" && EXIST=`ls -d ${FIX}`
NTPONESHOT="/usr/sbin/ntpdate foo.foo.foo.foo foo.foo.foo.foo foo.foo.foo.foo foo.foo.foo.foo"  ##GEN000240  ##GEN000241 ##GEN000242 ##GEN000244  ##GEN000246

test "X${SELF}" = "X" -o "X${TSTAMP}" = "X" -o "X${EXIST}" = "X" && exit


eval "fix${OSNAME}"

chmod 755 /etc/rc3.d/S99ntponeshot

if [ -f "/tmp/$$crontab.edit${SELF}.${TSTAMP}" -a "/tmp/$$crontab.pre${SELF}.${TSTAMP}" ] ; then
  diff -u "/tmp/$$crontab.pre${SELF}.${TSTAMP}" "/tmp/$$crontab.edit${SELF}.${TSTAMP}"
  diff -u "/tmp/$$crontab.pre${SELF}.${TSTAMP}" "/tmp/$$crontab.edit${SELF}.${TSTAMP}" > /tmp/$$crontab${SELF}.${TSTAMP}.patch
  cp /tmp/$$crontab* ~
else
  echo "already has ntp cron"
fi

