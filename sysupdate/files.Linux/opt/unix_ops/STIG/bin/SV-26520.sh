#!/bin/bash -x

FIX="${*}"
test "X${FIX}" = "X" && FIX='/etc/audit/audit.rules'
sleep 1
TSTAMP=`date +%Y-%m-%d_%H:%M:%S`
SELF=`basename $0`
MISSINGRULES=''
UMODRULE="-w /usr/sbin/usermod -p x -k usermod"
GMODRULE="-w /usr/sbin/groupmod -p x -k groupmod"
PASSWDRULE="-w /etc/passwd -p a -k passwd"
SHADOWRULE="-w /etc/shadow -p a -k shadow"
GROUPRULE="-w /etc/group -p a -k group"
GSHADOWRULE="-w /etc/gshadow -p a -k gshadow"

test "X${SELF}" = "X" -o "X${TSTAMP}" = "X" -o "X${FIX}" = "X" && exit

grep  -- "^-w .*/usr/sbin/usermod .*-p .*x .*-k .*" ${FIX} >/dev/null
if [ "X${?}" = "X0" ] ; then
  echo "already has usermod exec rule"
else
  MISSINGRULES="${MISSINGRULES}
${UMODRULE}"
fi  

grep  -- "^-w .*/usr/sbin/groupmod .*-p .*x.*-k .*" ${FIX} >/dev/null
if [ "X${?}" = "X0" ] ; then
  echo "already has groupmod exec rule"
else
  MISSINGRULES="${MISSINGRULES}
${GMODRULE}"
fi  

grep  -- "^-w .*/etc/passwd .*-p .*a.*-k .*" ${FIX} >/dev/null
if [ "X${?}" = "X0" ] ; then
  echo "already has passwd writes rule"
else
  MISSINGRULES="${MISSINGRULES}
${PASSWDRULE}"
fi  

grep  -- "^-w .*/etc/shadow .*-p .*a.*-k .*" ${FIX} >/dev/null
if [ "X${?}" = "X0" ] ; then
  echo "already has shadow writes rule"
else
  MISSINGRULES="${MISSINGRULES}
${SHADOWRULE}"
fi  

grep  -- "^-w .*/etc/group .*-p .*a.*-k .*" ${FIX} >/dev/null
if [ "X${?}" = "X0" ] ; then
  echo "already has group writes rule"
else
  MISSINGRULES="${MISSINGRULES}
${GROUPRULE}"
fi  

grep  -- "^-w .*/etc/gshadow .*-p .*a.*-k .*" ${FIX} >/dev/null
if [ "X${?}" = "X0" ] ; then
  echo "already has gshadow writes rule"
else
  MISSINGRULES="${MISSINGRULES}
${GSHADOWRULE}"
fi  

MISSINGRULES=`echo "${MISSINGRULES}"|grep '.'`
if [ "X${MISSINGRULES}" != "X" ] ; then
  cp ${FIX} ${FIX}.pre${SELF}.${TSTAMP}
  echo "${MISSINGRULES}" >> ${FIX}
  diff -u ${FIX}.pre${SELF}.${TSTAMP} ${FIX}
  diff -u ${FIX}.pre${SELF}.${TSTAMP} ${FIX} > ${FIX}.${SELF}.${TSTAMP}.patch
fi

