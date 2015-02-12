#!/bin/bash -x


. /etc/default/SYSconstants || exit 4

FIX="${*}"
test "X${FIX}" = "X" && FIX='/etc/passwd'


sleep 1
TSTAMP=`perl -e 'print int(time)'`
SELF=`basename $0`
test "X${FIX}" != "X" && EXIST=`ls -d ${FIX} 2>/dev/null`

test "X${SELF}" != "X" -a "X${TSTAMP}" != "X" -a "X${EXIST}" != "X" && {
  test "X${__OSNAME}" = "XSunOS" && chmod A- ${EXIST}  #GEN001390
  test "X${__OSNAME}" != "XSunOS" && setfacl --remove-all ${EXIST}  #GEN001390
  UIDZERONOTROOT=`awk -F\: '($3 == "0" && $1 != "root") {print $1}' /etc/passwd`
  test "X${UIDZERONOTROOT}" != "X" && echo "...found ${UIDZERONOTROOT} account with UID 0"  ##RHEL-06-000032
  HASHESINPASSWD=`awk -F\: '($2 != "x" && $2 != "") {print $1}' /etc/passwd`
  test "X${HASHESINPASSWD}" != "X" && echo "...found ${HASHESINPASSWD} account with hashes in /etc/passwd"  ##RHEL-06-000031
}


