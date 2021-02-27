Summary:    A sophisticated file transfer program
Name:        lftp
Version:    4.9.2
Release:    3%{?dist}
License:    GPLv3+
Group:        Applications/Internet
Source0:    ftp://ftp.yar.ru/lftp/lftp-%{version}.tar.gz
URL:        http://lftp.yar.ru/
BuildRoot:    %{_tmppath}/%{name}-%{version}-%{release}-root-%(%{__id_u} -n)
BuildRequires:    ncurses-devel, gnutls-devel, pkgconfig, readline-devel, gettext
%description
LFTP is a sophisticated ftp/http file transfer program. Like bash, it has job
control and uses the readline library for input. It has bookmarks, built-in
mirroring, and can transfer several files in parallel. It is designed with
reliability in mind.
%package scripts
Summary:    Scripts for lftp modified by cnrock
Group:        Applications/Internet
Requires:    lftp >= %{version}-%{release}
BuildArch:    noarch
%description scripts
Utility scripts for use with lftp.
%prep
%setup -q
#sed -i.rpath -e '/lftp_cv_openssl/s|-R.*lib||' configure
sed -i.norpath -e \
   '/sys_lib_dlsearch_path_spec/s|/usr/lib |/usr/lib /usr/lib64 /lib64 |' \
   configure
%build
%configure --with-modules --disable-static --with-gnutls --with-openssl --with-debug
make %{?_smp_mflags}
%install
rm -rf $RPM_BUILD_ROOT
export tagname=CC
make DESTDIR=$RPM_BUILD_ROOT INSTALL='install -p' install
chmod 0755 $RPM_BUILD_ROOT%{_libdir}/lftp/*
chmod 0755 $RPM_BUILD_ROOT%{_libdir}/lftp/%{version}/*.so
iconv -f ISO88591 -t UTF8 NEWS -o NEWS.tmp
touch -c -r NEWS NEWS.tmp
mv NEWS.tmp NEWS
# Remove files from $RPM_BUILD_ROOT that we aren't shipping.
#rm $RPM_BUILD_ROOT%{_libdir}/lftp/%{version}/*.la
rm $RPM_BUILD_ROOT%{_libdir}/liblftp-jobs.la
rm $RPM_BUILD_ROOT%{_libdir}/liblftp-tasks.la
rm $RPM_BUILD_ROOT%{_libdir}/liblftp-jobs.so
rm $RPM_BUILD_ROOT%{_libdir}/liblftp-tasks.so
rm $RPM_BUILD_ROOT%{_prefix}/share/applications/lftp.desktop
rm $RPM_BUILD_ROOT%{_prefix}/share/icons/hicolor/48x48/apps/lftp-icon.png
%find_lang %{name}
%clean
rm -rf $RPM_BUILD_ROOT
%post -p /sbin/ldconfig
%postun -p /sbin/ldconfig
%files -f %{name}.lang
%defattr(-,root,root,-)
%doc BUGS COPYING ChangeLog FAQ FEATURES README* NEWS THANKS TODO
%config(noreplace) %{_sysconfdir}/lftp.conf
%{_bindir}/*
%{_mandir}/*/*
%dir %{_libdir}/lftp
%dir %{_libdir}/lftp/%{version}
%{_libdir}/lftp/%{version}/cmd-torrent.so
%{_libdir}/lftp/%{version}/cmd-mirror.so
%{_libdir}/lftp/%{version}/cmd-sleep.so
%{_libdir}/lftp/%{version}/liblftp-network.so
%{_libdir}/lftp/%{version}/liblftp-pty.so
%{_libdir}/lftp/%{version}/proto-file.so
%{_libdir}/lftp/%{version}/proto-fish.so
%{_libdir}/lftp/%{version}/proto-ftp.so
%{_libdir}/lftp/%{version}/proto-http.so
%{_libdir}/lftp/%{version}/proto-sftp.so
%{_libdir}/liblftp-jobs.so.*
%{_libdir}/liblftp-tasks.so.*
%files scripts
%defattr(-,root,root,-)
%{_datadir}/lftp
#rpmbuild -ba lftp.spec
