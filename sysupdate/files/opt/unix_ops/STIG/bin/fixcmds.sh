#!/bin/bash -x


. /etc/default/SYSconstants || exit 4
GREP='grep'


test "X${__STAT}" = "X" && {
  /usr/sbin/slack-get global-solaris-adminfunctions
  . /etc/default/SYSconstants || exit 5
  test "X${__STAT}" = "X" && exit 6
}


test "X${__OSNAME}" = "X" && exit 7
test "X${__OSNAME}" = "XSunOS" && {
  /usr/sbin/slack-get pkg-get
  ${__STAT} --version  || repo install.SFWcoreu
  ${__STAT} --version  || exit 8
  /usr/sfw/bin/ggrep -V || repo install.SUNWggrp
  /usr/sfw/bin/ggrep -V || exit 6
  GREP='/usr/sfw/bin/ggrep'
}


FIX="${*}"
test "X${FIX}" = "X" && FIX=`find /bin /usr/bin /usr/local/bin /usr/lbin /usr/ucb /sbin /usr/sbin /usr/local/sbin  \! -type l ` ##GEN001140

sleep 1
TSTAMP=`perl -e 'print int(time)'`
SELF=`basename $0`
test "X${FIX}" != "X" && EXIST=`ls -d ${FIX} 2>/dev/null`

test "X${SELF}" != "X" -a "X${TSTAMP}" != "X" -a "X${EXIST}" != "X" && {
  test "X${__OSNAME}" = "XSunOS" && chmod A-   ${EXIST}  ##GEN001210
  test "X${__OSNAME}" != "XSunOS" && setfacl --remove-all  ${EXIST}  ##GEN001210
  WITHOWNER=`${__STAT} --printf="%U|%n\n" ${EXIST}`
  SYSACCTSREGEX=`awk -F\: '{if($3 < 500) print "^"$1"|"}' /etc/passwd`
  NEEDCHOWN=`echo "${WITHOWNER}"|${GREP} -v -G "${SYSACCTSREGEX}"|awk -F\| {'print $2'}`
  test "X${NEEDCHOWN}" != "X" && chown root  ${NEEDCHOWN}  ##GEN001220  ##RHEL-06-000048
  chmod go-w ${EXIST} || exit $?  ##GEN001200 ##GEN001180  ##RHEL-06-000047
}


EXIST=''


