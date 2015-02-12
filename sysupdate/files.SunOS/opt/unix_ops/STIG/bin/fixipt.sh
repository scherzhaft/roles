#!/bin/bash -x

OSNAME=`uname -s` ; test "X${OSNAME}" != X || exit
test "X${OSNAME}" != "XLinux" -a "X${OSNAME}" != "XSunOS" && exit
FIX="${*}"
test "X${FIX}" = "X" && {
  test "X${OSNAME}" = "XLinux" && FIX=''
  test "X${OSNAME}" = "XSunOS" && FIX='/etc/ipf/ipf.conf'
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

WORK=''
SRCRTDPACKETS1='block out log quick all with opt lsrr'
if grep "^${SRCRTDPACKETS1}$" ${EXIST} >/dev/null ; then
  echo "aready had ${SRCRTDPACKETS1}"
else
  WORK="${SRCRTDPACKETS1}"
fi

SRCRTDPACKETS2='block out log quick all with opt ssrr'
if grep "^${SRCRTDPACKETS2}$" ${EXIST} >/dev/null ; then
  echo "aready had ${SRCRTDPACKETS2}"
else
  WORK=`printf "${WORK}\n${SRCRTDPACKETS2}"|grep '.'`
fi

SRCRTDPACKETS3='block in log quick all with opt lsrr'
if grep "^${SRCRTDPACKETS3}$" ${EXIST} >/dev/null ; then
  echo "aready had ${SRCRTDPACKETS3}"
else
  WORK=`printf "${WORK}\n${SRCRTDPACKETS3}"|grep '.'`
fi

SRCRTDPACKETS4='block in log quick all with opt ssrr'
if grep "^${SRCRTDPACKETS4}$" ${EXIST} >/dev/null ; then
  echo "aready had ${SRCRTDPACKETS4}"
else
  WORK=`printf "${WORK}\n${SRCRTDPACKETS4}"|grep '.'`
fi


test "X${WORK}" != "X" && {
  echo "trying lamo echo"
  cp ${EXIST} ${EXIST}.pre${SELF}.${TSTAMP} || exit
  echo "${WORK}" > ${EXIST}
  cat ${EXIST}.pre${SELF}.${TSTAMP} >> ${EXIST}
}


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

