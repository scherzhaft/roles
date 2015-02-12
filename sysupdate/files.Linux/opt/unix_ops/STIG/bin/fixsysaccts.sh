#!/bin/bash -x


##RHEL-06-000029

foo=`awk -F\: ' { if ($3 <  500 && $1 != "root") {print "^"$1":"}}' /etc/passwd`
sysacctswithpass=`grep -G "${foo}" /etc/shadow|awk -F\: {'print $1":"$2'}|egrep -v ":\!\!$|:\!\*$"|grep ":....*$"`
test "X${sysacctswithpass}" != "X" && echo "...found sysaccts `echo "${sysacctswithpass}"|perl -p -e "s|\n| |g"` with pass set"


##RHEL-06-000294

/usr/sbin/pwck -r | grep 'no group' && echo "...found user primary gid not listed in /etc/group"
/usr/sbin/pwck -r | grep 'no group'


##RHEL-06-000296

DUPACCTNAMES=`/usr/sbin/pwck -rq`
test "X${DUPACCTNAMES}" != "X" && "...found duplicate account names"


##RHEL-06-000297  ##RHEL-06-000298

echo "no temporary accounts"

exit 0

