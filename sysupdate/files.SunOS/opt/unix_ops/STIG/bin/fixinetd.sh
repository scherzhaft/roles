#!/bin/bash -x

FIX="${*}"
test "X${FIX}" = "X" && FIX='/etc/inet/inetd.conf'

 
/usr/sbin/inetadm -M tcp_trace=TRUE ; /usr/sbin/inetadm | grep enabled | awk '{print $NF}' | xargs -I X /usr/sbin/inetadm -m X tcp_trace=  #GEN003800 
/usr/sbin/svccfg -s svc:/network/inetd setprop defaults/tcp_wrappers=true  ##GEN006580


sleep 1
TSTAMP=`perl -e 'print int(time)'`
SELF=`basename $0`
test "X${FIX}" != "X" && EXIST=`ls -d ${FIX} 2>/dev/null`

test "X${SELF}" != "X" -a "X${TSTAMP}" != "X" -a "X${EXIST}" != "X" && {
  chgrp sys ${EXIST}  #GEN003730
  chmod 0640 ${EXIST}  
  chmod A- ${EXIST}  #GEN003745
  chown root ${EXIST}  #GEN003720
}

##GEN003060  ##GEN003700  we need/use inetd


