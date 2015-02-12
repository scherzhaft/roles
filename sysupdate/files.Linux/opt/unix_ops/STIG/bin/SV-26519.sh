#!/bin/bash -x


##RHEL-06-000165  ##RHEL-06-000167  ##RHEL-06-000169  ##RHEL-06-000171  ##RHEL-06-000173  ##RHEL-06-000174  ##RHEL-06-000175  ##RHEL-06-000176  ##RHEL-06-000177  ##RHEL-06-000182  ##RHEL-06-000183  ##RHEL-06-000184  ##RHEL-06-000185  ##RHEL-06-000186  ##RHEL-06-000187  ##RHEL-06-000188  ##RHEL-06-000189  ##RHEL-06-000190  ##RHEL-06-000191  ##RHEL-06-000192  ##RHEL-06-000193  ##RHEL-06-000194  ##RHEL-06-000195  ##RHEL-06-000196  ##RHEL-06-000197  ##RHEL-06-000198  ##RHEL-06-000199  ##RHEL-06-000200  ##RHEL-06-000201  ##RHEL-06-000202  ##RHEL-06-000281  ##RHEL-06-000278  ##RHEL-06-000279  ##RHEL-06-000280  ##RHEL-06-000522  ##RHEL-06-000385  ##RHEL-06-000384  ##RHEL-06-000383  ##RHEL-06-000525



FIX="${*}"
test "X${FIX}" = "X" && FIX='/etc/audit/audit.rules'
sleep 1
TSTAMP=`date +%Y-%m-%d_%H:%M:%S`
SELF=`basename $0`
MISSINGRULES=''
UADDRULE="-w /usr/sbin/useradd -p x -k useradd"
GADDRULE="-w /usr/sbin/groupadd -p x -k groupadd"
PASSWDRULE="-w /etc/passwd -p a -k passwd"
SHADOWRULE="-w /etc/shadow -p a -k shadow"
GROUPRULE="-w /etc/group -p a -k group"
GSHADOWRULE="-w /etc/gshadow -p a -k gshadow"

test "X${SELF}" = "X" -o "X${TSTAMP}" = "X" -o "X${FIX}" = "X" && exit

grep  -- "^-w .*/usr/sbin/useradd .*-p .*x .*-k .*" ${FIX} >/dev/null
if [ "X${?}" = "X0" ] ; then
  echo "already has useradd exec rule"
else
  MISSINGRULES="${MISSINGRULES}
${UADDRULE}"
fi  

grep  -- "^-w .*/usr/sbin/groupadd .*-p .*x.*-k .*" ${FIX} >/dev/null
if [ "X${?}" = "X0" ] ; then
  echo "already has groupadd exec rule"
else
  MISSINGRULES="${MISSINGRULES}
${GADDRULE}"
fi  

grep  -- "^-w .*/etc/passwd .*-p .*a.*-k .*" ${FIX} >/dev/null
if [ "X${?}" = "X0" ] ; then
  echo "already has passwd attr change rule"
else
  MISSINGRULES="${MISSINGRULES}
${PASSWDRULE}"
fi  

grep  -- "^-w .*/etc/shadow .*-p .*a.*-k .*" ${FIX} >/dev/null
if [ "X${?}" = "X0" ] ; then
  echo "already has shadow attr change rule"
else
  MISSINGRULES="${MISSINGRULES}
${SHADOWRULE}"
fi  

grep  -- "^-w .*/etc/group .*-p .*a.*-k .*" ${FIX} >/dev/null
if [ "X${?}" = "X0" ] ; then
  echo "already has group attr change rule"
else
  MISSINGRULES="${MISSINGRULES}
${GROUPRULE}"
fi  

grep  -- "^-w .*/etc/gshadow .*-p .*a.*-k .*" ${FIX} >/dev/null
if [ "X${?}" = "X0" ] ; then
  echo "already has gshadow attr change rule"
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

