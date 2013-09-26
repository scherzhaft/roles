#!/bin/bash

rm -f /etc/yum.repos.d/sysupdate.repo.?*
yumreposd=`ls -d /etc/yum.repos.d/* 2>/dev/null`


if [ "X${yumreposd}" != "X" ] ; then
  cp ${yumreposd} "${SPOOL}"
fi

