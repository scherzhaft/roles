#!/bin/sh
#
# rep_populate.sh
#
# Updated: 12/29/2008

# Command paths
UP2DATE=/usr/sbin/up2date
CREATEREPO=/usr/bin/createrepo
YUMARCH=/usr/bin/yum-arch

# yum repository paths
REP_BASE=/sysbuild/kickstart/updates/yum
REP_OEL=EnterpriseLinux
REP_OVM=OracleVM
REP_UNK=unknown

# Maximum number of packages to download at once
MAXPKG=1000

# The script has the option to be able to download the src rpms alongside
# the binary rpms.  The default, however is to NOT download them.  So, set the
# default and then check if the user asked for the src rpms.
SRC=--nosrc
if [ $# -eq 1 ] ; then
  if [ "$1" = "src" ] ; then
    SRC=--src
  else
    echo "$0: unknown argument \"$1\""
    echo "usage: $0 [src]"
    exit 1
  fi
fi

# Identify what OS the script is running on.
# If the OS is EL or RHEL, save version and arch info.
if rpm -q redhat-release >/dev/null 2>&1 || rpm -q enterprise-release >/dev/null 2>&1
then
  EL_VER="el`rpm -qf /etc/redhat-release --qf '%{VERSION}' | sed 's/[^0-9]*//g'`"
  EL_ARCH=`uname -i`
else
  echo "Error: script must be run on Enterprise Linux OS"
  exit 1
fi

# Install uln-yum-proxy if missing.
# This installs packages required to create yum repositories.
rpm -q uln-yum-proxy >/dev/null 2>&1 || \
 ${UP2DATE} -i uln-yum-proxy --channel ${EL_VER}_${EL_ARCH}_addons --channel ${EL_VER}_${EL_ARCH}_latest

# If uln-yum-proxy did not get installed, abort.
if ! rpm -q uln-yum-proxy >/dev/null 2>&1
then
  echo "Error installing uln-yum-proxy... aborting."
  exit 1
fi

for CHANNEL in `${UP2DATE} --show-channels | sort` ;do
  # convert the channel label into a path suitable for our yum conventions
  DIR=`echo $CHANNEL | sed 's/x86_64/x86-64/g' |
  sed 's/_u\([0-9][0-9]*\)_/_\1_/' | awk -F _ '{ printf("%s/", toupper($1)); \
   count=1; while (++count<NF) \
   {if(count==NF-1) {print $(count+1)"/"$(count)} else \
   {printf("%s/", $(count))}}}' | sed 's/x86-64/x86_64/g'`

  # determine the correct yum repository directory
  REP_PATH=$REP_BASE/$REP_UNK/$DIR
  echo $CHANNEL | grep '^el[0-9]*_' >/dev/null 2>&1 && \
    REP_PATH=$REP_BASE/$REP_OEL/$DIR
  echo $CHANNEL | grep '^ovm[0-9]*_' >/dev/null 2>&1 && \
    REP_PATH=$REP_BASE/$REP_OVM/$DIR

  echo "$REP_PATH"

  # Create the required yum repository directory.
  # If directory creation failed, print error and exit.
  mkdir -p $REP_PATH
  if [ ! -d $REP_PATH ] ; then
    echo "There was an error creating $REP_BASE."
    echo "Please check the permissions of the directory tree to ensure"
    echo "that this directory can be created and then re-run this script."
    exit 1
  fi

  cd $REP_PATH

  # Always set --nosrc for oracle channels, which has no src rpms
  GETSRC=$SRC
  echo $CHANNEL | grep '_oracle$' >/dev/null 2>&1 && GETSRC=--nosrc

  # download the rpms, $MAXPKG at a time
  ${UP2DATE} --showall --channel ${CHANNEL} | xargs -n $MAXPKG \
    ${UP2DATE} --nox --get ${GETSRC} --download --channel ${CHANNEL} --tmpdir=.

  # Clean up download dir.  Only keep rpms.
  find . -type f -not -name "*rpm" -exec rm -f {} \;

  # move src rpms to SRPMS directory
  if [ "${GETSRC}" = "--src" ] ; then
    mkdir -p SRPMS
    mv *.src.rpm SRPMS
  fi

  # run createrepo command if present
  which ${CREATEREPO} >/dev/null 2>&1
  if [ $? -eq 0 ] ; then
    ${CREATEREPO} $REP_PATH
  else
    echo "${CREATEREPO}: command not found"
  fi

  # run yum-arch command if present
  which ${YUMARCH} >/dev/null 2>&1
  if [ $? -eq 0 ] ; then
    if [ "${GETSRC}" = "--src" ] ; then
      ${YUMARCH} -s $REP_PATH
    else
      ${YUMARCH} $REP_PATH
    fi
  else
    echo "${YUMARCH}: command not found"
  fi
done

date +%m/%d/%y >"${REP_BASE}/.SyncDate"
