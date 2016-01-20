Name:           checkmate
Version:        2.3.5
Release:        1%{?dist}
Summary:        Checksum generator and validator

License:        LGPL
URL:            http://kalebklein.com/portfolio/post/checkmate
Source0:        %{name}-%{version}.tar.gz

BuildRequires:  qt5-qtbase-devel,gcc-c++
Requires:       qt5-qtbase

%description
Generates checksums and validates them. Supports MD5, SHA1, and SHA256

%prep
%setup -q


%build
make %{?_smp_mflags}


%install
rm -rf $RPM_BUILD_ROOT
mkdir -p %{buildroot}%{_bindir}
mkdir -p %{buildroot}/opt/checkmate
mkdir -p %{buildroot}%{_datadir}/applications
mkdir -p %{buildroot}%{_datadir}/icons

install -m 777 %{_builddir}/checkmate-%{version}/src/Checkmate %{buildroot}%{_bindir}/checkmate
install -m 777 %{_builddir}/checkmate-%{version}/src/Checkmate %{buildroot}/opt/checkmate/Checkmate
install -m 777 %{_builddir}/checkmate-%{version}/src/res/images/gear.png %{buildroot}%{_datadir}/icons/checkmate_icon.png
install -m 777 %{_builddir}/checkmate-%{version}/checkmate.desktop %{buildroot}%{_datadir}/applications/checkmate.desktop

%files
%doc
/usr/bin/checkmate
/opt/checkmate/Checkmate
/usr/share/icons/checkmate_icon.png
/usr/share/applications/checkmate.desktop

%changelog
* Wed Jan 20 2016 Kaleb Klein <klein.jae@gmail.com> 2.3.5
- New MessageBox system and separated linux from windows update server
* Fri Jan 15 2016 Kaleb Klein <klein.jae@gmail.com> 2.3.3
- New stylesheet
* Sat Nov 14 2015 Kaleb Klein <klein.jae@gmail.com> 2.3-1
- Initial package for RPM
