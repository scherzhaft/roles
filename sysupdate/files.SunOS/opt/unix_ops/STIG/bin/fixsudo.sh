#!/bin/bash -x

FIX="${*}"
test "X${FIX}" = "X" && FIX='/opt/sfw/etc/sudoers /usr/local/etc/sudoers'


sleep 1
TSTAMP=`perl -e 'print int(time)'`
SELF=`basename $0`
test "X${FIX}" != "X" && EXIST=`ls -d ${FIX} 2>/dev/null`

test "X${SELF}" != "X" -a "X${TSTAMP}" != "X" -a "X${EXIST}" != "X" && {
  chown root:root  ${EXIST}  #GEN001020  ##we use sudo instead of rbac
  chmod 0440 ${EXIST}
  chmod A- ${EXIST}
}

chmod u+s /opt/sfw/bin/sudo /usr/local/bin/sudo
ln -sf /opt/sfw/bin/sudo /usr/local/bin/sudo
chmod A- /opt/sfw/bin/* /opt/sfw/sbin/*


