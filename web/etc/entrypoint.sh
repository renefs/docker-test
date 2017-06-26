#!/bin/bash
export APP_HOME=${APP_HOME:-/opt/app-root}
# Setup nss_wrapper so the random user OpenShift will run this container
# has an entry in /etc/passwd.
# This is needed for to avoid a problem that happened with the guid() running Python
# https://gitlab.cern.ch/ci-tools/ci-worker/blob/master/ci-base/contrib/openshift/run-jnlp-client
#
USER_ID=$(id -u)
GROUP_ID=$(id -g)
# Pointless if running as root
if [[ "${USER_ID}" != '0' ]]; then
  export NSS_WRAPPER_PASSWD=${APP_HOME}/nss_passwd
  export NSS_WRAPPER_GROUP=${APP_HOME}/nss_group
  cp /etc/passwd $NSS_WRAPPER_PASSWD
  cp /etc/group  $NSS_WRAPPER_GROUP
  if ! getent passwd "${USER_ID}" >/dev/null; then
     # we need an entry in passwd for current user. Make sure there is no conflict
     sed -e '/^app-user:/d' -i $NSS_WRAPPER_PASSWD
     echo "app-user:x:${USER_ID}:${GROUP_ID}:users:${APP_HOME}:/sbin/nologin" >> $NSS_WRAPPER_PASSWD
  fi
  # kubernetes plugin 0.9 mounts by default am emptyDir volume in $APP_HOME,
  # and users may mount a persistent volume in some cases.
  # Openshift then uses fsGroup to grant permission on that volume (when unshared) or
  # supplemental groups for shared storage.
  # Tools like rpmbuild may fail if a file's group is not valid, so we need to add each supplemental
  # group to the NSS_WRAPPER_GROUP.
  for groupid in $(id -G); do
    if ! getent group "${groupid}" > /dev/null; then
      # we need an entry in group file. Make sure there is no conflict
      groupname="suppgroup${groupid}"
      sed -e "/^${groupname}:/d" -i  $NSS_WRAPPER_GROUP
      echo "${groupname}:x:${groupid}:" >> $NSS_WRAPPER_GROUP
    fi
  done
  export LD_PRELOAD=libnss_wrapper.so
fi
# Make sure the Java clients have valid $HOME directory set
export HOME=${APP_HOME}
set -e
# We enable the Python environment to have all our installed packages
#. /opt/app-root/venv/bin/activate
echo 'Starting app...'
# Running the application directly would work, but is better using uwsgi
# python main.py
# We run the application using uwsgi
cp -rf /opt/app-root/app-temp/* /opt/app-root/app
uwsgi --ini /opt/app-root/etc/uwsgi.ini
