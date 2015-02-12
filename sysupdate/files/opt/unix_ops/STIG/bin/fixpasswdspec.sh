#!/bin/bash -x


##GEN000640  ##RHEL-06-000058
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
MINSPEC='password    required      pam_cracklib.so try_first_pass retry=3 minlen=14 difok=4 maxrepeat=3 dcredit=-1 ucredit=-1 ocredit=-1 lcredit=-1'

if grep "^password[\ ]*[a-z]* .*pam_cracklib.so .*ocredit=-[0-9]*" ${EXIST} ; then
  NEEDMINSPEC=`grep -L "^password .*required .*pam_cracklib.so .*ocredit=-1" ${EXIST}`
  if [ "X${NEEDMINSPEC}" != "X" ] ; then
    echo "trying fancy perl"
    perl -p -i.pre${SELF}.${TSTAMP} -e "s|^(password[\ ]*)[a-z]* (.*pam_cracklib.so .*)ocredit=-[0-9]*|\1required \2ocredit=-1|" ${EXIST}
  else
    echo "aready had ${MINSPEC}"
  fi
else
  echo "trying less fancy perl"
  perl -p -i.pre${SELF}.${TSTAMP} -e "s|^(password[\ ]*)[a-z]* (.*pam_cracklib.so .*$)|\1required \2 ocredit=-1|" ${EXIST}
  STILLNEEDMINSPEC=`grep -L "^password .*required .*pam_cracklib.so .*ocredit=-1" ${EXIST}`
  if [ "X${STILLNEEDMINSPEC}" != "X" ] ; then
    echo "trying lamo echo"
    cp ${EXIST} ${EXIST}.pre${SELF}.${TSTAMP}
    grep -v " pam_cracklib.so " ${EXIST}.pre${SELF}.${TSTAMP} > ${EXIST}
    echo "${MINSPEC}" >> ${EXIST}
  fi
fi

}

fixSunOS()
{
MINSPEC='MINSPECIAL=1'

if grep "^${MINSPEC}$" ${EXIST} >/dev/null ; then
  echo "aready had ${MINSPEC}"
  exit 0
else
  echo "trying fancy perl"
  perl -p -i.pre${SELF}.${TSTAMP} -e "s|^[#,\s]*MINSPECIAL=.*$|${MINSPEC}|g" ${EXIST}
  grep "^${MINSPEC}$" ${EXIST} >/dev/null || {
    echo "trying lamo echo"
    cp ${EXIST} ${EXIST}.pre${SELF}.${TSTAMP}
    echo "${MINSPEC}" >> ${EXIST}
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

