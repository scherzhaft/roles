#!/bin/bash -x


##RHEL-06-000011  ##RHEL-06-000519  ##RHEL-06-000518  ##RHEL-06-000517  ##RHEL-06-000516  ##RHEL-06-000138  ##RHEL-06-000321



/usr/bin/yum check-update
test -f /bin/rpm  || echo "...rpm not found ..."
/usr/bin/yum -y install logrotate  openswan

exit 0


