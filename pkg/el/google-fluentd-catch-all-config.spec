Summary: Catch-all configuration files for google-fluentd on GCE.
Name: google-fluentd-catch-all-config
Version: 0.1
Release: 1%{?dist}
License: Apache
Group: System Environment/Daemons
URL: https://cloud.google.com/logging/
Requires: google-fluentd

%description
A set of configuration files for google-fluentd used to ingest logs
from the system and third-party application packages.

%files
%config /etc/google-fluentd

%clean
# don't clean up the files here; we'll do it in the toplevel Makefile

# post-install/un-install scripts to handle diverting google-fluentd.conf
%triggerin -- google-fluentd
if [ ! -h /etc/google-fluentd/google-fluentd.conf -o ! "`readlink /etc/google-fluentd/google-fluentd.conf`" = "/etc/google-fluentd/google-fluentd.conf.google" ] ; then
  if [ -e /etc/google-fluentd/google-fluentd.conf ] ; then
    mv -f /etc/google-fluentd/google-fluentd.conf /etc/google-fluentd/google-fluentd.conf.orig
  fi
  ln -s /etc/google-fluentd/google-fluentd.conf.google /etc/google-fluentd/google-fluentd.conf
fi

%triggerun -- ntp
if [ $1 -eq 0 -a $2 -gt 0 -a -e /etc/google-fluentd/google-fluentd.conf.orig ] ; then
  mv -f /etc/google-fluentd/google-fluentd.conf.orig /etc/google-fluentd/google-fluentd.conf
fi

%triggerpostun -- ntp
if [ $2 -eq 0 ] ; then
  rm -f /etc/google-fluentd/google-fluentd.conf.rpmsave /etc/google-fluentd/google-fluentd.conf.orig
fi
if [ -e /etc/google-fluentd/google-fluentd.conf.rpmnew ] ; then
   mv /etc/google-fluentd/google-fluentd.conf.rpmnew /etc/google-fluentd/google-fluentd.conf.orig
fi
