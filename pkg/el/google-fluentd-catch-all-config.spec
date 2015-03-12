Summary: Catch-all configuration files for google-fluentd on GCE.
Name: google-fluentd-catch-all-config
Version: 0.1
Release: 1%{?dist}
License: ASL 2.0
Group: System Environment/Daemons
URL: https://cloud.google.com/logging/
Requires: google-fluentd
BuildArch: noarch
BuildRoot: %{_tmppath}/%{name}-%{version}-%{release}-root

%description
A set of configuration files for google-fluentd used to ingest logs
from the system and third-party application packages.

%files
%dir /etc/google-fluentd
%config(noreplace) /etc/google-fluentd

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

%triggerun -- google-fluentd
if [ $1 -eq 0 -a $2 -gt 0 -a -e /etc/google-fluentd/google-fluentd.conf.orig ] ; then
  mv -f /etc/google-fluentd/google-fluentd.conf.orig /etc/google-fluentd/google-fluentd.conf
fi

%triggerpostun -- google-fluentd
if [ $2 -eq 0 ] ; then
  rm -f /etc/google-fluentd/google-fluentd.conf.rpmsave /etc/google-fluentd/google-fluentd.conf.orig
fi
if [ -e /etc/google-fluentd/google-fluentd.conf.rpmnew ] ; then
   mv /etc/google-fluentd/google-fluentd.conf.rpmnew /etc/google-fluentd/google-fluentd.conf.orig
fi
