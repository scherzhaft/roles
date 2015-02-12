#!/bin/bash -x

FIX="${*}"
test "X${FIX}" = "X" && FIX='/etc/mail/sendmail.cf /etc/mail/sendmail.mc'
sleep 1
TSTAMP=`date +%Y-%m-%d_%H:%M:%S`
SELF=`basename $0`
MISSINGRULES=''
CFFORWARD='O ForwardPath='
MCFORWARD=define\(\`confFORWARD_PATH\'\,\`\'\)dnl
CFEXIST=`ls -d ${FIX} 2>/dev/null|grep "\.cf.*"`
MCEXIST=`ls -d ${FIX} 2>/dev/null|grep "\.mc.*"`
test "X${SELF}" = "X" -o "X${TSTAMP}" = "X" && exit


if [ "X${CFEXIST}" != "X" ] ; then
  CFNEEDFORWARD=`grep -L -- "^${CFFORWARD}$" ${CFEXIST}`
  if [ "X${?}" = "X0" ] ; then
    echo "already has ${CFFORWARD}"
  fi
fi

for CFNEEDFORWARDli in `echo "${CFNEEDFORWARD}"` ; do
  cp ${CFNEEDFORWARDli} ${CFNEEDFORWARDli}.pre${SELF}.${TSTAMP}
  perl -p -i -e "s|^.*ForwardPath=.*$|${CFFORWARD}|g" ${CFNEEDFORWARDli}
  grep -- "^${CFFORWARD}$" ${CFNEEDFORWARDli} || echo "${CFFORWARD}" >> ${CFNEEDFORWARDli}
  diff -u ${CFNEEDFORWARDli}.pre${SELF}.${TSTAMP} ${CFNEEDFORWARDli}
  diff -u ${CFNEEDFORWARDli}.pre${SELF}.${TSTAMP} ${CFNEEDFORWARDli} > ${CFNEEDFORWARDli}.${SELF}.${TSTAMP}.patch
done



if [ "X${MCEXIST}" != "X" ] ; then
  MCNEEDFORWARD=`grep -L -- "^${MCFORWARD}$" ${MCEXIST}`
  if [ "X${?}" = "X0" ] ; then
    echo "already has ${MCFORWARD}"
  fi
fi


for MCNEEDFORWARDli in `echo "${MCNEEDFORWARD}"` ; do
  cp ${MCNEEDFORWARDli} ${MCNEEDFORWARDli}.pre${SELF}.${TSTAMP}
  perl -p -i -e "s|^define\(\`confFORWARD_PATH\'.*$|${MCFORWARD}|g" ${MCNEEDFORWARDli}
  grep -- "^define\(\`confFORWARD_PATH\'\,\`\'\)dnl$" ${MCNEEDFORWARDli} || echo "${MCFORWARD}" >> ${MCNEEDFORWARDli}
  diff -u ${MCNEEDFORWARDli}.pre${SELF}.${TSTAMP} ${MCNEEDFORWARDli}
  diff -u ${MCNEEDFORWARDli}.pre${SELF}.${TSTAMP} ${MCNEEDFORWARDli} > ${MCNEEDFORWARDli}.${SELF}.${TSTAMP}.patch
done



LOOKHERE4FORWARDS="/lib /opt /lib64 /bin /home /boot /sbin /usr /etc /root"
RMLIST=`find ${LOOKHERE4FORWARDS} -name .forward|awk '{if ($1 != "" ) { print "rm "$1}}'`

test "X${RMLIST}" != "X" && echo "${RMLIST}" > /tmp/${SELF}.${TSTAMP}.rmlog
test -f /tmp/${SELF}.${TSTAMP}.rmlog && echo "####  execute /tmp/${SELF}.${TSTAMP}.rmlog to remove
the following ####"
echo
test -f /tmp/${SELF}.${TSTAMP}.rmlog && cat /tmp/${SELF}.${TSTAMP}.rmlog

