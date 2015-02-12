#!/bin/bash -x


##RHEL-06-000299


FIX="${*}"
test "X${FIX}" = "X" && FIX='/etc/pam.d/system-auth'
sleep 1
TSTAMP=`date +%Y-%m-%d_%H:%M:%S`
SELF=`basename $0`
MAXREPEAT='password    required      pam_cracklib.so try_first_pass retry=3 minlen=14 difok=4 maxrepeat=3 dcredit=-2 ucredit=-2 ocredit=-2 lcredit=-2'

EXIST=`ls -d "${FIX}"`


test "X${SELF}" = "X" -o "X${TSTAMP}" = "X" -o "X${EXIST}" = "X" && exit


if grep "^password[\ ]*[a-z]* .*pam_cracklib.so .*maxrepeat=[0-9]*" ${EXIST} ; then
  NEEDMAXREPEAT=`grep -L "^password .*required .*pam_cracklib.so .*maxrepeat=3" ${EXIST}`
  if [ "X${NEEDMAXREPEAT}" != "X" ] ; then
    echo "trying fancy perl"
    perl -p -i.pre${SELF}.${TSTAMP} -e "s|^(password[\ ]*)[a-z]* (.*pam_cracklib.so .*)maxrepeat=[0-9]*|\1required \2maxrepeat=3|" ${EXIST}
  else
    echo "aready had ${MAXREPEAT}"
  fi
else
  echo "trying less fancy perl"
  perl -p -i.pre${SELF}.${TSTAMP} -e "s|^(password[\ ]*)[a-z]* (.*pam_cracklib.so .*$)|\1required \2 maxrepeat=3|" ${EXIST}
  STILLNEEDMAXREPEAT=`grep -L "^password .*required .*pam_cracklib.so .*maxrepeat=3" ${EXIST}`
  if [ "X${STILLNEEDMAXREPEAT}" != "X" ] ; then
    echo "trying lamo echo"
    cp ${EXIST} ${EXIST}.pre${SELF}.${TSTAMP}
    grep -v " pam_cracklib.so " ${EXIST}.pre${SELF}.${TSTAMP} > ${EXIST}
    echo "${MAXREPEAT}" >> ${EXIST}
  fi
fi

if [ -f "${EXIST}.pre${SELF}.${TSTAMP}" ] ; then
  diff -u "${EXIST}.pre${SELF}.${TSTAMP}" "${EXIST}"
  diff -u "${EXIST}.pre${SELF}.${TSTAMP}" "${EXIST}" > "${EXIST}.${SELF}.${TSTAMP}.patch"
fi
