#!/bin/bash -x

FIX="${*}"
test "X${FIX}" = "X" && FIX='/etc/dfs/dfstab'


sleep 1
TSTAMP=`perl -e 'print int(time)'`
SELF=`basename $0`
test "X${FIX}" != "X" && EXIST=`ls -d ${FIX} 2>/dev/null`

test "X${SELF}" != "X" -a "X${TSTAMP}" != "X" -a "X${EXIST}" != "X" && {
  chmod A- ${EXIST}  #GEN005770
}

/usr/sbin/exportfs -v|grep "/" && {  ##GEN005800  ##GEN005810
  echo "..found exports...please chown/chgrp root"
  echo "..and no 'anon=0'"  ##GEN005820
  echo "..and rw or ro options specifying a list of hosts or networks for each export"  ##GEN005840
  echo "..and grep 'root='"  ##GEN005880
  echo "..and grep 'sec=none'"  ##GEN005860
  
 
}

