#!/bin/bash -x


##GEN000680  ##RHEL-06-000299
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
MAXREP='password    required      pam_cracklib.so try_first_pass retry=3 minlen=14 difok=4 maxrepeat=3 dcredit=-1 ucredit=-1 ocredit=-1 lcredit=-1'

if grep "^password[\ ]*[a-z]* .*pam_cracklib.so .*maxrepeat=[0-9]*" ${EXIST} ; then
  NEEDMAXREP=`grep -L "^password .*required .*pam_cracklib.so .*maxrepeat=3" ${EXIST}`
  if [ "X${NEEDMAXREP}" != "X" ] ; then
    echo "trying fancy perl"
    perl -p -i.pre${SELF}.${TSTAMP} -e "s|^(password[\ ]*)[a-z]* (.*pam_cracklib.so .*)maxrepeat=[0-9]*|\1required \2maxrepeat=3|" ${EXIST}
  else
    echo "aready had ${MAXREP}"
  fi
else
  echo "trying less fancy perl"
  perl -p -i.pre${SELF}.${TSTAMP} -e "s|^(password[\ ]*)[a-z]* (.*pam_cracklib.so .*$)|\1required \2 maxrepeat=3|" ${EXIST}
  STILLNEEDMAXREP=`grep -L "^password .*required .*pam_cracklib.so .*maxrepeat=3" ${EXIST}`
  if [ "X${STILLNEEDMAXREP}" != "X" ] ; then
    echo "trying lamo echo"
    cp ${EXIST} ${EXIST}.pre${SELF}.${TSTAMP}
    grep -v " pam_cracklib.so " ${EXIST}.pre${SELF}.${TSTAMP} > ${EXIST}
    echo "${MAXREP}" >> ${EXIST}
  fi
fi

}

fixSunOS()
{
MAXREP='MAXREPEATS=3'

if grep "^${MAXREP}$" ${EXIST} >/dev/null ; then
  echo "aready had ${MAXREP}"
  exit 0
else
  echo "trying fancy perl"
  perl -p -i.pre${SELF}.${TSTAMP} -e "s|^[#,\s]*MAXREPEATS=.*$|${MAXREP}|g" ${EXIST}
  grep "^${MAXREP}$" ${EXIST} >/dev/null || {
    echo "trying lamo echo"
    cp ${EXIST} ${EXIST}.pre${SELF}.${TSTAMP}
    echo "${MAXREP}" >> ${EXIST}
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

