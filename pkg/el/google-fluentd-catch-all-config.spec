Summary: Catch-all configuration files for google-fluentd on GCE.
Name: google-fluentd-catch-all-config
Version: %{package_version}
Release: %{package_build_num}%{?dist}
License: ASL 2.0
Group: System Environment/Daemons
URL: https://cloud.google.com/logging/
Requires: google-fluentd >= 1.3.0
BuildArch: noarch
BuildRoot: %{_tmppath}/%{name}-%{version}-%{release}-root

%description
A set of configuration files for google-fluentd used to ingest logs
from the system and third-party application packages.

%files
%dir /etc/google-fluentd
%config(noreplace) /etc/google-fluentd
%dir /var/lib/google-fluentd/pos

%clean
# don't clean up the files here; we'll do it in the toplevel Makefile
