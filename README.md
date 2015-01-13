# njann - Not Just Another Names Normalizer.

Script de GNU/Linux para la normalización de nombres de ficheros.

## Info consultada para crear el RPM.

- http://www.ibiblio.org/pub/linux/docs/howto/other-formats/html_single/RPM-HOWTO.html
- http://fedoraproject.org/wiki/RPMGroups
- http://meinit.nl/making-rpm-shell-script -> Fuente principal.

## Pasos para generar el paquete.

1. Comprimir la carpeta rpmbuild/SOURCES/njann-1.1/, generando el comprimido njann-1.1.tar.gz.
2. Situarse en el directorio rpmbuild.
3. Crear RPM: rpmbuild -v -bb --clean SPECS/sfs-1.0.0-1.spec
4. Si todo va bien, el RPM se generarará en RPMS/noarch

## Pasos para instalar el paquete.

- En Debian/Ubuntu: sudo alien -i --scripts <ruta_paquete>
- En CentOS: sudo yum localinstall <ruta_paquete>

## Posibles mejoras

- La construcción del paquete da error si la ruta hasta esta carpeta contiene
  espacios. Para solventarlo se ha intentado sustituir la línea 

	%define _topdir %(echo $PWD)/

  por

	%define _topdir %(echo ${PWD//" "/"\ "})/

  pero no funciona.

- Si se construye este paquete desde una ruta que no sea HOME, se genera una 
carpeta "rpmbuild" con subcarpetas BUILD, BUILDROOT, etc vacías en HOME.

## Localización del script

- Si únicamente se desea obtener el script (sin generar/instalar el RPM), el código del mismo se encuentra en rpmbuild/SOURCES/njann-1.1/njann.sh
