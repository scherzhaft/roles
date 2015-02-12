#!/bin/bash -x


CWD=`pwd`
FIX="${*}"
ETC='etc'
test "X${FIX}" = "X" && ETC=/etc
test "X${FIX}" = "X" && FIX='/etc/xinetd.conf /etc/xinetd.d/*' 
SELF=`basename $0`
rm -rf "/tmp/${SELF}$$"

sleep 1
TSTAMP=`date +%Y-%m-%d_%H:%M:%S`
FQFIX=`echo "${FIX}"|perl -p -e "s| |\n|g"|grep '.'|sed -e "s|^\([^/].\)|${CWD}/\1|g"`
FQEXIST=`ls -d ${FQFIX} 2>/dev/null`
EXIST=`ls -d ${FIX} 2>/dev/null`
test "X${SELF}" = "X" -o "X${TSTAMP}" = "X" -o "X${FQEXIST}" = "X" -o "X${EXIST}" = "X" && exit
mkdir -p "/tmp/${SELF}$$"


zip  -q  ${ETC}/pre${SELF}.${TSTAMP}.zip ${EXIST}


NEEDSLTYPE=`grep -L "log_type" ${FQEXIST}`
NEEDSLONSUCCESS=`grep -L "log_on_success" ${FQEXIST}`
NEEDSLONFAILURE=`grep -L "log_on_failure" ${FQEXIST}`


echo "${NEEDSLTYPE}" |xargs perl -p -i -e "s|^\{\n|\{\n        log_type                = SYSLOG authpriv\n|g"
echo "${NEEDSLONSUCCESS}" |xargs perl -p -i -e "s|^\{\n|\{\n        log_on_success          = HOST PID USERID EXIT\n|g"
echo "${NEEDSLONFAILURE}" |xargs perl -p -i -e "s|^\{\n|\{\n        log_on_failure          = HOST USERID\n|g"


##grep -E "(#.*log_type|#.*log_on_success|#.*log_on_failure)" ${EXISTS} >/dev/null




####perl -p -i -e "s|^#*(.*log_type[^=]*=).*$|\$1 SYSLOG authpriv|g"

perl -p -i -e "s|^#*(.*log_type[^=]*=).*$|\1 SYSLOG authpriv|g" ${FQEXIST}
perl -p -i -e "s|^#*(.*log_on_failure[^=]*=).*$|\1 HOST USERID|g" ${FQEXIST}
perl -p -i -e "s|^#*(.*log_on_success[^=]*=).*$|\1 HOST PID USERID EXIT|g" ${FQEXIST}

##read
unzip -q -o  ${ETC}/pre${SELF}.${TSTAMP}.zip -d "/tmp/${SELF}$$"


cd "/tmp/${SELF}$$"
for f2diff in `echo "${FQEXIST}"` ; do
  ORIG=`echo "${f2diff}"|sed -e "s|^${CWD}/||g"`
  NEW="${f2diff}"
  diff -u "${ORIG}" "${NEW}"|grep -v "^No differences encountered$"
done > "/tmp/${SELF}$$/pre${SELF}.${TSTAMP}.patch"

cd "${CWD}"

if [ -s "/tmp/${SELF}$$/pre${SELF}.${TSTAMP}.patch" ] ; then
  mv "/tmp/${SELF}$$/pre${SELF}.${TSTAMP}.patch" ${ETC}
  cat "${ETC}/pre${SELF}.${TSTAMP}.patch"
else
  rm "${ETC}/pre${SELF}.${TSTAMP}.zip"
fi

rm -rf "/tmp/${SELF}$$"
