#!/bin/bash -x


. /etc/default/SYSconstants || exit 15
/usr/sfw/bin/ggrep -V || repo install.SUNWggrp
/usr/sfw/bin/ggrep -V || exit 17


FIX="${*}"
test "X${FIX}" = "X" && FIX=`ls -d \`awk -F\: {'print $6'} /etc/passwd |sort -u|awk {'print $1"/.??*"'}|perl -p -e "s|//|/|g"\`|/bin/egrep -e "\.netrc$|\.forward$" `

sleep 1
TSTAMP=`perl -e 'print int(time)'`
SELF=`basename $0`
test "X${FIX}" != "X" && EXIST=`find ${FIX} 2>/dev/null`

test "X${SELF}" != "X" -a "X${TSTAMP}" != "X" -a "X${EXIST}" != "X" && {
  rm -f   ${EXIST}  || exit $?  ##GEN002000  ##GEN004580
}



FIX=`ls -d \`awk -F\: {'print $6'} /etc/passwd |sort -u|awk {'print $1"/.??*"'}|perl -p -e "s|//|/|g"\``

sleep 1
TSTAMP=`perl -e 'print int(time)'`
SELF=`basename $0`
test "X${FIX}" != "X" && find ${FIX} -print -exec chmod A- {} \;  2>/dev/null  ##GEN001890



test "X${FIX}" != "X" && find `echo "${FIX}"|/usr/bin/grep -v "/\.dt[^\/]*"`  \( -perm -o+r -o -perm -o+w -o -perm -o+x -o -perm -g+w -o -perm -g+x  \) -print -exec chmod g-wx,o-rwx {} \;   ##GEN001880




test "X${FIX}" != "X" && EXIST=`echo "${FIX}"|/usr/bin/grep  "/\.xscreensaver$"`
EXIST=`echo "${EXIST}
/usr/openwin/lib/app-defaults/XScreenSaver"|sort -u|/bin/grep '.'`
EXIST=`ls -d ${EXIST} 2>/dev/null`

test "X${SELF}" != "X" -a "X${TSTAMP}" != "X" -a "X${EXIST}" != "X" && {
for path in `echo "${EXIST}"` ; do
  test -d "${path}" && continue

  DEATHLOCK=`/bin/grep "^\*lock:"  ${path}|awk {'print $2'}`
  test "X${DEATHLOCK}" != "XTrue" && {
    perl -p -i.pre${SELF}.${TSTAMP} -e "s|^\*lock:.*$|\*lock:                  True|g"  ${path}
  }
  DEATHLOCK=`/bin/grep "^\*lock:"  ${path}|awk {'print $2'}`
  test "X${DEATHLOCK}" != "XTrue" && {
    echo '*lock:                  True' >> ${path}
  }

  sleep 1
  TSTAMP=`perl -e 'print int(time)'`

  OUTATIME=`/bin/grep "^\*timeout:"  ${path}|awk {'print $2'}`
  test "X${OUTATIME}" != "X0:15:00" && {
    perl -p -i.pre${SELF}.${TSTAMP} -e "s|^\*timeout:.*$|\*timeout:               0:15:00|g"  ${path}
  }
  OUTATIME=`/bin/grep "^\*timeout:"  ${path}|awk {'print $2'}`
  test "X${OUTATIME}" != "X0:15:00" && {
    echo '*timeout:               0:15:00' >> ${path}
  }

done  ##GEN000500
}



test "X${FIX}" != "X" && EXIST=`echo "${FIX}"|/usr/bin/grep  "/\.dt[^\/]*$"`

test "X${SELF}" != "X" -a "X${TSTAMP}" != "X" -a "X${EXIST}" != "X" && {
  chmod g-w,o-w  ${EXIST}  || exit $?  ##.dt and .dtprofile are allowed to be 755
}



FIX=`awk -F\: '{if ( $6 != "/" && $6 != "" && $1 == "ftp" ) {print $6"/.??*"}}' /etc/passwd `
sleep 1
test "X${FIX}" != "X" && EXIST=`ls -d  ${FIX} 2>/dev/null|/usr/bin/grep -v "/\.[a-z]*sh_history$"|/usr/xpg4/bin/grep -E "(\.bash|\.csh|\.login|\.local|\.profile)"`  ##GEN005040
for path in `echo "${EXIST}"` ; do
  test -d "${path}" && continue
  tail -1 "${path}"|grep "^umask .*077$" && continue
  echo "NEEDS umask"
  echo "umask 077" >> "${path}"
done



####FIX=`awk -F\: '{if ($6 != "/" && $6 != "" && $1 != "" ) {print "chown -R "$1" "$6"/.??*"}}' /etc/passwd `
FIX=`awk -F\: '{if ( $6 != "/" && $6 != "" && $1 != "" && $4 != "" ) {print $1":"$4" "$6"/.??*"}}' /etc/passwd `

OLDIFS="${IFS}"
sleep 1
IFS='
'

for fixme in ${FIX} ; do
  testlen=`echo "${fixme}"|awk '{print NF}'`
  test "X${testlen}" != "X2" && continue
  pwnerer=`echo "${fixme}"|awk {'print $1'}`
  profilepath=`echo "${fixme}"|awk {'print $2'}`
  notroots=`find ${profilepath} \! -group root`
  test "X${notroots}" != "X" && {
    chown  ${pwnerer} ${notroots}    ##GEN001860  ##GEN001870
  }
done

IFS="${OLDIFS}"



FIX=`awk -F\: '{if ( $6 != "" ) {print $6"/.??*"}}' /etc/passwd|perl -p -e "s|//|/|g"|sort -u`

test "X${FIX}" != "X" && EXIST=`/usr/sfw/bin/ggrep  -l "PATH.*:\." \`ls -d ${FIX} 2>/dev/null|/usr/bin/grep -v "/\.[a-z]*sh_history$"\``

test "X${SELF}" != "X" -a "X${TSTAMP}" != "X" -a "X${EXIST}" != "X" && {
  echo "...found bad paths"
  echo "${EXIST}"  ##GEN001900
}



test "X${FIX}" != "X" && EXIST=`/usr/sfw/bin/ggrep  -l "LD_LIBRARY_PATH.*:\." \`ls -d ${FIX} 2>/dev/null|/usr/bin/grep -v "/\.[a-z]*sh_history$"\``

test "X${SELF}" != "X" -a "X${TSTAMP}" != "X" -a "X${EXIST}" != "X" && {
  echo "...found bad lib paths"
  echo "${EXIST}"  ##GEN001901
}


test "X${FIX}" != "X" && EXIST=`/usr/sfw/bin/ggrep  -l "LD_PRELOAD.*:\." \`ls -d ${FIX} 2>/dev/null|/usr/bin/grep -v "/\.[a-z]*sh_history$"\``

test "X${SELF}" != "X" -a "X${TSTAMP}" != "X" -a "X${EXIST}" != "X" && {
  echo "...found bad preload paths"
  echo "${EXIST}"  ##GEN001902
}



sleep 2
FIX=`/usr/bin/find / \! -local -prune -o -acl -print`
test "X${FIX}" != "X" && EXIST=`ls -d ${FIX} 2>/dev/null`

test "X${SELF}" != "X" -a "X${TSTAMP}" != "X" -a "X${EXIST}" != "X" && {  ##GEN001570
  echo "...found acl's"
  echo "${EXIST}"
}


