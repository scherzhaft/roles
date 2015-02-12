#!/bin/bash -x


. /etc/default/SYSconstants || exit 4
/usr/sfw/bin/ggrep -V || repo install.SUNWggrp
/usr/sfw/bin/ggrep -V || exit 6


DANGERZONEPATHS=`/usr/sbin/zoneadm list -cv|grep -v " global "|awk {'print $4'}|grep -v "^PATH$"`

test "X${DANGERZONEPATHS}" != "X" && FILTER=`echo "${DANGERZONEPATHS}"|awk {'print "^"$1'}`


SAFEPATHS=`/usr/bin/find \`ls -d /*|grep -v "^/zone"|grep -v "^/system"|grep -v "^/proc"|grep -v "^/tmp"|grep -v "^/dev"\` \! -local -prune -o  \( \! -perm -1000 -a -perm -o+w -a \( -type f -o -type d \) \) -print|grep -v "^/var/tmp"|grep -v "/tmp$"|grep -v "/tmp/"|grep -v "^/var/adm/spellhist"|grep -v "^/var/dt/dtpower/_current_scheme"|grep -v "^/usr/oasys/tmp/TERRLOG"|grep -v "^/var/imq/lic/imqbrokertry.lic"`


test "X${FILTER}" != "X" && {
  SAFEPATHS=`echo "${SAFEPATHS}"|/usr/sfw/bin/ggrep -v -G "${FILTER}"`
}


OLDIFS="${IFS}"
sleep 1
IFS='
'

for i in ${SAFEPATHS} ; do
  echo "chmod o-w ${i} "
  chmod o-w ${i}    #GEN001640 #GEN002480 #GEN002280
done


IFS="${OLDIFS}"
sleep 1


exit 0


