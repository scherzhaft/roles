#!/bin/bash -x


. /etc/default/SYSconstants || exit 15
/usr/sfw/bin/gtar --version || repo install.SUNWgtar
/usr/sfw/bin/gtar --version || exit 17


/usr/sfw/bin/ggrep -V || repo install.SUNWggrp
/usr/sfw/bin/ggrep -V || exit 18


FIX="${*}"
test "X${FIX}" = "X" && FIX='/etc/mail'
sleep 1
TSTAMP=`__getepoc`
SELF=`basename $0`
test "X${FIX}" != "X" && EXIST=`ls -d ${FIX}`

test "X${SELF}" = "X" -o "X${TSTAMP}" = "X" -o "X${EXIST}" = "X" && exit 20

cd /etc || exit 21
/usr/sfw/bin/gtar czpvf "mail.${SELF}.${TSTAMP}.tar.gz" mail || exit 22
/usr/sbin/slack-get sendmail-solaris  ##GEN004710  ##GEN004580  ##GEN004540  ##GEN002730  

/usr/sfw/bin/gtar zxpvf "mail.${SELF}.${TSTAMP}.tar.gz" mail/aliases  || exit 23


echo > /etc/mail/helpfile  #GEN004540
chgrp smmsp /etc/mail/aliases.db  #GEN004370
chgrp root /etc/mail/aliases  #GEN004410
chmod A- /etc/mail/aliases /etc/mail/aliases.db  #GEN004390  #GEN004430
chmod 0644 /etc/mail/aliases /etc/mail/aliases.db  #GEN004380
perl -p -i -e "s|^([\s]*decode:)|#\1|g" /etc/mail/aliases ; perl -p -i -e "s|^([\s]*uudecode:)|#\1|g" /etc/mail/aliases ; /usr/sbin/newaliases ##GEN004640


perl -p -e "s|#.*||g" /etc/mail/aliases|awk {'print $1" "$2'}|grep "^audit_warn: root$" || {  ##GEN002730
  perl -p -i -e "s|^[\s]*audit_warn:.*$|audit_warn: root|g"  /etc/mail/aliases
  grep "^audit_warn: root$"   /etc/mail/aliases  || echo "audit_warn: root" >> /etc/mail/aliases
  /usr/sbin/newaliases
}


rootalias=`perl -p -e "s|#.*||g" /etc/mail/aliases|perl -p -e "s|^[\s]+||g"|grep "^root:"|perl -p -e "s|^root:||g"|perl -p -e "s|[\,\s]+|\n|g"|grep '.'`
rootalias=`printf "${rootalias}\nfoo@foo.foo.foo\n"|sort -u|grep '.'`
rootalias=`echo "${rootalias}"|perl -p -e "s|\n|,|g"|perl -p -e "s|,$|\n|g"|perl -p -e 's|\@|\\\\@|g'`

perl -p -i.${SELF}.${TSTAMP} -e "s|[\s]*root:.*$|root:   ${rootalias}|g"  /etc/mail/aliases
grep "^root:   ${rootalias}$" /etc/mail/aliases || {
  echo "root:   ${rootalias}"|perl -p -e 's|\\||g' >> /etc/mail/aliases
}
/usr/sbin/newaliases


sleep 1
TSTAMP=`__getepoc`
adminalias=`perl -p -e "s|#.*||g" /etc/mail/aliases|perl -p -e "s|^[\s]+||g"|grep "^admin:"|perl -p -e "s|^admin:||g"|perl -p -e "s|[\,\s]+|\n|g"|grep '.'`
adminalias=`printf "${adminalias}\nfoo@foo.foo.foo\n"|sort -u|grep '.'`
adminalias=`echo "${adminalias}"|perl -p -e "s|\n|,|g"|perl -p -e "s|,$|\n|g"|perl -p -e 's|\@|\\\\@|g'`

perl -p -i.${SELF}.${TSTAMP} -e "s|[\s]*admin:.*$|admin:   ${adminalias}|g"  /etc/mail/aliases
grep "^admin:   ${adminalias}$" /etc/mail/aliases || {
  echo "admin:   ${adminalias}"|perl -p -e 's|\\||g' >> /etc/mail/aliases
}
/usr/sbin/newaliases


sleep 1
TSTAMP=`__getepoc`
postalias=`perl -p -e "s|#.*||g" /etc/mail/aliases|perl -p -e "s|^[\s]+||g"|grep "^postmaster:"|perl -p -e "s|^postmaster:||g"|perl -p -e "s|[\,\s]+|\n|g"|grep '.'`
postalias=`printf "${postalias}\nfoo@foo.foo.foo\n"|sort -u|grep '.'`
postalias=`echo "${postalias}"|perl -p -e "s|\n|,|g"|perl -p -e "s|,$|\n|g"|perl -p -e 's|\@|\\\\@|g'`

perl -p -i.${SELF}.${TSTAMP} -e "s|[\s]*postmaster:.*$|postmaster:   ${postalias}|g"  /etc/mail/aliases
grep "^postmaster:   ${postalias}$" /etc/mail/aliases || {
  echo "postmaster:   ${postalias}"|perl -p -e 's|\\||g' >> /etc/mail/aliases
}
/usr/sbin/newaliases




##GEN004500 ##GEN004510 ##GEN004480 taken care of in log-solaris slackrole
