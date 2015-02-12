#!/bin/bash -x

OSNAME=`uname -s` ; test "X${OSNAME}" != X || exit
test "X${OSNAME}" != "XLinux" -a "X${OSNAME}" != "XSunOS" && exit
FIX="${*}"
test "X${FIX}" = "X" && {
  test "X${OSNAME}" = "XLinux" && FIX='/etc/pam.d/system-auth'
  test "X${OSNAME}" = "XSunOS" && FIX='/etc/security/policy.conf /etc/default/login'
  test "X${FIX}" != "X" || exit
}


fixLinux()
{
STRIKE3='password    required      pam_cracklib.so try_first_pass retry=3 minlen=14 difok=4 maxrepeat=3 dcredit=-2 ucredit=-2 ocredit=-2 lcredit=-2'

if grep "^password[\ ]*[a-z]* .*pam_cracklib.so .*difok=[0-9]*" ${EXIST} ; then
  NEEDSTRIKE3=`grep -L "^password .*required .*pam_cracklib.so .*difok=4" ${EXIST}`
  if [ "X${NEEDSTRIKE3}" != "X" ] ; then
    echo "trying fancy perl"
    perl -p -i.pre${SELF}.${TSTAMP} -e "s|^(password[\ ]*)[a-z]* (.*pam_cracklib.so .*)difok=[0-9]*|\1required \2difok=4|" ${EXIST}
  else
    echo "aready had ${STRIKE3}"
  fi
else
  echo "trying less fancy perl"
  perl -p -i.pre${SELF}.${TSTAMP} -e "s|^(password[\ ]*)[a-z]* (.*pam_cracklib.so .*$)|\1required \2 difok=4|" ${EXIST}
  STILLNEEDSTRIKE3=`grep -L "^password .*required .*pam_cracklib.so .*difok=4" ${EXIST}`
  if [ "X${STILLNEEDSTRIKE3}" != "X" ] ; then
    echo "trying lamo echo"
    cp ${EXIST} ${EXIST}.pre${SELF}.${TSTAMP}
    grep -v " pam_cracklib.so " ${EXIST}.pre${SELF}.${TSTAMP} > ${EXIST}
    echo "${STRIKE3}" >> ${EXIST}
  fi
fi

}

fixSunOS()
{

FILEANDPROPS=`echo "${EXIST}"|perl -p -e "s|^(/etc/security/policy.conf)$|\1:LOCK_AFTER_RETRIES=YES|"|perl -p -e "s|^(/etc/default/login)$|\1:RETRIES=3|"`

for strikesettings in `echo "${FILEANDPROPS}"` ; do
  MYEXIST=`echo "${strikesettings}"|awk -F\: {'print $1'}`
  STRIKE3=`echo "${strikesettings}"|awk -F\: {'print $2'}`
  MYKEY=`echo "${strikesettings}"|awk -F\: {'print $2'}|awk -F\= {'print $1'}`

  if grep "^${STRIKE3}$" ${MYEXIST} >/dev/null ; then
    echo "aready had ${STRIKE3}"
  else
    echo "trying fancy perl"
    perl -p -i.pre${SELF}.${TSTAMP} -e "s|^[#,\s]*${MYKEY}=.*$|${STRIKE3}|g" ${MYEXIST}
    grep "^${STRIKE3}$" ${MYEXIST} >/dev/null || {
      echo "trying lamo echo"
      cp ${MYEXIST} ${MYEXIST}.pre${SELF}.${TSTAMP}
      echo "${STRIKE3}" >> ${MYEXIST}
    }
  fi


  if [ -f "${MYEXIST}.pre${SELF}.${TSTAMP}" ] ; then
    diff -u "${MYEXIST}.pre${SELF}.${TSTAMP}" "${MYEXIST}"
    diff -u "${MYEXIST}.pre${SELF}.${TSTAMP}" "${MYEXIST}" > "${MYEXIST}.${SELF}.${TSTAMP}.patch"
  fi
done
}




sleep 1
TSTAMP=`perl -e 'print int(time)'`
SELF=`basename $0`
test "X${FIX}" != "X" && EXIST=`ls -d ${FIX}`


test "X${SELF}" = "X" -o "X${TSTAMP}" = "X" -o "X${EXIST}" = "X" && exit


eval "fix${OSNAME}"


