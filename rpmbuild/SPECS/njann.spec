%define _topdir %(echo $PWD)/

Summary: njann - Normalizador de nombres de archivos
Name: njann
Version: 1.1
Release: 1
URL:     https://github.com/Neodivert/njann
License: GPL
Group: Applications/File
BuildRoot: %{_tmppath}/%{name}-root
Requires: bash
Requires(post): sudo
Requires(post): mandb
Requires(postun): sudo
Requires(postun): mandb
Source0: njann-%{version}.tar.gz
BuildArch: noarch

%description
Script que normaliza los nombres de los ficheros pasados por argumento

%prep
%setup 

%build


%install
rm -rf ${RPM_BUILD_ROOT}
mkdir -p ${RPM_BUILD_ROOT}/usr/bin
mkdir -p ${RPM_BUILD_ROOT}/usr/share/man/man1/
install -m 755 njann ${RPM_BUILD_ROOT}%{_bindir}
install -m 644 njann.1.gz ${RPM_BUILD_ROOT}/usr/share/man/man1/njann.1.gz

%clean
rm -rf ${RPM_BUILD_ROOT}

%post
sudo mandb
%postun 
sudo mandb

%files
%defattr(-,root,root)
%attr(755,root,root) %{_bindir}/njann
%doc
/usr/share/man/man1/njann.1.gz

%changelog
* Mon Mar 01 2013 njann team - 1.1-1
- Se ha actualizado la pagina de manual:
	- Ahora se especifica que el script puede tratar varios ficheros en una misma llamada.
	- Tambien se especifica que en caso de que al renombrar un fichero A, el nuevo nombre coincida con el de un fichero B, el fichero B es sobrescrito.
- Se ha insertado la orden "mandb" en la instalacion y la desinstalacion para actualizar la base de datos del whatis.
