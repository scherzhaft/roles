#!/bin/bash -x

OSNAME=`uname -s` ; test "X${OSNAME}" != X || exit
test "X${OSNAME}" != "XLinux" -a "X${OSNAME}" != "XSunOS" && exit
FIX="${*}"
test "X${FIX}" = "X" && {
  test "X${OSNAME}" = "XLinux" && FIX=''
  test "X${OSNAME}" = "XSunOS" && FIX='/etc/system'
  test "X${FIX}" != "X" || exit
}


fixLinux()
{
NOEXECPROGSTACK='password    required      pam_cracklib.so try_first_pass retry=3 minlen=14 difok=4 maxrepeat=3 dcredit=-2 ucredit=-2 ocredit=-2 lcredit=-2'

if grep "^password[\ ]*[a-z]* .*pam_cracklib.so .*difok=[0-9]*" ${EXIST} ; then
  NEEDNOEXECPROGSTACK=`grep -L "^password .*required .*pam_cracklib.so .*difok=4" ${EXIST}`
  if [ "X${NEEDNOEXECPROGSTACK}" != "X" ] ; then
    echo "trying fancy perl"
    perl -p -i.pre${SELF}.${TSTAMP} -e "s|^(password[\ ]*)[a-z]* (.*pam_cracklib.so .*)difok=[0-9]*|\1required \2difok=4|" ${EXIST}
  else
    echo "aready had ${NOEXECPROGSTACK}"
  fi
else
  echo "trying less fancy perl"
  perl -p -i.pre${SELF}.${TSTAMP} -e "s|^(password[\ ]*)[a-z]* (.*pam_cracklib.so .*$)|\1required \2 difok=4|" ${EXIST}
  STILLNEEDNOEXECPROGSTACK=`grep -L "^password .*required .*pam_cracklib.so .*difok=4" ${EXIST}`
  if [ "X${STILLNEEDNOEXECPROGSTACK}" != "X" ] ; then
    echo "trying lamo echo"
    cp ${EXIST} ${EXIST}.pre${SELF}.${TSTAMP}
    grep -v " pam_cracklib.so " ${EXIST}.pre${SELF}.${TSTAMP} > ${EXIST}
    echo "${NOEXECPROGSTACK}" >> ${EXIST}
  fi
fi

}

fixSunOS()
{
NOEXECPROGSTACK='set noexec_user_stack = 1'

if grep "^${NOEXECPROGSTACK}$" ${EXIST} >/dev/null ; then
  echo "aready had ${NOEXECPROGSTACK}"
  exit 0
else
  echo "trying fancy perl"
  perl -p -i.pre${SELF}.${TSTAMP} -e "s|^[#,\s]*set\s.*noexec_user_stack\s*=.*$|${NOEXECPROGSTACK}|g" ${EXIST}
  grep "^${NOEXECPROGSTACK}$" ${EXIST} >/dev/null || {
    echo "trying lamo echo"
    cp ${EXIST} ${EXIST}.pre${SELF}.${TSTAMP}
    echo "${NOEXECPROGSTACK}" >> ${EXIST}
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

