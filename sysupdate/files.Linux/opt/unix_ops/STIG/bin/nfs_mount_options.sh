#!/bin/bash -x


##RHEL-06-000269  RHEL-06-000270

mount|grep nfs
echo "oracle needs suid dev"

##RHEL-06-000271

grep noexec /etc/fstab
echo "vm's don't have removable media"

