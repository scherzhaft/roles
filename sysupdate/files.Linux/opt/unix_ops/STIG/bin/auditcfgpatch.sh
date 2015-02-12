#!/bin/bash -x


############################
# Linux audit config patch #
############################



##########################################################
## we need rotate until we get it all sending to syslog ##
##########################################################

perl -p -i -e "s|^[' ',\t]*max_log_file_action[' ',\t]*=.*$|max_log_file_action = rotate|g" /etc/audit/auditd.conf


/sbin/chkconfig --level 0126  auditd off
/sbin/chkconfig --level 345 auditd on
/sbin/chkconfig --level 345 nfs on
/sbin/chkconfig --level 345 nfslock on
/sbin/chkconfig --level 345 portmap on
/sbin/chkconfig --level 345 netfs on


##########################################################################################
## make sure audit is last to start, and 1st to stop as to prevent booting/reboot hangs ##
##########################################################################################

rm -f /etc/rc?.d/S??auditd  /etc/rc?.d/K??auditd
sleep 1
ln -sf /etc/init.d/auditd  /etc/rc3.d/S99auditd
ln -sf /etc/init.d/auditd  /etc/rc4.d/S99auditd
ln -sf /etc/init.d/auditd  /etc/rc5.d/S99auditd
ln -sf /etc/init.d/auditd  /etc/rc0.d/K01auditd
ln -sf /etc/init.d/auditd  /etc/rc1.d/K01auditd
ln -sf /etc/init.d/auditd  /etc/rc2.d/K01auditd
ln -sf /etc/init.d/auditd  /etc/rc6.d/K01auditd
sleep 1
ls -ld /etc/rc?.d/S??auditd  /etc/rc?.d/K??auditd
/etc/init.d/auditd stop
sleep 3
/etc/init.d/auditd start
sleep 2


##########################################################################
## another issue that will go away once everything is sending to syslog ##
##########################################################################

recursivelink=`ls -d /audit/*/audit 2>/dev/null`
test "X${recursivelink}" != "X" && rm -f ${recursivelink}


exit 0

 
