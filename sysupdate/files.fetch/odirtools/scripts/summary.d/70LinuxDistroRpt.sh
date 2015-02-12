#!/bin/bash

. /etc/default/SYSconstants
##set -x
cd /sysbuild/system && MAINFIND=`find */lsb_release.out -exec grep -H "Description:" {} \;|sed  -e "s| *([^\(,^\)]*)$||g"|perl -p -e "s|\/lsb_release.out:Description:[\s]+|\,|g"`

MASTER=`cat /sysbuild/system/summary/master.csv`
SVRLSB=`echo "${MAINFIND}"|awk -F\, {'print $1'}|sort -u`

for SVRNAME in `echo "${SVRLSB}"` ; do
  myLSB=`echo "${MAINFIND}"|grep "^${SVRNAME}\,"|awk -F, {'print $2'}`
  myMaster=`echo "${MASTER}"|grep "^[^,]*,[^,]*,\"${SVRNAME}\""|sort -u|head -1`
##exit
  myCiOSCPU=`echo "${myMaster}"|cut -d, -f4-6`
##/bin/bash -i
  if [ "X${SVRNAME}" != "X" -a "X${myLSB}" != "X" ] ; then
    myRptLine="\"${SVRNAME}\",${myCiOSCPU},\"${myLSB}\""
    RptData=`printf "${RptData}\n${myRptLine}"`
  fi
done

RptData=`echo "${RptData}"|sort -u|grep '.'`
RptHeader='"HOST","CI","OSNAME","CPU","LINUXDISTRO"'

Rpt=`printf "${RptHeader}\n${RptData}\n"|grep '.'`

echo "${Rpt}" > /sysbuild/system/summary/LinuxDistro.csv
chmod 755 /sysbuild/system/summary/LinuxDistro.csv
