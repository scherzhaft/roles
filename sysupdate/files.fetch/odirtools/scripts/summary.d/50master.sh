#!/bin/bash


. /etc/default/SYSconstants

DATE='/opt/sfw/bin/date'
MISSINGSECRPT="master.csv"
#SYSSVNROOT='/sysbuild/system'
#SUMMARY="/sysbuild/system/summary"

if [ "X${SYSSVNROOT}" = "X" -o "X${SUMMARY}" = "X" ] ; then
 exit 1
fi

MISSINGS=`cd "${SYSSVNROOT}" && find . -name ???.patch.report -exec grep -H ^List:  {} \;|perl -p -e 's/^\.\///g'|perl -p -e 's/\//\,/g'|perl -p -e 's/pca\.patch\.report\:List\: .*missingrs .*\(//g'|perl -p -e 's/yum\.patch\.report\:List\: .*check-update .*\(//g'|perl -p -e 's/\,9999\)$//g'|perl -p -e 's/\,0\)$//g'`

if [ "X${MISSINGS}" = "X" ] ; then
 exit 1
fi

##echo "${MISSINGS}"|awk -F\, '{print $1","$2",=HYPERLINK(\"https://%SHORTSUPPORT%/sysrpts/"$1"/pca.report.html\")"}'|perl -p -e "s/\%SHORTSUPPORT\%/${__SHORTSUPPORT}/g" > "${SUMMARY}/${MISSINGSECRPT}"

HOSTS=`echo "${MISSINGS}"|awk -F\, {'print $1'}`

for i in `echo "${HOSTS}"` ; do
 PATCHLVLS=`grep -E '(^Using .*.xref from .../../..$|^Using repodata from .../../..$)' ${SYSSVNROOT}/${i}/???.out.*|awk {'print $NF'}|awk -F/ {'print $3"/"$1"/"$2'}|tr -s '[:upper:]' '[:lower:]'|perl -p -e "s|/jan/|/01/|g"|perl -p -e "s|/feb/|/02/|g"|perl -p -e "s|/mar/|/03/|g"|perl -p -e "s|/apr/|/04/|g"|perl -p -e "s|/may/|/05/|g"|perl -p -e "s|/jun/|/06/|g"|perl -p -e "s|/jul/|/07/|g"|perl -p -e "s|/aug/|/08/|g"|perl -p -e "s|/sep/|/09/|g"|perl -p -e "s|/oct/|/10/|g"|perl -p -e "s|/nov/|/11/|g"|perl -p -e "s|/dec/|/12/|g"|sort -n|tail -1|awk -F/ {'print $2"/"$3"/"$1'}`
 PATCHLVLEPOCS=""
## for lvl in `echo "${PATCHLVLS}"` ; do
##  LVLCLEAN=`echo "${lvl}"|awk -F/ {'print $1" "$2" "$3'}`
##  LVLEPOC=`${DATE} --date="${LVLCLEAN}" +%s`
##  EPOCSTATUS="$?"
##  if [ "X${EPOCSTATUS}" = "X0" ] ; then
##   PATCHLVLEPOCS=`printf "${PATCHLVLEPOCS}\n${LVLEPOC}|${LVLCLEAN}"|grep '.'`
##  fi
## done
## MYLVL=`echo "${PATCHLVLEPOCS}"|sort -nr|grep '.'|head -1|awk -F\| {'print $2'}|awk {'print $1"\/"$2"\/"$3'}` ##|perl -p -e 's/\//-/g'`
  MYLVL="${PATCHLVLS}"
 UNAME=`head -1 ${SYSSVNROOT}/${i}/uname.out`
 OS=`echo "${UNAME}"|awk {'print $1'}`
 case "${OS}" in
   SunOS)
     KERNEL=`echo "${UNAME}"|awk {'print $3"-"$4'}`
   ;;

   Linux)
     KERNEL=`echo "${UNAME}"|awk {'print $3'}`
   ;;
 esac

   
 CPU=`echo "${UNAME}"|awk {'foo=NF - 1;print $foo'}`
 if echo "${CPU}"|grep .*86.* >/dev/null ; then
   CPU='x86'
 fi
 CI=`__slapwhoami "X${i}"|grep '^__CI='|awk -F\= {'print $2'}`
 QTY=`echo "${MISSINGS}"|grep "^${i}"|awk -F\, {'print $2'}` 

if [ -f "${SYSSVNROOT}/${i}/pca.patch.report.html" ] ; then
 MISSINGS=`echo "${MISSINGS}"|perl -p -e "s|^${i}\,.*|${i}\,${CI}\,${OS}\,${CPU}\,${KERNEL}\,${MYLVL}\,${QTY}\,\=HYPERLINK\(\"https:\/\/${__SHORTSUPPORT}\/sysrpts\/${i}\/pca.patch.report.html\"\)|"`
elif [ -f "${SYSSVNROOT}/${i}/yum.patch.report" ] ; then
 MISSINGS=`echo "${MISSINGS}"|perl -p -e "s|^${i}\,.*|${i}\,${CI}\,${OS}\,${CPU}\,${KERNEL}\,${MYLVL}\,${QTY}\,\=HYPERLINK\(\"https:\/\/${__SHORTSUPPORT}\/sysrpts\/${i}\/yum.patch.report\"\)|"`
fi
done 


MISSINGSDATA=`echo "${MISSINGS}"|sort -u`

TEMPLATE=`cat ${SUMMARY}/vmReport.csv`
TEMPLATELENGTH=`echo "${TEMPLATE}"|wc -l |awk {'print $1'}`
LENGTHMINUSHEADERS=`expr ${TEMPLATELENGTH} - 1`
if [ "X${LENGTHMINUSHEADERS}" != "X" ] ; then
  TEMPLATE=`echo "${TEMPLATE}"|tail -${LENGTHMINUSHEADERS}`
  if [ "${LENGTHMINUSHEADERS}" -gt 0 ] ; then
  MISSINGSDATAREF="${TEMPLATE}"
  for i in `echo "${TEMPLATE}"` ; do
    HOSTPRIKEY=`echo "${i}"|awk -F, '{print $3}'`
    HOSTLI=`echo "${MISSINGSDATA}"|grep "^${HOSTPRIKEY},"`
    if [ "X${HOSTLI}" != "X" -a "X${HOSTPRIKEY}" != "X" ] ; then
      MISSINGSDATAREF=`echo "${MISSINGSDATAREF}"|perl -p -e "s|\,${HOSTPRIKEY}$|\,${HOSTLI}|g"`
    fi
  done
  MISSINGSDATA=`echo "${MISSINGSDATA}"|sort -u`
  MISSINGSDATAREF=`echo "${MISSINGSDATAREF}"|sort -u|awk -F, '{print "\""$1"\",\""$2"\",\""$3"\",\""$4"\",\""$5"\",\""$6"\",\""$7"\",\""$8"\","$9","$10}'|perl -p -e 's|\"\"||g'`

  MISSINGSUPDATE=`printf "\"PHYSICAL SERVER\",\"CONTAINER TYPE\",\"HOST/VIRTUALHOST\",\"CI\",\"OSNAME\",\"CPU\",\"KERNEL\",\"PATCHLVL\",\"QTY\",\"REPORT\"\n${MISSINGSDATAREF}"`
  fi
fi

if [ "X${MISSINGSUPDATE}" = "X" ] ; then
 exit 1
fi

echo "${MISSINGSUPDATE}"|grep 'FOO.FOO' >/dev/null
UPDATEVALID="$?"

if [ "X${UPDATEVALID}" != "X0" ] ; then
 exit 1
fi

echo "${MISSINGSUPDATE}" > "${SUMMARY}/${MISSINGSECRPT}"

chown -R svn:svn ${SUMMARY}
chmod -R 770 ${SUMMARY}

#cd "${SUMMARY}"
#svn st|grep "^? .*${MISSINGSECRPT}$"
#NEEDADD=$?
#if [ "X${NEEDADD}" = "X0" ] ; then
# svn add ${MISSINGSECRPT}
# svn commit -m "sysupdate: initialized new system item" ${MISSINGSECRPT}
#fi


#svn st|grep "^M .*${MISSINGSECRPT}$"
#MODDED=$?
#if [ "X${MODDED}" = "X0" ] ; then
# svn commit -m "sysupdate: system info update" ${MISSINGSECRPT}
#fi
