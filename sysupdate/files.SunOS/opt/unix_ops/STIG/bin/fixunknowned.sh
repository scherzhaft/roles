#!/bin/bash -x


. /etc/default/SYSconstants || exit 4
/usr/sfw/bin/ggrep -V || repo install.SUNWggrp
/usr/sfw/bin/ggrep -V || exit 6


DANGERZONEPATHS=`/usr/sbin/zoneadm list -cv|grep -v " global "|awk {'print $4'}|grep -v "^PATH$"`

test "X${DANGERZONEPATHS}" != "X" && FILTER=`echo "${DANGERZONEPATHS}"|awk {'print "^"$1'}`

SAFEPATHS=`/usr/bin/find \`ls -d /*|grep -v "^/zone"|grep -v "^/system"|grep -v "^/proc"|grep -v "^/dev"\` \! -local -prune  -o -nouser -print`


test "X${FILTER}" != "X" && {
  SAFEPATHS=`echo "${SAFEPATHS}"|/usr/sfw/bin/ggrep -v -G "${FILTER}"`
}

OLDIFS="${IFS}"
sleep 1
IFS='
'

for i in ${SAFEPATHS} ; do
  echo "chown root ${i}"
  chown root "${i}"  ##GEN001160
done

SAFEPATHS=`/usr/bin/find \`ls -d /*|grep -v "^/zone"|grep -v "^/system"|grep -v "^/proc"|grep -v "^/dev"\` \! -local -prune  -o -nogroup -print`


test "X${FILTER}" != "X" && {
  SAFEPATHS=`echo "${SAFEPATHS}"|/usr/sfw/bin/ggrep -v -G "${FILTER}"`
}

for i in ${SAFEPATHS} ; do
  echo "chgrp root ${i}"
  chgrp root "${i}"  ##GEN001170
done


IFS="${OLDIFS}"
sleep 1


