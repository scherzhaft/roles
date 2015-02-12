#!/bin/bash -x



chown root /etc/gshadow  ##RHEL-06-000036
chgrp root /etc/gshadow  ##RHEL-06-000037
chmod 0000 /etc/gshadow  ##RHEL-06-000038
chown root /etc/passwd  ##RHEL-06-000039  ##GEN001378
chgrp root /etc/passwd  ##RHEL-06-000040  ##GEN001379
chmod 0644 /etc/passwd  ##RHEL-06-000041 ##GEN001380
chown root /etc/group  ##RHEL-06-000042  ##GEN001391
chgrp root /etc/group  ##RHEL-06-000043  ##GEN001392
chmod 644 /etc/group  ##RHEL-06-000044    ##GEN001393
chown root /etc/shadow  ##RHEL-06-000033  ##GEN001400
chgrp root /etc/shadow  ##RHEL-06-000034  ##GEN001410
chmod 0000 /etc/shadow  ##RHEL-06-000035  ##GEN001420
chown root /etc/grub.conf  ##RHEL-06-000065  ##GEN008760
chgrp root /etc/grub.conf  ##RHEL-06-000066  ##GEN008780
chmod 600 /etc/grub.conf  ##RHEL-06-000067  ##GEN008720



exit 0


