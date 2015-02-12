#!/bin/bash

if [ "X${SYSSVNROOT}" = "X" -o "X${SUMMARY}" = "X" ] ; then
 exit 1
fi

VMRPTFILE='vmReport.csv'
cd "${SYSSVNROOT}"
HOSTLIST=`ls|grep -v "^summary$"`
VMRPTDATA=`find . -name *.vm.list -exec grep -H -v -E "(^Name|^NAME|^Domain-0|ID NAME .*|ID .*FQDN .*| global .*|^primary .*)" {} \;|perl -p -e "s/: *[0-9,\-]* */,/g"|awk {'print $1'}|perl -p -e "s/:/,/g"|perl -p -e "s/\.vm\.list//g"|perl -p -e "s/^\.\///g"|perl -p -e "s/\//,/g"|perl -p -e "s/\,xen\,/\,ovm\/xen\,/g"|perl -p -e "s/\,ldom\,/\,ovm\/ldom\,/g"|perl -p -e "s|^([^\.]+)\.([^\,]+)\,(.*)|\1.\2,\3.\2|g"|while read line ; do DOM=`echo "${line}"|awk -F\. {'print $2'}`;test "X${DOM}" != "X" && echo "${line}"|perl -p -e "s|\.${DOM}\.[^\,]+\.${DOM}\.|.${DOM}.|g"; done`

HVRPTDATA=`echo "${VMRPTDATA}"|awk -F\, '{print $1","$2","$1}'`
VMRPTDATA=`printf "${VMRPTDATA}\n${HVRPTDATA}\n"|sort -u|grep '.'`
FULLRPTDATA="${HOSTLIST}"
DIRTYVMS=`echo "${VMRPTDATA}"|grep -v ".*,.*,.*\..*\..*\..*"`
VMRPTDATA=`echo "${VMRPTDATA}"|grep ".*,.*,.*\..*\..*\..*"`

WASHEDVMS="${DIRTYVMS}"
for i in `echo "${DIRTYVMS}"` ; do
  DIRTYVM=`echo "${i}"|awk -F, '{print $3}'`
  CLEANVM=`echo "${DIRTYVM}"|perl -p -e "s|.*_||g"|perl -p -e "s|image\n||g"`
  DIRTYHVFQDN=`echo "${i}"|awk -F, '{print $1}'`
  DIRTYVMDN=`echo "${DIRTYHVFQDN}"|cut -f2- -d.`
  DIRTYHV=`echo "${DIRTYHVFQDN}"|cut -f1 -d.`
  
  case "${CLEANVM}" in
    [a-z])
      CLEANVM="${DIRTYHV}${CLEANVM}"
    ;;
    *)
      CLEANVM="${CLEANVM}"
  esac

  CLEANVMFQDN="${CLEANVM}.${DIRTYVMDN}"
  if [ "X${CLEANVM}" = "X" ] ; then
    WASHEDVMS=`echo "${WASHEDVMS}"|perl -p -e "s|${i}||g"`
  else
    WASHEDVMS=`echo "${WASHEDVMS}"|perl -p -e "s|\,${DIRTYVM}$|\,${CLEANVMFQDN}|g"`
  fi
done

VMRPTDATA=`printf "${VMRPTDATA}\n${WASHEDVMS}\n"|sort -u|grep '.'`
for i in `echo "${HOSTLIST}"` ; do
  MYVMLI=`echo "${VMRPTDATA}"|grep "^.*,.*,${i}$"`
  if [ "X${MYVMLI}" != "X" ] ; then
    #set -x 
    FULLRPTDATA=`echo "${FULLRPTDATA}"|perl -p -e "s|^${i}$|${MYVMLI}|g"`
    #set +x
    #exit 2
  else
    FULLRPTDATA=`echo "${FULLRPTDATA}"|perl -p -e "s|^${i}$|${i}\,real\,${i}|g"`
  fi
done

FULLRPTDATA=`echo "${FULLRPTDATA}"|sort -u|grep '.'`
if [ "X${FULLRPTDATA}" != "X" ] ; then
  VMRPTHEADER="HV,TYPE,VM"
  VMRPT=`printf "${VMRPTHEADER}\n${FULLRPTDATA}"`
  echo "${VMRPT}" >${SUMMARY}/${VMRPTFILE}
fi
