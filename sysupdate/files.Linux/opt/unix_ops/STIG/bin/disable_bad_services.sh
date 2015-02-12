#!/bin/bash -x

/sbin/chkconfig --level 0123456 autofs off   ##RHEL-06-000526 
/sbin/service autofs stop  ##RHEL-06-000526
/sbin/chkconfig rhnsd off  ##RHEL-06-000009 
/sbin/service rhnsd stop  ##RHEL-06-000009
##  we use inetd ##/sbin/chkconfig xinetd off  ##RHEL-06-000203 
##  we use inetd ##/sbin/service xinetd stop  ##RHEL-06-000203
/sbin/chkconfig telnet off  ##RHEL-06-000211
/sbin/chkconfig rsh off  ##RHEL-06-000214
/sbin/chkconfig rexec off  ##RHEL-06-000216
/sbin/chkconfig rlogin off  ##RHEL-06-000218
/sbin/chkconfig ypbind off  ##RHEL-06-000221  ##GEN006380 #GEN006080  ##GEN006420  ##GEN006460  we don't run nis
/sbin/service ypbind stop  ##RHEL-06-000221  ##GEN006380 #GEN006080  ##GEN006420  ##GEN006460  we don't run nis
/sbin/chkconfig tftp off  ##RHEL-06-000223  #GEN005140  ##GEN005120  ##GEN005080
/sbin/chkconfig avahi-daemon off  ##RHEL-06-000246 
/sbin/service avahi-daemon stop  ##RHEL-06-000246
/sbin/chkconfig abrtd on  ##RHEL-06-000261 ##we have buggy programs, need core files
/sbin/service abrtd start  ##RHEL-06-000261 ##we have buggy programs, need core files
/sbin/chkconfig atd off  ##RHEL-06-000262 
/sbin/service atd stop  ##RHEL-06-000262
/sbin/chkconfig ntpd off  ##we use cron + our own init script
/sbin/service ntpd stop  ##we use cron + our own init script
/sbin/chkconfig ntpdate off  ##RHEL-06-000265 
/sbin/service ntpdate stop  ##RHEL-06-000265
/sbin/chkconfig oddjobd off  ##RHEL-06-000266 
/sbin/service oddjobd stop  ##RHEL-06-000266
/sbin/chkconfig qpidd off  ##RHEL-06-000267 
/sbin/service qpidd stop  ##RHEL-06-000267
/sbin/chkconfig rdisc off  ##RHEL-06-000268 
/sbin/service rdisc stop  ##RHEL-06-000268
/sbin/chkconfig netconsole off  ##RHEL-06-000289 
/sbin/service netconsole stop  ##RHEL-06-000289
/sbin/chkconfig bluetooth off  ##RHEL-06-000331 
/sbin/service bluetooth stop  ##RHEL-06-000331
/sbin/chkconfig uucp off  ##GEN005280
/sbin/service uucp stop  ##GEN005280
/sbin/chkconfig gssftp off  #GEN004800  ##GEN000410  ##GEN005020  ##GEN004840  ##GEN004900  ##GEN004820
/sbin/service gssftp  stop  #GEN004800  ##GEN000410  ##GEN005020  ##GEN004840  ##GEN004900  ##GEN004820
/sbin/chkconfig vsftpd off  #GEN004800  ##GEN000410  ##GEN005020  ##GEN004840  ##GEN004900  ##GEN004820  ##RHEL-06-000348  ##RHEL-06-000339
/sbin/service vsftpd  stop  #GEN004800  ##GEN000410  ##GEN005020  ##GEN004840  ##GEN004900  ##GEN004820


##fix auditd init.d dep issues by forcing it to be the last to start and the 1st to stop

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



exit 0


