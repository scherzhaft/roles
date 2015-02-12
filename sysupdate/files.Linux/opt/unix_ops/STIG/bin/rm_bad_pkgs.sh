#!/bin/bash -x


##RHEL-06-000204  ##RHEL-06-000206  ##RHEL-06-000213  ##RHEL-06-000220  ##RHEL-06-000222  ##RHEL-06-000256  ##RHEL-06-000288  ##RHEL-06-000211  ##RHEL-06-000214  ##RHEL-06-000216  ##RHEL-06-000218  ##  ##GEN006080  ##RHEL-06-000272  ##RHEL-06-000273


. /etc/default/SYSconstants


DIRTYPKGS="telnet-server
samba*
sssd
cifs*
ipa-client
rsh-server
ypserv
tftp-server
openldap-servers"


rm_pkgs ${DIRTYPKGS}

test "X${__GNU_R}" = "X6" && rm_pkgs sendmail

exit 0


