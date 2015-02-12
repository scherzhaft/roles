#!/bin/bash -x

OSNAME=`uname -s` ; test "X${OSNAME}" != X || exit
test "X${OSNAME}" != "XLinux" -a "X${OSNAME}" != "XSunOS" && exit
FIX="${*}"
test "X${FIX}" = "X" && {
  test "X${OSNAME}" = "XLinux" && FIX=''
  test "X${OSNAME}" = "XSunOS" && FIX='/etc/default/login'
  test "X${FIX}" != "X" || exit
}


fixLinux()
{
SLEEP='password    required      pam_cracklib.so try_first_pass retry=3 minlen=14 difok=4 maxrepeat=3 dcredit=-2 ucredit=-2 ocredit=-2 lcredit=-2'

if grep "^password[\ ]*[a-z]* .*pam_cracklib.so .*difok=[0-9]*" ${EXIST} ; then
  NEEDSLEEP=`grep -L "^password .*required .*pam_cracklib.so .*difok=4" ${EXIST}`
  if [ "X${NEEDSLEEP}" != "X" ] ; then
    echo "trying fancy perl"
    perl -p -i.pre${SELF}.${TSTAMP} -e "s|^(password[\ ]*)[a-z]* (.*pam_cracklib.so .*)difok=[0-9]*|\1required \2difok=4|" ${EXIST}
  else
    echo "aready had ${SLEEP}"
  fi
else
  echo "trying less fancy perl"
  perl -p -i.pre${SELF}.${TSTAMP} -e "s|^(password[\ ]*)[a-z]* (.*pam_cracklib.so .*$)|\1required \2 difok=4|" ${EXIST}
  STILLNEEDSLEEP=`grep -L "^password .*required .*pam_cracklib.so .*difok=4" ${EXIST}`
  if [ "X${STILLNEEDSLEEP}" != "X" ] ; then
    echo "trying lamo echo"
    cp ${EXIST} ${EXIST}.pre${SELF}.${TSTAMP}
    grep -v " pam_cracklib.so " ${EXIST}.pre${SELF}.${TSTAMP} > ${EXIST}
    echo "${SLEEP}" >> ${EXIST}
  fi
fi

}

fixSunOS()
{
SLEEP='SLEEPTIME=4'

if grep "^${SLEEP}$" ${EXIST} >/dev/null ; then
  echo "aready had ${SLEEP}"
  exit 0
else
  echo "trying fancy perl"
  perl -p -i.pre${SELF}.${TSTAMP} -e "s|^[#,\s]*SLEEPTIME=.*$|${SLEEP}|" ${EXIST}
  grep "^${SLEEP}$" ${EXIST} >/dev/null || {
    echo "trying lamo echo"
    test -s "${EXIST}.pre${SELF}.${TSTAMP}" && {
      cat "${EXIST}.pre${SELF}.${TSTAMP}" > "${EXIST}"
    }

    cp ${EXIST} ${EXIST}.pre${SELF}.${TSTAMP}
    echo "${SLEEP}" >> ${EXIST}
  }
fi

}


sleep 1
TSTAMP=`perl -e 'print int(time)'`
SELF=`basename $0`
test "X${FIX}" != "X" && EXIST=`ls -d ${FIX}`


test "X${SELF}" = "X" -o "X${TSTAMP}" = "X" -o "X${EXIST}" = "X" && exit


eval "fix${OSNAME}"



if [ -f "${EXIST}.pre${SELF}.${TSTAMP}" ] ; then
  diff -u "${EXIST}.pre${SELF}.${TSTAMP}" "${EXIST}"
  diff -u "${EXIST}.pre${SELF}.${TSTAMP}" "${EXIST}" > "${EXIST}.${SELF}.${TSTAMP}.patch"
fi

