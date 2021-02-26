#!/bin/bash
echo ----openssl-1.1.1j--2021-02-16--by cnrock------
set -e
set -v
if [[ ! -f "/root/openssl-1.1.1j.tar.gz" ]];then
  wget -O /root/openssl-1.1.1j.tar.gz https://www.openssl.org/source/openssl-1.1.1j.tar.gz
fi
mkdir ~/openssl && cd ~/openssl
yum -y install \
    curl \
    which \
    make \
    gcc \
    perl \
    perl-WWW-Curl \
    rpm-build
# Get openssl tarball
if [[ ! -f "./openssl-1.1.1j.tar.gz" ]];then
  cp /root/openssl-1.1.1j.tar.gz ./
fi

# SPEC file
cat << 'EOF' > ~/openssl/openssl.spec
Summary: OpenSSL 1.1.1j for Centos by cnrock
Name: openssl
Version: %{?version}%{!?version:1.1.1j}
Release: 1%{?dist}
Obsoletes: %{name} <= %{version}
Provides: %{name} = %{version}
URL: https://www.openssl.org/
License: GPLv2+

Source: https://www.openssl.org/source/%{name}-%{version}.tar.gz

BuildRequires: make gcc perl perl-WWW-Curl
BuildRoot: %{_tmppath}/%{name}-%{version}-%{release}-root
%global openssldir /usr/local/openssl

%description
OpenSSL RPM for version 1.1.1j on Centos

%package devel
Summary: Development files for programs which will use the openssl library
Group: Development/Libraries
Requires: %{name} = %{version}-%{release}

%description devel
OpenSSL RPM for version 1.1.1j on Centos (development package)

%prep
%setup -q

%build
./config --prefix=%{openssldir} --openssldir=%{openssldir}
make

%install
[ "%{buildroot}" != "/" ] && %{__rm} -rf %{buildroot}
%make_install

mkdir -p %{buildroot}%{_bindir}
mkdir -p %{buildroot}%{_libdir}
ln -sf %{openssldir}/lib/libssl.so.1.1 %{buildroot}%{_libdir}
ln -sf %{openssldir}/lib/libcrypto.so.1.1 %{buildroot}%{_libdir}
ln -sf %{openssldir}/bin/openssl %{buildroot}%{_bindir}

%clean
[ "%{buildroot}" != "/" ] && %{__rm} -rf %{buildroot}

%files
%{openssldir}
%defattr(-,root,root)
/usr/bin/openssl
/usr/lib64/libcrypto.so.1.1
/usr/lib64/libssl.so.1.1

%files devel
%{openssldir}/include/*
%defattr(-,root,root)

%post -p /sbin/ldconfig

%postun -p /sbin/ldconfig
EOF

mkdir -p /root/rpmbuild/{BUILD,RPMS,SOURCES,SPECS,SRPMS}
cp ~/openssl/openssl.spec /root/rpmbuild/SPECS/openssl.spec

mv openssl-1.1.1j.tar.gz /root/rpmbuild/SOURCES
cd /root/rpmbuild/SPECS && \
    rpmbuild \
    -D "version 1.1.1j" \
    -ba openssl.spec

# Before Uninstall  Openssl :   rpm -qa openssl
# Uninstall Current Openssl Vesion : yum -y remove openssl
# For install:  rpm -ivvh /root/rpmbuild/RPMS/x86_64/openssl-1.1.1j-1.el7.x86_64.rpm --nodeps
# or rpm -Uvh openssl-1.1.1j-1.el7.x86_64.rpm --nodeps --force
# Verify install:  rpm -qa openssl
#                  openssl version
