#!/bin/bash

. /etc/default/SYSconstants
##set -x
cd /sysbuild/system && MAINFIND=`find . \( -name pkginfo.out -o -name rpminfo.out \) -exec grep -H -E "(^jdk|SUNWj[4,5,6].)" {} \;`

MASTER=`cat /sysbuild/system/summary/master.csv`
SVRWJDK=`echo "${MAINFIND}"|awk -F\/ {'print $2'}|sort -u`

for SVRNAME in `echo "${SVRWJDK}"` ; do
  myJdk=`echo "${MAINFIND}"|grep "^\.\/${SVRNAME}\/"|sed -e "s%.*/rpminfo.out:%%"|sed -e "s%.*/pkginfo.out:%%"|awk {'print $NF'}|sed -e "s/[^0-9,^_,^-,^\.]//g"|sort -u|perl -p -e "s/\n/\|/g"|perl -p -e "s/\|$//g"`
  myMaster=`echo "${MASTER}"|grep "^[^,]*,[^,]*,\"${SVRNAME}\""|sort -u|head -1`
  myCiOSCPU=`echo "${myMaster}"|cut -d, -f4-6`
##/bin/bash -i
  if [ "X${SVRNAME}" != "X" -a "X${myJdk}" != "X" ] ; then
    myRptLine="\"${SVRNAME}\",${myCiOSCPU},\"${myJdk}\""
    jdkRptData=`printf "${jdkRptData}\n${myRptLine}"`
  fi
done

jdkRptData=`echo "${jdkRptData}"|sort -u|grep '.'`
jdkRptHeader='"HOST","CI","OSNAME","CPU","JDKREVS"'

jdkRpt=`printf "${jdkRptHeader}\n${jdkRptData}\n"|grep '.'`

echo "${jdkRpt}" >/sysbuild/system/summary/jdkRpt.csv
chmod 755 /sysbuild/system/summary/jdkRpt.csv
