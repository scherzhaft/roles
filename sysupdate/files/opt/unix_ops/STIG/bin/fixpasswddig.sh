#!/bin/bash -x


##GEN000620  ##RHEL-06-000056
OSNAME=`uname -s` ; test "X${OSNAME}" != X || exit
test "X${OSNAME}" != "XLinux" -a "X${OSNAME}" != "XSunOS" && exit
FIX="${*}"
test "X${FIX}" = "X" && {
  test "X${OSNAME}" = "XLinux" && FIX='/etc/pam.d/system-auth'
  test "X${OSNAME}" = "XSunOS" && FIX='/etc/default/passwd'
  test "X${FIX}" != "X" || exit
}


fixLinux()
{
MINDIG='password    required      pam_cracklib.so try_first_pass retry=3 minlen=14 difok=4 maxrepeat=3 dcredit=-1 ucredit=-1 ocredit=-1 lcredit=-1'

if grep "^password[\ ]*[a-z]* .*pam_cracklib.so .*dcredit=-[0-9]*" ${EXIST} ; then
  NEEDMINDIG=`grep -L "^password .*required .*pam_cracklib.so .*dcredit=-1" ${EXIST}`
  if [ "X${NEEDMINDIG}" != "X" ] ; then
    echo "trying fancy perl"
    perl -p -i.pre${SELF}.${TSTAMP} -e "s|^(password[\ ]*)[a-z]* (.*pam_cracklib.so .*)dcredit=-[0-9]*|\1required \2dcredit=-1|" ${EXIST}
  else
    echo "aready had ${MINDIG}"
  fi
else
  echo "trying less fancy perl"
  perl -p -i.pre${SELF}.${TSTAMP} -e "s|^(password[\ ]*)[a-z]* (.*pam_cracklib.so .*$)|\1required \2 dcredit=-1|" ${EXIST}
  STILLNEEDMINDIG=`grep -L "^password .*required .*pam_cracklib.so .*dcredit=-1" ${EXIST}`
  if [ "X${STILLNEEDMINDIG}" != "X" ] ; then
    echo "trying lamo echo"
    cp ${EXIST} ${EXIST}.pre${SELF}.${TSTAMP}
    grep -v " pam_cracklib.so " ${EXIST}.pre${SELF}.${TSTAMP} > ${EXIST}
    echo "${MINDIG}" >> ${EXIST}
  fi
fi

}

fixSunOS()
{
MINDIG='MINDIGIT=1'

if grep "^${MINDIG}$" ${EXIST} >/dev/null ; then
  echo "aready had ${MINDIG}"
  exit 0
else
  echo "trying fancy perl"
  perl -p -i.pre${SELF}.${TSTAMP} -e "s|^[#,\s]*MINDIGIT=.*$|${MINDIG}|g" ${EXIST}
  grep "^${MINDIG}$" ${EXIST} >/dev/null || {
    echo "trying lamo echo"
    cp ${EXIST} ${EXIST}.pre${SELF}.${TSTAMP}
    echo "${MINDIG}" >> ${EXIST}
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

