#!/bin/bash -x

FIX="${*}"
test "X${FIX}" = "X" && FIX='/var/ldap/ldap_client_file /var/ldap/ldap_client_cred /var/ldap/cert8.db /var/ldap/key3.db /var/ldap/secmod.db'


sleep 1
TSTAMP=`perl -e 'print int(time)'`
SELF=`basename $0`
test "X${FIX}" != "X" && EXIST=`ls -d ${FIX} 2>/dev/null`

test "X${SELF}" != "X" -a "X${TSTAMP}" != "X" -a "X${EXIST}" != "X" && {
  chown root ${EXIST}  #GEN008140
  chgrp root ${EXIST}  #GEN008160
  chmod 0600 ${EXIST}  #GEN008180
  chmod A- ${EXIST}  #GEN008200 #GEN008120
}

##GEN007980  we use local accounts auth


