#!/bin/bash -x

OSNAME=`uname -s` ; test "X${OSNAME}" != X || exit
ARCH=`uname -p` ; test "X${ARCH}" != X || exit
test "X${OSNAME}" != "XLinux" -a "X${OSNAME}" != "XSunOS" && exit
FIX="${*}"
test "X${FIX}" = "X" && {
  test "X${OSNAME}" = "XLinux" && FIX=''
  test "X${OSNAME}" = "XSunOS" && FIX='/etc/security/policy.conf /etc/security/policy.conf /etc/security/crypt.conf /etc/security/crypt.conf'
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


FILEANDPROPS=`echo "${EXIST}"|perl -p -e "s|\n|@@@|g"|perl   -p -e "s|(/etc/security/policy.conf)@|\1:CRYPT_ALGORITHMS_ALLOW=1,2a,md5,5,6|"|perl   -p -e "s|(/etc/security/policy.conf)@|\1:CRYPT_DEFAULT=6|"|perl   -p -e "s|(/etc/security/crypt.conf)@|\1:5 crypt_sha256.so.1|"|perl   -p -e "s|(/etc/security/crypt.conf)@|\1:6 crypt_sha512.so.1|"|perl -p -e "s|@@|\n|g"`

##exit

OLDIFS="${IFS}"
IFS='
'


for strikesettings in `echo "${FILEANDPROPS}"` ; do
  MYEXIST=`echo "${strikesettings}"|awk -F\: {'print $1'}`
  STRIKE3=`echo "${strikesettings}"|awk -F\: {'print $2'}`
  MYKEY=`echo "${strikesettings}"|awk -F\: {'print $2'}|awk -F\= {'print $1'}`

  ##if grep "^${STRIKE3}$" ${MYEXIST} >/dev/null ; then
  if perl -p -e "s|\n|@@@@|g" ${MYEXIST}|perl -p -e "s|[\s]+| |g"| perl -p -e "s|@@@@|\n|g"|grep "^${STRIKE3}$" ; then
    echo "aready had ${STRIKE3}"
  else
    echo "trying perl"
    perl -p -i.pre${SELF}.${TSTAMP} -e "s|^${MYKEY}=.*$|${STRIKE3}|g" ${MYEXIST}
    grep "^${STRIKE3}$" ${MYEXIST} >/dev/null || {
      echo "trying fancy perl"
      perl -p -i.pre${SELF}.${TSTAMP} -e "s|^[#,\s]*${MYKEY}=.*$|${STRIKE3}|g" ${MYEXIST}
    }
    grep "^${STRIKE3}$" ${MYEXIST} >/dev/null || {
      echo "trying lamo echo"
      test -s "${MYEXIST}.pre${SELF}.${TSTAMP}" && {
        cat "${MYEXIST}.pre${SELF}.${TSTAMP}" > "${MYEXIST}"
      }
      cp ${MYEXIST} ${MYEXIST}.pre${SELF}.${TSTAMP}
      echo "${STRIKE3}" >> ${MYEXIST}
    }
   
  fi


  if [ -f "${MYEXIST}.pre${SELF}.${TSTAMP}" ] ; then
    diff -u "${MYEXIST}.pre${SELF}.${TSTAMP}" "${MYEXIST}"
    diff -u "${MYEXIST}.pre${SELF}.${TSTAMP}" "${MYEXIST}" > "${MYEXIST}.${SELF}.${TSTAMP}.patch"
  fi
  TSTAMP=`__gettstamp`
done

IFS="${OLDIFS}"
}



__gettstamp()
{
sleep 1
perl -e 'print int(time)'
}


TSTAMP=`__gettstamp`
SELF=`basename $0`
BASE=`dirname $0`
PATCHBASE="/opt/unix_ops/"
PATCHBIN="${PATCHBASE}/bin"
test "X${FIX}" != "X" && EXIST=`ls -d ${FIX}`

test -f /usr/lib/security/crypt_sha256.so.1 -a -f /usr/lib/security/64/crypt_sha256.so.1 -a -f /usr/lib/security/crypt_sha512.so.1 -a -f /usr/lib/security/64/crypt_sha512.so.1 || exit 1

test "X${ARCH}" = "Xsparc" && SHAPATCHES="140905-02"
test "X${ARCH}" = "Xi386" && SHAPATCHES="140906-02"

test "X${SHAPATCHES}" != "X" && ${PATCHBIN}/pca -X ${PATCHBASE}/etc -y   -i ${SHAPATCHES}


test "X${SELF}" = "X" -o "X${TSTAMP}" = "X" -o "X${EXIST}" = "X" && exit


eval "fix${OSNAME}"


##GEN000590  ##GEN000585
