#!/bin/bash -x


##SUNWusb
OSNAME=`uname -s` ; test "X${OSNAME}" != X || exit
test "X${OSNAME}" != "XLinux" -a "X${OSNAME}" != "XSunOS" && exit
FIX="${*}"
test "X${FIX}" = "X" && {
  test "X${OSNAME}" = "XLinux" && FIX=''
  test "X${OSNAME}" = "XSunOS" && FIX='SUNWrcmdr SUNWsmbaS SUNWsmbac SUNWsmbar SUNWsmbau'  ##GEN003825  ##GEN003835  ##GEN003845
  test "X${FIX}" != "X" || exit
}


fixLinux()
{
SRCRTDPACKETS='password    required      pam_cracklib.so try_first_pass retry=3 minlen=14 difok=4 maxrepeat=3 dcredit=-2 ucredit=-2 ocredit=-2 lcredit=-2'

if grep "^password[\ ]*[a-z]* .*pam_cracklib.so .*difok=[0-9]*" ${EXIST} ; then
  NEEDSRCRTDPACKETS=`grep -L "^password .*required .*pam_cracklib.so .*difok=4" ${EXIST}`
  if [ "X${NEEDSRCRTDPACKETS}" != "X" ] ; then
    echo "trying fancy perl"
    perl -p -i.pre${SELF}.${TSTAMP} -e "s|^(password[\ ]*)[a-z]* (.*pam_cracklib.so .*)difok=[0-9]*|\1required \2difok=4|" ${EXIST}
  else
    echo "aready had ${SRCRTDPACKETS}"
  fi
else
  echo "trying less fancy perl"
  perl -p -i.pre${SELF}.${TSTAMP} -e "s|^(password[\ ]*)[a-z]* (.*pam_cracklib.so .*$)|\1required \2 difok=4|" ${EXIST}
  STILLNEEDSRCRTDPACKETS=`grep -L "^password .*required .*pam_cracklib.so .*difok=4" ${EXIST}`
  if [ "X${STILLNEEDSRCRTDPACKETS}" != "X" ] ; then
    echo "trying lamo echo"
    cp ${EXIST} ${EXIST}.pre${SELF}.${TSTAMP}
    grep -v " pam_cracklib.so " ${EXIST}.pre${SELF}.${TSTAMP} > ${EXIST}
    echo "${SRCRTDPACKETS}" >> ${EXIST}
  fi
fi

}

fixSunOS()
{
test "X${FIX}" != "X" && EXIST=`cd /var/sadm/pkg && ls -d ${FIX} 2>/dev/null`

test "X${EXIST}" != "X" && /usr/sbin/pkgrm -M -n -a /var/pkg-get/admin-fullauto ${EXIST}

}


sleep 1
TSTAMP=`perl -e 'print int(time)'`
SELF=`basename $0`


test "X${SELF}" = "X" -o "X${TSTAMP}" = "X"  && exit


eval "fix${OSNAME}"



if [ -f "${EXIST}.pre${SELF}.${TSTAMP}" ] ; then
  diff -u "${EXIST}.pre${SELF}.${TSTAMP}" "${EXIST}"
  diff -u "${EXIST}.pre${SELF}.${TSTAMP}" "${EXIST}" > "${EXIST}.${SELF}.${TSTAMP}.patch"
fi

